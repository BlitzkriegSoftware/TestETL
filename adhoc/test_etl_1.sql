/*
Ad-hoc test script
*/
SET NOCOUNT ON;

exec [etl].[p00_InitEtl];
exec [test].[p00_Test]

exec [etl].[p01_GetFilesToImport]
exec [test].[p01_Test]

exec [etl].[p02_LoadRaw]
exec [test].[p02_Test]

exec [etl].[p03_ValidateRaw] 
exec [test].[p03_Test]

SELECT TOP (1000) [EMail]
      ,[ProductId]
      ,[Quantity]
      ,[OrderDate]
  FROM [Bicycle].[etl].[Orders-Raw]

exec [etl].[p04_ImportRaw]
exec [test].[p04_Test]

SELECT TOP (1000) [ErrorLogId]
      ,[Step]
      ,[Comment]
  FROM [Bicycle].[common].[ErrorLog]