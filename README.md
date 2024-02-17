# Azure Database Migration

### Table of Contents
---
1. Project Description
- - PRODUCTION DATABASE
1. Set Up
   - Virtual Machine
   - Server
   - Database
   - Firewall
1. Installation Instructions
   - SQL Server Developer 
   - SQL Server Management Studio (SSMS)
1. Usage Instructions
   - Connect to the Database
   - Restore the AdventureWorks Database
- - DATABASE MIGRATION
1. Migration Installation Instructions
   - Azure Data Studio
   - Azure SQL Migration
1. Migration 
   - Steps
- - DATABASE INSPECTION
1. File Structure
1. License Information



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



#### Restore the AdventureWorks Database
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
These files contain matching SQL Queries which can be run by opening the files or opening a new query for each database. This ensures that the data matches and has not been corrupted during the migration process: 




Local Server: localhost_validation_queries.sql




Target Server: migration_validation_queries.sql

 


### License Information
---
None.




> [!NOTE]
> Ensure links are not outdated for your purposes. 
