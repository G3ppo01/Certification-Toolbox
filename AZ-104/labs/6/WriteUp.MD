# Lab 00 - Template
## Intro
In this lab you learn to create storage accounts for Azure blobs and Azure files. You learn to configure and secure blob containers. You also learn to use Storage Browser to configure and secure Azure file shares.
## Scenario
Your organization is currently storing data in on-premises data stores. Most of these files are not accessed frequently. You would like to minimize the cost of storage by placing infrequently accessed files in lower-priced storage tiers. You also plan to explore different protection mechanisms that Azure Storage offers, including network access, authentication, authorization, and replication. Finally, you want to determine to what extent Azure Files is suitable for hosting your on-premises file shares.
## Tasks
- Task 1: Create and configure a storage account.
- Task 2: Create and configure secure blob storage.
- Task 3: Create and configure secure Azure file storage.

## Write up
### Task 1: Create and configure a storage account
#### GUI
- Create a new storage account in the storage account service with the following parameters:

| Setting | Value |
| --- | --- |
|Subscription | the name of your Azure subscription|
|Resource group | az104-rg7 (create new)|
|Storage account name | az104lab07storageaccount|
|Region | (US) East US|
|Performance | Standard (notice the Premium option)|
|Preferred storage type | Azure Blob Storage or Azure Data Lake Storage|
|Redundancy | Geo-redundant storage (notice the other options)|
|Make read access to data available in the event of regional unavailability. | Check the box|

- Enable access from selected public networks --> Whitelised my public IP
- Created a lifecycle management rule:
    - Data Management Blade --> Lifecycle Management --> Add a rule
    - *If base blobs were last modified more than 30 days ago then Move to cool storage*

### Task 2: 
