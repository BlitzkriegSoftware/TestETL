CREATE TABLE [store].[Order] (
    [OrderId]    BIGINT        IDENTITY (1, 1) NOT NULL,
    [CustomerId] BIGINT        NOT NULL,
    [OrderDate]  DATETIME2 (7) DEFAULT (getutcdate()) NOT NULL,
    [IsActive]   BIT           DEFAULT ((1)) NULL,
    CONSTRAINT [PK_Order] PRIMARY KEY CLUSTERED ([OrderId] ASC),
    CONSTRAINT [FK_Order_Customer] FOREIGN KEY ([CustomerId]) REFERENCES [store].[Customer] ([CustomerId])
);

