scripts:

create resource-group for storage
az group create --name bd-storage-rg --location australiaeast

//storage account for backend 
az storage account create -n terraformstatexdfes -g bd-storage-rg -l  australiaeast

//storage container 
az storage container  create -n terraformstatefiles  --account-name terraformstatexdfes