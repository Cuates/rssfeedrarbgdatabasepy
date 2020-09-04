USE [media]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[MovieFeed](
	[mfID] [bigint] IDENTITY(1,1) NOT NULL,
	[titlelong] [nvarchar](255) NOT NULL,
	[titleshort] [nvarchar](255) NOT NULL,
	[publish_date] [datetime2](7) NOT NULL,
	[actionstatus] [int] NOT NULL,
	[created_date] [datetime2](7) NOT NULL,
	[modified_date] [datetime2](7) NULL,
 CONSTRAINT [PK_MovieFeed_titlelong] PRIMARY KEY CLUSTERED 
(
	[titlelong] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[MovieFeed] ADD  DEFAULT (getdate()) FOR [created_date]
GO

ALTER TABLE [dbo].[MovieFeed] ADD  DEFAULT (getdate()) FOR [modified_date]
GO

ALTER TABLE [dbo].[MovieFeed]  WITH CHECK ADD  CONSTRAINT [FK_MovieFeed_actionstatus] FOREIGN KEY([actionstatus])
REFERENCES [dbo].[ActionStatus] ([actionnumber])
GO

ALTER TABLE [dbo].[MovieFeed] CHECK CONSTRAINT [FK_MovieFeed_actionstatus]
GO
