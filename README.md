# Azure Database Migration

### Table of Contents
---
1. Project Description
1. Set Up
   - Virtual Machine
   - Server
   - Database
   - Firewall
1. Installation Instructions
   - Microsoft SQL Server
   - SQL Server Management Studio (SSMS)
1. Usage Instructions
1. License Information



### Project Description
---
This project is a simulated database migration for a manufacturing company's operations using Microsoft Azure.
Database: AdventureWorks | Link: [https://aicore-portal-public-prod-307050600709.s3.eu-west-1.amazonaws.com/project-files/93dd5a0c-212d-48eb-ad51-df521a9b4e9c/AdventureWorks2022.bak] 



### Set Up
---
Ensure you have a Mircosoft Azure account with an appropriate subscription. 




#### Virtual Machine
Create a Virtual Machine by navigating to the relevent Azure service.



Resource Group: Create new as this can be modified later 



Name: ADM



Region: UK South (ensure that you select the one closest to your location) 



Image: 'Windows 11 Pro, version 22H2 - x64 Gen2' 



Size: Standard_D2s_v3 (This was recommended but can be modified by selecting a different size)



Set up your Administrator Account username and password - you will need this to connect to ADM so ensure you keep these credentials safe. 



Inbound Port Rules: select 'Allow selected ports' -> 'RDP (3389)'



Licensing: check the confirmation statment then 'Review + create'



Once this resoure has been deployed, navigate to it and on the Overview page click on the 'Connect' tab in the top-bar and download the RDP file found here; you will use this to connect to this VM.




#### Server
Create an SQL Server by navigating to the relevent Azure service.



Complete the required fields as you did for the creation of the VM. However, in addition, use your preferred choice of Authentication; for this project, 'Use Microsoft Entra-only authentication' was selected and an admin was set but clicking on 'Set Admin'. Then click on 'Review + create' to deploy this resource. 




#### Database
Create an SQL Database by navigating to the relevent Azure service.


Complete the required fields as you did for the creation of the Server and be sure to select this Server in the appropriate field. Select 'Geo-redundant backup storage' for 'Backup storage redundancy' - this will aloow for geo-replication later on. Leave all other options as default. Then click on 'Review + create' to deploy this resource. 




#### Firewall
Navigate to the Overview page of the server and click on 'Show networking settings' to add a new firewall rule which allows access to the database on ADM. Name the rule and paste the database IP address in both fields: 'Start IP' and 'End IP'. Access is now granted to your database. 



### Installation Instructions
---
Connect to your VM via Microsoft Remote Desktop by dragging and dropping the downloaded RDP file to this applicatiion, which will then launch your VM. 


Once you are on, download and install the following: 



SQL Server Developer (Download Link: [https://go.microsoft.com/fwlink/p/?linkid=2215158&clcid=0x809&culture=en-gb&country=gb to])



Once you have installed the above, there is a button to 'Install SSMS' so go ahead and click that to access the download link for SQL Server Management Studio. Make sure to install this as well.



> [!NOTE]
> Ensure these links are not outdated for your purposes. 



### Usage Instructions
---
Database details...



### License Information
---
None.
