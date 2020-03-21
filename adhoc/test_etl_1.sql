/*
Ad-hoc test script end to end
*/
use [Bicycle]

SET NOCOUNT ON;

-- Start with a clean slate
truncate table [store].[OrderDetail];
delete from [store].[Order];

-- Set data file folder location
-- TODO: Change this to your file path
update [Bicycle].[common].[Configuration] set [Value] = 'C:\code\blitz\TestETL\data\' WHERE [Name] = 'DataFilePath';

-- Set up ETL Pipeline
exec [etl].[p00_InitEtl];
exec [test].[p00_Test]

-- Find files to import
exec [etl].[p01_GetFilesToImport]
exec [test].[p01_Test]

-- Load files into raw tables
exec [etl].[p02_LoadRaw]
exec [test].[p02_Test]

-- Run business rules
exec [etl].[p03_ValidateRaw] 
exec [test].[p03_Test]

-- See results
SELECT TOP (1000) [EMail]
      ,[ProductId]
      ,[Quantity]
      ,[OrderDate]
  FROM [Bicycle].[etl].[Orders-Raw]

-- Do import to production tables
exec [etl].[p04_ImportRaw]
exec [test].[p04_Test]

-- Show Error Log
SELECT TOP (1000) [ErrorLogId]
      ,[Step]
      ,[Comment]
  FROM [Bicycle].[common].[ErrorLog]
