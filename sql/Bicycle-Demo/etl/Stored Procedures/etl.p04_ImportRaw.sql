-- =============================================
-- Author:		Stuart Williams
-- Create date: 3/20/2020
-- Description:	Raw to real data
-- =============================================
CREATE  PROCEDURE [etl].[p04_ImportRaw] 

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
                RAISERROR('No Raw Data to Process', 16, 1);

            If EXISTS (
				Select *
				from [common].[ErrorLog]
			)
			RAISERROR('No import, there are ETL Errors', 16, 1);

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

		DECLARE @email nvarchar(max) = '';
		DECLARE @productid bigint = 0;
		DECLARE @quantity int = 0;
		DECLARE @orderdate datetime2 = GetUtcDate();

		Declare @customerid bigint = 0;
		declare @orderid bigint = 0;
		declare @cost money = 0.0;

		DECLARE RawData CURSOR LOCAL FAST_FORWARD
            FOR SELECT [Email], [ProductId], [Quantity], [OrderDate] from [etl].[Orders-Raw]

            OPEN RawData;
            FETCH NEXT FROM RawData INTO @email, @productid, @quantity, @orderdate

            WHILE @@FETCH_STATUS = 0
                BEGIN
					select @customerid = [CustomerId] from [store].[Customer] where [EMail] = @email;

					INSERT INTO [store].[Order]
							   ([CustomerId]
							   ,[OrderDate]
							   ,[IsActive])
						 VALUES
							   (@customerid
							   ,@orderdate
							   ,1)

					select @orderid = SCOPE_IDENTITY();

					select @cost = [Price] from [store].[Product] where [ProductId] = @productid;

					INSERT INTO [store].[OrderDetail]
							   ([OrderId]
							   ,[ProductId]
							   ,[CostEach]
							   ,[Quantity])
						 VALUES
							   (@orderid
							   ,@productid
							   ,@cost
							   ,@quantity);

                    FETCH NEXT FROM RawData INTO @email, @productid, @quantity, @orderdate;
                END;

            CLOSE RawData;
            DEALLOCATE RawData;

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

END