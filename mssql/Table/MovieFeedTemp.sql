USE [Media]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[MovieFeedTemp](
	[titlelong] [nvarchar](255) NULL,
	[titleshort] [nvarchar](255) NULL,
	[publish_date] [nvarchar](255) NULL,
	[created_date] [datetime2](7) NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[MovieFeedTemp] ADD  DEFAULT (getdate()) FOR [created_date]
GO
