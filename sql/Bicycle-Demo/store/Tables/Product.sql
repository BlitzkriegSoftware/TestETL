CREATE TABLE [store].[Product] (
    [ProductId] BIGINT         IDENTITY (1, 1) NOT NULL,
    [Name]      NVARCHAR (255) NOT NULL,
    [Decripton] NVARCHAR (MAX) NULL,
    [IsActive]  BIT            DEFAULT ((1)) NULL,
    CONSTRAINT [PK_Product] PRIMARY KEY CLUSTERED ([ProductId] ASC)
);

