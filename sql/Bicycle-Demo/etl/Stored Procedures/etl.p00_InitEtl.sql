-- =============================================
-- Author:		Stuart Williams
-- Create date: 3/17/2020
-- Description:	Step Zero of ETL
-- =============================================
CREATE PROCEDURE [etl].p00_InitEtl 

AS
BEGIN

	SET NOCOUNT ON;

	truncate table [etl].[ErrorLog];
	truncate table [etl].[OrderDetail-Load];
	truncate table [etl].[Order-Load];
	truncate table [etl].[Customer-Load];
	truncate table [etl].[Product-Load];

END