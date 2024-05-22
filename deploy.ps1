## QD Deployment + Peer tweak and tear down of Enviroment

az login
$sub = '' #set your subscription id here
$location = 'eastus'
$rg = 'funwithvnets'+ (Get-Random -Minimum 10 -Maximum 99)

az login
az account set --subscription $sub
az group create --location $location --name $rg #Create Resource Group
az deployment group create --resource-group $rg --template-file .\CreateVNETs.bicep #Deploy VNETs (good idea to whatify the bicep file)
$vnet1 = (az network vnet list --resource-group $rg --query "[?contains(name, 'vnet1')].name" --output tsv)
$vnet2 = (az network vnet list --resource-group $rg --query "[?contains(name, 'vnet2')].name" --output tsv)
az network vnet peering list --resource-group $rg --vnet-name $vnet1 --output table #check peering should be in sync
az network vnet update --address-prefixes 10.200.0.0/21 --name $vnet2 --resource-group $rg #assumes you didn't change the address prefix in the bicep file
az network vnet peering list --resource-group $rg --vnet-name $vnet1 --output table #check peering localnotinsync
az network vnet peering list --resource-group $rg --vnet-name $vnet2 --output table #check peering remotenotinsync

# Magic Powershell Fix to be built by William X


# Tear Down
az group delete --name $rg --yes --no-wait #Delete Resource Group

