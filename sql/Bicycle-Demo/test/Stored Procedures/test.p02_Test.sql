-- =============================================
-- Author:		Stuart Williams
-- Create date: 3/20/20202
-- Description:	Test Step 1
-- =============================================

CREATE PROCEDURE [test].[p02_Test]
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @status bit= 0;
	DECLARE @ct int= 0;

	SELECT @ct = COUNT(*)
	FROM [etl].[Orders-Raw];

	IF(@ct <= 0)
	BEGIN
		SELECT @status = 1;
		RAISERROR('There should be raw rows', 16, 1);
	END;

	IF(@status = 1)
		BEGIN
				PRINT ISNULL(OBJECT_NAME(@@PROCID), '') + ' Fail';
		END;
			ELSE
			BEGIN
				PRINT ISNULL(OBJECT_NAME(@@PROCID), '') + ' Pass';
		END;


END;