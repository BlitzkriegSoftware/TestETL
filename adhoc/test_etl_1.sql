/*
Ad-hoc test script
*/

exec [etl].[p00_InitEtl];
exec [etl].[p01_GetFilesToImport]
exec [etl].[p02_LoadRaw]
exec [etl].[p03_ValidateRaw] 

SELECT TOP (1000) [EMail]
      ,[ProductId]
      ,[Quantity]
      ,[OrderDate]
  FROM [Bicycle].[etl].[Orders-Raw]

exec [etl].[p04_ImportRaw]

SELECT TOP (1000) [ErrorLogId]
      ,[Step]
      ,[Comment]
  FROM [Bicycle].[common].[ErrorLog]