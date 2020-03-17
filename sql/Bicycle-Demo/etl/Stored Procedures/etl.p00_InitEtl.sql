-- =============================================
-- Author:		Stuart Williams
-- Create date: 3/17/2020
-- Description:	Step Zero of ETL
-- =============================================
CREATE PROCEDURE [etl].[p00_InitEtl] 

AS
BEGIN

	SET NOCOUNT ON;

	truncate table [common].[ErrorLog];
	truncate table [etl].[FilesToImport]
	truncate table [etl].[Orders-Raw];

END