# Azure Database Migration

### Table of Contents
---
1. Project Description
2. Production Environment: Set Up
 - Virtual Machine
 - Server
 - Database
 - Firewall
 - Installation Instructions
 - SQL Server Developer
 - SQL Server Management Studio
 - Usage Instructions: Connect to Database
 - Restore AdventureWorks Database
3. Migration to Azure SQL Database
 - Migration Installation Instructions
 - Azure Data Studio
 - Azure SQL Migration
 - Migration: Steps
 - Database Inspection
 - File Structure
 - Azure Blob Storage
4. Data Backup and Restrore
 - Sandbox
 - Sandbox Set Up
 - Restoring Backup Database onto DUP-ADM
 - Inspect Restored Backup Database Data
 - Automate Database Backups
 - Steps
5. Disaster Recovery Simulation
 - Restore Database via Azure SQL Database Backup
 - Validate Restoration 
6. Geo-Replication and Failover 
 - Steps
 - Failover 
 - Steps
 - Tailback 
7.  Microsoft Entra Directory Integration
 - Connect using Microsoft Entra ID
 - DB Reader User 
8.  Azure Database Migration: Project Diagram
9. License Information
---



### 1. Project Description
---
This project is a simulated database migration for a manufacturing company's operations using Microsoft Azure.
Database: AdventureWorks | [Database Download Link](https://aicore-portal-public-prod-307050600709.s3.eu-west-1.amazonaws.com/project-files/93dd5a0c-212d-48eb-ad51-df521a9b4e9c/AdventureWorks2022.bak)



### 2. Production Environment: Set Up
---  
Ensure you have a Mircosoft Azure account with an appropriate subscription. 




#### Virtual Machine
---
Create a Virtual Machine by navigating to the relevent Azure service.



Resource Group: Create new as this can be modified later 



Name: **ADM**



Region: **UK South** (ensure that you select the one closest to your location) 



Image: **Windows 11 Pro, version 22H2 - x64 Gen2**



Size: **Standard_D2s_v3** (This was recommended but can be modified by selecting a different size)



Set up your Administrator Account username and password - you will need this to connect to ADM so ensure you keep these credentials safe. 



Inbound Port Rules: select **Allow selected ports** -> **RDP (3389)**



Licensing: check the confirmation statment then **Review + create**



Once this resoure has been deployed, navigate to it and on the Overview page click on the **Connect** tab in the top-bar and download the RDP file found here; you will use this to connect to this VM.




#### Server
---
Create an SQL Server by navigating to the relevent Azure service.



Complete the required fields as you did for the creation of the VM. However, in addition, use your preferred choice of Authentication; for this project, **Use Microsoft Entra-only authentication** was selected and an admin was set but clicking on **Set Admin**. Then click on **Review + create** to deploy this resource. 




#### Database
---
Create an SQL Database by navigating to the relevent Azure service.


Complete the required fields as you did for the creation of the Server and be sure to select this Server in the appropriate field. Select **Geo-redundant backup storage** for **Backup storage redundancy** - this will allow for geo-replication later on. Leave all other options as default. Then click on **Review + create** to deploy this resource. 




#### Firewall
---
Navigate to the Overview page of the server and click on **Show networking settings** to add a new firewall rule which allows access to the database on ADM. Name the rule and paste the database IP address in both fields: **Start IP** and **End IP**. Access is now granted to your database. 



#### Installation Instructions
---

> [!NOTE]
> Ensure you are using your VM to complete the steps below.

Connect to your VM via Microsoft Remote Desktop by dragging and dropping the downloaded RDP file to this applicatiion, which will then launch your VM and ask you to sign in using your Authentication Account credentials.

Once you are on, download and install the following: 



#### SQL Server Developer
---
[Download Link](https://go.microsoft.com/fwlink/p/?linkid=2215158&clcid=0x809&culture=en-gb&country=gb)


#### SQL Server Management Studio
---
Once you have installed the above, there is a button to 'Install SSMS' so go ahead and click that to access the download link for SSMS. Make sure to install this as well.




#### Usage Instructions: Connect to Database
---
Launch SSMS to connect to the server with the following settings and using your Authentication Account credentials: 



Server Type: **Database Engine**



Server Name: **ADM** 



Authentication: **Windows Authentication**



#### Restore AdventureWorks Database
---
Download the backup file ([Download Link](https://aicore-portal-public-prod-307050600709.s3.eu-west-1.amazonaws.com/project-files/93dd5a0c-212d-48eb-ad51-df521a9b4e9c/AdventureWorks2022.bak)) and store in the following pathway: `C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\`




In SSMS, ensure you are connected to the server, in the **Object Explorer**, right-click on **Databases** -> **Restore Database...** -> on the **General** page, select **Device:** -> **...** -> **Add** to add the backup (.bak) file which you stored in the aforementioned pathway -> **OK** -> **OK**




You should receive a notification pop up to tell you that the restoration was successful. The AdventureWorks Database is now available in the Object Explorer under **Databases**.



### 3. Migration to Azure SQL Database
---
#### Migration Installation Instructions
---
Create another Azure SQL Server which will support a development database. Follow the steps above in the **[Server](#Server)** section. For the authentication method choose SQL Login instead this time - you will need this to confgure Azure Data Studio. 




Create the development Azure SQL Database on your Azure account to which you intend to migrate your ADM database to as this existing database is the on-premise, production database. You require one which will replicate this and can create it by following the steps in the **[Database](#Database)** section. Ensure to configure appropriate settings by following the **[Firewall](#Firewall)** rules section. 




#### Azure Data Studio
---
Install and configure Azure Data Studio on ADM (the VM you created at the beginning of this project) via [this link](https://docs.microsoft.com/en-us/sql/azure-data-studio/download-azure-data-studio). Be sure to select **Create Desktop Icon** when given the option for ease of access. 





Launch Azure Data Studio and establish a connection with your on-premise database:
 - Click on **New Connection** in the **Servers** tab on the left of the application.
 - Fill out the connection details (localhost as server name will provide all databases stored on the local server).
 - Authentication Type will remain as default: **Windows Authentication**.
 - The **AdventureWorks2022** database will then become available as a choice in the **Database** field.
 - Connect and when prompted with a **Connection Error**, click **Enable Trust server certificate**





Connect to the database you created in this section of the project, via Azure Data Studio by clicking on **New Connection** once again and filling in the connection details for this new database which will be used to migrate your local database to. This time select **SQL Login** as the **Autherntication Type** and use your SQL Login credentials from when you created this target server. Finally, click **Connect** to connect this development database to Azure Data Studio. If a **Connection Error** pops up, check that your Firewall rules are correctly configured for this server - specify ADM VM's IP Address. 




From the left-tabs of Azure Data Studio, select **Extensions** and install **Schema Compare**. Right-click on the database you would like to replicate - in this case, **localhost** and click **Schema Compare**. Ensure that the target database is your desired development database then click **OK**.




On the Schema Compare page in the main console, click on **Compare** and ensure the changes being made are accurately being synchronized - in this case, this applies to all changes. When prompted if you would like to update the target database with these changes, click **Yes**. Once this update has occurred you should be able to view all the tables from the local server, within this target database however they will not contain any data as just the schema has been updated to this database.




#### Azure SQL Migration
---
Now to ensure the data is inserted into these tables, install **Azure SQL Migration** from the **Extensions** tab to add it to your environment. Right-click on the local server's **AdventureWorks2022** database to select **Manage**. In the main console, click on the button: **Migrate to Azure SQL** which will open a Migration Wizard to select the dataebase whih you want to migrate (**AdventureWorks2022**).



#### Migration: Steps
---
- Complete each of the steps of the Migration Wizard and ensure you use the correct credentials relative to your target server in Step 3.
- Step 4: you will need to navigate to **Azure Database Migration Service** on your Azure account and create a new service with all the default settings, before you are able to move forward. Now, you will see an error message in the main console so you need to click on the download link and select the latest or desired version of **Azure Database Migration Service** and then run the downloaded file to install. Use one of the Keys provided in the main console of Azure Data Studio to **Register** Integration Runtime. Finally, click on **Launch Configuration Manager**.
- Click refresh or **Save + close** and re-open this migration ticket and you should be able to proceed to Step 5.
- Step 5: you will need your Windows Authentication credentials and ensure all tables are selected by clicking **Edit**, select as you desire and **Update**, if necessary. Click **Run Validation** then **Start Migration**
- Once the migration is complete and successful, you can view the table data in the target database. 



#### Database Inspection
---
> [!NOTE]
> This is an integral part of data migration to retain data intergrity and accuracy.



#### File Structure
---
These files contain matching SQL Queries which can be run by opening the files or opening a new query for each database. This ensures that the data matches and has not been lost or corrupted during the migration process: 




Local Server: localhost_validation_queries.sql




Target Server: migration_validation_queries.sql



#### Azure Blob Storage
---
- Create a **Storage Account** by navigating to the service on the Azure Portal - this is where you will store your database backup file as Blob storage, remotely.
- Create a container by accessing this Storage Account, selecting **Containers** in the left-panel under **Data Storage** and clicking on **+ Container** to be prompted for the container's name and **Anonymous access level** - *Ensure use of the most appropriate access level for your case*.
- Upload .bak file to the container by clicking on **Upload** in the desired container by dragging and dropping the file here before uploading.


### 4. Data Backup and Restore
---
> [!NOTE]
> The following section uses SSMS.


#### Sandbox
---
A sandbox is a controlled and isolated environment where applications and software can be tested, developed, and experimented with, all without impacting the production systems. To create this development environment, the Windows VM which is currently the **Production Environment**, with all of it's infrastructure, will be duplicated. The purpose of a sandbox allows you to work on the application, test new features, and troubleshoot issues in a safe and isolated environment before making changes in the production system.




#### Sandbox Set Up
---
- Provision a new **[Windows VM](#Virtual Machine)** named **DUP-ADM**
- Follow the **[Installation Instructions](#Installation Instructions)** to mimic the infrastructure of the **Production Environment**; ensure the following are downloaded and installed correctly:
   - SQL Server Developer 
   - SQL Server Management Studio (SSMS)




#### Restoring Backup Database onto DUP-ADM
---
- Download the Blob from your Azure Storage Account 
- Restore the AdventureWorks2022 database by following the instructions for **[Restore AdventureWorks Database](#Restore AdventureWorks Database)**
- Refresh the **Object Explorer** if you cannot view the restored database




#### Inspect Restored Backup Database Data
---
Run some queires to ensure data integrity. For example, you may wish to check the number of rows for some tables with the following syntax: 




`SELECT * FROM [table_name];`




#### Automate Database Backups
---
Configuring a weekly backup schedule ensures consistent protection for any evolving work and simplifies the recovery process of the development environment if and when necessary. 




#### Steps
---
Create your credentials for your server to ensure backups are stored to the correct and secure external location:
- Right-click on the Server you wish to backup (**DUP-ADM**) and select **New Query**
- Now input your correct credentials into the following syntax:
   - (Your **Access Key** is associated to your storage account on your Azure Portal under **Security + networking**)
   - **DO NOT SHARE YOUR ACCESS KEYS WITH ANYONE FOR SECURITY PURPOSES**




`CREATE CREDENTIAL [YourCredentialName]
WITH IDENTITY = '[Your Azure Storage Account Name]',
SECRET = 'Access Key';`



- Once you have executed this query, refresh the **Object Explorer** to view the new node containing your credentials which will ensure that any periodic backups will be stored safely and correctly:




![image](https://github.com/S-a-a-h/azure-database-migration978/assets/152003248/620d957b-9831-4fb4-86ed-46ad25e8b2bf)




- Right-click on the **SQL Server Agent** node and select **Start** to begin configuring automated backups:
![image](https://github.com/S-a-a-h/azure-database-migration978/assets/152003248/dd0ec808-fd70-4abb-842f-9d2060800b83)




- Expand the **Management** node, right-click on **Maintenance Plans** and then select **Maintenance Plan Wizard**
![image](https://github.com/S-a-a-h/azure-database-migration978/assets/152003248/fd891b7e-9b50-4240-9d95-1017fbec8042)




- Ensure a name and description of this plan for readability:




![image](https://github.com/S-a-a-h/azure-database-migration978/assets/152003248/107d7e46-7db2-4217-a66d-81dc0ce8a587)
- As you can see, the **Schedule** isset to default: **Not Scheduled (On Demand)**
- Click on **Change** to configure this setting to a weekly backup before clicking **Next**:
![image](https://github.com/S-a-a-h/azure-database-migration978/assets/152003248/8f2fd1e3-4de8-4987-bf9a-d08a650b9840)




- Ensure that you select **Back Up Database (Full)** before continuing
![image](https://github.com/S-a-a-h/azure-database-migration978/assets/152003248/69171c5b-b7ab-4283-9c2c-0a5c0a12000d)




- In the **General** tab, **All databases** should be backed up due to the developmental nature of this environment and the **Back up to** will be **URL**
![image](https://github.com/S-a-a-h/azure-database-migration978/assets/152003248/357d5f56-36ea-49e0-948e-0d09c25a34a1)




- Create a new container in your Azure Storage Account to store the backups and for linearity you may wish to call it **mydupadmcontainer** 
- In the **Destination** tab, use the drop down menu to select you correct credentials node for **SQL Credential** and type in your desired container name to backup to, which in this case would be: **mydupadmcontainer**
- Click **Next** until the end of the plan and then **Finish** and you will be notified once this task has been successful:
![image](https://github.com/S-a-a-h/azure-database-migration978/assets/152003248/f3d0999d-9bbb-4ac5-b0f0-5ffc4696901a)




- Refresh the **Object Explorer** and you will be able to see a new node named **DUPADMMaintenancePlan** and as you can see, you have various options when right-clicking on this node:
![image](https://github.com/S-a-a-h/azure-database-migration978/assets/152003248/71503e5a-6145-489a-914c-2bc3f75193b8)





- Click on **Execute** to commence the backup process
![image](https://github.com/S-a-a-h/azure-database-migration978/assets/152003248/e884ea54-7339-4ee8-85ff-8a1dc77cadb7)





- A popup will display the backup progress and success of the maintenance plan.
![image](https://github.com/S-a-a-h/azure-database-migration978/assets/152003248/8528e2c1-2f69-444a-95e8-35136dc988aa)





- Verify that the backup file has been uploaded to the Azure Storage Container with the same name as specified in the maintenance plan. You can check this in the Azure portal.
![image](https://github.com/S-a-a-h/azure-database-migration978/assets/152003248/7874acc6-c306-4d8a-a694-95530f9c72a2)





### 5. Disaster Recovery Simulation
---
This part of the project simulates data loss and corruption within the production environment to test the robustness of disaster recovery procedures. 




Backup the production environment as this is where the simulation will occur (VM: ADM) by utilizing the Maintenance Plan Wizard by following instructions to **[Automate Database Backups](#Automate Database Backups)**. Make sure to only execute this plan on an "On Demand" basis: 
![image](https://github.com/S-a-a-h/azure-database-migration978/assets/152003248/e34b98cd-2163-429f-8b07-f51bf0abb6be)
![image](https://github.com/S-a-a-h/azure-database-migration978/assets/152003248/cce62712-22cb-48a0-97e8-ffca6ac17dad)




Finally, check that this backup has occurred in the correct container by navigating to it to see the new blob in the Azure Portal: 
![image](https://github.com/S-a-a-h/azure-database-migration978/assets/152003248/638e8631-deed-4648-a6c3-b6f6f5d22f56)




To mimic a data loss scenario, use the following query in Azure Data Studio in the VM: ADM. 

1. View the data you are going to mimic loss on:
   `SELECT * FROM Person.Address;'
   ![image](https://github.com/S-a-a-h/azure-database-migration978/assets/152003248/361d5a67-17bc-4b20-9b74-6571e1b428c7)





1. Perform the data loss query by disabling all foreign key constraints referencing the table:
   `EXEC sp_msforeachtable 'ALTER TABLE ? NOCHECK CONSTRAINT ALL';`
   
1. Delete the rows from the table:
   `DELETE TOP (100) FROM Person.Address;`
   
1. View the data once the loss has occurred to confirm that the top 100 rows are now missing:
   `SELECT * FROM Person.Address;`
   ![image](https://github.com/S-a-a-h/azure-database-migration978/assets/152003248/ac7e0b0d-7aa8-4dba-86e3-7024ebe1daeb)

   




To mimic a data corruption scenario, use the following queries in Azure Data Studio in the VM: ADM.

1. View the data you are going to mimic corruption on:
   `SELECT * FROM Person.EmailAddress;`
   ![image](https://github.com/S-a-a-h/azure-database-migration978/assets/152003248/fc2d007b-2b7b-4c02-bbda-aac59e10d563)



   
1. Corrupt the data with the following query:
   `UPDATE TOP (100) Person.EmailAddress
    SET EmailAddress = NULL;`
   
1. View the corrupted data:
   `SELECT EmailAddress FROM Person.EmailAddress;`
   ![image](https://github.com/S-a-a-h/azure-database-migration978/assets/152003248/bb43407d-06cc-4a04-b375-ba971c88fd06)



   


#### Restore Database via Azure SQL Database Backup
---
On Azure Portal, navigate to the Azure SQL Database associaed with your production environment to click on **Restore**. 
![image](https://github.com/S-a-a-h/azure-database-migration978/assets/152003248/55d90736-8fc8-444d-9a63-ad2a3f9546a5)




Choose a date and time representing the point in time before the data loss/corruption occurred. Be sure to name this database descriptively to distinguish between the compromised database and the one being restored to ADM; add `-restored` to the end of the database name. **Review + create** this restoration once you have checked the details are correct. 
![image](https://github.com/S-a-a-h/azure-database-migration978/assets/152003248/321851ed-fb58-41a0-9083-41e792b8d55d)



#### Validate Restoration 
---
Once the database has been restored through Azure, it will appear under the resource list in Azure SQL Database in the Azure Portal. 
![image](https://github.com/S-a-a-h/azure-database-migration978/assets/152003248/02636af7-a3d9-4f1e-883d-a7888c1a255c)




To validate that it has been restored correctly, establish a connection to it using Azure Data Studio in the VM: ADM, by clicking on the **New Connection** icon in the **Connections** tab and entering the relevant details and **SQL Login** credentials. 




Verify that this database is once again fully functional by running simple queries to examine the number of rows, especially targetting the deleted and corrupted data from the simulation: 
- Examine number of rows: `SELECT * FROM Person.Address;`
![image](https://github.com/S-a-a-h/azure-database-migration978/assets/152003248/03f690b6-ae5d-4cd1-8c93-f2ffef3a028b)





- Examine correct values: `SELECT EmailAddress FROM Person.EmailAddress;`
![image](https://github.com/S-a-a-h/azure-database-migration978/assets/152003248/600e5aef-f3bf-489d-b760-633a856c7551)





Delete the corrupted database in the Azure Portal by navigating to it and clicking on **Delete** in the top bar. It is no longer useful to the production environment. 




### 6. Geo-Replication and Failover 
---
Geo-replication involves backing up the primary database to a secondary location which differs from the primary database's region and incase of a disaster. 




#### Steps
---
1. In the Azure Portal, navigate to the database requiring geo-replication, in this case, the one which was just restored.
1. Select **Replicas** from under the **Data management** tab on the left. 
![image](https://github.com/S-a-a-h/azure-database-migration978/assets/152003248/540d7a3a-750f-451b-b8ed-a646f2df1440)
1. Click on **Create replica** and create a new server for this geo-replicated database
1. Select a location that is far from the one where the primary database is stored: Primary: UK South | Secondary: East US
1. Select **Use SQL authentication** to create credentials to access this server in the event of a disaster
1. Confirm the details and **Review + create** to synchronize the databases
1. Validate the geo-replication details of the primary and secondary databases by examining the resource's page (you will be redirected to this once deployment is complete in Azure)
![image](https://github.com/S-a-a-h/azure-database-migration978/assets/152003248/1a39d219-4c50-4129-a755-ebba4f76f495)




#### Failover 
---
A faiover switches the workload from the primary region to the secondary region in a geo-replicated environment. Orchestrating a planned failover during a downtime window determines the functionality of the environment without impacting the production workload or incurring any data loss. 




#### Steps
---
1. Navigate to resources in Azure Portal and select the primary **server** which is associated with the region: **UK South**
1. Select **Failover groups** from under the **Data management** tab on the left
1. Click on **Add group** in the top bar to create a new failover group
1. Enter a name for this failover group and select the secondary server as the **Server**, then **Create**
![image](https://github.com/S-a-a-h/azure-database-migration978/assets/152003248/5fdf8982-05ec-4e03-8b57-440a6d94e83e)
1. Access this group to initialise the failover
![image](https://github.com/S-a-a-h/azure-database-migration978/assets/152003248/1a5a38e6-e5f1-4b56-9ae9-7198d72e1011)
1. Select **Failover** from the top tab and then click **Yes** at the following warning:
![image](https://github.com/S-a-a-h/azure-database-migration978/assets/152003248/aa2c4af9-0d55-45c7-9455-1567bb5f667c)
1. You will see this change once the failover has occurred:
![image](https://github.com/S-a-a-h/azure-database-migration978/assets/152003248/8e2f047e-3c66-4108-9dae-0cec7353836d)




#### Tailback 
---
A tailback reverts the workload back to the primary region after a successful failover. To perform the tailback, simply click on **Failback** then **Yes** when the warning pops up and you should see that the workload is switched back to the primary region.
![image](https://github.com/S-a-a-h/azure-database-migration978/assets/152003248/6e19aeb0-b4cf-4760-90c7-282dd81b44da)




### 7. Microsoft Entra Directory Integration
---
To manage who can access the data as well as user management, Microsoft Entra IDs can be created for administrative authority. 




Navigate to the SQL Server in the Azure Portal which hosts the primary database - the one which was recently restored. Under the **Settings** section, click on **Microsoft Entra**, then **Set Admin** in the top bar. Select **Users** to choose the correct user to assign admin privileges to by searching for them and clciking **Select**:
![image](https://github.com/S-a-a-h/azure-database-migration978/assets/152003248/3c7db878-9a1a-4707-921d-4b681a461aea)
You will now see that this has been set after clicking on **Save** in the top bar:
![image](https://github.com/S-a-a-h/azure-database-migration978/assets/152003248/ca6bc97c-c02f-4bd1-a874-734341d52cbf)




#### Connect using Microsoft Entra ID
---
Connect to the VM named ADM and access Azure Data Studio to establish a connection to the restored, production database. 




If a connection already exists, right-click on the server and select **Disconnect** before double-clicking on the server once more to connect. This will ensure that a refresh occurs to allow for use of the new Microsoft Entra admin user. In the **Connection Details**, select **Azure Active Directory - Universal with MFA support** and **Add an account** to add the authorized account by logging in when redirected. Now, you have the option to choose this account in future. Click on **Connect** once details are confirmed. 
![image](https://github.com/S-a-a-h/azure-database-migration978/assets/152003248/a521ac6c-682f-45d8-8923-1fa4fd697132)




#### DB Reader User 
---
A DB Reader User is a user with read-only access to the database. 




Create an db_reader user by navigating to the Azure portal and into the Microsoft Entra ID resource homepage. Click on **Create new** and select a suggestive name for the user. Be sure to create a password for this user by unticking **Auto-generatepassword** and store these credentials safely. Confirm the details and **Create**.




In ADM, return to the connection made in Azure Data Studio via Microsoft Entra ID and open up a **New Query** by right-clicking on the server and selecting that option. Adapt and run the following queries to enable the correct credentials for the db_reader user you have created in the Azure Portal: 




`CREATE USER [DB_Reader@yourdomain.com] FROM EXTERNAL PROVIDER;` - creates the user 




`ALTER ROLE db_datareader ADD MEMBER [DB_Reader@yourdomain.com];` - adapts the access assigned to the user




In the Azure Portal, this user will now appear in the Microsoft Entra Directory users when you search for the user you created for db_reader purposes only. 
![image](https://github.com/S-a-a-h/azure-database-migration978/assets/152003248/e24df1d2-158d-4ee1-84c1-b55e97b41e60)




To test this db_reader user's permissions, reconnect to the server using the associated credentials. You can do so by clicking **Edit Connection**
![image](https://github.com/S-a-a-h/azure-database-migration978/assets/152003248/ee2c00d1-bc5b-4ef1-8f0f-91477b8880bb)




Add the account as done for [Microsoft Entra ID](#Microsoft Entra Directory Integration) - you will be asked to choose a new password so update this and then click **Connect**:
![image](https://github.com/S-a-a-h/azure-database-migration978/assets/152003248/4dd49d0d-16d2-4e32-926a-f06e860ad77c)




![image](https://github.com/S-a-a-h/azure-database-migration978/assets/152003248/9c7a7aa1-7029-4c9d-8f2e-27ce99feb05b)




Right-click on any table and select **Select Top 1000** and this will return the data requested:
![image](https://github.com/S-a-a-h/azure-database-migration978/assets/152003248/6f1a24e9-826d-4015-a3d0-fa4d3fe22db3)




However, if you attempt the following query: `DELETE TOP (1) FROM Person.BusinessEntity;` 
You will see the following error due to read-only access: 
![image](https://github.com/S-a-a-h/azure-database-migration978/assets/152003248/c0115aaf-8cd1-4446-9434-d40185525a5d)




### 8. Azure Database Migration: Project Diagram
---
![image](https://github.com/S-a-a-h/azure-database-migration978/assets/152003248/58528764-be23-4971-8a12-875ecc9110f2)





### 9. License Information
---
None.




> [!NOTE]
> Ensure links are not outdated for your purposes. 
