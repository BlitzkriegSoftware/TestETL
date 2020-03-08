CREATE TABLE [store].[Customer] (
    [CustomerId]      BIGINT         IDENTITY (1, 1) NOT NULL,
    [NameLast]        NVARCHAR (255) NOT NULL,
    [NameFirst]       NVARCHAR (255) NOT NULL,
    [Company]         NVARCHAR (255) NULL,
    [Address1]        NVARCHAR (40)  NOT NULL,
    [Address2]        NVARCHAR (40)  NULL,
    [Address3]        NVARCHAR (40)  NULL,
    [Address4]        NVARCHAR (40)  NULL,
    [City]            NVARCHAR (40)  NOT NULL,
    [StateOrProvence] NVARCHAR (40)  NULL,
    [PostalCode]      NVARCHAR (40)  NOT NULL,
    [PhonePrimary]    NVARCHAR (15)  NULL,
    [EMail]           NVARCHAR (255) NOT NULL,
    [IsActive]        BIT            NULL,
    CONSTRAINT [PK_Customer] PRIMARY KEY CLUSTERED ([CustomerId] ASC)
);

