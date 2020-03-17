CREATE TABLE [common].[ErrorLog] (
    [ErrorLogId] BIGINT         IDENTITY (1, 1) NOT NULL,
    [Step]       NVARCHAR (255) NOT NULL,
    [Comment]    NVARCHAR (MAX) NOT NULL,
    CONSTRAINT [PK_ErrorLog] PRIMARY KEY CLUSTERED ([ErrorLogId] ASC)
);

