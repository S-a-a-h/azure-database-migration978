# Azure Database Migration

### Table of Contents
---
1. Project Description


#### Production Database
---
2. Set Up
   - Virtual Machine
   - Server
   - Database
   - Firewall
3. Installation Instructions
   - SQL Server Developer 
   - SQL Server Management Studio (SSMS)
4. Usage Instructions
   - Connect to the Database
   - Restore AdventureWorks Database

     
#### Database Migration
---
5. Migration Installation Instructions
   - Azure Data Studio
   - Azure SQL Migration
6. Migration 
   - Steps


#### Database Inspection
---
7. File Structure
---
8. Azure Blob Storage


#### Sandbox
---
9. Description
10. Sandbox Set Up
    - Restoring Backup Database onto DUP-ADM
    - Inspect Restored Backup Database Data
11. Automate Database Backups
    - Steps

---
12. License Information
---



### Project Description
---
This project is a simulated database migration for a manufacturing company's operations using Microsoft Azure.
Database: AdventureWorks | [Database Download Link](https://aicore-portal-public-prod-307050600709.s3.eu-west-1.amazonaws.com/project-files/93dd5a0c-212d-48eb-ad51-df521a9b4e9c/AdventureWorks2022.bak)



      PRODUCTION DATABASE
      


### Set Up
---
Ensure you have a Mircosoft Azure account with an appropriate subscription. 




#### Virtual Machine
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
Create an SQL Server by navigating to the relevent Azure service.



Complete the required fields as you did for the creation of the VM. However, in addition, use your preferred choice of Authentication; for this project, **Use Microsoft Entra-only authentication** was selected and an admin was set but clicking on **Set Admin**. Then click on **Review + create** to deploy this resource. 




#### Database
Create an SQL Database by navigating to the relevent Azure service.


Complete the required fields as you did for the creation of the Server and be sure to select this Server in the appropriate field. Select **Geo-redundant backup storage** for **Backup storage redundancy** - this will aloow for geo-replication later on. Leave all other options as default. Then click on **Review + create** to deploy this resource. 




#### Firewall
Navigate to the Overview page of the server and click on **Show networking settings** to add a new firewall rule which allows access to the database on ADM. Name the rule and paste the database IP address in both fields: **Start IP** and **End IP**. Access is now granted to your database. 



### Installation Instructions
---

> [!NOTE]
> Ensure you are using your VM to complete the steps below.

Connect to your VM via Microsoft Remote Desktop by dragging and dropping the downloaded RDP file to this applicatiion, which will then launch your VM and ask you to sign in using your Authentication Account credentials.

Once you are on, download and install the following: 



#### SQL Server Developer
[Download Link](https://go.microsoft.com/fwlink/p/?linkid=2215158&clcid=0x809&culture=en-gb&country=gb)


#### SQL Server Management Studio
Once you have installed the above, there is a button to 'Install SSMS' so go ahead and click that to access the download link for SSMS. Make sure to install this as well.




### Usage Instructions
---
#### Connect to Database
Launch SSMS to connect to the server with the following settings and using your Authentication Account credentials: 



Server Type: **Database Engine**



Server Name: **ADM** 



Authentication: **Windows Authentication**



#### Restore AdventureWorks Database
Download the backup file ([Download Link](https://aicore-portal-public-prod-307050600709.s3.eu-west-1.amazonaws.com/project-files/93dd5a0c-212d-48eb-ad51-df521a9b4e9c/AdventureWorks2022.bak)) and store in the following pathway: `C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\`




In SSMS, ensure you are connected to the server, in the **Object Explorer**, right-click on **Databases** -> **Restore Database...** -> on the **General** page, select **Device:** -> **...** -> **Add** to add the backup (.bak) file which you stored in the aforementioned pathway -> **OK** -> **OK**




You should receive a notification pop up to tell you that the restoration was successful. The AdventureWorks Database is now available in the Object Explorer under **Databases**.



      DATABASE MIGRATION



### Migration Installation Instructions
---
Create another Azure SQL Server which will support a development database. Follow the steps above in the **[Server](#Server)** section. For the authentication method choose SQL Login instead this time - you will need this to confgure Azure Data Studio. 




Create the development Azure SQL Database on your Azure account to which you intend to migrate your ADM database to as this existing database is the on-premise, production database. You require one which will replicate this and can create it by following the steps in the **[Database](#Database)** section. Ensure to configure appropriate settings by following the **[Firewall](#Firewall)** rules section. 




#### Azure Data Studio
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
Now to ensure the data is inserted into these tables, install **Azure SQL Migration** from the **Extensions** tab to add it to your environment. Right-click on the local server's **AdventureWorks2022** database to select **Manage**. In the main console, click on the button: **Migrate to Azure SQL** which will open a Migration Wizard to select the dataebase whih you want to migrate (**AdventureWorks2022**).



### Migration
---
#### Steps
- Complete each of the steps of the Migration Wizard and ensure you use the correct credentials relative to your target server in Step 3.
- Step 4: you will need to navigate to **Azure Database Migration Service** on your Azure account and create a new service with all the default settings, before you are able to move forward. Now, you will see an error message in the main console so you need to click on the download link and select the latest or desired version of **Azure Database Migration Service** and then run the downloaded file to install. Use one of the Keys provided in the main console of Azure Data Studio to **Register** Integration Runtime. Finally, click on **Launch Configuration Manager**.
- Click refresh or **Save + close** and re-open this migration ticket and you should be able to proceed to Step 5.
- Step 5: you will need your Windows Authentication credentials and ensure all tables are selected by clicking **Edit**, select as you desire and **Update**, if necessary. Click **Run Validation** then **Start Migration**
- Once the migration is complete and successful, you can view the table data in the target database. 



      DATABASE INSPECTION

> [!NOTE]
> This is an integral part of data migration to retain data intergrity and accuracy.



### File Structure
---
These files contain matching SQL Queries which can be run by opening the files or opening a new query for each database. This ensures that the data matches and has not been lost or corrupted during the migration process: 




Local Server: localhost_validation_queries.sql




Target Server: migration_validation_queries.sql



### Azure Blob Storage
---
- Create a **Storage Account** by navigating to the service on the Azure Portal - this is where you will store your database backup file as Blob storage, remotely.
- Create a container by accessing this Storage Account, selecting **Containers** in the left-panel under **Data Storage** and clicking on **+ Container** to be prompted for the container's name and **Anonymous access level** - *Ensure use of the most appropriate access level for your case*.
- Upload .bak file to the container by clicking on **Upload** in the desired container by dragging and dropping the file here before uploading.



      SANDBOX

> [!NOTE]
> The following section uses SSMS.

#### Description 
A sandbox is a controlled and isolated environment where applications and software can be tested, developed, and experimented with, all without impacting the production systems. To create this development environment, the Windows VM which is currently the **Production Environment**, with all of it's infrastructure, will be duplicated. The purpose of a sandbox allows you to work on the application, test new features, and troubleshoot issues in a safe and isolated environment before making changes in the production system.




#### Sandbox Set Up
- Provision a new **[Windows VM](#Virtual Machine)** named **DUP-ADM**
- Follow the **[Installation Instructions](#Installation Instructions)** to mimic the infrastructure of the **Production Environment**; ensure the following are downloaded and installed correctly:
   - SQL Server Developer 
   - SQL Server Management Studio (SSMS)




#### Restoring Backup Database onto DUP-ADM
- Download the Blob from your Azure Storage Account 
- Restore the AdventureWorks2022 database by following the instructions for **[Restore AdventureWorks Database](#Restore AdventureWorks Database)**
- Refresh the **Object Explorer** if you cannot view the restored database




#### Inspect Restored Backup Database Data
Run some queires to ensure data integrity. For example, you may wish to check the number of rows for some tables with the following syntax: 




`SELECT * FROM [table_name];`




### Automate Database Backups
---
Configuring a weekly backup schedule ensures consistent protection for any evolving work and simplifies the recovery process of the development environment if and when necessary. 




#### Steps
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





### Disaster Recovery Simulation
---
This part of the project simulates data loss and corruption within the production environment to test the robustness of disaster recovery procedures. 




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
   
1. Corrupt the data with the following query:
   `UPDATE TOP (100) Person.EmailAddress
    SET EmailAddress = NULL;`
   
1. View the corrupted data:
   `SELECT EmailAddress FROM Person.EmailAddress;`
   ![image](https://github.com/S-a-a-h/azure-database-migration978/assets/152003248/2ed21e24-4528-4c40-9df2-53f616f3dd98)

   






### License Information
---
None.




> [!NOTE]
> Ensure links are not outdated for your purposes. 
