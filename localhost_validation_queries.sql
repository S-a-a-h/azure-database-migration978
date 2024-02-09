SELECT * FROM HumanResources.Employee;

SELECT * FROM Person.Person;

SELECT name AS TableName
FROM sys.tables
ORDER BY name;

EXEC sp_help 'Person.ContactType';

SELECT
    MAX(ModifiedDate) AS MaxValue,
    MIN(ModifiedDate) AS MinValue
FROM Person.ContactType;

SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'HumanResources'
    AND TABLE_NAME = 'Employee';