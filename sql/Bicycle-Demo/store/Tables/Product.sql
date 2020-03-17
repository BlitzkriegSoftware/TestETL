CREATE TABLE [store].[Product] (
    [ProductId]   BIGINT         IDENTITY (1, 1) NOT NULL,
    [Name]        NVARCHAR (255) NOT NULL,
    [Description] NVARCHAR (MAX) NULL,
    [IsActive]    BIT            DEFAULT ((1)) NULL,
    [Price]       MONEY          CONSTRAINT [DF_Product_Price] DEFAULT ((20.00)) NULL,
    CONSTRAINT [PK_Product] PRIMARY KEY CLUSTERED ([ProductId] ASC)
);





