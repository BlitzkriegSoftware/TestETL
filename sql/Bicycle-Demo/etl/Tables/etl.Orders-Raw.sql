CREATE TABLE [etl].[Orders-Raw] (
    [EMail]     NVARCHAR (MAX) NULL,
    [ProductId] BIGINT         NULL,
    [Quantity]  INT            NULL,
    [OrderDate] DATETIME2 (7)  NULL
);

