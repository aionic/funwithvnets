@description('Prefix for the resource names.')
param prefix string = 'funwithvnets'

@description('Location for the resources.')
param location string = resourceGroup().location

@description('Address space for VNet1.')
param vnet1AddressSpace string = '10.100.0.0/22'

@description('Address space for VNet2.')
param vnet2AddressSpace string = '10.200.0.0/22'

@description('Subnet name for VNet1.')
param vnet1SubnetName string = 'subnet1'

@description('Subnet address prefix for VNet1.')
param vnet1SubnetPrefix string = '10.100.0.0/24'

@description('Subnet name for VNet2.')
param vnet2SubnetName string = 'subnet2'

@description('Subnet address prefix for VNet2.')
param vnet2SubnetPrefix string = '10.200.0.0/24'

var uniqueStringSuffix = uniqueString(resourceGroup().id)

resource vnet1 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: '${prefix}-vnet1-${uniqueStringSuffix}'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnet1AddressSpace
      ]
    }
    subnets: [
      {
        name: vnet1SubnetName
        properties: {
          addressPrefix: vnet1SubnetPrefix
        }
      }
    ]
  }
}

resource vnet2 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: '${prefix}-vnet2-${uniqueStringSuffix}'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnet2AddressSpace
      ]
    }
    subnets: [
      {
        name: vnet2SubnetName
        properties: {
          addressPrefix: vnet2SubnetPrefix
        }
      }
    ]
  }
}

resource vnet1Peering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-05-01' = {
  name: '${prefix}-vnet1-to-vnet2-peering-${uniqueStringSuffix}'
  parent: vnet1
  properties: {
    remoteVirtualNetwork: {
      id: vnet2.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
  }
}

resource vnet2Peering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-05-01' = {
  name: '${prefix}-vnet2-to-vnet1-peering-${uniqueStringSuffix}'
  parent: vnet2
  properties: {
    remoteVirtualNetwork: {
      id: vnet1.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
  }
}
