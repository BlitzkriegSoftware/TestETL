CREATE TABLE [etl].[Customer-Load] (
    [CustomerId]      BIGINT         NULL,
    [NameLast]        NVARCHAR (MAX) NULL,
    [NameFirst]       NVARCHAR (MAX) NULL,
    [Company]         NVARCHAR (MAX) NULL,
    [Address1]        NVARCHAR (MAX) NULL,
    [Address2]        NVARCHAR (MAX) NULL,
    [Address3]        NVARCHAR (MAX) NULL,
    [Address4]        NVARCHAR (MAX) NULL,
    [City]            NVARCHAR (MAX) NOT NULL,
    [StateOrProvence] NVARCHAR (MAX) NULL,
    [PostalCode]      NVARCHAR (MAX) NULL,
    [PhonePrimary]    NVARCHAR (MAX) NULL,
    [EMail]           NVARCHAR (MAX) NULL
);

