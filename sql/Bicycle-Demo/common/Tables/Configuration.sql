CREATE TABLE [common].[Configuration] (
    [Name]  NVARCHAR (255) NOT NULL,
    [Value] NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_Configuration] PRIMARY KEY CLUSTERED ([Name] ASC)
);

