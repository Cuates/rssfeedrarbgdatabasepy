USE [media]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[MediaAudioEncode](
	[maeID] [bigint] IDENTITY(1,1) NOT NULL,
	[audioencode] [nvarchar](100) NOT NULL,
	[movieInclude] [bit] NOT NULL,
	[tvInclude] [bit] NOT NULL,
	[created_date] [datetime2](7) NOT NULL,
	[modified_date] [datetime2](7) NULL,
 CONSTRAINT [PK_MediaAudioEncode_audioencode] PRIMARY KEY CLUSTERED 
(
	[audioencode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[MediaAudioEncode] ADD  DEFAULT ((0)) FOR [movieInclude]
GO

ALTER TABLE [dbo].[MediaAudioEncode] ADD  DEFAULT ((0)) FOR [tvInclude]
GO

ALTER TABLE [dbo].[MediaAudioEncode] ADD  DEFAULT (getdate()) FOR [created_date]
GO

ALTER TABLE [dbo].[MediaAudioEncode] ADD  DEFAULT (getdate()) FOR [modified_date]
GO
