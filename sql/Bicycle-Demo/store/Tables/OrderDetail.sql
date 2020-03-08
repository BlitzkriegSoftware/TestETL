CREATE TABLE [store].[OrderDetail] (
    [OrderDetailId] BIGINT IDENTITY (1, 1) NOT NULL,
    [OrderId]       BIGINT NOT NULL,
    [ProductId]     BIGINT NOT NULL,
    [CostEach]      MONEY  DEFAULT ((0.0)) NOT NULL,
    [Quantity]      INT    DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_OrderDetail] PRIMARY KEY CLUSTERED ([OrderDetailId] ASC),
    CONSTRAINT [FK_OrderDetail_Order] FOREIGN KEY ([OrderId]) REFERENCES [store].[Order] ([OrderId]),
    CONSTRAINT [FK_OrderDetail_Product] FOREIGN KEY ([ProductId]) REFERENCES [store].[Product] ([ProductId])
);

