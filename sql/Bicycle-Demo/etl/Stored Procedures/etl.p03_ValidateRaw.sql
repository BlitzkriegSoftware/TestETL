-- =============================================
-- Author:		Stuart Williams
-- Create date: 3/20/2020
-- Description:	Validate RAW Files
-- =============================================
CREATE PROCEDURE [etl].[p03_ValidateRaw]
AS
    BEGIN
        SET NOCOUNT ON;
        DECLARE @ErrorMessage NVARCHAR(4000);
        DECLARE @ErrorSeverity INT;
        BEGIN TRY
            IF NOT EXISTS
            (
                SELECT *
                FROM [ETL].[Orders-Raw]
            )
                RAISERROR('No Orders to Process', 16, 1);
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

            -- Scrubbings
            UPDATE [etl].[Orders-Raw]
              SET 
                  [EMail] = replace([Email], '"', '');
            UPDATE [etl].[Orders-Raw]
              SET 
                  [EMail] = TRIM([Email]);
            UPDATE [etl].[Orders-Raw]
              SET 
                  [OrderDate] = GETUTCDATE()
            WHERE [OrderDate] IS NULL;

            -- Missing Customers
            INSERT INTO common.ErrorLog
            (Step, 
             Comment
            )
                   SELECT ISNULL(OBJECT_NAME(@@PROCID), ''), 
                          r.[EMail] + ' not found in customers'
                   FROM [etl].[Orders-Raw] r
                        LEFT JOIN [store].[Customer] c ON r.[EMail] = c.[EMail]
                   WHERE c.[EMail] IS NULL;

            -- Bad Products
            INSERT INTO common.ErrorLog
            (Step, 
             Comment
            )
                   SELECT ISNULL(OBJECT_NAME(@@PROCID), ''), 
                          CAST(r.[ProductId] AS NVARCHAR(50)) + ' not found in products'
                   FROM [etl].[Orders-Raw] r
                        LEFT JOIN [store].[Product] p ON r.[ProductId] = p.[ProductId]
                   WHERE p.ProductId IS NULL;

            -- Bad Quantities
            INSERT INTO common.ErrorLog
            (Step, 
             Comment
            )
                   SELECT ISNULL(OBJECT_NAME(@@PROCID), ''), 
                          CAST(r.[Quantity] AS NVARCHAR(50)) + ' not a valid quantity'
                   FROM [etl].[Orders-Raw] r
                   WHERE(r.[Quantity] IS NULL)
                        OR (r.[Quantity] <= 0)
                        OR (r.[Quantity] > 99);

            -- lastly validate we have no errors
            IF EXISTS
            (
                SELECT *
                FROM [common].[ErrorLog]
            )
                RAISERROR('ETL Errors See Log', 16, 1);
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