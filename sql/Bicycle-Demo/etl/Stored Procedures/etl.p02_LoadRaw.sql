-- =============================================
-- Author:		Stuart Williams
-- Create date: 3/20/2020
-- Description:	Lifts Files off disk into RAW
-- =============================================

CREATE PROCEDURE etl.p02_LoadRaw
AS
    BEGIN
        SET NOCOUNT ON;
        DECLARE @ErrorMessage NVARCHAR(4000);
        DECLARE @ErrorSeverity INT;
        BEGIN TRY
            IF NOT EXISTS
            (
                SELECT *
                FROM etl.FilesToImport
            )
                RAISERROR('Nothing to import', 16, 1);
        END TRY
        BEGIN CATCH
            SELECT @ErrorMessage = ERROR_MESSAGE(), 
                   @ErrorSeverity = ERROR_SEVERITY();
            INSERT INTO common.ErrorLog
            (Step, 
             Comment
            )
            VALUES
            (
            (
                SELECT OBJECT_NAME(@@PROCID)
            ), 
            @ErrorMessage
            );
            RAISERROR(@ErrorMessage, @ErrorSeverity, 1);
            RETURN;
        END CATCH;
        BEGIN TRY
			DECLARE @SQL_BULK VARCHAR(MAX);
            DECLARE @filename NVARCHAR(MAX);
			DECLARE @formatfile NVARchar(max); 

			select @formatfile=[Value] from [common].[Configuration] where [Name]='FormatFilePath';

			DECLARE ImportFiles CURSOR LOCAL FAST_FORWARD
            FOR SELECT f.[FileNamePath] FROM [etl].[FilesToImport] AS f;

            OPEN ImportFiles;
            FETCH NEXT FROM ImportFiles INTO @filename;

            WHILE @@FETCH_STATUS = 0
                BEGIN
                    PRINT 'Processing: ' + @filename;
                    FETCH NEXT FROM ImportFiles INTO @filename;

                    SET @SQL_BULK = 'BULK INSERT [etl].[Orders-Raw] FROM ''' + @filename + ''' WITH (FIRSTROW = 2, FIELDTERMINATOR = ''tab'', KEEPNULLS, formatfile=''' + @formatfile + ''')';
                    EXEC (@SQL_BULK);
                END;

            CLOSE ImportFiles;
            DEALLOCATE ImportFiles;
        END TRY
        BEGIN CATCH
            SELECT @ErrorMessage = ERROR_MESSAGE(), 
                   @ErrorSeverity = ERROR_SEVERITY();
            INSERT INTO common.ErrorLog
            (Step, 
             Comment
            )
            VALUES
            (
            (
                SELECT OBJECT_NAME(@@PROCID)
            ), 
            @ErrorMessage
            );
            RAISERROR(@ErrorMessage, @ErrorSeverity, 1);
            RETURN;
        END CATCH;
    END;