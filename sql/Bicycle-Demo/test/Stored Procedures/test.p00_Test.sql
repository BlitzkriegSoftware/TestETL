-- =============================================
-- Author:		Stuart Williams
-- Create date: 3/20/20202
-- Description:	Test Step 0
-- =============================================
CREATE PROCEDURE [test].[p00_Test]
AS
    BEGIN
        SET NOCOUNT ON;
        DECLARE @status BIT= 0;
        DECLARE @ct INT= 0;

        SELECT @ct = COUNT(*)
        FROM [common].[ErrorLog];
        IF(@ct > 0)
            BEGIN
                SELECT @status = 1;
                RAISERROR('Error Log Should Be Empty', 16, 1);
        END;

        SELECT @ct = COUNT(*)
        FROM [etl].[FilesToImport];
        IF(@ct > 0)
            BEGIN
                SELECT @status = 1;
                RAISERROR('Files To Import Should Be Empty', 16, 1);
        END;
      
		SELECT @ct = COUNT(*)
		FROM [etl].[Orders-Raw];
		IF(@ct > 0)
			BEGIN
				SELECT @status = 1;
				RAISERROR('Raw Data Should Be Empty', 16, 1);
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