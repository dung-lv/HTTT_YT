USE [master]
GO
/****** Object:  Database [QLDT]    Script Date: 8/7/2019 11:34:29 PM ******/
CREATE DATABASE [QLDT]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'QLDT', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\DATA\QLDT.mdf' , SIZE = 13504KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'QLDT_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\DATA\QLDT_log.ldf' , SIZE = 832KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [QLDT] SET COMPATIBILITY_LEVEL = 120
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [QLDT].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [QLDT] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [QLDT] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [QLDT] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [QLDT] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [QLDT] SET ARITHABORT OFF 
GO
ALTER DATABASE [QLDT] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [QLDT] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [QLDT] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [QLDT] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [QLDT] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [QLDT] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [QLDT] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [QLDT] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [QLDT] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [QLDT] SET  ENABLE_BROKER 
GO
ALTER DATABASE [QLDT] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [QLDT] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [QLDT] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [QLDT] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [QLDT] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [QLDT] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [QLDT] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [QLDT] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [QLDT] SET  MULTI_USER 
GO
ALTER DATABASE [QLDT] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [QLDT] SET DB_CHAINING OFF 
GO
ALTER DATABASE [QLDT] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [QLDT] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [QLDT] SET DELAYED_DURABILITY = DISABLED 
GO
USE [QLDT]
GO
/****** Object:  UserDefinedFunction [dbo].[Func_GetCodeTree]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[Func_GetCodeTree]
    (
      @ParentID UNIQUEIDENTIFIER
    )
RETURNS HIERARCHYID
AS
    BEGIN
        DECLARE @codeRoot HIERARCHYID= hierarchyid::GetRoot() ,
            @code HIERARCHYID ,
            @previous HIERARCHYID
        IF @ParentID IS NULL
            BEGIN
               
                SELECT 
                        @previous = MAX(Code)
                FROM    dbo.ProjectTask
                WHERE   Grade = 1
                IF @previous IS NULL
                    BEGIN
                        SET @code = @codeRoot.GetDescendant(NULL, NULL)
                    END
                ELSE
                    BEGIN
                        SET @code = @codeRoot.GetDescendant(@previous, NULL)  
                    END
               
            END
        ELSE
            BEGIN
                DECLARE @grade INT
                SELECT  @code = Code ,
                        @grade = Grade
                FROM    dbo.ProjectTask
                WHERE   ProjectTaskID = @ParentID		
				
                SELECT 
                        @previous = MAX(Code)
                FROM    dbo.ProjectTask
                WHERE   Code.IsDescendantOf(@code) = 'TRUE'
                        AND Grade = @code.GetLevel() + 1
				
                SET @code = @code.GetDescendant(@previous, NULL)  
            END

	-- Return the result of the function
        RETURN @code

    END




GO
/****** Object:  UserDefinedFunction [dbo].[Func_GetCodeVirtualree]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<dvthang>
-- Create date: <11.02.2018>
-- Description:	<Sinh ra code tree của projectTask>
-- =============================================
CREATE FUNCTION [dbo].[Func_GetCodeVirtualree]
    (
      @ParentID UNIQUEIDENTIFIER
    )
RETURNS HIERARCHYID
AS
    BEGIN
        DECLARE @codeRoot HIERARCHYID= hierarchyid::GetRoot() ,
            @code HIERARCHYID ,
            @previous HIERARCHYID
        IF @ParentID IS NULL
            BEGIN
               
                SELECT 
                        @previous = MAX(CodeVirtual)
                FROM    dbo.ProjectTask
                WHERE   Grade = 1
                IF @previous IS NULL
                    BEGIN
                        SET @code = @codeRoot.GetDescendant(NULL, NULL)
                    END
                ELSE
                    BEGIN
                        SET @code = @codeRoot.GetDescendant(@previous, NULL)  
                    END
               
            END
        ELSE
            BEGIN
                DECLARE @grade INT
                SELECT  @code = CodeVirtual ,
                        @grade = Grade
                FROM    dbo.ProjectTask
                WHERE   ProjectTaskID = @ParentID		
				
                SELECT  @previous = MAX(CodeVirtual)
                FROM    dbo.ProjectTask
                WHERE   CodeVirtual.IsDescendantOf(@code) = 'TRUE'
                        AND Grade = @code.GetLevel() + 1
				
                SET @code = @code.GetDescendant(@previous, NULL)  
            END

	-- Return the result of the function
        RETURN @code

    END




GO
/****** Object:  UserDefinedFunction [dbo].[Func_GetTotalDayInMonth]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<dvthang>
-- Create date: <17.04.2017>
-- Description:	<Hàm lấy về tổng số ngày trong 1 tháng
-- select dbo.Func_GetTotalDayInMonth(4,2018)
-- =============================================
CREATE FUNCTION [dbo].[Func_GetTotalDayInMonth] ( @Month INT, @Year INT )
RETURNS INT
AS
    BEGIN
        DECLARE @Totalday INT
		--Tính số ngày
        IF @Month IN ( 1, 3, 5, 7, 8, 10, 12 )
            SET @Totalday = 31
        ELSE
            IF @Month IN ( 2, 4, 6, 9, 11 )
                BEGIN
                    IF @Month = 2
                        BEGIN
                            IF ( ( @Year % 4 = 0
                                   AND @Year % 100 != 0
                                 )
                                 OR @Year % 400 = 0
                               )
                                SET @Totalday = 29
                            ELSE
                                SET @Totalday = 28
                        END
                    ELSE
                        BEGIN
                            SET @Totalday = 30
                        END
                END
				-- Trả về
        RETURN @Totalday
    END




GO
/****** Object:  UserDefinedFunction [dbo].[Func_GetTotalDayOn_By_MonthYear]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<laipv>
-- Create date: <10.03.2018>
-- Description:	<Hàm lấy về tổng số ngày làm việc trong 1 tháng trừ thứ 7 và CN>
-- select dbo.Func_GetTotalDayInMonth(1, 2018)
-- =============================================
CREATE FUNCTION [dbo].[Func_GetTotalDayOn_By_MonthYear] ( @iMonth INT, @iYear INT )
RETURNS INT
AS 
    BEGIN
        DECLARE @total INT= 0
        DECLARE @dStart DATETIME= CAST(@iYear AS NVARCHAR(10)) + '/'
            + CAST(@iMonth AS NVARCHAR(10)) + '/01'
        DECLARE @dEnd DATETIME= @dStart ,
            @totaldays INT= 0
        IF @iMonth = 1
            OR @iMonth = 3
            OR @iMonth = 5
            OR @iMonth = 7
            OR @iMonth = 8
            OR @iMonth = 10
            OR @iMonth = 12 
            BEGIN
                SET @totaldays = 31
            END
        ELSE 
            IF @iMonth = 4
                OR @iMonth = 6
                OR @iMonth = 9
                OR @iMonth = 11 
                BEGIN
                    SET @totaldays = 30
                END
            ELSE 
                BEGIN
	     --Tháng 2
                    SET @totaldays = 28
                    IF @iYear % 400 = 0
                        OR ( @iYear % 4 = 0
                             AND @iYear % 100 <> 0
                           ) 
                        BEGIN
                            SET @totaldays = 29
                        END
                END
        SET @dEnd = CAST(@iYear AS NVARCHAR(10)) + '/'
            + CAST(@iMonth AS NVARCHAR(10)) + '/'
            + CAST(@totaldays AS NVARCHAR(10))
         
        
        WHILE ( @dEnd >= @dStart ) 
            BEGIN
                IF DATENAME(dw, @dStart) <> 'Saturday'
                    AND DATENAME(dw, @dStart) <> 'Sunday' 
                    SET @total = @total + 1
                SET @dStart = DATEADD(DAY, 1, @dStart)
            END 
        RETURN @total
    END




GO
/****** Object:  UserDefinedFunction [dbo].[Func_GroupFileContenExperimentIntoMaster]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<manh>
-- Create date: <26.02.2018>
-- Description:	<Gộp danh sách tệp đính kèm>
-- =============================================

CREATE FUNCTION [dbo].[Func_GroupFileContenExperimentIntoMaster] ( @ID UNIQUEIDENTIFIER )
RETURNS NVARCHAR(800)
AS
    BEGIN
	-- Declare the return variable here
        DECLARE @strID NVARCHAR(800)

        SET @strID = ( SELECT   CAST(ProjectExperiment_AttachDetailID AS NVARCHAR(36))
                                + ',' + FileType + '|'
                       FROM     dbo.ProjectExperiment_AttachDetail
                       WHERE    ID = @ID
                     FOR
                       XML PATH('')
                     );

        RETURN @strID

    END




GO
/****** Object:  UserDefinedFunction [dbo].[Func_GroupFileContenServeyIntoMaster]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<dvthang>
-- Create date: <25.02.2018>
-- Description:	<Gộp danh sách tệp đính kèm>
-- =============================================

CREATE FUNCTION [dbo].[Func_GroupFileContenServeyIntoMaster] ( @ID UNIQUEIDENTIFIER )
RETURNS NVARCHAR(800)
AS
    BEGIN
	-- Declare the return variable here
        DECLARE @strID NVARCHAR(800)

        SET @strID = ( SELECT   CAST(ProjectSurvey_AttachDetailID AS NVARCHAR(36))
                                + ',' + FileType + '|'
                       FROM     dbo.ProjectSurvey_AttachDetail
                       WHERE    ID = @ID
                     FOR
                       XML PATH('')
                     );

        RETURN @strID

    END




GO
/****** Object:  UserDefinedFunction [dbo].[Func_GroupFileProjectPlanPerformIntoMaster]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<truongnm>
-- Create date: <25.02.2018>
-- Description:	<Gộp danh sách tệp đính kèm của thông tin hội thảo>
-- =============================================

CREATE FUNCTION [dbo].[Func_GroupFileProjectPlanPerformIntoMaster] ( @ID UNIQUEIDENTIFIER )
RETURNS NVARCHAR(800)
AS
    BEGIN
	-- Declare the return variable here
        DECLARE @strID NVARCHAR(800)

        SET @strID = ( SELECT   CAST(ProjectPlanPerform_AttachDetailID AS NVARCHAR(36))
                               + ',' + FileType + ',' + left([Description]+'..........',10) +'...|'
                       FROM     dbo.ProjectPlanPerform_AttachDetail
                       WHERE    ProjectPlanPerformID = @ID
                     FOR
                       XML PATH('')
                     );

        RETURN @strID

    END




GO
/****** Object:  UserDefinedFunction [dbo].[Func_GroupFileProjectProgressReportIntoMaster]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<truongnm>
-- Create date: <25.02.2018>
-- Description:	<Gộp danh sách tệp đính kèm của thông tin hội thảo>
-- =============================================

CREATE FUNCTION [dbo].[Func_GroupFileProjectProgressReportIntoMaster] ( @ID UNIQUEIDENTIFIER )
RETURNS NVARCHAR(800)
AS
    BEGIN
	-- Declare the return variable here
        DECLARE @strID NVARCHAR(800)

        SET @strID = ( SELECT   CAST(ProjectProgressReport_AttachDetailID AS NVARCHAR(36))
                                + ',' + FileType + ',' + left([Description]+'..........',10) +'...|'
                       FROM     dbo.ProjectProgressReport_AttachDetail
                       WHERE    ProjectProgressReportID = @ID
                     FOR
                       XML PATH('')
                     );

        RETURN @strID

    END




GO
/****** Object:  UserDefinedFunction [dbo].[Func_GroupFileProjectWorkshopIntoMaster]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<dvthang>
-- Create date: <25.02.2018>
-- Description:	<Gộp danh sách tệp đính kèm của thông tin hội thảo>
-- =============================================

CREATE FUNCTION [dbo].[Func_GroupFileProjectWorkshopIntoMaster] ( @ID UNIQUEIDENTIFIER )
RETURNS NVARCHAR(800)
AS
    BEGIN
	-- Declare the return variable here
        DECLARE @strID NVARCHAR(800)

        SET @strID = ( SELECT   CAST(ProjectWorkshop_AttachDetailID AS NVARCHAR(36))
                                + ',' + FileType + '|'
                       FROM     dbo.ProjectWorkshop_AttachDetail
                       WHERE    ProjectWorkshopID = @ID
                     FOR
                       XML PATH('')
                     );

        RETURN @strID

    END




GO
/****** Object:  Table [dbo].[__MigrationHistory]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[__MigrationHistory](
	[MigrationId] [nvarchar](150) NOT NULL,
	[ContextKey] [nvarchar](300) NOT NULL,
	[Model] [varbinary](max) NOT NULL,
	[ProductVersion] [nvarchar](32) NOT NULL,
 CONSTRAINT [PK_dbo.__MigrationHistory] PRIMARY KEY CLUSTERED 
(
	[MigrationId] ASC,
	[ContextKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[AspNetRoles]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetRoles](
	[Id] [int] NOT NULL,
	[Name] [nvarchar](256) NOT NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedDate] [datetime] NULL,
	[IPAddress] [nvarchar](128) NULL,
	[ModifiedBy] [nvarchar](128) NULL,
	[CreatedBy] [nvarchar](128) NULL,
 CONSTRAINT [PK_dbo.AspNetRoles] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AspNetUserClaims]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserClaims](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [nvarchar](128) NOT NULL,
	[ClaimType] [nvarchar](max) NULL,
	[ClaimValue] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.AspNetUserClaims] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AspNetUserLogins]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserLogins](
	[LoginProvider] [nvarchar](128) NOT NULL,
	[ProviderKey] [nvarchar](128) NOT NULL,
	[UserId] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_dbo.AspNetUserLogins] PRIMARY KEY CLUSTERED 
(
	[LoginProvider] ASC,
	[ProviderKey] ASC,
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AspNetUserRoles]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserRoles](
	[UserId] [nvarchar](128) NOT NULL,
	[RoleId] [int] NOT NULL,
 CONSTRAINT [PK_dbo.AspNetUserRoles] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AspNetUsers]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUsers](
	[Id] [nvarchar](128) NOT NULL,
	[Email] [nvarchar](256) NULL,
	[EmailConfirmed] [bit] NOT NULL,
	[PasswordHash] [nvarchar](max) NULL,
	[SecurityStamp] [nvarchar](max) NULL,
	[PhoneNumber] [nvarchar](max) NULL,
	[PhoneNumberConfirmed] [bit] NOT NULL,
	[TwoFactorEnabled] [bit] NOT NULL,
	[LockoutEndDateUtc] [datetime] NULL,
	[LockoutEnabled] [bit] NOT NULL,
	[AccessFailedCount] [int] NOT NULL,
	[UserName] [nvarchar](256) NOT NULL,
	[GroupID] [int] NULL,
	[UserID] [int] NULL,
	[FullName] [nvarchar](50) NULL,
	[Address] [nvarchar](150) NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL,
	[IPAddress] [nvarchar](128) NULL,
	[ModifiedBy] [nvarchar](128) NULL,
	[CreatedBy] [nvarchar](128) NULL,
	[oId] [int] NULL,
 CONSTRAINT [PK_dbo.AspNetUsers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Customer]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customer](
	[CustomerID] [int] IDENTITY(400,1) NOT NULL,
	[CustomerCode] [nvarchar](64) NULL,
	[CustomerName] [nvarchar](255) NULL,
	[CustomerGender] [int] NULL,
	[DOB] [datetime] NULL,
	[HealthCareNumber] [nvarchar](255) NULL,
	[Tel] [nvarchar](64) NULL,
	[Email] [nvarchar](255) NULL,
	[Address] [nvarchar](255) NULL,
	[CustomerGroup] [nvarchar](255) NULL,
	[CustomerDescription] [nvarchar](max) NULL,
	[PresenterName] [nvarchar](255) NULL,
	[PresenterPhone] [nvarchar](255) NULL,
	[PresenterAddress] [nvarchar](255) NULL,
	[PresenterIDC] [nvarchar](255) NULL,
	[Relationship] [nvarchar](255) NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedDate] [datetime] NULL,
	[IPAddress] [nvarchar](128) NULL,
	[ModifiedBy] [nvarchar](128) NULL,
	[CreatedBy] [nvarchar](128) NULL,
 CONSTRAINT [PK_Customer] PRIMARY KEY CLUSTERED 
(
	[CustomerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MeasurementParameter]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MeasurementParameter](
	[MeasurementParameterID] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](128) NULL,
	[ViName] [nvarchar](128) NULL,
	[EnName] [nvarchar](128) NULL,
	[Symbol] [nvarchar](128) NULL,
	[UnitOfMeasure] [nvarchar](128) NULL,
	[Description] [nvarchar](255) NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_MeasurementParameter_CreatedDate]  DEFAULT (getdate()),
	[ModifiedDate] [datetime] NULL CONSTRAINT [DF_MeasurementParameter_ModifiedDate]  DEFAULT (getdate()),
	[IPAddress] [nvarchar](128) NULL CONSTRAINT [DF_MeasurementParameter_IPAddress]  DEFAULT (N''),
	[ModifiedBy] [nvarchar](128) NULL CONSTRAINT [DF_MeasurementParameter_ModifiedBy]  DEFAULT (N''),
	[CreatedBy] [nvarchar](128) NULL CONSTRAINT [DF_MeasurementParameter_CreatedBy]  DEFAULT (N''),
 CONSTRAINT [PK_MeasurementParameter] PRIMARY KEY CLUSTERED 
(
	[MeasurementParameterID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MeasurementStandard]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MeasurementStandard](
	[MeasurementStandardID] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](64) NULL,
	[FullName] [nvarchar](255) NULL,
	[ShortName] [nvarchar](50) NULL,
	[Description] [nvarchar](255) NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_MeasurementStandard_CreatedDate]  DEFAULT (getdate()),
	[ModifiedDate] [datetime] NULL CONSTRAINT [DF_MeasurementStandard_ModifiedDate]  DEFAULT (getdate()),
	[IPAddress] [nvarchar](128) NULL CONSTRAINT [DF_MeasurementStandard_IPAddress]  DEFAULT (N''),
	[ModifiedBy] [nvarchar](128) NULL CONSTRAINT [DF_MeasurementStandard_ModifiedBy]  DEFAULT (N''),
	[CreatedBy] [nvarchar](128) NULL CONSTRAINT [DF_MeasurementStandard_CreatedBy]  DEFAULT (N''),
 CONSTRAINT [PK_MeasurementStandard] PRIMARY KEY CLUSTERED 
(
	[MeasurementStandardID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MeasurementStandardParameter]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MeasurementStandardParameter](
	[MeasurementStandardParameterID] [int] IDENTITY(1,1) NOT NULL,
	[MeasurementStandardID] [int] NOT NULL,
	[MeasurementParameterID] [int] NULL,
	[C_Min] [decimal](18, 4) NULL,
	[C_Max] [decimal](18, 4) NULL,
	[C_Text] [nvarchar](255) NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_MeasurementStandardParameter_CreatedDate]  DEFAULT (getdate()),
	[ModifiedDate] [datetime] NULL CONSTRAINT [DF_MeasurementStandardParameter_ModifiedDate]  DEFAULT (getdate()),
	[IPAddress] [nvarchar](128) NULL CONSTRAINT [DF_MeasurementStandardParameter_IPAddress]  DEFAULT (N''),
	[ModifiedBy] [nvarchar](128) NULL CONSTRAINT [DF_MeasurementStandardParameter_ModifiedBy]  DEFAULT (N''),
	[CreatedBy] [nvarchar](128) NULL CONSTRAINT [DF_MeasurementStandardParameter_CreatedBy]  DEFAULT (N''),
 CONSTRAINT [PK_MeasurementStandardParameter] PRIMARY KEY CLUSTERED 
(
	[MeasurementStandardParameterID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MedicalRecord]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MedicalRecord](
	[MedicalRecordID] [int] IDENTITY(1,1) NOT NULL,
	[CustomerID] [int] NULL,
	[AppliedStandardID] [int] NULL,
	[MedicalRecordDescription] [nvarchar](255) NULL,
	[MedicalRecordLocation] [nvarchar](255) NULL,
	[MedicalRecordDate] [datetime] NULL,
	[FinalResult] [nvarchar](255) NULL,
	[CreatedBy] [nvarchar](128) NULL,
	[ModifiedBy] [nvarchar](128) NULL,
	[IPAddress] [nvarchar](128) NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_MedicalRecoed] PRIMARY KEY CLUSTERED 
(
	[MedicalRecordID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[News]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[News](
	[NewsID] [int] IDENTITY(1,1) NOT NULL,
	[NewsTittle] [nvarchar](128) NOT NULL,
	[NewContent] [nvarchar](1000) NOT NULL,
	[ExpiredDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedDate] [datetime] NULL,
	[IPAddress] [nvarchar](128) NULL,
	[ModifiedBy] [nvarchar](128) NULL,
	[CreatedBy] [nvarchar](128) NULL,
 CONSTRAINT [PK_News] PRIMARY KEY CLUSTERED 
(
	[NewsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[QADetail]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QADetail](
	[QADetailID] [int] IDENTITY(1,1) NOT NULL,
	[QATopicID] [int] NOT NULL,
	[QuestionContent] [nvarchar](3500) NOT NULL CONSTRAINT [DF_QADetail_QAType]  DEFAULT ((0)),
	[AnswerContent] [nvarchar](3500) NULL,
	[PublicState] [bit] NULL CONSTRAINT [DF_QADetail_PublicState]  DEFAULT ((0)),
	[QuestionBy] [nvarchar](128) NULL CONSTRAINT [DF_QADetail_CreatedBy]  DEFAULT (N''),
	[QuestionDate] [datetime] NULL CONSTRAINT [DF_QADetail_CreatedDate]  DEFAULT (getdate()),
	[AnswerBy] [nvarchar](128) NULL,
	[AnswerDate] [datetime] NULL CONSTRAINT [DF_QADetail_AnswerDate]  DEFAULT (getdate()),
	[ModifiedDate] [datetime] NULL CONSTRAINT [DF_QADetail_ModifiedDate]  DEFAULT (getdate()),
	[ModifiedBy] [nvarchar](128) NULL CONSTRAINT [DF_QADetail_ModifiedBy]  DEFAULT (N''),
	[IPAddress] [nvarchar](128) NULL CONSTRAINT [DF_QADetail_IPAddress]  DEFAULT (N''),
 CONSTRAINT [PK_QADetail] PRIMARY KEY CLUSTERED 
(
	[QADetailID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[QATopic]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QATopic](
	[QATopicID] [int] IDENTITY(1,1) NOT NULL,
	[QATopicCode] [nvarchar](64) NULL,
	[QATopicName] [nvarchar](128) NULL,
	[Description] [nvarchar](255) NULL,
	[Inactive] [bit] NULL CONSTRAINT [DF_QATopic_Inactive]  DEFAULT ((0)),
	[SortOrder] [int] NULL CONSTRAINT [DF_QATopic_SortOrder]  DEFAULT ((0)),
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_QATopic_CreatedDate]  DEFAULT (getdate()),
	[ModifiedDate] [datetime] NULL CONSTRAINT [DF_QATopic_ModifiedDate]  DEFAULT (getdate()),
	[IPAddress] [nvarchar](128) NULL CONSTRAINT [DF_QATopic_IPAddress]  DEFAULT (N''),
	[ModifiedBy] [nvarchar](128) NULL CONSTRAINT [DF_QATopic_ModifiedBy]  DEFAULT (N''),
	[CreatedBy] [nvarchar](128) NULL CONSTRAINT [DF_QATopic_CreatedBy]  DEFAULT (N''),
 CONSTRAINT [PK_QATopic] PRIMARY KEY CLUSTERED 
(
	[QATopicID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[StatusViewNotifications]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StatusViewNotifications](
	[CompanyID] [int] NOT NULL,
	[StatusViewNotifications] [bit] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Tokens]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Tokens](
	[TokenId] [uniqueidentifier] NOT NULL CONSTRAINT [DF_Tokens_TokenId]  DEFAULT (newid()),
	[UserName] [varchar](50) NULL,
	[Token] [nvarchar](max) NULL,
	[ExpiresOn] [datetime] NULL,
	[IssuedOn] [datetime] NULL,
 CONSTRAINT [PK_Tokens_1] PRIMARY KEY CLUSTERED 
(
	[TokenId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  UserDefinedFunction [dbo].[Func_ConvertGuidIntoTable]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Func_ConvertGuidIntoTable]
(
    @String NVARCHAR(4000),
    @Delimiter NCHAR(1)
)
RETURNS TABLE
AS
RETURN
(
    WITH Split(stpos,endpos)
    AS(
        SELECT 0 AS stpos, CHARINDEX(@Delimiter,@String) AS endpos
        UNION ALL
        SELECT endpos+1, CHARINDEX(@Delimiter,@String,endpos+1)
            FROM Split
            WHERE endpos > 0
    )
    SELECT 
        'Value' = SUBSTRING(@String,stpos,COALESCE(NULLIF(endpos,0),LEN(@String)+1)-stpos)
    FROM Split
)



GO
/****** Object:  View [dbo].[View_DayOff]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[View_DayOff]
AS
    SELECT  ROW_NUMBER() OVER ( ORDER BY D.Date DESC ) AS SortOrder ,
            D.DayOffID ,
            D.Date ,
            D.Description ,
            D.Inactive
    FROM    dbo.DayOff AS D







GO
/****** Object:  View [dbo].[View_Employee]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[View_Employee]
AS
SELECT        EmployeeID, CompanyID, EmployeeCode, FirstName, LastName, FullName, RankID, Gender, AcademicRankID, YearOfAcademicRank, DegreeID, YearOfDegree, PositionID, CAST(BirthDay AS DATE) AS BirthDay, BirthPlace, 
                         HomeLand, NativeAddress, Tel, HomeTel, Mobile, Fax, Email, OfficeAddress, HomeAddress, Website, Description, FileResourceID, Inactive, IDNumber, IssuedBy, DateBy, AccountNumber, Bank
FROM            dbo.Employee AS E




GO
/****** Object:  View [dbo].[View_GrantRatio]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[View_GrantRatio]
AS
SELECT        dbo.GrantRatio.*
FROM            dbo.GrantRatio




GO
/****** Object:  View [dbo].[View_Project]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[View_Project]
AS
SELECT        dbo.Project.ProjectID, dbo.Project.ProjectCode, dbo.Project.ProjectName, dbo.Project.StartDate, dbo.Project.EndDate, dbo.Project.CompanyID, dbo.Project.EmployeeID, dbo.Project.Amount, dbo.Project.Amount_Level1, 
                         dbo.Project.Amount_Level2, dbo.Project.Amount_Other, dbo.Project.Program, dbo.Project.ProgramName, dbo.Project.ProjectScience, dbo.Project.ProjectScienceName, dbo.Project.IndependentTopic, dbo.Project.Nature, 
                         dbo.Project.AFF, dbo.Project.Technical, dbo.Project.Pharmacy, dbo.Project.Result, dbo.Project.CompanyApply, dbo.Project.Description, dbo.Project.Status, dbo.Project.LevelID, dbo.Project.ProjectChairman, 
                         dbo.Project.ProjectSecretary, dbo.Project.ProjectMember, dbo.Project.ProjectCompanyChair, dbo.Project.ProjectCompanyCombination, dbo.Project.Inactive, dbo.Project.SortOrder, dbo.Employee.FullName AS EmployeeName, 
                         dbo.Project.CreatedBy, dbo.ProjectPresentProtected.ProtectedDate AS PresentProtectedDate, dbo.ProjectExpenseProtected.ProtectedDate AS ExpenseProtectedDate, dbo.ProjectClose.Date AS CloseDate, CAST(1 AS BIT) 
                         AS IsProject, 
                         CASE WHEN Project.Status = 11 THEN N'Đang đề xuất' WHEN Project.Status = 12 THEN N'Đang xét duyệt' WHEN Project.Status = 13 THEN N'Đã gửi lên cấp trên' WHEN Project.Status = 14 THEN N'Đã phê duyệt' WHEN Project.Status =
                          21 THEN N'Đã đưa vào thực hiện' WHEN Project.Status = 22 THEN N'Chờ nghiệm thu' WHEN Project.Status = 23 THEN N'Đã nghiệm thu cấp cơ sở' WHEN Project.Status = 24 THEN N'Đã nghiệm thu cấp quản lý' WHEN Project.Status = 31 THEN
                          N'Đã đóng đề tài' ELSE N'' END AS StatusName, dbo.Project.ProjectNameAbbreviation, dbo.Project.GrantRatioID, dbo.Project.MonthFin, dbo.Project.YearFin
FROM            dbo.Project LEFT OUTER JOIN
                         dbo.Employee ON dbo.Project.EmployeeID = dbo.Employee.EmployeeID LEFT OUTER JOIN
                         dbo.ProjectPresentProtected ON dbo.Project.ProjectID = dbo.ProjectPresentProtected.ProjectID LEFT OUTER JOIN
                         dbo.ProjectExpenseProtected ON dbo.Project.ProjectID = dbo.ProjectExpenseProtected.ProjectID LEFT OUTER JOIN
                         dbo.ProjectClose ON dbo.Project.ProjectID = dbo.ProjectClose.ProjectID




GO
/****** Object:  View [dbo].[View_ProjectMember]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[View_ProjectMember]
AS
SELECT        dbo.ProjectMember.ProjectMemberID, dbo.ProjectMember.ProjectID, dbo.ProjectMember.EmployeeID, dbo.ProjectMember.StartDate, dbo.ProjectMember.EndDate, dbo.ProjectMember.MonthForProject, 
                         dbo.ProjectMember.Inactive, dbo.ProjectMember.ProjectPositionID, dbo.ProjectMember.CreatedDate, dbo.ProjectMember.SortOrder, dbo.ProjectMember.ModifiedDate, dbo.ProjectMember.IPAddress, 
                         dbo.ProjectMember.ModifiedBy, dbo.ProjectMember.CreatedBy, dbo.ProjectPosition.ProjectPositionName, dbo.Employee.LastName + N' ' + dbo.Employee.FirstName AS EmployeeName, dbo.Employee.FullName
FROM            dbo.ProjectMember LEFT OUTER JOIN
                         dbo.ProjectPosition ON dbo.ProjectMember.ProjectPositionID = dbo.ProjectPosition.ProjectPositionID LEFT OUTER JOIN
                         dbo.Employee ON dbo.ProjectMember.EmployeeID = dbo.Employee.EmployeeID




GO
/****** Object:  View [dbo].[View_ProjectPlanExpense]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[View_ProjectPlanExpense]
AS
SELECT        dbo.ProjectPlanExpense.*
FROM            dbo.ProjectPlanExpense




GO
/****** Object:  View [dbo].[View_ProjectPlanExpense_AttachDetail]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[View_ProjectPlanExpense_AttachDetail]
AS
SELECT        dbo.ProjectPlanExpense_AttachDetail.*
FROM            dbo.ProjectPlanExpense_AttachDetail




GO
/****** Object:  View [dbo].[View_ProjectPlanPerform]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[View_ProjectPlanPerform]
AS
SELECT        dbo.ProjectPlanPerform.*
FROM            dbo.ProjectPlanPerform




GO
/****** Object:  View [dbo].[View_ProjectPlanPerform_AttachDetail]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[View_ProjectPlanPerform_AttachDetail]
AS
SELECT        dbo.ProjectPlanPerform_AttachDetail.*
FROM            dbo.ProjectPlanPerform_AttachDetail




GO
/****** Object:  View [dbo].[View_ProjectPosition]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[View_ProjectPosition]
AS
SELECT        dbo.Project.ProjectID, dbo.Project.ProjectName, dbo.ProjectPosition.ProjectPositionName, dbo.Employee.FullName, dbo.ProjectPosition.ProjectPositionID, dbo.ProjectPosition.ProjectPositionCode
FROM            dbo.Project INNER JOIN
                         dbo.ProjectMember ON dbo.Project.ProjectID = dbo.ProjectMember.ProjectID INNER JOIN
                         dbo.Employee ON dbo.ProjectMember.EmployeeID = dbo.Employee.EmployeeID INNER JOIN
                         dbo.ProjectPosition ON dbo.ProjectMember.ProjectPositionID = dbo.ProjectPosition.ProjectPositionID




GO
/****** Object:  View [dbo].[View_ProjectProgressReport]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[View_ProjectProgressReport]
AS
SELECT        ProjectProgressReportID, ProjectID, TermID, TermName, DateReport, DateCheck, Result, CASE Result WHEN 11 THEN N'Đảm bảo tiến độ' WHEN 12 THEN N'Chậm tiến độ' END AS Result_sTen, Inactive, SortOrder, CreatedDate, 
                         ModifiedDate, IPAddress, ModifiedBy, CreatedBy, IdFiles
FROM            dbo.ProjectProgressReport




GO
/****** Object:  View [dbo].[View_ProjectProgressReport_AttachDetail]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[View_ProjectProgressReport_AttachDetail]
AS
SELECT        dbo.ProjectProgressReport_AttachDetail.*
FROM            dbo.ProjectProgressReport_AttachDetail




GO
/****** Object:  View [dbo].[View_ProjectTaskMember]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[View_ProjectTaskMember]
AS
SELECT        dbo.ProjectTaskMember.ProjectTaskMemberID, dbo.ProjectTaskMember.ProjectTaskID, dbo.ProjectTaskMember.EmployeeID, dbo.ProjectTaskMember.StartDate, dbo.ProjectTaskMember.EndDate, 
                         dbo.ProjectTaskMember.MonthForTask, dbo.ProjectTaskMember.SortOrder, dbo.ProjectTaskMember.CreatedDate, dbo.ProjectTaskMember.ModifiedDate, dbo.ProjectTaskMember.IPAddress, dbo.ProjectTaskMember.ModifiedBy, 
                         dbo.ProjectTaskMember.CreatedBy, dbo.Employee.LastName + N' ' + dbo.Employee.FirstName AS EmployeeName, dbo.Employee.FullName
FROM            dbo.ProjectTaskMember INNER JOIN
                         dbo.Employee ON dbo.ProjectTaskMember.EmployeeID = dbo.Employee.EmployeeID




GO
INSERT [dbo].[__MigrationHistory] ([MigrationId], [ContextKey], [Model], [ProductVersion]) VALUES (N'201710171449338_InitialCreate', N'APIBE.Models.ApplicationDbContext', 0x1F8B0800000000000400DD5CDB6EDC36107D2FD07F10F4D416CECA9726488DDD04CEDA6E8DC617649DA06F0157E2AE8548942A518E8DA25FD6877E527FA14389BAF1A2CBAEBCBB0E0A1459717866381C92C3D191FFFBE7DFF1DB07DF33EE7114BB01999807A37DD3C0C40E1C972C276642172F5E9B6FDF7CFFDDF8CCF11F8C4FB9DC1193839E249E98779486C79615DB77D847F1C877ED288883051DD9816F2127B00EF7F77FB10E0E2C0C10266019C6F84342A8EBE3F407FC9C06C4C6214D90771938D88BF9736899A5A8C615F2711C221B4FCC939B8B7767A34CCE344E3C17810D33EC2D4C0311125044C1C2E38F319ED12820CB59080F9077FB1862905B202FC6DCF2E352BCEB20F60FD920ACB2630E6527310DFC9E800747DC2B96D87D25DF9A85D7C06F67E05FFAC8469DFA6E625E38387DF421F0C001A2C2E3A91731E1897959A83889C32B4C4779C75106791E01DCD720FA32AA22EE199DFBED15517438DA67FFED19D3C4A349842704273442DE9E7193CC3DD7FE1D3FDE065F30991C1DCC1747AF5FBE42CED1AB9FF1D1CBEA4861AC20577B008F6EA220C411D88617C5F84DC3AAF7B3C48E45B74A9FCC2B104BB0204CE3123DBCC76449EF60A91CBE368D73F7013BF9131E5C1F890BEB073AD128819F5789E7A1B9878B76AB5127FB7F83D6C397AF06D17A85EEDD653AF5827E583811ACAB0FD84B5BE33B37CC96576DBE3F73B1F328F0D9EF7A7C65AD9F674112D96C308156E416454B4CEBD68DAD32783B8534831A3EAC73D4DD0F6D66A91CDE4A5136A0555642AE62D3AB21B7F769F5768EB8933084C94B438B79A429E0AAC7D448E8B767A4AD65B81C740D1702C3F89677BF331FB9DE00DB5F072D90732CDCC8C7C528DF05106C88F4B6F906C531AC7EE73714DF35980EFF1CC0F419B69308827246911F3EB9B69BBB80E0ABC49FB358DF9CAEC1A6E6F66B708E6C1A446784F55A1BEF7D607F09127A469C5344F1476AE780ECE7ADEB770718C49C13DBC6717C0EC18C9D690029750E7841E8D1616F38B6356D3BFD987AC8F5D5F987B0897ECE45CB1C442D21E5211A31552ED264EAFB60E9926EA6E6A27A5333895653B9585F531958374BB9A4DED054A0D5CE4C6AB0EC2E9DA1E1D3BB1476F7F3BBF50E6FDD5E5071E30C7648FC2B2638826DCCB94194E2889433D065DFD846B2904E1F53FAE46753AAE913F292A155ADB41AD24D60F8D590C2EEFE6A48CD84C7F7AEC3B2920E979E5C18E03BC9ABEF53ED6B4EB06CD3CBA136CC4D2BDFCC1EA05B2E27711CD86EBA0A14E52E5EACA8DB0F399CD15EB9C84623563F606010E82E3BF2E0098CCD1483EA9A9C620F536C9CD85939708A621B39B21B61404E0FC3F2135561585905A91BF793A413221D47AC136297A01856AA4BA8BC2C5C62BB21F25ABD24F4EC7884B1B1173AC496531C62C214B67AA28B7275D1831950E81126A5CD4363AB1271CD81A8C95A7573DE96C296F32ED5223612932DB9B3262E79FEF62481D9ECB10D0467B34BBA18A02DE06D2340F95DA56B008817975D0B50E1C6A409509E526D2440EB1EDB4280D65DF2EC0234BBA2769D7FE1BEBA6BE159BF286FFE586F74D71662B3E68F1D0BCD2CF7843E147AE0480ECFD3396BC40F547139033BF9FD2CE6A9AE18220C7C8669BD6453E6BBCA3CD46A061183A809B00CB41650FEEA4F029216540FE3F25A5EA3753C8BE8019BD7DD1A61F9DE2FC0566240C6AEBE02AD08EA5F948AC1D9E9F6518CAC880629C83B5D162A388A801037AFFAC03B38455797951DD32517EE930D5706C627A3C1412D99ABC649F96006F7521E9AED5E5225647D52B2B5BC24A44F1A2FE58319DC4B3C46DB9DA4480A7AA4056BB9A87E840FB4D8F24A4771DA146D632BE344F107634B439E1A5FA23074C9B242A6E24F8C59C6A49ABE98F5271AF9198665C70ABE51616DA18906115A62A1155483A5E76E14D35344D11CB13ACFD4F12531E5D9AAD9FE7395D5E3539EC4FC1CC8A5D9BF79E8555FD8D74E59390DE1BDCF616C3ECB65D202BA62E6D5DD0D466B431E8A1435FB69E0253ED1A756FADED99BBB6AFFEC898C30B604FBA5D449F29394E0D69DDE694AE4E5B0F6F41439CBEA53A487D0393ACF38ABAED665A17A94BC285545D115AAB63665BAE4A5E334891961FF596A45789AB5C469285500FEA8274685C9208155DABAA3D6C92655CC7A4B774481515285149A7A5859E58DD48CAC36AC84A7F1A85AA2BB0699295245975BBB232B3823556845F30AD80A9BC5B6EEA80A5A491558D1DC1DBBE49888DBE70E9F56DA7BCA0AC75576895DEFBCD2603CCD5E38CC715779575F05AA3CEE89C5DFC64B60FCF94EC691F626B7421C65558BF5E24883A1DF6D6AEFB7EB9B4DE34B793D66EDA5756D436F7A69AFC7EB17AD4F1A13D2154E1429B4175739E1CA36E6D7A7F68F62A4FB5426621AB91BE1307F8C29F6474C6034FBD39B7A2E665B772E708988BBC031CD881AE6E1FEC1A1F075CDEE7CE962C5B1E329AE9FBACF5DEA73B601CE15B947917D87229901B1C6D72025A8545CBE200E7E98987FA5BD8ED33A05FB57FA78CFB8883F12F7CF041A6EA3041B7FCB8CCE61D8F1CD57AA1DFD96A1BB572FFEF89C75DD33AE235831C7C6BEE0CB5566B8FE85432F6BB2AE6B58B3F2770FCF7741D53E3050A20A0B62F5EF09E62E1DE45B82DCCA1F7CF4F0635FD394DF0BAC85A8F8266028BC415CA8E3FCAF82A5E5FB3BF093A67CFF7E8355F3FF57314DCBFD77497F3091F9DF7D1BCA7B6EF1A851DC8636B125A57E6E654EAF45A3DCF6D92411ACD75AE83289BA07DC1A44E91522E399718C073B1D1514E2C1B0B719DA4FCE1BDE15AA7049E2D82E437893A4E0869740DF14177807D86B0A36CEF619BF9B8E355D0577C76993FD78BD3B166C9CA3B57DF6EEA6834D57E6DDF160EBC5D1DDB158DBD6F9B9E548EB7C846E9D712B9387346F6254B5E036466D5638871BFE3C8020C832CAEC43483585AB897EDAA2B014D12BD573C744C5D2C291F44A12CD6AFB8D951FF88D83E532CD6A358CCB26DD7CFF6FD4CD659A756B788CDBE0022B99842A7E76CB3ED644797A4EDCDFDA485AA8E66D396BE36BF5E744F51DC429B5D5A37947FC7C98BD83B864C8A5D383C92BBFEE85B3B3F29712E1FC8EDD6509C1FE6E22C176EDD42C642EC822C80F6FC1A25C44A8D05C628A1C38524F22EA2E904DA199D598D32FB9D3BA1D7BD331C7CE05B94E6898501832F6E75EADE0C5928026FD295DB96EF3F83A4CFF28C9104300335D569BBF26EF12D7730ABBCF1535210D04CB2E784597CD256595DDE563817415908E40DC7D4552748BFDD003B0F89ACCD03D5EC53608BFF77889ECC7B202A803699F88BADBC7A72E5A46C88F3946D91F7E420C3BFEC39BFF01B7BACB3B30540000, N'6.1.3-40302')
INSERT [dbo].[AspNetRoles] ([Id], [Name], [CreatedDate], [ModifiedDate], [IPAddress], [ModifiedBy], [CreatedBy]) VALUES (-1, N'Administrator', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[AspNetRoles] ([Id], [Name], [CreatedDate], [ModifiedDate], [IPAddress], [ModifiedBy], [CreatedBy]) VALUES (0, N'Default', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[AspNetRoles] ([Id], [Name], [CreatedDate], [ModifiedDate], [IPAddress], [ModifiedBy], [CreatedBy]) VALUES (1, N'Quản trị hệ thống(Quản trị)', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[AspNetRoles] ([Id], [Name], [CreatedDate], [ModifiedDate], [IPAddress], [ModifiedBy], [CreatedBy]) VALUES (2, N'Quản trị nội dung (Quản trị)', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[AspNetRoles] ([Id], [Name], [CreatedDate], [ModifiedDate], [IPAddress], [ModifiedBy], [CreatedBy]) VALUES (3, N'Quản trị hệ thống(Người dùng)', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[AspNetRoles] ([Id], [Name], [CreatedDate], [ModifiedDate], [IPAddress], [ModifiedBy], [CreatedBy]) VALUES (5, N'Quản trị nội dung(Người dùng)', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[AspNetRoles] ([Id], [Name], [CreatedDate], [ModifiedDate], [IPAddress], [ModifiedBy], [CreatedBy]) VALUES (6, N'Tài khoản bị khóa(Quản trị)', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[AspNetRoles] ([Id], [Name], [CreatedDate], [ModifiedDate], [IPAddress], [ModifiedBy], [CreatedBy]) VALUES (7, N'Tài khoản bị khóa(Người dùng)', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[AspNetRoles] ([Id], [Name], [CreatedDate], [ModifiedDate], [IPAddress], [ModifiedBy], [CreatedBy]) VALUES (8, N'Nhóm Tổng công ty, Tập đoàn (Người dùng)', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[AspNetRoles] ([Id], [Name], [CreatedDate], [ModifiedDate], [IPAddress], [ModifiedBy], [CreatedBy]) VALUES (9, N'Nhóm Công ty trực thuộc Tổng công ty, Tập đoàn (Người dùng)', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[AspNetRoles] ([Id], [Name], [CreatedDate], [ModifiedDate], [IPAddress], [ModifiedBy], [CreatedBy]) VALUES (10, N'Nhóm Sở ban ngành trực thuộc các Tỉnh, Thành phố (Người dùng)', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[AspNetRoles] ([Id], [Name], [CreatedDate], [ModifiedDate], [IPAddress], [ModifiedBy], [CreatedBy]) VALUES (11, N'Nhóm người dùng cơ quan quản lý, xem dữ liệu, thống kê báo cáo dữ liệu', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[AspNetRoles] ([Id], [Name], [CreatedDate], [ModifiedDate], [IPAddress], [ModifiedBy], [CreatedBy]) VALUES (12, N'Nhóm Cơ quan Quản lý khai báo', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[AspNetRoles] ([Id], [Name], [CreatedDate], [ModifiedDate], [IPAddress], [ModifiedBy], [CreatedBy]) VALUES (13, N'Quản trị tài khoản', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[AspNetUsers] ([Id], [Email], [EmailConfirmed], [PasswordHash], [SecurityStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEndDateUtc], [LockoutEnabled], [AccessFailedCount], [UserName], [GroupID], [UserID], [FullName], [Address], [ModifiedDate], [CreatedDate], [IPAddress], [ModifiedBy], [CreatedBy], [oId]) VALUES (N'33a7ebe4-3eef-4933-9deb-f524d21f3f81', N'haigv@gemvietnam.com', 0, N'AMf1H4DEyilrx6NkKWCEgxgjBDVehyo77yy8vqquinmDqDYhofASulr+MgEoSSVZZg==', N'a1583699-54c5-42d2-af07-53476ca0104e', N'0965186738', 0, 0, NULL, 0, 0, N'haigv', -1, 111, N'Giang Văn Hải', N'Hà Nội', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[AspNetUsers] ([Id], [Email], [EmailConfirmed], [PasswordHash], [SecurityStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEndDateUtc], [LockoutEnabled], [AccessFailedCount], [UserName], [GroupID], [UserID], [FullName], [Address], [ModifiedDate], [CreatedDate], [IPAddress], [ModifiedBy], [CreatedBy], [oId]) VALUES (N'33a7ebe4-3eef-4933-9deb-f524d21f3f82', N'haigv@gemvietnam.com', 0, N'AMf1H4DEyilrx6NkKWCEgxgjBDVehyo77yy8vqquinmDqDYhofASulr+MgEoSSVZZg==', N'', N'0965186738', 0, 0, CAST(N'2019-05-14 03:34:54.620' AS DateTime), 0, 0, N'tungpm', 1, 401, N'Phạm Minh tùng', N'Hà Nội', CAST(N'2019-05-14 03:34:54.753' AS DateTime), CAST(N'2019-05-14 03:34:54.753' AS DateTime), N'', N'haigv', N'haigv', 0)
INSERT [dbo].[AspNetUsers] ([Id], [Email], [EmailConfirmed], [PasswordHash], [SecurityStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEndDateUtc], [LockoutEnabled], [AccessFailedCount], [UserName], [GroupID], [UserID], [FullName], [Address], [ModifiedDate], [CreatedDate], [IPAddress], [ModifiedBy], [CreatedBy], [oId]) VALUES (N'33a7ebe4-3eef-4933-9deb-f524d21f3f92', N'haigv@gemvietnam.com', 0, N'AMf1H4DEyilrx6NkKWCEgxgjBDVehyo77yy8vqquinmDqDYhofASulr+MgEoSSVZZg==', N'', N'0989142280', 0, 0, CAST(N'2019-05-14 03:35:53.570' AS DateTime), 0, 0, N'datgv', 1, 402, N'Giang Van Dat', N'HN', CAST(N'2019-05-14 03:35:53.577' AS DateTime), CAST(N'2019-05-14 03:35:53.577' AS DateTime), N'', N'haigv', N'haigv', 0)
INSERT [dbo].[AspNetUsers] ([Id], [Email], [EmailConfirmed], [PasswordHash], [SecurityStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEndDateUtc], [LockoutEnabled], [AccessFailedCount], [UserName], [GroupID], [UserID], [FullName], [Address], [ModifiedDate], [CreatedDate], [IPAddress], [ModifiedBy], [CreatedBy], [oId]) VALUES (N'8f3edce2-42f3-445a-95c1-8d1dd6f185b8', N'haigv@gemvietnam.com', 0, N'AMf1H4DEyilrx6NkKWCEgxgjBDVehyo77yy8vqquinmDqDYhofASulr+MgEoSSVZZg==', N'', N'0965186738', 0, 0, CAST(N'2019-05-14 03:35:47.497' AS DateTime), 0, 0, N'harrisonwells', 1, 400, N'Harrison Wells', N'New York', CAST(N'2019-05-14 03:35:47.500' AS DateTime), CAST(N'2019-05-14 03:35:47.500' AS DateTime), N'', N'haigv', N'haigv', 0)
SET IDENTITY_INSERT [dbo].[Customer] ON 

INSERT [dbo].[Customer] ([CustomerID], [CustomerCode], [CustomerName], [CustomerGender], [DOB], [HealthCareNumber], [Tel], [Email], [Address], [CustomerGroup], [CustomerDescription], [PresenterName], [PresenterPhone], [PresenterAddress], [PresenterIDC], [Relationship], [CreatedDate], [ModifiedDate], [IPAddress], [ModifiedBy], [CreatedBy]) VALUES (400, N'001099012345', N'Nguyễn Văn A', 1, CAST(N'2019-04-22 00:00:00.000' AS DateTime), N'005-123-14252', N'0923564823', N'mtcongthuong@gmail.com', N'Cầu Giấy Hà Nội', N'<1 tuổi', N'Không có mô tả', N'Nguyễn Văn BA', N'0923564823', N'Cầu Giấy Hà Nội', N'001099012345', N'Bố', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[Customer] ([CustomerID], [CustomerCode], [CustomerName], [CustomerGender], [DOB], [HealthCareNumber], [Tel], [Email], [Address], [CustomerGroup], [CustomerDescription], [PresenterName], [PresenterPhone], [PresenterAddress], [PresenterIDC], [Relationship], [CreatedDate], [ModifiedDate], [IPAddress], [ModifiedBy], [CreatedBy]) VALUES (401, N'035185947294', N'Phạm Minh Tùng', 1, CAST(N'1992-06-16 00:00:00.000' AS DateTime), N'013-532-12674', N'0912947858', N'haigv@gemvietnam.com', N'Bắc Từ Liêm Hà Nội', N'20-30 tuổi', N'Không có mô tả', N'Nguyễn Thị Thúy', N'0985828492', N'Thái Bình', N'001170285932', N'Mẹ', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[Customer] ([CustomerID], [CustomerCode], [CustomerName], [CustomerGender], [DOB], [HealthCareNumber], [Tel], [Email], [Address], [CustomerGroup], [CustomerDescription], [PresenterName], [PresenterPhone], [PresenterAddress], [PresenterIDC], [Relationship], [CreatedDate], [ModifiedDate], [IPAddress], [ModifiedBy], [CreatedBy]) VALUES (402, N'', N'Giang Văn Đạt', 0, CAST(N'1997-06-17 00:00:00.000' AS DateTime), N'003-123-99204', N'1234567690', N'haigv1997@gmail.com', N'Hà nội', N'sinh viên', N'không', N'Giang Văn A', N'0963672222', N'Hà nội', N'0010750123953', N'bố', CAST(N'2019-05-12 21:45:05.397' AS DateTime), CAST(N'2019-05-12 21:45:05.397' AS DateTime), N'', N'haigv', N'haigv')
SET IDENTITY_INSERT [dbo].[Customer] OFF
SET IDENTITY_INSERT [dbo].[MeasurementParameter] ON 

INSERT [dbo].[MeasurementParameter] ([MeasurementParameterID], [Code], [ViName], [EnName], [Symbol], [UnitOfMeasure], [Description], [CreatedDate], [ModifiedDate], [IPAddress], [ModifiedBy], [CreatedBy]) VALUES (2, N'Nhiệt độ', N'Nhiệt độ', N'Temperature', N'Nhiệt độ', N'oC', N'', CAST(N'2019-03-08 14:48:59.470' AS DateTime), CAST(N'2019-03-08 14:48:59.470' AS DateTime), N'', N'sysadmin', N'sysadmin')
INSERT [dbo].[MeasurementParameter] ([MeasurementParameterID], [Code], [ViName], [EnName], [Symbol], [UnitOfMeasure], [Description], [CreatedDate], [ModifiedDate], [IPAddress], [ModifiedBy], [CreatedBy]) VALUES (12, N'Cu', N'Đồng', N'Copper', N'Cu', N'mg/l', NULL, CAST(N'2011-01-05 10:08:00.000' AS DateTime), CAST(N'2019-04-22 21:05:02.923' AS DateTime), N'', N'', N'1')
INSERT [dbo].[MeasurementParameter] ([MeasurementParameterID], [Code], [ViName], [EnName], [Symbol], [UnitOfMeasure], [Description], [CreatedDate], [ModifiedDate], [IPAddress], [ModifiedBy], [CreatedBy]) VALUES (16, N'Asen', N'Asen', N'Arsenic', N'As', N'mg/l', NULL, CAST(N'2011-01-19 09:14:00.000' AS DateTime), CAST(N'2019-04-22 21:05:03.113' AS DateTime), N'', N'', N'1')
INSERT [dbo].[MeasurementParameter] ([MeasurementParameterID], [Code], [ViName], [EnName], [Symbol], [UnitOfMeasure], [Description], [CreatedDate], [ModifiedDate], [IPAddress], [ModifiedBy], [CreatedBy]) VALUES (17, N'Chì', N'Chì', N'Lead', N'Pb', N'mg/l', NULL, CAST(N'2011-01-19 09:15:00.000' AS DateTime), CAST(N'2019-04-22 21:05:03.160' AS DateTime), N'', N'', N'1')
INSERT [dbo].[MeasurementParameter] ([MeasurementParameterID], [Code], [ViName], [EnName], [Symbol], [UnitOfMeasure], [Description], [CreatedDate], [ModifiedDate], [IPAddress], [ModifiedBy], [CreatedBy]) VALUES (18, N'Cadimi', N'Cadimi', N'Cadimium', N'Cd', N'mg/l', NULL, CAST(N'2011-01-19 09:16:00.000' AS DateTime), CAST(N'2015-03-16 14:15:00.000' AS DateTime), N'', N'1', N'1')
INSERT [dbo].[MeasurementParameter] ([MeasurementParameterID], [Code], [ViName], [EnName], [Symbol], [UnitOfMeasure], [Description], [CreatedDate], [ModifiedDate], [IPAddress], [ModifiedBy], [CreatedBy]) VALUES (21, N'Kẽm', N'Kẽm', N'Zinc', N'Zn', N'mg/l', NULL, CAST(N'2011-01-19 09:18:00.000' AS DateTime), CAST(N'2019-04-22 21:05:03.340' AS DateTime), N'', N'', N'1')
INSERT [dbo].[MeasurementParameter] ([MeasurementParameterID], [Code], [ViName], [EnName], [Symbol], [UnitOfMeasure], [Description], [CreatedDate], [ModifiedDate], [IPAddress], [ModifiedBy], [CreatedBy]) VALUES (23, N'Mangan', N'Mangan', N'Manganese', N'Mn', N'mg/l', NULL, CAST(N'2011-01-19 09:19:00.000' AS DateTime), CAST(N'2019-04-22 21:05:03.427' AS DateTime), N'', N'', N'1')
INSERT [dbo].[MeasurementParameter] ([MeasurementParameterID], [Code], [ViName], [EnName], [Symbol], [UnitOfMeasure], [Description], [CreatedDate], [ModifiedDate], [IPAddress], [ModifiedBy], [CreatedBy]) VALUES (24, N'Sắt', N'Sắt', N'Iron', N'Fe', N'mg/l', NULL, CAST(N'2011-01-19 09:20:00.000' AS DateTime), CAST(N'2019-04-22 21:05:03.480' AS DateTime), N'', N'', N'1')
INSERT [dbo].[MeasurementParameter] ([MeasurementParameterID], [Code], [ViName], [EnName], [Symbol], [UnitOfMeasure], [Description], [CreatedDate], [ModifiedDate], [IPAddress], [ModifiedBy], [CreatedBy]) VALUES (30, N'Clo dư', N'Clo dư', N'Total Residual Chlorine', N'Cl dư', N'mg/l', NULL, CAST(N'2011-01-19 09:27:00.000' AS DateTime), CAST(N'2019-04-22 21:05:03.757' AS DateTime), N'', N'', N'1')
INSERT [dbo].[MeasurementParameter] ([MeasurementParameterID], [Code], [ViName], [EnName], [Symbol], [UnitOfMeasure], [Description], [CreatedDate], [ModifiedDate], [IPAddress], [ModifiedBy], [CreatedBy]) VALUES (31, N'PCB', N'PCB', N'Polychlorinated biphenyls', N'PCB', N'mg/l', NULL, CAST(N'2011-01-19 09:29:00.000' AS DateTime), CAST(N'2019-04-22 21:05:03.803' AS DateTime), N'', N'', N'1')
INSERT [dbo].[MeasurementParameter] ([MeasurementParameterID], [Code], [ViName], [EnName], [Symbol], [UnitOfMeasure], [Description], [CreatedDate], [ModifiedDate], [IPAddress], [ModifiedBy], [CreatedBy]) VALUES (40, N'Tổng hoạt độ phóng xạ α', N'Tổng hoạt độ phóng xạ α', N'Gross alpha activity', N'Tổng hoạt độ phóng xạ α', N'Bq/l', NULL, CAST(N'2011-01-19 09:43:00.000' AS DateTime), CAST(N'2019-04-22 21:05:04.213' AS DateTime), N'', N'', N'1')
INSERT [dbo].[MeasurementParameter] ([MeasurementParameterID], [Code], [ViName], [EnName], [Symbol], [UnitOfMeasure], [Description], [CreatedDate], [ModifiedDate], [IPAddress], [ModifiedBy], [CreatedBy]) VALUES (41, N'Tổng hoạt độ phóng xạ β', N'Tổng hoạt độ phóng xạ β', N'Gross beta activity', N'Tổng hoạt độ phóng xạ β', N'Bq/l', NULL, CAST(N'2011-01-19 09:43:00.000' AS DateTime), CAST(N'2019-04-22 21:05:04.257' AS DateTime), N'', N'', N'1')
INSERT [dbo].[MeasurementParameter] ([MeasurementParameterID], [Code], [ViName], [EnName], [Symbol], [UnitOfMeasure], [Description], [CreatedDate], [ModifiedDate], [IPAddress], [ModifiedBy], [CreatedBy]) VALUES (44, N'Asen và các hợp chất, tính theo asen', N'Asen và các hợp chất, tính theo asen', N'Arsenic and arsenic compounds (as As)', N'Asen và các hợp chất, tính theo asen', N'mg/Nm3', NULL, CAST(N'2011-01-19 13:39:00.000' AS DateTime), CAST(N'2019-04-22 21:05:04.400' AS DateTime), N'', N'', N'1')
INSERT [dbo].[MeasurementParameter] ([MeasurementParameterID], [Code], [ViName], [EnName], [Symbol], [UnitOfMeasure], [Description], [CreatedDate], [ModifiedDate], [IPAddress], [ModifiedBy], [CreatedBy]) VALUES (45, N'Chì và các hợp chất, tính theo chì', N'Chì và các hợp chất, tính theo chì', N'Lead and lead compounds (as Pb)', N'Chì và các hợp chất, tính theo chì', N'mg/Nm3', NULL, CAST(N'2011-01-19 13:41:00.000' AS DateTime), CAST(N'2019-04-22 21:05:04.443' AS DateTime), N'', N'', N'1')
INSERT [dbo].[MeasurementParameter] ([MeasurementParameterID], [Code], [ViName], [EnName], [Symbol], [UnitOfMeasure], [Description], [CreatedDate], [ModifiedDate], [IPAddress], [ModifiedBy], [CreatedBy]) VALUES (46, N'Cadmi và các hợp chất, tính theo cadmi', N'Cadmi và các hợp chất, tính theo cadmi', N'Cadmium and cadmium compounds (as Cd)', N'Cadmi và các hợp chất, tính theo cadmi', N'mg/Nm3', NULL, CAST(N'2011-01-19 13:42:00.000' AS DateTime), CAST(N'2019-04-22 21:05:04.497' AS DateTime), N'', N'', N'1')
INSERT [dbo].[MeasurementParameter] ([MeasurementParameterID], [Code], [ViName], [EnName], [Symbol], [UnitOfMeasure], [Description], [CreatedDate], [ModifiedDate], [IPAddress], [ModifiedBy], [CreatedBy]) VALUES (56, N'Thủy ngân', N'Thủy ngân', N'Mecury', N'Hg', N'mg/l', NULL, CAST(N'2011-01-19 15:05:00.000' AS DateTime), CAST(N'2019-04-22 21:05:04.960' AS DateTime), N'', N'', N'1')
INSERT [dbo].[MeasurementParameter] ([MeasurementParameterID], [Code], [ViName], [EnName], [Symbol], [UnitOfMeasure], [Description], [CreatedDate], [ModifiedDate], [IPAddress], [ModifiedBy], [CreatedBy]) VALUES (61, N'Nitrat (Theo nitơ)', N'Nitrat', N'Nitrate (as N)', N'NO3-N', N'mg/l', NULL, CAST(N'2011-02-21 11:06:00.000' AS DateTime), CAST(N'2019-04-22 21:05:05.190' AS DateTime), N'', N'', N'1')
INSERT [dbo].[MeasurementParameter] ([MeasurementParameterID], [Code], [ViName], [EnName], [Symbol], [UnitOfMeasure], [Description], [CreatedDate], [ModifiedDate], [IPAddress], [ModifiedBy], [CreatedBy]) VALUES (63, N'Nitrit (NO2-) (tính theo N)', N'Nitrit', N'Nitrit', N'NO2-', N'mg/l', NULL, CAST(N'2015-01-29 10:10:00.000' AS DateTime), CAST(N'2019-04-22 21:05:05.287' AS DateTime), N'', N'', N'1')
INSERT [dbo].[MeasurementParameter] ([MeasurementParameterID], [Code], [ViName], [EnName], [Symbol], [UnitOfMeasure], [Description], [CreatedDate], [ModifiedDate], [IPAddress], [ModifiedBy], [CreatedBy]) VALUES (64, N'E. Coli', N'E. Coli', N'E. Coli', N'E. Coli', N'MPN/100ml', NULL, CAST(N'2015-01-30 14:50:00.000' AS DateTime), CAST(N'2019-04-22 21:05:05.333' AS DateTime), N'', N'', N'1')
INSERT [dbo].[MeasurementParameter] ([MeasurementParameterID], [Code], [ViName], [EnName], [Symbol], [UnitOfMeasure], [Description], [CreatedDate], [ModifiedDate], [IPAddress], [ModifiedBy], [CreatedBy]) VALUES (170, N'Tổng các kim loại nặng khác (As, Sb, Ni, Co, Cu, C', N'Tổng các kim loại nặng khác (As, Sb, Ni,', NULL, NULL, NULL, NULL, CAST(N'2019-04-22 21:05:14.170' AS DateTime), CAST(N'2019-04-22 21:05:14.170' AS DateTime), N'', N'', N'')
INSERT [dbo].[MeasurementParameter] ([MeasurementParameterID], [Code], [ViName], [EnName], [Symbol], [UnitOfMeasure], [Description], [CreatedDate], [ModifiedDate], [IPAddress], [ModifiedBy], [CreatedBy]) VALUES (177, N' Dioxin ', N' Dioxin ', N' Dioxin ', N' Dioxin ', N'pgTEQ /l', N'', CAST(N'2019-03-07 17:14:09.473' AS DateTime), CAST(N'2019-03-07 17:14:09.473' AS DateTime), N'', N'sysadmin', N'sysadmin')
INSERT [dbo].[MeasurementParameter] ([MeasurementParameterID], [Code], [ViName], [EnName], [Symbol], [UnitOfMeasure], [Description], [CreatedDate], [ModifiedDate], [IPAddress], [ModifiedBy], [CreatedBy]) VALUES (184, N'Nhịp tim', N'Nhịp tim', N'Heartbeat', N'HeartBeat', N'bpm', NULL, CAST(N'2019-04-22 21:25:15.350' AS DateTime), CAST(N'2019-04-22 21:25:15.350' AS DateTime), N'', N'', N'')
INSERT [dbo].[MeasurementParameter] ([MeasurementParameterID], [Code], [ViName], [EnName], [Symbol], [UnitOfMeasure], [Description], [CreatedDate], [ModifiedDate], [IPAddress], [ModifiedBy], [CreatedBy]) VALUES (185, N'Huyết áp lv1', N'Huyết áp', N'BloodPressure', N'BloodPressure', N'mmHg', NULL, CAST(N'2019-04-22 21:26:08.657' AS DateTime), CAST(N'2019-04-22 21:26:08.657' AS DateTime), N'', N'', N'')
INSERT [dbo].[MeasurementParameter] ([MeasurementParameterID], [Code], [ViName], [EnName], [Symbol], [UnitOfMeasure], [Description], [CreatedDate], [ModifiedDate], [IPAddress], [ModifiedBy], [CreatedBy]) VALUES (186, N'Chụp cắt lớp vi tính', N'Chụp cắt lớp vi tính', N'Computed Tomography', N'CT', N'Pass or Fail', NULL, CAST(N'2019-04-22 23:06:42.330' AS DateTime), CAST(N'2019-04-22 23:06:42.330' AS DateTime), N'', N'', N'')
INSERT [dbo].[MeasurementParameter] ([MeasurementParameterID], [Code], [ViName], [EnName], [Symbol], [UnitOfMeasure], [Description], [CreatedDate], [ModifiedDate], [IPAddress], [ModifiedBy], [CreatedBy]) VALUES (187, N'Huyết áp lv2', N'Huyết áp', N'BloodPressure', N'BloodPressure', NULL, NULL, CAST(N'2019-04-22 23:11:46.620' AS DateTime), CAST(N'2019-04-22 23:11:46.620' AS DateTime), N'', N'', N'')
INSERT [dbo].[MeasurementParameter] ([MeasurementParameterID], [Code], [ViName], [EnName], [Symbol], [UnitOfMeasure], [Description], [CreatedDate], [ModifiedDate], [IPAddress], [ModifiedBy], [CreatedBy]) VALUES (188, N'Huyết áp lv3', N'Huyết áp', N'BloodPressure', N'BloodPressure', N'mmHg', NULL, CAST(N'2019-04-22 21:26:08.657' AS DateTime), CAST(N'2019-04-22 21:26:08.657' AS DateTime), N'', N'', N'')
SET IDENTITY_INSERT [dbo].[MeasurementParameter] OFF
SET IDENTITY_INSERT [dbo].[MeasurementStandard] ON 

INSERT [dbo].[MeasurementStandard] ([MeasurementStandardID], [Code], [FullName], [ShortName], [Description], [CreatedDate], [ModifiedDate], [IPAddress], [ModifiedBy], [CreatedBy]) VALUES (1, NULL, N'Khám tổng quan', N'KTQ-BYT:04/2019', N'Khám tổng quan xét nghiệm các thành phần trong cơ thể', CAST(N'2010-12-29 14:55:00.000' AS DateTime), CAST(N'2017-03-30 00:00:00.000' AS DateTime), N'', N'1', N'1')
INSERT [dbo].[MeasurementStandard] ([MeasurementStandardID], [Code], [FullName], [ShortName], [Description], [CreatedDate], [ModifiedDate], [IPAddress], [ModifiedBy], [CreatedBy]) VALUES (52, NULL, N'Khám thông thường', N'KTT-BV:04/2019', N'Nhịp tim huyết áp, nhiệt độ cơ thể', CAST(N'2019-04-22 21:22:08.810' AS DateTime), CAST(N'2019-04-22 21:22:08.810' AS DateTime), N'', N'', N'')
INSERT [dbo].[MeasurementStandard] ([MeasurementStandardID], [Code], [FullName], [ShortName], [Description], [CreatedDate], [ModifiedDate], [IPAddress], [ModifiedBy], [CreatedBy]) VALUES (53, NULL, N'Thử máu', N'TM-BYT:04/2019', N'Thử máu', CAST(N'2019-04-22 21:23:09.950' AS DateTime), CAST(N'2019-04-22 21:23:09.950' AS DateTime), N'', N'', N'')
INSERT [dbo].[MeasurementStandard] ([MeasurementStandardID], [Code], [FullName], [ShortName], [Description], [CreatedDate], [ModifiedDate], [IPAddress], [ModifiedBy], [CreatedBy]) VALUES (54, NULL, N'Khám sức khỏe', N'KSK-BV:04/2019', N'Siêu âm, đo mắt, nhịp tim', CAST(N'2019-04-22 21:23:51.373' AS DateTime), CAST(N'2019-04-22 21:23:51.373' AS DateTime), N'', N'', N'')
SET IDENTITY_INSERT [dbo].[MeasurementStandard] OFF
SET IDENTITY_INSERT [dbo].[MeasurementStandardParameter] ON 

INSERT [dbo].[MeasurementStandardParameter] ([MeasurementStandardParameterID], [MeasurementStandardID], [MeasurementParameterID], [C_Min], [C_Max], [C_Text], [CreatedDate], [ModifiedDate], [IPAddress], [ModifiedBy], [CreatedBy]) VALUES (1, 54, 186, NULL, NULL, NULL, CAST(N'2019-04-22 21:10:58.633' AS DateTime), CAST(N'2019-04-22 21:10:58.633' AS DateTime), N'2010-12-29 15:18:00.000', N'', N'')
INSERT [dbo].[MeasurementStandardParameter] ([MeasurementStandardParameterID], [MeasurementStandardID], [MeasurementParameterID], [C_Min], [C_Max], [C_Text], [CreatedDate], [ModifiedDate], [IPAddress], [ModifiedBy], [CreatedBy]) VALUES (2, 54, 185, CAST(65.0000 AS Decimal(18, 4)), CAST(115.0000 AS Decimal(18, 4)), N'', CAST(N'2019-04-22 21:10:58.693' AS DateTime), CAST(N'2019-04-22 21:10:58.693' AS DateTime), N'2019-03-08 16:09:01.173', N'2019-03-08 16:22:01.010', N'')
INSERT [dbo].[MeasurementStandardParameter] ([MeasurementStandardParameterID], [MeasurementStandardID], [MeasurementParameterID], [C_Min], [C_Max], [C_Text], [CreatedDate], [ModifiedDate], [IPAddress], [ModifiedBy], [CreatedBy]) VALUES (3, 54, 184, CAST(0.0000 AS Decimal(18, 4)), NULL, NULL, CAST(N'2019-04-22 21:10:58.730' AS DateTime), CAST(N'2019-04-22 21:10:58.730' AS DateTime), N'2010-12-29 15:22:00.000', N'2012-05-02 09:58:00.000', N'')
INSERT [dbo].[MeasurementStandardParameter] ([MeasurementStandardParameterID], [MeasurementStandardID], [MeasurementParameterID], [C_Min], [C_Max], [C_Text], [CreatedDate], [ModifiedDate], [IPAddress], [ModifiedBy], [CreatedBy]) VALUES (4, 54, 2, CAST(0.0000 AS Decimal(18, 4)), CAST(42.0000 AS Decimal(18, 4)), N'', CAST(N'2019-04-22 21:10:58.770' AS DateTime), CAST(N'2019-04-22 21:10:58.770' AS DateTime), N'2019-03-08 16:15:22.970', N'2019-03-08 16:28:22.810', N'')
INSERT [dbo].[MeasurementStandardParameter] ([MeasurementStandardParameterID], [MeasurementStandardID], [MeasurementParameterID], [C_Min], [C_Max], [C_Text], [CreatedDate], [ModifiedDate], [IPAddress], [ModifiedBy], [CreatedBy]) VALUES (5, 53, 17, NULL, CAST(1500.0000 AS Decimal(18, 4)), NULL, CAST(N'2019-04-22 21:10:58.810' AS DateTime), CAST(N'2019-04-22 21:10:58.810' AS DateTime), N'2010-12-29 15:24:00.000', N'2012-05-02 10:29:00.000', N'')
INSERT [dbo].[MeasurementStandardParameter] ([MeasurementStandardParameterID], [MeasurementStandardID], [MeasurementParameterID], [C_Min], [C_Max], [C_Text], [CreatedDate], [ModifiedDate], [IPAddress], [ModifiedBy], [CreatedBy]) VALUES (6, 53, 18, NULL, CAST(100.0000 AS Decimal(18, 4)), NULL, CAST(N'2019-04-22 21:10:58.963' AS DateTime), CAST(N'2019-04-22 21:10:58.963' AS DateTime), N'2010-12-29 15:25:00.000', N'2012-05-02 10:14:00.000', N'')
INSERT [dbo].[MeasurementStandardParameter] ([MeasurementStandardParameterID], [MeasurementStandardID], [MeasurementParameterID], [C_Min], [C_Max], [C_Text], [CreatedDate], [ModifiedDate], [IPAddress], [ModifiedBy], [CreatedBy]) VALUES (7, 53, 21, CAST(5.0000 AS Decimal(18, 4)), CAST(20.0000 AS Decimal(18, 4)), N'', CAST(N'2019-04-22 21:10:59.007' AS DateTime), CAST(N'2019-04-22 21:10:59.007' AS DateTime), N'2018-11-11 11:08:20.460', N'2018-11-11 11:08:18.400', N'')
INSERT [dbo].[MeasurementStandardParameter] ([MeasurementStandardParameterID], [MeasurementStandardID], [MeasurementParameterID], [C_Min], [C_Max], [C_Text], [CreatedDate], [ModifiedDate], [IPAddress], [ModifiedBy], [CreatedBy]) VALUES (9, 53, 23, NULL, NULL, NULL, CAST(N'2019-04-22 23:07:57.777' AS DateTime), CAST(N'2019-04-22 23:07:57.777' AS DateTime), N'', N'', N'')
INSERT [dbo].[MeasurementStandardParameter] ([MeasurementStandardParameterID], [MeasurementStandardID], [MeasurementParameterID], [C_Min], [C_Max], [C_Text], [CreatedDate], [ModifiedDate], [IPAddress], [ModifiedBy], [CreatedBy]) VALUES (10, 53, 24, NULL, NULL, NULL, CAST(N'2019-04-22 23:08:25.880' AS DateTime), CAST(N'2019-04-22 23:08:25.880' AS DateTime), N'', N'', N'')
INSERT [dbo].[MeasurementStandardParameter] ([MeasurementStandardParameterID], [MeasurementStandardID], [MeasurementParameterID], [C_Min], [C_Max], [C_Text], [CreatedDate], [ModifiedDate], [IPAddress], [ModifiedBy], [CreatedBy]) VALUES (11, 54, 187, CAST(80.0000 AS Decimal(18, 4)), CAST(123.0000 AS Decimal(18, 4)), N'', CAST(N'2019-04-22 21:10:58.693' AS DateTime), CAST(N'2019-04-22 21:10:58.693' AS DateTime), N'2019-03-08 16:09:01.173', N'2019-03-08 16:22:01.010', N'')
INSERT [dbo].[MeasurementStandardParameter] ([MeasurementStandardParameterID], [MeasurementStandardID], [MeasurementParameterID], [C_Min], [C_Max], [C_Text], [CreatedDate], [ModifiedDate], [IPAddress], [ModifiedBy], [CreatedBy]) VALUES (12, 54, 188, CAST(83.0000 AS Decimal(18, 4)), CAST(134.0000 AS Decimal(18, 4)), N'', CAST(N'2019-04-22 21:10:58.693' AS DateTime), CAST(N'2019-04-22 21:10:58.693' AS DateTime), N'2019-03-08 16:09:01.173', N'2019-03-08 16:22:01.010', N'')
INSERT [dbo].[MeasurementStandardParameter] ([MeasurementStandardParameterID], [MeasurementStandardID], [MeasurementParameterID], [C_Min], [C_Max], [C_Text], [CreatedDate], [ModifiedDate], [IPAddress], [ModifiedBy], [CreatedBy]) VALUES (14, 52, 188, CAST(83.0000 AS Decimal(18, 4)), CAST(134.0000 AS Decimal(18, 4)), N'', CAST(N'2019-04-22 21:10:58.693' AS DateTime), CAST(N'2019-04-22 21:10:58.693' AS DateTime), N'2019-03-08 16:09:01.173', N'2019-03-08 16:22:01.010', N'')
INSERT [dbo].[MeasurementStandardParameter] ([MeasurementStandardParameterID], [MeasurementStandardID], [MeasurementParameterID], [C_Min], [C_Max], [C_Text], [CreatedDate], [ModifiedDate], [IPAddress], [ModifiedBy], [CreatedBy]) VALUES (15, 52, 187, CAST(80.0000 AS Decimal(18, 4)), CAST(123.0000 AS Decimal(18, 4)), N'', CAST(N'2019-04-22 21:10:58.693' AS DateTime), CAST(N'2019-04-22 21:10:58.693' AS DateTime), N'2019-03-08 16:09:01.173', N'2019-03-08 16:22:01.010', N'')
INSERT [dbo].[MeasurementStandardParameter] ([MeasurementStandardParameterID], [MeasurementStandardID], [MeasurementParameterID], [C_Min], [C_Max], [C_Text], [CreatedDate], [ModifiedDate], [IPAddress], [ModifiedBy], [CreatedBy]) VALUES (16, 52, 185, CAST(65.0000 AS Decimal(18, 4)), CAST(115.0000 AS Decimal(18, 4)), N'', CAST(N'2019-04-22 21:10:58.693' AS DateTime), CAST(N'2019-04-22 21:10:58.693' AS DateTime), N'2019-03-08 16:09:01.173', N'2019-03-08 16:22:01.010', N'')
INSERT [dbo].[MeasurementStandardParameter] ([MeasurementStandardParameterID], [MeasurementStandardID], [MeasurementParameterID], [C_Min], [C_Max], [C_Text], [CreatedDate], [ModifiedDate], [IPAddress], [ModifiedBy], [CreatedBy]) VALUES (17, 52, 184, CAST(0.0000 AS Decimal(18, 4)), NULL, NULL, CAST(N'2019-04-22 21:10:58.730' AS DateTime), CAST(N'2019-04-22 21:10:58.730' AS DateTime), N'2010-12-29 15:22:00.000', N'2012-05-02 09:58:00.000', N'')
INSERT [dbo].[MeasurementStandardParameter] ([MeasurementStandardParameterID], [MeasurementStandardID], [MeasurementParameterID], [C_Min], [C_Max], [C_Text], [CreatedDate], [ModifiedDate], [IPAddress], [ModifiedBy], [CreatedBy]) VALUES (18, 52, 2, CAST(0.0000 AS Decimal(18, 4)), CAST(42.0000 AS Decimal(18, 4)), NULL, CAST(N'2019-04-22 21:10:58.730' AS DateTime), CAST(N'2019-04-22 21:10:58.730' AS DateTime), N'2010-12-29 15:22:00.000', N'2012-05-02 09:58:00.000', N'')
INSERT [dbo].[MeasurementStandardParameter] ([MeasurementStandardParameterID], [MeasurementStandardID], [MeasurementParameterID], [C_Min], [C_Max], [C_Text], [CreatedDate], [ModifiedDate], [IPAddress], [ModifiedBy], [CreatedBy]) VALUES (19, 1, 186, NULL, NULL, NULL, CAST(N'2019-04-22 23:19:10.940' AS DateTime), CAST(N'2019-04-22 23:19:10.940' AS DateTime), N'', N'', N'')
SET IDENTITY_INSERT [dbo].[MeasurementStandardParameter] OFF
SET IDENTITY_INSERT [dbo].[MedicalRecord] ON 

INSERT [dbo].[MedicalRecord] ([MedicalRecordID], [CustomerID], [AppliedStandardID], [MedicalRecordDescription], [MedicalRecordLocation], [MedicalRecordDate], [FinalResult], [CreatedBy], [ModifiedBy], [IPAddress], [CreatedDate], [ModifiedDate]) VALUES (1, 401, 52, N'Khám thông thường', N'Phòng 401', CAST(N'2019-04-22 00:00:00.000' AS DateTime), N'Hoàn thành', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[MedicalRecord] ([MedicalRecordID], [CustomerID], [AppliedStandardID], [MedicalRecordDescription], [MedicalRecordLocation], [MedicalRecordDate], [FinalResult], [CreatedBy], [ModifiedBy], [IPAddress], [CreatedDate], [ModifiedDate]) VALUES (2, 400, 54, N'Kiểm tra SK', N'Phòng 509', CAST(N'2019-04-22 00:00:00.000' AS DateTime), N'Hoàn thành', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[MedicalRecord] ([MedicalRecordID], [CustomerID], [AppliedStandardID], [MedicalRecordDescription], [MedicalRecordLocation], [MedicalRecordDate], [FinalResult], [CreatedBy], [ModifiedBy], [IPAddress], [CreatedDate], [ModifiedDate]) VALUES (9, 400, 1, N'123', N'123', CAST(N'2019-04-23 00:00:00.000' AS DateTime), N'123', N'haigv', N'haigv', N'', CAST(N'2019-04-23 11:50:39.380' AS DateTime), CAST(N'2019-04-23 11:50:39.380' AS DateTime))
INSERT [dbo].[MedicalRecord] ([MedicalRecordID], [CustomerID], [AppliedStandardID], [MedicalRecordDescription], [MedicalRecordLocation], [MedicalRecordDate], [FinalResult], [CreatedBy], [ModifiedBy], [IPAddress], [CreatedDate], [ModifiedDate]) VALUES (10, 401, 53, N'TM', N'Phòng 201', CAST(N'2019-04-23 00:00:00.000' AS DateTime), N'Chờ KQ', N'haigv', N'haigv', N'', CAST(N'2019-04-23 11:51:20.700' AS DateTime), CAST(N'2019-04-23 11:51:20.700' AS DateTime))
INSERT [dbo].[MedicalRecord] ([MedicalRecordID], [CustomerID], [AppliedStandardID], [MedicalRecordDescription], [MedicalRecordLocation], [MedicalRecordDate], [FinalResult], [CreatedBy], [ModifiedBy], [IPAddress], [CreatedDate], [ModifiedDate]) VALUES (11, 401, 52, N'KTT', N'Phòng 202', CAST(N'2019-04-23 00:00:00.000' AS DateTime), N'Chờ KQ', N'haigv', N'haigv', N'', CAST(N'2019-04-23 11:52:57.433' AS DateTime), CAST(N'2019-04-23 11:52:57.433' AS DateTime))
INSERT [dbo].[MedicalRecord] ([MedicalRecordID], [CustomerID], [AppliedStandardID], [MedicalRecordDescription], [MedicalRecordLocation], [MedicalRecordDate], [FinalResult], [CreatedBy], [ModifiedBy], [IPAddress], [CreatedDate], [ModifiedDate]) VALUES (1003, 401, 1, N'KTK', N'Phòng KTQ', CAST(N'2019-04-23 00:00:00.000' AS DateTime), N'Hoàn thành', N'haigv', N'haigv', N'', CAST(N'2019-04-23 12:40:51.840' AS DateTime), CAST(N'2019-04-23 12:40:51.840' AS DateTime))
INSERT [dbo].[MedicalRecord] ([MedicalRecordID], [CustomerID], [AppliedStandardID], [MedicalRecordDescription], [MedicalRecordLocation], [MedicalRecordDate], [FinalResult], [CreatedBy], [ModifiedBy], [IPAddress], [CreatedDate], [ModifiedDate]) VALUES (1004, 400, 1, N'1', N'1', CAST(N'2019-04-23 00:00:00.000' AS DateTime), N'1', N'haigv', N'haigv', N'', CAST(N'2019-04-23 12:41:26.140' AS DateTime), CAST(N'2019-04-23 12:41:26.140' AS DateTime))
SET IDENTITY_INSERT [dbo].[MedicalRecord] OFF
SET IDENTITY_INSERT [dbo].[QADetail] ON 

INSERT [dbo].[QADetail] ([QADetailID], [QATopicID], [QuestionContent], [AnswerContent], [PublicState], [QuestionBy], [QuestionDate], [AnswerBy], [AnswerDate], [ModifiedDate], [ModifiedBy], [IPAddress]) VALUES (1, 1, N'Đau phần bụng bên phải', N'Tiếp nhận,  BN đến khám lúc 2h chiều 14/5', 1, N'datgv', CAST(N'2019-05-14 00:00:00.000' AS DateTime), N'haigv', CAST(N'2019-05-14 00:00:00.000' AS DateTime), CAST(N'2019-05-14 10:32:15.997' AS DateTime), N'haigv', N'')
INSERT [dbo].[QADetail] ([QADetailID], [QATopicID], [QuestionContent], [AnswerContent], [PublicState], [QuestionBy], [QuestionDate], [AnswerBy], [AnswerDate], [ModifiedDate], [ModifiedBy], [IPAddress]) VALUES (2, 3, N'TNGT', NULL, 0, N'harrisonwells', CAST(N'2019-05-14 09:32:51.557' AS DateTime), NULL, CAST(N'2019-05-14 09:32:51.557' AS DateTime), CAST(N'2019-05-14 09:32:51.557' AS DateTime), N'', N'')
INSERT [dbo].[QADetail] ([QADetailID], [QATopicID], [QuestionContent], [AnswerContent], [PublicState], [QuestionBy], [QuestionDate], [AnswerBy], [AnswerDate], [ModifiedDate], [ModifiedBy], [IPAddress]) VALUES (3, 2, N'Sốt trẻ nhỏ', N'', 0, N'haigv', CAST(N'2019-05-14 00:00:00.000' AS DateTime), N'', CAST(N'2019-05-14 00:00:00.000' AS DateTime), CAST(N'2019-05-14 10:19:14.270' AS DateTime), N'haigv', N'')
INSERT [dbo].[QADetail] ([QADetailID], [QATopicID], [QuestionContent], [AnswerContent], [PublicState], [QuestionBy], [QuestionDate], [AnswerBy], [AnswerDate], [ModifiedDate], [ModifiedBy], [IPAddress]) VALUES (4, 1, N'khám tổng quát', N'mời đến chiều 2h', 1, N'datgv', CAST(N'2019-05-14 00:00:00.000' AS DateTime), N'haigv', CAST(N'2019-05-14 00:00:00.000' AS DateTime), CAST(N'2019-05-14 12:57:26.677' AS DateTime), N'haigv', N'')
SET IDENTITY_INSERT [dbo].[QADetail] OFF
SET IDENTITY_INSERT [dbo].[QATopic] ON 

INSERT [dbo].[QATopic] ([QATopicID], [QATopicCode], [QATopicName], [Description], [Inactive], [SortOrder], [CreatedDate], [ModifiedDate], [IPAddress], [ModifiedBy], [CreatedBy]) VALUES (1, N'1', N'Khám', N'Khám', 0, 0, CAST(N'2019-05-14 09:20:07.343' AS DateTime), CAST(N'2019-05-14 09:20:07.343' AS DateTime), N'', N'', N'')
INSERT [dbo].[QATopic] ([QATopicID], [QATopicCode], [QATopicName], [Description], [Inactive], [SortOrder], [CreatedDate], [ModifiedDate], [IPAddress], [ModifiedBy], [CreatedBy]) VALUES (2, N'2', N'Cấp cứu', N'Cấp cứu', 0, 0, CAST(N'2019-05-14 09:20:44.507' AS DateTime), CAST(N'2019-05-14 09:20:44.507' AS DateTime), N'', N'', N'')
INSERT [dbo].[QATopic] ([QATopicID], [QATopicCode], [QATopicName], [Description], [Inactive], [SortOrder], [CreatedDate], [ModifiedDate], [IPAddress], [ModifiedBy], [CreatedBy]) VALUES (3, N'3', N'Trường hợp khẩn cấp', N'Trường hợp khẩn cấp', 0, 0, CAST(N'2019-05-14 09:21:03.410' AS DateTime), CAST(N'2019-05-14 09:21:03.410' AS DateTime), N'', N'', N'')
SET IDENTITY_INSERT [dbo].[QATopic] OFF
INSERT [dbo].[Tokens] ([TokenId], [UserName], [Token], [ExpiresOn], [IssuedOn]) VALUES (N'6472fdd4-e8df-465a-bff6-486b5b7f4a15', N'datgv', N'{"access_token":"4yclet2UtlxQxp4pjw5K8MjvuTovxxaTSDq4Nw1ShIzV7RvFoUlADhbOOxqdtGtUveL-BZ3VyRFMfd12iDEL99mGWY0p0gpgiLyjt5_lAJ8sjcNWwyuvk3EbdMc4LbizIIcrY8NwY9BAjk7s4WoEokizZXm-9EYV9AFdd4gobvrnPLxjJ2F1Vd3Czls5LpPIDclE8bEAagKnRSmtYTKCPglNexOn62wD1vzSYgXWCuapHWMrBIvUPgytRxU9JYPl34gqhoUl_uJvZBV5V9vUStiJUzOcHScAXXtaFgUVzLMrdsS9WDDC0OrVtFWofs1NRRTqJyQnJ_e1sH30hNBIY08ZbmEKYXrGCcuu3B1js99utIxh3pZk6-pL_MTNegwU6EWP66qAfyyMilOnH7eYkJj-96-AYL3MgjKV5Mbm9vpajhA8gDCA_AOT1GmpBbNei842XAphzWSOwuKbkHeEsHE2ieWjB6VQhX_n95doVRfVD4RuODY4MQOdYnTTzehz","token_type":"bearer","expires_in":86399,"userName":"datgv",".issued":"Tue, 14 May 2019 05:56:30 GMT",".expires":"Wed, 15 May 2019 05:56:30 GMT","error":null,"error_description":null,"FileResourceID":null,"EmployeeID":null,"FullName":"Giang Van Dat","UserID":402,"GroupID":1,"ReportYear":2019}', CAST(N'2019-05-15 12:56:32.807' AS DateTime), CAST(N'2019-05-14 12:56:32.807' AS DateTime))
INSERT [dbo].[Tokens] ([TokenId], [UserName], [Token], [ExpiresOn], [IssuedOn]) VALUES (N'd0019c57-fd2b-4645-bdf9-59afbd3016c4', N'harrisonwells', N'{"access_token":"t0M5P4TQrmFVaJ6ln2F9MOLyo2U_crzWBp0THddLO_w_3XdYWwryZB6CwWXxjrB628Ks8uxHYlnI5KEgo12HfuHBLQM34S1g2g1RpHIRqzM63Vf39MH-8xFdM3QRT7hjsQHGn35xee9J46ky7nwrC1o-hsYCU4Ud2db1FNXoV0cJsoL_ZMfmgkrRBDbZmtrbhdIELugOVG5DVSxhiewEQEd4ZF3OPvhK6iDHAhYL9lcuF7LbmlQZQ8pMpMZbJTAwhEPEQxB5A7Y7U9qUPvdajCqishOHO6q9IbTdqIPMyVbrr8VHu-hIWyaOaQdtk_eSPdE-FIOvhpGSu28SNfiQjKnyJRI_Bo3p6I4FwdZe-clPGAhAdgGIcjeewyagTRpGb8eQ1H2eTkuvYAvA_w4CIBtQVsWAA0gpQSp_Cu-wib3qzUQgQfKXv3yyt9IwcSOnz7M6AIjeYEyecj8mfFv0Rrmx-7O-6fPAQ4uTNOGB9SRDhlHByg86u9_jcn5-RtJj3GgZ9ImMtxTgMQK54hO42g","token_type":"bearer","expires_in":86399,"userName":"harrisonwells",".issued":"Tue, 14 May 2019 02:36:57 GMT",".expires":"Wed, 15 May 2019 02:36:57 GMT","error":null,"error_description":null,"FileResourceID":null,"EmployeeID":null,"FullName":"Harrison Wells","UserID":400,"GroupID":1,"ReportYear":2019}', CAST(N'2019-05-15 09:36:57.823' AS DateTime), CAST(N'2019-05-14 09:36:57.823' AS DateTime))
INSERT [dbo].[Tokens] ([TokenId], [UserName], [Token], [ExpiresOn], [IssuedOn]) VALUES (N'1d81e459-5f9a-47d7-9d2b-730ab495d195', N'haigv', N'{"access_token":"5Jl4EpH40EAfw6QddaH0ICLas1K3laiytsYjDxWJqiWzZ8bd4ZRKYn7sC50cxUMCDnneYOZP_uQDjwxQ9gaW5tT1-U4uU_ipbG4GqiJx5bCFl1xsk9jseE0GbXQ43qBdZOcSbx9vf8AX8jnSFlMPlmub4RgCBc8YvU3tWZMGmek1ZJZiBd6lc0ARHaz77gZxx8sTH0LhR9UkV-Yn3LFJj1FbKjSItL9PoNA0nBHgSm6QYiss2fpPldoFIx65ejBwpml9_4oftoPYKYIvKkoZVUfZeSGVaZfnRaOTVHwj7O4wwwf14uS8CNusNqrWBsXOoWXl9vYRK-P4mhKaN91cw-T864D4w3JvNETC8OhRiArYnSXkxS1e3oIwPVUm8NermDOUw9Ap4Y5_nADxX0asWHBeDt4gnECIt9GlCzGdotbBNOkDPqy_bUm5fyp480YBk8buu8xoD5aDiStI8Kz0BGg5ez41LSl-IAGUPEzBxFP5_nylc-Y2iCHAFyVlcNqpKfBOW8cbGG-Ge_n8cVdNa4cgHePJpsyM6Xqgy0AiwdacD_lsy7B-g44ABMCgO_wy","token_type":"bearer","expires_in":86399,"userName":"haigv",".issued":"Tue, 14 May 2019 02:42:32 GMT",".expires":"Wed, 15 May 2019 02:42:32 GMT","error":null,"error_description":null,"FileResourceID":null,"EmployeeID":null,"FullName":"Giang Văn Hải","UserID":111,"GroupID":-1,"ReportYear":2019}', CAST(N'2019-05-15 09:42:32.817' AS DateTime), CAST(N'2019-05-14 09:42:32.817' AS DateTime))
INSERT [dbo].[Tokens] ([TokenId], [UserName], [Token], [ExpiresOn], [IssuedOn]) VALUES (N'f402a24b-b7a4-4302-b095-cf4e42f914ab', N'haigv1', N'{"access_token":"zp0Ijfoy46lUMA52Q8A6ukdtJQw2MU-p83vweU_kZaILp9kwt5x10_MCdYMQhiDCkhXtoMvZH_dS1JxxSyl6xCPU0spezd-ZLKmkfnrW7gscPMeN3Yb3GNxzDGwwAscVBFt4a60cCBmLcf9323bGnyd5D6gJA_HmWjGwekH59t6X-ChaT5LQqFKEiZQNUXpHmQgGPqsyxGrPgsF3YPFc0CoJYMMOKYCGZnDInlM6Ix0HyfQzqJpfbnWoJTJHQQM0pX20LHp55QsDY_fmYxK5FCBwPckUEtQjICPIrLwWUV1dJSWw3t4X_UmAn66aNILdUMXGmTm1prtmgWjKm50jAZFecyPwgkh2lp1MY5hcyc69GXcj1wiXPMBF-ewvO44SnC6bBJem704BBxFcWQkpydTYFUZ8Ku4zmdX5EWsSgUs8Evg_Y_LjT38w3datLw2Q51Wd1zi9J_47S0fv0QwJZres6gWEQYWEwPs9Nk7w-rHAeI1bmaJLvgKiiIUaM53asG66dY3qRRw1t7N9Youy27t6aZR9Tc0yHRCGULxBM7P_955RDHUj2STM_jA1SK84","token_type":"bearer","expires_in":86399,"userName":"haigv1",".issued":"Mon, 13 May 2019 17:50:03 GMT",".expires":"Tue, 14 May 2019 17:50:03 GMT","error":null,"error_description":null,"FileResourceID":null,"EmployeeID":null,"FullName":"Giang Văn Hải","UserID":213,"GroupID":1,"ReportYear":2019}', CAST(N'2019-05-15 00:50:03.873' AS DateTime), CAST(N'2019-05-14 00:50:03.873' AS DateTime))
SET ANSI_PADDING ON

GO
/****** Object:  Index [RoleNameIndex]    Script Date: 8/7/2019 11:34:30 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [RoleNameIndex] ON [dbo].[AspNetRoles]
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_UserId]    Script Date: 8/7/2019 11:34:30 PM ******/
CREATE NONCLUSTERED INDEX [IX_UserId] ON [dbo].[AspNetUserClaims]
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_UserId]    Script Date: 8/7/2019 11:34:30 PM ******/
CREATE NONCLUSTERED INDEX [IX_UserId] ON [dbo].[AspNetUserLogins]
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_RoleId]    Script Date: 8/7/2019 11:34:30 PM ******/
CREATE NONCLUSTERED INDEX [IX_RoleId] ON [dbo].[AspNetUserRoles]
(
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_UserId]    Script Date: 8/7/2019 11:34:30 PM ******/
CREATE NONCLUSTERED INDEX [IX_UserId] ON [dbo].[AspNetUserRoles]
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UserNameIndex]    Script Date: 8/7/2019 11:34:30 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [UserNameIndex] ON [dbo].[AspNetUsers]
(
	[UserName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[News] ADD  CONSTRAINT [DF_News_NewsTittle]  DEFAULT (N'') FOR [NewsTittle]
GO
ALTER TABLE [dbo].[News] ADD  CONSTRAINT [DF_News_NewContent]  DEFAULT (N'') FOR [NewContent]
GO
ALTER TABLE [dbo].[News] ADD  CONSTRAINT [DF_News_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[News] ADD  CONSTRAINT [DF_News_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [dbo].[News] ADD  CONSTRAINT [DF_News_IPAddress]  DEFAULT (N'') FOR [IPAddress]
GO
ALTER TABLE [dbo].[News] ADD  CONSTRAINT [DF_News_ModifiedBy]  DEFAULT (N'') FOR [ModifiedBy]
GO
ALTER TABLE [dbo].[News] ADD  CONSTRAINT [DF_News_CreatedBy]  DEFAULT (N'') FOR [CreatedBy]
GO
ALTER TABLE [dbo].[StatusViewNotifications] ADD  CONSTRAINT [DF_StatusViewNotifications_StatusViewNotifications]  DEFAULT ((0)) FOR [StatusViewNotifications]
GO
ALTER TABLE [dbo].[AspNetUserClaims]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AspNetUserClaims_dbo.AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserClaims] CHECK CONSTRAINT [FK_dbo.AspNetUserClaims_dbo.AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[AspNetUserLogins]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AspNetUserLogins_dbo.AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserLogins] CHECK CONSTRAINT [FK_dbo.AspNetUserLogins_dbo.AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[AspNetUserRoles]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetRoles_RoleId] FOREIGN KEY([RoleId])
REFERENCES [dbo].[AspNetRoles] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserRoles] CHECK CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetRoles_RoleId]
GO
ALTER TABLE [dbo].[AspNetUserRoles]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserRoles] CHECK CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetUsers_UserId]
GO
/****** Object:  StoredProcedure [dbo].[CheckExistProject]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<dvthang>
-- Create date: <29.1.2018>
-- Description:	<Kiểm tra đề tài đã tồn tại chưa>
-- =============================================
CREATE PROCEDURE [dbo].[CheckExistProject]
    @projectID UNIQUEIDENTIFIER ,
    @projectCode NVARCHAR(64) ,
    @editMode INT
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

        IF NOT EXISTS ( SELECT TOP 1
                                1
                        FROM    dbo.Project
                        WHERE   ( ( @editMode IN ( 1, 2 )
                                    AND ProjectCode = @projectCode
                                  )
                                  OR ( @editMode NOT IN ( 1, 2 )
                                       AND ProjectCode = @projectCode
                                       AND ProjectID <> @projectID
                                     )
                                ) )
            BEGIN
	 	
                SELECT  0;
            END
        ELSE
            BEGIN
     	
                SELECT  1;
            END
    END




GO
/****** Object:  StoredProcedure [dbo].[GetListProjectPlanExpenseByMasterID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<truongnm>
-- Create date: <11.02.2018>
-- Description:	<Lấy danh sách Kế hoạch thực hiện>
-- =============================================
CREATE PROCEDURE [dbo].[GetListProjectPlanExpenseByMasterID]
    @MasterID UNIQUEIDENTIFIER
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

        SELECT  *
        FROM    dbo.ProjectPlanExpense
        WHERE   ProjectID = @MasterID
    END




GO
/****** Object:  StoredProcedure [dbo].[GetListProjectPlanPerformByMasterID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<truongnm>
-- Create date: <11.02.2018>
-- Description:	<Lấy danh sách Kế hoạch thực hiện>
-- =============================================
CREATE PROCEDURE [dbo].[GetListProjectPlanPerformByMasterID]
    @MasterID UNIQUEIDENTIFIER
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

        SELECT  *
        FROM    dbo.ProjectPlanPerform
        WHERE   ProjectID = @MasterID
    END




GO
/****** Object:  StoredProcedure [dbo].[GetListProjectWorkshopByMasterID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetListProjectWorkshopByMasterID]
    @MasterID UNIQUEIDENTIFIER
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

        SELECT  *
        FROM    dbo.ProjectWorkshop
        WHERE   ProjectID = @MasterID
    END



GO
/****** Object:  StoredProcedure [dbo].[Proc_CheckExistProject]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<dvthang>
-- Create date: <29.1.2018>
-- Description:	<Kiểm tra đề tài đã tồn tại chưa>
-- =============================================
create PROCEDURE [dbo].[Proc_CheckExistProject]
    @projectID UNIQUEIDENTIFIER ,
    @projectCode NVARCHAR(64) ,
    @editMode INT
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

        IF NOT EXISTS ( SELECT TOP 1
                                1
                        FROM    dbo.Project
                        WHERE   ( ( @editMode IN ( 1, 2 )
                                    AND ProjectCode = @projectCode
                                  )
                                  OR ( @editMode NOT IN ( 1, 2 )
                                       AND ProjectCode = @projectCode
                                       AND ProjectID <> @projectID
                                     )
                                ) )
            BEGIN
	 	
                SELECT  0;
            END
        ELSE
            BEGIN
     	
                SELECT  1;
            END
    END




GO
/****** Object:  StoredProcedure [dbo].[Proc_CheckExitsAcademicRankCode]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Proc_CheckExitsAcademicRankCode]
  @AcademicRankID uniqueidentifier,
  @AcademicRankCode nvarchar(64),
  @EditMode int
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

        IF EXISTS ( SELECT TOP 1
                            1
                    FROM    dbo.AcademicRank
                    WHERE   ( ( @EditMode = 3
                                AND AcademicRankID <> @AcademicRankID
                                AND AcademicRankCode = @AcademicRankCode
                              )
                              OR (@EditMode <> 3 AND AcademicRankCode = @AcademicRankCode )
                            ) 
					)
            BEGIN
                SELECT  1
            END
        ELSE
            BEGIN
                SELECT  0;
            END

    END




GO
/****** Object:  StoredProcedure [dbo].[Proc_CheckExitsCategoryCode]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Proc_CheckExitsCategoryCode]
    @CategoryID UNIQUEIDENTIFIER ,
    @EditMode INT
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

        IF EXISTS ( SELECT TOP 1
                            1
                    FROM    dbo.Category
                    WHERE   ( ( @EditMode = 3
                                AND CategoryID <> @CategoryID
                              )
                              OR (@EditMode <> 3 )
                            ) )
            BEGIN
                SELECT  1
            END
        ELSE
            BEGIN
                SELECT  0;
            END

    END




GO
/****** Object:  StoredProcedure [dbo].[Proc_CheckExitsCompanyCode]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Proc_CheckExitsCompanyCode]
  @CompanyID uniqueidentifier,
  @CompanyCode nvarchar(64),
  @EditMode int
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

        IF EXISTS ( SELECT TOP 1
                            1
                    FROM    dbo.Company
                    WHERE   ( ( @EditMode = 3
                                AND CompanyID <> @CompanyID
                                AND CompanyCode = @CompanyCode
                              )
                              OR (@EditMode <> 3 AND CompanyCode = @CompanyCode )
                            ) 
					)
            BEGIN
                SELECT  1
            END
        ELSE
            BEGIN
                SELECT  0;
            END

    END




GO
/****** Object:  StoredProcedure [dbo].[Proc_CheckExitsDayOffCode]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Proc_CheckExitsDayOffCode]
    @DayOffID uniqueidentifier ,
    @EditMode INT
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

        IF EXISTS ( SELECT TOP 1
                            1
                    FROM    dbo.DayOff
                    WHERE   ( ( @EditMode <> 3
                                AND DayOffID = @DayOffID
                              )
                            ) 
			)
            BEGIN
                SELECT  1
            END
        ELSE
            BEGIN
                SELECT  0;
            END

    END




GO
/****** Object:  StoredProcedure [dbo].[Proc_CheckExitsDegreeCode]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Proc_CheckExitsDegreeCode]
  @DegreeID uniqueidentifier,
  @DegreeCode nvarchar(64),
  @EditMode int
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

        IF EXISTS ( SELECT TOP 1
                            1
                    FROM    dbo.Degree
                    WHERE   ( ( @EditMode = 3
                                AND DegreeID <> @DegreeID
                                AND DegreeCode = @DegreeCode
                              )
                              OR (@EditMode <> 3 AND DegreeCode = @DegreeCode )
                            ) 
					)
            BEGIN
                SELECT  1
            END
        ELSE
            BEGIN
                SELECT  0;
            END

    END




GO
/****** Object:  StoredProcedure [dbo].[Proc_CheckExitsEmployeeCode]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<dvthang>
-- Create date: <20.2.2018>
-- Description:	<Kiểm tra trùng mã nhân viên>
-- =============================================
--[dbo].[Proc_CheckExitsEmployeeCode] '60ce5f19-450b-4679-bc52-37a81e9135d8','vannh',3
CREATE PROCEDURE [dbo].[Proc_CheckExitsEmployeeCode]
  @EmployeeID uniqueidentifier,
  @EmployeeCode nvarchar(64),
  @EditMode int
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

        IF EXISTS ( SELECT TOP 1
                            1
                    FROM    dbo.Employee
                    WHERE   ( ( @EditMode = 3
                                AND EmployeeID <> @EmployeeID
                                AND EmployeeCode = @EmployeeCode
                              )
                              OR ( @EditMode <>3 AND EmployeeCode = @EmployeeCode )
                            ) 
					)
            BEGIN
                SELECT  1
            END
        ELSE
            BEGIN
                SELECT  0;
            END

    END




GO
/****** Object:  StoredProcedure [dbo].[Proc_CheckExitsFullName]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<manh>
-- Create date: <30.05.18>
-- Description:	<Kiểm tra trùng họ tên và ngày sinh>
-- =============================================
--[dbo].[Proc_CheckExitsFullName] N'Trần Thị Ngọc ',N' Tuyết',3
CREATE PROCEDURE [dbo].[Proc_CheckExitsFullName]
    @LastName NVARCHAR(128) ,
    @FirstName NVARCHAR(128) ,
    @EditMode INT
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

        IF EXISTS ( SELECT TOP 1
                            1
                    FROM    dbo.Employee
                    WHERE   ( ( @EditMode = 3
                                AND LTRIM(RTRIM(LastName)) = N''
                                + LTRIM(RTRIM(@LastName)) + ''
                                AND LTRIM(RTRIM(FirstName)) = N''
                                + LTRIM(RTRIM(@FirstName)) + ''
                              )
                              OR ( @EditMode <> 3
                                   AND LTRIM(RTRIM(LastName)) = N''
                                   + LTRIM(RTRIM(@LastName)) + ''
                                   AND LTRIM(RTRIM(FirstName)) = N''
                                   + LTRIM(RTRIM(@FirstName)) + ''
                                 )
                            ) )
            BEGIN
                SELECT  1
            END
        ELSE
            BEGIN
                SELECT  0;
            END
    END




GO
/****** Object:  StoredProcedure [dbo].[Proc_CheckExitsFullName_CompanyID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<manh>
-- Create date: <30.05.18>
-- Description:	<Kiểm tra trùng họ tên và đơn vị>
-- =============================================
--[dbo].[Proc_CheckExitsFullName_PositionID] '43F521F3-6DCC-4726-920E-BC028C915766','Phí Hồng Mạnh hỒnG','660A1800-3E4A-49A4-BF7E-524907A7C375',3
CREATE PROCEDURE [dbo].[Proc_CheckExitsFullName_CompanyID]
    @EmployeeID UNIQUEIDENTIFIER ,
    @FullName NVARCHAR(255) ,
    @CompanyID UNIQUEIDENTIFIER ,
    @EditMode INT
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

        IF EXISTS ( SELECT TOP 1
                            1
                    FROM    dbo.Employee
                    WHERE   ( ( @EditMode = 3
                                AND EmployeeID <> @EmployeeID
                                AND FullName = @FullName
                                AND CompanyID = @CompanyID
                              )
                              OR ( @EditMode <> 3
                                   AND FullName = @FullName
                                   AND CompanyID = @CompanyID
                                 )
                            ) )
            BEGIN
                SELECT  1
            END
        ELSE
            BEGIN
                SELECT  0;
            END

    END




GO
/****** Object:  StoredProcedure [dbo].[Proc_CheckExitsGrantRatioCode]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Proc_CheckExitsGrantRatioCode]
  @GrantRatioID uniqueidentifier,
  @GrantRatioCode nvarchar(64),
  @EditMode int
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

        IF EXISTS ( SELECT TOP 1
                            1
                    FROM    dbo.GrantRatio
                    WHERE   ( ( @EditMode = 3
                                AND GrantRatioID <> @GrantRatioID
                                AND GrantRatioCode = @GrantRatioCode
                              )
                              OR (@EditMode <> 3 AND GrantRatioCode = @GrantRatioCode )
                            ) 
					)
            BEGIN
                SELECT  1
            END
        ELSE
            BEGIN
                SELECT  0;
            END

    END




GO
/****** Object:  StoredProcedure [dbo].[Proc_CheckExitsLevelCode]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Proc_CheckExitsLevelCode]
    @LevelID int ,
    @LevelCode NVARCHAR(50) ,
    @EditMode INT
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

        IF EXISTS ( SELECT TOP 1
                            1
                    FROM    dbo.Level
                    WHERE   ( ( @EditMode = 3
                                AND LevelID <> @LevelID
                                AND LevelCode = @LevelCode
                              )
                              OR (@EditMode <> 3 AND LevelCode = @LevelCode )
                            ) 
			)
            BEGIN
                SELECT  1
            END
        ELSE
            BEGIN
                SELECT  0;
            END

    END




GO
/****** Object:  StoredProcedure [dbo].[Proc_CheckExitsProjectMemberCode]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- [dbo].[Proc_CheckExitsProjectMemberCode] '4202199d-8841-4ab2-b36d-8c73a65b06d4','b0ce4e46-be93-4294-818d-88fd5e824db9','f32ebd6e-a9d2-4703-aad2-1d83ac88b7c1',3
-- =============================================
CREATE PROCEDURE [dbo].[Proc_CheckExitsProjectMemberCode]
  @ProjectMemberID uniqueidentifier,
  @ProjectID uniqueidentifier,
  @EmployeeID uniqueidentifier,
  @EditMode int
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

        IF EXISTS ( SELECT TOP 1
                            1
                    FROM    dbo.ProjectMember
                    WHERE   ( ( @EditMode = 3
								AND ProjectID = @ProjectID
                                AND ProjectMemberID <> @ProjectMemberID
                                AND EmployeeID = @EmployeeID
                              )
                              OR (@EditMode <> 3 AND ProjectID = @ProjectID AND EmployeeID = @EmployeeID )
                            ) 
					)
            BEGIN
                SELECT  1
            END
        ELSE
            BEGIN
                SELECT  0;
            END

    END





GO
/****** Object:  StoredProcedure [dbo].[Proc_CheckExitsProjectPositionCode]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Proc_CheckExitsProjectPositionCode]
  @ProjectPositionID uniqueidentifier,
  @ProjectPositionCode nvarchar(64),
  @EditMode int
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

        IF EXISTS ( SELECT TOP 1
                            1
                    FROM    dbo.ProjectPosition
                    WHERE   ( ( @EditMode = 3
                                AND ProjectPositionID <> @ProjectPositionID
                                AND ProjectPositionCode = @ProjectPositionCode
                              )
                              OR (@EditMode <> 3 AND ProjectPositionCode = @ProjectPositionCode )
                            ) 
					)
            BEGIN
                SELECT  1
            END
        ELSE
            BEGIN
                SELECT  0;
            END

    END




GO
/****** Object:  StoredProcedure [dbo].[Proc_CheckExitsRankCode]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Proc_CheckExitsRankCode]
    @RankID UNIQUEIDENTIFIER ,
    @RankCode NVARCHAR(50) ,
    @EditMode INT
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

        IF EXISTS ( SELECT TOP 1
                            1
                    FROM    dbo.Rank
                    WHERE   ( ( @EditMode = 3
                                AND RankID <> @RankID
                                AND RankCode = @RankCode
                              )
                              OR (@EditMode <> 3 AND RankCode = @RankCode )
                            ) )
            BEGIN
                SELECT  1
            END
        ELSE
            BEGIN
                SELECT  0;
            END

    END




GO
/****** Object:  StoredProcedure [dbo].[Proc_CheckExitsUserName]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Proc_CheckExitsUserName]
  @UserName nvarchar(256),
  @Id NVARCHAR(128),
  @EditMode int
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

        IF EXISTS ( SELECT TOP 1
                            1
                    FROM    dbo.AspNetUsers
                    WHERE   ( ( @EditMode = 3
                                AND id <> @Id
                                AND UserName = @UserName
                              )
                              OR (@EditMode <> 3 AND UserName = @UserName )
                            ) 
					)
            BEGIN
                SELECT  1
            END
        ELSE
            BEGIN
                SELECT  0;
            END

    END

GO
/****** Object:  StoredProcedure [dbo].[Proc_CheckIncurrentData]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<dvthang>
-- Create date: <28.03.2018>
-- Description:	<Kiểm tra phát sinh dữ liệu trước khi xóa>
-- =============================================
CREATE PROCEDURE [dbo].[Proc_CheckIncurrentData]
    @TableName VARCHAR(50) ,
    @ID INT
AS
    BEGIN
	  
        IF ( @TableName = 'Project' )
            BEGIN
                IF EXISTS ( SELECT  *
                            FROM    dbo.ProjectTask
                            WHERE   ProjectID = @ID )
                    OR EXISTS ( SELECT  *
                                FROM    dbo.ProjectPlanPerform
                                WHERE   ProjectID = @ID )
                    OR EXISTS ( SELECT  *
                                FROM    dbo.ProjectMember
                                WHERE   ProjectID = @ID )
                    OR EXISTS ( SELECT  *
                                FROM    dbo.ProjectPlanExpense
                                WHERE   ProjectID = @ID )
                    OR EXISTS ( SELECT  *
                                FROM    dbo.ProjectSurvey
                                WHERE   ProjectID = @ID )
                    OR EXISTS ( SELECT  *
                                FROM    dbo.ContentServey
                                WHERE   ProjectID = @ID )
                    OR EXISTS ( SELECT  *
                                FROM    dbo.ProjectExperiment
                                WHERE   ProjectID = @ID )
                    OR EXISTS ( SELECT  *
                                FROM    dbo.ProjectProgressReport
                                WHERE   ProjectID = @ID )
                    OR EXISTS ( SELECT  *
                                FROM    dbo.ProjectWorkshop
                                WHERE   ProjectID = @ID )
                    OR EXISTS ( SELECT  *
                                FROM    dbo.ProjectAcceptanceBasic
                                WHERE   ProjectID = @ID )
                    OR EXISTS ( SELECT  *
                                FROM    dbo.ProjectAcceptanceManage
                                WHERE   ProjectID = @ID )
                    OR EXISTS ( SELECT  *
                                FROM    dbo.ProjectClose
                                WHERE   ProjectID = @ID )
                    OR EXISTS ( SELECT  *
                                FROM    dbo.ProjectTaskMemberFinance
                                WHERE   ProjectID = @ID )
                    BEGIN
                        SELECT  1
                        RETURN
                    END
            END
	  
        IF ( @TableName = 'ProjectTask' )
            BEGIN
                IF EXISTS ( SELECT  *
                            FROM    dbo.ProjectTaskMemberFinance
                            WHERE   ProjectTaskID = @ID )
                    OR EXISTS ( SELECT  *
                                FROM    dbo.ProjectTaskMember
                                WHERE   ProjectTaskID = @ID )
                    BEGIN
                        SELECT  1
                        RETURN
						
                    END
            END

        IF ( @TableName = 'Employee' )
            BEGIN
                IF EXISTS ( SELECT  *
                            FROM    dbo.Project
                            WHERE   EmployeeID = @ID )
                    OR EXISTS ( SELECT  *
                                FROM    dbo.ProjectTaskMember
                                WHERE   EmployeeID = @ID )
                    OR EXISTS ( SELECT  *
                                FROM    dbo.ProjectTaskMemberFinance
                                WHERE   EmployeeID = @ID )
                    OR EXISTS ( SELECT  *
                                FROM    dbo.ProjectMember
                                WHERE   EmployeeID = @ID )
                    BEGIN
                        SELECT  1
                        RETURN
						
                    END
            END
        IF ( @TableName = 'Degree' )
            BEGIN
                IF EXISTS ( SELECT  *
                            FROM    dbo.Employee
                            WHERE   DegreeID = @ID )
                    BEGIN
                        SELECT  1
                        RETURN
						
                    END
            END
        IF ( @TableName = 'AcademicRank' )
            BEGIN
                IF EXISTS ( SELECT  *
                            FROM    dbo.Employee
                            WHERE   AcademicRankID = @ID )
                    BEGIN
                        SELECT  1
                        RETURN
						
                    END
            END

        IF ( @TableName = 'Rank' )
            BEGIN
                IF EXISTS ( SELECT  *
                            FROM    dbo.Employee
                            WHERE   RankID = @ID )
                    BEGIN
                        SELECT  1
                        RETURN
						
                    END
            END

        IF ( @TableName = 'Company' )
            BEGIN
                IF EXISTS ( SELECT  *
                            FROM    dbo.Employee
                            WHERE   CompanyID = @ID )
                    OR EXISTS ( SELECT  *
                                FROM    dbo.Project
                                WHERE   CompanyID = @ID )
                    BEGIN
                        SELECT  1
                        RETURN
						
                    END
            END
        SELECT  0;
    END




GO
/****** Object:  StoredProcedure [dbo].[Proc_CheckNoExistsTaskChildUnStatus]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<dvthang>
-- Create date: <03.01.2018>
-- Description:	<Kiểm tra xem các task con của 1 task đã cập nhật trạng thái chưa,
-- nếu tất cả đã cập nhật roh thì mới cho cập task cha >
-- =============================================
CREATE PROCEDURE [dbo].[Proc_CheckNoExistsTaskChildUnStatus]
    @projectTaskID UNIQUEIDENTIFIER ,
    @status INT
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

        WITH    temp ( id, status )
                  AS ( SELECT   ProjectTaskID ,
                                Status
                       FROM     dbo.ProjectTask
                       WHERE    ProjectTaskID = @projectTaskID
                       UNION ALL
                       SELECT   b.ProjectTaskID ,
                                a.status
                       FROM     temp AS a ,
                                dbo.ProjectTask AS b
                       WHERE    a.id = b.ParentID
                                AND b.Status <> @status
                     )
            SELECT  *
            INTO    #T
            FROM    temp

		--Không tồn tài con nào có trạng thái là status<> khác trạng thái hiện tại 
		--thì được phép cập nhật, ngược lại thì ko
        IF NOT EXISTS ( SELECT  *
                        FROM    #T
                        WHERE   id <> @projectTaskID )
            BEGIN
                SELECT  1
            END
        ELSE
            BEGIN
                SELECT  0
            END
    END




GO
/****** Object:  StoredProcedure [dbo].[Proc_CheckPermissionProjectMember]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Manh
-- Create date: 21.08.18
-- Description:	Kiểm tra quyền của người dùng với đề tài
-- Proc_CheckPermissionProjectMember '1C71BA3F-FBA0-4533-9C81-551C2576CC7C','C1644EF7-2BB9-4715-A3F8-3F21638D2C18'
-- =============================================
CREATE PROCEDURE [dbo].[Proc_CheckPermissionProjectMember]
    @EmployeeID UNIQUEIDENTIFIER ,
    @ProjectID UNIQUEIDENTIFIER
AS
    BEGIN
        IF EXISTS ( SELECT TOP 1
                            1
                    FROM    dbo.ProjectInput
                    WHERE   EmployeeID = @EmployeeID
                            AND ProjectID = @ProjectID )
            BEGIN
                SELECT  1
            END
        ELSE
            BEGIN
                SELECT  0
            END
    END




GO
/****** Object:  StoredProcedure [dbo].[Proc_DeleteAcademicRankByID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_DeleteAcademicRankByID]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   truong using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_DeleteAcademicRankByID]
-- Date Generated: Saturday, January 13, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_DeleteAcademicRankByID]
	@AcademicRankID uniqueidentifier
AS


DELETE FROM [dbo].[AcademicRank]
WHERE
	[AcademicRankID] = @AcademicRankID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_DeleteAspNetUsersByID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Proc_DeleteAspNetUsersByID]
	@Id nvarchar(128)
AS


DELETE FROM [dbo].[AspNetUsers]
WHERE
	[Id] = @Id

--endregion


GO
/****** Object:  StoredProcedure [dbo].[Proc_DeleteCompanyByID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_DeleteCompanyByID]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   truong using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_DeleteCompanyByID]
-- Date Generated: Saturday, January 13, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_DeleteCompanyByID]
	@CompanyID uniqueidentifier
AS


DELETE FROM [dbo].[Company]
WHERE
	[CompanyID] = @CompanyID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_DeleteContentExperimentByID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_DeleteContentExperimentByID]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   Admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_DeleteContentExperimentByID]
-- Date Generated: Sunday, February 25, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_DeleteContentExperimentByID]
	@ID uniqueidentifier
AS



DELETE FROM [dbo].[ContentExperiment]
WHERE
	[ID] = @ID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_DeleteContentServeyByID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_DeleteContentServeyByID]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   THANG using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_DeleteContentServeyByID]
-- Date Generated: Saturday, February 24, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_DeleteContentServeyByID]
	@ID uniqueidentifier
AS


DELETE FROM [dbo].[ContentServey]
WHERE
	[ID] = @ID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_DeleteCustomerByID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Proc_DeleteCustomerByID]
	@CustomerID int
AS


DELETE FROM [dbo].[Customer]
WHERE
	[CustomerID] = @CustomerID

--endregion


GO
/****** Object:  StoredProcedure [dbo].[Proc_DeleteDayOffByID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_DeleteDayOffByID]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   truong using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_DeleteDayOffByID]
-- Date Generated: Saturday, March 3, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_DeleteDayOffByID]
	@DayOffID uniqueidentifier
AS


DELETE FROM [dbo].[DayOff]
WHERE
	[DayOffID] = @DayOffID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_DeleteDegreeByID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_DeleteDegreeByID]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_DeleteDegreeByID]
-- Date Generated: 13 Tháng Giêng 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_DeleteDegreeByID]
	@DegreeID uniqueidentifier
AS



DELETE FROM [dbo].[Degree]
WHERE
	[DegreeID] = @DegreeID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_DeleteEmployeeByID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_DeleteEmployeeByID]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_DeleteEmployeeByID]
-- Date Generated: 14 Tháng Giêng 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_DeleteEmployeeByID]
	@EmployeeID uniqueidentifier
AS



DELETE FROM [dbo].[Employee]
WHERE
	[EmployeeID] = @EmployeeID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_DeleteGrantRatioByID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_DeleteGrantRatioByID]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   truong using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_DeleteGrantRatioByID]
-- Date Generated: Wednesday, May 23, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_DeleteGrantRatioByID]
	@GrantRatioID uniqueidentifier
AS


DELETE FROM [dbo].[GrantRatio]
WHERE
	[GrantRatioID] = @GrantRatioID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_DeleteLevelByID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_DeleteLevelByID]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   Phamlai using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_DeleteLevelByID]
-- Date Generated: Saturday, January 13, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_DeleteLevelByID]
	@LevelID int
AS


DELETE FROM [dbo].[Level]
WHERE
	[LevelID] = @LevelID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_DeleteMedicalRecordByID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Proc_DeleteMedicalRecordByID]
	@MedicalRecordID int
AS


DELETE FROM [dbo].[MedicalRecord]
WHERE
	[MedicalRecordID] = @MedicalRecordID

SELECT @MedicalRecordID
--endregion


GO
/****** Object:  StoredProcedure [dbo].[Proc_DeleteProject_AttachDetailByID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_DeleteProject_AttachDetailByID]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   THANG using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_DeleteProject_AttachDetailByID]
-- Date Generated: Sunday, February 4, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_DeleteProject_AttachDetailByID]
	@Project_AttachDetailID uniqueidentifier
AS


DELETE FROM [dbo].[Project_AttachDetail]
WHERE
	[Project_AttachDetailID] = @Project_AttachDetailID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_DeleteProjectAcceptanceBasic_AttachDetailByID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_DeleteProjectAcceptanceBasic_AttachDetailByID]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_DeleteProjectAcceptanceBasic_AttachDetailByID]
-- Date Generated: 05 Tháng Hai 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_DeleteProjectAcceptanceBasic_AttachDetailByID]
	@ProjectAcceptanceBasic_AttachDetailID uniqueidentifier
AS



DELETE FROM [dbo].[ProjectAcceptanceBasic_AttachDetail]
WHERE
	[ProjectAcceptanceBasic_AttachDetailID] = @ProjectAcceptanceBasic_AttachDetailID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_DeleteProjectAcceptanceManage_AttachDetailByID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_DeleteProjectAcceptanceManage_AttachDetailByID]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_DeleteProjectAcceptanceManage_AttachDetailByID]
-- Date Generated: 09 Tháng Hai 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_DeleteProjectAcceptanceManage_AttachDetailByID]
	@ProjectAcceptanceManage_AttachDetailID uniqueidentifier
AS



DELETE FROM [dbo].[ProjectAcceptanceManage_AttachDetail]
WHERE
	[ProjectAcceptanceManage_AttachDetailID] = @ProjectAcceptanceManage_AttachDetailID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_DeleteProjectByID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_DeleteProjectByID]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   THANG using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_DeleteProjectByID]
-- Date Generated: Sunday, January 28, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_DeleteProjectByID]
	@ProjectID uniqueidentifier
AS


DELETE FROM [dbo].[Project]
WHERE
	[ProjectID] = @ProjectID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_DeleteProjectClose_AttachDetailByID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_DeleteProjectClose_AttachDetailByID]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_DeleteProjectClose_AttachDetailByID]
-- Date Generated: 09 Tháng Hai 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_DeleteProjectClose_AttachDetailByID]
	@ProjectClose_AttachDetailID uniqueidentifier
AS



DELETE FROM [dbo].[ProjectClose_AttachDetail]
WHERE
	[ProjectClose_AttachDetailID] = @ProjectClose_AttachDetailID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_DeleteProjectCloseByID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--region [dbo].[Proc_DeleteProjectCloseByID]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   truong using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_DeleteProjectCloseByID]
-- Date Generated: Sunday, March 4, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_DeleteProjectCloseByID]
	@ProjectCloseID uniqueidentifier
AS


DELETE FROM [dbo].[ProjectClose]
WHERE
	[ProjectCloseID] = @ProjectCloseID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_DeleteProjectExperiment_AttachDetailByID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_DeleteProjectExperiment_AttachDetailByID]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   Admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_DeleteProjectExperiment_AttachDetailByID]
-- Date Generated: Sunday, February 25, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_DeleteProjectExperiment_AttachDetailByID]
	@ProjectExperiment_AttachDetailID uniqueidentifier
AS



DELETE FROM [dbo].[ProjectExperiment_AttachDetail]
WHERE
	[ProjectExperiment_AttachDetailID] = @ProjectExperiment_AttachDetailID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_DeleteProjectExperiment_AttachDetailByMasterID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Manh>
-- Create date: <01.04.18>
-- Description:	<Xóa file đính kèm Thông tin thử nghiệm theo masterID>
-- =============================================
CREATE PROCEDURE [dbo].[Proc_DeleteProjectExperiment_AttachDetailByMasterID]
@MasterID UNIQUEIDENTIFIER
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	DELETE
	FROM dbo.ProjectExperiment_AttachDetail
	WHERE ProjectExperiment_AttachDetailID = @MasterID
END




GO
/****** Object:  StoredProcedure [dbo].[Proc_DeleteProjectExperimentByID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_DeleteProjectExperimentByID]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   Admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_DeleteProjectExperimentByID]
-- Date Generated: Sunday, February 25, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_DeleteProjectExperimentByID]
	@ProjectExperimentID uniqueidentifier
AS



DELETE FROM [dbo].[ProjectExperiment]
WHERE
	[ProjectExperimentID] = @ProjectExperimentID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_DeleteProjectInput]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Manh
-- Create date: 22.08.18
-- Description:	Xóa employee trong projectinput
-- =============================================
CREATE PROCEDURE [dbo].[Proc_DeleteProjectInput]
    @ProjectID UNIQUEIDENTIFIER ,
    @EmployeeID UNIQUEIDENTIFIER
AS
    BEGIN
        DELETE  FROM dbo.ProjectInput
        WHERE   ProjectID = @ProjectID
                AND EmployeeID = @EmployeeID
    END




GO
/****** Object:  StoredProcedure [dbo].[Proc_DeleteProjectMemberByID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_DeleteProjectMemberByID]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   truong using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_DeleteProjectMemberByID]
-- Date Generated: Sunday, January 28, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_DeleteProjectMemberByID]
	@ProjectMemberID uniqueidentifier
AS


DELETE FROM [dbo].[ProjectMember]
WHERE
	[ProjectMemberID] = @ProjectMemberID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_DeleteProjectPlanExpense_AttachDetailByID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_DeleteProjectPlanExpense_AttachDetailByID]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_DeleteProjectPlanExpense_AttachDetailByID]
-- Date Generated: 14 Tháng Giêng 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_DeleteProjectPlanExpense_AttachDetailByID]
	@ProjectPlanExpense_AttachDetailID uniqueidentifier
AS



DELETE FROM [dbo].[ProjectPlanExpense_AttachDetail]
WHERE
	[ProjectPlanExpense_AttachDetailID] = @ProjectPlanExpense_AttachDetailID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_DeleteProjectPlanExpenseByID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_DeleteProjectPlanExpenseByID]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   truong using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_DeleteProjectPlanExpenseByID]
-- Date Generated: Sunday, January 28, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_DeleteProjectPlanExpenseByID]
	@ProjectPlanExpenseID uniqueidentifier
AS


DELETE FROM [dbo].[ProjectPlanExpense]
WHERE
	[ProjectPlanExpenseID] = @ProjectPlanExpenseID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_DeleteProjectPlanPerform_AttachDetailByID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Proc_DeleteProjectPlanPerform_AttachDetailByID]
	@ProjectPlanPerform_AttachDetailID uniqueidentifier
AS


DELETE FROM [dbo].[ProjectPlanPerform_AttachDetail]
WHERE
	[ProjectPlanPerform_AttachDetailID] = @ProjectPlanPerform_AttachDetailID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_DeleteProjectPlanPerformByID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_DeleteProjectPlanPerformByID]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   Phamlai using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_DeleteProjectPlanPerformByID]
-- Date Generated: Monday, January 29, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_DeleteProjectPlanPerformByID]
	@ProjectPlanPerformID uniqueidentifier
AS


DELETE FROM [dbo].[ProjectPlanPerform]
WHERE
	[ProjectPlanPerformID] = @ProjectPlanPerformID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_DeleteProjectPositionByID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_DeleteProjectPostionByID]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_DeleteProjectPostionByID]
-- Date Generated: 14 Tháng Giêng 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_DeleteProjectPositionByID]
	@ProjectPositionID uniqueidentifier
AS



DELETE FROM [dbo].[ProjectPosition]
WHERE
	[ProjectPositionID] = @ProjectPositionID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_DeleteProjectPresentProtected_AttachDetailByID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_DeleteProjectPresentProtected_AttachDetailByID]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_DeleteProjectPresentProtected_AttachDetailByID]
-- Date Generated: 14 Tháng Giêng 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_DeleteProjectPresentProtected_AttachDetailByID]
	@ProjectPresentProtected_AttachDetailID uniqueidentifier
AS



DELETE FROM [dbo].[ProjectPresentProtected_AttachDetail]
WHERE
	[ProjectPresentProtected_AttachDetailID] = @ProjectPresentProtected_AttachDetailID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_DeleteProjectPresentProtectedByID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_DeleteProjectPresentProtectedByID]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_DeleteProjectPresentProtectedByID]
-- Date Generated: 14 Tháng Giêng 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_DeleteProjectPresentProtectedByID]
	@ProjectPresentProtectedID uniqueidentifier
AS



DELETE FROM [dbo].[ProjectPresentProtected]
WHERE
	[ProjectPresentProtectedID] = @ProjectPresentProtectedID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_DeleteProjectProgressReport_AttachDetailByID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_DeleteProjectProgressReport_AttachDetailByID]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   truong using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_DeleteProjectProgressReport_AttachDetailByID]
-- Date Generated: Sunday, February 25, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_DeleteProjectProgressReport_AttachDetailByID]
	@ProjectProgressReport_AttachDetailID uniqueidentifier
AS


DELETE FROM [dbo].[ProjectProgressReport_AttachDetail]
WHERE
	[ProjectProgressReport_AttachDetailID] = @ProjectProgressReport_AttachDetailID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_DeleteProjectProgressReport_AttachDetailByMasterID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Manh>
-- Create date: <01.04.18>
-- Description:	<Xóa file đính kèm báo cáo tiến độ theo masterID>
-- =============================================
CREATE PROCEDURE [dbo].[Proc_DeleteProjectProgressReport_AttachDetailByMasterID]
@MasterID UNIQUEIDENTIFIER
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	DELETE
	FROM dbo.ProjectProgressReport_AttachDetail
	WHERE ProjectProgressReport_AttachDetailID = @MasterID
END




GO
/****** Object:  StoredProcedure [dbo].[Proc_DeleteProjectProgressReportByID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_DeleteProjectProgressReportByID]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   truong using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_DeleteProjectProgressReportByID]
-- Date Generated: Wednesday, January 31, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_DeleteProjectProgressReportByID]
	@ProjectProgressReportID uniqueidentifier
AS


DELETE FROM [dbo].[ProjectProgressReport]
WHERE
	[ProjectProgressReportID] = @ProjectProgressReportID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_DeleteProjectSurvey_AttachDetailByID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_DeleteProjectSurvey_AttachDetailByID]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   THANG using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_DeleteProjectSurvey_AttachDetailByID]
-- Date Generated: Saturday, February 24, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_DeleteProjectSurvey_AttachDetailByID]
    @ProjectSurvey_AttachDetailID UNIQUEIDENTIFIER
AS
    BEGIN

        DECLARE @ID UNIQUEIDENTIFIER;

        SELECT  @ID = ID
        FROM    dbo.ProjectSurvey_AttachDetail
        WHERE   ProjectSurvey_AttachDetailID = @ProjectSurvey_AttachDetailID;


        DELETE  FROM [dbo].[ProjectSurvey_AttachDetail]
        WHERE   [ProjectSurvey_AttachDetailID] = @ProjectSurvey_AttachDetailID

        UPDATE  dbo.ContentServey
        SET     IdFiles = dbo.Func_GroupFileContenServeyIntoMaster(@ID)
        WHERE   ID = @ID
    END
--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_DeleteProjectSurvey_AttachDetailByMasterID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Manh>
-- Create date: <01.04.18>
-- Description:	<Xóa file đính kèm báo cáo tiến độ theo masterID>
-- =============================================
CREATE PROCEDURE [dbo].[Proc_DeleteProjectSurvey_AttachDetailByMasterID]
@MasterID UNIQUEIDENTIFIER
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	DELETE
	FROM dbo.ProjectSurvey_AttachDetail
	WHERE ProjectSurvey_AttachDetailID = @MasterID
END




GO
/****** Object:  StoredProcedure [dbo].[Proc_DeleteProjectSurveyByID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_DeleteProjectSurveyByID]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   THANG using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_DeleteProjectSurveyByID]
-- Date Generated: Saturday, February 24, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_DeleteProjectSurveyByID]
	@ProjectSurveyID uniqueidentifier
AS


DELETE FROM [dbo].[ProjectSurvey]
WHERE
	[ProjectSurveyID] = @ProjectSurveyID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_DeleteProjectTaskByID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_DeleteProjectTaskByID]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   THANG using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_DeleteProjectTaskByID]
-- Date Generated: Sunday, February 11, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_DeleteProjectTaskByID]
	@ProjectTaskID uniqueidentifier
AS


DELETE FROM [dbo].[ProjectTask]
WHERE
	[ProjectTaskID] = @ProjectTaskID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_DeleteProjectTaskMemberByID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_DeleteProjectTaskMemberByID]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   THANG using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_DeleteProjectTaskMemberByID]
-- Date Generated: Thursday, March 8, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_DeleteProjectTaskMemberByID]
	@ProjectTaskMemberID uniqueidentifier
AS


DELETE FROM [dbo].[ProjectTaskMember]
WHERE
	[ProjectTaskMemberID] = @ProjectTaskMemberID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_DeleteProjectWorkshop_AttachDetailByID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_DeleteProjectWorkshop_AttachDetailByID]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   Admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_DeleteProjectWorkshop_AttachDetailByID]
-- Date Generated: Saturday, February 24, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_DeleteProjectWorkshop_AttachDetailByID]
    @ProjectWorkshop_AttachDetailID UNIQUEIDENTIFIER
AS
    BEGIN

        DECLARE @ProjectWorkshopID UNIQUEIDENTIFIER

        SELECT  @ProjectWorkshopID = ProjectWorkshopID
        FROM    dbo.ProjectWorkshop_AttachDetail
        WHERE   ProjectWorkshop_AttachDetailID = @ProjectWorkshop_AttachDetailID
        DELETE  FROM [dbo].[ProjectWorkshop_AttachDetail]
        WHERE   [ProjectWorkshop_AttachDetailID] = @ProjectWorkshop_AttachDetailID

        UPDATE  dbo.ProjectWorkshop
        SET     IdFiles = dbo.[Func_GroupFileProjectWorkshopIntoMaster](@ProjectWorkshopID)
        WHERE   ProjectWorkshopID = @ProjectWorkshopID
    END
--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_DeleteProjectWorkshop_AttachDetailByMasterID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Manh>
-- Create date: <01.04.18>
-- Description:	<Xóa file đính kèm Hội thảo theo masterID>
-- =============================================
CREATE PROCEDURE [dbo].[Proc_DeleteProjectWorkshop_AttachDetailByMasterID]
@MasterID UNIQUEIDENTIFIER
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	DELETE
	FROM dbo.ProjectWorkshop_AttachDetail
	WHERE ProjectWorkshop_AttachDetailID = @MasterID
END




GO
/****** Object:  StoredProcedure [dbo].[Proc_DeleteProjectWorkshopByID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_DeleteProjectWorkshopByID]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   truong using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_DeleteProjectWorkshopByID]
-- Date Generated: Sunday, January 28, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_DeleteProjectWorkshopByID]
	@ProjectWorkshopID uniqueidentifier
AS


DELETE FROM [dbo].[ProjectWorkshop]
WHERE
	[ProjectWorkshopID] = @ProjectWorkshopID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_DeleteQADetailByID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Proc_DeleteQADetailByID]
	@QADetailID int
AS


DELETE FROM [dbo].[QADetail]
WHERE
	[QADetailID] = @QADetailID

--endregion


GO
/****** Object:  StoredProcedure [dbo].[Proc_DeleteQATopicByID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Proc_DeleteQATopicByID]
	@QATopicID int
AS


DELETE FROM [dbo].[QATopic]
WHERE
	[QATopicID] = @QATopicID

--endregion


GO
/****** Object:  StoredProcedure [dbo].[Proc_DeleteRankByID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_DeleteRankByID]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   THANG using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_DeleteRankByID]
-- Date Generated: Monday, January 8, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_DeleteRankByID]
	@RankID uniqueidentifier
AS


DELETE FROM [dbo].[Rank]
WHERE
	[RankID] = @RankID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_DeleteTokensByID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_DeleteTokensByID]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   THANG using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_DeleteTokensByID]
-- Date Generated: Friday, January 12, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_DeleteTokensByID]
	@TokenId uniqueidentifier
AS


DELETE FROM [dbo].[Tokens]
WHERE
	[TokenId] = @TokenId

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_GetCndtByProjectID_PositionID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<manh>
-- Create date: <28.05.18>
-- Description:	<Lấy chủ nhiệm đề tài theo projectID>
-- Proc_GetCndtByProjectID_PositionID 'c1644ef7-2bb9-4715-a3f8-3f21638d2c18'
-- =============================================
CREATE PROCEDURE [dbo].[Proc_GetCndtByProjectID_PositionID]
	-- Add the parameters for the stored procedure here
    @ProjectID UNIQUEIDENTIFIER
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;
        DECLARE @projectPosition UNIQUEIDENTIFIER = '37309CEE-1259-4498-B221-193532AFF374'
    -- Insert statements for procedure here
        SELECT  FullName
        FROM    dbo.View_ProjectMember
        WHERE   ProjectID = @ProjectID
                AND ProjectPositionID = @projectPosition
    END




GO
/****** Object:  StoredProcedure [dbo].[Proc_GetDataContractedProfessional_By_ProjectID_sProjectTastID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[Proc_GetDataContractedProfessional_By_ProjectID_sProjectTastID]
    @ProjectID UNIQUEIDENTIFIER ,
    @sProjectTastID NVARCHAR(4000)
AS
    BEGIN
	--B1: Lấy bảng hệ số tiền công theo đề tài
        CREATE TABLE #WageCoefficient
            (
              [ProjectPositionID] UNIQUEIDENTIFIER NULL ,
              [Month] INT NULL ,
              [Year] INT NULL ,
              [Coefficient] DECIMAL(20, 4) NULL,
            )
        INSERT  #WageCoefficient
                ( ProjectPositionID ,
                  Month ,
                  Year ,
                  Coefficient
			    )
                SELECT  WC.ProjectPositionID ,
                        WC.Month ,
                        WC.Year ,
                        WC.Coefficient
                FROM    dbo.Project P
                        INNER JOIN WageCoefficient WC ON P.GrantRatioID = WC.GrantRatioID
                                                         AND P.MonthFin = WC.Month
                                                         AND P.YearFin = WC.Year
                WHERE   P.ProjectID = @ProjectID
                        
	--B1: Lấy các tham số trung gian
        CREATE TABLE #Header
            (
              [ProjectName] [NVARCHAR](255) NULL , --Tên đề tài
              [LevelName] [NVARCHAR](128) NULL , --Cấp quản lý
              [FullName_CN] [NVARCHAR](255) NULL , -- Tên chủ nhiệm 
              [RankName_CN] [NVARCHAR](128) NULL , -- Cấp bậc chủ nhiệm 
              [IDNumber_CN] [NVARCHAR](20) NULL ,  --Chứng minh thư chủ nhiệm 
              [IssuedBy_CN] [NVARCHAR](255) NULL ,  -- Nơi cấp  chủ nhiệm 
              [DateBy_CN] [NVARCHAR](20) NULL ,               -- Ngày cấp chủ nhiệm 
              [OfficeAddress_CN] [NVARCHAR](255) NULL , --Địa chỉ cơ quan chủ nhiệm 
              [AccountNumber_CN] [NVARCHAR](20) NULL ,  -- Số tài khoản chủ nhiệm 
              [Bank_CN] [NVARCHAR](255) NULL , --Ngân hàng chủ nhiệm 
              [FullName_TK] [NVARCHAR](255) NULL , -- Tên thư ký 
              [RankName_TK] [NVARCHAR](128) NULL , -- Cấp bậc thư ký 
              [IDNumber_TK] [NVARCHAR](20) NULL ,  --Chứng minh thư thư ký 
              [IssuedBy_TK] [NVARCHAR](255) NULL ,  -- Nơi cấp  thư ký 
              [DateBy_TK] [NVARCHAR](20) NULL ,               -- Ngày cấp thư ký 
              [OfficeAddress_TK] [NVARCHAR](255) NULL , --Địa chỉ cơ quan thư ký 
              [AccountNumber_TK] [NVARCHAR](20) NULL ,  -- Số tài khoản thư ký 
              [Bank_TK] [NVARCHAR](255) NULL , --Ngân hàng thư ký 
              [DecisionNumber] [NVARCHAR](255) NULL , --Số quyết định
              [DecisionDate] [NVARCHAR](20) NULL ,--Ngày quyết định
              [DecisionContent] [NVARCHAR](255) NULL , --Nội dung quyết định
              [NOCContracts] [NVARCHAR](20) NULL , --Số hợp đồng con
              [DOSCContracts] [NVARCHAR](20) NULL , --Ngày ký hợp đồng con
              [DORCContracts] [NVARCHAR](20) NULL , --Ngày nghiệm thu hợp đồng con
              [Salary] INT NULL --Ngày nghiệm thu hợp đồng con
            )

        DECLARE @ProjectName NVARCHAR(255)  --Tên đề tài
        DECLARE @LevelName NVARCHAR(128)  --Cấp quản lý
        DECLARE @FullName_CN NVARCHAR(255) -- Tên chủ nhiệm 
        DECLARE @RankName_CN NVARCHAR(128) -- Cấp bậc chủ nhiệm 
        DECLARE @IDNumber_CN NVARCHAR(20)  --Chứng minh thư chủ nhiệm 
        DECLARE @IssuedBy_CN NVARCHAR(255)  -- Nơi cấp  chủ nhiệm 
        DECLARE @DateBy_CN NVARCHAR(20)               -- Ngày cấp chủ nhiệm 
        DECLARE @OfficeAddress_CN NVARCHAR(255) --Địa chỉ cơ quan chủ nhiệm 
        DECLARE @AccountNumber_CN NVARCHAR(20)  -- Số tài khoản chủ nhiệm 
        DECLARE @Bank_CN NVARCHAR(255) --Ngân hàng chủ nhiệm 
        DECLARE @FullName_TK NVARCHAR(255) -- Tên thư ký 
        DECLARE @RankName_TK NVARCHAR(128) -- Cấp bậc thư ký 
        DECLARE @IDNumber_TK NVARCHAR(20)  --Chứng minh thư thư ký 
        DECLARE @IssuedBy_TK NVARCHAR(255)  -- Nơi cấp  thư ký 
        DECLARE @DateBy_TK NVARCHAR(20)               -- Ngày cấp thư ký 
        DECLARE @OfficeAddress_TK NVARCHAR(255) --Địa chỉ cơ quan thư ký 
        DECLARE @AccountNumber_TK NVARCHAR(20)  -- Số tài khoản thư ký 
        DECLARE @Bank_TK NVARCHAR(255) --Ngân hàng thư ký 
        DECLARE @DecisionNumber NVARCHAR(255) --Số quyết định
        DECLARE @DecisionDate NVARCHAR(20)--Ngày quyết định
        DECLARE @DecisionContent NVARCHAR(255) --Nội dung quyết định
        DECLARE @NOCContracts NVARCHAR(20) --Số hợp đồng con
        DECLARE @DOSCContracts NVARCHAR(20) --Ngày ký hợp đồng con
        DECLARE @DORCContracts NVARCHAR(20) --Ngày nghiệm thu hợp đồng con
        DECLARE @Salary INT --Ngày nghiệm thu hợp đồng con
		--
        SET @DecisionNumber = N''
        SET @DecisionDate = N''
        SET @DecisionContent = N''
        SET @NOCContracts = N''
        SET @DOSCContracts = N''
        SET @DORCContracts = N''
		--Lấy tên đề tài
        SELECT  @ProjectName = dbo.Project.ProjectName ,
                @LevelName = ISNULL(dbo.Level.LevelName, N'')
        FROM    dbo.Project
                LEFT JOIN dbo.Level ON dbo.Project.LevelID = dbo.Level.LevelID
        WHERE   ProjectID = @ProjectID
		--Lấy thông tin chủ nhiệm vào
        SELECT  @FullName_CN = dbo.Employee.FullName ,
                @RankName_CN = dbo.Rank.RankName ,
                @IDNumber_CN = dbo.Employee.IDNumber ,
                @IssuedBy_CN = dbo.Employee.IssuedBy ,
                @DateBy_CN = dbo.Employee.DateBy ,
                @OfficeAddress_CN = dbo.Employee.OfficeAddress ,
                @AccountNumber_CN = dbo.Employee.AccountNumber ,
                @Bank_CN = dbo.Employee.Bank
        FROM    dbo.Employee
                LEFT JOIN dbo.ProjectMember ON dbo.Employee.EmployeeID = dbo.ProjectMember.EmployeeID
                LEFT JOIN dbo.Rank ON dbo.Employee.RankID = dbo.Rank.RankID
                INNER JOIN dbo.Project ON dbo.ProjectMember.ProjectID = dbo.Project.ProjectID
        WHERE   dbo.Project.ProjectID = @ProjectID
                AND dbo.ProjectMember.ProjectPositionID = '37309cee-1259-4498-b221-193532aff374'

				--Lấy thông tin thư ký vào
        SELECT  @FullName_TK = dbo.Employee.FullName ,
                @RankName_TK = dbo.Rank.RankName ,
                @IDNumber_TK = dbo.Employee.IDNumber ,
                @IssuedBy_TK = dbo.Employee.IssuedBy ,
                @DateBy_TK = dbo.Employee.DateBy ,
                @OfficeAddress_TK = dbo.Employee.OfficeAddress ,
                @AccountNumber_TK = dbo.Employee.AccountNumber ,
                @Bank_TK = dbo.Employee.Bank
        FROM    dbo.Employee
                LEFT JOIN dbo.ProjectMember ON dbo.Employee.EmployeeID = dbo.ProjectMember.EmployeeID
                LEFT JOIN dbo.Rank ON dbo.Employee.RankID = dbo.Rank.RankID
                INNER JOIN dbo.Project ON dbo.ProjectMember.ProjectID = dbo.Project.ProjectID
        WHERE   dbo.Project.ProjectID = @ProjectID
                AND dbo.ProjectMember.ProjectPositionID = '71a459eb-1b06-492a-915c-2565e692efb4'

				-- Lấy thông tin lương cơ bản vào
        SELECT  @Salary = dbo.Salary.Money
        FROM    dbo.Project
                INNER JOIN dbo.Salary ON dbo.Project.MonthFin = dbo.Salary.Month
                                         AND dbo.Project.YearFin = dbo.Salary.Year
        WHERE   ProjectID = @ProjectID 
			
		--Đưa dữ liệu vào bảng

        INSERT  #Header
                ( ProjectName ,
                  LevelName ,
                  FullName_CN ,
                  RankName_CN ,
                  IDNumber_CN ,
                  IssuedBy_CN ,
                  DateBy_CN ,
                  OfficeAddress_CN ,
                  AccountNumber_CN ,
                  Bank_CN ,
                  FullName_TK ,
                  RankName_TK ,
                  IDNumber_TK ,
                  IssuedBy_TK ,
                  DateBy_TK ,
                  OfficeAddress_TK ,
                  AccountNumber_TK ,
                  Bank_TK ,
                  DecisionNumber ,
                  DecisionDate ,
                  DecisionContent ,
                  NOCContracts ,
                  DOSCContracts ,
                  DORCContracts ,
                  Salary
			    )
        VALUES  ( @ProjectName ,
                  @LevelName ,
                  @FullName_CN ,
                  @RankName_CN ,
                  @IDNumber_CN ,
                  @IssuedBy_CN ,
                  @DateBy_CN ,
                  @OfficeAddress_CN ,
                  @AccountNumber_CN ,
                  @Bank_CN ,
                  @FullName_TK ,
                  @RankName_TK ,
                  @IDNumber_TK ,
                  @IssuedBy_TK ,
                  @DateBy_TK ,
                  @OfficeAddress_TK ,
                  @AccountNumber_TK ,
                  @Bank_TK ,
                  @DecisionNumber ,
                  @DecisionDate ,
                  @DecisionContent ,
                  @NOCContracts ,
                  @DOSCContracts ,
                  @DORCContracts ,
                  @Salary
			    )
				-- Lấy dữ liệu ra
        SELECT  *
        FROM    #Header
        DROP TABLE #Header
	--Bước 2: Lấy toàn bộ các ProjectTask về
        SELECT  PT.ProjectTaskID ,
                PT.Contents ,
                PT.Result ,
                PT.StartDate ,
                PT.EndDate
        FROM    dbo.ProjectTask PT
        WHERE   CHARINDEX(CONVERT(NVARCHAR(50), PT.ProjectTaskID),
                          @sProjectTastID) > 0
        ORDER BY PT.Code
	--Bước 3: Lấy toàn bộ các thành viên tham gia các ProjectTask về
        SELECT  PTM.ProjectTaskID ,
                PTM.EmployeeID ,
                E.FullName ,
                PTM.StartDate ,
                PTM.EndDate ,
                PTM.MonthForTask ,
                E.FullName AS FullName_B ,
                R.RankName AS RankName_B ,
                E.IDNumber AS IDNumber_B ,
                E.IssuedBy AS IssuedBy_B ,
                E.DateBy AS DateBy_B ,
                E.OfficeAddress AS OfficeAddress_B ,
                E.AccountNumber AS AccountNumber_B ,
                E.Bank AS Bank_B
        INTO    #ProjectTaskMember
        FROM    dbo.ProjectTaskMember PTM
                INNER JOIN dbo.Employee E ON PTM.EmployeeID = E.EmployeeID
                LEFT JOIN dbo.Rank R ON E.RankID = R.RankID
        WHERE   CHARINDEX(CONVERT(NVARCHAR(50), PTM.ProjectTaskID),
                          @sProjectTastID) > 0
        ORDER BY E.LastName ,
                E.FirstName
				-- Lấy dữ liệu ra
        SELECT  PTM.ProjectTaskID ,
                PTM.EmployeeID ,
                PTM.FullName ,
                PTM.StartDate ,
                PTM.EndDate ,
                PTM.MonthForTask ,
                PTM.FullName_B ,
                PTM.RankName_B ,
                PTM.IDNumber_B ,
                PTM.IssuedBy_B ,
                PTM.DateBy_B ,
                PTM.OfficeAddress_B ,
                PTM.AccountNumber_B ,
                PTM.Bank_B ,
                PP.ProjectPositionID ,
                PP.ProjectPositionName AS ProjectPositionName_B ,
                PP.SortOrder AS PP_SortOrder
        INTO    #ProjectTaskMember2
        FROM    #ProjectTaskMember PTM
                LEFT JOIN dbo.ProjectMember PM ON PTM.EmployeeID = PM.EmployeeID
                                                  AND PM.ProjectID = @ProjectID
                INNER JOIN dbo.ProjectPosition PP ON PM.ProjectPositionID = PP.ProjectPositionID

        SELECT  PTM.ProjectTaskID ,
                PTM.EmployeeID ,
                PTM.FullName ,
                PTM.StartDate ,
                PTM.EndDate ,
                PTM.MonthForTask ,
                PTM.FullName_B ,
                PTM.RankName_B ,
                PTM.IDNumber_B ,
                PTM.IssuedBy_B ,
                PTM.DateBy_B ,
                PTM.OfficeAddress_B ,
                PTM.AccountNumber_B ,
                PTM.Bank_B ,
                PTM.ProjectPositionID ,
                PTM.ProjectPositionName_B ,
                ISNULL(WC.Coefficient, 0) AS Coefficient_B ,
                @Salary AS Salary
        FROM    #ProjectTaskMember2 PTM
                LEFT JOIN #WageCoefficient WC ON PTM.ProjectPositionID = WC.ProjectPositionID
        ORDER BY PTM.PP_SortOrder
				--Xóa bảng tạm
        DROP TABLE #ProjectTaskMember
        DROP TABLE #WageCoefficient
        DROP TABLE #ProjectTaskMember2
    END




GO
/****** Object:  StoredProcedure [dbo].[Proc_GetDayOffsByMonthYear]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<dvthang>
-- Create date: <03.06.2018>
-- Description:	<Lấy về danh sách ngày nghỉ của thánh>
-- =============================================
--Proc_GetDayOffsByMonthYear 2,2018
CREATE PROCEDURE [dbo].[Proc_GetDayOffsByMonthYear] @month INT, @year INT
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;
        DECLARE @totalDay INT
        IF @month IN ( 1, 3, 5, 7, 9, 10, 12 )
            SET @totalDay = 31
        ELSE
            IF @month IN ( 2, 4, 6, 8, 11 )
                BEGIN
                    IF @month = 2
                        BEGIN
                            IF ( ( @year % 4 = 0
                                   AND @year % 100 != 0
                                 )
                                 OR @year % 400 = 0
                               )
                                SET @totalDay = 29
                            ELSE
                                SET @totalDay = 28
                        END
                    ELSE
                        BEGIN
                            SET @totalDay = 30
                        END
                END
        
        DECLARE @fromDate DATE ,
            @toDate DATE

        SET @fromDate = CAST(@year AS NVARCHAR(6)) + '/'
            + CAST(@month AS NVARCHAR(2)) + '/1'
        SET @toDate = CAST(@year AS NVARCHAR(6)) + '/'
            + CAST(@month AS NVARCHAR(2)) + '/'
            + CAST(@totalDay AS NVARCHAR(2))


        SELECT  Date AS Value
        FROM    dbo.DayOff
        WHERE   Date BETWEEN @fromDate AND @toDate
    END




GO
/****** Object:  StoredProcedure [dbo].[Proc_GetEmpByUserName]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<dvthang>
-- Create date: <21.02.2018>
-- Description:	<Lấy về thông tin nhân viên>
-- =============================================
CREATE PROCEDURE [dbo].[Proc_GetEmpByUserName] @userName NVARCHAR(64)
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;
        SELECT TOP 1
                *
        FROM    dbo.Employee
        WHERE   EmployeeCode = @userName
                OR Email = @userName
                OR Tel = @userName
    END




GO
/****** Object:  StoredProcedure [dbo].[Proc_GetEmployeeByCompanyId]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<dvthang>
-- Create date: <03.06.2018>
-- Description:	<Lấy danh sách nhân viên theo đơn vị công tác>
-- =============================================
CREATE PROCEDURE [dbo].[Proc_GetEmployeeByCompanyId]
    @CompanyID UNIQUEIDENTIFIER
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

        SELECT  EmployeeID ,
                FullName
        FROM    dbo.Employee
        WHERE   CompanyID = @CompanyID OR @CompanyID IS NULL OR @CompanyID='00000000-0000-0000-0000-000000000000'
        ORDER BY FirstName
    END




GO
/****** Object:  StoredProcedure [dbo].[Proc_GetListContractedProfessional_By_ProjectID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<laipv>
-- Create date: <29.05.2018>
-- Description:	<Hàm lấy về các nội dung để thực hiện thuê khoán chuyên môn>
-- =============================================
--Chạy thử: Proc_GetListContractedProfessional_By_ProjectID 'c1644ef7-2bb9-4715-a3f8-3f21638d2c18'
CREATE PROC [dbo].[Proc_GetListContractedProfessional_By_ProjectID]
    @ProjectID UNIQUEIDENTIFIER
AS
    BEGIN
		--Tạo bảng tạm chứa dữ liệu
        CREATE TABLE #Result
            (
              [ContractedProfessionalID] [UNIQUEIDENTIFIER] NOT NULL ,
              [ProjectID] [UNIQUEIDENTIFIER] NULL ,
              [ProjectTaskID] [UNIQUEIDENTIFIER] NULL ,
              [Contents] NVARCHAR(4000) ,
              [EmployeeID] [UNIQUEIDENTIFIER] NULL ,
              [FullName] NVARCHAR(255) ,
              [MonthForTask] INT , --Số ngày tham gia ProjectTask
              [MonthForTaskLaborday] INT , --Số ngày đã chấm công
              [SortOrder] [INT] NULL ,
              Edit [BIT] NULL --Trường cho phép có Edit được hay không
            )
        --B1: Đưa tất cả các nội dung vào
		--Thực hiện duyệt
        DECLARE @ProjectTaskID UNIQUEIDENTIFIER
        DECLARE @Contents NVARCHAR(4000)
        DECLARE Cu_PT CURSOR
        FOR
            SELECT  dbo.ProjectTask.ProjectTaskID ,
                    dbo.ProjectTask.Contents
            FROM    dbo.ProjectTask
            WHERE   dbo.ProjectTask.ProjectID = @ProjectID
			ORDER BY dbo.ProjectTask.Code
        OPEN Cu_PT
        FETCH FROM Cu_PT INTO @ProjectTaskID, @Contents
        WHILE @@FETCH_STATUS = 0
            BEGIN
                --Thực hiện đưa nội dung ra bảng
                INSERT  #Result
                        ( ContractedProfessionalID ,
                          ProjectID ,
                          ProjectTaskID ,
                          Contents ,
                          EmployeeID ,
                          FullName ,
                          SortOrder ,
                          Edit
				        )
                VALUES  ( NEWID() ,
                          @ProjectID ,
                          @ProjectTaskID ,
                          @Contents ,
                          NEWID() ,
                          N'' ,
                          1 ,
                          0
				        )
				-- Thực hiện đưa thành viên tham gia vào bảng
                INSERT  #Result
                        ( ContractedProfessionalID ,
                          ProjectID ,
                          ProjectTaskID ,
                          Contents ,
                          EmployeeID ,
                          FullName ,
                          MonthForTask ,
                          SortOrder ,
                          Edit
				        )
                        SELECT  NEWID() ,
                                @ProjectID ,
                                @ProjectTaskID ,
                                N'' ,
                                dbo.ProjectTaskMember.EmployeeID ,
                                N'' ,
                                dbo.ProjectTaskMember.MonthForTask ,
                                1 ,
                                1
                        FROM    dbo.ProjectTaskMember
                        WHERE   dbo.ProjectTaskMember.ProjectTaskID = @ProjectTaskID  
				--
                FETCH FROM Cu_PT INTO @ProjectTaskID, @Contents
            END
        CLOSE Cu_PT
        DEALLOCATE Cu_PT
        --Hết
		--Đưa FullName vào
        UPDATE  A
        SET     A.FullName = RA.FullName
        FROM    #Result A
                LEFT JOIN dbo.Employee RA ON A.EmployeeID = RA.EmployeeID
		--Đưa số ngày đã chấm công vào
        UPDATE  #Result
        SET     MonthForTaskLaborday = ( SELECT COUNT(*)
                                         FROM   ProjectTaskMemberFinance
                                         WHERE  ProjectTaskMemberFinance.ProjectTaskID = #Result.ProjectTaskID
                                                AND ProjectTaskMemberFinance.EmployeeID = #Result.EmployeeID
												AND ProjectTaskMemberFinance.LaborDay > 0
                                       ) 
		-- Lấy dữ liệu ra
        SELECT  ROW_NUMBER() OVER ( ORDER BY SortOrder ) AS RowNum ,
                *
        FROM    #Result
		-- Xóa bảng tạm
        DROP TABLE #Result
    END







GO
/****** Object:  StoredProcedure [dbo].[Proc_GetListContractedProfessional_By_ProjectID_Excel]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<laipv>
-- Create date: <29.05.2018>
-- Description:	<Hàm lấy về các nội dung để thực hiện thuê khoán chuyên môn>
-- =============================================
--Chạy thử: Proc_GetListContractedProfessional_By_ProjectID_Excel 'f58fe740-357f-4559-8323-ef9b0c118b51'
CREATE PROC [dbo].[Proc_GetListContractedProfessional_By_ProjectID_Excel]
    @ProjectID UNIQUEIDENTIFIER
AS
    BEGIN
		--Tạo bảng tạm chứa dữ liệu
        CREATE TABLE #Result
            (
              [ContractedProfessionalID] [UNIQUEIDENTIFIER] NOT NULL ,
              [ProjectID] [UNIQUEIDENTIFIER] NULL ,
              [ProjectTaskID] [UNIQUEIDENTIFIER] NULL ,
              [Contents] NVARCHAR(4000) ,
              [EmployeeID] [UNIQUEIDENTIFIER] NULL ,
              [FullName] NVARCHAR(255) ,
              [MonthForTask] INT , --Số ngày tham gia ProjectTask
              [MonthForTaskLaborday] INT , --Số ngày đã chấm công
              [SortOrder] [INT] NULL ,
              Edit [BIT] NULL --Trường cho phép có Edit được hay không
            )
        --B1: Đưa tất cả các nội dung vào
		--Thực hiện duyệt
        DECLARE @ProjectTaskID UNIQUEIDENTIFIER
        DECLARE @Contents NVARCHAR(4000)
        DECLARE Cu_PT CURSOR
        FOR
            SELECT  dbo.ProjectTask.ProjectTaskID ,
                    dbo.ProjectTask.Contents
            FROM    dbo.ProjectTask
            WHERE   dbo.ProjectTask.ProjectID = @ProjectID
            ORDER BY dbo.ProjectTask.Code
        OPEN Cu_PT
        FETCH FROM Cu_PT INTO @ProjectTaskID, @Contents
        WHILE @@FETCH_STATUS = 0
            BEGIN
                --Thực hiện đưa nội dung ra bảng
                INSERT  #Result
                        ( ContractedProfessionalID ,
                          ProjectID ,
                          ProjectTaskID ,
                          Contents ,
                          EmployeeID ,
                          FullName ,
                          SortOrder ,
                          Edit
				        )
                VALUES  ( NEWID() ,
                          @ProjectID ,
                          @ProjectTaskID ,
                          @Contents ,
                          NEWID() ,
                          N'' ,
                          1 ,
                          0
				        )
				-- Thực hiện đưa thành viên tham gia vào bảng
                INSERT  #Result
                        ( ContractedProfessionalID ,
                          ProjectID ,
                          ProjectTaskID ,
                          Contents ,
                          EmployeeID ,
                          FullName ,
                          MonthForTask ,
                          SortOrder ,
                          Edit
				        )
                        SELECT  NEWID() ,
                                @ProjectID ,
                                @ProjectTaskID ,
                                N'' ,
                                dbo.ProjectTaskMember.EmployeeID ,
                                N'' ,
                                dbo.ProjectTaskMember.MonthForTask ,
                                1 ,
                                1
                        FROM    dbo.ProjectTaskMember
                        WHERE   dbo.ProjectTaskMember.ProjectTaskID = @ProjectTaskID  
				--
                FETCH FROM Cu_PT INTO @ProjectTaskID, @Contents
            END
        CLOSE Cu_PT
        DEALLOCATE Cu_PT
        --Hết
		--Đưa FullName vào
        UPDATE  A
        SET     A.FullName = RA.FullName
        FROM    #Result A
                LEFT JOIN dbo.Employee RA ON A.EmployeeID = RA.EmployeeID
		--Đưa số ngày đã chấm công vào
        UPDATE  #Result
        SET     MonthForTaskLaborday = ( SELECT COUNT(*)
                                         FROM   ProjectTaskMemberFinance
                                         WHERE  ProjectTaskMemberFinance.ProjectTaskID = #Result.ProjectTaskID
                                                AND ProjectTaskMemberFinance.EmployeeID = #Result.EmployeeID
                                       ) 
		-- Lấy dữ liệu ra
        SELECT 
                Contents ,
                FullName ,
                MonthForTask ,
                MonthForTaskLaborday
        FROM    #Result
		-- Xóa bảng tạm
        DROP TABLE #Result
    END







GO
/****** Object:  StoredProcedure [dbo].[Proc_GetListContractedProfessional_By_ProjectID_In]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<laipv>
-- Create date: <29.05.2018>
-- Description:	<Hàm lấy về các nội dung để thực hiện thuê khoán chuyên môn>
-- =============================================
--Chạy thử: Proc_GetListContractedProfessional_By_ProjectID_In 'c1644ef7-2bb9-4715-a3f8-3f21638d2c18'
CREATE PROC [dbo].[Proc_GetListContractedProfessional_By_ProjectID_In]
    @ProjectID UNIQUEIDENTIFIER
AS
    BEGIN
	--Tạo bảng tạm chứa dữ liệu
        CREATE TABLE #Result
            (
              [ContractedProfessionalID] [UNIQUEIDENTIFIER] NOT NULL ,
              [ProjectID] [UNIQUEIDENTIFIER] NULL ,
              [ProjectTaskID] [UNIQUEIDENTIFIER] NULL ,
              [Contents] NVARCHAR(4000) ,
              [EmployeeID] [UNIQUEIDENTIFIER] NULL ,
              [FullName] NVARCHAR(255) ,
              [MonthForTask] INT , --Số ngày tham gia ProjectTask
              [MonthForTaskLaborday] INT , --Số ngày đã chấm công
              [SortOrder] [INT] NULL ,
              Edit [BIT] NULL --Trường cho phép có Edit được hay không
            )
    --B1: Đưa tất cả các nội dung vào
	--Thực hiện duyệt
        DECLARE @ProjectTaskID UNIQUEIDENTIFIER
        DECLARE @Contents NVARCHAR(4000)
        DECLARE Cu_PT CURSOR
        FOR
            SELECT  dbo.ProjectTask.ProjectTaskID ,
                    dbo.ProjectTask.Contents
            FROM    dbo.ProjectTask
            WHERE   dbo.ProjectTask.ProjectID = @ProjectID
			ORDER BY dbo.ProjectTask.Code
        OPEN Cu_PT
        FETCH FROM Cu_PT INTO @ProjectTaskID, @Contents
        WHILE @@FETCH_STATUS = 0
            BEGIN
            --Thực hiện đưa nội dung ra bảng
                INSERT  #Result
                        ( ContractedProfessionalID ,
                          ProjectID ,
                          ProjectTaskID ,
                          Contents ,
                          EmployeeID ,
                          FullName ,
                          SortOrder ,
                          Edit
			            )
                VALUES  ( NEWID() ,
                          @ProjectID ,
                          @ProjectTaskID ,
                          @Contents ,
                          NEWID() ,
                          N'' ,
                          1 ,
                          0
			            )
			-- Thực hiện đưa thành viên tham gia vào bảng
                INSERT  #Result
                        ( ContractedProfessionalID ,
                          ProjectID ,
                          ProjectTaskID ,
                          Contents ,
                          EmployeeID ,
                          FullName ,
                          MonthForTask ,
                          SortOrder ,
                          Edit
			            )
                        SELECT  NEWID() ,
                                @ProjectID ,
                                @ProjectTaskID ,
                                N'' ,
                                dbo.ProjectTaskMember.EmployeeID ,
                                N'' ,
                                dbo.ProjectTaskMember.MonthForTask ,
                                1 ,
                                1
                        FROM    dbo.ProjectTaskMember
                        WHERE   dbo.ProjectTaskMember.ProjectTaskID = @ProjectTaskID  
			--
                FETCH FROM Cu_PT INTO @ProjectTaskID, @Contents
            END
        CLOSE Cu_PT
        DEALLOCATE Cu_PT
    --Hết
	--Đưa FullName vào
        UPDATE  A
        SET     A.FullName = RA.FullName
        FROM    #Result A
                LEFT JOIN dbo.Employee RA ON A.EmployeeID = RA.EmployeeID
	--Đưa số ngày đã chấm công vào
        UPDATE  #Result
        SET     MonthForTaskLaborday = ( SELECT COUNT(*)
                                         FROM   ProjectTaskMemberFinance
                                         WHERE  ProjectTaskMemberFinance.ProjectTaskID = #Result.ProjectTaskID
                                                AND ProjectTaskMemberFinance.EmployeeID = #Result.EmployeeID
                                       ) 
	-- Lấy dữ liệu ra
        SELECT  ProjectTaskID ,
                Contents
        INTO    #tmpX
        FROM    #Result
        WHERE   LEN(LTRIM(Contents)) > 5
	
        UPDATE  #Result
        SET     Contents = ( SELECT Contents
                             FROM   #tmpX v
                             WHERE  v.ProjectTaskID = #Result.ProjectTaskID
                           )
    
        SELECT  DISTINCT
                ProjectTaskID
        INTO    #tmp1
        FROM    #Result --into #tmp1
    -- Dem so noi dung
        DECLARE @CntND INT
        SELECT  @CntND = COUNT(*)
        FROM    #tmp1
        SELECT  IDENTITY( INT, 1,1 ) ID ,
                ProjectTaskID
        INTO    #tmp2
        FROM    #tmp1
   
        SELECT  ID ,
                FullName ,
                Contents ,
                MonthForTask ,
                [MonthForTaskLaborday]
        INTO    #tmp3
        FROM    #Result v1
                INNER JOIN #tmp2 v2 ON v2.ProjectTaskID = v1.ProjectTaskID
        UPDATE  #tmp3
        SET     FullName = '@'
        WHERE   FullName IS NULL
    
        SELECT DISTINCT
                FullName
        INTO    #tmp4
        FROM    #tmp3
  --Select * from #tmp3
  
        DECLARE @i INT ,
            @st1 VARCHAR(4000) ,
            @st2 VARCHAR(4000)
        SET @i = 1
        SET @st1 = 'Select V0.FullName FullName '
        SET @st2 = ' From #tmp4 v0 '
        WHILE ( @i <= @CntND )
            BEGIN
                SET @st1 += ',isnull(v' + CAST(@i AS VARCHAR(10))
                    + '.Contents,' + CHAR(39) + ' ' + CHAR(39) + ') ND'
                    + CAST(@i AS VARCHAR(10)) + ', isnull( v'
                    + CAST(@i AS VARCHAR(10)) + '.MonthForTask,0) SN_RD'
                    + CAST(@i AS VARCHAR(10)) + ', isnull(v'
                    + CAST(@i AS VARCHAR(10))
                    + '.[MonthForTaskLaborday],0) SN_CC'
                    + CAST(@i AS VARCHAR(10))
                SET @st2 += '  Full Join (select * from #tmp3 where id='
                    + CAST(@i AS VARCHAR(10)) + ') v'
                    + CAST(@i AS VARCHAR(10)) + ' on v'
                    + CAST(@i AS VARCHAR(10)) + '.FullName=v0.FullName'
                SET @i += 1
            END  
        PRINT @st1 + @st2
        EXEC(@st1+@st2)       
    END

-- Proc_GetListContractedProfessional_By_ProjectID_In 'c1644ef7-2bb9-4715-a3f8-3f21638d2c18'

--Select V0.FullName FullName
 --   ,v1.Contents ND1, v1.MonthForTask SN_RD1, v1.[MonthForTaskLaborday] SN_CC1
 --   ,v2.Contents ND2, v2.MonthForTask SN_RD2, v2.[MonthForTaskLaborday] SN_CC2
 --     ,v3.Contents ND2, v3.MonthForTask SN_RD2, v3.[MonthForTaskLaborday] SN_CC3
 --       ,v4.Contents ND2, v4.MonthForTask SN_RD2, v4.[MonthForTaskLaborday] SN_CC4
 --         ,v5.Contents ND2, v5.MonthForTask SN_RD2, v5.[MonthForTaskLaborday] SN_CC5
 --           ,v6.Contents ND2, v6.MonthForTask SN_RD2, v6.[MonthForTaskLaborday] SN_CC6
 --             ,v7.Contents ND2, v7.MonthForTask SN_RD2, v7.[MonthForTaskLaborday] SN_CC7
 --               ,v8.Contents ND2, v8.MonthForTask SN_RD2, v8.[MonthForTaskLaborday] SN_CC8
 --                 ,v9.Contents ND2, v9.MonthForTask SN_RD2, v9.[MonthForTaskLaborday] SN_CC9
 --                   ,v10.Contents ND2, v10.MonthForTask SN_RD2, v10.[MonthForTaskLaborday] SN_CC10
 --                     ,v11.Contents ND2, v11.MonthForTask SN_RD2, v11.[MonthForTaskLaborday] SN_CC11
 --                       ,v12.Contents ND2, v12.MonthForTask SN_RD2, v12.[MonthForTaskLaborday] SN_CC12
 --                         ,v13.Contents ND2, v13.MonthForTask SN_RD2, v13.[MonthForTaskLaborday] SN_CC13
                           
 --    From #tmp4 v0
 --   Full Join (select * from #tmp3 where id=1) v1 on v1.FullName=v0.FullName
 --   Full Join (select * from #tmp3 where id=2) v2 on v2.FullName=v0.FullName 
 --     Full Join (select * from #tmp3 where id=3) v3 on v3.FullName=v0.FullName 
 --     Full Join (select * from #tmp3 where id=4) v4 on v4.FullName=v0.FullName 
 --     Full Join (select * from #tmp3 where id=5) v5 on v5.FullName=v0.FullName 
 --     Full Join (select * from #tmp3 where id=6) v6 on v6.FullName=v0.FullName 
 --     Full Join (select * from #tmp3 where id=7) v7 on v7.FullName=v0.FullName 
 --     Full Join (select * from #tmp3 where id=8) v8 on v8.FullName=v0.FullName 
 --     Full Join (select * from #tmp3 where id=9) v9 on v9.FullName=v0.FullName 
 --     Full Join (select * from #tmp3 where id=10) v10 on v10.FullName=v0.FullName 
 --     Full Join (select * from #tmp3 where id=11) v11 on v11.FullName=v0.FullName 
 --     Full Join (select * from #tmp3 where id=12) v12 on v12.FullName=v0.FullName 
 --     Full Join (select * from #tmp3 where id=13) v13 on v13.FullName=v0.FullName




GO
/****** Object:  StoredProcedure [dbo].[Proc_GetListContractedProfessional_By_ProjectID_sProjectTastID_In]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<laipv>
-- Create date: <29.05.2018>
-- Description:	<Hàm lấy về các nội dung để thực hiện thuê khoán chuyên môn>
-- =============================================
--Chạy thử: Proc_GetListContractedProfessional_By_ProjectID_sProjectTastID_In 'c1644ef7-2bb9-4715-a3f8-3f21638d2c18',''
CREATE PROC [dbo].[Proc_GetListContractedProfessional_By_ProjectID_sProjectTastID_In]
    @ProjectID UNIQUEIDENTIFIER,
	@sProjectTastID NVARCHAR(4000)
AS
    BEGIN
	--Tạo bảng tạm chứa dữ liệu
        CREATE TABLE #Result
            (
              [ContractedProfessionalID] [UNIQUEIDENTIFIER] NOT NULL ,
              [ProjectID] [UNIQUEIDENTIFIER] NULL ,
              [ProjectTaskID] [UNIQUEIDENTIFIER] NULL ,
              [Contents] NVARCHAR(4000) ,
              [EmployeeID] [UNIQUEIDENTIFIER] NULL ,
              [FullName] NVARCHAR(255) ,
              [MonthForTask] INT , --Số ngày tham gia ProjectTask
              [MonthForTaskLaborday] INT , --Số ngày đã chấm công
              [SortOrder] [INT] NULL ,
              Edit [BIT] NULL --Trường cho phép có Edit được hay không
            )
    --B1: Đưa tất cả các nội dung vào
	--Thực hiện duyệt
        DECLARE @ProjectTaskID UNIQUEIDENTIFIER
        DECLARE @Contents NVARCHAR(4000)
        DECLARE Cu_PT CURSOR
        FOR
            SELECT  dbo.ProjectTask.ProjectTaskID ,
                    dbo.ProjectTask.Contents
            FROM    dbo.ProjectTask
            WHERE   dbo.ProjectTask.ProjectID = @ProjectID
			AND CHARINDEX(convert(nvarchar(50),ProjectTask.ProjectTaskID),@sProjectTastID) > 0
			ORDER BY dbo.ProjectTask.Code
        OPEN Cu_PT
        FETCH FROM Cu_PT INTO @ProjectTaskID, @Contents
        WHILE @@FETCH_STATUS = 0
            BEGIN
            --Thực hiện đưa nội dung ra bảng
                INSERT  #Result
                        ( ContractedProfessionalID ,
                          ProjectID ,
                          ProjectTaskID ,
                          Contents ,
                          EmployeeID ,
                          FullName ,
                          SortOrder ,
                          Edit
			            )
                VALUES  ( NEWID() ,
                          @ProjectID ,
                          @ProjectTaskID ,
                          @Contents ,
                          NEWID() ,
                          N'' ,
                          1 ,
                          0
			            )
			-- Thực hiện đưa thành viên tham gia vào bảng
                INSERT  #Result
                        ( ContractedProfessionalID ,
                          ProjectID ,
                          ProjectTaskID ,
                          Contents ,
                          EmployeeID ,
                          FullName ,
                          MonthForTask ,
                          SortOrder ,
                          Edit
			            )
                        SELECT  NEWID() ,
                                @ProjectID ,
                                @ProjectTaskID ,
                                N'' ,
                                dbo.ProjectTaskMember.EmployeeID ,
                                N'' ,
                                dbo.ProjectTaskMember.MonthForTask ,
                                1 ,
                                1
                        FROM    dbo.ProjectTaskMember
                        WHERE   dbo.ProjectTaskMember.ProjectTaskID = @ProjectTaskID  
			--
                FETCH FROM Cu_PT INTO @ProjectTaskID, @Contents
            END
        CLOSE Cu_PT
        DEALLOCATE Cu_PT
    --Hết
	--Đưa FullName vào
        UPDATE  A
        SET     A.FullName = RA.FullName
        FROM    #Result A
                LEFT JOIN dbo.Employee RA ON A.EmployeeID = RA.EmployeeID
	--Đưa số ngày đã chấm công vào
        UPDATE  #Result
        SET     MonthForTaskLaborday = ( SELECT COUNT(*)
                                         FROM   ProjectTaskMemberFinance
                                         WHERE  ProjectTaskMemberFinance.ProjectTaskID = #Result.ProjectTaskID
                                                AND ProjectTaskMemberFinance.EmployeeID = #Result.EmployeeID
                                       ) 
	-- Lấy dữ liệu ra
        SELECT  ProjectTaskID ,
                Contents
        INTO    #tmpX
        FROM    #Result
        WHERE   LEN(LTRIM(Contents)) > 5
	
        UPDATE  #Result
        SET     Contents = ( SELECT Contents
                             FROM   #tmpX v
                             WHERE  v.ProjectTaskID = #Result.ProjectTaskID
                           )
    
        SELECT  DISTINCT
                ProjectTaskID
        INTO    #tmp1
        FROM    #Result --into #tmp1
    -- Dem so noi dung
        DECLARE @CntND INT
        SELECT  @CntND = COUNT(*)
        FROM    #tmp1
        SELECT  IDENTITY( INT, 1,1 ) ID ,
                ProjectTaskID
        INTO    #tmp2
        FROM    #tmp1
   
        SELECT  ID ,
                FullName ,
                Contents ,
                MonthForTask ,
                [MonthForTaskLaborday]
        INTO    #tmp3
        FROM    #Result v1
                INNER JOIN #tmp2 v2 ON v2.ProjectTaskID = v1.ProjectTaskID
        UPDATE  #tmp3
        SET     FullName = '@'
        WHERE   FullName IS NULL
    
        SELECT DISTINCT
                FullName
        INTO    #tmp4
        FROM    #tmp3
  --Select * from #tmp3
  
        DECLARE @i INT ,
            @st1 NVARCHAR(MAX) ,
            @st2  NVARCHAR(MAX) 
        SET @i = 1
        SET @st1 = 'Select V0.FullName FullName '
        SET @st2 = ' From #tmp4 v0 '
        WHILE ( @i <= @CntND )
            BEGIN
                SET @st1 += ',isnull(v' + CAST(@i AS VARCHAR(10))
                    + '.Contents,' + CHAR(39) + ' ' + CHAR(39) + ') ND'
                    + CAST(@i AS VARCHAR(10)) + ', isnull( v'
                    + CAST(@i AS VARCHAR(10)) + '.MonthForTask,0) SN_RD'
                    + CAST(@i AS VARCHAR(10)) + ', isnull(v'
                    + CAST(@i AS VARCHAR(10))
                    + '.[MonthForTaskLaborday],0) SN_CC'
                    + CAST(@i AS VARCHAR(10))
                SET @st2 += '  Full Join (select * from #tmp3 where id='
                    + CAST(@i AS VARCHAR(10)) + ') v'
                    + CAST(@i AS VARCHAR(10)) + ' on v'
                    + CAST(@i AS VARCHAR(10)) + '.FullName=v0.FullName'
                SET @i += 1
            END  
        PRINT @st1 + @st2
        EXEC(@st1+@st2)       
    END

-- Proc_GetListContractedProfessional_By_ProjectID_In 'c1644ef7-2bb9-4715-a3f8-3f21638d2c18'

--Select V0.FullName FullName
 --   ,v1.Contents ND1, v1.MonthForTask SN_RD1, v1.[MonthForTaskLaborday] SN_CC1
 --   ,v2.Contents ND2, v2.MonthForTask SN_RD2, v2.[MonthForTaskLaborday] SN_CC2
 --     ,v3.Contents ND2, v3.MonthForTask SN_RD2, v3.[MonthForTaskLaborday] SN_CC3
 --       ,v4.Contents ND2, v4.MonthForTask SN_RD2, v4.[MonthForTaskLaborday] SN_CC4
 --         ,v5.Contents ND2, v5.MonthForTask SN_RD2, v5.[MonthForTaskLaborday] SN_CC5
 --           ,v6.Contents ND2, v6.MonthForTask SN_RD2, v6.[MonthForTaskLaborday] SN_CC6
 --             ,v7.Contents ND2, v7.MonthForTask SN_RD2, v7.[MonthForTaskLaborday] SN_CC7
 --               ,v8.Contents ND2, v8.MonthForTask SN_RD2, v8.[MonthForTaskLaborday] SN_CC8
 --                 ,v9.Contents ND2, v9.MonthForTask SN_RD2, v9.[MonthForTaskLaborday] SN_CC9
 --                   ,v10.Contents ND2, v10.MonthForTask SN_RD2, v10.[MonthForTaskLaborday] SN_CC10
 --                     ,v11.Contents ND2, v11.MonthForTask SN_RD2, v11.[MonthForTaskLaborday] SN_CC11
 --                       ,v12.Contents ND2, v12.MonthForTask SN_RD2, v12.[MonthForTaskLaborday] SN_CC12
 --                         ,v13.Contents ND2, v13.MonthForTask SN_RD2, v13.[MonthForTaskLaborday] SN_CC13
                           
 --    From #tmp4 v0
 --   Full Join (select * from #tmp3 where id=1) v1 on v1.FullName=v0.FullName
 --   Full Join (select * from #tmp3 where id=2) v2 on v2.FullName=v0.FullName 
 --     Full Join (select * from #tmp3 where id=3) v3 on v3.FullName=v0.FullName 
 --     Full Join (select * from #tmp3 where id=4) v4 on v4.FullName=v0.FullName 
 --     Full Join (select * from #tmp3 where id=5) v5 on v5.FullName=v0.FullName 
 --     Full Join (select * from #tmp3 where id=6) v6 on v6.FullName=v0.FullName 
 --     Full Join (select * from #tmp3 where id=7) v7 on v7.FullName=v0.FullName 
 --     Full Join (select * from #tmp3 where id=8) v8 on v8.FullName=v0.FullName 
 --     Full Join (select * from #tmp3 where id=9) v9 on v9.FullName=v0.FullName 
 --     Full Join (select * from #tmp3 where id=10) v10 on v10.FullName=v0.FullName 
 --     Full Join (select * from #tmp3 where id=11) v11 on v11.FullName=v0.FullName 
 --     Full Join (select * from #tmp3 where id=12) v12 on v12.FullName=v0.FullName 
 --     Full Join (select * from #tmp3 where id=13) v13 on v13.FullName=v0.FullName




GO
/****** Object:  StoredProcedure [dbo].[Proc_GetListContractedProfessional_By_ProjectID_sProjectTastID_In_temp]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<laipv>
-- Create date: <29.05.2018>
-- Description:	<Hàm lấy về các nội dung để thực hiện thuê khoán chuyên môn>
-- =============================================
--Chạy thử: [Proc_GetListContractedProfessional_By_ProjectID_sProjectTastID_In] 'c1644ef7-2bb9-4715-a3f8-3f21638d2c18',''
CREATE PROC [dbo].[Proc_GetListContractedProfessional_By_ProjectID_sProjectTastID_In_temp]
    @ProjectID UNIQUEIDENTIFIER,
	@sProjectTastID NVARCHAR(4000)
AS
BEGIN
	--Tạo bảng tạm chứa dữ liệu
    CREATE TABLE #Result(
          [ContractedProfessionalID] [UNIQUEIDENTIFIER] NOT NULL ,
          [ProjectID] [UNIQUEIDENTIFIER] NULL ,
          [ProjectTaskID] [UNIQUEIDENTIFIER] NULL ,
          [Contents] NVARCHAR(4000) ,
          [EmployeeID] [UNIQUEIDENTIFIER] NULL ,
          [FullName] NVARCHAR(255) ,
          [MonthForTask] INT , --Số ngày tham gia ProjectTask
          [MonthForTaskLaborday] INT , --Số ngày đã chấm công
          [SortOrder] [INT] NULL ,
          Edit [BIT] NULL --Trường cho phép có Edit được hay không
        )
    --B1: Đưa tất cả các nội dung vào
	--Thực hiện duyệt
    DECLARE @ProjectTaskID UNIQUEIDENTIFIER
    DECLARE @Contents NVARCHAR(4000)
    DECLARE Cu_PT CURSOR
    FOR
        SELECT  dbo.ProjectTask.ProjectTaskID ,
                dbo.ProjectTask.Contents
        FROM    dbo.ProjectTask
        WHERE   dbo.ProjectTask.ProjectID = @ProjectID
        ORDER BY dbo.ProjectTask.Code
    OPEN Cu_PT
    FETCH FROM Cu_PT INTO @ProjectTaskID, @Contents
    WHILE @@FETCH_STATUS = 0
        BEGIN
            --Thực hiện đưa nội dung ra bảng
            INSERT  #Result
                    ( ContractedProfessionalID ,
                      ProjectID ,
                      ProjectTaskID ,
                      Contents ,
                      EmployeeID ,
                      FullName ,
                      SortOrder ,
                      Edit
			        )
            VALUES  ( NEWID() ,
                      @ProjectID ,
                      @ProjectTaskID ,
                      @Contents ,
                      NEWID() ,
                      N'' ,
                      1 ,
                      0
			        )
			-- Thực hiện đưa thành viên tham gia vào bảng
            INSERT  #Result
                    ( ContractedProfessionalID ,
                      ProjectID ,
                      ProjectTaskID ,
                      Contents ,
                      EmployeeID ,
                      FullName ,
                      MonthForTask ,
                      SortOrder ,
                      Edit
			        )
                    SELECT  NEWID() ,
                            @ProjectID ,
                            @ProjectTaskID ,
                            N'' ,
                            dbo.ProjectTaskMember.EmployeeID ,
                            N'' ,
                            dbo.ProjectTaskMember.MonthForTask ,
                            1 ,
                            1
                    FROM    dbo.ProjectTaskMember
                    WHERE   dbo.ProjectTaskMember.ProjectTaskID = @ProjectTaskID  
			--
            FETCH FROM Cu_PT INTO @ProjectTaskID, @Contents
        END
    CLOSE Cu_PT
    DEALLOCATE Cu_PT
    --Hết
	--Đưa FullName vào
    UPDATE  A
    SET     A.FullName = RA.FullName
    FROM    #Result A
            LEFT JOIN dbo.Employee RA ON A.EmployeeID = RA.EmployeeID
	--Đưa số ngày đã chấm công vào
    UPDATE  #Result
    SET     MonthForTaskLaborday = ( SELECT COUNT(*)
                                     FROM   ProjectTaskMemberFinance
                                     WHERE  ProjectTaskMemberFinance.ProjectTaskID = #Result.ProjectTaskID
									 AND ProjectTaskMemberFinance.EmployeeID = #Result.EmployeeID
                                   ) 
	-- Lấy dữ liệu ra

    SELECT  distinct ProjectTaskID into #tmp1  FROM    #Result --into #tmp1
    -- Dem so noi dung
    Declare @CntND int
    Select @CntND=Count(*) From #tmp1
    Select identity(INT, 1,1) ID, ProjectTaskID into #tmp2 from #tmp1
   
    SELECT  ID , FullName , Contents ,
      MonthForTask, [MonthForTaskLaborday] Into #tmp3 FROM    #Result v1
    Inner Join #tmp2 v2 on v2.ProjectTaskID=v1.ProjectTaskID
    update #tmp3 set Fullname='@' where Fullname is null
    
  Select distinct FullName into #tmp4 from #tmp3
  --Select * from #tmp3
  
  Declare @i int, @st1 varchar(4000), @st2 varchar(4000)
  Set @i=1
  Set @st1='Select V0.FullName FullName '
  Set @st2=' From #tmp4 v0 '
  While (@i<=@CntND)
  Begin
    Set @st1+=
     ',v'+cast( @i as varchar(10))+'.Contents ND'+cast( @i as varchar(10))
     +', v'+cast( @i as varchar(10))+'.MonthForTask SN_RD'+cast( @i as varchar(10))
     +', v'+cast( @i as varchar(10))+'.[MonthForTaskLaborday] SN_CC'+cast( @i as varchar(10))
    Set @st2+='  Full Join (select * from #tmp3 where id='+cast( @i as varchar(10))
    +') v'+cast( @i as varchar(10))+' on v'+cast( @i as varchar(10))+'.FullName=v0.FullName'
    Set @i+=1
  End  
 Exec(@st1+@st2)       
END

-- Proc_GetListContractedProfessional_By_ProjectID_In 'c1644ef7-2bb9-4715-a3f8-3f21638d2c18'

--Select V0.FullName FullName
 --   ,v1.Contents ND1, v1.MonthForTask SN_RD1, v1.[MonthForTaskLaborday] SN_CC1
 --   ,v2.Contents ND2, v2.MonthForTask SN_RD2, v2.[MonthForTaskLaborday] SN_CC2
 --     ,v3.Contents ND2, v3.MonthForTask SN_RD2, v3.[MonthForTaskLaborday] SN_CC3
 --       ,v4.Contents ND2, v4.MonthForTask SN_RD2, v4.[MonthForTaskLaborday] SN_CC4
 --         ,v5.Contents ND2, v5.MonthForTask SN_RD2, v5.[MonthForTaskLaborday] SN_CC5
 --           ,v6.Contents ND2, v6.MonthForTask SN_RD2, v6.[MonthForTaskLaborday] SN_CC6
 --             ,v7.Contents ND2, v7.MonthForTask SN_RD2, v7.[MonthForTaskLaborday] SN_CC7
 --               ,v8.Contents ND2, v8.MonthForTask SN_RD2, v8.[MonthForTaskLaborday] SN_CC8
 --                 ,v9.Contents ND2, v9.MonthForTask SN_RD2, v9.[MonthForTaskLaborday] SN_CC9
 --                   ,v10.Contents ND2, v10.MonthForTask SN_RD2, v10.[MonthForTaskLaborday] SN_CC10
 --                     ,v11.Contents ND2, v11.MonthForTask SN_RD2, v11.[MonthForTaskLaborday] SN_CC11
 --                       ,v12.Contents ND2, v12.MonthForTask SN_RD2, v12.[MonthForTaskLaborday] SN_CC12
 --                         ,v13.Contents ND2, v13.MonthForTask SN_RD2, v13.[MonthForTaskLaborday] SN_CC13
                           
 --    From #tmp4 v0
 --   Full Join (select * from #tmp3 where id=1) v1 on v1.FullName=v0.FullName
 --   Full Join (select * from #tmp3 where id=2) v2 on v2.FullName=v0.FullName 
 --     Full Join (select * from #tmp3 where id=3) v3 on v3.FullName=v0.FullName 
 --     Full Join (select * from #tmp3 where id=4) v4 on v4.FullName=v0.FullName 
 --     Full Join (select * from #tmp3 where id=5) v5 on v5.FullName=v0.FullName 
 --     Full Join (select * from #tmp3 where id=6) v6 on v6.FullName=v0.FullName 
 --     Full Join (select * from #tmp3 where id=7) v7 on v7.FullName=v0.FullName 
 --     Full Join (select * from #tmp3 where id=8) v8 on v8.FullName=v0.FullName 
 --     Full Join (select * from #tmp3 where id=9) v9 on v9.FullName=v0.FullName 
 --     Full Join (select * from #tmp3 where id=10) v10 on v10.FullName=v0.FullName 
 --     Full Join (select * from #tmp3 where id=11) v11 on v11.FullName=v0.FullName 
 --     Full Join (select * from #tmp3 where id=12) v12 on v12.FullName=v0.FullName 
 --     Full Join (select * from #tmp3 where id=13) v13 on v13.FullName=v0.FullName




GO
/****** Object:  StoredProcedure [dbo].[Proc_GetListDaysLeftByCompanyIDAndEmployeeIDAndProjectIDAndYear]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<laipv>
-- Create date: <10.06.2018>
-- Description:	<Lấy về danh sách số ngày còn để chấm công>
-- =============================================
--[Proc_GetListDaysLeftByCompanyIDAndEmployeeIDAndProjectIDAndYear] NULL,NULL,NULL,2018
--[Proc_GetListDaysLeftByCompanyIDAndEmployeeIDAndProjectIDAndYear] '1625b2c7-997f-4b8c-b923-1a7e5227c663','4fe295eb-02fd-4dc6-bd45-6a2b0fd1d78b','180f7bdb-522e-45f1-b50a-4d3c40d7528b',2018
CREATE PROCEDURE [dbo].[Proc_GetListDaysLeftByCompanyIDAndEmployeeIDAndProjectIDAndYear]
    @CompanyID UNIQUEIDENTIFIER ,
    @EmployeeID UNIQUEIDENTIFIER ,
    @ProjectID UNIQUEIDENTIFIER ,
    @Year INT
AS
    BEGIN
        --Bước 1: Lấy tất cả các ngày làm việc trong tháng (Số ngày của tháng - Số ngày nghỉ của tháng [Bảng DayOff]
		--Tạo bảng tạm chứa dữ liệu
        CREATE TABLE #Thang
            (
              [Month] [INT] NULL ,
              [WorkingDay] [INT] NULL
            )
			--
        DECLARE @Month_1 INT
        DECLARE @Month_2 INT
        DECLARE @Month_3 INT
        DECLARE @Month_4 INT
        DECLARE @Month_5 INT
        DECLARE @Month_6 INT
        DECLARE @Month_7 INT
        DECLARE @Month_8 INT
        DECLARE @Month_9 INT
        DECLARE @Month_10 INT
        DECLARE @Month_11 INT
        DECLARE @Month_12 INT
			--Định nghĩa biến
        DECLARE @Month INT
        DECLARE @Totalday INT
        DECLARE @DayOf INT
        DECLARE @Index INT
		--Duyệt qua các tháng để lấy số ngày còn lại trong tháng
		----------------------
		----------------------
		--Tháng 1
        SELECT  @Totalday = dbo.Func_GetTotalDayInMonth(1, @Year)
        SELECT  @DayOf = ISNULL(COUNT(*), 0)
        FROM    dbo.DayOff
        WHERE   MONTH(Date) = 1
                AND YEAR(Date) = @Year
        SET @Month_1 = @Totalday - @DayOf
        INSERT  #Thang
                ( Month, WorkingDay )
        VALUES  ( 1, -- Month - int
                  @Month_1  -- Year - int
                  )
		----------------------
		----------------------
		--Tháng 2
        SELECT  @Totalday = dbo.Func_GetTotalDayInMonth(2, @Year)
        SELECT  @DayOf = ISNULL(COUNT(*), 0)
        FROM    dbo.DayOff
        WHERE   MONTH(Date) = 2
                AND YEAR(Date) = @Year
        SET @Month_2 = @Totalday - @DayOf
        INSERT  #Thang
                ( Month, WorkingDay )
        VALUES  ( 2, -- Month - int
                  @Month_2  -- Year - int
                  )
		----------------------
		----------------------
		--Tháng 3
        SELECT  @Totalday = dbo.Func_GetTotalDayInMonth(3, @Year)
        SELECT  @DayOf = ISNULL(COUNT(*), 0)
        FROM    dbo.DayOff
        WHERE   MONTH(Date) = 3
                AND YEAR(Date) = @Year
        SET @Month_3 = @Totalday - @DayOf
        INSERT  #Thang
                ( Month, WorkingDay )
        VALUES  ( 3, -- Month - int
                  @Month_3  -- Year - int
                  )
		----------------------
		----------------------
		--Tháng 4
        SELECT  @Totalday = dbo.Func_GetTotalDayInMonth(4, @Year)
        SELECT  @DayOf = ISNULL(COUNT(*), 0)
        FROM    dbo.DayOff
        WHERE   MONTH(Date) = 4
                AND YEAR(Date) = @Year
        SET @Month_4 = @Totalday - @DayOf
        INSERT  #Thang
                ( Month, WorkingDay )
        VALUES  ( 4, -- Month - int
                  @Month_4  -- Year - int
                  )
		----------------------
		----------------------
		--Tháng 5
        SELECT  @Totalday = dbo.Func_GetTotalDayInMonth(5, @Year)
        SELECT  @DayOf = ISNULL(COUNT(*), 0)
        FROM    dbo.DayOff
        WHERE   MONTH(Date) = 5
                AND YEAR(Date) = @Year
        SET @Month_5 = @Totalday - @DayOf
        INSERT  #Thang
                ( Month, WorkingDay )
        VALUES  ( 5, -- Month - int
                  @Month_5  -- Year - int
                  )
		----------------------
		----------------------
		--Tháng 6
        SELECT  @Totalday = dbo.Func_GetTotalDayInMonth(6, @Year)
        SELECT  @DayOf = ISNULL(COUNT(*), 0)
        FROM    dbo.DayOff
        WHERE   MONTH(Date) = 6
                AND YEAR(Date) = @Year
        SET @Month_6 = @Totalday - @DayOf
        INSERT  #Thang
                ( Month, WorkingDay )
        VALUES  ( 6, -- Month - int
                  @Month_6  -- Year - int
                  )
		----------------------
		----------------------
		--Tháng 7
        SELECT  @Totalday = dbo.Func_GetTotalDayInMonth(7, @Year)
        SELECT  @DayOf = ISNULL(COUNT(*), 0)
        FROM    dbo.DayOff
        WHERE   MONTH(Date) = 7
                AND YEAR(Date) = @Year
        SET @Month_7 = @Totalday - @DayOf
        INSERT  #Thang
                ( Month, WorkingDay )
        VALUES  ( 7, -- Month - int
                  @Month_7  -- Year - int
                  )
		----------------------
		----------------------
		--Tháng 8
        SELECT  @Totalday = dbo.Func_GetTotalDayInMonth(8, @Year)
        SELECT  @DayOf = ISNULL(COUNT(*), 0)
        FROM    dbo.DayOff
        WHERE   MONTH(Date) = 8
                AND YEAR(Date) = @Year
        SET @Month_8 = @Totalday - @DayOf
        INSERT  #Thang
                ( Month, WorkingDay )
        VALUES  ( 8, -- Month - int
                  @Month_8  -- Year - int
                  )
		----------------------
		----------------------
		--Tháng 9
        SELECT  @Totalday = dbo.Func_GetTotalDayInMonth(9, @Year)
        SELECT  @DayOf = ISNULL(COUNT(*), 0)
        FROM    dbo.DayOff
        WHERE   MONTH(Date) = 9
                AND YEAR(Date) = @Year
        SET @Month_9 = @Totalday - @DayOf
        INSERT  #Thang
                ( Month, WorkingDay )
        VALUES  ( 9, -- Month - int
                  @Month_9  -- Year - int
                  )
		----------------------
		----------------------
		--Tháng 10
        SELECT  @Totalday = dbo.Func_GetTotalDayInMonth(10, @Year)
        SELECT  @DayOf = ISNULL(COUNT(*), 0)
        FROM    dbo.DayOff
        WHERE   MONTH(Date) = 10
                AND YEAR(Date) = @Year
        SET @Month_10 = @Totalday - @DayOf
        INSERT  #Thang
                ( Month, WorkingDay )
        VALUES  ( 10, -- Month - int
                  @Month_10  -- Year - int
                  )
		----------------------
		----------------------
		--Tháng 1
        SELECT  @Totalday = dbo.Func_GetTotalDayInMonth(11, @Year)
        SELECT  @DayOf = ISNULL(COUNT(*), 0)
        FROM    dbo.DayOff
        WHERE   MONTH(Date) = 11
                AND YEAR(Date) = @Year
        SET @Month_11 = @Totalday - @DayOf
        INSERT  #Thang
                ( Month, WorkingDay )
        VALUES  ( 11, -- Month - int
                  @Month_11  -- Year - int
                  )
		----------------------
		----------------------
		--Tháng 12
        SELECT  @Totalday = dbo.Func_GetTotalDayInMonth(12, @Year)
        SELECT  @DayOf = ISNULL(COUNT(*), 0)
        FROM    dbo.DayOff
        WHERE   MONTH(Date) = 12
                AND YEAR(Date) = @Year
        SET @Month_12 = @Totalday - @DayOf
        INSERT  #Thang
                ( Month, WorkingDay )
        VALUES  ( 12, -- Month - int
                  @Month_12  -- Year - int
                  )
		----------------------
		--Hết
        
		--Bước 2: Lấy tất cả số ngày đã chấm công [Bảng ProjectTaskMemberFinance] theo từng tháng của mỗi cán bộ thuộc [Bảng Employee] (Lấy tất cả các cán bộ)
        CREATE TABLE #DayTimeKeep
            (
			[SortOrder] INT IDENTITY(1,1),
              [EmployeeID] UNIQUEIDENTIFIER ,
              [FullName] NVARCHAR(255) ,
              [Month_1] [INT] NULL ,
              [DayTimeKeep_1] [INT] NULL ,
              [DayLeft_1] [INT] NULL ,
              [Month_2] [INT] NULL ,
              [DayTimeKeep_2] [INT] NULL ,
              [DayLeft_2] [INT] NULL ,
              [Month_3] [INT] NULL ,
              [DayTimeKeep_3] [INT] NULL ,
              [DayLeft_3] [INT] NULL ,
              [Month_4] [INT] NULL ,
              [DayTimeKeep_4] [INT] NULL ,
              [DayLeft_4] [INT] NULL ,
              [Month_5] [INT] NULL ,
              [DayTimeKeep_5] [INT] NULL ,
              [DayLeft_5] [INT] NULL ,
              [Month_6] [INT] NULL ,
              [DayTimeKeep_6] [INT] NULL ,
              [DayLeft_6] [INT] NULL ,
              [Month_7] [INT] NULL ,
              [DayTimeKeep_7] [INT] NULL ,
              [DayLeft_7] [INT] NULL ,
              [Month_8] [INT] NULL ,
              [DayTimeKeep_8] [INT] NULL ,
              [DayLeft_8] [INT] NULL ,
              [Month_9] [INT] NULL ,
              [DayTimeKeep_9] [INT] NULL ,
              [DayLeft_9] [INT] NULL ,
              [Month_10] [INT] NULL ,
              [DayTimeKeep_10] [INT] NULL ,
              [DayLeft_10] [INT] NULL ,
              [Month_11] [INT] NULL ,
              [DayTimeKeep_11] [INT] NULL ,
              [DayLeft_11] [INT] NULL ,
              [Month_12] [INT] NULL ,
              [DayTimeKeep_12] [INT] NULL ,
              [DayLeft_12] [INT] NULL,
            )

        INSERT  #DayTimeKeep
                ( 
				EmployeeID ,
                  FullName ,
                  Month_1 ,
                  DayTimeKeep_1 ,
                  DayLeft_1 ,
                  Month_2 ,
                  DayTimeKeep_2 ,
                  DayLeft_2 ,
                  Month_3 ,
                  DayTimeKeep_3 ,
                  DayLeft_3 ,
                  Month_4 ,
                  DayTimeKeep_4 ,
                  DayLeft_4 ,
                  Month_5 ,
                  DayTimeKeep_5 ,
                  DayLeft_5 ,
                  Month_6 ,
                  DayTimeKeep_6 ,
                  DayLeft_6 ,
                  Month_7 ,
                  DayTimeKeep_7 ,
                  DayLeft_7 ,
                  Month_8 ,
                  DayTimeKeep_8 ,
                  DayLeft_8 ,
                  Month_9 ,
                  DayTimeKeep_9 ,
                  DayLeft_9 ,
                  Month_10 ,
                  DayTimeKeep_10 ,
                  DayLeft_10 ,
                  Month_11 ,
                  DayTimeKeep_11 ,
                  DayLeft_11 ,
                  Month_12 ,
                  DayTimeKeep_12 ,
                  DayLeft_12
			    )
                SELECT 
				 E.EmployeeID , -- EmployeeID - uniqueidentifier
                        E.FullName , -- FullName - nvarchar(255)
                        @Month_1 , -- Month_1 - int
                        ( SELECT    COUNT(*)
                          FROM      dbo.ProjectTaskMemberFinance PT
                          WHERE     PT.EmployeeID = E.EmployeeID
                                    AND PT.Month = 1
                                    AND PT.Year = @Year
                        ) , -- DayTimeKeep_1 - int
                        0 , -- DayLeft_1 - int
                        @Month_2 , -- Month_2 - int
                        ( SELECT    COUNT(*)
                          FROM      dbo.ProjectTaskMemberFinance PT
                          WHERE     PT.EmployeeID = E.EmployeeID
                                    AND PT.Month = 2
                                    AND PT.Year = @Year
                        ) , -- DayTimeKeep_2 - int
                        0 , -- DayLeft_2 - int
                        @Month_3 , -- Month_3 - int
                        ( SELECT    COUNT(*)
                          FROM      dbo.ProjectTaskMemberFinance PT
                          WHERE     PT.EmployeeID = E.EmployeeID
                                    AND PT.Month = 3
                                    AND PT.Year = @Year
                        ) , -- DayTimeKeep_3 - int
                        0 , -- DayLeft_3 - int
                        @Month_4 , -- Month_4 - int
                        ( SELECT    COUNT(*)
                          FROM      dbo.ProjectTaskMemberFinance PT
                          WHERE     PT.EmployeeID = E.EmployeeID
                                    AND PT.Month = 4
                                    AND PT.Year = @Year
                        ) , -- DayTimeKeep_4 - int
                        0 , -- DayLeft_4 - int
                        @Month_5 , -- Month_5 - int
                        ( SELECT    COUNT(*)
                          FROM      dbo.ProjectTaskMemberFinance PT
                          WHERE     PT.EmployeeID = E.EmployeeID
                                    AND PT.Month = 5
                                    AND PT.Year = @Year
                        ) , -- DayTimeKeep_5 - int
                        0 , -- DayLeft_5 - int
                        @Month_6 , -- Month_6 - int
                        ( SELECT    COUNT(*)
                          FROM      dbo.ProjectTaskMemberFinance PT
                          WHERE     PT.EmployeeID = E.EmployeeID
                                    AND PT.Month = 6
                                    AND PT.Year = @Year
                        ) , -- DayTimeKeep_6 - int
                        0 , -- DayLeft_6 - int
                        @Month_7 , -- Month_7 - int
                        ( SELECT    COUNT(*)
                          FROM      dbo.ProjectTaskMemberFinance PT
                          WHERE     PT.EmployeeID = E.EmployeeID
                                    AND PT.Month = 7
                                    AND PT.Year = @Year
                        ) , -- DayTimeKeep_7 - int
                        0 , -- DayLeft_7 - int
                        @Month_8 , -- Month_8 - int
                        ( SELECT    COUNT(*)
                          FROM      dbo.ProjectTaskMemberFinance PT
                          WHERE     PT.EmployeeID = E.EmployeeID
                                    AND PT.Month = 8
                                    AND PT.Year = @Year
                        ) , -- DayTimeKeep_8 - int
                        0 , -- DayLeft_8 - int
                        @Month_9 , -- Month_9 - int
                        ( SELECT    COUNT(*)
                          FROM      dbo.ProjectTaskMemberFinance PT
                          WHERE     PT.EmployeeID = E.EmployeeID
                                    AND PT.Month = 9
                                    AND PT.Year = @Year
                        ) , -- DayTimeKeep_9 - int
                        0 , -- DayLeft_9 - int
                        @Month_10 , -- Month_10 - int
                        ( SELECT    COUNT(*)
                          FROM      dbo.ProjectTaskMemberFinance PT
                          WHERE     PT.EmployeeID = E.EmployeeID
                                    AND PT.Month = 10
                                    AND PT.Year = @Year
                        ) , -- DayTimeKeep_10 - int
                        0 , -- DayLeft_10 - int
                        @Month_11 , -- Month_11 - int
                        ( SELECT    COUNT(*)
                          FROM      dbo.ProjectTaskMemberFinance PT
                          WHERE     PT.EmployeeID = E.EmployeeID
                                    AND PT.Month = 11
                                    AND PT.Year = @Year
                        ) , -- DayTimeKeep_11 - int
                        0 , -- DayLeft_11 - int
                        @Month_12 , -- Month_12 - int
                        ( SELECT    COUNT(*)
                          FROM      dbo.ProjectTaskMemberFinance PT
                          WHERE     PT.EmployeeID = E.EmployeeID
                                    AND PT.Month = 12
                                    AND PT.Year = @Year
                        ) , -- DayTimeKeep_12 - int
                        0  -- DayLeft_12 - int
                FROM    dbo.Employee E
				WHERE (E.CompanyID = @CompanyID OR @CompanyID = NULL OR @CompanyID = '00000000-0000-0000-0000-000000000000' )
				AND (E.EmployeeID = @EmployeeID OR @EmployeeID = NULL OR @EmployeeID = '00000000-0000-0000-0000-000000000000' )
                ORDER BY E.CompanyID ,
                        E.FirstName ,
                        E.LastName

						-- 
        UPDATE  #DayTimeKeep
        SET     DayLeft_1 = ISNULL(Month_1, 0) - ISNULL(DayTimeKeep_1, 0) ,
                DayLeft_2 = ISNULL(Month_2, 0) - ISNULL(DayTimeKeep_2, 0) ,
                DayLeft_3 = ISNULL(Month_3, 0) - ISNULL(DayTimeKeep_3, 0) ,
                DayLeft_4 = ISNULL(Month_4, 0) - ISNULL(DayTimeKeep_4, 0) ,
                DayLeft_5 = ISNULL(Month_5, 0) - ISNULL(DayTimeKeep_5, 0) ,
                DayLeft_6 = ISNULL(Month_6, 0) - ISNULL(DayTimeKeep_6, 0) ,
                DayLeft_7 = ISNULL(Month_7, 0) - ISNULL(DayTimeKeep_7, 0) ,
                DayLeft_8 = ISNULL(Month_8, 0) - ISNULL(DayTimeKeep_8, 0) ,
                DayLeft_9 = ISNULL(Month_9, 0) - ISNULL(DayTimeKeep_9, 0) ,
                DayLeft_10 = ISNULL(Month_10, 0) - ISNULL(DayTimeKeep_10, 0) ,
                DayLeft_11 = ISNULL(Month_11, 0) - ISNULL(DayTimeKeep_11, 0) ,
                DayLeft_12 = ISNULL(Month_12, 0) - ISNULL(DayTimeKeep_12, 0)


        --Bước 3: Lấy dữ liệu ra
        SELECT  ROW_NUMBER() OVER ( ORDER BY SortOrder ) AS RowNum ,
                *
        FROM    #DayTimeKeep

        SELECT  *
        FROM    #Thang
		--
        DROP TABLE #Thang
        DROP TABLE #DayTimeKeep
		--

    END




GO
/****** Object:  StoredProcedure [dbo].[Proc_GetListDaysLeftByCompanyIDAndEmployeeIDAndProjectIDAndYearExcel]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<laipv>
-- Create date: <10.06.2018>
-- Description:	<Lấy về danh sách số ngày còn để chấm công>
-- =============================================
--[Proc_GetListDaysLeftByCompanyIDAndEmployeeIDAndProjectIDAndYearExcel] NULL,NULL,NULL,2018
--[Proc_GetListDaysLeftByCompanyIDAndEmployeeIDAndProjectIDAndYearExcel] '1625b2c7-997f-4b8c-b923-1a7e5227c663','4fe295eb-02fd-4dc6-bd45-6a2b0fd1d78b','180f7bdb-522e-45f1-b50a-4d3c40d7528b',2018
CREATE PROCEDURE [dbo].[Proc_GetListDaysLeftByCompanyIDAndEmployeeIDAndProjectIDAndYearExcel]
    @CompanyID UNIQUEIDENTIFIER ,
    @EmployeeID UNIQUEIDENTIFIER ,
    @ProjectID UNIQUEIDENTIFIER ,
    @Year INT
AS
    BEGIN
        --Bước 1: Lấy tất cả các ngày làm việc trong tháng (Số ngày của tháng - Số ngày nghỉ của tháng [Bảng DayOff]
		--Tạo bảng tạm chứa dữ liệu
        CREATE TABLE #Thang
            (
              [Month] [INT] NULL ,
              [WorkingDay] [INT] NULL
            )
			--
        DECLARE @Month_1 INT
        DECLARE @Month_2 INT
        DECLARE @Month_3 INT
        DECLARE @Month_4 INT
        DECLARE @Month_5 INT
        DECLARE @Month_6 INT
        DECLARE @Month_7 INT
        DECLARE @Month_8 INT
        DECLARE @Month_9 INT
        DECLARE @Month_10 INT
        DECLARE @Month_11 INT
        DECLARE @Month_12 INT
			--Định nghĩa biến
        DECLARE @Month INT
        DECLARE @Totalday INT
        DECLARE @DayOf INT
        DECLARE @Index INT
		--Duyệt qua các tháng để lấy số ngày còn lại trong tháng
		----------------------
		----------------------
		--Tháng 1
        SELECT  @Totalday = dbo.Func_GetTotalDayInMonth(1, @Year)
        SELECT  @DayOf = ISNULL(COUNT(*), 0)
        FROM    dbo.DayOff
        WHERE   MONTH(Date) = 1
                AND YEAR(Date) = @Year
        SET @Month_1 = @Totalday - @DayOf
        INSERT  #Thang
                ( Month, WorkingDay )
        VALUES  ( 1, -- Month - int
                  @Month_1  -- Year - int
                  )
		----------------------
		----------------------
		--Tháng 2
        SELECT  @Totalday = dbo.Func_GetTotalDayInMonth(2, @Year)
        SELECT  @DayOf = ISNULL(COUNT(*), 0)
        FROM    dbo.DayOff
        WHERE   MONTH(Date) = 2
                AND YEAR(Date) = @Year
        SET @Month_2 = @Totalday - @DayOf
        INSERT  #Thang
                ( Month, WorkingDay )
        VALUES  ( 2, -- Month - int
                  @Month_2  -- Year - int
                  )
		----------------------
		----------------------
		--Tháng 3
        SELECT  @Totalday = dbo.Func_GetTotalDayInMonth(3, @Year)
        SELECT  @DayOf = ISNULL(COUNT(*), 0)
        FROM    dbo.DayOff
        WHERE   MONTH(Date) = 3
                AND YEAR(Date) = @Year
        SET @Month_3 = @Totalday - @DayOf
        INSERT  #Thang
                ( Month, WorkingDay )
        VALUES  ( 3, -- Month - int
                  @Month_3  -- Year - int
                  )
		----------------------
		----------------------
		--Tháng 4
        SELECT  @Totalday = dbo.Func_GetTotalDayInMonth(4, @Year)
        SELECT  @DayOf = ISNULL(COUNT(*), 0)
        FROM    dbo.DayOff
        WHERE   MONTH(Date) = 4
                AND YEAR(Date) = @Year
        SET @Month_4 = @Totalday - @DayOf
        INSERT  #Thang
                ( Month, WorkingDay )
        VALUES  ( 4, -- Month - int
                  @Month_4  -- Year - int
                  )
		----------------------
		----------------------
		--Tháng 5
        SELECT  @Totalday = dbo.Func_GetTotalDayInMonth(5, @Year)
        SELECT  @DayOf = ISNULL(COUNT(*), 0)
        FROM    dbo.DayOff
        WHERE   MONTH(Date) = 5
                AND YEAR(Date) = @Year
        SET @Month_5 = @Totalday - @DayOf
        INSERT  #Thang
                ( Month, WorkingDay )
        VALUES  ( 5, -- Month - int
                  @Month_5  -- Year - int
                  )
		----------------------
		----------------------
		--Tháng 6
        SELECT  @Totalday = dbo.Func_GetTotalDayInMonth(6, @Year)
        SELECT  @DayOf = ISNULL(COUNT(*), 0)
        FROM    dbo.DayOff
        WHERE   MONTH(Date) = 6
                AND YEAR(Date) = @Year
        SET @Month_6 = @Totalday - @DayOf
        INSERT  #Thang
                ( Month, WorkingDay )
        VALUES  ( 6, -- Month - int
                  @Month_6  -- Year - int
                  )
		----------------------
		----------------------
		--Tháng 7
        SELECT  @Totalday = dbo.Func_GetTotalDayInMonth(7, @Year)
        SELECT  @DayOf = ISNULL(COUNT(*), 0)
        FROM    dbo.DayOff
        WHERE   MONTH(Date) = 7
                AND YEAR(Date) = @Year
        SET @Month_7 = @Totalday - @DayOf
        INSERT  #Thang
                ( Month, WorkingDay )
        VALUES  ( 7, -- Month - int
                  @Month_7  -- Year - int
                  )
		----------------------
		----------------------
		--Tháng 8
        SELECT  @Totalday = dbo.Func_GetTotalDayInMonth(8, @Year)
        SELECT  @DayOf = ISNULL(COUNT(*), 0)
        FROM    dbo.DayOff
        WHERE   MONTH(Date) = 8
                AND YEAR(Date) = @Year
        SET @Month_8 = @Totalday - @DayOf
        INSERT  #Thang
                ( Month, WorkingDay )
        VALUES  ( 8, -- Month - int
                  @Month_8  -- Year - int
                  )
		----------------------
		----------------------
		--Tháng 9
        SELECT  @Totalday = dbo.Func_GetTotalDayInMonth(9, @Year)
        SELECT  @DayOf = ISNULL(COUNT(*), 0)
        FROM    dbo.DayOff
        WHERE   MONTH(Date) = 9
                AND YEAR(Date) = @Year
        SET @Month_9 = @Totalday - @DayOf
        INSERT  #Thang
                ( Month, WorkingDay )
        VALUES  ( 9, -- Month - int
                  @Month_9  -- Year - int
                  )
		----------------------
		----------------------
		--Tháng 10
        SELECT  @Totalday = dbo.Func_GetTotalDayInMonth(10, @Year)
        SELECT  @DayOf = ISNULL(COUNT(*), 0)
        FROM    dbo.DayOff
        WHERE   MONTH(Date) = 10
                AND YEAR(Date) = @Year
        SET @Month_10 = @Totalday - @DayOf
        INSERT  #Thang
                ( Month, WorkingDay )
        VALUES  ( 10, -- Month - int
                  @Month_10  -- Year - int
                  )
		----------------------
		----------------------
		--Tháng 1
        SELECT  @Totalday = dbo.Func_GetTotalDayInMonth(11, @Year)
        SELECT  @DayOf = ISNULL(COUNT(*), 0)
        FROM    dbo.DayOff
        WHERE   MONTH(Date) = 11
                AND YEAR(Date) = @Year
        SET @Month_11 = @Totalday - @DayOf
        INSERT  #Thang
                ( Month, WorkingDay )
        VALUES  ( 11, -- Month - int
                  @Month_11  -- Year - int
                  )
		----------------------
		----------------------
		--Tháng 12
        SELECT  @Totalday = dbo.Func_GetTotalDayInMonth(12, @Year)
        SELECT  @DayOf = ISNULL(COUNT(*), 0)
        FROM    dbo.DayOff
        WHERE   MONTH(Date) = 12
                AND YEAR(Date) = @Year
        SET @Month_12 = @Totalday - @DayOf
        INSERT  #Thang
                ( Month, WorkingDay )
        VALUES  ( 12, -- Month - int
                  @Month_12  -- Year - int
                  )
		----------------------
		--Hết
        
		--Bước 2: Lấy tất cả số ngày đã chấm công [Bảng ProjectTaskMemberFinance] theo từng tháng của mỗi cán bộ thuộc [Bảng Employee] (Lấy tất cả các cán bộ)
        CREATE TABLE #DayTimeKeep
            (
              [EmployeeID] UNIQUEIDENTIFIER ,
              [FullName] NVARCHAR(255) ,
              [Month_1] [INT] NULL ,
              [DayTimeKeep_1] [INT] NULL ,
              [DayLeft_1] [INT] NULL ,
              [Month_2] [INT] NULL ,
              [DayTimeKeep_2] [INT] NULL ,
              [DayLeft_2] [INT] NULL ,
              [Month_3] [INT] NULL ,
              [DayTimeKeep_3] [INT] NULL ,
              [DayLeft_3] [INT] NULL ,
              [Month_4] [INT] NULL ,
              [DayTimeKeep_4] [INT] NULL ,
              [DayLeft_4] [INT] NULL ,
              [Month_5] [INT] NULL ,
              [DayTimeKeep_5] [INT] NULL ,
              [DayLeft_5] [INT] NULL ,
              [Month_6] [INT] NULL ,
              [DayTimeKeep_6] [INT] NULL ,
              [DayLeft_6] [INT] NULL ,
              [Month_7] [INT] NULL ,
              [DayTimeKeep_7] [INT] NULL ,
              [DayLeft_7] [INT] NULL ,
              [Month_8] [INT] NULL ,
              [DayTimeKeep_8] [INT] NULL ,
              [DayLeft_8] [INT] NULL ,
              [Month_9] [INT] NULL ,
              [DayTimeKeep_9] [INT] NULL ,
              [DayLeft_9] [INT] NULL ,
              [Month_10] [INT] NULL ,
              [DayTimeKeep_10] [INT] NULL ,
              [DayLeft_10] [INT] NULL ,
              [Month_11] [INT] NULL ,
              [DayTimeKeep_11] [INT] NULL ,
              [DayLeft_11] [INT] NULL ,
              [Month_12] [INT] NULL ,
              [DayTimeKeep_12] [INT] NULL ,
              [DayLeft_12] [INT] NULL,
            )

        INSERT  #DayTimeKeep
                ( EmployeeID ,
                  FullName ,
                  Month_1 ,
                  DayTimeKeep_1 ,
                  DayLeft_1 ,
                  Month_2 ,
                  DayTimeKeep_2 ,
                  DayLeft_2 ,
                  Month_3 ,
                  DayTimeKeep_3 ,
                  DayLeft_3 ,
                  Month_4 ,
                  DayTimeKeep_4 ,
                  DayLeft_4 ,
                  Month_5 ,
                  DayTimeKeep_5 ,
                  DayLeft_5 ,
                  Month_6 ,
                  DayTimeKeep_6 ,
                  DayLeft_6 ,
                  Month_7 ,
                  DayTimeKeep_7 ,
                  DayLeft_7 ,
                  Month_8 ,
                  DayTimeKeep_8 ,
                  DayLeft_8 ,
                  Month_9 ,
                  DayTimeKeep_9 ,
                  DayLeft_9 ,
                  Month_10 ,
                  DayTimeKeep_10 ,
                  DayLeft_10 ,
                  Month_11 ,
                  DayTimeKeep_11 ,
                  DayLeft_11 ,
                  Month_12 ,
                  DayTimeKeep_12 ,
                  DayLeft_12
			    )
                SELECT  E.EmployeeID , -- EmployeeID - uniqueidentifier
                        E.FullName , -- FullName - nvarchar(255)
                        @Month_1 , -- Month_1 - int
                        ( SELECT    COUNT(*)
                          FROM      dbo.ProjectTaskMemberFinance PT
                          WHERE     PT.EmployeeID = E.EmployeeID
                                    AND PT.Month = 1
                                    AND PT.Year = @Year
                        ) , -- DayTimeKeep_1 - int
                        0 , -- DayLeft_1 - int
                        @Month_2 , -- Month_2 - int
                        ( SELECT    COUNT(*)
                          FROM      dbo.ProjectTaskMemberFinance PT
                          WHERE     PT.EmployeeID = E.EmployeeID
                                    AND PT.Month = 2
                                    AND PT.Year = @Year
                        ) , -- DayTimeKeep_2 - int
                        0 , -- DayLeft_2 - int
                        @Month_3 , -- Month_3 - int
                        ( SELECT    COUNT(*)
                          FROM      dbo.ProjectTaskMemberFinance PT
                          WHERE     PT.EmployeeID = E.EmployeeID
                                    AND PT.Month = 3
                                    AND PT.Year = @Year
                        ) , -- DayTimeKeep_3 - int
                        0 , -- DayLeft_3 - int
                        @Month_4 , -- Month_4 - int
                        ( SELECT    COUNT(*)
                          FROM      dbo.ProjectTaskMemberFinance PT
                          WHERE     PT.EmployeeID = E.EmployeeID
                                    AND PT.Month = 4
                                    AND PT.Year = @Year
                        ) , -- DayTimeKeep_4 - int
                        0 , -- DayLeft_4 - int
                        @Month_5 , -- Month_5 - int
                        ( SELECT    COUNT(*)
                          FROM      dbo.ProjectTaskMemberFinance PT
                          WHERE     PT.EmployeeID = E.EmployeeID
                                    AND PT.Month = 5
                                    AND PT.Year = @Year
                        ) , -- DayTimeKeep_5 - int
                        0 , -- DayLeft_5 - int
                        @Month_6 , -- Month_6 - int
                        ( SELECT    COUNT(*)
                          FROM      dbo.ProjectTaskMemberFinance PT
                          WHERE     PT.EmployeeID = E.EmployeeID
                                    AND PT.Month = 6
                                    AND PT.Year = @Year
                        ) , -- DayTimeKeep_6 - int
                        0 , -- DayLeft_6 - int
                        @Month_7 , -- Month_7 - int
                        ( SELECT    COUNT(*)
                          FROM      dbo.ProjectTaskMemberFinance PT
                          WHERE     PT.EmployeeID = E.EmployeeID
                                    AND PT.Month = 7
                                    AND PT.Year = @Year
                        ) , -- DayTimeKeep_7 - int
                        0 , -- DayLeft_7 - int
                        @Month_8 , -- Month_8 - int
                        ( SELECT    COUNT(*)
                          FROM      dbo.ProjectTaskMemberFinance PT
                          WHERE     PT.EmployeeID = E.EmployeeID
                                    AND PT.Month = 8
                                    AND PT.Year = @Year
                        ) , -- DayTimeKeep_8 - int
                        0 , -- DayLeft_8 - int
                        @Month_9 , -- Month_9 - int
                        ( SELECT    COUNT(*)
                          FROM      dbo.ProjectTaskMemberFinance PT
                          WHERE     PT.EmployeeID = E.EmployeeID
                                    AND PT.Month = 9
                                    AND PT.Year = @Year
                        ) , -- DayTimeKeep_9 - int
                        0 , -- DayLeft_9 - int
                        @Month_10 , -- Month_10 - int
                        ( SELECT    COUNT(*)
                          FROM      dbo.ProjectTaskMemberFinance PT
                          WHERE     PT.EmployeeID = E.EmployeeID
                                    AND PT.Month = 10
                                    AND PT.Year = @Year
                        ) , -- DayTimeKeep_10 - int
                        0 , -- DayLeft_10 - int
                        @Month_11 , -- Month_11 - int
                        ( SELECT    COUNT(*)
                          FROM      dbo.ProjectTaskMemberFinance PT
                          WHERE     PT.EmployeeID = E.EmployeeID
                                    AND PT.Month = 11
                                    AND PT.Year = @Year
                        ) , -- DayTimeKeep_11 - int
                        0 , -- DayLeft_11 - int
                        @Month_12 , -- Month_12 - int
                        ( SELECT    COUNT(*)
                          FROM      dbo.ProjectTaskMemberFinance PT
                          WHERE     PT.EmployeeID = E.EmployeeID
                                    AND PT.Month = 12
                                    AND PT.Year = @Year
                        ) , -- DayTimeKeep_12 - int
                        0  -- DayLeft_12 - int
                FROM    dbo.Employee E
                ORDER BY E.CompanyID ,
                        E.LastName ,
                        E.FirstName

						-- 
        UPDATE  #DayTimeKeep
        SET     DayLeft_1 = ISNULL(Month_1, 0) - ISNULL(DayTimeKeep_1, 0) ,
                DayLeft_2 = ISNULL(Month_2, 0) - ISNULL(DayTimeKeep_2, 0) ,
                DayLeft_3 = ISNULL(Month_3, 0) - ISNULL(DayTimeKeep_3, 0) ,
                DayLeft_4 = ISNULL(Month_4, 0) - ISNULL(DayTimeKeep_4, 0) ,
                DayLeft_5 = ISNULL(Month_5, 0) - ISNULL(DayTimeKeep_5, 0) ,
                DayLeft_6 = ISNULL(Month_6, 0) - ISNULL(DayTimeKeep_6, 0) ,
                DayLeft_7 = ISNULL(Month_7, 0) - ISNULL(DayTimeKeep_7, 0) ,
                DayLeft_8 = ISNULL(Month_8, 0) - ISNULL(DayTimeKeep_8, 0) ,
                DayLeft_9 = ISNULL(Month_9, 0) - ISNULL(DayTimeKeep_9, 0) ,
                DayLeft_10 = ISNULL(Month_10, 0) - ISNULL(DayTimeKeep_10, 0) ,
                DayLeft_11 = ISNULL(Month_11, 0) - ISNULL(DayTimeKeep_11, 0) ,
                DayLeft_12 = ISNULL(Month_12, 0) - ISNULL(DayTimeKeep_12, 0)


        --Bước 3: Lấy dữ liệu ra
        SELECT  ROW_NUMBER() OVER ( ORDER BY FullName ) AS RowNum ,
                FullName ,
                DayTimeKeep_1 ,
                DayLeft_1 ,
                DayTimeKeep_2 ,
                DayLeft_2 ,
                DayTimeKeep_3 ,
                DayLeft_3 ,
                DayTimeKeep_4 ,
                DayLeft_4 ,
                DayTimeKeep_5 ,
                DayLeft_5 ,
                DayTimeKeep_6 ,
                DayLeft_6 ,
                DayTimeKeep_7 ,
                DayLeft_7 ,
                DayTimeKeep_8 ,
                DayLeft_8 ,
                DayTimeKeep_9 ,
                DayLeft_9 ,
                DayTimeKeep_10 ,
                DayLeft_10 ,
                DayTimeKeep_11 ,
                DayLeft_11 ,
                DayTimeKeep_12 ,
                DayLeft_12
        FROM    #DayTimeKeep

        SELECT  *
        FROM    #Thang
		--
        DROP TABLE #Thang
        DROP TABLE #DayTimeKeep
		--

    END




GO
/****** Object:  StoredProcedure [dbo].[Proc_GetListProjectCloseByMasterID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<truongnm>
-- Create date: <11.02.2018>
-- Description:	<Lấy danh sách Kế hoạch thực hiện>
-- =============================================
create PROCEDURE [dbo].[Proc_GetListProjectCloseByMasterID]
    @masterID UNIQUEIDENTIFIER
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

        SELECT  *
        FROM    dbo.ProjectClose
        WHERE   ProjectID = @masterID
    END




GO
/****** Object:  StoredProcedure [dbo].[Proc_GetListProjectPlanExpenseByMasterID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<truongnm>
-- Create date: <11.02.2018>
-- Description:	<Lấy danh sách Kế hoạch thực hiện>
-- =============================================
CREATE PROCEDURE [dbo].[Proc_GetListProjectPlanExpenseByMasterID]
    @MasterID UNIQUEIDENTIFIER
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

        SELECT  *
        FROM    dbo.ProjectPlanExpense
        WHERE   ProjectID = @MasterID
    END




GO
/****** Object:  StoredProcedure [dbo].[Proc_GetListProjectPlanPerformByMasterID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<truongnm>
-- Create date: <11.02.2018>
-- Description:	<Lấy danh sách Kế hoạch thực hiện>
-- =============================================
CREATE PROCEDURE [dbo].[Proc_GetListProjectPlanPerformByMasterID]
    @masterID UNIQUEIDENTIFIER
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

        SELECT  *
        FROM    dbo.ProjectPlanPerform
        WHERE   ProjectID = @masterID
    END




GO
/****** Object:  StoredProcedure [dbo].[Proc_GetListProjectTaskByMasterID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<dvthang>
-- Create date: <06.02.2018>
-- Description:	<Lấy danh sách nội dung của đề tài>
-- =============================================

CREATE PROCEDURE [dbo].[Proc_GetListProjectTaskByMasterID]
    @MasterID UNIQUEIDENTIFIER
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

        SELECT  ProjectTaskID ,
                ParentID ,
                ProjectID ,
                Contents ,
                Rank ,
                Result ,
                StartDate ,
                EndDate ,
                EmployeeID ,
                Status ,
                Code ,
                Grade ,
                Inactive                
        FROM    dbo.ProjectTask
        WHERE   ProjectID = @MasterID
        ORDER BY Code 
    END




GO
/****** Object:  StoredProcedure [dbo].[Proc_GetListProjectTaskMemberFinances]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<laipv>
-- Create date: <03.03.2017>
-- Description:	<Hàm lấy về các ngày làm việc trong tháng>
-- =============================================
--Chạy thử: Proc_GetListProjectTaskMemberFinances '5fd3894e-5e75-4ad6-9db3-77bd06ed29da', '7fe5b578-6f4a-4073-b866-b950c1d7124b', '8e543541-40fb-40ed-8d5b-8e42a73faad5', 2018, 5
CREATE PROC [dbo].[Proc_GetListProjectTaskMemberFinances]
    @ProjectID UNIQUEIDENTIFIER ,
    @ProjectTaskID UNIQUEIDENTIFIER ,
    @EmployeeID UNIQUEIDENTIFIER ,
    @Year INT ,
    @Month INT
AS
    BEGIN
		--Tạo bảng tạm chứa dữ liệu
        CREATE TABLE #Result
            (
              [ProjectTaskMemberFinanceID] [UNIQUEIDENTIFIER] NULL ,
              [ProjectID] [UNIQUEIDENTIFIER] NULL ,
              [ProjectTaskID] [UNIQUEIDENTIFIER] NOT NULL ,
              [EmployeeID] [UNIQUEIDENTIFIER] NOT NULL ,
              [Year] [INT] NULL ,
              [Month] [INT] NULL ,
              [Day] [DATE] NULL ,
              [Description] [NVARCHAR](255) NULL ,
              [Hour] [NUMERIC](20, 4) NULL ,
              [LaborDay] [NUMERIC](20, 4) NULL ,
              [DescriptionFin] [NVARCHAR](255) NULL ,
              [HourFin] [NUMERIC](20, 4) NULL ,
              [LaborDayFin] [NUMERIC](20, 4) NULL ,
              [SortOrder] [INT] NULL ,
              [DayOff] BIT ,
              [LaborDayMade] [NUMERIC](20, 4) NULL , --Ngày công đã thực hiện
              [DescriptionMade] [NVARCHAR](255) NULL , --Mô tả ngày công đã thực hiện cho công việc nào
            )
		--Lấy số ngày của tháng theo (Year, Month)
        DECLARE @TotalDay INT
        SELECT  @TotalDay = dbo.Func_GetTotalDayInMonth(@Month, @Year)
		--Duyệt qua tất cả các ngày trong tháng để đưa nội dung vào
        DECLARE @iIndex INT = 1
        DECLARE @cDate DATE
        
        WHILE @iIndex <= @TotalDay
            BEGIN
			--
                SET @cDate = CONVERT(NVARCHAR(4), @Year) + '-'
                    + CONVERT(NVARCHAR(2), @Month) + '-'
                    + CONVERT(NVARCHAR(2), @iIndex)
			--
                INSERT  INTO #Result
                        ( [ProjectTaskMemberFinanceID] ,
                          [ProjectID] ,
                          [ProjectTaskID] ,
                          [EmployeeID] ,
                          [Year] ,
                          [Month] ,
                          [Day] ,
                          [Description] ,
                          [Hour] ,
                          [LaborDay] ,
                          [DescriptionFin] ,
                          [HourFin] ,
                          [LaborDayFin] ,
                          [SortOrder] ,
                          [DayOff]
			            )
                VALUES  ( NEWID() ,
                          @ProjectID ,
                          @ProjectTaskID ,
                          @EmployeeID ,
                          @Year ,
                          @Month ,
                          @cDate ,
                          N'' ,
                          0 ,
                          0 ,
                          N'' ,
                          0 ,
                          0 ,
                          @iIndex ,
                          0
			            )
			--
                SET @iIndex = @iIndex + 1
            END
		-- Lấy dữ liệu ra
        SELECT  ISNULL(PT.ProjectTaskMemberFinanceID,
                       T.ProjectTaskMemberFinanceID) AS ProjectTaskMemberFinanceID ,
                T.[ProjectID] ,
                T.[ProjectTaskID] ,
                T.[EmployeeID] ,
                T.[Year] ,
                T.[Month] ,
                T.[Day] ,
                PT.[Description] ,
                PT.[Hour] ,
                PT.[LaborDay] ,
                PT.[DescriptionFin] ,
                PT.[HourFin] ,
                PT.[LaborDayFin] ,
                ISNULL(PT.[SortOrder], T.SortOrder) AS SortOrder ,
                T.DayOff
        INTO    #Temp
        FROM    #Result T
                LEFT JOIN ProjectTaskMemberFinance AS PT ON T.ProjectID = PT.ProjectID
                                                            AND PT.ProjectTaskID = T.ProjectTaskID
                                                            AND PT.EmployeeID = T.EmployeeID
                                                            AND PT.Month = T.Month
                                                            AND PT.Year = T.Year
                                                            AND T.Day = PT.Day
		-- Lấy dữ liệu ra
        SELECT  #Temp.ProjectTaskMemberFinanceID ,
                #Temp.[ProjectID] ,
                #Temp.[ProjectTaskID] ,
                #Temp.[EmployeeID] ,
                #Temp.[Year] ,
                #Temp.[Month] ,
                #Temp.[Day] ,
                #Temp.[Description] ,
                ISNULL(#Temp.[Hour], 0) AS Hour ,
                ISNULL(#Temp.[LaborDay], 0) AS LaborDay ,
                #Temp.[DescriptionFin] ,
                ISNULL(#Temp.[HourFin], 0) AS HourFin ,
                ISNULL(#Temp.[LaborDayFin], 0) AS LaborDayFin ,
                #Temp.SortOrder ,
                DayOff = CASE WHEN dbo.DayOff.Date IS NULL THEN 0
                              ELSE 1
                         END ,
                LaborDayMade = ISNULL(( SELECT  ISNULL(SUM(ISNULL(LaborDay, 0)),
                                                       0)
                                        FROM    ProjectTaskMemberFinance
                                        WHERE   ProjectTaskMemberFinance.Day = #Temp.[Day]
                                                AND ProjectTaskMemberFinance.ProjectTaskID <> @ProjectTaskID
                                                AND ProjectTaskMemberFinance.EmployeeID = @EmployeeID
                                      ), 0) ,--Tổng số ngày đã chấm công của người này cho một công việc khác tại ngày #Temp.[Day]
                DescriptionMade = ISNULL(( SELECT TOP 1
                                                    N'Tham gia đề tài: '
                                                    + Project.ProjectName + N'; nội dung: ' + ProjectTask.Contents
                                           FROM     ProjectTaskMemberFinance
                                                    INNER JOIN dbo.Project ON ProjectTaskMemberFinance.ProjectID = dbo.Project.ProjectID
													left JOIN dbo.ProjectTask ON ProjectTaskMemberFinance.ProjectTaskID = ProjectTask.ProjectTaskID
                                           WHERE    ProjectTaskMemberFinance.Day = #Temp.[Day]
                                                    AND ProjectTaskMemberFinance.ProjectTaskID <> @ProjectTaskID
                                                    AND ProjectTaskMemberFinance.EmployeeID = @EmployeeID
                                         ), 0)
        FROM    #Temp
                LEFT JOIN dbo.DayOff ON #Temp.Day = DayOff.Date
        ORDER BY SortOrder
		-- Xóa bảng tạm
        DROP TABLE #Result
		-- Xóa bảng tạm
        DROP TABLE #Temp
    END




GO
/****** Object:  StoredProcedure [dbo].[Proc_GetListReportProjectTaskMemberFinanceByCompanyIDAndEmployeeIDAndProjectID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<dvthang>
-- Create date: <03.06.2018>
-- Description:	<Lấy về danh sách chấm công>
-- =============================================
--Proc_GetListReportProjectTaskMemberFinanceByCompanyIDAndEmployeeIDAndProjectID NULL,NULL,NULL,'2018/02/01','2018/02/28'
CREATE PROCEDURE [dbo].[Proc_GetListReportProjectTaskMemberFinanceByCompanyIDAndEmployeeIDAndProjectID]
    @CompanyID UNIQUEIDENTIFIER ,
    @EmployeeID UNIQUEIDENTIFIER ,
    @ProjectID UNIQUEIDENTIFIER ,
    @FromDate DATETIME ,
    @ToDate DATETIME
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

        DECLARE @Columns NVARCHAR(MAX)= '' ,
            @ColumnsAlias NVARCHAR(MAX)= '' ,
            @Totalday INT= 0 ,
            @Month INT= MONTH(@FromDate) ,
            @Year INT= YEAR(@FromDate) ,
            @TSQL NVARCHAR(MAX)= '';

        IF @Month IN ( 1, 3, 5, 7, 8, 10, 12 )
            SET @Totalday = 31
        ELSE
            IF @Month IN ( 2, 4, 6, 9, 11 )
                BEGIN
                    IF @Month = 2
                        BEGIN
                            IF ( ( @Year % 4 = 0
                                   AND @Year % 100 != 0
                                 )
                                 OR @Year % 400 = 0
                               )
                                SET @Totalday = 29
                            ELSE
                                SET @Totalday = 28
                        END
                    ELSE
                        BEGIN
                            SET @Totalday = 30
                        END
                END
        
        DECLARE @index INT= 1

        WHILE ( @index <= @Totalday )
            BEGIN
                SET @Columns = @Columns + '[' + CAST(@index AS NVARCHAR(5))
                    + '],';

                SET @ColumnsAlias = @ColumnsAlias + '['
                    + CAST(@index AS NVARCHAR(5)) + '] as T'
                    + CAST(@index AS NVARCHAR(5)) + ',';

                SET @index = @index + 1
            END


        SET @Columns = SUBSTRING(@Columns, 0, LEN(@Columns));
        SET @ColumnsAlias = SUBSTRING(@ColumnsAlias, 0, LEN(@ColumnsAlias));


        SELECT  E.EmployeeID ,
                E.FullName ,
                PM.LaborDay ,
                DAY(PM.Day) AS Day
        INTO    #Result
        FROM    dbo.ProjectTaskMemberFinance PM
                INNER JOIN dbo.Employee E ON E.EmployeeID = PM.EmployeeID
                INNER JOIN dbo.Project P ON P.ProjectID = PM.ProjectID
        WHERE   ( E.CompanyID = @CompanyID
                  OR @CompanyID IS NULL
                  OR @CompanyID = '00000000-0000-0000-0000-000000000000'
                )
                AND ( E.EmployeeID = @EmployeeID
                      OR @EmployeeID IS NULL
                      OR @EmployeeID = '00000000-0000-0000-0000-000000000000'
                    )
                AND ( P.ProjectID = @ProjectID
                      OR @ProjectID IS NULL
                      OR @ProjectID = '00000000-0000-0000-0000-000000000000'
                    )
                AND PM.Month = @Month
                AND PM.Year = @Year;
            
        SET @TSQL = 'SELECT EmployeeID,FullName,' + @ColumnsAlias
            + ' FROM (SELECT * FROM #Result) AS T'
            + ' PIVOT (SUM(LaborDay) FOR Day IN (' + @Columns
            + ') ) AS P ORDER BY FullName'
			
        EXEC(@TSQL)

        DROP TABLE #Result

    END




GO
/****** Object:  StoredProcedure [dbo].[Proc_GetListSalary_By_Year]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<laipv>
-- Create date: <26.05.2018>
-- Description:	<Hàm lấy về mức lương các tháng theo năm>
-- =============================================
--Chạy thử: Proc_GetListSalary_By_Year 2018
CREATE PROC [dbo].[Proc_GetListSalary_By_Year] @Year INT
AS
    BEGIN
		--Tạo bảng tạm chứa dữ liệu
        CREATE TABLE #Result
            (
              [SalaryID] [UNIQUEIDENTIFIER] NOT NULL ,
              [SalaryCode] [NVARCHAR](64) NOT NULL ,
              [SalaryName] [NVARCHAR](128) NOT NULL ,
              [Month] [INT] NULL ,
              [Year] [INT] NULL ,
              [Money] [INT] NULL ,
              [Inactive] [BIT] NULL ,
              [SortOrder] [INT] NULL
            )
		--Duyệt qua tất cả các tháng để đưa vào
        DECLARE @iIndex INT = 1
        WHILE @iIndex <= 12
            BEGIN
			--
                INSERT  INTO #Result
                        ( [SalaryID] ,
                          [SalaryCode] ,
                          [SalaryName] ,
                          [Month] ,
                          [Year] ,
                          [Money] ,
                          [Inactive] ,
                          [SortOrder] 
			            )
                VALUES  ( NEWID() ,
                          N'T' + CONVERT(NVARCHAR(64),@iIndex) ,
                          N'Tháng ' + CONVERT(NVARCHAR(128),@iIndex) ,
                          @iIndex ,
                          @Year ,
                          0 ,
                          0 ,
                          @iIndex
			            )
			--
                SET @iIndex = @iIndex + 1
            END
-- Lấy dữ liệu ra
        SELECT  ISNULL(S.SalaryID, T.SalaryID) AS SalaryID ,
                T.[SalaryCode] ,
                T.[SalaryName] ,
                T.[Month] ,
                T.[Year] ,
                S.[Money] ,
                T.[Inactive] ,
                T.[SortOrder]
        FROM    #Result T
                LEFT JOIN dbo.Salary AS S ON T.Month = S.Month
                                             AND T.Year = S.Year
											 ORDER BY T.Month
		-- Xóa bảng tạm
        DROP TABLE #Result
    END




GO
/****** Object:  StoredProcedure [dbo].[Proc_GetListTaskMemberByProjectTaskID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--region Proc_GetListEmployeeTask

------------------------------------------------------------------------------------------------------------------------
-- CreateBy:   manh 04.03.18
------------------------------------------------------------------------------------------------------------------------
CREATE PROC [dbo].[Proc_GetListTaskMemberByProjectTaskID]
    @ProjectTaskID UNIQUEIDENTIFIER
AS
    BEGIN
        SELECT  ROW_NUMBER() OVER ( ORDER BY e.SortOrder ASC ) AS Rownum ,
                e.FullName ,
                tm.StartDate ,
                tm.EndDate ,
                tm.MonthForTask
        FROM    dbo.ProjectTaskMember tm
                LEFT JOIN dbo.Employee e ON tm.EmployeeID = e.EmployeeID
        WHERE   tm.ProjectTaskID = @ProjectTaskID
    END




GO
/****** Object:  StoredProcedure [dbo].[Proc_GetListTimeCheck_By_CompanyID_EmployeeID_ProjectID_FromMonth_ToMonth_Year]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<laipv>
-- Create date: <30.05.2018>
-- Description:	<Hàm lấy về các ngày chấm công của cán bộ trong Viện>
-- =============================================
--Chạy thử: Proc_GetListTimeCheck_By_CompanyID_EmployeeID_ProjectID_FromMonth_ToMonth_Year '00000000-0000-0000-0000-000000000000','00000000-0000-0000-0000-000000000000','00000000-0000-0000-0000-000000000000',1,1,2018
CREATE PROC [dbo].[Proc_GetListTimeCheck_By_CompanyID_EmployeeID_ProjectID_FromMonth_ToMonth_Year]
	@CompanyID UNIQUEIDENTIFIER, -- Tất cả: 00000000-0000-0000-0000-000000000000
	@EmployeeID UNIQUEIDENTIFIER,-- Tất cả: 00000000-0000-0000-0000-000000000000
    @ProjectID UNIQUEIDENTIFIER,-- Tất cả: 00000000-0000-0000-0000-000000000000
	@FromMonth INT,
	@ToMonth INT,
	@Year int
AS
    BEGIN
		--Tạo bảng tạm chứa dữ liệu
        CREATE TABLE #Result
            (
              [CompanyID] [UNIQUEIDENTIFIER] NOT NULL ,
              [EmployeeID] [UNIQUEIDENTIFIER] NULL ,
              [ProjectID] [UNIQUEIDENTIFIER] NULL ,
              [Day] int ,
              [Month] INT,
              [Year] INT,
              [MonthForTaskLaborday] INT,  --Số ngày đã chấm công: Mầu xanh = 1; Mầu vàng = 2; Mầu trắng = 0
			  [DayOf] BIT --(DayOf = 1) Mầu đỏ: Ngày nghỉ
            )
        
		-- Lấy dữ liệu ra
        SELECT  *
        FROM    #Result
		-- Xóa bảng tạm
        DROP TABLE #Result
    END







GO
/****** Object:  StoredProcedure [dbo].[Proc_GetListWageCoefficient_By_GrantRatioID_Year]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<laipv>
-- Create date: <26.05.2018>
-- Description:	<Hàm lấy về các hệ số tiền theo vị trí trong đề tài>
-- =============================================
--Chạy thử: Proc_GetListWageCoefficient_By_GrantRatioID_Year 'ab912e7c-8714-49a6-86ec-3739cacb8211', 2018
CREATE PROC [dbo].[Proc_GetListWageCoefficient_By_GrantRatioID_Year]
    @GrantRatioID UNIQUEIDENTIFIER ,
    @Year INT
AS
    BEGIN
		--Tạo bảng tạm chứa dữ liệu
        CREATE TABLE #Result
            (
              [WageCoefficientID] [UNIQUEIDENTIFIER] NOT NULL ,
              [GrantRatioID] [UNIQUEIDENTIFIER] NULL ,
              [ProjectPositionID] [UNIQUEIDENTIFIER] NULL ,
              [ProjectPositionName] NVARCHAR(128) NULL ,
              [Month] [INT] NULL ,
              [Year] [INT] NULL ,
              [Coefficient] [DECIMAL](20, 4) NULL ,
              [Inactive] [BIT] NULL ,
              [SortOrder] [INT] NULL ,
              Edit [BIT] NULL --Trường cho phép có Edit được hay không
            )
		--Duyệt qua tất cả các ngày trong tháng để đưa nội dung vào
        DECLARE @iIndex INT = 1
        WHILE @iIndex <= 12
            BEGIN
			-- B1: Đưa dòng Tháng vào
                INSERT  #Result
                        ( WageCoefficientID ,
                          GrantRatioID ,
                          ProjectPositionID ,
                          ProjectPositionName ,
                          Month ,
                          Year ,
                          Coefficient ,
                          Inactive ,
                          SortOrder ,
                          Edit
			            )
                VALUES  ( NEWID() ,
                          @GrantRatioID ,
                          NEWID() ,
                          N'' ,
                          @iIndex ,
                          @Year ,
                          0 ,
                          1 ,
                          0 ,
                          0
			            )
                -- B2: Đưa các vị trí vào
                INSERT  #Result
                        ( WageCoefficientID ,
                          GrantRatioID ,
                          ProjectPositionID ,
                          ProjectPositionName ,
                          Month ,
                          Year ,
                          Coefficient ,
                          Inactive ,
                          SortOrder ,
                          Edit
			            )
                        SELECT  NEWID() ,
                                @GrantRatioID ,
                                PP.ProjectPositionID ,
                                PP.ProjectPositionName ,
                                @iIndex ,
                                @Year ,
                                0 ,
                                0 ,
                                PP.SortOrder ,
                                1
                        FROM    dbo.ProjectPosition AS PP
						ORDER BY PP.SortOrder
			-- Tăng chỉ số cộng
                SET @iIndex = @iIndex + 1
            END
		-- Lấy dữ liệu ra
        SELECT  ISNULL(WC.WageCoefficientID, T.WageCoefficientID) AS WageCoefficientID ,
                T.[GrantRatioID] ,
                T.[ProjectPositionID] ,
                T.[ProjectPositionName] ,
                T.[Month] ,
                T.[Year] ,
                ISNULL(WC.[Coefficient],0) AS Coefficient ,
                T.[Inactive] ,
                T.[SortOrder] ,
                T.[Edit]
        FROM    #Result T
                LEFT JOIN dbo.WageCoefficient AS WC ON WC.Month = T.Month
                                                       AND WC.Year = T.Year
                                                       AND WC.GrantRatioID = T.GrantRatioID AND WC.ProjectPositionID = T.ProjectPositionID
                                                       ORDER BY T.Year, T.Month, T.[SortOrder] 
		-- Xóa bảng tạm
        DROP TABLE #Result
    END




GO
/****** Object:  StoredProcedure [dbo].[Proc_GetProject_RP_Mau3]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Proc_GetProject_RP_Mau3]
AS
    BEGIN
	 -- Cap nha nuoc 
        SELECT  'I' AS TT ,
                IDENTITY ( INT, 1, 1 ) AS NEW_ID ,  [ProjectName],  
                [FullName] , [StartDate] , [EndDate] , Result, v3.MeetingDate  , v1.Status
        INTO    #tmp1
        FROM    [Project] v1
        INNER JOIN [Employee] v2 ON v2.[EmployeeID] = v1.[EmployeeID]
		Left  JOIN ProjectAcceptanceManage v3 on v3.ProjectID=v1.ProjectID		
        WHERE   v1.LevelID = 1
     -- Cap bo
      SELECT  'II' AS TT ,
                IDENTITY ( INT, 1, 1 ) AS NEW_ID ,  [ProjectName],  
                [FullName] , [StartDate] , [EndDate] , Result, v3.MeetingDate  , v1.Status
        INTO    #tmp2
        FROM    [Project] v1
        INNER JOIN [Employee] v2 ON v2.[EmployeeID] = v1.[EmployeeID]
		Left  JOIN ProjectAcceptanceManage v3 on v3.ProjectID=v1.ProjectID		
        WHERE   v1.LevelID = 2

        SELECT  *  INTO    #RP1
        FROM    ( SELECT    'I' AS TT ,  ' ' NEW_ID ,
                            N'CẤP NHÀ NƯỚC' [ProjectName] ,  ' ' [FullName] ,
                            ' ' [StartDate] ,  ' ' [EndDate] ,    ' ' Result, ' '  D1,  ' ' Status 
                  UNION
                  SELECT    *
                  FROM      #tmp1
                  UNION
                  SELECT    'II' ,
                            ' ' NEW_ID ,
                            N'CẤP BỘ QUỐC PHÒNG' ,
                            ' ' ,
                            ' ' ,
                            ' ' ,
                            ' ' Result, ' '  D1,  ' ' Status            
                  UNION
                  SELECT    *
                  FROM      #tmp2
                ) AS tt

        SELECT  TT + ( CASE WHEN NEW_ID > 0
                            THEN '.' + CAST(NEW_ID AS VARCHAR(10))
                            ELSE ''
                       END )  as STT ,
                [ProjectName] TenDT,  [FullName] ChuNhiemDT,
                [StartDate] NgayBatDau, [EndDate] NgayKetThuc,
                Result Sanpham, D1 NgayNghiemThu, Status TrangThai
        FROM    #RP1
        ORDER BY TT + '.' + CAST(NEW_ID AS VARCHAR(10))

    END




GO
/****** Object:  StoredProcedure [dbo].[Proc_GetProjectAssistants]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Proc_GetProjectFinishs '1=1'
CREATE PROC [dbo].[Proc_GetProjectAssistants]
@where NVARCHAR(MAX) 
AS
    BEGIN
	--Tính toán điều kiện lọc
	 IF ( @where <> '' ) 
            SET @where = 'where 1=1'-- + @where
			else SET @where = 'where 1=1'
	--Lấy cấp quản lý về
        SELECT  LevelID ,
                LevelName
        FROM    Level
        ORDER BY LevelID
    --Lấy đề tài về 

	 DECLARE @sql NVARCHAR(MAX)= ' SELECT *	FROM [dbo].View_Project '+@where+ ' ORDER BY  LevelID '
	 print @sql
     EXEC sp_executesql @sql	

    END





GO
/****** Object:  StoredProcedure [dbo].[Proc_GetProjectFinishs]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Proc_GetProjectFinishs '1=1'
CREATE PROC [dbo].[Proc_GetProjectFinishs]
@where NVARCHAR(MAX) 
AS
    BEGIN
	--Tính toán điều kiện lọc
	 IF ( @where <> '' ) 
            SET @where = 'where ' + @where
			else SET @where = 'where 1=1'
	--Lấy cấp quản lý về
        SELECT  LevelID ,
                LevelName
        FROM    Level
        ORDER BY LevelID
    --Lấy đề tài về 

	 DECLARE @sql NVARCHAR(MAX)= ' SELECT *	FROM [dbo].View_Project '+@where+ ' ORDER BY  LevelID '
     EXEC sp_executesql @sql	

    END





GO
/****** Object:  StoredProcedure [dbo].[Proc_GetProjectOffers]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Proc_GetProjectFinishs '1=1'
CREATE PROC [dbo].[Proc_GetProjectOffers]
@where NVARCHAR(MAX) 
AS
    BEGIN
	--Tính toán điều kiện lọc
	 IF ( @where <> '' ) 
            SET @where = 'where ' + @where
			else SET @where = 'where 1=1'
	--Lấy cấp quản lý về
        SELECT  LevelID ,
                LevelName
        FROM    Level
        ORDER BY LevelID
    --Lấy đề tài về 

	 DECLARE @sql NVARCHAR(MAX)= ' SELECT *	FROM [dbo].View_Project '+@where+ ' ORDER BY  LevelID '
	 print @sql
     EXEC sp_executesql @sql	

    END





GO
/****** Object:  StoredProcedure [dbo].[Proc_GetProjectsByLevelIdOrById]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<dvthang>
-- Create date: <01.04.2018>
-- Description:	<Lấy danh sách Task>
-- =============================================
CREATE PROCEDURE [dbo].[Proc_GetProjectsByLevelIdOrById]
    @LevelId INT ,
    @Id UNIQUEIDENTIFIER
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

        SELECT  ProjectID AS Id ,
                ProjectName AS Name ,
                StartDate ,
                EndDate ,
                CAST(0 AS DECIMAL) AS PercentDone
        FROM    dbo.Project
        WHERE   ( LevelID = @LevelId
                  OR @LevelId = -1
                )
                AND ( ProjectID = @Id
                      OR @Id IS NULL
                    )
        ORDER BY ProjectID
    END




GO
/****** Object:  StoredProcedure [dbo].[Proc_GetPrositionNameByProjectID_EmployeeID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<manh>
-- Create date: <28.05.18>
-- Description:	<Lấy chức danh nhân viên trong đề tài theo projectID>
-- Proc_GetPrositionNameByProjectID_EmployeeID 'c1644ef7-2bb9-4715-a3f8-3f21638d2c18', 'F32EBD6E-A9D2-4703-AAD2-1D83AC88B7C1'
-- =============================================
CREATE PROCEDURE [dbo].[Proc_GetPrositionNameByProjectID_EmployeeID]
	-- Add the parameters for the stored procedure here
    @ProjectID UNIQUEIDENTIFIER,
	@EmployeeID UNIQUEIDENTIFIER
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;
    -- Insert statements for procedure here
        SELECT  ProjectPositionName,FullName
        FROM    dbo.View_ProjectMember
        WHERE   ProjectID = @ProjectID
                AND EmployeeID = @EmployeeID
    END




GO
/****** Object:  StoredProcedure [dbo].[Proc_GetQADetailByTopic_Content]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Proc_GetQADetailByTopic_Content] @searchMode INT, @topicID INT, @content NVARCHAR(max), @groupID INT AS
BEGIN
IF @groupID = -1
	IF @searchMode = 0
	BEGIN
		SELECT * FROM dbo.QADetail
	END
	ELSE IF @searchMode = 1
	BEGIN
		SELECT * FROM dbo.QADetail WHERE QATopicID =@topicID 
	END
	ELSE IF @searchMode = 2
	BEGIN
		SELECT * FROM dbo.QADetail WHERE QuestionContent LIKE @content
	END
	ELSE
	BEGIN
		SELECT * FROM dbo.QADetail
	END
ELSE
BEGIN
	IF @searchMode = 0
	BEGIN
		SELECT * FROM dbo.QADetail WHERE PublicState = 0
	END
	ELSE IF @searchMode = 1
	BEGIN
		SELECT * FROM dbo.QADetail WHERE PublicState = 0 AND QATopicID =@topicID 
	END
	ELSE IF @searchMode = 2
	BEGIN
		SELECT * FROM dbo.QADetail WHERE PublicState = 0 AND QuestionContent LIKE @content
	END
	ELSE
	BEGIN
		SELECT * FROM dbo.QADetail WHERE PublicState = 0
	END
END
END
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetRptWasteWaterQualityDetail]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create proc [dbo].[Proc_GetRptWasteWaterQualityDetail]
	@CompanyID int,
	@MeasurementStandardID int
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

declare @C_CMax decimal(18,4);
declare @C_CMin decimal(18,4);
declare @MeasurementParameterID int;
SELECT
	[RptWasteWaterQualityDetailID],
	[dbo].RptWasteWaterQualityDetail.[RptWasteWaterQualityID],
	[ParameterID],
	[dbo].[MeasurementStandardParameter].[MeasurementParameterID],
	--dbo.CalculatedRptWasteWaterQuality(,C_Min,Kf,Kq) as 'C_CMin',
	--dbo.CalculatedRptWasteWaterQuality(,C_Max,Kf,Kq) as 'C_CMax',
	[MeasurementStandardParameterID],
	[dbo].[MeasurementStandardParameter].[MeasurementStandardID],
	CONCAT(ViName ,' (',UnitOfMeasure,')') as 'ViName',
	[BeforeProcessResult],
	[AfterProcessResult],
	[TextResult],
	[FinalResult]
FROM
	[dbo].[MeasurementStandardParameter] inner join [dbo].[MeasurementParameter] 
on [dbo].[MeasurementStandardParameter].MeasurementParameterID=[dbo].[MeasurementParameter].MeasurementParameterID
inner join [dbo].[MeasurementStandard] on [dbo].[MeasurementStandard].MeasurementStandardID=[dbo].[MeasurementStandardParameter].MeasurementStandardID 
and [dbo].[MeasurementStandard].MeasurementStandardID=@MeasurementStandardID
inner join [dbo].[RptWasteWaterQuality] on [dbo].[RptWasteWaterQuality].[AppliedStandardID]=[dbo].[MeasurementStandardParameter].[MeasurementStandardID]
left join [dbo].[RptWasteWaterQualityDetail] on [dbo].[RptWasteWaterQualityDetail].[RptWasteWaterQualityID]=[dbo].[RptWasteWaterQuality].RptWasteWaterQualityID
and  [dbo].[RptWasteWaterQualityDetail].ParameterID=[dbo].[MeasurementStandardParameter].MeasurementParameterID
where [dbo].[RptWasteWaterQuality].CompanyID=@CompanyID order by [RptWasteWaterQualityDetailID] desc


GO
/****** Object:  StoredProcedure [dbo].[Proc_GetTasksById]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<dvthang>
-- Create date: <01.04.2018>
-- Description:	<Lấy danh sách Task của project>
-- =============================================
CREATE PROCEDURE [dbo].[Proc_GetTasksById] @Id UNIQUEIDENTIFIER
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

        SELECT  ProjectTaskID AS Id ,
                Contents AS Name ,
				ParentID,
				ProjectID,
                StartDate ,
                EndDate ,
                CAST(0 AS DECIMAL) AS PercentDone ,
                Grade
        FROM    dbo.ProjectTask
        WHERE   ( ProjectID = @Id
                  OR @Id IS NULL
                )
        ORDER BY ProjectID ,
                Code
    END




GO
/****** Object:  StoredProcedure [dbo].[Proc_GetTimekeeping_By_ProjectIDAndProjectTaskIDAndEmployeeIDAndYearAndMonth]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<laipv>
-- Create date: <03.03.2017>
-- Description:	<Hàm lấy về các ngày làm việc trong tháng>
-- =============================================
--Chạy thử: Proc_GetTimekeeping_By_ProjectIDAndProjectTaskIDAndEmployeeIDAndYearAndMonth '5fd3894e-5e75-4ad6-9db3-77bd06ed29da', '7fe5b578-6f4a-4073-b866-b950c1d7124b', '8e543541-40fb-40ed-8d5b-8e42a73faad5', 2018, 5
CREATE PROC [dbo].[Proc_GetTimekeeping_By_ProjectIDAndProjectTaskIDAndEmployeeIDAndYearAndMonth]
    @ProjectID UNIQUEIDENTIFIER ,
    @ProjectTaskID UNIQUEIDENTIFIER ,
    @EmployeeID UNIQUEIDENTIFIER ,
    @Year INT ,
    @Month INT
AS
    BEGIN
	    --B1: Lấy các tham số trung gian
        CREATE TABLE #Header
            (
              [ProjectName] [NVARCHAR](255) NULL ,
              [Contents] [NVARCHAR](4000) NULL ,
              [FullName] [NVARCHAR](255) NULL ,
              [ProjectPositionName] [NVARCHAR](128) NULL ,
              [ProjectPositionName_TK] [NVARCHAR](128) NULL ,
              [ProjectPositionName_CN] [NVARCHAR](128) NULL
            )
			--
        DECLARE @ProjectName NVARCHAR(255)
        DECLARE @Contents NVARCHAR(4000)
        DECLARE @FullName NVARCHAR(255)
        DECLARE @ProjectPositionName NVARCHAR(128)
        DECLARE @ProjectPositionName_TK NVARCHAR(128)
        DECLARE @ProjectPositionName_CN NVARCHAR(128)
			--
        SELECT  @ProjectName = dbo.Project.ProjectName
        FROM    dbo.Project
        WHERE   ProjectID = @ProjectID
		--
        SELECT  @Contents = dbo.ProjectTask.Contents
        FROM    dbo.ProjectTask
        WHERE   ProjectTaskID = @ProjectTaskID
		--
        SELECT  @FullName = dbo.Employee.FullName
        FROM    dbo.Employee
        WHERE   EmployeeID = @EmployeeID
		--
        SELECT  @ProjectPositionName = dbo.ProjectPosition.ProjectPositionName
        FROM    dbo.Employee
                LEFT JOIN dbo.ProjectMember ON dbo.Employee.EmployeeID = dbo.ProjectMember.EmployeeID
				LEFT JOIN dbo.ProjectPosition ON dbo.ProjectMember.ProjectPositionID = dbo.ProjectPosition.ProjectPositionID
                INNER JOIN dbo.Project ON dbo.ProjectMember.ProjectID = dbo.Project.ProjectID
        WHERE   dbo.Project.ProjectID = @ProjectID
                AND dbo.ProjectMember.EmployeeID = @EmployeeID
		--
        SELECT  @ProjectPositionName_TK = dbo.Employee.FullName
        FROM    dbo.Employee
                LEFT JOIN dbo.ProjectMember ON dbo.Employee.EmployeeID = dbo.ProjectMember.EmployeeID
                INNER JOIN dbo.Project ON dbo.ProjectMember.ProjectID = dbo.Project.ProjectID
        WHERE   dbo.Project.ProjectID = @ProjectID
                AND dbo.ProjectMember.ProjectPositionID = '71a459eb-1b06-492a-915c-2565e692efb4'
		--
        SELECT  @ProjectPositionName_CN = dbo.Employee.FullName
        FROM    dbo.Employee
                LEFT JOIN dbo.ProjectMember ON dbo.Employee.EmployeeID = dbo.ProjectMember.EmployeeID
                INNER JOIN dbo.Project ON dbo.ProjectMember.ProjectID = dbo.Project.ProjectID
        WHERE   dbo.Project.ProjectID = @ProjectID
                AND dbo.ProjectMember.ProjectPositionID = '37309cee-1259-4498-b221-193532aff374'
		
        INSERT  #Header
                ( ProjectName ,
                  Contents ,
                  FullName ,
                  ProjectPositionName ,
                  ProjectPositionName_TK ,
                  ProjectPositionName_CN
		        )
        VALUES  ( @ProjectName ,
                  @Contents ,
                  @FullName ,
                  @ProjectPositionName ,
                  @ProjectPositionName_TK ,
                  @ProjectPositionName_CN
		        )
		--B1: Lấy các tham số giá trị
		--Tạo bảng tạm chứa dữ liệu
        CREATE TABLE #Result
            (
              [ProjectTaskMemberFinanceID] [UNIQUEIDENTIFIER] NULL ,
              [ProjectID] [UNIQUEIDENTIFIER] NULL ,
              [ProjectTaskID] [UNIQUEIDENTIFIER] NOT NULL ,
              [EmployeeID] [UNIQUEIDENTIFIER] NOT NULL ,
              [Year] [INT] NULL ,
              [Month] [INT] NULL ,
              [Day] [DATE] NULL ,
              [Description] [NVARCHAR](255) NULL ,
              [Hour] [NUMERIC](20, 4) NULL ,
              [LaborDay] [NUMERIC](20, 4) NULL ,
              [DescriptionFin] [NVARCHAR](255) NULL ,
              [HourFin] [NUMERIC](20, 4) NULL ,
              [LaborDayFin] [NUMERIC](20, 4) NULL ,
              [SortOrder] [INT] NULL
            )
		--Lấy số ngày của tháng theo (Year, Month)
        DECLARE @TotalDay INT
        SELECT  @TotalDay = dbo.Func_GetTotalDayInMonth(@Month, @Year)
		--Duyệt qua tất cả các ngày trong tháng để đưa nội dung vào
        DECLARE @iIndex INT = 1
        DECLARE @cDate DATE
        
        WHILE @iIndex <= @TotalDay
            BEGIN
			--
                SET @cDate = CONVERT(NVARCHAR(4), @Year) + '-'
                    + CONVERT(NVARCHAR(2), @Month) + '-'
                    + CONVERT(NVARCHAR(2), @iIndex)
			--
                INSERT  INTO #Result
                        ( [ProjectTaskMemberFinanceID] ,
                          [ProjectID] ,
                          [ProjectTaskID] ,
                          [EmployeeID] ,
                          [Year] ,
                          [Month] ,
                          [Day] ,
                          [Description] ,
                          [Hour] ,
                          [LaborDay] ,
                          [DescriptionFin] ,
                          [HourFin] ,
                          [LaborDayFin] ,
                          [SortOrder] 
			            )
                VALUES  ( NEWID() ,
                          @ProjectID ,
                          @ProjectTaskID ,
                          @EmployeeID ,
                          @Year ,
                          @Month ,
                          @cDate ,
                          N'' ,
                          0 ,
                          0 ,
                          N'' ,
                          0 ,
                          0 ,
                          @iIndex 
			            )
			--
                SET @iIndex = @iIndex + 1
            END
		-- Lấy dữ liệu ra
        SELECT  ISNULL(PT.ProjectTaskMemberFinanceID,
                       T.ProjectTaskMemberFinanceID) AS ProjectTaskMemberFinanceID ,
                T.[ProjectID] ,
                T.[ProjectTaskID] ,
                T.[EmployeeID] ,
                T.[Year] ,
                T.[Month] ,
                T.[Day] ,
                PT.[Description] ,
                PT.[Hour] ,
                PT.[LaborDay] ,
                PT.[DescriptionFin] ,
                PT.[HourFin] ,
                PT.[LaborDayFin] ,
                ISNULL(PT.[SortOrder], T.SortOrder) AS SortOrder
        INTO    #Temp
        FROM    #Result T
                LEFT JOIN ProjectTaskMemberFinance AS PT ON T.ProjectID = PT.ProjectID
                                                            AND PT.ProjectTaskID = T.ProjectTaskID
                                                            AND PT.EmployeeID = T.EmployeeID
                                                            AND PT.Month = T.Month
                                                            AND PT.Year = T.Year
                                                            AND T.Day = PT.Day
		-- Lấy dữ liệu ra
		--
        SELECT  *
        FROM    #Header
		--
        SELECT  #Temp.ProjectTaskMemberFinanceID ,
                #Temp.[ProjectID] ,
                #Temp.[ProjectTaskID] ,
                #Temp.[EmployeeID] ,
                #Temp.[Year] ,
                #Temp.[Month] ,
                #Temp.[Day] ,
                #Temp.[Description] ,
                ISNULL(#Temp.[Hour], 0) AS Hour ,
                ISNULL(#Temp.[LaborDay], 0) AS LaborDay ,
                #Temp.[DescriptionFin] ,
                ISNULL(#Temp.[HourFin], 0) AS HourFin ,
                ISNULL(#Temp.[LaborDayFin], 0) AS LaborDayFin ,
                #Temp.SortOrder
        FROM    #Temp
                LEFT JOIN dbo.DayOff ON #Temp.Day = DayOff.Date
        ORDER BY SortOrder
		-- Xóa bảng tạm
        DROP TABLE #Result
		-- Xóa bảng tạm
        DROP TABLE #Temp
        DROP TABLE #Header
    END




GO
/****** Object:  StoredProcedure [dbo].[Proc_GetTimekeeping_By_ProjectTaskIDAndEmployeeIDAndYearAndMonth]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<laipv>
-- Create date: <03.03.2017>
-- Description:	<Hàm lấy về các ngày làm việc trong tháng>
-- =============================================
--Chạy thử: Proc_GetTimekeeping_By_ProjectTaskIDAndEmployeeIDAndYearAndMonth '7fe5b578-6f4a-4073-b866-b950c1d7124b', '8e543541-40fb-40ed-8d5b-8e42a73faad5', 2018, 5
CREATE PROC [dbo].[Proc_GetTimekeeping_By_ProjectTaskIDAndEmployeeIDAndYearAndMonth]
    @ProjectTaskID UNIQUEIDENTIFIER ,
    @EmployeeID UNIQUEIDENTIFIER ,
    @Year INT ,
    @Month INT
AS
    BEGIN
	--
        DECLARE @ProjectID UNIQUEIDENTIFIER 
        SELECT  @ProjectID = dbo.ProjectTask.ProjectID
        FROM    dbo.ProjectTask
        WHERE   ProjectTaskID = @ProjectTaskID

	    		--
	--Bước 1: Lấy thông tin: Tên đề tài, chủ nhiệm, ...
        CREATE TABLE #Header
            (
              [ProjectName] [NVARCHAR](255) NULL ,
              [Contents] [NVARCHAR](4000) NULL ,
              [FullName] [NVARCHAR](255) NULL ,
              [ProjectPositionName] [NVARCHAR](128) NULL ,
              [ProjectPositionName_TK] [NVARCHAR](128) NULL ,
              [ProjectPositionName_CN] [NVARCHAR](128) NULL
            )
        DECLARE @ProjectName NVARCHAR(255)
        DECLARE @Contents NVARCHAR(4000)
        DECLARE @FullName NVARCHAR(255)
        DECLARE @ProjectPositionName NVARCHAR(128)
        DECLARE @ProjectPositionName_TK NVARCHAR(128)
        DECLARE @ProjectPositionName_CN NVARCHAR(128)
			--
        SELECT  @ProjectName = dbo.Project.ProjectName
        FROM    dbo.Project
        WHERE   ProjectID = @ProjectID
		--
        SELECT  @Contents = dbo.ProjectTask.Contents
        FROM    dbo.ProjectTask
        WHERE   ProjectTaskID = @ProjectTaskID
		--
        SELECT  @FullName = dbo.Employee.FullName
        FROM    dbo.Employee
        WHERE   EmployeeID = @EmployeeID
		--
        SELECT  @ProjectPositionName = dbo.ProjectPosition.ProjectPositionName
        FROM    dbo.Employee
                LEFT JOIN dbo.ProjectMember ON dbo.Employee.EmployeeID = dbo.ProjectMember.EmployeeID
                LEFT JOIN dbo.ProjectPosition ON dbo.ProjectMember.ProjectPositionID = dbo.ProjectPosition.ProjectPositionID
                INNER JOIN dbo.Project ON dbo.ProjectMember.ProjectID = dbo.Project.ProjectID
        WHERE   dbo.Project.ProjectID = @ProjectID
                AND dbo.ProjectMember.EmployeeID = @EmployeeID
		--
        SELECT  @ProjectPositionName_TK = dbo.Employee.FullName
        FROM    dbo.Employee
                LEFT JOIN dbo.ProjectMember ON dbo.Employee.EmployeeID = dbo.ProjectMember.EmployeeID
                INNER JOIN dbo.Project ON dbo.ProjectMember.ProjectID = dbo.Project.ProjectID
        WHERE   dbo.Project.ProjectID = @ProjectID
                AND dbo.ProjectMember.ProjectPositionID = '71a459eb-1b06-492a-915c-2565e692efb4'
		--
        SELECT  @ProjectPositionName_CN = dbo.Employee.FullName
        FROM    dbo.Employee
                LEFT JOIN dbo.ProjectMember ON dbo.Employee.EmployeeID = dbo.ProjectMember.EmployeeID
                INNER JOIN dbo.Project ON dbo.ProjectMember.ProjectID = dbo.Project.ProjectID
        WHERE   dbo.Project.ProjectID = @ProjectID
                AND dbo.ProjectMember.ProjectPositionID = '37309cee-1259-4498-b221-193532aff374'
		
        INSERT  #Header
                ( ProjectName ,
                  Contents ,
                  FullName ,
                  ProjectPositionName ,
                  ProjectPositionName_TK ,
                  ProjectPositionName_CN
		        )
        VALUES  ( @ProjectName ,
                  @Contents ,
                  @FullName ,
                  @ProjectPositionName ,
                  @ProjectPositionName_TK ,
                  @ProjectPositionName_CN
		        )
		--B1: Lấy các tham số giá trị
		--Tạo bảng tạm chứa dữ liệu
        CREATE TABLE #Result
            (
              [ProjectTaskMemberFinanceID] [UNIQUEIDENTIFIER] NULL ,
              [ProjectID] [UNIQUEIDENTIFIER] NULL ,
              [ProjectTaskID] [UNIQUEIDENTIFIER] NOT NULL ,
              [EmployeeID] [UNIQUEIDENTIFIER] NOT NULL ,
              [Year] [INT] NULL ,
              [Month] [INT] NULL ,
              [Day] [DATE] NULL ,
              [Description] [NVARCHAR](255) NULL ,
              [Hour] [NUMERIC](20, 4) NULL ,
              [LaborDay] [NUMERIC](20, 4) NULL ,
              [DescriptionFin] [NVARCHAR](255) NULL ,
              [HourFin] [NUMERIC](20, 4) NULL ,
              [LaborDayFin] [NUMERIC](20, 4) NULL ,
              [SortOrder] [INT] NULL
            )
		--Lấy số ngày của tháng theo (Year, Month)
        DECLARE @TotalDay INT
        SELECT  @TotalDay = dbo.Func_GetTotalDayInMonth(@Month, @Year)
		--Duyệt qua tất cả các ngày trong tháng để đưa nội dung vào
        DECLARE @iIndex INT = 1
        DECLARE @cDate DATE
        
        WHILE @iIndex <= @TotalDay
            BEGIN
			--
                SET @cDate = CONVERT(NVARCHAR(4), @Year) + '-'
                    + CONVERT(NVARCHAR(2), @Month) + '-'
                    + CONVERT(NVARCHAR(2), @iIndex)
			--
                INSERT  INTO #Result
                        ( [ProjectTaskMemberFinanceID] ,
                          [ProjectID] ,
                          [ProjectTaskID] ,
                          [EmployeeID] ,
                          [Year] ,
                          [Month] ,
                          [Day] ,
                          [Description] ,
                          [Hour] ,
                          [LaborDay] ,
                          [DescriptionFin] ,
                          [HourFin] ,
                          [LaborDayFin] ,
                          [SortOrder] 
			            )
                VALUES  ( NEWID() ,
                          @ProjectID ,
                          @ProjectTaskID ,
                          @EmployeeID ,
                          @Year ,
                          @Month ,
                          @cDate ,
                          N'' ,
                          0 ,
                          0 ,
                          N'' ,
                          0 ,
                          0 ,
                          @iIndex 
			            )
			--
                SET @iIndex = @iIndex + 1
            END
		-- Lấy dữ liệu ra
        SELECT  ISNULL(PT.ProjectTaskMemberFinanceID,
                       T.ProjectTaskMemberFinanceID) AS ProjectTaskMemberFinanceID ,
                T.[ProjectID] ,
                T.[ProjectTaskID] ,
                T.[EmployeeID] ,
                T.[Year] ,
                T.[Month] ,
                T.[Day] ,
                PT.[Description] ,
                PT.[Hour] ,
                PT.[LaborDay] ,
                PT.[DescriptionFin] ,
                PT.[HourFin] ,
                PT.[LaborDayFin] ,
                ISNULL(PT.[SortOrder], T.SortOrder) AS SortOrder
        INTO    #Temp
        FROM    #Result T
                LEFT JOIN ProjectTaskMemberFinance AS PT ON T.ProjectID = PT.ProjectID
                                                            AND T.ProjectTaskID = PT.ProjectTaskID
                                                            AND T.EmployeeID = PT.EmployeeID
                                                            AND T.Month = PT.Month
                                                            AND T.Year = PT.Year
                                                            AND T.Day = PT.Day
		-- Lấy dữ liệu ra
		--
        SELECT  *
        FROM    #Header
		--
        SELECT  #Temp.ProjectTaskMemberFinanceID ,
                #Temp.[ProjectID] ,
                #Temp.[ProjectTaskID] ,
                #Temp.[EmployeeID] ,
                #Temp.[Year] ,
                #Temp.[Month] ,
                #Temp.[Day] ,
                #Temp.[Description] ,
                ISNULL(#Temp.[Hour], 0) AS Hour ,
                ISNULL(#Temp.[LaborDay], 0) AS LaborDay ,
                #Temp.[DescriptionFin] ,
                ISNULL(#Temp.[HourFin], 0) AS HourFin ,
                ISNULL(#Temp.[LaborDayFin], 0) AS LaborDayFin ,
                #Temp.SortOrder
        FROM    #Temp
                LEFT JOIN dbo.DayOff ON #Temp.Day = DayOff.Date
        ORDER BY SortOrder
		-- Xóa bảng tạm
        DROP TABLE #Result
		-- Xóa bảng tạm
        DROP TABLE #Temp
        DROP TABLE #Header
    END




GO
/****** Object:  StoredProcedure [dbo].[Proc_GetTkByProjectID_PositionID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<manh>
-- Create date: <28.05.18>
-- Description:	<Lấy thư ký đề tài theo projectID>
-- Proc_GetTkByProjectID_PositionID 'c1644ef7-2bb9-4715-a3f8-3f21638d2c18'
-- =============================================
CREATE PROCEDURE [dbo].[Proc_GetTkByProjectID_PositionID]
	-- Add the parameters for the stored procedure here
    @ProjectID UNIQUEIDENTIFIER
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;
        DECLARE @projectPosition UNIQUEIDENTIFIER = '71A459EB-1B06-492A-915C-2565E692EFB4'
    -- Insert statements for procedure here
        SELECT  FullName
        FROM    dbo.View_ProjectMember
        WHERE   ProjectID = @ProjectID
                AND ProjectPositionID = @projectPosition
    END




GO
/****** Object:  StoredProcedure [dbo].[Proc_HiararchicalRP_Mau2_Chuanbi]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [dbo].[Proc_HiararchicalRP_Mau2_Chuanbi]
as 
Begin	

	WITH RPProjectTask ([IDX],[IDX_Parent], [Contents], STT, [StartDate], [EndDate], Result, Status)  AS 
	 (
	  Select 'DT', null, N'Đề tài', 'A', ' ', ' ', ' ', 0
	  Union
	  -- Tiêu đề: A, B
	  Select 'DTNN', 'DT',  CONVERT(nvarchar(255), N' Đề tài cấp NN' ), 'AA', ' ', ' ',  ' ', 0
	  Union All
	   Select 'DTBO', 'DT',   CONVERT(nvarchar(255), N' Đề tài cấp Bộ'),'AB',' ',' ', '',0
	  -- Tên Các đề tài NN, Bộ
	 Union All
	 Select  CONVERT(varchar(255),[ProjectID]), 'DTNN' , CONVERT(nvarchar(255), N' Đề tài cấp NN:'+ [ProjectName]),'AA',[StartDate],[EndDate], Result, Status
	 From [dbo].[Project] where LevelID=1
	 Union ALl
	 Select  CONVERT(varchar(255),[ProjectID]),'DTBO', CONVERT(nvarchar(255),N'Đề tài cấp Bộ: '+ [ProjectName]),'AB',[StartDate],[EndDate],  Result, Status
	 From [dbo].[Project] where LevelID=2
	 -- Lấy các nội dung của từng đề tài
	 Union all
	 SELECT CONVERT(varchar(255),e.[ProjectTaskID]), CONVERT(varchar(255),e.[ProjectID] )
		  ,CONVERT(nvarchar(255),'--'+rtrim([Contents]))
		  ,(Case 
		  When p.LevelID=1 Then 'AA'
		  When p.LevelID=2 Then 'AB' End), e.[StartDate], e.[EndDate],   e.Result, e.Status
		FROM [ProjectTask] AS e  
		Inner Join Project p on p.[ProjectID]=e.[ProjectID]
		where  (p.LevelID=1 OR P.LevelID=2) And (e.[ParentID]  IS NULL)
	 -- Lấy tất cả các nội dung con của từng nội dung
	 UNION ALL  
	 SELECT 
		CONVERT(varchar(255),e.[ProjectTaskID]), CONVERT(varchar(255),e.[ParentID])
		, CONVERT(nvarchar(255),  rtrim(e.[Contents]))
		,(Case 
		  When p.LevelID=1 Then 'AA'
		  When p.LevelID=2 Then 'AB' End), e.[StartDate], e.[EndDate],   e.Result, e.Status
		 FROM [ProjectTask] AS e
		JOIN RPProjectTask AS d ON CONVERT(varchar(255),e.[ParentID]) = d.IDX
		 Inner Join Project p on p.[ProjectID]=CONVERT(varchar(255),e.[ProjectID])
		 Where (p.LevelID=1 OR P.LevelID=2)
	 ) 	 
	Insert Into [ProjectTask_RP_Value] ( [IDX], [IDX_Parent],[Contents], [StartDate], [EndDate], Result, Status )
	 SELECT  [IDX], [IDX_Parent],[Contents], [StartDate], [EndDate], Result, Status   
	 FROM RPProjectTask  order by STT, [IDX_Parent],IDx
	-- Chuan bi dua ra cay
	Delete From dbo.[ProjectTask_RP_Children]
	INSERT [ProjectTask_RP_Children] (ChildID, ParentID, Num)  
	SELECT IDX, [IDX_Parent],  
	  ROW_NUMBER() OVER (PARTITION BY [IDX_Parent] ORDER BY [IDX_Parent], left(contents,10))   
	  FROM [ProjectTask_RP_Value]  

  
  --Delete From [ProjectTask_RP_Value]
  -- Delete From [ProjectTask_RP_Hierarchical]
End






GO
/****** Object:  StoredProcedure [dbo].[Proc_HiararchicalRP_Mau2_Chuanbi_Lai]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [dbo].[Proc_HiararchicalRP_Mau2_Chuanbi_Lai]
as 
Begin	

	WITH RPProjectTask ([IDX],[IDX_Parent], [Contents], STT, [StartDate], [EndDate], Result, Status)  AS 
	 (
	 -- Select 'DT', null, N'Đề tài', 'A', ' ', ' ', ' ', 0
	 -- Union
	 -- -- Tiêu đề: A, B
	 -- Select 'DTNN', 'DT',  CONVERT(nvarchar(255), N' Đề tài cấp NN' ), 'AA', ' ', ' ',  ' ', 0
	 -- Union All
	 --  Select 'DTBO', 'DT',   CONVERT(nvarchar(255), N' Đề tài cấp Bộ'),'AB',' ',' ', '',0
	 -- -- Tên Các đề tài NN, Bộ
	 --Union All
	 --Select  CONVERT(varchar(255),[ProjectID]), 'DTNN' , CONVERT(nvarchar(255), N' Đề tài cấp NN:'+ [ProjectName]),'AA',[StartDate],[EndDate], Result, Status
	 --From [dbo].[Project] where LevelID=1
	 --Union ALl
	 --Select  CONVERT(varchar(255),[ProjectID]),'DTBO', CONVERT(nvarchar(255),N'Đề tài cấp Bộ: '+ [ProjectName]),'AB',[StartDate],[EndDate],  Result, Status
	 --From [dbo].[Project] where LevelID=2
	 -- Lấy các nội dung của từng đề tài
	 -- Union all
	 SELECT CONVERT(varchar(255),e.[ProjectTaskID]), CONVERT(varchar(255),e.[ParentID] )
		  ,CONVERT(nvarchar(255),'--'+rtrim([Contents]))
		  ,N'', e.[StartDate], e.[EndDate],   e.Result, e.Status
		FROM [ProjectTask] AS e  
	 -- Lấy tất cả các nội dung con của từng nội dung
	 UNION ALL  
	 SELECT 
		CONVERT(varchar(255),e.[ProjectTaskID]), CONVERT(varchar(255),e.[ParentID])
		, CONVERT(nvarchar(255),  rtrim(e.[Contents]))
		,N'', e.[StartDate], e.[EndDate],   e.Result, e.Status
		 FROM [ProjectTask] AS e
		JOIN RPProjectTask AS d ON CONVERT(varchar(255),e.[ParentID]) = d.IDX
	 ) 	 
	 -- 
	 delete from [ProjectTask_RP_Value]
	 --
	Insert Into [ProjectTask_RP_Value] ( [IDX], [IDX_Parent],[Contents], [StartDate], [EndDate], Result, Status )
	 SELECT  [IDX], [IDX_Parent],[Contents], [StartDate], [EndDate], Result, Status   
	 FROM RPProjectTask  order by STT, [IDX_Parent],IDx
	-- Chuan bi dua ra cay
	Delete From dbo.[ProjectTask_RP_Children]
	INSERT [ProjectTask_RP_Children] (ChildID, ParentID, Num)  
	SELECT IDX, [IDX_Parent],  
	  ROW_NUMBER() OVER (PARTITION BY [IDX_Parent] ORDER BY [IDX_Parent], left(contents,10))   
	  FROM [ProjectTask_RP_Value]  

  
  --Delete From [ProjectTask_RP_Value]
  -- Delete From [ProjectTask_RP_Hierarchical]
End






GO
/****** Object:  StoredProcedure [dbo].[Proc_HiararchicalRP_Mau2_KQ]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc  [dbo].[Proc_HiararchicalRP_Mau2_KQ]
As
Begin
        
		Delete From [ProjectTask_RP_Value]
		Exec [Proc_HiararchicalRP_Mau2_Chuanbi]
		Delete From [ProjectTask_RP_Hierarchical]
		Exec   [Proc_HiararchicalRP_Mau2_Thuchien]
End





GO
/****** Object:  StoredProcedure [dbo].[Proc_HiararchicalRP_Mau2_Thuchien]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Proc  [dbo].[Proc_HiararchicalRP_Mau2_Thuchien]
as 
Begin
	WITH Hirar_paths ( Prjpath, ID)   
	  AS (  
		-- Get root
		SELECT hierarchyid::GetRoot() AS PrjNode, ChildID   
		FROM [ProjectTask_RP_Children] AS C  WHERE ParentID IS NULL  
		UNION ALL   
		-- get all nodes except the root  
		SELECT CAST(p.Prjpath.ToString() + CAST(C.Num AS varchar(30)) + '/' AS hierarchyid),   
			C.ChildID  
			FROM [ProjectTask_RP_Children] AS C   
			JOIN Hirar_paths AS p ON C.ParentID = P.ID   
	  )  
	 INSERT [ProjectTask_RP_Hierarchical] (PrjPath, ChildID, ParentID,[Contents], [StartDate], [EndDate],  Result, Status  )  
		SELECT P.Prjpath, O.[IDX], O.[IDX_Parent], O.[Contents], O.[StartDate], O.[EndDate], O.Result,  O.Status
		FROM [ProjectTask_RP_Value]  AS O   
		JOIN Hirar_paths AS P ON O.IDX = P.ID  
   
	SELECT PrjPath.ToString() AS Code, *   
	FROM [ProjectTask_RP_Hierarchical]   
	ORDER BY Code; 

 End



GO
/****** Object:  StoredProcedure [dbo].[Proc_HiararchicalRP_Mau2_Thuchien_Lai]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Proc  [dbo].[Proc_HiararchicalRP_Mau2_Thuchien_Lai]
as 
Begin
	WITH Hirar_paths ( Prjpath, ID)   
	  AS (  
		-- Get root
		SELECT hierarchyid::GetRoot() AS PrjNode, ChildID   
		FROM [ProjectTask_RP_Children] AS C  WHERE ParentID IS NULL  
		UNION ALL   
		-- get all nodes except the root  
		SELECT CAST(p.Prjpath.ToString() + CAST(C.Num AS varchar(30)) + '/' AS hierarchyid),   
			C.ChildID  
			FROM [ProjectTask_RP_Children] AS C   
			JOIN Hirar_paths AS p ON C.ParentID = P.ID   
	  )  
	 INSERT [ProjectTask_RP_Hierarchical] (PrjPath, ChildID, ParentID,[Contents], [StartDate], [EndDate],  Result, Status  )  
		SELECT P.Prjpath, O.[IDX], O.[IDX_Parent], O.[Contents], O.[StartDate], O.[EndDate], O.Result,  O.Status
		FROM [ProjectTask_RP_Value]  AS O   
		JOIN Hirar_paths AS P ON O.IDX = P.ID  
   
	SELECT PrjPath.ToString() AS Code, *   
	FROM [ProjectTask_RP_Hierarchical]   
	ORDER BY Code; 

 End



GO
/****** Object:  StoredProcedure [dbo].[Proc_HierarchicalProjectTask]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Proc_HierarchicalProjectTask]
AS
    BEGIN
        SELECT  LevelID ,
                LevelName
        FROM    Level
        ORDER BY LevelID

        SELECT  ProjectID ,
                ProjectName ,
                ProjectNameAbbreviation ,
                EmployeeName ,
                StartDate ,
                EndDate ,
                LevelID ,
                Result ,
                [Status],
				CreatedBy
        FROM    View_Project
        WHERE   [Status] >= 21
                AND [Status] <= 29
        ORDER BY LevelID

        SELECT  CAST(1 AS BIT) AS Expanded ,
                ProjectTask.Contents ,
                CAST(0 AS BIT) AS IconCls ,
                ProjectTask.Grade ,
                ProjectTask.Code ,
                ProjectTask.ProjectID ,
                ProjectTask.ParentID ,
                ProjectTask.ProjectTaskID ,
                ProjectTask.Result ,
                ProjectTask.Status
        FROM    ProjectTask
                INNER JOIN Project ON ProjectTask.ProjectID = Project.ProjectID
        WHERE   Project.Status >= 21
                AND Project.Status <= 29
        ORDER BY ProjectTask.Code
               

    END





GO
/****** Object:  StoredProcedure [dbo].[Proc_InsertAcademicRank]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_InsertAcademicRank]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   truong using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_InsertAcademicRank]
-- Date Generated: Saturday, January 13, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_InsertAcademicRank]
	@AcademicRankCode nvarchar(64),
	@AcademicRankName nvarchar(128),
	@AcademicRankShortName nvarchar(128),
	@Description nvarchar(255),
	@Inactive bit,
	@SortOrder int,
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@IPAddress nvarchar(128),
	@ModifiedBy nvarchar(128),
	@CreatedBy nvarchar(128),
	@AcademicRankID uniqueidentifier OUTPUT
AS

INSERT INTO [dbo].[AcademicRank] (
	[AcademicRankID],
	[AcademicRankCode],
	[AcademicRankName],
	[AcademicRankShortName],
	[Description],
	[Inactive],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
) VALUES (
	@AcademicRankID,
	@AcademicRankCode,
	@AcademicRankName,
	@AcademicRankShortName,
	@Description,
	@Inactive,
	@SortOrder,
	@CreatedDate,
	@ModifiedDate,
	@IPAddress,
	@ModifiedBy,
	@CreatedBy
)

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_InsertAspNetUsers]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Proc_InsertAspNetUsers]
	@Id NVARCHAR(128),
	@Email nvarchar(256),
	@EmailConfirmed bit,
	@PasswordHash nvarchar(max),
	@SecurityStamp nvarchar(max),
	@PhoneNumber nvarchar(max),
	@PhoneNumberConfirmed bit,
	@TwoFactorEnabled bit,
	@LockoutEndDateUtc datetime,
	@LockoutEnabled bit,
	@AccessFailedCount int,
	@UserName nvarchar(256),
	@GroupID int,
	@UserID int,
	@FullName nvarchar(50),
	@Address nvarchar(150),
	@ModifiedDate datetime,
	@CreatedDate datetime,
	@IPAddress nvarchar(128),
	@ModifiedBy nvarchar(128),
	@CreatedBy nvarchar(128),
	@oId INT
AS

INSERT INTO [dbo].[AspNetUsers] (
	Id,
	[Email],
	[EmailConfirmed],
	[PasswordHash],
	[SecurityStamp],
	[PhoneNumber],
	[PhoneNumberConfirmed],
	[TwoFactorEnabled],
	[LockoutEndDateUtc],
	[LockoutEnabled],
	[AccessFailedCount],
	[UserName],
	[GroupID],
	[UserID],
	[FullName],
	[Address],
	[ModifiedDate],
	[CreatedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy],
	[oId]
) VALUES (
	@Id,
	@Email,
	@EmailConfirmed,
	@PasswordHash,
	@SecurityStamp,
	@PhoneNumber,
	@PhoneNumberConfirmed,
	@TwoFactorEnabled,
	@LockoutEndDateUtc,
	@LockoutEnabled,
	@AccessFailedCount,
	@UserName,
	@GroupID,
	@UserID,
	@FullName,
	@Address,
	@ModifiedDate,
	@CreatedDate,
	@IPAddress,
	@ModifiedBy,
	@CreatedBy,
	@oId
)
--endregion


GO
/****** Object:  StoredProcedure [dbo].[Proc_InsertContentExperiment]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_InsertContentExperiment]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   Admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_InsertContentExperiment]
-- Date Generated: Sunday, February 25, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_InsertContentExperiment]
	@ProjectID uniqueidentifier,
	@ToDate datetime,
	@CompanyID uniqueidentifier,
	@AtCompany nvarchar(255),
	@Description nvarchar(500),
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@IPAddress nvarchar(128),
	@ModifiedBy nvarchar(128),
	@CreatedBy nvarchar(128),
	@ID uniqueidentifier OUTPUT
AS

INSERT INTO [dbo].[ContentExperiment] (
	[ID],
	[ProjectID],
	[ToDate],
	[CompanyID],
	[AtCompany],
	[Description],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
) VALUES (
	@ID,
	@ProjectID,
	@ToDate,
	@CompanyID,
	@AtCompany,
	@Description,
	@CreatedDate,
	@ModifiedDate,
	@IPAddress,
	@ModifiedBy,
	@CreatedBy
)

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_InsertContentServey]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_InsertContentServey]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   THANG using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_InsertContentServey]
-- Date Generated: Saturday, February 24, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_InsertContentServey]
	@CompanyID uniqueidentifier,
	@AtCompany nvarchar(255),
	@Description nvarchar(500),
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@IPAddress nvarchar(128),
	@ModifiedBy nvarchar(128),
	@CreatedBy nvarchar(128),
	@ID uniqueidentifier OUTPUT,
	@ToDate DATETIME,
	@ProjectID UNIQUEIDENTIFIER
AS

INSERT INTO [dbo].[ContentServey] (
	[ID],
	[CompanyID],
	[AtCompany],
	[Description],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy],
	ToDate,
	ProjectID
) VALUES (
	@ID,
	@CompanyID,
	@AtCompany,
	@Description,
	@CreatedDate,
	@ModifiedDate,
	@IPAddress,
	@ModifiedBy,
	@CreatedBy,
	@ToDate,
	@ProjectID
)

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_InsertCustomer]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Proc_InsertCustomer]
	@CustomerCode nvarchar(64),
	@CustomerName nvarchar(255),
	@CustomerGender int,
	@DOB datetime,
	@HealthCareNumber nvarchar(255),
	@Tel nvarchar(64),
	@Email nvarchar(255),
	@Address nvarchar(255),
	@CustomerGroup NVARCHAR(255),
	@CustomerDescription nvarchar(max),
	@PresenterName nvarchar(255),
	@PresenterPhone nvarchar(255),
	@PresenterAddress nvarchar(255),
	@PresenterIDC nvarchar(255),
	@Relationship nvarchar(255),
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@IPAddress nvarchar(128),
	@ModifiedBy nvarchar(128),
	@CreatedBy nvarchar(128),
	@CustomerID int OUTPUT
AS

INSERT INTO [dbo].[Customer] (
	[CustomerCode],
	[CustomerName],
	[CustomerGender],
	[DOB],
	[HealthCareNumber],
	[Tel],
	[Email],
	[Address],
	[CustomerGroup],
	[CustomerDescription],
	[PresenterName],
	[PresenterPhone],
	[PresenterAddress],
	[PresenterIDC],
	[Relationship],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
) VALUES (
	@CustomerCode,
	@CustomerName,
	@CustomerGender,
	@DOB,
	@HealthCareNumber,
	@Tel,
	@Email,
	@Address,
	@CustomerGroup,
	@CustomerDescription,
	@PresenterName,
	@PresenterPhone,
	@PresenterAddress,
	@PresenterIDC,
	@Relationship,
	@CreatedDate,
	@ModifiedDate,
	@IPAddress,
	@ModifiedBy,
	@CreatedBy
)

SET @CustomerID = SCOPE_IDENTITY()
SELECT @CustomerID

--endregion


GO
/****** Object:  StoredProcedure [dbo].[Proc_InsertDayOff]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_InsertDayOff]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   truong using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_InsertDayOff]
-- Date Generated: Saturday, March 3, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_InsertDayOff]
	@Date date,
	@Description nvarchar(255),
	@Inactive bit,
	@SortOrder int,
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@IPAddress nvarchar(128),
	@ModifiedBy nvarchar(128),
	@CreatedBy nvarchar(128),
	@DayOffID uniqueidentifier OUTPUT
AS

INSERT INTO [dbo].[DayOff] (
	[DayOffID],
	[Date],
	[Description],
	[Inactive],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
) VALUES (
	@DayOffID,
	@Date,
	@Description,
	@Inactive,
	@SortOrder,
	@CreatedDate,
	@ModifiedDate,
	@IPAddress,
	@ModifiedBy,
	@CreatedBy
)

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_InsertDegree]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_InsertDegree]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_InsertDegree]
-- Date Generated: 13 Tháng Giêng 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_InsertDegree]
	@DegreeCode nvarchar(64),
	@DegreeName nvarchar(128),
	@DegreeShortName nvarchar(128),
	@Description nvarchar(255),
	@Inactive bit,
	@SortOrder int,
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@IPAddress nvarchar(128),
	@ModifiedBy nvarchar(128),
	@CreatedBy nvarchar(128),
	@DegreeID uniqueidentifier OUTPUT
AS

INSERT INTO [dbo].[Degree] (
	[DegreeID],
	[DegreeCode],
	[DegreeName],
	[DegreeShortName],
	[Description],
	[Inactive],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
) VALUES (
	@DegreeID,
	@DegreeCode,
	@DegreeName,
	@DegreeShortName,
	@Description,
	@Inactive,
	@SortOrder,
	@CreatedDate,
	@ModifiedDate,
	@IPAddress,
	@ModifiedBy,
	@CreatedBy
)

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_InsertEmployee]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_InsertEmployee]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   manh using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_InsertEmployee]
-- Date Generated: Tuesday, May 29, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_InsertEmployee]
	@CompanyID uniqueidentifier,
	@EmployeeCode nvarchar(64),
	@FirstName nvarchar(128),
	@LastName nvarchar(128),
	@FullName nvarchar(255),
	@RankID uniqueidentifier,
	@Gender int,
	@AcademicRankID uniqueidentifier,
	@YearOfAcademicRank int,
	@DegreeID uniqueidentifier,
	@YearOfDegree int,
	@PositionID uniqueidentifier,
	@BirthDay datetime,
	@BirthPlace nvarchar(255),
	@HomeLand nvarchar(255),
	@NativeAddress nvarchar(255),
	@Tel nvarchar(64),
	@HomeTel nvarchar(64),
	@Mobile nvarchar(64),
	@Fax nvarchar(64),
	@Email nvarchar(64),
	@OfficeAddress nvarchar(255),
	@HomeAddress nvarchar(255),
	@Website nvarchar(64),
	@Description nvarchar(255),
	@FileResourceID nvarchar(255),
	@IDNumber nvarchar(20),
	@IssuedBy nvarchar(255),
	@DateBy date,
	@AccountNumber nvarchar(20),
	@Bank nvarchar(255),
	@Inactive bit,
	@SortOrder int,
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@IPAddress nvarchar(128),
	@ModifiedBy nvarchar(128),
	@CreatedBy nvarchar(128),
	@EmployeeID uniqueidentifier OUTPUT
AS

INSERT INTO [dbo].[Employee] (
	[EmployeeID],
	[CompanyID],
	[EmployeeCode],
	[FirstName],
	[LastName],
	[FullName],
	[RankID],
	[Gender],
	[AcademicRankID],
	[YearOfAcademicRank],
	[DegreeID],
	[YearOfDegree],
	[PositionID],
	[BirthDay],
	[BirthPlace],
	[HomeLand],
	[NativeAddress],
	[Tel],
	[HomeTel],
	[Mobile],
	[Fax],
	[Email],
	[OfficeAddress],
	[HomeAddress],
	[Website],
	[Description],
	[FileResourceID],
	[IDNumber],
	[IssuedBy],
	[DateBy],
	[AccountNumber],
	[Bank],
	[Inactive],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
) VALUES (
	@EmployeeID,
	@CompanyID,
	@EmployeeCode,
	@FirstName,
	@LastName,
	@FullName,
	@RankID,
	@Gender,
	@AcademicRankID,
	@YearOfAcademicRank,
	@DegreeID,
	@YearOfDegree,
	@PositionID,
	@BirthDay,
	@BirthPlace,
	@HomeLand,
	@NativeAddress,
	@Tel,
	@HomeTel,
	@Mobile,
	@Fax,
	@Email,
	@OfficeAddress,
	@HomeAddress,
	@Website,
	@Description,
	@FileResourceID,
	@IDNumber,
	@IssuedBy,
	@DateBy,
	@AccountNumber,
	@Bank,
	@Inactive,
	@SortOrder,
	@CreatedDate,
	@ModifiedDate,
	@IPAddress,
	@ModifiedBy,
	@CreatedBy
)

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_InsertGrantRatio]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_InsertGrantRatio]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   truong using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_InsertGrantRatio]
-- Date Generated: Wednesday, May 23, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_InsertGrantRatio]
	@GrantRatioCode nvarchar(64),
	@GrantRatioName nvarchar(128),
	@Description nvarchar(255),
	@Inactive bit,
	@SortOrder int,
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@IPAddress nvarchar(128),
	@ModifiedBy nvarchar(128),
	@CreatedBy nvarchar(128),
	@GrantRatioID uniqueidentifier OUTPUT
AS

INSERT INTO [dbo].[GrantRatio] (
	[GrantRatioID],
	[GrantRatioCode],
	[GrantRatioName],
	[Description],
	[Inactive],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
) VALUES (
	@GrantRatioID,
	@GrantRatioCode,
	@GrantRatioName,
	@Description,
	@Inactive,
	@SortOrder,
	@CreatedDate,
	@ModifiedDate,
	@IPAddress,
	@ModifiedBy,
	@CreatedBy
)

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_InsertLevel]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_InsertLevel]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   Phamlai using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_InsertLevel]
-- Date Generated: Saturday, January 13, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_InsertLevel]
	@LevelID int,
	@LevelCode nvarchar(64),
	@LevelName nvarchar(128),
	@Description nvarchar(255),
	@Inactive bit,
	@SortOrder int,
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@IPAddress nvarchar(128),
	@ModifiedBy nvarchar(128),
	@CreatedBy nvarchar(128)
AS

INSERT INTO [dbo].[Level] (
	[LevelID],
	[LevelCode],
	[LevelName],
	[Description],
	[Inactive],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
) VALUES (
	@LevelID,
	@LevelCode,
	@LevelName,
	@Description,
	@Inactive,
	@SortOrder,
	@CreatedDate,
	@ModifiedDate,
	@IPAddress,
	@ModifiedBy,
	@CreatedBy
)

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_InsertMeasurementParameterGroup]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Proc_InsertMeasurementParameterGroup]
	@MeasurementParameterGroupCode nvarchar(64),
	@MeasurementParameterGroupName nvarchar(128),
	@Description nvarchar(255),
	@Inactive bit,
	@SortOrder int,
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@IPAddress nvarchar(128),
	@ModifiedBy nvarchar(128),
	@CreatedBy nvarchar(128),
	@MeasurementParameterGroupID int OUTPUT
AS

INSERT INTO [dbo].[MeasurementParameterGroup] (
	[MeasurementParameterGroupCode],
	[MeasurementParameterGroupName],
	[Description],
	[Inactive],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
) VALUES (
	@MeasurementParameterGroupCode,
	@MeasurementParameterGroupName,
	@Description,
	@Inactive,
	@SortOrder,
	@CreatedDate,
	@ModifiedDate,
	@IPAddress,
	@ModifiedBy,
	@CreatedBy
)

SET @MeasurementParameterGroupID = SCOPE_IDENTITY()
SELECT @MeasurementParameterGroupID

--endregion



GO
/****** Object:  StoredProcedure [dbo].[Proc_InsertMedicalRecord]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Proc_InsertMedicalRecord]
	@CustomerID int,
	@AppliedStandardID int,
	@MedicalRecordDescription nvarchar(255),
	@MedicalRecordLocation nvarchar(255),
	@MedicalRecordDate datetime,
	@FinalResult nvarchar(255),
	@CreatedBy nvarchar(128),
	@ModifiedBy nvarchar(128),
	@IPAddress nvarchar(128),
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@MedicalRecordID int OUTPUT
AS

INSERT INTO [dbo].[MedicalRecord] (
	[CustomerID],
	[AppliedStandardID],
	[MedicalRecordDescription],
	[MedicalRecordLocation],
	[MedicalRecordDate],
	[FinalResult],
	[CreatedBy],
	[ModifiedBy],
	[IPAddress],
	[CreatedDate],
	[ModifiedDate]
) VALUES (
	@CustomerID,
	@AppliedStandardID,
	@MedicalRecordDescription,
	@MedicalRecordLocation,
	@MedicalRecordDate,
	@FinalResult,
	@CreatedBy,
	@ModifiedBy,
	@IPAddress,
	@CreatedDate,
	@ModifiedDate
)

SET @MedicalRecordID = SCOPE_IDENTITY()
SELECT @MedicalRecordID

--endregion


GO
/****** Object:  StoredProcedure [dbo].[Proc_InsertPosition]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_InsertPosition]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   manh using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_InsertPosition]
-- Date Generated: Thursday, July 19, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_InsertPosition]
	@PositionCode nvarchar(64),
	@PositionName nvarchar(128),
	@Description nvarchar(255),
	@Inactive bit,
	@SortOrder int,
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@IPAddress nvarchar(128),
	@ModifiedBy nvarchar(128),
	@CreatedBy nvarchar(128),
	@PositionID uniqueidentifier OUTPUT
AS

INSERT INTO [dbo].[Position] (
	[PositionID],
	[PositionCode],
	[PositionName],
	[Description],
	[Inactive],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
) VALUES (
	@PositionID,
	@PositionCode,
	@PositionName,
	@Description,
	@Inactive,
	@SortOrder,
	@CreatedDate,
	@ModifiedDate,
	@IPAddress,
	@ModifiedBy,
	@CreatedBy
)

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_InsertProject]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_InsertProject]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   THANG using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_InsertProject]
-- Date Generated: Sunday, January 28, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_InsertProject]
    @ProjectCode NVARCHAR(64) ,
    @ProjectName NVARCHAR(255) ,
    @ProjectNameAbbreviation NVARCHAR(255) ,
    @StartDate DATETIME ,
    @EndDate DATETIME ,
    @CompanyID UNIQUEIDENTIFIER ,
    @EmployeeID UNIQUEIDENTIFIER ,
    @Amount NUMERIC(20, 4) ,
    @Amount_Level1 NUMERIC(20, 4) ,
    @Amount_Level2 NUMERIC(20, 4) ,
    @Amount_Other NUMERIC(20, 4) ,
    @Program BIT ,
    @ProgramName NVARCHAR(255) ,
    @ProjectScience BIT ,
    @ProjectScienceName NVARCHAR(255) ,
    @IndependentTopic BIT ,
    @Nature BIT ,
    @AFF BIT ,
    @Technical BIT ,
    @Pharmacy BIT ,
    @Result NVARCHAR(255) ,
    @CompanyApply NVARCHAR(255) ,
    @Description NVARCHAR(255) ,
    @Status INT ,
    @LevelID INT ,
    @ProjectChairman UNIQUEIDENTIFIER ,
    @ProjectSecretary UNIQUEIDENTIFIER ,
    @ProjectCompanyChair UNIQUEIDENTIFIER ,
    @ProjectMember UNIQUEIDENTIFIER ,
    @ProjectCompanyCombination UNIQUEIDENTIFIER ,
    @Inactive BIT ,
    @SortOrder INT ,
    @CreatedDate DATETIME ,
    @ModifiedDate DATETIME ,
    @IPAddress NVARCHAR(128) ,
    @ModifiedBy NVARCHAR(128) ,
    @CreatedBy NVARCHAR(128) ,
    @GrantRatioID UNIQUEIDENTIFIER ,
    @MonthFin INT ,
    @YearFin INT ,
    @ProjectID UNIQUEIDENTIFIER OUTPUT
AS
    INSERT  INTO [dbo].[Project]
            ( [ProjectID] ,
              [ProjectCode] ,
              [ProjectName] ,
              [ProjectNameAbbreviation] ,
              [StartDate] ,
              [EndDate] ,
              [CompanyID] ,
              [EmployeeID] ,
              [Amount] ,
              [Amount_Level1] ,
              [Amount_Level2] ,
              [Amount_Other] ,
              [Program] ,
              [ProgramName] ,
              [ProjectScience] ,
              [ProjectScienceName] ,
              [IndependentTopic] ,
              [Nature] ,
              [AFF] ,
              [Technical] ,
              [Pharmacy] ,
              [Result] ,
              [CompanyApply] ,
              [Description] ,
              [Status] ,
              [LevelID] ,
              [ProjectChairman] ,
              [ProjectSecretary] ,
              [ProjectCompanyChair] ,
              [ProjectMember] ,
              [ProjectCompanyCombination] ,
              [Inactive] ,
              [SortOrder] ,
              [CreatedDate] ,
              [ModifiedDate] ,
              [IPAddress] ,
              [ModifiedBy] ,
              [CreatedBy] ,
              [GrantRatioID] ,
              [MonthFin] ,
              [YearFin]
            )
    VALUES  ( @ProjectID ,
              @ProjectCode ,
              @ProjectName ,
              @ProjectNameAbbreviation ,
              @StartDate ,
              @EndDate ,
              @CompanyID ,
              @EmployeeID ,
              @Amount ,
              @Amount_Level1 ,
              @Amount_Level2 ,
              @Amount_Other ,
              @Program ,
              @ProgramName ,
              @ProjectScience ,
              @ProjectScienceName ,
              @IndependentTopic ,
              @Nature ,
              @AFF ,
              @Technical ,
              @Pharmacy ,
              @Result ,
              @CompanyApply ,
              @Description ,
              @Status ,
              @LevelID ,
              @ProjectChairman ,
              @ProjectSecretary ,
              @ProjectCompanyChair ,
              @ProjectMember ,
              @ProjectCompanyCombination ,
              @Inactive ,
              @SortOrder ,
              @CreatedDate ,
              @ModifiedDate ,
              @IPAddress ,
              @ModifiedBy ,
              @CreatedBy ,
              @GrantRatioID ,
              @MonthFin ,
              @YearFin
            )

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_InsertProject_AttachDetail]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_InsertProject_AttachDetail]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   THANG using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_InsertProject_AttachDetail]
-- Date Generated: Sunday, February 4, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_InsertProject_AttachDetail]
	@ProjectID uniqueidentifier,
	@Description nvarchar(255),
	@FileName nvarchar(100),
	@FileType nvarchar(64),
	@FileSize float,
	@SortOrder int,
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@IPAddress nvarchar(128),
	@ModifiedBy nvarchar(128),
	@CreatedBy nvarchar(128),
	@Project_AttachDetailID uniqueidentifier OUTPUT
AS

INSERT INTO [dbo].[Project_AttachDetail] (
	[Project_AttachDetailID],
	[ProjectID],
	[Description],
	[FileName],
	[FileType],
	[FileSize],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
) VALUES (
	@Project_AttachDetailID,
	@ProjectID,
	@Description,
	@FileName,
	@FileType,
	@FileSize,
	@SortOrder,
	@CreatedDate,
	@ModifiedDate,
	@IPAddress,
	@ModifiedBy,
	@CreatedBy
)

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_InsertProjectAcceptanceBasic]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_InsertProjectAcceptanceBasic]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_InsertProjectAcceptanceBasic]
-- Date Generated: 23 Tháng Hai 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_InsertProjectAcceptanceBasic]
	@ProjectID uniqueidentifier,
	@EstablishedDate date,
	@MeetingDate date,
	@Status int,
	@Inactive bit,
	@SortOrder int,
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@IPAddress nvarchar(128),
	@ModifiedBy nvarchar(128),
	@CreatedBy nvarchar(128),
	@ProjectAcceptanceBasicID uniqueidentifier OUTPUT
AS

INSERT INTO [dbo].[ProjectAcceptanceBasic] (
	[ProjectAcceptanceBasicID],
	[ProjectID],
	[EstablishedDate],
	[MeetingDate],
	[Status],
	[Inactive],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
) VALUES (
	@ProjectAcceptanceBasicID,
	@ProjectID,
	@EstablishedDate,
	@MeetingDate,
	@Status,
	@Inactive,
	@SortOrder,
	@CreatedDate,
	@ModifiedDate,
	@IPAddress,
	@ModifiedBy,
	@CreatedBy
)

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_InsertProjectAcceptanceBasic_AttachDetail]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_InsertProjectAcceptanceBasic_AttachDetail]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_InsertProjectAcceptanceBasic_AttachDetail]
-- Date Generated: 05 Tháng Hai 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_InsertProjectAcceptanceBasic_AttachDetail]
	@ProjectAcceptanceBasicID uniqueidentifier,
	@Contents nvarchar(255),
	@FileName nvarchar(255),
	@FileType nvarchar(64),
	@FileSize float,
	@Inactive bit,
	@SortOrder int,
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@IPAddress nvarchar(128),
	@ModifiedBy nvarchar(128),
	@CreatedBy nvarchar(128),
	@ProjectAcceptanceBasic_AttachDetailID uniqueidentifier OUTPUT
AS

INSERT INTO [dbo].[ProjectAcceptanceBasic_AttachDetail] (
	[ProjectAcceptanceBasic_AttachDetailID],
	[ProjectAcceptanceBasicID],
	[Contents],
	[FileName],
	[FileType],
	[FileSize],
	[Inactive],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
) VALUES (
	@ProjectAcceptanceBasic_AttachDetailID,
	@ProjectAcceptanceBasicID,
	@Contents,
	@FileName,
	@FileType,
	@FileSize,
	@Inactive,
	@SortOrder,
	@CreatedDate,
	@ModifiedDate,
	@IPAddress,
	@ModifiedBy,
	@CreatedBy
)

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_InsertProjectAcceptanceManage]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_InsertProjectAcceptanceManage]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_InsertProjectAcceptanceManage]
-- Date Generated: 23 Tháng Hai 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_InsertProjectAcceptanceManage]
	@ProjectID uniqueidentifier,
	@EstablishedDate date,
	@MeetingDate date,
	@Status int,
	@Inactive bit,
	@SortOrder int,
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@IPAddress nvarchar(128),
	@ModifiedBy nvarchar(128),
	@CreatedBy nvarchar(128),
	@ProjectAcceptanceManageID uniqueidentifier OUTPUT
AS

INSERT INTO [dbo].[ProjectAcceptanceManage] (
	[ProjectAcceptanceManageID],
	[ProjectID],
	[EstablishedDate],
	[MeetingDate],
	[Status],
	[Inactive],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
) VALUES (
	@ProjectAcceptanceManageID,
	@ProjectID,
	@EstablishedDate,
	@MeetingDate,
	@Status,
	@Inactive,
	@SortOrder,
	@CreatedDate,
	@ModifiedDate,
	@IPAddress,
	@ModifiedBy,
	@CreatedBy
)

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_InsertProjectAcceptanceManage_AttachDetail]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_InsertProjectAcceptanceManage_AttachDetail]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_InsertProjectAcceptanceManage_AttachDetail]
-- Date Generated: 09 Tháng Hai 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_InsertProjectAcceptanceManage_AttachDetail]
	@ProjectAcceptanceManageID uniqueidentifier,
	@Contents nvarchar(255),
	@FileName nvarchar(255),
	@FileType nvarchar(64),
	@FileSize float,
	@Inactive bit,
	@SortOrder int,
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@IPAddress nvarchar(128),
	@ModifiedBy nvarchar(128),
	@CreatedBy nvarchar(128),
	@ProjectAcceptanceManage_AttachDetailID uniqueidentifier OUTPUT
AS

INSERT INTO [dbo].[ProjectAcceptanceManage_AttachDetail] (
	[ProjectAcceptanceManage_AttachDetailID],
	[ProjectAcceptanceManageID],
	[Contents],
	[FileName],
	[FileType],
	[FileSize],
	[Inactive],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
) VALUES (
	@ProjectAcceptanceManage_AttachDetailID,
	@ProjectAcceptanceManageID,
	@Contents,
	@FileName,
	@FileType,
	@FileSize,
	@Inactive,
	@SortOrder,
	@CreatedDate,
	@ModifiedDate,
	@IPAddress,
	@ModifiedBy,
	@CreatedBy
)

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_InsertProjectClose]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_InsertProjectClose]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_InsertProjectClose]
-- Date Generated: 23 Tháng Hai 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_InsertProjectClose]
	@ProjectID uniqueidentifier,
	@Date date,
	@LiquidationDate date,
	@FileName nvarchar(255),
	@FileType nvarchar(64),
	@FileSize float,
	@Inactive bit,
	@SortOrder int,
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@IPAddress nvarchar(128),
	@ModifiedBy nvarchar(128),
	@CreatedBy nvarchar(128),
	@ProjectCloseID uniqueidentifier OUTPUT
AS

INSERT INTO [dbo].[ProjectClose] (
	[ProjectCloseID],
	[ProjectID],
	[Date],
	[LiquidationDate],
	[FileName],
	[FileType],
	[FileSize],
	[Inactive],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
) VALUES (
	@ProjectCloseID,
	@ProjectID,
	@Date,
	@LiquidationDate,
	@FileName,
	@FileType,
	@FileSize,
	@Inactive,
	@SortOrder,
	@CreatedDate,
	@ModifiedDate,
	@IPAddress,
	@ModifiedBy,
	@CreatedBy
)

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_InsertProjectExperiment]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_InsertProjectExperiment]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   Manh using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_InsertProjectExperiment]
-- Date Generated: Sunday, February 25, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_InsertProjectExperiment]
	@ProjectID uniqueidentifier,
	@FileName nvarchar(255),
	@FileType nvarchar(64),
	@FileSize float,
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@IPAddress nvarchar(128),
	@ModifiedBy nvarchar(128),
	@CreatedBy nvarchar(128),
	@ProjectExperimentID uniqueidentifier OUTPUT
AS

INSERT INTO [dbo].[ProjectExperiment] (
	[ProjectExperimentID],
	[ProjectID],
	[FileName],
	[FileType],
	[FileSize],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
) VALUES (
	@ProjectExperimentID,
	@ProjectID,
	@FileName,
	@FileType,
	@FileSize,
	@CreatedDate,
	@ModifiedDate,
	@IPAddress,
	@ModifiedBy,
	@CreatedBy
)

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_InsertProjectExperiment_AttachDetail]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_InsertProjectExperiment_AttachDetail]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   Manh using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_InsertProjectExperiment_AttachDetail]
-- Date Generated: Sunday, February 25, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_InsertProjectExperiment_AttachDetail]
    @ID UNIQUEIDENTIFIER ,
    @FileName NVARCHAR(255) ,
    @FileType NVARCHAR(64) ,
    @FileSize FLOAT ,
    @Description NVARCHAR(255) ,
    @SortOrder INT ,
    @CreatedDate DATETIME ,
    @ModifiedDate DATETIME ,
    @IPAddress NVARCHAR(128) ,
    @ModifiedBy NVARCHAR(128) ,
    @CreatedBy NVARCHAR(128) ,
    @ProjectExperiment_AttachDetailID UNIQUEIDENTIFIER OUTPUT
AS
    BEGIN
        INSERT  INTO [dbo].[ProjectExperiment_AttachDetail]
                ( [ProjectExperiment_AttachDetailID] ,
                  [ID] ,
                  [FileName] ,
                  [FileType] ,
                  [FileSize] ,
                  [Description] ,
                  [SortOrder] ,
                  [CreatedDate] ,
                  [ModifiedDate] ,
                  [IPAddress] ,
                  [ModifiedBy] ,
                  [CreatedBy]
                )
        VALUES  ( @ProjectExperiment_AttachDetailID ,
                  @ID ,
                  @FileName ,
                  @FileType ,
                  @FileSize ,
                  @Description ,
                  @SortOrder ,
                  @CreatedDate ,
                  @ModifiedDate ,
                  @IPAddress ,
                  @ModifiedBy ,
                  @CreatedBy
                )

        UPDATE  dbo.ContentExperiment
        SET     IdFiles = dbo.Func_GroupFileContenExperimentIntoMaster(@ID)
        WHERE   ID = @ID
    END
--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_InsertProjectMember]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_InsertProjectMember]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   truong using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_InsertProjectMember]
-- Date Generated: Sunday, January 28, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_InsertProjectMember]
	@ProjectID uniqueidentifier,
	@EmployeeID uniqueidentifier,
	@FullName nvarchar(255),
	@StartDate date,
	@EndDate date,
	@MonthForProject numeric(20, 4),
	@ProjectPositionID uniqueidentifier,
	@Inactive bit,
	@SortOrder int,
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@IPAddress nvarchar(128),
	@ModifiedBy nvarchar(128),
	@CreatedBy nvarchar(128),
	@ProjectMemberID uniqueidentifier OUTPUT
AS
--IF NOT EXISTS (SELECT 1 FROM [dbo].[ProjectMember] WHERE EmployeeID = @EmployeeID) -- truongnm 03.03.2018
BEGIN
INSERT INTO [dbo].[ProjectMember] (
	[ProjectMemberID],
	[ProjectID],
	[EmployeeID],
	[FullName],
	[StartDate],
	[EndDate],
	[MonthForProject],
	[ProjectPositionID],
	[Inactive],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
) VALUES (
	@ProjectMemberID,
	@ProjectID,
	@EmployeeID,
	@FullName,
	@StartDate,
	@EndDate,
	@MonthForProject,
	@ProjectPositionID,
	@Inactive,
	@SortOrder,
	@CreatedDate,
	@ModifiedDate,
	@IPAddress,
	@ModifiedBy,
	@CreatedBy
)
END
--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_InsertProjectPlanExpense]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_InsertProjectPlanExpense]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   truong using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_InsertProjectPlanExpense]
-- Date Generated: Sunday, January 28, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_InsertProjectPlanExpense]
	@ProjectID uniqueidentifier,
	@Number nvarchar(64),
	@Date date,
	@Amount numeric(20, 4),
	@Inactive bit,
	@SortOrder int,
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@IPAddress nvarchar(128),
	@ModifiedBy nvarchar(128),
	@CreatedBy nvarchar(128),
	@ProjectPlanExpenseID uniqueidentifier OUTPUT
AS

INSERT INTO [dbo].[ProjectPlanExpense] (
	[ProjectPlanExpenseID],
	[ProjectID],
	[Number],
	[Date],
	[Amount],
	[Inactive],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
) VALUES (
	@ProjectPlanExpenseID,
	@ProjectID,
	@Number,
	@Date,
	@Amount,
	@Inactive,
	@SortOrder,
	@CreatedDate,
	@ModifiedDate,
	@IPAddress,
	@ModifiedBy,
	@CreatedBy
)

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_InsertProjectPlanExpense_AttachDetail]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_InsertProjectPlanExpense_AttachDetail]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_InsertProjectPlanExpense_AttachDetail]
-- Date Generated: 14 Tháng Giêng 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_InsertProjectPlanExpense_AttachDetail]
	@ProjectPlanExpenseID uniqueidentifier,
	@FileName nvarchar(255),
	@FileType nvarchar(64),
	@Description nvarchar(255),
	@FileSize float,
	@Inactive bit,
	@SortOrder int,
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@IPAddress nvarchar(128),
	@ModifiedBy nvarchar(128),
	@CreatedBy nvarchar(128),
	@ProjectPlanExpense_AttachDetailID uniqueidentifier OUTPUT
AS

INSERT INTO [dbo].[ProjectPlanExpense_AttachDetail] (
	[ProjectPlanExpense_AttachDetailID],
	[ProjectPlanExpenseID],
	[FileName],
	[FileType],
	[Description],
	[FileSize],
	[Inactive],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
) VALUES (
	@ProjectPlanExpense_AttachDetailID,
	@ProjectPlanExpenseID,
	@FileName,
	@FileType,
	@Description,
	@FileSize,
	@Inactive,
	@SortOrder,
	@CreatedDate,
	@ModifiedDate,
	@IPAddress,
	@ModifiedBy,
	@CreatedBy
)

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_InsertProjectPlanPerform]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_InsertProjectPlanPerform]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   Phamlai using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_InsertProjectPlanPerform]
-- Date Generated: Monday, January 29, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_InsertProjectPlanPerform]
	@ProjectID uniqueidentifier,
	@Number nvarchar(64),
	@Date date,
	@Inactive bit,
	@SortOrder int,
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@IPAddress nvarchar(128),
	@ModifiedBy nvarchar(128),
	@CreatedBy nvarchar(128),
	@ProjectPlanPerformID uniqueidentifier OUTPUT
AS

INSERT INTO [dbo].[ProjectPlanPerform] (
	[ProjectPlanPerformID],
	[ProjectID],
	[Number],
	[Date],
	[Inactive],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
) VALUES (
	@ProjectPlanPerformID,
	@ProjectID,
	@Number,
	@Date,
	@Inactive,
	@SortOrder,
	@CreatedDate,
	@ModifiedDate,
	@IPAddress,
	@ModifiedBy,
	@CreatedBy
)

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_InsertProjectPlanPerform_AttachDetail]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_InsertProjectPlanPerform_AttachDetail]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   truong using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_InsertProjectPlanPerform_AttachDetail]
-- Date Generated: Sunday, February 11, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_InsertProjectPlanPerform_AttachDetail]
	@ProjectPlanPerformID uniqueidentifier,
	@FileName nvarchar(255),
	@FileType nvarchar(64),
	@Description nvarchar(255), 
	@FileSize float,
	@Inactive bit,
	@SortOrder int,
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@IPAddress nvarchar(128),
	@ModifiedBy nvarchar(128),
	@CreatedBy nvarchar(128),
	@ProjectPlanPerform_AttachDetailID uniqueidentifier OUTPUT
AS
BEGIN
INSERT INTO [dbo].[ProjectPlanPerform_AttachDetail] (
	[ProjectPlanPerform_AttachDetailID],
	[ProjectPlanPerformID],
	[FileName],
	[FileType],
	[Description],
	[FileSize],
	[Inactive],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
) VALUES (
	@ProjectPlanPerform_AttachDetailID,
	@ProjectPlanPerformID,
	@FileName,
	@FileType,
	@Description,
	@FileSize,
	@Inactive,
	@SortOrder,
	@CreatedDate,
	@ModifiedDate,
	@IPAddress,
	@ModifiedBy,
	@CreatedBy
)
UPDATE  dbo.ProjectPlanPerform
        SET     IdFiles = dbo.[Func_GroupFileProjectPlanPerformIntoMaster](@ProjectPlanPerformID)
        WHERE   ProjectPlanPerformID = @ProjectPlanPerformID
END


--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_InsertProjectPosition]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_InsertProjectPostion]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_InsertProjectPostion]
-- Date Generated: 14 Tháng Giêng 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_InsertProjectPosition]
	@ProjectPositionCode nvarchar(64),
	@ProjectPositionName nvarchar(128),
	@ProjectPositionShortName nvarchar(128),
	@Coefficient decimal(20, 4),
	@Description nvarchar(255),
	@Inactive bit,
	@SortOrder int,
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@IPAddress nvarchar(128),
	@ModifiedBy nvarchar(128),
	@CreatedBy nvarchar(128),
	@ProjectPositionID uniqueidentifier OUTPUT
AS

INSERT INTO [dbo].[ProjectPosition] (
	[ProjectPositionID],
	[ProjectPositionCode],
	[ProjectPositionName],
	[ProjectPositionShortName],
	[Coefficient],
	[Description],
	[Inactive],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
) VALUES (
	@ProjectPositionID,
	@ProjectPositionCode,
	@ProjectPositionName,
	@ProjectPositionShortName,
	@Coefficient,
	@Description,
	@Inactive,
	@SortOrder,
	@CreatedDate,
	@ModifiedDate,
	@IPAddress,
	@ModifiedBy,
	@CreatedBy
)

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_InsertProjectPresentProtected]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_InsertProjectPresentProtected]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_InsertProjectPresentProtected]
-- Date Generated: 14 Tháng Giêng 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_InsertProjectPresentProtected]
	@ProjectID uniqueidentifier,
	@DecisionNumber nvarchar(64),
	@DecisionDate date,
	@ProtectedDate date,
	@Status int,
	@Inactive bit,
	@SortOrder int,
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@IPAddress nvarchar(128),
	@ModifiedBy nvarchar(128),
	@CreatedBy nvarchar(128),
	@ProjectPresentProtectedID uniqueidentifier OUTPUT
AS

INSERT INTO [dbo].[ProjectPresentProtected] (
	[ProjectPresentProtectedID],
	[ProjectID],
	[DecisionNumber],
	[DecisionDate],
	[ProtectedDate],
	[Status],
	[Inactive],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
) VALUES (
	@ProjectPresentProtectedID,
	@ProjectID,
	@DecisionNumber,
	@DecisionDate,
	@ProtectedDate,
	@Status,
	@Inactive,
	@SortOrder,
	@CreatedDate,
	@ModifiedDate,
	@IPAddress,
	@ModifiedBy,
	@CreatedBy
)

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_InsertProjectPresentProtected_AttachDetail]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_InsertProjectPresentProtected_AttachDetail]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_InsertProjectPresentProtected_AttachDetail]
-- Date Generated: 14 Tháng Giêng 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_InsertProjectPresentProtected_AttachDetail]
	@ProjectPresentProtectedID uniqueidentifier,
	@FileName nvarchar(255),
	@FileType nvarchar(64),
	@FileSize float,
	@Inactive bit,
	@SortOrder int,
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@IPAddress nvarchar(128),
	@ModifiedBy nvarchar(128),
	@CreatedBy nvarchar(128),
	@ProjectPresentProtected_AttachDetailID uniqueidentifier OUTPUT
AS

INSERT INTO [dbo].[ProjectPresentProtected_AttachDetail] (
	[ProjectPresentProtected_AttachDetailID],
	[ProjectPresentProtectedID],
	[FileName],
	[FileType],
	[FileSize],
	[Inactive],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
) VALUES (
	@ProjectPresentProtected_AttachDetailID,
	@ProjectPresentProtectedID,
	@FileName,
	@FileType,
	@FileSize,
	@Inactive,
	@SortOrder,
	@CreatedDate,
	@ModifiedDate,
	@IPAddress,
	@ModifiedBy,
	@CreatedBy
)

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_InsertProjectProgressReport]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_InsertProjectProgressReport]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   truong using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_InsertProjectProgressReport]
-- Date Generated: Wednesday, January 31, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_InsertProjectProgressReport]
	@ProjectID uniqueidentifier,
	@TermID int,
	@TermName nvarchar(255),
	@DateReport date,
	@DateCheck date,
	@Result int,
	@Inactive bit,
	@SortOrder int,
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@IPAddress nvarchar(128),
	@ModifiedBy nvarchar(128),
	@CreatedBy nvarchar(128),
	@ProjectProgressReportID uniqueidentifier OUTPUT
AS

INSERT INTO [dbo].[ProjectProgressReport] (
	[ProjectProgressReportID],
	[ProjectID],
	[TermID],
	[TermName],
	[DateReport],
	[DateCheck],
	[Result],
	[Inactive],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
) VALUES (
	@ProjectProgressReportID,
	@ProjectID,
	@TermID,
	@TermName,
	@DateReport,
	@DateCheck,
	@Result,
	@Inactive,
	@SortOrder,
	@CreatedDate,
	@ModifiedDate,
	@IPAddress,
	@ModifiedBy,
	@CreatedBy
)

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_InsertProjectProgressReport_AttachDetail]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_InsertProjectProgressReport_AttachDetail]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   truong using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_InsertProjectProgressReport_AttachDetail]
-- Date Generated: Sunday, February 25, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_InsertProjectProgressReport_AttachDetail]
	@ProjectProgressReportID uniqueidentifier,
	@FileName nvarchar(255),
	@Description nvarchar(255),
	@FileType nvarchar(64),
	@FileSize float,
	@Inactive bit,
	@SortOrder int,
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@IPAddress nvarchar(128),
	@ModifiedBy nvarchar(128),
	@CreatedBy nvarchar(128),
	@ProjectProgressReport_AttachDetailID uniqueidentifier OUTPUT
AS
BEGIN
INSERT INTO [dbo].[ProjectProgressReport_AttachDetail] (
	[ProjectProgressReport_AttachDetailID],
	[ProjectProgressReportID],
	[FileName],
	[Description],
	[FileType],
	[FileSize],
	[Inactive],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
) VALUES (
	@ProjectProgressReport_AttachDetailID,
	@ProjectProgressReportID,
	@FileName,
	@Description,
	@FileType,
	@FileSize,
	@Inactive,
	@SortOrder,
	@CreatedDate,
	@ModifiedDate,
	@IPAddress,
	@ModifiedBy,
	@CreatedBy
)
 UPDATE  dbo.ProjectProgressReport
        SET     IdFiles = dbo.[Func_GroupFileProjectProgressReportIntoMaster](@ProjectProgressReportID)
        WHERE   ProjectProgressReportID = @ProjectProgressReportID
END


--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_InsertProjectSurvey]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_InsertProjectSurvey]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   THANG using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_InsertProjectSurvey]
-- Date Generated: Saturday, February 24, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_InsertProjectSurvey]
	@ProjectID uniqueidentifier,
	@FileName nvarchar(255),
	@FileType nvarchar(64),
	@FileSize float,
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@IPAddress nvarchar(128),
	@ModifiedBy nvarchar(128),
	@CreatedBy nvarchar(128),
	@ProjectSurveyID uniqueidentifier OUTPUT
AS
BEGIN
DELETE FROM dbo.ProjectSurvey WHERE ProjectID=@ProjectID
INSERT INTO [dbo].[ProjectSurvey] (
	[ProjectSurveyID],
	[ProjectID],
	[FileName],
	[FileType],
	[FileSize],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
) VALUES (
	@ProjectSurveyID,
	@ProjectID,
	@FileName,
	@FileType,
	@FileSize,
	@CreatedDate,
	@ModifiedDate,
	@IPAddress,
	@ModifiedBy,
	@CreatedBy
)
END	
--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_InsertProjectSurvey_AttachDetail]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_InsertProjectSurvey_AttachDetail]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   THANG using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_InsertProjectSurvey_AttachDetail]
-- Date Generated: Saturday, February 24, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_InsertProjectSurvey_AttachDetail]
    @ID UNIQUEIDENTIFIER ,
    @FileName NVARCHAR(255) ,
    @FileType NVARCHAR(64) ,
    @FileSize FLOAT ,
    @SortOrder INT ,
    @CreatedDate DATETIME ,
    @ModifiedDate DATETIME ,
    @IPAddress NVARCHAR(128) ,
    @ModifiedBy NVARCHAR(128) ,
    @CreatedBy NVARCHAR(128) ,
    @ProjectSurvey_AttachDetailID UNIQUEIDENTIFIER OUTPUT ,
    @Description NVARCHAR(255)
AS
    BEGIN
        

        INSERT  INTO [dbo].[ProjectSurvey_AttachDetail]
                ( [ProjectSurvey_AttachDetailID] ,
                  [ID] ,
                  [FileName] ,
                  [FileType] ,
                  [FileSize] ,
                  [SortOrder] ,
                  [CreatedDate] ,
                  [ModifiedDate] ,
                  [IPAddress] ,
                  [ModifiedBy] ,
                  [CreatedBy] ,
                  [Description]
                )
        VALUES  ( @ProjectSurvey_AttachDetailID ,
                  @ID ,
                  @FileName ,
                  @FileType ,
                  @FileSize ,
                  @SortOrder ,
                  @CreatedDate ,
                  @ModifiedDate ,
                  @IPAddress ,
                  @ModifiedBy ,
                  @CreatedBy ,
                  @Description
                )

        UPDATE  dbo.ContentServey
        SET     IdFiles = dbo.Func_GroupFileContenServeyIntoMaster(@ID)
        WHERE   ID = @ID
    END
--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_InsertProjectTask]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_InsertProjectTask]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   THANG using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_InsertProjectTask]
-- Date Generated: Sunday, February 11, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_InsertProjectTask]
    @ParentID UNIQUEIDENTIFIER ,
    @ProjectID UNIQUEIDENTIFIER ,
    @Contents NVARCHAR(4000) ,
    @Rank INT ,
    @Result NVARCHAR(255) ,
    @StartDate DATETIME ,
    @EndDate DATETIME ,
    @EmployeeID UNIQUEIDENTIFIER ,
    @Status INT ,
    @Inactive BIT ,
    @CreatedDate DATETIME ,
    @ModifiedDate DATETIME ,
    @IPAddress NVARCHAR(128) ,
    @ModifiedBy NVARCHAR(128) ,
    @CreatedBy NVARCHAR(128) ,
    @ProjectTaskID UNIQUEIDENTIFIER OUTPUT
AS
    BEGIN
        DECLARE @code HIERARCHYID 
        SET @code = [dbo].[Func_GetCodeTree](@ParentID)
        INSERT  INTO [dbo].[ProjectTask]
                ( [ProjectTaskID] ,
                  [ParentID] ,
                  [ProjectID] ,
                  [Contents] ,
                  [Rank] ,
                  [Result] ,
                  [StartDate] ,
                  [EndDate] ,
                  [EmployeeID] ,
                  [Status] ,
                  [Code] ,
                  [Inactive] ,
                  [CreatedDate] ,
                  [ModifiedDate] ,
                  [IPAddress] ,
                  [ModifiedBy] ,
                  [CreatedBy]
                )
        VALUES  ( @ProjectTaskID ,
                  @ParentID ,
                  @ProjectID ,
                  @Contents ,
                  @Rank ,
                  @Result ,
                  @StartDate ,
                  @EndDate ,
                  @EmployeeID ,
                  @Status ,
                  @code ,
                  @Inactive ,
                  @CreatedDate ,
                  @ModifiedDate ,
                  @IPAddress ,
                  @ModifiedBy ,
                  @CreatedBy
                )

    END
--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_InsertProjectTaskMember]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_InsertProjectTaskMember]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   THANG using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_InsertProjectTaskMember]
-- Date Generated: Thursday, March 8, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_InsertProjectTaskMember]
	@ProjectTaskID uniqueidentifier,
	@EmployeeID uniqueidentifier,
	@StartDate datetime,
	@EndDate datetime,
	@MonthForTask numeric(20, 4),
	@SortOrder int,
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@IPAddress nvarchar(128),
	@ModifiedBy nvarchar(128),
	@CreatedBy nvarchar(128),
	@ProjectTaskMemberID uniqueidentifier OUTPUT
AS

INSERT INTO [dbo].[ProjectTaskMember] (
	[ProjectTaskMemberID],
	[ProjectTaskID],
	[EmployeeID],
	[StartDate],
	[EndDate],
	[MonthForTask],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
) VALUES (
	@ProjectTaskMemberID,
	@ProjectTaskID,
	@EmployeeID,
	@StartDate,
	@EndDate,
	@MonthForTask,
	@SortOrder,
	@CreatedDate,
	@ModifiedDate,
	@IPAddress,
	@ModifiedBy,
	@CreatedBy
)

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_InsertProjectWorkshop]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_InsertProjectWorkshop]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   truong using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_InsertProjectWorkshop]
-- Date Generated: Sunday, January 28, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_InsertProjectWorkshop]
	@ProjectID uniqueidentifier,
	@Date date,
	@Time DATETIME,
	@Adderess nvarchar(128),
	@Contents nvarchar(255),
	@SortOrder int,
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@IPAddress nvarchar(128),
	@ModifiedBy nvarchar(128),
	@CreatedBy nvarchar(128),
	@ProjectWorkshopID uniqueidentifier OUTPUT
AS

INSERT INTO [dbo].[ProjectWorkshop] (
	[ProjectWorkshopID],
	[ProjectID],
	[Date],
	[Time],
	[Adderess],
	[Contents],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
) VALUES (
	@ProjectWorkshopID,
	@ProjectID,
	@Date,
	@Time,
	@Adderess,
	@Contents,
	@SortOrder,
	@CreatedDate,
	@ModifiedDate,
	@IPAddress,
	@ModifiedBy,
	@CreatedBy
)

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_InsertProjectWorkshop_AttachDetail]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_InsertProjectWorkshop_AttachDetail]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   Manh using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_InsertProjectWorkshop_AttachDetail]
-- Date Generated: Saturday, February 24, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_InsertProjectWorkshop_AttachDetail]
    @ProjectWorkshopID UNIQUEIDENTIFIER ,
    @Description NVARCHAR(255) ,
    @FileName NVARCHAR(255) ,
    @FileType NVARCHAR(64) ,
    @FileSize FLOAT ,
    @SortOrder INT ,
    @CreatedDate DATETIME ,
    @ModifiedDate DATETIME ,
    @IPAddress NVARCHAR(128) ,
    @ModifiedBy NVARCHAR(128) ,
    @CreatedBy NVARCHAR(128) ,
    @ProjectWorkshop_AttachDetailID UNIQUEIDENTIFIER OUTPUT
AS
    BEGIN
        INSERT  INTO [dbo].[ProjectWorkshop_AttachDetail]
                ( [ProjectWorkshop_AttachDetailID] ,
                  [ProjectWorkshopID] ,
                  [Description] ,
                  [FileName] ,
                  [FileType] ,
                  [FileSize] ,
                  [SortOrder] ,
                  [CreatedDate] ,
                  [ModifiedDate] ,
                  [IPAddress] ,
                  [ModifiedBy] ,
                  [CreatedBy]
                )
        VALUES  ( @ProjectWorkshop_AttachDetailID ,
                  @ProjectWorkshopID ,
                  @Description ,
                  @FileName ,
                  @FileType ,
                  @FileSize ,
                  @SortOrder ,
                  @CreatedDate ,
                  @ModifiedDate ,
                  @IPAddress ,
                  @ModifiedBy ,
                  @CreatedBy
                )

        UPDATE  dbo.ProjectWorkshop
        SET     IdFiles = dbo.[Func_GroupFileProjectWorkshopIntoMaster](@ProjectWorkshopID)
        WHERE   ProjectWorkshopID = @ProjectWorkshopID
    END
--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_InsertQADetail]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Proc_InsertQADetail]
	@QATopicID int,
	@QuestionContent nvarchar(3500),
	@AnswerContent nvarchar(3500),
	@PublicState bit,
	@QuestionBy nvarchar(128),
	@QuestionDate datetime,
	@AnswerBy nvarchar(128),
	@AnswerDate datetime,
	@ModifiedDate datetime,
	@ModifiedBy nvarchar(128),
	@IPAddress nvarchar(128),
	@QADetailID int OUTPUT
AS

INSERT INTO [dbo].[QADetail] (
	[QATopicID],
	[QuestionContent],
	[AnswerContent],
	[PublicState],
	[QuestionBy],
	[QuestionDate],
	[AnswerBy],
	[AnswerDate],
	[ModifiedDate],
	[ModifiedBy],
	[IPAddress]
) VALUES (
	@QATopicID,
	@QuestionContent,
	@AnswerContent,
	@PublicState,
	@QuestionBy,
	@QuestionDate,
	@AnswerBy,
	@AnswerDate,
	@ModifiedDate,
	@ModifiedBy,
	@IPAddress
)

SET @QADetailID = SCOPE_IDENTITY()
SELECT @QADetailID

--endregion


GO
/****** Object:  StoredProcedure [dbo].[Proc_InsertQATopic]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Proc_InsertQATopic]
	@QATopicCode nvarchar(64),
	@QATopicName nvarchar(128),
	@Description nvarchar(255),
	@Inactive bit,
	@SortOrder int,
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@IPAddress nvarchar(128),
	@ModifiedBy nvarchar(128),
	@CreatedBy nvarchar(128),
	@QATopicID int OUTPUT
AS

INSERT INTO [dbo].[QATopic] (
	[QATopicCode],
	[QATopicName],
	[Description],
	[Inactive],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
) VALUES (
	@QATopicCode,
	@QATopicName,
	@Description,
	@Inactive,
	@SortOrder,
	@CreatedDate,
	@ModifiedDate,
	@IPAddress,
	@ModifiedBy,
	@CreatedBy
)

SET @QATopicID = SCOPE_IDENTITY()
SELECT @QATopicID

--endregion


GO
/****** Object:  StoredProcedure [dbo].[Proc_InsertRank]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_InsertRank]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   THANG using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_InsertRank]
-- Date Generated: Monday, January 8, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_InsertRank]
	@RankCode nvarchar(50),
	@RankName nvarchar(128),
	@Description nvarchar(255),
	@Inactive bit,
	@SortOrder int,
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@IPAddress nvarchar(128),
	@ModifiedBy nvarchar(128),
	@CreatedBy nvarchar(128),
	@RankID uniqueidentifier 
AS

GO
/****** Object:  StoredProcedure [dbo].[Proc_InsertRptSolidWaste]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Proc_InsertRptSolidWaste]
	@ReportYear int,
	@CompanyID int,
	@ClassifyStatus bit,
	@WasteTypeID int,
	@Quantity numeric(18, 4),
	@CollectingType int,
	@CollectingTypeDescription nvarchar(1000),
	@CollectingContractNumber nvarchar(150),
	@CollectingContractDate datetime,
	@CollectingContractCompany nvarchar(150),
	@CreatedBy nvarchar(128),
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@ModifiedBy nvarchar(128),
	@IPAddress nvarchar(128),
	@RptSolidWasteID int OUTPUT
AS

INSERT INTO [dbo].[RptSolidWaste] (
	[ReportYear],
	[CompanyID],
	[ClassifyStatus],
	[WasteTypeID],
	[Quantity],
	[CollectingType],
	[CollectingTypeDescription],
	[CollectingContractNumber],
	[CollectingContractDate],
	[CollectingContractCompany],
	[CreatedBy],
	[CreatedDate],
	[ModifiedDate],
	[ModifiedBy],
	[IPAddress]
) VALUES (
	@ReportYear,
	@CompanyID,
	@ClassifyStatus,
	@WasteTypeID,
	@Quantity,
	@CollectingType,
	@CollectingTypeDescription,
	@CollectingContractNumber,
	@CollectingContractDate,
	@CollectingContractCompany,
	@CreatedBy,
	@CreatedDate,
	@ModifiedDate,
	@ModifiedBy,
	@IPAddress
)

SET @RptSolidWasteID = SCOPE_IDENTITY()
SELECT @RptSolidWasteID

--endregion



GO
/****** Object:  StoredProcedure [dbo].[Proc_InsertRptWasteWaterQuantity]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Proc_InsertRptWasteWaterQuantity]
	@CompanyID int,
	@ReportYear int,
	@ProduceWasteWaterQuantity int,
	@DomesticWasteWaterQuantity int,
	@ProcessedWasteWaterQuantity int,
	@ProcessedWasteWaterRate numeric(18, 2),
	@CollingWaterQuantity int,
	@ReuseWaterQuantity int,
	@CreatedBy nvarchar(128),
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@ModifiedBy nvarchar(128),
	@IPAddress nvarchar(128),
	@RptWasteWaterQuantityID int OUTPUT
AS

INSERT INTO [dbo].[RptWasteWaterQuantity] (
	[CompanyID],
	[ReportYear],
	[ProduceWasteWaterQuantity],
	[DomesticWasteWaterQuantity],
	[ProcessedWasteWaterQuantity],
	[ProcessedWasteWaterRate],
	[CollingWaterQuantity],
	[ReuseWaterQuantity],
	[CreatedBy],
	[CreatedDate],
	[ModifiedDate],
	[ModifiedBy],
	[IPAddress]
) VALUES (
	@CompanyID,
	@ReportYear,
	@ProduceWasteWaterQuantity,
	@DomesticWasteWaterQuantity,
	@ProcessedWasteWaterQuantity,
	@ProcessedWasteWaterRate,
	@CollingWaterQuantity,
	@ReuseWaterQuantity,
	@CreatedBy,
	@CreatedDate,
	@ModifiedDate,
	@ModifiedBy,
	@IPAddress
)

SET @RptWasteWaterQuantityID = SCOPE_IDENTITY()
SELECT @RptWasteWaterQuantityID
INSERT INTO [dbo].[CompanyReportingStatus] (
	[CompanyID],
	[ReportYear],
	[ReportDay],
	[UserCreateID]
) VALUES (
	@CompanyID,
	@ReportYear,
	GETDATE(),
	@CreatedBy
)



GO
/****** Object:  StoredProcedure [dbo].[Proc_InsertTokens]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_InsertTokens]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   THANG using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_InsertTokens]
-- Date Generated: Friday, January 12, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_InsertTokens]
	@UserName varchar(50),
	@Token nvarchar(max),
	@ExpiresOn datetime,
	@IssuedOn datetime,
	@TokenId uniqueidentifier OUTPUT
AS
begin
delete from [dbo].[Tokens] where UserName=@UserName
--AND TokenId=@TokenId
INSERT INTO [dbo].[Tokens] (
	[TokenId],
	[UserName],
	[Token],
	[ExpiresOn],
	[IssuedOn]
) VALUES (
	@TokenId,
	@UserName,
	@Token,
	@ExpiresOn,
	@IssuedOn
)
end
--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_InsertUpdateProjectTask]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_InsertUpdateProjectTask]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   MANH using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_InsertUpdateProjectTask]
-- Date Generated: Thursday, March 8, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_InsertUpdateProjectTask]
	@ProjectTaskID uniqueidentifier,
	@ParentID uniqueidentifier,
	@ProjectID uniqueidentifier,
	@SortOrder int
AS

IF EXISTS(SELECT [ProjectTaskID] FROM [dbo].[ProjectTask] WHERE [ProjectTaskID] = @ProjectTaskID)
BEGIN
	UPDATE [dbo].[ProjectTask] SET
		[ParentID] = @ParentID,
		[ProjectID] = @ProjectID,
		[SortOrder] = @SortOrder
	WHERE
		[ProjectTaskID] = @ProjectTaskID
END
ELSE
BEGIN
	INSERT INTO [dbo].[ProjectTask] (
		[ProjectTaskID],
		[ParentID],
		[ProjectID],
		[SortOrder]
	) VALUES (
		@ProjectTaskID,
		@ParentID,
		@ProjectID,
		@SortOrder
	)
END

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_InsertUpdateProjectTaskMember]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_InsertUpdateProjectTaskMember]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   THANG using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_InsertUpdateProjectTaskMember]
-- Date Generated: Thursday, March 8, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_InsertUpdateProjectTaskMember]
	@ProjectTaskMemberID uniqueidentifier,
	@ProjectTaskID uniqueidentifier,
	@EmployeeID uniqueidentifier,
	@StartDate datetime,
	@EndDate datetime,
	@MonthForTask numeric(20, 4),
	@SortOrder int,
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@IPAddress nvarchar(128),
	@ModifiedBy nvarchar(128),
	@CreatedBy nvarchar(128)
AS

IF EXISTS(SELECT [ProjectTaskMemberID] FROM [dbo].[ProjectTaskMember] WHERE [ProjectTaskMemberID] = @ProjectTaskMemberID)
BEGIN
	UPDATE [dbo].[ProjectTaskMember] SET
		[ProjectTaskID] = @ProjectTaskID,
		[EmployeeID] = @EmployeeID,
		[StartDate] = @StartDate,
		[EndDate] = @EndDate,
		[MonthForTask] = @MonthForTask,
		[SortOrder] = @SortOrder,
		[CreatedDate] = @CreatedDate,
		[ModifiedDate] = @ModifiedDate,
		[IPAddress] = @IPAddress,
		[ModifiedBy] = @ModifiedBy,
		[CreatedBy] = @CreatedBy
	WHERE
		[ProjectTaskMemberID] = @ProjectTaskMemberID
END
ELSE
BEGIN
	INSERT INTO [dbo].[ProjectTaskMember] (
		[ProjectTaskMemberID],
		[ProjectTaskID],
		[EmployeeID],
		[StartDate],
		[EndDate],
		[MonthForTask],
		[SortOrder],
		[CreatedDate],
		[ModifiedDate],
		[IPAddress],
		[ModifiedBy],
		[CreatedBy]
	) VALUES (
		@ProjectTaskMemberID,
		@ProjectTaskID,
		@EmployeeID,
		@StartDate,
		@EndDate,
		@MonthForTask,
		@SortOrder,
		@CreatedDate,
		@ModifiedDate,
		@IPAddress,
		@ModifiedBy,
		@CreatedBy
	)
END

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_InsertUpdateProjectTaskMemberFinance]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_InsertUpdateProjectTaskMemberFinance]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   THANG using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_InsertUpdateProjectTaskMemberFinance]
-- Date Generated: Sunday, March 4, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_InsertUpdateProjectTaskMemberFinance]
    @ProjectTaskMemberFinanceID UNIQUEIDENTIFIER ,
    @ProjectID UNIQUEIDENTIFIER ,
    @ProjectTaskID UNIQUEIDENTIFIER ,
    @EmployeeID UNIQUEIDENTIFIER ,
    @Year INT ,
    @Month INT ,
    @Day DATE ,
    @Description NVARCHAR(255) ,
    @Hour NUMERIC(20, 4) ,
    @LaborDay NUMERIC(20, 4) ,
    @DescriptionFin NVARCHAR(255) ,
    @HourFin NUMERIC(20, 4) ,
    @LaborDayFin NUMERIC(20, 4) ,
    @SortOrder INT ,
    @IPAddress NVARCHAR(128) ,
    @ModifiedBy NVARCHAR(128) ,
    @CreatedBy NVARCHAR(128)
AS
    IF EXISTS ( SELECT  [ProjectTaskMemberFinanceID]
                FROM    [dbo].[ProjectTaskMemberFinance]
                WHERE   [ProjectTaskMemberFinanceID] = @ProjectTaskMemberFinanceID )
        BEGIN
            IF ( LEN(@Description) ) = 0
                BEGIN
                    UPDATE  dbo.ProjectTaskMemberFinance
                    SET     Hour = 0 ,
                            LaborDay = 0 ,
                            Description = NULL
                    WHERE   ProjectTaskMemberFinanceID = @ProjectTaskMemberFinanceID
                END
            ELSE
                BEGIN
                    UPDATE  [dbo].[ProjectTaskMemberFinance]
                    SET     [ProjectID] = @ProjectID ,
                            [ProjectTaskID] = @ProjectTaskID ,
                            [EmployeeID] = @EmployeeID ,
                            [Year] = @Year ,
                            [Month] = @Month ,
                            [Day] = @Day ,
                            [Description] = @Description ,
                            [Hour] = @Hour ,
                            [LaborDay] = @LaborDay ,
                            [DescriptionFin] = @DescriptionFin ,
                            [HourFin] = @HourFin ,
                            [LaborDayFin] = @LaborDayFin ,
                            [SortOrder] = @SortOrder ,
                            [ModifiedDate] = GETDATE() ,
                            [IPAddress] = @IPAddress ,
                            [ModifiedBy] = @ModifiedBy
                    WHERE   [ProjectTaskMemberFinanceID] = @ProjectTaskMemberFinanceID
                END
	
        END
    ELSE
        BEGIN
            INSERT  INTO [dbo].[ProjectTaskMemberFinance]
                    ( [ProjectTaskMemberFinanceID] ,
                      [ProjectID] ,
                      [ProjectTaskID] ,
                      [EmployeeID] ,
                      [Year] ,
                      [Month] ,
                      [Day] ,
                      [Description] ,
                      [Hour] ,
                      [LaborDay] ,
                      [DescriptionFin] ,
                      [HourFin] ,
                      [LaborDayFin] ,
                      [SortOrder] ,
                      [CreatedDate] ,
                      [ModifiedDate] ,
                      [IPAddress] ,
                      [ModifiedBy] ,
                      [CreatedBy]
	                )
            VALUES  ( @ProjectTaskMemberFinanceID ,
                      @ProjectID ,
                      @ProjectTaskID ,
                      @EmployeeID ,
                      @Year ,
                      @Month ,
                      @Day ,
                      @Description ,
                      @Hour ,
                      @LaborDay ,
                      @DescriptionFin ,
                      @HourFin ,
                      @LaborDayFin ,
                      @SortOrder ,
                      GETDATE() ,
                      GETDATE() ,
                      @IPAddress ,
                      @ModifiedBy ,
                      @CreatedBy
	                )
        END

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_InsertUpdateSalary]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_InsertUpdateSalary]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   manh using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_InsertUpdateSalary]
-- Date Generated: Saturday, May 26, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_InsertUpdateSalary]
	@SalaryID uniqueidentifier,
	@SalaryCode nvarchar(64),
	@SalaryName nvarchar(128),
	@Month int,
	@Year int,
	@Money int,
	@Inactive bit,
	@SortOrder int,
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@IPAddress nvarchar(128),
	@ModifiedBy nvarchar(128),
	@CreatedBy nvarchar(128)
AS

IF EXISTS(SELECT [SalaryID] FROM [dbo].[Salary] WHERE [SalaryID] = @SalaryID)
BEGIN
	UPDATE [dbo].[Salary] SET
		[SalaryCode] = @SalaryCode,
		[SalaryName] = @SalaryName,
		[Month] = @Month,
		[Year] = @Year,
		[Money] = @Money,
		[Inactive] = @Inactive,
		[SortOrder] = @SortOrder,
		[CreatedDate] = @CreatedDate,
		[ModifiedDate] = @ModifiedDate,
		[IPAddress] = @IPAddress,
		[ModifiedBy] = @ModifiedBy,
		[CreatedBy] = @CreatedBy
	WHERE
		[SalaryID] = @SalaryID
END
ELSE
BEGIN
	INSERT INTO [dbo].[Salary] (
		[SalaryID],
		[SalaryCode],
		[SalaryName],
		[Month],
		[Year],
		[Money],
		[Inactive],
		[SortOrder],
		[CreatedDate],
		[ModifiedDate],
		[IPAddress],
		[ModifiedBy],
		[CreatedBy]
	) VALUES (
		@SalaryID,
		@SalaryCode,
		@SalaryName,
		@Month,
		@Year,
		@Money,
		@Inactive,
		@SortOrder,
		@CreatedDate,
		@ModifiedDate,
		@IPAddress,
		@ModifiedBy,
		@CreatedBy
	)
END

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_InsertUpdateWageCoefficient]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_InsertUpdateWageCoefficient]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   manh using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_InsertUpdateWageCoefficient]
-- Date Generated: Saturday, May 26, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_InsertUpdateWageCoefficient]
	@WageCoefficientID uniqueidentifier,
	@GrantRatioID uniqueidentifier,
	@ProjectPositionID uniqueidentifier,
	@Month int,
	@Year int,
	@Coefficient decimal(20, 4),
	@Inactive bit,
	@SortOrder int,
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@IPAddress nvarchar(128),
	@ModifiedBy nvarchar(128),
	@CreatedBy nvarchar(128)
AS

IF EXISTS(SELECT [WageCoefficientID] FROM [dbo].[WageCoefficient] WHERE [WageCoefficientID] = @WageCoefficientID)
BEGIN
	UPDATE [dbo].[WageCoefficient] SET
		[GrantRatioID] = @GrantRatioID,
		[ProjectPositionID] = @ProjectPositionID,
		[Month] = @Month,
		[Year] = @Year,
		[Coefficient] = @Coefficient,
		[Inactive] = @Inactive,
		[SortOrder] = @SortOrder,
		[CreatedDate] = @CreatedDate,
		[ModifiedDate] = @ModifiedDate,
		[IPAddress] = @IPAddress,
		[ModifiedBy] = @ModifiedBy,
		[CreatedBy] = @CreatedBy
	WHERE
		[WageCoefficientID] = @WageCoefficientID
END
ELSE
BEGIN
	INSERT INTO [dbo].[WageCoefficient] (
		[WageCoefficientID],
		[GrantRatioID],
		[ProjectPositionID],
		[Month],
		[Year],
		[Coefficient],
		[Inactive],
		[SortOrder],
		[CreatedDate],
		[ModifiedDate],
		[IPAddress],
		[ModifiedBy],
		[CreatedBy]
	) VALUES (
		@WageCoefficientID,
		@GrantRatioID,
		@ProjectPositionID,
		@Month,
		@Year,
		@Coefficient,
		@Inactive,
		@SortOrder,
		@CreatedDate,
		@ModifiedDate,
		@IPAddress,
		@ModifiedBy,
		@CreatedBy
	)
END

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_Make_Code_For_ProjectTask]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [dbo].[Proc_Make_Code_For_ProjectTask]
as 
Begin	
	with cte as
(
select
    ProjectTaskID,
    Contents,
    ParentID,
    N'/' + cast(row_number()over(partition by ParentID order by ProjectID) as varchar(max)) + N'/' as [path],
    0 as level,
    row_number()over(partition by ParentID order by ProjectID) / power(10.0,0) as x
 
from ProjectTask
where  ParentID is null
union all
select
    t.ProjectTaskID,
    t.Contents,
    t.ParentID,
    [path] + cast(row_number()over(partition by t.ParentID order by t.ProjectID)   as varchar(max)) + N'/',
    level+1,
    x + row_number()over(partition by t.ParentID order by t.ProjectID) / power(10.0,level+1)
 
from
    cte
join ProjectTask t on cte.ProjectTaskID = t.ParentID
)
--   
--delete from ProjectTask_Temp
--
insert ProjectTask_Temp
select
    ProjectTaskID,
	ParentID,
    Contents,
    [path],
    level
from cte
order by x
End

-- Hiệu chỉnh lại trong bảng ProjectTask
--UPDATE PT
--SET    PT.Code = PT_T.path,
--		PT.Grade = PT_T.level
--FROM   dbo.ProjectTask PT
--INNER JOIN dbo.ProjectTask_Temp PT_T ON PT.ProjectTaskID = PT_T.ProjectTaskID


--Điền lại trưởng Leaf
--update PT1 
--set PT1.Leaf = 1
--from  ProjectTask PT1
--where 
--(
--	select count(*) 
--	from ProjectTask 
--	where ProjectTask.Code  like PT1.Code + '%' and len(ProjectTask.Code) >  len(PT1.Code)
--) < 1







GO
/****** Object:  StoredProcedure [dbo].[Proc_MoveProjectTask]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SELECT CAST(Code AS NVARCHAR(255)),Contents,Code,Grade,ProjectTaskID,ParentID FROM dbo.ProjectTask
--ORDER BY Code

-- Author:		<dvthang>
-- Create date: <11.02.2018>
-- Description:	<Chuyển cành khi sửa nội task của project>
-- =============================================
--[dbo].[Proc_MoveProjectTask] '2E42DEA5-5135-42F4-ADBC-9814EE6AF093','21178C4C-F26E-43A5-99BA-AB212A1D6B43'
CREATE PROCEDURE [dbo].[Proc_MoveProjectTask]
    (
      @NewProjectTaskID UNIQUEIDENTIFIER ,
      @OldProjectTaskID UNIQUEIDENTIFIER
    )
AS
    BEGIN  
        DECLARE @nold HIERARCHYID ,
            @nnew HIERARCHYID  
        SELECT  @nold = Code
        FROM    dbo.ProjectTask
        WHERE   ProjectTaskID = @OldProjectTaskID;  

        SELECT  @nnew = Code
        FROM    dbo.ProjectTask
        WHERE   ProjectTaskID = @NewProjectTaskID;  

        SELECT  @nnew = @nnew.GetDescendant(MAX(Code), NULL)
        FROM    dbo.ProjectTask
        WHERE   Code.GetAncestor(1) = @nnew;  

        UPDATE  dbo.ProjectTask
        SET     Code = Code.GetReparentedValue(@nold, @nnew)
        WHERE   Code.IsDescendantOf(@nold) = 1;  
    END;  




GO
/****** Object:  StoredProcedure [dbo].[Proc_ReSortOrderForProjectTaskByProjectID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<dvthang>
-- Create date: <13.03.2018>
-- Description:	<Thực hiện đánh sortorder cho task>
-- =============================================
CREATE PROCEDURE [dbo].[Proc_ReSortOrderForProjectTaskByProjectID]
    @ProjectID UNIQUEIDENTIFIER
AS
    BEGIN
        UPDATE  P
        SET     P.SortOrder = T.SortOrder
        FROM    dbo.ProjectTask P
                --INNER JOIN ( SELECT ROW_NUMBER() OVER ( ORDER BY Code ) AS SortOrder ,
				INNER JOIN ( SELECT ROW_NUMBER() OVER ( ORDER BY SortOrder ) AS SortOrder ,
                                    ProjectTaskID
                             FROM   dbo.ProjectTask
                             WHERE  ProjectID = @ProjectID
                           ) AS T ON T.ProjectTaskID = P.ProjectTaskID
    END




GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectAcademicRankAll]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectAcademicRankAll]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   truong using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectAcademicRankAll]
-- Date Generated: Saturday, January 13, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectAcademicRankAll]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[AcademicRankID],
	[AcademicRankCode],
	[AcademicRankName],
	[AcademicRankShortName],
	[Description],
	[Inactive],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
FROM
	[dbo].[AcademicRank]

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectAcademicRankAllByEditMode]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<dvthang>
-- Create date: <20.1.2018>
-- Description:	<Lấy danh sách học hàm>
-- =============================================
CREATE PROCEDURE [dbo].[Proc_SelectAcademicRankAllByEditMode] @editMode INT
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

        SELECT  AcademicRankID ,
                AcademicRankCode ,
                AcademicRankName                
        FROM    dbo.AcademicRank
        WHERE   ( ( @editMode IN ( 1, 2 )
                    AND Inactive = 0
                  )
                  OR @editMode NOT	 IN ( 1, 2 )
                )
				ORDER BY SortOrder
    END




GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectAcademicRankByID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectAcademicRankByID]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   truong using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectAcademicRankByID]
-- Date Generated: Saturday, January 13, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectAcademicRankByID]
	@AcademicRankID uniqueidentifier
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[AcademicRankID],
	[AcademicRankCode],
	[AcademicRankName],
	[AcademicRankShortName],
	[Description],
	[Inactive],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
FROM
	[dbo].[AcademicRank]
WHERE
	[AcademicRankID] = @AcademicRankID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectAcademicRankPaging]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectProjectAcceptanceBasisPaging]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectProjectAcceptanceBasisPaging]
-- Date Generated: 19 Tháng Chín 2017
------------------------------------------------------------------------------------------------------------------------
--[dbo].[Proc_SelectRankPaging]'',1,50,'','*',0
CREATE PROCEDURE [dbo].[Proc_SelectAcademicRankPaging]
	@sort NVARCHAR(255) ,
    @page INT ,
    @limit INT ,
    @where NVARCHAR(MAX) ,
    @columns NVARCHAR(1000) = '*' ,
    @totalCount INT OUTPUT
AS
BEGIN
        SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
        IF ( @columns IS NULL
             OR LEN(@columns) = 0
           ) 
            SET @columns = '*'
        IF ( @sort IS NULL
             OR LEN(@sort) = 0
           ) 
            SET @sort = ' ModifiedDate DESC'
       
	   declare @start int=1;

	   set @start=(@page - 1) * @limit

        IF ( @where <> '' ) 
            SET @where = ' WHERE ' + @where
		-- Lay ve totalCount
        DECLARE @totalCountSql NVARCHAR(MAX)= 'SELECT @totalCount=count(*) FROM [dbo].AcademicRank '
            + @where

        EXEC sp_executesql @totalCountSql, N'@totalCount INT OUT', @totalCount OUT
        
		--Lay data
        DECLARE @sql NVARCHAR(MAX)= ' SELECT *	FROM [dbo].AcademicRank '+@where+ ' ORDER BY '+@sort+' OFFSET '+ cast(@start as nvarchar(10))+' ROWS FETCH NEXT '+cast(@limit as nvarchar(10))+' ROWS ONLY'
        
         
        EXEC sp_executesql @sql	
END

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectAspNetUsersAll]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Proc_SelectAspNetUsersAll]
AS
SELECT
	a.[Id],
	a.[Email],
	a.[EmailConfirmed],
	a.[PasswordHash],
	a.[SecurityStamp],
	a.[PhoneNumber],
	a.[PhoneNumberConfirmed],
	a.[TwoFactorEnabled],
	a.[LockoutEndDateUtc],
	a.[LockoutEnabled],
	a.[AccessFailedCount],
	a.[UserName],
	a.[GroupID],
	a.UserID,
	a.[ModifiedDate],
	a.[CreatedDate],
	a.[IPAddress],
	a.[ModifiedBy],
	a.[CreatedBy],
	a.[FullName]
FROM AspNetUsers AS a

GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectAspNetUsersPaging]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectAspNetUsersPaging]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectAspNetUsersPaging]
-- Date Generated: Monday, May 13, 2019
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectAspNetUsersPaging]
	@sort NVARCHAR(255) ,
    @page INT ,
    @limit INT ,
    @where NVARCHAR(MAX) ,
    @columns NVARCHAR(1000) = '*' ,
    @totalCount INT OUTPUT
AS
BEGIN
        SET NOCOUNT ON
        
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
        IF ( @columns IS NULL
             OR LEN(@columns) = 0
           ) 
            SET @columns = '*'
        IF ( @sort IS NULL
             OR LEN(@sort) = 0
           ) 
            SET @sort = ' ModifiedDate DESC'
       
		declare @start int=1;

		set @start=(@page - 1) * @limit

		IF ( @where IS NOT NULL
			 AND LEN(@where) >0
		   ) 
			SET @where = ' WHERE ' + @where
		-- Lay ve totalCount
		DECLARE @totalCountSql NVARCHAR(MAX)= 'SELECT @totalCount=count(*) FROM [dbo].AspNetUsers '
			+ @where

		EXEC sp_executesql @totalCountSql, N'@totalCount INT OUT', @totalCount OUT
		
		--Lay data
		DECLARE @sql NVARCHAR(MAX)= ' SELECT *	FROM [dbo].AspNetUsers '+@where+ ' ORDER BY '+@sort+' OFFSET '+ cast(@start as nvarchar(10))+' ROWS FETCH NEXT '+cast(@limit as nvarchar(10))+' ROWS ONLY'
		
		 
		EXEC sp_executesql @sql	
        
END

--endregion


GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectCompanyAll]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectCompanyAll]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   truong using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectCompanyAll]
-- Date Generated: Saturday, January 13, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectCompanyAll]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[CompanyID],
	[ParentID],
	[CompanyCode],
	[CompanyName],
	[CompanyShortName],
	[Tel],
	[Fax],
	[Email],
	[Address],
	[Website],
	[Director],
	[AccountNumber],
	[BankName],
	[Description],
	[IsLeaf],
	[Inactive],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy],
	[Owned]
FROM
	[dbo].[Company]

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectCompanyAllByEditMode]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<dvthang>
-- Create date: <20.1.2018>
-- Description:	<Lấy danh sách đơn vị>
-- =============================================
CREATE PROCEDURE [dbo].[Proc_SelectCompanyAllByEditMode] @editMode INT
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

        SELECT CompanyID,CompanyName FROM dbo.Company
        WHERE   ( ( @editMode IN ( 1, 2 )
                    AND Inactive = 0
                  )
                  OR @editMode NOT	 IN ( 1, 2 )
                )
				ORDER BY SortOrder
    END




GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectCompanyByID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectCompanyByID]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   truong using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectCompanyByID]
-- Date Generated: Saturday, January 13, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectCompanyByID]
	@CompanyID uniqueidentifier
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[CompanyID],
	[ParentID],
	[CompanyCode],
	[CompanyName],
	[CompanyShortName],
	[Tel],
	[Fax],
	[Email],
	[Address],
	[Website],
	[Director],
	[AccountNumber],
	[BankName],
	[Description],
	[IsLeaf],
	[Inactive],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy],
	[Owned]
FROM
	[dbo].[Company]
WHERE
	[CompanyID] = @CompanyID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectCompanyPaging]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectProjectAcceptanceBasisPaging]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectProjectAcceptanceBasisPaging]
-- Date Generated: 19 Tháng Chín 2017
------------------------------------------------------------------------------------------------------------------------
--[dbo].[Proc_SelectRankPaging]'',1,50,'','*',0
CREATE PROCEDURE [dbo].[Proc_SelectCompanyPaging]
	@sort NVARCHAR(255) ,
    @page INT ,
    @limit INT ,
    @where NVARCHAR(MAX) ,
    @columns NVARCHAR(1000) = '*' ,
    @totalCount INT OUTPUT
AS
BEGIN
        SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
        IF ( @columns IS NULL
             OR LEN(@columns) = 0
           ) 
            SET @columns = '*'
        IF ( @sort IS NULL
             OR LEN(@sort) = 0
           ) 
            SET @sort = ' ModifiedDate DESC'
       
	   declare @start int=1;

	   set @start=(@page - 1) * @limit

        IF ( @where <> '' ) 
            SET @where = ' WHERE ' + @where
		-- Lay ve totalCount
        DECLARE @totalCountSql NVARCHAR(MAX)= 'SELECT @totalCount=count(*) FROM [dbo].Company '
            + @where

        EXEC sp_executesql @totalCountSql, N'@totalCount INT OUT', @totalCount OUT
        
		--Lay data
        DECLARE @sql NVARCHAR(MAX)= ' SELECT *	FROM [dbo].Company '+@where+ ' ORDER BY '+@sort+' OFFSET '+ cast(@start as nvarchar(10))+' ROWS FETCH NEXT '+cast(@limit as nvarchar(10))+' ROWS ONLY'
        
         
        EXEC sp_executesql @sql	
END

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectContentExperimentAll]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectContentExperimentAll]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   Manh using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectContentExperimentAll]
-- Date Generated: Sunday, February 25, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectContentExperimentAll]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[ID],
	[ProjectID],
	[ToDate],
	[CompanyID],
	[AtCompany],
	[Description],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
FROM
	[dbo].[ContentExperiment]

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectContentExperimentByID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectContentExperimentByID]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   Admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectContentExperimentByID]
-- Date Generated: Sunday, February 25, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectContentExperimentByID]
	@ID uniqueidentifier
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[ID],
	[ProjectID],
	[ToDate],
	[CompanyID],
	[AtCompany],
	[Description],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
FROM
	[dbo].[ContentExperiment]
WHERE
	[ID] = @ID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectContentExperimentByMasterID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<manh>
-- Create date: <25.02.2018>
-- Description:	<Lấy danh sách nội dung thử nghiệm>
-- =============================================

CREATE PROCEDURE [dbo].[Proc_SelectContentExperimentByMasterID]
    @masterId UNIQUEIDENTIFIER
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;
        SELECT  ID ,
                ProjectID ,
                ToDate ,
                C.CompanyID ,
                AtCompany ,
                C.Description ,
                CP.CompanyName,
				C.ToDate,
				C.IdFiles
        FROM    dbo.ContentExperiment C
		INNER JOIN dbo.Company CP ON CP.CompanyID = C.CompanyID
        WHERE   ProjectID = @masterId
		ORDER BY CP.CompanyName
    END




GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectContentServeyAll]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectContentServeyAll]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   THANG using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectContentServeyAll]
-- Date Generated: Saturday, February 24, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectContentServeyAll]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[ID],
	[CompanyID],
	[AtCompany],
	[Description],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy],
	ToDate,
	ProjectID
FROM
	[dbo].[ContentServey]

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectContentServeyByID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectContentServeyByID]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   THANG using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectContentServeyByID]
-- Date Generated: Saturday, February 24, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectContentServeyByID]
	@ID uniqueidentifier
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[ID],
	[CompanyID],
	[AtCompany],
	[Description],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy],
	ToDate,
	ProjectID
FROM
	[dbo].[ContentServey]
WHERE
	[ID] = @ID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectContentServeyByMasterID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<dvthang>
-- Create date: <24.02.2018>
-- Description:	<Lấy danh sách nội dung khảo sát>
-- =============================================

CREATE PROCEDURE [dbo].[Proc_SelectContentServeyByMasterID]
    @masterId UNIQUEIDENTIFIER
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;
        SELECT  ID ,
                ProjectID ,
                ToDate ,
                C.CompanyID ,
                AtCompany ,
                C.Description ,
                CP.CompanyName,
				C.ToDate,
				C.IdFiles
        FROM    dbo.ContentServey C
		INNER JOIN dbo.Company CP ON CP.CompanyID = C.CompanyID
        WHERE   ProjectID = @masterId
		ORDER BY CP.CompanyName
    END




GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectCustomerAll]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Proc_SelectCustomerAll]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[CustomerID],
	[CustomerCode],
	[CustomerName],
	[CustomerGender],
	[DOB],
	[HealthCareNumber],
	[Tel],
	[Email],
	[Address],
	[CustomerDescription],
	[PresenterName],
	[PresenterPhone],
	[PresenterAddress],
	[PresenterIDC],
	[Relationship],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
FROM
	[dbo].[Customer]

--endregion


GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectCustomerPaging]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectCustomerPaging]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectCustomerPaging]
-- Date Generated: Monday, April 22, 2019
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectCustomerPaging]
	@sort NVARCHAR(255) ,
    @page INT ,
    @limit INT ,
    @where NVARCHAR(MAX) ,
    @columns NVARCHAR(1000) = '*' ,
    @totalCount INT OUTPUT
AS
BEGIN
        SET NOCOUNT ON
        
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
        IF ( @columns IS NULL
             OR LEN(@columns) = 0
           ) 
            SET @columns = '*'
        IF ( @sort IS NULL
             OR LEN(@sort) = 0
           ) 
            SET @sort = ' ModifiedDate DESC'
       
		declare @start int=1;

		set @start=(@page - 1) * @limit

		IF ( @where IS NOT NULL
			 AND LEN(@where) >0
		   ) 
			SET @where = ' WHERE ' + @where
		-- Lay ve totalCount
		DECLARE @totalCountSql NVARCHAR(MAX)= 'SELECT @totalCount=count(*) FROM [dbo].Customer '
			+ @where

		EXEC sp_executesql @totalCountSql, N'@totalCount INT OUT', @totalCount OUT
		
		--Lay data
		DECLARE @sql NVARCHAR(MAX)= ' SELECT *	FROM [dbo].Customer '+@where+ ' ORDER BY '+@sort+' OFFSET '+ cast(@start as nvarchar(10))+' ROWS FETCH NEXT '+cast(@limit as nvarchar(10))+' ROWS ONLY'
		
		 
		EXEC sp_executesql @sql	
        
END

--endregion


GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectDayOffAll]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectDayOffAll]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   truong using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectDayOffAll]
-- Date Generated: Saturday, March 3, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectDayOffAll]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[DayOffID],
	[Date],
	[Description],
	[Inactive],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
FROM
	[dbo].[DayOff]

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectDayOffAllByEditMode]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<dvthang>
-- Create date: <20.1.2018>
-- Description:	<Lấy danh sách cấp quản lý>
-- =============================================
CREATE PROCEDURE [dbo].[Proc_SelectDayOffAllByEditMode] @editMode INT
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

        SELECT  DayOffID ,
                [Date] ,
                Description 
                 FROM dbo.DayOff
        WHERE   ( ( @editMode IN ( 1, 2 )
                    AND Inactive = 0
                  )
                  OR @editMode NOT	 IN ( 1, 2 )
                )
				ORDER BY SortOrder
    END




GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectDayOffByID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectDayOffByID]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   truong using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectDayOffByID]
-- Date Generated: Saturday, March 3, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectDayOffByID]
	@DayOffID uniqueidentifier
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[DayOffID],
	[Date],
	[Description],
	[Inactive],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
FROM
	[dbo].[DayOff]
WHERE
	[DayOffID] = @DayOffID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectDayOffByMasterID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Proc_SelectDayOffByMasterID]
    @MasterID UNIQUEIDENTIFIER
AS
    SET NOCOUNT ON
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED

    SELECT  dbo.View_DayOff.* ,
            ROW_NUMBER() OVER ( ORDER BY dbo.View_DayOff.SortOrder ASC ) AS Rownum
    FROM    dbo.View_DayOff
    WHERE   [DayOffID] = @MasterID




GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectDayOffPaging]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectDayOffPaging]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   THANG using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectDayOffPaging]
-- Date Generated: Tuesday, March 27, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectDayOffPaging]
	@sort NVARCHAR(255) ,
	@page INT ,
    @limit INT ,
    @where NVARCHAR(MAX) ,
    @columns NVARCHAR(1000) = '*' ,
    @totalCount INT OUTPUT
AS
BEGIN
        SET NOCOUNT ON
        
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
        IF ( @columns IS NULL
             OR LEN(@columns) = 0
           ) 
            SET @columns = '*'
        IF ( @sort IS NULL
             OR LEN(@sort) = 0
           ) 
            SET @sort = ' Date DESC'
       
		declare @start int=1;

		set @start=(@page - 1) * @limit

		IF ( @where IS NOT NULL
			 AND LEN(@where) >0
		   ) 
			SET @where = ' WHERE ' + @where
		-- Lay ve totalCount
		DECLARE @totalCountSql NVARCHAR(MAX)= 'SELECT @totalCount=count(*) FROM [dbo].[View_DayOff] '
			+ @where

		EXEC sp_executesql @totalCountSql, N'@totalCount INT OUT', @totalCount OUT
		
		--Lay data
		DECLARE @sql NVARCHAR(MAX)= ' SELECT *	FROM [dbo].[View_DayOff] '+@where+ ' ORDER BY '+@sort+' OFFSET '+ cast(@start as nvarchar(10))+' ROWS FETCH NEXT '+cast(@limit as nvarchar(10))+' ROWS ONLY'
		
		 
		EXEC sp_executesql @sql	
        
END

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectDegreeAll]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectDegreeAll]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectDegreeAll]
-- Date Generated: 13 Tháng Giêng 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectDegreeAll]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[DegreeID],
	[DegreeCode],
	[DegreeName],
	[DegreeShortName],
	[Description],
	[Inactive],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
FROM
	[dbo].[Degree]

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectDegreeAllByEditMode]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<dvthang>
-- Create date: <20.1.2018>
-- Description:	<Lấy danh sách học hàm>
-- =============================================
CREATE PROCEDURE [dbo].[Proc_SelectDegreeAllByEditMode] @editMode INT
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

        SELECT  DegreeID ,
                DegreeCode ,
                DegreeName 
                 FROM dbo.Degree
        WHERE   ( ( @editMode IN ( 1, 2 )
                    AND Inactive = 0
                  )
                  OR @editMode NOT	 IN ( 1, 2 )
                )
				ORDER BY SortOrder
    END




GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectDegreeByID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectDegreeByID]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectDegreeByID]
-- Date Generated: 13 Tháng Giêng 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectDegreeByID]
	@DegreeID uniqueidentifier
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[DegreeID],
	[DegreeCode],
	[DegreeName],
	[DegreeShortName],
	[Description],
	[Inactive],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
FROM
	[dbo].[Degree]
WHERE
	[DegreeID] = @DegreeID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectDegreePaging]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectProjectAcceptanceBasisPaging]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectProjectAcceptanceBasisPaging]
-- Date Generated: 19 Tháng Chín 2017
------------------------------------------------------------------------------------------------------------------------
--[dbo].[Proc_SelectRankPaging]'',1,50,'','*',0
CREATE PROCEDURE [dbo].[Proc_SelectDegreePaging]
	@sort NVARCHAR(255) ,
    @page INT ,
    @limit INT ,
    @where NVARCHAR(MAX) ,
    @columns NVARCHAR(1000) = '*' ,
    @totalCount INT OUTPUT
AS
BEGIN
        SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
        IF ( @columns IS NULL
             OR LEN(@columns) = 0
           ) 
            SET @columns = '*'
        IF ( @sort IS NULL
             OR LEN(@sort) = 0
           ) 
            SET @sort = ' ModifiedDate DESC'
       
	   declare @start int=1;

	   set @start=(@page - 1) * @limit

        IF ( @where <> '' ) 
            SET @where = ' WHERE ' + @where
		-- Lay ve totalCount
        DECLARE @totalCountSql NVARCHAR(MAX)= 'SELECT @totalCount=count(*) FROM [dbo].Degree '
            + @where

        EXEC sp_executesql @totalCountSql, N'@totalCount INT OUT', @totalCount OUT
        
		--Lay data
        DECLARE @sql NVARCHAR(MAX)= ' SELECT *	FROM [dbo].Degree '+@where+ ' ORDER BY '+@sort+' OFFSET '+ cast(@start as nvarchar(10))+' ROWS FETCH NEXT '+cast(@limit as nvarchar(10))+' ROWS ONLY'
        
         
        EXEC sp_executesql @sql	
END

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectEmployee_For_ProjectInputPaging]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectProjectAcceptanceBasisPaging]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectProjectAcceptanceBasisPaging]
-- Date Generated: 19 Tháng Chín 2017
------------------------------------------------------------------------------------------------------------------------
--[dbo].[Proc_SelectEmployeePaging]'',1,50,'','*',0
CREATE PROCEDURE [dbo].[Proc_SelectEmployee_For_ProjectInputPaging]
    @sort NVARCHAR(255) ,
    @page INT ,
    @limit INT ,
    @where NVARCHAR(MAX) ,
    @columns NVARCHAR(1000) = '*' ,
    @totalcount INT OUTPUT ,
    @ProjectID UNIQUEIDENTIFIER
AS
    BEGIN
        SET NOCOUNT ON
        SET TRANSACTION ISOLATION LEVEL READ COMMITTED
--Lấy dữ liệu vào bảng tạm
        SELECT  @ProjectID AS ProjectID ,
                View_Employee.EmployeeID ,
                +View_Employee.LastName + N' ' + View_Employee.FirstName AS FullName ,
                View_Employee.FirstName
        INTO    #TempTable
        FROM    View_Employee
--Lấy giá trị cho phép được nhập liệu
        SELECT  #TempTable.ProjectID ,
                #TempTable.EmployeeID ,
                #TempTable.FullName ,
                #TempTable.FirstName ,
                AllowedToInput = CASE WHEN ProjectInput.EmployeeID IS NULL
                                      THEN 0
                                      ELSE 1
                                 END
        INTO    #TempTable2
        FROM    #TempTable
                LEFT JOIN dbo.ProjectInput ON #TempTable.ProjectID = ProjectInput.ProjectID
                                              AND #TempTable.EmployeeID = ProjectInput.EmployeeID
--
        IF ( @columns IS NULL
             OR LEN(@columns) = 0
           )
            SET @columns = '*'
        IF ( @sort IS NULL
             OR LEN(@sort) = 0
           )
            SET @sort = ' FirstName'
       
        DECLARE @start INT= 1;

        SET @start = ( @page - 1 ) * @limit

        IF ( @where <> '' )
            SET @where = ' WHERE ' + @where
		-- Lay ve totalCount
        DECLARE @totalCountSql NVARCHAR(MAX)= 'SELECT @totalcount=count(*) FROM #TempTable2 '
            + @where

        EXEC sp_executesql @totalCountSql, N'@totalcount INT OUT',
            @totalCount OUT
        
		--Lay data
        DECLARE @sql NVARCHAR(MAX)= ' SELECT *, ROW_NUMBER() OVER (ORDER BY FirstName) AS Rownum FROM #TempTable2 '
            + @where + ' ORDER BY ' + @sort + ' OFFSET '
            + CAST(@start AS NVARCHAR(10)) + ' ROWS FETCH NEXT '
            + CAST(@limit AS NVARCHAR(10)) + ' ROWS ONLY'
        
         
        EXEC sp_executesql @sql	
		--Xóa bảng
        DROP TABLE #TempTable
        DROP TABLE #TempTable2
    END

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectEmployeeAll]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectEmployeeAll]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectEmployeeAll]
-- Date Generated: 14 Tháng Giêng 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectEmployeeAll]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[EmployeeID],
	[CompanyID],
	[EmployeeCode],
	[FirstName],
	[LastName],
	[FullName],
	[RankID],
	[Gender],
	[AcademicRankID],
	[YearOfAcademicRank],
	[DegreeID],
	[YearOfDegree],
	[PositionID],
	[BirthDay],
	[BirthPlace],
	[HomeLand],
	[NativeAddress],
	[Tel],
	[HomeTel],
	[Mobile],
	[Fax],
	[Email],
	[OfficeAddress],
	[HomeAddress],
	[Website],
	[Description],
	FileResourceID,
	[Inactive],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
FROM
	[dbo].[Employee]

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectEmployeeAllByEditMode]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<dvthang>
-- Create date: <20.1.2018>
-- Description:	<Lấy danh sách cấp quản lý>
-- =============================================
CREATE PROCEDURE [dbo].[Proc_SelectEmployeeAllByEditMode] @editMode INT
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

        SELECT  dbo.Employee.EmployeeID ,
                dbo.Employee.EmployeeCode ,
                dbo.Employee.FullName + N'('
                + RTRIM(LTRIM(ISNULL(Company.CompanyShortName, N''))) + ')' AS FullName
        FROM    dbo.Employee
                LEFT JOIN dbo.Company ON dbo.Employee.CompanyID = dbo.Company.CompanyID
        WHERE   ( ( @editMode IN ( 1, 2 )
                    AND dbo.Employee.Inactive = 0
                  )
                  OR @editMode NOT	 IN ( 1, 2 )
                )
        ORDER BY dbo.Employee.FirstName ,
                dbo.Employee.LastName
    END




GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectEmployeeByID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectEmployeeByID]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectEmployeeByID]
-- Date Generated: 14 Tháng Giêng 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectEmployeeByID]
	@EmployeeID uniqueidentifier
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[EmployeeID],
	[CompanyID],
	[EmployeeCode],
	[FirstName],
	[LastName],
	[FullName],
	[RankID],
	[Gender],
	[AcademicRankID],
	[YearOfAcademicRank],
	[DegreeID],
	[YearOfDegree],
	[PositionID],
	[BirthDay],
	[BirthPlace],
	[HomeLand],
	[NativeAddress],
	[Tel],
	[HomeTel],
	[Mobile],
	[Fax],
	[Email],
	[OfficeAddress],
	[HomeAddress],
	[Website],
	[Description],
	FileResourceID,
	[Inactive],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
FROM
	[dbo].[Employee]
WHERE
	[EmployeeID] = @EmployeeID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectEmployeeByMasterID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Manh>
-- Create date: <11.03.18>
-- Description:	<Danh sách thành viên load vào combo trong ProjectTaskMember>
-- =============================================
CREATE PROCEDURE [dbo].[Proc_SelectEmployeeByMasterID]
	@ProjectID UNIQUEIDENTIFIER
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;-- 

    -- Insert statements for procedure here
	SELECT ProjectMemberID,ProjectID,EmployeeID,FullName
	FROM dbo.View_ProjectMember
	WHERE ProjectID = @ProjectID

END




GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectEmployeePaging]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectProjectAcceptanceBasisPaging]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectProjectAcceptanceBasisPaging]
-- Date Generated: 19 Tháng Chín 2017
------------------------------------------------------------------------------------------------------------------------
--[dbo].[Proc_SelectEmployeePaging]'',1,50,'','*',0
CREATE PROCEDURE [dbo].[Proc_SelectEmployeePaging]
	@sort NVARCHAR(255) ,
    @page INT ,
    @limit INT ,
    @where NVARCHAR(MAX) ,
    @columns NVARCHAR(1000) = '*' ,
    @totalcount INT OUTPUT
AS
BEGIN
        SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
        IF ( @columns IS NULL
             OR LEN(@columns) = 0
           ) 
            SET @columns = '*'
        IF ( @sort IS NULL
             OR LEN(@sort) = 0
           ) 
            SET @sort = ' FirstName'
       
	   declare @start int=1;

	   set @start=(@page - 1) * @limit

        IF ( @where <> '' ) 
            SET @where = ' WHERE ' + @where
		-- Lay ve totalCount
        DECLARE @totalCountSql NVARCHAR(MAX)= 'SELECT @totalcount=count(*) FROM [dbo].[View_Employee] '
            + @where

        EXEC sp_executesql @totalCountSql, N'@totalcount INT OUT', @totalCount OUT
        
		--Lay data
        DECLARE @sql NVARCHAR(MAX)= ' SELECT *, ROW_NUMBER() OVER (ORDER BY FirstName) AS Rownum FROM [dbo].[View_Employee] '+@where+ ' ORDER BY '+@sort+' OFFSET '+ cast(@start as nvarchar(10))+' ROWS FETCH NEXT '+cast(@limit as nvarchar(10))+' ROWS ONLY'
        
         
        EXEC sp_executesql @sql	
END

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectEmployeeToProjectInput]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Manh
-- Create date: 22.08.18
-- Description:	Lấy các nhân viên chưa được chọn
-- Proc_SelectEmployeeToProjectInput 'c1644ef7-2bb9-4715-a3f8-3f21638d2c18',N'Hà'
-- =============================================
CREATE PROCEDURE [dbo].[Proc_SelectEmployeeToProjectInput]
    @ProjectID UNIQUEIDENTIFIER ,
    @search NVARCHAR(255)
AS
    BEGIN
        SET NOCOUNT ON;
        SELECT  *
        FROM    dbo.Employee E
        WHERE   ( E.LastName LIKE N'%' + ISNULL(@search, '') + '%'
                  OR E.FirstName LIKE N'%' + ISNULL(@search, '') + '%'
                  OR E.FullName LIKE N'%' + ISNULL(@search, '') + '%'
                )
                AND E.EmployeeID NOT IN ( SELECT    PI.EmployeeID
                                          FROM      dbo.ProjectInput PI
                                          WHERE     PI.ProjectID = @ProjectID )
    END




GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectGrantRatioAll]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectGrantRatioAll]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   truong using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectGrantRatioAll]
-- Date Generated: Wednesday, May 23, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectGrantRatioAll]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[GrantRatioID],
	[GrantRatioCode],
	[GrantRatioName],
	[Description],
	[Inactive],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
FROM
	[dbo].[GrantRatio]

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectGrantRatioAllByEditMode]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<dvthang>
-- Create date: <20.1.2018>
-- Description:	<Lấy danh sách học hàm>
-- =============================================
CREATE PROCEDURE [dbo].[Proc_SelectGrantRatioAllByEditMode] @editMode INT
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

        SELECT  GrantRatioID ,
                GrantRatioCode ,
                GrantRatioName                
        FROM    dbo.GrantRatio
        WHERE   ( ( @editMode IN ( 1, 2 )
                    AND Inactive = 0
                  )
                  OR @editMode NOT	 IN ( 1, 2 )
                )
				ORDER BY SortOrder
    END




GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectGrantRatioByID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectGrantRatioByID]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   truong using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectGrantRatioByID]
-- Date Generated: Wednesday, May 23, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectGrantRatioByID]
	@GrantRatioID uniqueidentifier
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[GrantRatioID],
	[GrantRatioCode],
	[GrantRatioName],
	[Description],
	[Inactive],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
FROM
	[dbo].[GrantRatio]
WHERE
	[GrantRatioID] = @GrantRatioID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectGrantRatioPaging]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectGrantRatioPaging]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   truong using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectGrantRatioPaging]
-- Date Generated: Sunday, April 8, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectGrantRatioPaging]
	@sort NVARCHAR(255) ,
    @page INT ,
    @limit INT ,
    @where NVARCHAR(MAX) ,
    @columns NVARCHAR(1000) = '*' ,
    @totalCount INT OUTPUT
AS
BEGIN
        SET NOCOUNT ON
        SET TRANSACTION ISOLATION LEVEL READ COMMITTED
        IF ( @columns IS NULL
             OR LEN(@columns) = 0
           ) 
            SET @columns = '*'
        IF ( @sort IS NULL
             OR LEN(@sort) = 0
           ) 
            SET @sort = ' ModifiedDate DESC'
       
		declare @start int=1;

		set @start=(@page - 1) * @limit

		IF ( @where IS NOT NULL
			 AND LEN(@where) >0
		   ) 
			SET @where = ' WHERE ' + @where
		-- Lay ve totalCount
		DECLARE @totalCountSql NVARCHAR(MAX)= 'SELECT @totalCount=count(*) FROM [dbo].View_GrantRatio '
			+ @where

		EXEC sp_executesql @totalCountSql, N'@totalCount INT OUT', @totalCount OUT
		
		--Lay data
		DECLARE @sql NVARCHAR(MAX)= 'SELECT *, ROW_NUMBER() OVER (ORDER BY ModifiedDate DESC) AS Rownum FROM [dbo].View_GrantRatio '+@where+ ' ORDER BY '+@sort+' OFFSET '+ cast(@start as nvarchar(10))+' ROWS FETCH NEXT '+cast(@limit as nvarchar(10))+' ROWS ONLY'
		
		 
		EXEC sp_executesql @sql	
END

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectLevelAll]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectLevelAll]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   Phamlai using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectLevelAll]
-- Date Generated: Saturday, January 13, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectLevelAll]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[LevelID],
	[LevelCode],
	[LevelName],
	[Description],
	[Inactive],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
FROM
	[dbo].[Level]

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectLevelAllByEditMode]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<dvthang>
-- Create date: <20.1.2018>
-- Description:	<Lấy danh sách cấp quản lý>
-- =============================================
CREATE PROCEDURE [dbo].[Proc_SelectLevelAllByEditMode] @editMode INT
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

        SELECT  LevelID ,
                LevelCode ,
                LevelName 
                 FROM dbo.Level
        WHERE   ( ( @editMode IN ( 1, 2 )
                    AND Inactive = 0
                  )
                  OR @editMode NOT	 IN ( 1, 2 )
                )
				ORDER BY SortOrder
    END




GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectLevelByID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectLevelByID]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   Phamlai using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectLevelByID]
-- Date Generated: Saturday, January 13, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectLevelByID]
	@LevelID int
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[LevelID],
	[LevelCode],
	[LevelName],
	[Description],
	[Inactive],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
FROM
	[dbo].[Level]
WHERE
	[LevelID] = @LevelID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectLevelDynamic]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectLevelDynamic]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   Phamlai using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectLevelDynamic]
-- Date Generated: Saturday, January 13, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectLevelDynamic]
	@WhereCondition nvarchar(500),
	@OrderByExpression nvarchar(250) = NULL
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

DECLARE @SQL nvarchar(3250)

SET @SQL = '
SELECT
	[LevelID],
	[LevelCode],
	[LevelName],
	[Description],
	[Inactive],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
FROM
	[dbo].[Level]
WHERE
	' + @WhereCondition

IF @OrderByExpression IS NOT NULL AND LEN(@OrderByExpression) > 0
BEGIN
	SET @SQL = @SQL + '
ORDER BY
	' + @OrderByExpression
END

EXEC sp_executesql @SQL

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectLevelPaging]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectProjectAcceptanceBasisPaging]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectProjectAcceptanceBasisPaging]
-- Date Generated: 19 Tháng Chín 2017
------------------------------------------------------------------------------------------------------------------------
--[dbo].[Proc_SelectLevelPaging]'',1,50,'','*',0
create PROCEDURE [dbo].[Proc_SelectLevelPaging]
	@sort NVARCHAR(255) ,
    @page INT ,
    @limit INT ,
    @where NVARCHAR(MAX) ,
    @columns NVARCHAR(1000) = '*' ,
    @totalCount INT OUTPUT
AS
BEGIN
        SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
        IF ( @columns IS NULL
             OR LEN(@columns) = 0
           ) 
            SET @columns = '*'
        IF ( @sort IS NULL
             OR LEN(@sort) = 0
           ) 
            SET @sort = ' ModifiedDate DESC'
       
	   declare @start int=1;

	   set @start=(@page - 1) * @limit

        IF ( @where <> '' ) 
            SET @where = ' WHERE ' + @where
		-- Lay ve totalCount
        DECLARE @totalCountSql NVARCHAR(MAX)= 'SELECT @totalCount=count(*) FROM [dbo].Level '
            + @where

        EXEC sp_executesql @totalCountSql, N'@totalCount INT OUT', @totalCount OUT
        
		--Lay data
        DECLARE @sql NVARCHAR(MAX)= ' SELECT *	FROM [dbo].Level '+@where+ ' ORDER BY '+@sort+' OFFSET '+ cast(@start as nvarchar(10))+' ROWS FETCH NEXT '+cast(@limit as nvarchar(10))+' ROWS ONLY'
        
         
        EXEC sp_executesql @sql	
END

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectListIDProjectExperiment_AttachDetailByMasterID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Manh>
-- Create date: <01.04.18>
-- Description:	<Lấy về danh sách ID file đính kèm của Thông tin thử nghiệm>
-- =============================================
CREATE PROCEDURE [dbo].[Proc_SelectListIDProjectExperiment_AttachDetailByMasterID]
    @MasterID UNIQUEIDENTIFIER
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

    -- Insert statements for procedure here
        SELECT  ProjectExperiment_AttachDetailID ,
                FileType
        FROM    dbo.ProjectExperiment_AttachDetail
        WHERE   ID = @MasterID
    END




GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectListIDProjectProgressReport_AttachDetailByMasterID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Manh>
-- Create date: <01.04.18>
-- Description:	<Lấy về danh sách ID file đính kèm của Báo cáo tiến độ>
-- =============================================
CREATE PROCEDURE [dbo].[Proc_SelectListIDProjectProgressReport_AttachDetailByMasterID]
    @MasterID UNIQUEIDENTIFIER
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

    -- Insert statements for procedure here
        SELECT  ProjectProgressReport_AttachDetailID ,
                FileType
        FROM    dbo.ProjectProgressReport_AttachDetail
        WHERE   ProjectProgressReportID = @MasterID
    END




GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectListIDProjectSurvey_AttachDetailByMasterID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Manh>
-- Create date: <01.04.18>
-- Description:	<Lấy về danh sách ID file đính kèm của Thông tin khảo sát>
-- =============================================
CREATE PROCEDURE [dbo].[Proc_SelectListIDProjectSurvey_AttachDetailByMasterID]
    @MasterID UNIQUEIDENTIFIER
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

    -- Insert statements for procedure here
        SELECT  ProjectSurvey_AttachDetailID ,
                FileType
        FROM    dbo.ProjectSurvey_AttachDetail
        WHERE   ID = @MasterID
    END




GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectListIDProjectWorkshop_AttachDetailByMasterID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Manh>
-- Create date: <01.04.18>
-- Description:	<Lấy về danh sách ID file đính kèm của Thông tin khảo sát>
-- =============================================
CREATE PROCEDURE [dbo].[Proc_SelectListIDProjectWorkshop_AttachDetailByMasterID]
    @MasterID UNIQUEIDENTIFIER
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

    -- Insert statements for procedure here
        SELECT  ProjectWorkshop_AttachDetailID ,
                FileType
        FROM    dbo.ProjectWorkshop_AttachDetail
        WHERE   ProjectWorkshopID = @MasterID
    END




GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectMeasurementStandardAll]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Proc_SelectMeasurementStandardAll]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[MeasurementStandardID],
	[Code],
	[FullName],
	[ShortName],
	[Description],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
FROM
	[dbo].[MeasurementStandard]

--endregion


GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectMedicalRecordAll]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Proc_SelectMedicalRecordAll]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	dbo.MedicalRecord.*,
	dbo.Customer.CustomerName
FROM
	[dbo].[MedicalRecord] LEFT JOIN dbo.Customer ON Customer.CustomerID = MedicalRecord.CustomerID

--endregion


GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectMedicalRecordPaging]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Proc_SelectMedicalRecordPaging]
	@sort NVARCHAR(255) ,
    @page INT ,
    @limit INT ,
    @where NVARCHAR(MAX) ,
    @columns NVARCHAR(1000) = '*' ,
    @totalCount INT OUTPUT
AS
BEGIN
        SET NOCOUNT ON
        
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
        IF ( @columns IS NULL
             OR LEN(@columns) = 0
           ) 
            SET @columns = '*'
        IF ( @sort IS NULL
             OR LEN(@sort) = 0
           ) 
            SET @sort = ' ModifiedDate DESC'
       
		declare @start int=1;

		set @start=(@page - 1) * @limit

		IF ( @where IS NOT NULL
			 AND LEN(@where) >0
		   ) 
			SET @where = ' WHERE ' + @where
		-- Lay ve totalCount
		DECLARE @totalCountSql NVARCHAR(MAX)= 'SELECT @totalCount=count(*) FROM dbo.MedicalRecord AS rec LEFT JOIN dbo.Customer AS cus ON cus.CustomerID = rec.CustomerID '
			+ @where

		EXEC sp_executesql @totalCountSql, N'@totalCount INT OUT', @totalCount OUT
		
		--Lay data
		DECLARE @sql NVARCHAR(MAX)= ' SELECT rec.*, cus.CustomerName FROM dbo.MedicalRecord AS rec LEFT JOIN dbo.Customer AS cus ON cus.CustomerID = rec.CustomerID '+@where+ ' ORDER BY '+@sort+' OFFSET '+ cast(@start as nvarchar(10))+' ROWS FETCH NEXT '+cast(@limit as nvarchar(10))+' ROWS ONLY'
		
		 
		EXEC sp_executesql @sql	
        
END

--endregion


GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectPositionAll]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectPositionAll]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   manh using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectPositionAll]
-- Date Generated: Thursday, July 19, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectPositionAll]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[PositionID],
	[PositionCode],
	[PositionName],
	[Description],
	[Inactive],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
FROM
	[dbo].[Position]

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectPositionAllByEditMode]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<dvthang>
-- Create date: <20.1.2018>
-- Description:	<Lấy danh sách chức vụ>
-- =============================================
CREATE PROCEDURE [dbo].[Proc_SelectPositionAllByEditMode] @editMode INT
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

        SELECT  PositionID ,
                PositionCode ,
                PositionName 
                 FROM dbo.Position
        WHERE   ( ( @editMode IN ( 1, 2 )
                    AND Inactive = 0
                  )
                  OR @editMode NOT	 IN ( 1, 2 )
                )
				ORDER BY SortOrder
    END




GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectPositionByID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectPositionByID]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   manh using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectPositionByID]
-- Date Generated: Thursday, July 19, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectPositionByID]
	@PositionID uniqueidentifier
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[PositionID],
	[PositionCode],
	[PositionName],
	[Description],
	[Inactive],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
FROM
	[dbo].[Position]
WHERE
	[PositionID] = @PositionID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectPositionPaging]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectProjectAcceptanceBasisPaging]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectPositionPaging]
-- Date Generated: 19 Tháng Chín 2017
------------------------------------------------------------------------------------------------------------------------
--[dbo].[Proc_SelectPositionPaging]'',1,50,'','*',0
CREATE PROCEDURE [dbo].[Proc_SelectPositionPaging]
	@sort NVARCHAR(255) ,
    @page INT ,
    @limit INT ,
    @where NVARCHAR(MAX) ,
    @columns NVARCHAR(1000) = '*' ,
    @totalCount INT OUTPUT
AS
BEGIN
        SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
        IF ( @columns IS NULL
             OR LEN(@columns) = 0
           ) 
            SET @columns = '*'
        IF ( @sort IS NULL
             OR LEN(@sort) = 0
           ) 
            SET @sort = ' ModifiedDate DESC'
       
	   declare @start int=1;

	   set @start=(@page - 1) * @limit

        IF ( @where <> '' ) 
            SET @where = ' WHERE ' + @where
		-- Lay ve totalCount
        DECLARE @totalCountSql NVARCHAR(MAX)= 'SELECT @totalCount=count(*) FROM [dbo].Position '
            + @where

        EXEC sp_executesql @totalCountSql, N'@totalCount INT OUT', @totalCount OUT
        
		--Lay data
        DECLARE @sql NVARCHAR(MAX)= ' SELECT *	FROM [dbo].Position '+@where+ ' ORDER BY '+@sort+' OFFSET '+ cast(@start as nvarchar(10))+' ROWS FETCH NEXT '+cast(@limit as nvarchar(10))+' ROWS ONLY'
        
         
        EXEC sp_executesql @sql	
END

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProject_AttachDetailAll]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectProject_AttachDetailAll]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   THANG using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectProject_AttachDetailAll]
-- Date Generated: Sunday, February 4, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectProject_AttachDetailAll]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[Project_AttachDetailID],
	[ProjectID],
	[Description],
	[FileName],
	[FileType],
	[FileSize],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
FROM
	[dbo].[Project_AttachDetail]

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProject_AttachDetailByID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectProject_AttachDetailByID]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   THANG using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectProject_AttachDetailByID]
-- Date Generated: Sunday, February 4, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectProject_AttachDetailByID]
	@Project_AttachDetailID uniqueidentifier
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[Project_AttachDetailID],
	[ProjectID],
	[Description],
	[FileName],
	[FileType],
	[FileSize],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
FROM
	[dbo].[Project_AttachDetail]
WHERE
	[Project_AttachDetailID] = @Project_AttachDetailID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProject_AttachDetailByMasterID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Proc_SelectProject_AttachDetailByMasterID]
    @masterId UNIQUEIDENTIFIER
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;
        SELECT  Project_AttachDetailID ,
                ProjectID ,
                Description ,
                FileName ,
                FileType ,
                FileSize ,
                SortOrder
        FROM    dbo.Project_AttachDetail
        WHERE   ProjectID = @masterId
    END




GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectAcceptanceBasic_AttachDetailAll]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectProjectAcceptanceBasic_AttachDetailAll]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectProjectAcceptanceBasic_AttachDetailAll]
-- Date Generated: 05 Tháng Hai 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectProjectAcceptanceBasic_AttachDetailAll]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[ProjectAcceptanceBasic_AttachDetailID],
	[ProjectAcceptanceBasicID],
	[Contents],
	[FileName],
	[FileType],
	[FileSize],
	[Inactive],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
FROM
	[dbo].[ProjectAcceptanceBasic_AttachDetail]

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectAcceptanceBasic_AttachDetailByID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectProjectAcceptanceBasic_AttachDetailByID]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectProjectAcceptanceBasic_AttachDetailByID]
-- Date Generated: 05 Tháng Hai 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectProjectAcceptanceBasic_AttachDetailByID]
	@ProjectAcceptanceBasic_AttachDetailID uniqueidentifier
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[ProjectAcceptanceBasic_AttachDetailID],
	[ProjectAcceptanceBasicID],
	[Contents],
	[FileName],
	[FileType],
	[FileSize],
	[Inactive],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
FROM
	[dbo].[ProjectAcceptanceBasic_AttachDetail]
WHERE
	[ProjectAcceptanceBasic_AttachDetailID] = @ProjectAcceptanceBasic_AttachDetailID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectAcceptanceBasic_AttachDetailByMasterID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Proc_SelectProjectAcceptanceBasic_AttachDetailByMasterID]
    @masterId UNIQUEIDENTIFIER
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;
        SELECT	ProjectAcceptanceBasic_AttachDetailID
				  ,ProjectAcceptanceBasicID
				  ,Contents
				  ,FileName
				  ,FileType
				  ,FileSize
				  ,Inactive
				  ,SortOrder
        FROM    dbo.ProjectAcceptanceBasic_AttachDetail
        WHERE   ProjectAcceptanceBasicID = @masterId
    END




GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectAcceptanceBasicByProjectID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Proc_SelectProjectAcceptanceBasicByProjectID]
	@ProjectID uniqueidentifier
AS
BEGIN
	SELECT * FROM ProjectAcceptanceBasic
	WHERE ProjectID = @ProjectID
END




GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectAcceptanceManage_AttachDetailAll]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectProjectAcceptanceManage_AttachDetailAll]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectProjectAcceptanceManage_AttachDetailAll]
-- Date Generated: 09 Tháng Hai 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectProjectAcceptanceManage_AttachDetailAll]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[ProjectAcceptanceManage_AttachDetailID],
	[ProjectAcceptanceManageID],
	[Contents],
	[FileName],
	[FileType],
	[FileSize],
	[Inactive],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
FROM
	[dbo].[ProjectAcceptanceManage_AttachDetail]

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectAcceptanceManage_AttachDetailByID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectProjectAcceptanceManage_AttachDetailByID]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectProjectAcceptanceManage_AttachDetailByID]
-- Date Generated: 09 Tháng Hai 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectProjectAcceptanceManage_AttachDetailByID]
	@ProjectAcceptanceManage_AttachDetailID uniqueidentifier
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[ProjectAcceptanceManage_AttachDetailID],
	[ProjectAcceptanceManageID],
	[Contents],
	[FileName],
	[FileType],
	[FileSize],
	[Inactive],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
FROM
	[dbo].[ProjectAcceptanceManage_AttachDetail]
WHERE
	[ProjectAcceptanceManage_AttachDetailID] = @ProjectAcceptanceManage_AttachDetailID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectAcceptanceManage_AttachDetailByMasterID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Proc_SelectProjectAcceptanceManage_AttachDetailByMasterID]
    @masterId UNIQUEIDENTIFIER
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;
        SELECT  ProjectAcceptanceManage_AttachDetailID
				,ProjectAcceptanceManageID
				,Contents
				,FileName
				,FileType
				,FileSize
				,Inactive
				,SortOrder
        FROM    dbo.ProjectAcceptanceManage_AttachDetail
        WHERE   ProjectAcceptanceManageID = @masterId
    END




GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectAcceptanceManageByProjectID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Proc_SelectProjectAcceptanceManageByProjectID]
	@ProjectID uniqueidentifier
AS
BEGIN
	SELECT [ProjectAcceptanceManageID]
      ,[ProjectID]
      ,[EstablishedDate]
      ,[MeetingDate]
      ,[Status] FROM ProjectAcceptanceManage
	WHERE ProjectID = @ProjectID
END




GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectAll]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectProjectAll]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   THANG using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectProjectAll]
-- Date Generated: Sunday, January 28, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectProjectAll]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[ProjectID],
	[ProjectCode],
	[ProjectName],
	[ProjectNameAbbreviation],
	[StartDate],
	[EndDate],
	[CompanyID],
	[EmployeeID],
	[Amount],
	[Amount_Level1],
	[Amount_Level2],
	[Amount_Other],
	[Program],
	[ProgramName],
	[ProjectScience],
	[ProjectScienceName],
	[IndependentTopic],
	[Nature],
	[AFF],
	[Technical],
	[Pharmacy],
	[Result],
	[CompanyApply],
	[Description],
	[Status],
	[LevelID],
	[ProjectChairman],
	[ProjectSecretary],
	[ProjectCompanyChair],
	[ProjectMember],
	[ProjectCompanyCombination],
	[Inactive],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
FROM
	[dbo].[Project]

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectAllByEditMode]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<dvthang>
-- Create date: <20.1.2018>
-- Description:	<Lấy về danh sách đề tài>
-- =============================================
CREATE PROCEDURE [dbo].[Proc_SelectProjectAllByEditMode] @editMode INT
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

        SELECT  ProjectID ,
                ProjectCode ,
                ProjectName,
				ProjectNameAbbreviation
                 FROM dbo.Project
        WHERE   ( ( @editMode IN ( 1, 2 )
                    AND Inactive = 0
                  )
                  OR @editMode NOT	 IN ( 1, 2 )
                )
				ORDER BY SortOrder
    END
	-- Proc_SelectProjectAllByEditMode 0




GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectByEmployee]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<manh>
-- Create date: <03.05.18>
-- Description:	<Lấy đề tài theo người chủ nhiệm đề tài>
-- [dbo].[Proc_SelectProjectByEmployee] 'huynhdx'
-- =============================================
CREATE PROCEDURE [dbo].[Proc_SelectProjectByEmployee]
	-- Add the parameters for the stored procedure here
    @CreatedBy NVARCHAR(128)
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

    -- Insert statements for procedure here
        SELECT  *
        FROM    dbo.Project
        WHERE   CreatedBy = @CreatedBy
    END




GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectByID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectProjectByID]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   THANG using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectProjectByID]
-- Date Generated: Sunday, January 28, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectProjectByID]
	@ProjectID uniqueidentifier
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[ProjectID],
	[ProjectCode],
	[ProjectName],
	[ProjectNameAbbreviation],
	[StartDate],
	[EndDate],
	[CompanyID],
	[EmployeeID],
	[Amount],
	[Amount_Level1],
	[Amount_Level2],
	[Amount_Other],
	[Program],
	[ProgramName],
	[ProjectScience],
	[ProjectScienceName],
	[IndependentTopic],
	[Nature],
	[AFF],
	[Technical],
	[Pharmacy],
	[Result],
	[CompanyApply],
	[Description],
	[Status],
	[LevelID],
	[ProjectChairman],
	[ProjectSecretary],
	[ProjectCompanyChair],
	[ProjectMember],
	[ProjectCompanyCombination],
	[Inactive],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
FROM
	[dbo].[Project]
WHERE
	[ProjectID] = @ProjectID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectByMasterID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<dvthang>
-- Create date: <27.02.2018>
-- Description:	<Lấy về thông tin chi tiết của đề tài>
-- =============================================

CREATE PROCEDURE [dbo].[Proc_SelectProjectByMasterID]
    @masterId UNIQUEIDENTIFIER
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;
        SELECT  C.ProjectID ,
                C.ProjectCode ,
                C.ProjectName ,
				C.ProjectNameAbbreviation,
                C.StartDate ,
                C.EndDate ,
                C.CompanyID ,
                C.EmployeeID ,
                C.Amount ,
                C.Amount_Level1 ,
                C.Amount_Level2 ,
                C.Amount_Other ,
                C.Program ,
                C.ProgramName ,
                C.ProjectScience ,
                C.ProjectScienceName ,
                C.IndependentTopic ,
                C.Nature ,
                C.AFF ,
                C.Technical ,
                C.Pharmacy ,
                C.Result ,
                C.CompanyApply ,
                C.Description ,
                C.Status ,
                C.LevelID ,
                C.ProjectChairman ,
                C.ProjectSecretary ,
                C.ProjectMember ,
                C.ProjectCompanyChair ,
                C.ProjectCompanyCombination ,
                C.Inactive ,
                C.SortOrder ,
                C.EmployeeName 
        FROM    dbo.View_Project C
        WHERE   ProjectID = @masterId
    END




GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectClose_AttachDetailByID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectProjectClose_AttachDetailByID]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectProjectClose_AttachDetailByID]
-- Date Generated: 09 Tháng Hai 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectProjectClose_AttachDetailByID]
	@ProjectClose_AttachDetailID uniqueidentifier
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	*
FROM
	[dbo].[ProjectClose_AttachDetail]
WHERE
	[ProjectClose_AttachDetailID] = @ProjectClose_AttachDetailID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectClose_AttachDetailByMasterID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Proc_SelectProjectClose_AttachDetailByMasterID]
    @masterId UNIQUEIDENTIFIER
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;
        SELECT	*
        FROM    dbo.ProjectClose_AttachDetail
        WHERE   ProjectCloseID = @masterId
    END




GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectCloseByMasterID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Proc_SelectProjectCloseByMasterID]
	@masterId uniqueidentifier
AS
BEGIN
	SELECT [ProjectCloseID]
      ,[ProjectID]
      ,[Date]
      ,[LiquidationDate]
      ,[FileName]
      ,[FileType]
      ,[FileSize] FROM ProjectClose
	WHERE ProjectID = @masterId
END




GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectCloseByProjectID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Proc_SelectProjectCloseByProjectID]
	@masterID uniqueidentifier
AS
BEGIN
	SELECT [ProjectCloseID]
      ,[ProjectID]
      ,[Date]
      ,[LiquidationDate]
      ,[FileName]
      ,[FileType]
      ,[FileSize] FROM ProjectClose
	WHERE ProjectID = @masterID
END




GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectClosePaging]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectProjectAcceptanceBasisPaging]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectProjectAcceptanceBasisPaging]
-- Date Generated: 19 Tháng Chín 2017
------------------------------------------------------------------------------------------------------------------------
--[dbo].[Proc_SelectProjectClosePaging]'',1,50,'','*',0
CREATE PROCEDURE [dbo].[Proc_SelectProjectClosePaging]
	@sort NVARCHAR(255) ,
    @page INT ,
    @limit INT ,
    @where NVARCHAR(MAX) ,
    @columns NVARCHAR(1000) = '*' ,
    @totalCount INT OUTPUT
AS
BEGIN
        SET NOCOUNT ON
        SET TRANSACTION ISOLATION LEVEL READ COMMITTED
        IF ( @columns IS NULL
             OR LEN(@columns) = 0
           ) 
            SET @columns = '*'
        IF ( @sort IS NULL
             OR LEN(@sort) = 0
           ) 
            SET @sort = ' ModifiedDate DESC'
       
		declare @start int=1;

		set @start=(@page - 1) * @limit

		IF ( @where IS NOT NULL
			 AND LEN(@where) >0
		   ) 
			SET @where = ' WHERE ' + @where
		-- Lay ve totalCount
		DECLARE @totalCountSql NVARCHAR(MAX)= 'SELECT @totalCount=count(*) FROM [dbo].ProjectClose '
			+ @where

		EXEC sp_executesql @totalCountSql, N'@totalCount INT OUT', @totalCount OUT
		
		--Lay data
		DECLARE @sql NVARCHAR(MAX)= ' SELECT *	FROM [dbo].ProjectClose '+@where+ ' ORDER BY '+@sort+' OFFSET '+ cast(@start as nvarchar(10))+' ROWS FETCH NEXT '+cast(@limit as nvarchar(10))+' ROWS ONLY'
		
		 
		EXEC sp_executesql @sql	
END

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectExperiment_AttachDetailAll]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectProjectExperiment_AttachDetailAll]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   Admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectProjectExperiment_AttachDetailAll]
-- Date Generated: Sunday, February 25, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectProjectExperiment_AttachDetailAll]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[ProjectExperiment_AttachDetailID],
	[ID],
	[FileName],
	[FileType],
	[FileSize],
	[Description],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
FROM
	[dbo].[ProjectExperiment_AttachDetail]

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectExperiment_AttachDetailByID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectProjectExperiment_AttachDetailByID]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   Admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectProjectExperiment_AttachDetailByID]
-- Date Generated: Sunday, February 25, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectProjectExperiment_AttachDetailByID]
	@ProjectExperiment_AttachDetailID uniqueidentifier
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[ProjectExperiment_AttachDetailID],
	[ID],
	[FileName],
	[FileType],
	[FileSize],
	[Description],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
FROM
	[dbo].[ProjectExperiment_AttachDetail]
WHERE
	[ProjectExperiment_AttachDetailID] = @ProjectExperiment_AttachDetailID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectExperiment_AttachDetailByMasterID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<manh>
-- Create date: <24.02.2018>
-- Description:	<Lấy danh sách tệp nội dung thử nghiệm>
-- =============================================
CREATE PROCEDURE [dbo].[Proc_SelectProjectExperiment_AttachDetailByMasterID]
    @masterId UNIQUEIDENTIFIER
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;
        SELECT  
                ProjectExperiment_AttachDetailID ,
                ID ,
                FileName ,
                FileType ,
                FileSize ,
                SortOrder ,
				Description               
        FROM    dbo.ProjectExperiment_AttachDetail
        WHERE   ID = @masterId
		ORDER BY SortOrder
    END




GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectExperimentAll]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectProjectExperimentAll]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   Admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectProjectExperimentAll]
-- Date Generated: Sunday, February 25, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectProjectExperimentAll]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[ProjectExperimentID],
	[ProjectID],
	[FileName],
	[FileType],
	[FileSize],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
FROM
	[dbo].[ProjectExperiment]

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectExperimentByID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectProjectExperimentByID]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   Admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectProjectExperimentByID]
-- Date Generated: Sunday, February 25, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectProjectExperimentByID]
	@ProjectExperimentID uniqueidentifier
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[ProjectExperimentID],
	[ProjectID],
	[FileName],
	[FileType],
	[FileSize],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
FROM
	[dbo].[ProjectExperiment]
WHERE
	[ProjectExperimentID] = @ProjectExperimentID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectExperimentByMasterID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectProjectExperimentByID]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   manh using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectProjectExperimentByID]
-- Date Generated: Sunday, January 28, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectProjectExperimentByMasterID]
	@MasterID uniqueidentifier
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[ProjectExperimentID],
	[ProjectID],
	[FileName],
	[FileType],
	[FileSize]
FROM
	[dbo].[ProjectExperiment]
WHERE
	[ProjectID] = @MasterID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectExperimentPaging]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectProjectAcceptanceBasisPaging]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectProjectAcceptanceBasisPaging]
-- Date Generated: 19 Tháng Chín 2017
------------------------------------------------------------------------------------------------------------------------
--[dbo].[Proc_SelectProjectExperimentPaging]'',1,50,'','*',0
CREATE PROCEDURE [dbo].[Proc_SelectProjectExperimentPaging]
	@sort NVARCHAR(255) ,
    @page INT ,
    @limit INT ,
    @where NVARCHAR(MAX) ,
    @columns NVARCHAR(1000) = '*' ,
    @totalCount INT OUTPUT
AS
BEGIN
        SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
        IF ( @columns IS NULL
             OR LEN(@columns) = 0
           ) 
            SET @columns = '*'
        IF ( @sort IS NULL
             OR LEN(@sort) = 0
           ) 
            SET @sort = ' ModifiedDate DESC'
       
	   declare @start int=1;

	   set @start=(@page - 1) * @limit

        IF ( @where <> '' ) 
            SET @where = ' WHERE ' + @where
		-- Lay ve totalCount
        DECLARE @totalCountSql NVARCHAR(MAX)= 'SELECT @totalCount=count(*) FROM [dbo].ProjectExperiment '
            + @where

        EXEC sp_executesql @totalCountSql, N'@totalCount INT OUT', @totalCount OUT
        
		--Lay data
        DECLARE @sql NVARCHAR(MAX)= ' SELECT *	FROM [dbo].ProjectExperiment '+@where+ ' ORDER BY '+@sort+' OFFSET '+ cast(@start as nvarchar(10))+' ROWS FETCH NEXT '+cast(@limit as nvarchar(10))+' ROWS ONLY'
        
         
        EXEC sp_executesql @sql	
END

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectMemberAll]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectProjectMemberAll]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   truong using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectProjectMemberAll]
-- Date Generated: Sunday, January 28, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectProjectMemberAll]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[ProjectMemberID],
	[ProjectID],
	[EmployeeID],
	[FullName],
	[StartDate],
	[EndDate],
	[MonthForProject],
	[ProjectPositionID],
	[Inactive],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
FROM
	[dbo].[ProjectMember]

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectMemberByID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectProjectMemberByID]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   truong using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectProjectMemberByID]
-- Date Generated: Sunday, January 28, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectProjectMemberByID]
	@ProjectMemberID uniqueidentifier
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[ProjectMemberID],
	[ProjectID],
	[EmployeeID],
	[FullName],
	[StartDate],
	[EndDate],
	[MonthForProject],
	[ProjectPositionID],
	[Inactive],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
FROM
	[dbo].[ProjectMember]
WHERE
	[ProjectMemberID] = @ProjectMemberID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectMemberByMasterID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectProjectMemberByID]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   truong using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectProjectMemberByID]
-- Date Generated: Sunday, January 28, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectProjectMemberByMasterID]
	@MasterID uniqueidentifier
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT View_ProjectMember.*, ROW_NUMBER() OVER(ORDER BY ProjectPosition.SortOrder ASC) AS Rownum
	FROM   	[dbo].[View_ProjectMember]
	left join ProjectPosition on View_ProjectMember.ProjectPositionID = ProjectPosition.ProjectPositionID
WHERE
	[ProjectID] = @MasterID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectMemberPaging]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectProjectMemberPaging]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   truong using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectProjectMemberPaging]
-- Date Generated: Sunday, January 28, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectProjectMemberPaging]
	@sort NVARCHAR(255) ,
    @start INT ,
    @limit INT ,
    @where NVARCHAR(MAX) ,
    @columns NVARCHAR(1000) = '*' ,
    @totalCount INT OUTPUT
AS
BEGIN
        SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
        DECLARE @orderbyColumn NVARCHAR(MAX)
        DECLARE @wherePaging NVARCHAR(MAX)

        IF ( @columns IS NULL
             OR LEN(@columns) = 0
           ) 
            SET @columns = '*'
        IF ( @sort IS NULL
             OR LEN(@sort) = 0
           ) 
            SET @sort = ' ModifiedDate DESC'
        SET @wherePaging = ''

        IF ( @sort <> ''
             AND NOT @sort IS NULL
           ) 
            SET @orderbyColumn = 'ROW_NUMBER() OVER (ORDER BY ' + @sort
                + ') AS Rownum, '
        ELSE 
            SET @orderbyColumn = ' NULL AS Rownum,'
        IF ( @limit > 0 ) 
            BEGIN
                SET @wherePaging = ' WHERE temp.Rownum between '
                    + CONVERT(NVARCHAR(16), ( @start + 1 )) + ' AND '
                    + CONVERT(NVARCHAR(16), ( @start + @limit ))
            END     
			
        IF ( @where <> '' ) 
            SET @where = ' WHERE ' + @where
		-- Lay ve totalCount
        DECLARE @totalCountSql NVARCHAR(MAX)= 'SELECT @totalCount=count(*) FROM [dbo].ProjectMember '
            + @where

        EXEC sp_executesql @totalCountSql, N'@totalCount INT OUT', @totalCount OUT
        
		--Lay data
        DECLARE @sql NVARCHAR(MAX)= ' SELECT ' + @columns + '
		FROM (SELECT ' + @orderbyColumn + ' * FROM [dbo].ProjectMember ' + @where
            + ') as TEMP' + @wherePaging
        
         
        EXEC sp_executesql @sql	
END

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectPaging]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectProjectAcceptanceBasisPaging]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectProjectAcceptanceBasisPaging]
-- Date Generated: 19 Tháng Chín 2017
------------------------------------------------------------------------------------------------------------------------
--[dbo].[Proc_SelectRankPaging]'',1,50,'','*',0
CREATE PROCEDURE [dbo].[Proc_SelectProjectPaging]
	@sort NVARCHAR(255) ,
    @page INT ,
    @limit INT ,
    @where NVARCHAR(MAX) ,
    @columns NVARCHAR(1000) = '*' ,
    @totalCount INT OUTPUT
AS
BEGIN
        SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
        IF ( @columns IS NULL
             OR LEN(@columns) = 0
           ) 
            SET @columns = '*'
        IF ( @sort IS NULL
             OR LEN(@sort) = 0
           ) 
            SET @sort = ' ProjectCode DESC'
       
	   declare @start int=1;

	   set @start=(@page - 1) * @limit

        IF ( @where <> '' ) 
            SET @where = ' WHERE ' + @where
		-- Lay ve totalCount
        DECLARE @totalCountSql NVARCHAR(MAX)= 'SELECT @totalCount=count(*) FROM [dbo].View_Project '
            + @where

        EXEC sp_executesql @totalCountSql, N'@totalCount INT OUT', @totalCount OUT
        
		--Lay data
        DECLARE @sql NVARCHAR(MAX)= ' SELECT *	FROM [dbo].View_Project '+@where+ ' ORDER BY '+@sort+' OFFSET '+ cast(@start as nvarchar(10))+' ROWS FETCH NEXT '+cast(@limit as nvarchar(10))+' ROWS ONLY'
        
         
        EXEC sp_executesql @sql	
END

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectPlanExpense_AttachDetailAll]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectProjectPlanExpense_AttachDetailAll]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectProjectPlanExpense_AttachDetailAll]
-- Date Generated: 14 Tháng Giêng 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectProjectPlanExpense_AttachDetailAll]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[ProjectPlanExpense_AttachDetailID],
	[ProjectPlanExpenseID],
	[FileName],
	[FileType],
	[Description],
	[FileSize],
	[Inactive],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
FROM
	[dbo].[ProjectPlanExpense_AttachDetail]

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectPlanExpense_AttachDetailByID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Proc_SelectProjectPlanExpense_AttachDetailByID]
	@ProjectPlanExpense_AttachDetailID uniqueidentifier
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[ProjectPlanExpense_AttachDetailID],
	[ProjectPlanExpenseID],
	[FileName],
	[FileType],
	[FileSize],
	[Description],
	[Inactive],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
FROM
	[dbo].[ProjectPlanExpense_AttachDetail]
WHERE
	[ProjectPlanExpense_AttachDetailID] = @ProjectPlanExpense_AttachDetailID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectPlanExpense_AttachDetailByMasterID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Proc_SelectProjectPlanExpense_AttachDetailByMasterID]
    @masterId UNIQUEIDENTIFIER
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;
        SELECT *
        FROM    dbo.ProjectPlanExpense_AttachDetail
        WHERE   ProjectPlanExpenseID = @masterId
    END




GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectPlanExpense_AttachDetailPaging]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectProjectAcceptanceBasisPaging]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectProjectAcceptanceBasisPaging]
-- Date Generated: 19 Tháng Chín 2017
------------------------------------------------------------------------------------------------------------------------
--[dbo].[Proc_SelectRankPaging]'',1,50,'','*',0
CREATE PROCEDURE [dbo].[Proc_SelectProjectPlanExpense_AttachDetailPaging]
	@sort NVARCHAR(255) ,
    @page INT ,
    @limit INT ,
    @where NVARCHAR(MAX) ,
    @columns NVARCHAR(1000) = '*' ,
    @totalCount INT OUTPUT
AS
BEGIN
        SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
        IF ( @columns IS NULL
             OR LEN(@columns) = 0
           ) 
            SET @columns = '*'
        IF ( @sort IS NULL
             OR LEN(@sort) = 0
           ) 
            SET @sort = ' ModifiedDate DESC'
       
	   declare @start int=1;

	   set @start=(@page - 1) * @limit

        IF ( @where <> '' ) 
            SET @where = ' WHERE ' + @where
		-- Lay ve totalCount
        DECLARE @totalCountSql NVARCHAR(MAX)= 'SELECT @totalCount=count(*) FROM [dbo].View_ProjectPlanExpense_AttachDetail '
            + @where

        EXEC sp_executesql @totalCountSql, N'@totalCount INT OUT', @totalCount OUT
        
		--Lay data
        DECLARE @sql NVARCHAR(MAX)= ' SELECT *	FROM [dbo].View_ProjectPlanExpense_AttachDetail '+@where+ ' ORDER BY '+@sort+' OFFSET '+ cast(@start as nvarchar(10))+' ROWS FETCH NEXT '+cast(@limit as nvarchar(10))+' ROWS ONLY'
        
         
        EXEC sp_executesql @sql	
END

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectPlanExpenseAll]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectProjectPlanExpenseAll]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   truong using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectProjectPlanExpenseAll]
-- Date Generated: Sunday, January 28, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectProjectPlanExpenseAll]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[ProjectPlanExpenseID],
	[ProjectID],
	[Number],
	[Date],
	[Amount],
	[Inactive],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
FROM
	[dbo].[ProjectPlanExpense]

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectPlanExpenseByID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectProjectPlanExpenseByID]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   truong using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectProjectPlanExpenseByID]
-- Date Generated: Sunday, January 28, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectProjectPlanExpenseByID]
	@ProjectPlanExpenseID uniqueidentifier
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[ProjectPlanExpenseID],
	[ProjectID],
	[Number],
	[Date],
	[Amount],
	[Inactive],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
FROM
	[dbo].[ProjectPlanExpense]
WHERE
	[ProjectPlanExpenseID] = @ProjectPlanExpenseID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectPlanExpenseByMasterID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectProjectPlanExpenseByID]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   truong using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectProjectPlanExpenseByID]
-- Date Generated: Sunday, January 28, 2018
------------------------------------------------------------------------------------------------------------------------

create PROCEDURE [dbo].[Proc_SelectProjectPlanExpenseByMasterID]
	@MasterID uniqueidentifier
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[ProjectPlanExpenseID],
	[ProjectID],
	[Number],
	[Date],
	[Amount],
	[Inactive],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
FROM
	[dbo].[ProjectPlanExpense]
WHERE
	[ProjectID] = @MasterID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectPlanExpensePaging]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectProjectPlanExpensePaging]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   truong using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectProjectPlanExpensePaging]
-- Date Generated: Sunday, January 28, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectProjectPlanExpensePaging]
	@sort NVARCHAR(255) ,
    @start INT ,
    @limit INT ,
    @where NVARCHAR(MAX) ,
    @columns NVARCHAR(1000) = '*' ,
    @totalCount INT OUTPUT
AS
BEGIN
        SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
        DECLARE @orderbyColumn NVARCHAR(MAX)
        DECLARE @wherePaging NVARCHAR(MAX)

        IF ( @columns IS NULL
             OR LEN(@columns) = 0
           ) 
            SET @columns = '*'
        IF ( @sort IS NULL
             OR LEN(@sort) = 0
           ) 
            SET @sort = ' ModifiedDate DESC'
        SET @wherePaging = ''

        IF ( @sort <> ''
             AND NOT @sort IS NULL
           ) 
            SET @orderbyColumn = 'ROW_NUMBER() OVER (ORDER BY ' + @sort
                + ') AS Rownum, '
        ELSE 
            SET @orderbyColumn = ' NULL AS Rownum,'
        IF ( @limit > 0 ) 
            BEGIN
                SET @wherePaging = ' WHERE temp.Rownum between '
                    + CONVERT(NVARCHAR(16), ( @start + 1 )) + ' AND '
                    + CONVERT(NVARCHAR(16), ( @start + @limit ))
            END     
			
        IF ( @where <> '' ) 
            SET @where = ' WHERE ' + @where
		-- Lay ve totalCount
        DECLARE @totalCountSql NVARCHAR(MAX)= 'SELECT @totalCount=count(*) FROM [dbo].ProjectPlanExpense '
            + @where

        EXEC sp_executesql @totalCountSql, N'@totalCount INT OUT', @totalCount OUT
        
		--Lay data
        DECLARE @sql NVARCHAR(MAX)= ' SELECT ' + @columns + '
		FROM (SELECT ' + @orderbyColumn + ' * FROM [dbo].ProjectPlanExpense ' + @where
            + ') as TEMP' + @wherePaging
        
         
        EXEC sp_executesql @sql	
END

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectPlanPerform_AttachDetailAll]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectProjectPlanPerform_AttachDetailAll]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   truong using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectProjectPlanPerform_AttachDetailAll]
-- Date Generated: Sunday, February 11, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectProjectPlanPerform_AttachDetailAll]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[ProjectPlanPerform_AttachDetailID],
	[ProjectPlanPerformID],
	[FileName],
	[FileType],
	[FileSize],
	[Inactive],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
FROM
	[dbo].[ProjectPlanPerform_AttachDetail]

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectPlanPerform_AttachDetailByID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectProjectPlanPerform_AttachDetailByID]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   truong using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectProjectPlanPerform_AttachDetailByID]
-- Date Generated: Sunday, February 11, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectProjectPlanPerform_AttachDetailByID]
	@ProjectPlanPerform_AttachDetailID uniqueidentifier
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[ProjectPlanPerform_AttachDetailID],
	[ProjectPlanPerformID],
	[FileName],
	[FileType],
	[Description],
	[FileSize],
	[Inactive],
	[SortOrder]
FROM
	[dbo].[ProjectPlanPerform_AttachDetail]
WHERE
	[ProjectPlanPerform_AttachDetailID] = @ProjectPlanPerform_AttachDetailID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectPlanPerform_AttachDetailByMasterID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Proc_SelectProjectPlanPerform_AttachDetailByMasterID]
    @masterId UNIQUEIDENTIFIER
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;
        SELECT [ProjectPlanPerform_AttachDetailID],
	[ProjectPlanPerformID],
	[FileName],
	[FileType],
	[Description],
	[FileSize],
	[Inactive],
	[SortOrder]
        FROM    dbo.ProjectPlanPerform_AttachDetail
        WHERE   ProjectPlanPerformID = @masterId
    END




GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectPlanPerform_AttachDetailPaging]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectProjectAcceptanceBasisPaging]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectProjectAcceptanceBasisPaging]
-- Date Generated: 19 Tháng Chín 2017
------------------------------------------------------------------------------------------------------------------------
--[dbo].[Proc_SelectProjectPlanPerform_AttachDetailPaging]'',1,50,'','*',0
CREATE PROCEDURE [dbo].[Proc_SelectProjectPlanPerform_AttachDetailPaging]
	@sort NVARCHAR(255) ,
    @page INT ,
    @limit INT ,
    @where NVARCHAR(MAX) ,
    @columns NVARCHAR(1000) = '*' ,
    @totalCount INT OUTPUT
AS
BEGIN
        SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
        IF ( @columns IS NULL
             OR LEN(@columns) = 0
           ) 
            SET @columns = '*'
        IF ( @sort IS NULL
             OR LEN(@sort) = 0
           ) 
            SET @sort = ' ModifiedDate DESC'
       
	   declare @start int=1;

	   set @start=(@page - 1) * @limit

        IF ( @where <> '' ) 
            SET @where = ' WHERE ' + @where
		-- Lay ve totalCount
        DECLARE @totalCountSql NVARCHAR(MAX)= 'SELECT @totalCount=count(*) FROM [dbo].View_ProjectPlanPerform_AttachDetail '
            + @where

        EXEC sp_executesql @totalCountSql, N'@totalCount INT OUT', @totalCount OUT
        
		--Lay data
        DECLARE @sql NVARCHAR(MAX)= ' SELECT *	FROM [dbo].View_ProjectPlanPerform_AttachDetail '+@where+ ' ORDER BY '+@sort+' OFFSET '+ cast(@start as nvarchar(10))+' ROWS FETCH NEXT '+cast(@limit as nvarchar(10))+' ROWS ONLY'
        
         
        EXEC sp_executesql @sql	
END

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectPlanPerformAll]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectProjectPlanPerformAll]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   Phamlai using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectProjectPlanPerformAll]
-- Date Generated: Monday, January 29, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectProjectPlanPerformAll]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[ProjectPlanPerformID],
	[ProjectID],
	[Number],
	[Date],
	[Inactive],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
FROM
	[dbo].[ProjectPlanPerform]

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectPlanPerformByID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectProjectPlanPerformByID]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   Phamlai using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectProjectPlanPerformByID]
-- Date Generated: Monday, January 29, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectProjectPlanPerformByID]
	@ProjectPlanPerformID uniqueidentifier
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[ProjectPlanPerformID],
	[ProjectID],
	[Number],
	[Date],
	[Inactive],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy],
	[IdFiles]
FROM
	[dbo].[View_ProjectPlanPerform]
WHERE
	[ProjectPlanPerformID] = @ProjectPlanPerformID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectPlanPerformByMasterID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectProjectPlanPerformByID]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   Phamlai using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectProjectPlanPerformByID]
-- Date Generated: Monday, January 29, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectProjectPlanPerformByMasterID]
	@MasterID uniqueidentifier
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[ProjectPlanPerformID],
	[ProjectID],
	[Number],
	[Date],
	[Inactive],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy],
	[IdFiles]
FROM
	[dbo].[View_ProjectPlanPerform]
WHERE
	[ProjectID] = @MasterID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectPlanPerformPaging]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectProjectPlanPerformPaging]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   truong using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectProjectPlanPerformPaging]
-- Date Generated: Sunday, January 28, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectProjectPlanPerformPaging]
	@sort NVARCHAR(255) ,
    @start INT ,
    @limit INT ,
    @where NVARCHAR(MAX) ,
    @columns NVARCHAR(1000) = '*' ,
    @totalCount INT OUTPUT
AS
BEGIN
        SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
        DECLARE @orderbyColumn NVARCHAR(MAX)
        DECLARE @wherePaging NVARCHAR(MAX)

        IF ( @columns IS NULL
             OR LEN(@columns) = 0
           ) 
            SET @columns = '*'
        IF ( @sort IS NULL
             OR LEN(@sort) = 0
           ) 
            SET @sort = ' ModifiedDate DESC'
        SET @wherePaging = ''

        IF ( @sort <> ''
             AND NOT @sort IS NULL
           ) 
            SET @orderbyColumn = 'ROW_NUMBER() OVER (ORDER BY ' + @sort
                + ') AS Rownum, '
        ELSE 
            SET @orderbyColumn = ' NULL AS Rownum,'
        IF ( @limit > 0 ) 
            BEGIN
                SET @wherePaging = ' WHERE temp.Rownum between '
                    + CONVERT(NVARCHAR(16), ( @start + 1 )) + ' AND '
                    + CONVERT(NVARCHAR(16), ( @start + @limit ))
            END     
			
        IF ( @where <> '' ) 
            SET @where = ' WHERE ' + @where
		-- Lay ve totalCount
        DECLARE @totalCountSql NVARCHAR(MAX)= 'SELECT @totalCount=count(*) FROM [dbo].View_ProjectPlanPerform '
            + @where

        EXEC sp_executesql @totalCountSql, N'@totalCount INT OUT', @totalCount OUT
        
		--Lay data
        DECLARE @sql NVARCHAR(MAX)= ' SELECT ' + @columns + '
		FROM (SELECT ' + @orderbyColumn + ' * FROM [dbo].View_ProjectPlanPerform ' + @where
            + ') as TEMP' + @wherePaging
        
         
        EXEC sp_executesql @sql	
END

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectPositionAll]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectProjectPostionAll]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectProjectPostionAll]
-- Date Generated: 14 Tháng Giêng 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectProjectPositionAll]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[ProjectPositionID],
	[ProjectPositionCode],
	[ProjectPositionName],
	[ProjectPositionShortName],
	[Coefficient],
	[Description],
	[Inactive],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
FROM
	[dbo].[ProjectPosition]

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectPositionAllByEditMode]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<dvthang>
-- Create date: <20.1.2018>
-- Description:	<Lấy danh sách chức vụ>
-- =============================================
CREATE PROCEDURE [dbo].[Proc_SelectProjectPositionAllByEditMode] @editMode INT
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

        SELECT  ProjectPositionID ,
                ProjectPositionCode ,
                ProjectPositionName 
                 FROM dbo.ProjectPosition
        WHERE   ( ( @editMode IN ( 1, 2 )
                    AND Inactive = 0
                  )
                  OR @editMode NOT	 IN ( 1, 2 )
                )
				ORDER BY SortOrder
    END
	-- Proc_SelectProjectPositionAllByEditMode 0



GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectPositionByID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectProjectPostionByID]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectProjectPostionByID]
-- Date Generated: 14 Tháng Giêng 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectProjectPositionByID]
	@ProjectPositionID uniqueidentifier
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[ProjectPositionID],
	[ProjectPositionCode],
	[ProjectPositionName],
	[ProjectPositionShortName],
	[Coefficient],
	[Description],
	[Inactive],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
FROM
	[dbo].[ProjectPosition]
WHERE
	[ProjectPositionID] = @ProjectPositionID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectPositionPaging]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectProjectAcceptanceBasisPaging]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectProjectAcceptanceBasisPaging]
-- Date Generated: 19 Tháng Chín 2017
------------------------------------------------------------------------------------------------------------------------
--[dbo].[Proc_SelectRankPaging]'',1,50,'','*',0
CREATE PROCEDURE [dbo].[Proc_SelectProjectPositionPaging]
	@sort NVARCHAR(255) ,
    @page INT ,
    @limit INT ,
    @where NVARCHAR(MAX) ,
    @columns NVARCHAR(1000) = '*' ,
    @totalCount INT OUTPUT
AS
BEGIN
        SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
        IF ( @columns IS NULL
             OR LEN(@columns) = 0
           ) 
            SET @columns = '*'
        IF ( @sort IS NULL
             OR LEN(@sort) = 0
           ) 
            SET @sort = ' SortOrder ASC'
       
	   declare @start int=1;

	   set @start=(@page - 1) * @limit

        IF ( @where <> '' ) 
            SET @where = ' WHERE ' + @where
		-- Lay ve totalCount
        DECLARE @totalCountSql NVARCHAR(MAX)= 'SELECT @totalCount=count(*) FROM [dbo].ProjectPosition '
            + @where

        EXEC sp_executesql @totalCountSql, N'@totalCount INT OUT', @totalCount OUT
        
		--Lay data
        DECLARE @sql NVARCHAR(MAX)= ' SELECT *	FROM [dbo].ProjectPosition '+@where+ ' ORDER BY '+@sort+' OFFSET '+ cast(@start as nvarchar(10))+' ROWS FETCH NEXT '+cast(@limit as nvarchar(10))+' ROWS ONLY'
        
         
        EXEC sp_executesql @sql	
END

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectPresentProtected_AttachDetailAll]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectProjectPresentProtected_AttachDetailAll]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectProjectPresentProtected_AttachDetailAll]
-- Date Generated: 14 Tháng Giêng 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectProjectPresentProtected_AttachDetailAll]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[ProjectPresentProtected_AttachDetailID],
	[ProjectPresentProtectedID],
	[FileName],
	[FileType],
	[FileSize],
	[Inactive],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
FROM
	[dbo].[ProjectPresentProtected_AttachDetail]

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectPresentProtected_AttachDetailByID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectProjectPresentProtected_AttachDetailByID]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectProjectPresentProtected_AttachDetailByID]
-- Date Generated: 14 Tháng Giêng 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectProjectPresentProtected_AttachDetailByID]
	@ProjectPresentProtected_AttachDetailID uniqueidentifier
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[ProjectPresentProtected_AttachDetailID],
	[ProjectPresentProtectedID],
	[FileName],
	[FileType],
	[FileSize],
	[Inactive],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
FROM
	[dbo].[ProjectPresentProtected_AttachDetail]
WHERE
	[ProjectPresentProtected_AttachDetailID] = @ProjectPresentProtected_AttachDetailID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectPresentProtected_AttachDetailPaging]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectProjectAcceptanceBasisPaging]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectProjectAcceptanceBasisPaging]
-- Date Generated: 19 Tháng Chín 2017
------------------------------------------------------------------------------------------------------------------------
--[dbo].[Proc_SelectRankPaging]'',1,50,'','*',0
CREATE PROCEDURE [dbo].[Proc_SelectProjectPresentProtected_AttachDetailPaging]
	@sort NVARCHAR(255) ,
    @page INT ,
    @limit INT ,
    @where NVARCHAR(MAX) ,
    @columns NVARCHAR(1000) = '*' ,
    @totalCount INT OUTPUT
AS
BEGIN
        SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
        IF ( @columns IS NULL
             OR LEN(@columns) = 0
           ) 
            SET @columns = '*'
        IF ( @sort IS NULL
             OR LEN(@sort) = 0
           ) 
            SET @sort = ' ModifiedDate DESC'
       
	   declare @start int=1;

	   set @start=(@page - 1) * @limit

        IF ( @where <> '' ) 
            SET @where = ' WHERE ' + @where
		-- Lay ve totalCount
        DECLARE @totalCountSql NVARCHAR(MAX)= 'SELECT @totalCount=count(*) FROM [dbo].ProjectPresentProtected_AttachDetail '
            + @where

        EXEC sp_executesql @totalCountSql, N'@totalCount INT OUT', @totalCount OUT
        
		--Lay data
        DECLARE @sql NVARCHAR(MAX)= ' SELECT *	FROM [dbo].ProjectPresentProtected_AttachDetail '+@where+ ' ORDER BY '+@sort+' OFFSET '+ cast(@start as nvarchar(10))+' ROWS FETCH NEXT '+cast(@limit as nvarchar(10))+' ROWS ONLY'
        
         
        EXEC sp_executesql @sql	
END

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectPresentProtectedAll]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectProjectPresentProtectedAll]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectProjectPresentProtectedAll]
-- Date Generated: 14 Tháng Giêng 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectProjectPresentProtectedAll]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[ProjectPresentProtectedID],
	[ProjectID],
	[DecisionNumber],
	[DecisionDate],
	[ProtectedDate],
	[Status],
	[Inactive],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
FROM
	[dbo].[ProjectPresentProtected]

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectPresentProtectedByID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectProjectPresentProtectedByID]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectProjectPresentProtectedByID]
-- Date Generated: 14 Tháng Giêng 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectProjectPresentProtectedByID]
	@ProjectPresentProtectedID uniqueidentifier
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[ProjectPresentProtectedID],
	[ProjectID],
	[DecisionNumber],
	[DecisionDate],
	[ProtectedDate],
	[Status],
	[Inactive],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
FROM
	[dbo].[ProjectPresentProtected]
WHERE
	[ProjectPresentProtectedID] = @ProjectPresentProtectedID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectPresentProtectedPaging]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectProjectAcceptanceBasisPaging]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectProjectAcceptanceBasisPaging]
-- Date Generated: 19 Tháng Chín 2017
------------------------------------------------------------------------------------------------------------------------
--[dbo].[Proc_SelectRankPaging]'',1,50,'','*',0
CREATE PROCEDURE [dbo].[Proc_SelectProjectPresentProtectedPaging]
	@sort NVARCHAR(255) ,
    @page INT ,
    @limit INT ,
    @where NVARCHAR(MAX) ,
    @columns NVARCHAR(1000) = '*' ,
    @totalCount INT OUTPUT
AS
BEGIN
        SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
        IF ( @columns IS NULL
             OR LEN(@columns) = 0
           ) 
            SET @columns = '*'
        IF ( @sort IS NULL
             OR LEN(@sort) = 0
           ) 
            SET @sort = ' ModifiedDate DESC'
       
	   declare @start int=1;

	   set @start=(@page - 1) * @limit

        IF ( @where <> '' ) 
            SET @where = ' WHERE ' + @where
		-- Lay ve totalCount
        DECLARE @totalCountSql NVARCHAR(MAX)= 'SELECT @totalCount=count(*) FROM [dbo].ProjectPresentProtected '
            + @where

        EXEC sp_executesql @totalCountSql, N'@totalCount INT OUT', @totalCount OUT
        
		--Lay data
        DECLARE @sql NVARCHAR(MAX)= ' SELECT *	FROM [dbo].ProjectPresentProtected '+@where+ ' ORDER BY '+@sort+' OFFSET '+ cast(@start as nvarchar(10))+' ROWS FETCH NEXT '+cast(@limit as nvarchar(10))+' ROWS ONLY'
        
         
        EXEC sp_executesql @sql	
END

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectProgressReport_AttachDetailAll]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectProjectProgressReport_AttachDetailAll]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   truong using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectProjectProgressReport_AttachDetailAll]
-- Date Generated: Sunday, February 25, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectProjectProgressReport_AttachDetailAll]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[ProjectProgressReport_AttachDetailID],
	[ProjectProgressReportID],
	[FileName],
	[FileType],
	[FileSize],
	[Inactive],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
FROM
	[dbo].[ProjectProgressReport_AttachDetail]

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectProgressReport_AttachDetailByID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectProjectProgressReport_AttachDetailByID]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   truong using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectProjectProgressReport_AttachDetailByID]
-- Date Generated: Sunday, February 25, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectProjectProgressReport_AttachDetailByID]
	@ProjectProgressReport_AttachDetailID uniqueidentifier
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[ProjectProgressReport_AttachDetailID],
	[ProjectProgressReportID],
	[FileName],
	[FileType],
	[FileSize],
	[Inactive],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy],
	[Description]
FROM
	[dbo].[View_ProjectProgressReport_AttachDetail]
WHERE
	[ProjectProgressReport_AttachDetailID] = @ProjectProgressReport_AttachDetailID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectProgressReport_AttachDetailByMasterID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Proc_SelectProjectProgressReport_AttachDetailByMasterID]
    @masterId UNIQUEIDENTIFIER
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;
        SELECT  [ProjectProgressReport_AttachDetailID],
			[ProjectProgressReportID],
			[FileName],
			[FileType],
			[FileSize],
			[Inactive],
			[SortOrder],
			[CreatedDate],
			[ModifiedDate],
			[IPAddress],
			[ModifiedBy],
			[CreatedBy],
			[Description]
		FROM
			[dbo].[View_ProjectProgressReport_AttachDetail]
        WHERE   ProjectProgressReportID = @masterId
    END




GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectProgressReport_AttachDetailPaging]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectProjectAcceptanceBasisPaging]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectProjectAcceptanceBasisPaging]
-- Date Generated: 19 Tháng Chín 2017
------------------------------------------------------------------------------------------------------------------------
--[dbo].[Proc_SelectProjectProgressReport_AttachDetailPaging]'',1,50,'','*',0
CREATE PROCEDURE [dbo].[Proc_SelectProjectProgressReport_AttachDetailPaging]
	@sort NVARCHAR(255) ,
    @page INT ,
    @limit INT ,
    @where NVARCHAR(MAX) ,
    @columns NVARCHAR(1000) = '*' ,
    @totalCount INT OUTPUT
AS
BEGIN
        SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
        IF ( @columns IS NULL
             OR LEN(@columns) = 0
           ) 
            SET @columns = '*'
        IF ( @sort IS NULL
             OR LEN(@sort) = 0
           ) 
            SET @sort = ' ModifiedDate DESC'
       
	   declare @start int=1;

	   set @start=(@page - 1) * @limit

        IF ( @where <> '' ) 
            SET @where = ' WHERE ' + @where
		-- Lay ve totalCount
        DECLARE @totalCountSql NVARCHAR(MAX)= 'SELECT @totalCount=count(*) FROM [dbo].View_ProjectProgressReport_AttachDetail '
            + @where

        EXEC sp_executesql @totalCountSql, N'@totalCount INT OUT', @totalCount OUT
        
		--Lay data
        DECLARE @sql NVARCHAR(MAX)= ' SELECT *	FROM [dbo].View_ProjectProgressReport_AttachDetail '+@where+ ' ORDER BY '+@sort+' OFFSET '+ cast(@start as nvarchar(10))+' ROWS FETCH NEXT '+cast(@limit as nvarchar(10))+' ROWS ONLY'
        
         
        EXEC sp_executesql @sql	
END

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectProgressReportAll]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectProjectProgressReportAll]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   truong using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectProjectProgressReportAll]
-- Date Generated: Wednesday, January 31, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectProjectProgressReportAll]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[ProjectProgressReportID],
	[ProjectID],
	[TermID],
	[TermName],
	[DateReport],
	[DateCheck],
	[Result],
	[Result_sTen],
	[Inactive],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy],
	[IdFiles]
FROM
	[dbo].[View_ProjectProgressReport]

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectProgressReportByID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectProjectProgressReportByID]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   truong using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectProjectProgressReportByID]
-- Date Generated: Wednesday, January 31, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectProjectProgressReportByID]
	@ProjectProgressReportID uniqueidentifier
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[ProjectProgressReportID],
	[ProjectID],
	[TermID],
	[TermName],
	[DateReport],
	[DateCheck],
	[Result],
	[Result_sTen],
	[Inactive],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy],
	[IdFiles]
FROM
	[dbo].[View_ProjectProgressReport]
WHERE
	[ProjectProgressReportID] = @ProjectProgressReportID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectProgressReportByMasterID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectProjectProgressReportByID]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   truong using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectProjectProgressReportByID]
-- Date Generated: Sunday, January 28, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectProjectProgressReportByMasterID]
	@MasterID uniqueidentifier
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[ProjectProgressReportID],
	[ProjectID],
	[TermID],
	[TermName],
	[DateReport],
	[DateCheck],
	[Result],
	[Result_sTen],
	[Inactive],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy],
	[IdFiles]
FROM
	[dbo].[View_ProjectProgressReport]
WHERE
	[ProjectID] = @MasterID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectProgressReportPaging]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectProjectAcceptanceBasisPaging]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectProjectAcceptanceBasisPaging]
-- Date Generated: 19 Tháng Chín 2017
------------------------------------------------------------------------------------------------------------------------
--[dbo].[Proc_SelectProjectProgressReportPaging]'',1,50,'','*',0
CREATE PROCEDURE [dbo].[Proc_SelectProjectProgressReportPaging]
	@sort NVARCHAR(255) ,
    @page INT ,
    @limit INT ,
    @where NVARCHAR(MAX) ,
    @columns NVARCHAR(1000) = '*' ,
    @totalCount INT OUTPUT
AS
BEGIN
        SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
        IF ( @columns IS NULL
             OR LEN(@columns) = 0
           ) 
            SET @columns = '*'
        IF ( @sort IS NULL
             OR LEN(@sort) = 0
           ) 
            SET @sort = ' ModifiedDate DESC'
       
	   declare @start int=1;

	   set @start=(@page - 1) * @limit

        IF ( @where <> '' ) 
            SET @where = ' WHERE ' + @where
		-- Lay ve totalCount
        DECLARE @totalCountSql NVARCHAR(MAX)= 'SELECT @totalCount=count(*) FROM [dbo].View_ProjectProgressReport '
            + @where

        EXEC sp_executesql @totalCountSql, N'@totalCount INT OUT', @totalCount OUT
        
		--Lay data
        DECLARE @sql NVARCHAR(MAX)= ' SELECT *	FROM [dbo].View_ProjectProgressReport '+@where+ ' ORDER BY '+@sort+' OFFSET '+ cast(@start as nvarchar(10))+' ROWS FETCH NEXT '+cast(@limit as nvarchar(10))+' ROWS ONLY'
        
         
        EXEC sp_executesql @sql	
END

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectSurvey_AttachDetailAll]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectProjectSurvey_AttachDetailAll]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   THANG using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectProjectSurvey_AttachDetailAll]
-- Date Generated: Saturday, February 24, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectProjectSurvey_AttachDetailAll]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[ProjectSurvey_AttachDetailID],
	[ID],
	[FileName],
	[FileType],
	[FileSize],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
FROM
	[dbo].[ProjectSurvey_AttachDetail]

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectSurvey_AttachDetailByID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectProjectSurvey_AttachDetailByID]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   THANG using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectProjectSurvey_AttachDetailByID]
-- Date Generated: Saturday, February 24, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectProjectSurvey_AttachDetailByID]
	@ProjectSurvey_AttachDetailID uniqueidentifier
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[ProjectSurvey_AttachDetailID],
	[ID],
	[FileName],
	[FileType],
	[FileSize],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
FROM
	[dbo].[ProjectSurvey_AttachDetail]
WHERE
	[ProjectSurvey_AttachDetailID] = @ProjectSurvey_AttachDetailID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectSurvey_AttachDetailByMasterID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<dvthang>
-- Create date: <24.02.2018>
-- Description:	<Lấy danh sách tệp nội dung khảo sát>
-- =============================================
CREATE PROCEDURE [dbo].[Proc_SelectProjectSurvey_AttachDetailByMasterID]
    @masterId UNIQUEIDENTIFIER
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;
        SELECT  
                ProjectSurvey_AttachDetailID ,
                ID ,
                FileName ,
                FileType ,
                FileSize ,
                SortOrder ,
				Description               
        FROM    dbo.ProjectSurvey_AttachDetail
        WHERE   ID = @masterId
		ORDER BY SortOrder
    END




GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectSurveyAll]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectProjectSurveyAll]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   THANG using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectProjectSurveyAll]
-- Date Generated: Saturday, February 24, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectProjectSurveyAll]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[ProjectSurveyID],
	[ProjectID],
	[FileName],
	[FileType],
	[FileSize],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
FROM
	[dbo].[ProjectSurvey]

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectSurveyByID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectProjectSurveyByID]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   THANG using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectProjectSurveyByID]
-- Date Generated: Saturday, February 24, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectProjectSurveyByID]
	@ProjectSurveyID uniqueidentifier
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[ProjectSurveyID],
	[ProjectID],
	[FileName],
	[FileType],
	[FileSize]
FROM
	[dbo].[ProjectSurvey]
WHERE
	[ProjectSurveyID] = @ProjectSurveyID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectSurveyByMasterID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectProjectSurveyByID]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   truong using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectProjectSurveyByID]
-- Date Generated: Sunday, January 28, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectProjectSurveyByMasterID]
	@MasterID uniqueidentifier
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[ProjectSurveyID],
	[ProjectID],
	[FileName],
	[FileType],
	[FileSize]
FROM
	[dbo].[ProjectSurvey]
WHERE
	[ProjectID] = @MasterID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectSurveyPaging]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectProjectAcceptanceBasisPaging]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectProjectAcceptanceBasisPaging]
-- Date Generated: 19 Tháng Chín 2017
------------------------------------------------------------------------------------------------------------------------
--[dbo].[Proc_SelectProjectSurveyPaging]'',1,50,'','*',0
CREATE PROCEDURE [dbo].[Proc_SelectProjectSurveyPaging]
	@sort NVARCHAR(255) ,
    @page INT ,
    @limit INT ,
    @where NVARCHAR(MAX) ,
    @columns NVARCHAR(1000) = '*' ,
    @totalCount INT OUTPUT
AS
BEGIN
        SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
        IF ( @columns IS NULL
             OR LEN(@columns) = 0
           ) 
            SET @columns = '*'
        IF ( @sort IS NULL
             OR LEN(@sort) = 0
           ) 
            SET @sort = ' ModifiedDate DESC'
       
	   declare @start int=1;

	   set @start=(@page - 1) * @limit

        IF ( @where <> '' ) 
            SET @where = ' WHERE ' + @where
		-- Lay ve totalCount
        DECLARE @totalCountSql NVARCHAR(MAX)= 'SELECT @totalCount=count(*) FROM [dbo].ProjectSurvey '
            + @where

        EXEC sp_executesql @totalCountSql, N'@totalCount INT OUT', @totalCount OUT
        
		--Lay data
        DECLARE @sql NVARCHAR(MAX)= ' SELECT *	FROM [dbo].ProjectSurvey '+@where+ ' ORDER BY '+@sort+' OFFSET '+ cast(@start as nvarchar(10))+' ROWS FETCH NEXT '+cast(@limit as nvarchar(10))+' ROWS ONLY'
        
         
        EXEC sp_executesql @sql	
END

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectTaskAllByProjectAndEditMode]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<dvthang>
-- Create date: <20.1.2018>
-- Description:	<Danh sách task của một đề tài>
-- =============================================
--[dbo].[Proc_SelectProjectTaskAllByProjectAndEditMode]3,'9e5f5ca-7c25-4184-bd3d-c4b53823f6af','a644f5d6-f96c-43c6-9334-9cf0e03b2baa'
CREATE PROCEDURE [dbo].[Proc_SelectProjectTaskAllByProjectAndEditMode]
    @editMode INT ,
    @ProjectID UNIQUEIDENTIFIER ,
    @ProjectTaskID UNIQUEIDENTIFIER
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

        DECLARE @Code HIERARCHYID

        SELECT  @Code = Code
        FROM    dbo.ProjectTask
        WHERE   ProjectTaskID = @ProjectTaskID


        SELECT  ProjectTaskID ,
                ParentID ,
                ProjectID ,
                Contents ,
                Code ,
                Grade ,
                Inactive
        FROM    dbo.ProjectTask
        WHERE   ( ( @editMode not IN ( 1, 2 )
                    AND Code.IsDescendantOf(@Code)!='TRUE'
                  )
                  OR @editMode	 IN ( 1, 2 )
                )
                AND ProjectID = @ProjectID
        ORDER BY Code
    END
	-- Proc_SelectTermAllByEditMode 0




GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectTaskAllByProjectID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<dvthang>
-- Create date: <20.1.2018>
-- Description:	<Danh sách task của một đề tài>
-- =============================================
-- Proc_SelectProjectTaskAllByProjectID 'C47B713B-7694-47FA-B18B-46F7F5C44EE4'
CREATE PROCEDURE [dbo].[Proc_SelectProjectTaskAllByProjectID]
    @ProjectID UNIQUEIDENTIFIER
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;
        SELECT  NULL AS ProjectTaskID ,
                NULL AS ParentID ,
                @ProjectID AS ProjectID ,
                dbo.Project.ProjectName AS Contents ,
                NULL AS Code ,
                0 AS Grade ,
                0 AS Inactive
        FROM    dbo.Project
        WHERE   dbo.Project.ProjectID = @ProjectID
        UNION
        SELECT  ProjectTaskID ,
                ParentID ,
                ProjectID ,
                Contents ,
                Code ,
                Grade ,
                Inactive
        FROM    dbo.ProjectTask
        WHERE   ProjectID = @ProjectID
        ORDER BY Code
    END




GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectTaskAllByProjectTaskID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Proc_SelectProjectTaskAllByProjectTaskID]
    @ProjectTaskID UNIQUEIDENTIFIER ,
    @ProjectID UNIQUEIDENTIFIER
AS
    SET NOCOUNT ON
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED
	
    --Lấy dữ liệu ra
    SELECT  ROW_NUMBER() OVER ( ORDER BY P.Code ) AS SortOrder ,
            CAST(Code AS NVARCHAR(255)) ,
            ProjectTaskID ,
            ParentID ,
            ProjectID ,
            Contents ,
            Rank ,
            Result ,
            StartDate ,
            EndDate
    FROM    [dbo].[ProjectTask] AS P
    WHERE   ( [ParentID] = @ProjectTaskID )
            OR ( ProjectID = @ProjectID
                 AND @ProjectTaskID = '00000000-0000-0000-0000-000000000000'
                 AND [ParentID] IS NULL
               )







GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectTaskByMasterID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectProjectTaskByID]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   Phamlai using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectProjectTaskByID]
-- Date Generated: Sunday, January 28, 2018
------------------------------------------------------------------------------------------------------------------------
-- Proc_SelectProjectTaskByMasterID 'C47B713B-7694-47FA-B18B-46F7F5C44EE4'
CREATE PROCEDURE [dbo].[Proc_SelectProjectTaskByMasterID]
    @MasterID UNIQUEIDENTIFIER
AS
    SET NOCOUNT ON
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED

    SELECT  ProjectTaskID ,
            ParentID ,
            ProjectID ,
            Contents ,
            Rank ,
            Result ,
            StartDate ,
            EndDate ,
            EmployeeID ,
            Status ,
            Code ,
            Grade ,
            Inactive ,
			P.SortOrder,
            CAST(CASE WHEN EXISTS ( SELECT TOP 1
                                            Code
                                    FROM    dbo.ProjectTask
                                    WHERE   ParentID = P.ProjectTaskID ) THEN 0
                      ELSE 1
                 END AS BIT) AS Leaf
    FROM    [dbo].[ProjectTask] AS P
    WHERE   [ProjectID] = @MasterID
    ORDER BY P.Code

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectTaskMemberByMasterID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Proc_SelectProjectTaskMemberByMasterID]
    @MasterID UNIQUEIDENTIFIER
AS
    SET NOCOUNT ON
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED

    SELECT  dbo.View_ProjectTaskMember.* ,
            ROW_NUMBER() OVER ( ORDER BY dbo.Employee.SortOrder ASC ) AS Rownum
    FROM    dbo.View_ProjectTaskMember
            LEFT JOIN dbo.Employee ON View_ProjectTaskMember.EmployeeID = Employee.EmployeeID
    WHERE   [ProjectTaskID] = @MasterID




GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectTaskPaging]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectProjectTaskAcceptanceBasisPaging]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectProjectTaskAcceptanceBasisPaging]
-- Date Generated: 19 Tháng Chín 2017
------------------------------------------------------------------------------------------------------------------------
--[dbo].[Proc_SelectRankPaging]'',1,50,'','*',0
create PROCEDURE [dbo].[Proc_SelectProjectTaskPaging]
	@sort NVARCHAR(255) ,
    @page INT ,
    @limit INT ,
    @where NVARCHAR(MAX) ,
    @columns NVARCHAR(1000) = '*' ,
    @totalCount INT OUTPUT
AS
BEGIN
        SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
        IF ( @columns IS NULL
             OR LEN(@columns) = 0
           ) 
            SET @columns = '*'
        IF ( @sort IS NULL
             OR LEN(@sort) = 0
           ) 
            SET @sort = ' ModifiedDate DESC'
       
	   declare @start int=1;

	   set @start=(@page - 1) * @limit

        IF ( @where <> '' ) 
            SET @where = ' WHERE ' + @where
		-- Lay ve totalCount
        DECLARE @totalCountSql NVARCHAR(MAX)= 'SELECT @totalCount=count(*) FROM [dbo].ProjectTask '
            + @where

        EXEC sp_executesql @totalCountSql, N'@totalCount INT OUT', @totalCount OUT
        
		--Lay data
        DECLARE @sql NVARCHAR(MAX)= ' SELECT *	FROM [dbo].ProjectTask '+@where+ ' ORDER BY '+@sort+' OFFSET '+ cast(@start as nvarchar(10))+' ROWS FETCH NEXT '+cast(@limit as nvarchar(10))+' ROWS ONLY'
        
         
        EXEC sp_executesql @sql	
END

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectWorkshop_AttachDetailAll]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectProjectWorkshop_AttachDetailAll]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   Admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectProjectWorkshop_AttachDetailAll]
-- Date Generated: Saturday, February 24, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectProjectWorkshop_AttachDetailAll]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[ProjectWorkshop_AttachDetailID],
	[ProjectWorkshopID],
	[Description],
	[FileName],
	[FileType],
	[FileSize],
	[SortOrder]
FROM
	[dbo].[ProjectWorkshop_AttachDetail]

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectWorkshop_AttachDetailByID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectProjectWorkshop_AttachDetailByID]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   Admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectProjectWorkshop_AttachDetailByID]
-- Date Generated: Saturday, February 24, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectProjectWorkshop_AttachDetailByID]
	@ProjectWorkshop_AttachDetailID uniqueidentifier
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[ProjectWorkshop_AttachDetailID],
	[ProjectWorkshopID],
	[Description],
	[FileName],
	[FileType],
	[FileSize],
	[SortOrder]
FROM
	[dbo].[ProjectWorkshop_AttachDetail]
WHERE
	[ProjectWorkshop_AttachDetailID] = @ProjectWorkshop_AttachDetailID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectWorkshop_AttachDetailByMasterID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Proc_SelectProjectWorkshop_AttachDetailByMasterID]
    @masterId UNIQUEIDENTIFIER
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;
        SELECT  [ProjectWorkshop_AttachDetailID] ,
                [ProjectWorkshopID] ,
                [Description] ,
                [FileName] ,
                [FileType] ,
                [FileSize] ,
                [SortOrder]
        FROM    dbo.ProjectWorkshop_AttachDetail
        WHERE   ProjectWorkshopID = @masterId
		ORDER BY SortOrder
    END




GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectWorkshop_AttachDetailPaging]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectProjectWorkshop_AttachDetailPaging]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   Admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectProjectWorkshop_AttachDetailPaging]
-- Date Generated: Saturday, February 24, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectProjectWorkshop_AttachDetailPaging]
	@sort NVARCHAR(255) ,
    @start INT ,
    @limit INT ,
    @where NVARCHAR(MAX) ,
    @columns NVARCHAR(1000) = '*' ,
    @totalCount INT OUTPUT
AS
BEGIN
        SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
        DECLARE @orderbyColumn NVARCHAR(MAX)
        DECLARE @wherePaging NVARCHAR(MAX)

        IF ( @columns IS NULL
             OR LEN(@columns) = 0
           ) 
            SET @columns = '*'
        IF ( @sort IS NULL
             OR LEN(@sort) = 0
           ) 
            SET @sort = ' ModifiedDate DESC'
        SET @wherePaging = ''

        IF ( @sort <> ''
             AND NOT @sort IS NULL
           ) 
            SET @orderbyColumn = 'ROW_NUMBER() OVER (ORDER BY ' + @sort
                + ') AS Rownum, '
        ELSE 
            SET @orderbyColumn = ' NULL AS Rownum,'
        IF ( @limit > 0 ) 
            BEGIN
                SET @wherePaging = ' WHERE temp.Rownum between '
                    + CONVERT(NVARCHAR(16), ( @start + 1 )) + ' AND '
                    + CONVERT(NVARCHAR(16), ( @start + @limit ))
            END     
			
        IF ( @where <> '' ) 
            SET @where = ' WHERE ' + @where
		-- Lay ve totalCount
        DECLARE @totalCountSql NVARCHAR(MAX)= 'SELECT @totalCount=count(*) FROM [dbo].ProjectWorkshop_AttachDetail '
            + @where

        EXEC sp_executesql @totalCountSql, N'@totalCount INT OUT', @totalCount OUT
        
		--Lay data
        DECLARE @sql NVARCHAR(MAX)= ' SELECT ' + @columns + '
		FROM (SELECT ' + @orderbyColumn + ' * FROM [dbo].ProjectWorkshop_AttachDetail ' + @where
            + ') as TEMP' + @wherePaging
        
         
        EXEC sp_executesql @sql	
END

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectWorkshopAll]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectProjectWorkshopAll]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   truong using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectProjectWorkshopAll]
-- Date Generated: Sunday, January 28, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectProjectWorkshopAll]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[ProjectWorkshopID],
	[ProjectID],
	[Date],
	[Time],
	[Adderess],
	[Contents],
	[SortOrder]
FROM
	[dbo].[ProjectWorkshop]

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectWorkshopByID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectProjectWorkshopByID]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   truong using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectProjectWorkshopByID]
-- Date Generated: Sunday, January 28, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectProjectWorkshopByID]
	@ProjectWorkshopID uniqueidentifier
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[ProjectWorkshopID],
	[ProjectID],
	[Date],
	[Time],
	[Adderess],
	[Contents],
	[SortOrder]
FROM
	[dbo].[ProjectWorkshop]
WHERE
	[ProjectWorkshopID] = @ProjectWorkshopID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectWorkshopByMasterID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectProjectWorkshopByID]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   truong using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectProjectWorkshopByID]
-- Date Generated: Sunday, January 28, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectProjectWorkshopByMasterID]
	@MasterID uniqueidentifier
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[ProjectWorkshopID],
	[ProjectID],
	[Date],
	[Time],
	[Adderess],
	[Contents],
	[SortOrder],
	IdFiles
FROM
	[dbo].[ProjectWorkshop]
WHERE
	[ProjectID] = @MasterID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjectWorkshopPaging]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectProjectAcceptanceBasisPaging]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectProjectAcceptanceBasisPaging]
-- Date Generated: 19 Tháng Chín 2017
------------------------------------------------------------------------------------------------------------------------
--[dbo].[Proc_SelectProjectWorkshopPaging]'',1,50,'','*',0
CREATE PROCEDURE [dbo].[Proc_SelectProjectWorkshopPaging]
	@sort NVARCHAR(255) ,
    @page INT ,
    @limit INT ,
    @where NVARCHAR(MAX) ,
    @columns NVARCHAR(1000) = '*' ,
    @totalCount INT OUTPUT
AS
BEGIN
        SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
        IF ( @columns IS NULL
             OR LEN(@columns) = 0
           ) 
            SET @columns = '*'
        IF ( @sort IS NULL
             OR LEN(@sort) = 0
           ) 
            SET @sort = ' ModifiedDate DESC'
       
	   declare @start int=1;

	   set @start=(@page - 1) * @limit

        IF ( @where <> '' ) 
            SET @where = ' WHERE ' + @where
		-- Lay ve totalCount
        DECLARE @totalCountSql NVARCHAR(MAX)= 'SELECT @totalCount=count(*) FROM [dbo].ProjectWorkshop '
            + @where

        EXEC sp_executesql @totalCountSql, N'@totalCount INT OUT', @totalCount OUT
        
		--Lay data
        DECLARE @sql NVARCHAR(MAX)= ' SELECT *	FROM [dbo].ProjectWorkshop '+@where+ ' ORDER BY '+@sort+' OFFSET '+ cast(@start as nvarchar(10))+' ROWS FETCH NEXT '+cast(@limit as nvarchar(10))+' ROWS ONLY'
        
         
        EXEC sp_executesql @sql	
END

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectProjetInputByMasterID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Manh
-- Create date: 22.08.18
-- Description:	Lấy danh sách ProjectInput
-- Proc_SelectProjetInputByMasterID 'c1644ef7-2bb9-4715-a3f8-3f21638d2c18'
-- =============================================
CREATE PROCEDURE [dbo].[Proc_SelectProjetInputByMasterID]
    @masterID UNIQUEIDENTIFIER
AS
    BEGIN
        SET NOCOUNT ON;
        SELECT  ROW_NUMBER() OVER ( ORDER BY E.FirstName ) AS Rownum ,
                PI.ProjectInputID ,
                PI.ProjectID ,
                PI.EmployeeID ,
                ( LTRIM(RTRIM(E.LastName)) + N' ' + LTRIM(RTRIM(E.FirstName)) ) AS FullName
        FROM    dbo.ProjectInput PI
                LEFT JOIN dbo.Employee E ON PI.EmployeeID = E.EmployeeID
        WHERE   PI.ProjectID = @masterID
    END




GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectQADetailAll]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Proc_SelectQADetailAll]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[QADetailID],
	[QATopicID],
	[QuestionContent],
	[AnswerContent],
	[PublicState],
	[QuestionBy],
	[QuestionDate],
	[AnswerBy],
	[AnswerDate],
	[ModifiedDate],
	[ModifiedBy],
	[IPAddress]
FROM
	[dbo].[QADetail]

--endregion


GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectQADetailByTopic]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Proc_SelectQADetailByTopic] @topicID INT, @publicState INT AS
BEGIN
	SELECT * FROM dbo.QADetail WHERE QATopicID=@topicID AND PublicState = @publicState
END
GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectQADetailPaging]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectQADetailPaging]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectQADetailPaging]
-- Date Generated: Tuesday, May 14, 2019
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectQADetailPaging]
	@sort NVARCHAR(255) ,
    @page INT ,
    @limit INT ,
    @where NVARCHAR(MAX) ,
    @columns NVARCHAR(1000) = '*' ,
    @totalCount INT OUTPUT
AS
BEGIN
        SET NOCOUNT ON
        
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
        IF ( @columns IS NULL
             OR LEN(@columns) = 0
           ) 
            SET @columns = '*'
        IF ( @sort IS NULL
             OR LEN(@sort) = 0
           ) 
            SET @sort = ' ModifiedDate DESC'
       
		declare @start int=1;

		set @start=(@page - 1) * @limit

		IF ( @where IS NOT NULL
			 AND LEN(@where) >0
		   ) 
			SET @where = ' WHERE ' + @where
		-- Lay ve totalCount
		DECLARE @totalCountSql NVARCHAR(MAX)= 'SELECT @totalCount=count(*) FROM [dbo].QADetail '
			+ @where

		EXEC sp_executesql @totalCountSql, N'@totalCount INT OUT', @totalCount OUT
		
		--Lay data
		DECLARE @sql NVARCHAR(MAX)= ' SELECT *	FROM [dbo].QADetail '+@where+ ' ORDER BY '+@sort+' OFFSET '+ cast(@start as nvarchar(10))+' ROWS FETCH NEXT '+cast(@limit as nvarchar(10))+' ROWS ONLY'
		
		 
		EXEC sp_executesql @sql	
        
END

--endregion


GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectQATopicAll]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Proc_SelectQATopicAll]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[QATopicID],
	[QATopicCode],
	[QATopicName],
	[Description],
	[Inactive],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
FROM
	[dbo].[QATopic]

--endregion


GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectQATopicPaging]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectQATopicPaging]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectQATopicPaging]
-- Date Generated: Tuesday, May 14, 2019
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectQATopicPaging]
	@sort NVARCHAR(255) ,
    @page INT ,
    @limit INT ,
    @where NVARCHAR(MAX) ,
    @columns NVARCHAR(1000) = '*' ,
    @totalCount INT OUTPUT
AS
BEGIN
        SET NOCOUNT ON
        
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
        IF ( @columns IS NULL
             OR LEN(@columns) = 0
           ) 
            SET @columns = '*'
        IF ( @sort IS NULL
             OR LEN(@sort) = 0
           ) 
            SET @sort = ' ModifiedDate DESC'
       
		declare @start int=1;

		set @start=(@page - 1) * @limit

		IF ( @where IS NOT NULL
			 AND LEN(@where) >0
		   ) 
			SET @where = ' WHERE ' + @where
		-- Lay ve totalCount
		DECLARE @totalCountSql NVARCHAR(MAX)= 'SELECT @totalCount=count(*) FROM [dbo].QATopic '
			+ @where

		EXEC sp_executesql @totalCountSql, N'@totalCount INT OUT', @totalCount OUT
		
		--Lay data
		DECLARE @sql NVARCHAR(MAX)= ' SELECT *	FROM [dbo].QATopic '+@where+ ' ORDER BY '+@sort+' OFFSET '+ cast(@start as nvarchar(10))+' ROWS FETCH NEXT '+cast(@limit as nvarchar(10))+' ROWS ONLY'
		
		 
		EXEC sp_executesql @sql	
        
END

--endregion


GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectQuestionByUser]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Proc_SelectQuestionByUser] @username NVARCHAR(128), @groupID INT AS
BEGIN
IF @groupID = -1
	SELECT * FROM dbo.QADetail WHERE PublicState = 0
ELSE
	SELECT * FROM dbo.QADetail WHERE QuestionBy LIKE @username	
END
GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectRankAll]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectRankAll]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   THANG using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectRankAll]
-- Date Generated: Monday, January 8, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectRankAll]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[RankID],
	[RankCode],
	[RankName],
	[Description],
	[Inactive],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
FROM
	[dbo].[Rank]

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectRankAllByEditMode]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<dvthang>
-- Create date: <20.1.2018>
-- Description:	<Lấy danh sách cấp bậc>
-- =============================================
CREATE PROCEDURE [dbo].[Proc_SelectRankAllByEditMode] @editMode INT
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

        SELECT  RankID ,
                RankCode ,
                RankName 
                 FROM dbo.Rank
        WHERE   ( ( @editMode IN ( 1, 2 )
                    AND Inactive = 0
                  )
                  OR @editMode NOT	 IN ( 1, 2 )
                )
				ORDER BY SortOrder
    END




GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectRankByID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectRankByID]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   THANG using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectRankByID]
-- Date Generated: Monday, January 8, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectRankByID]
	@RankID uniqueidentifier
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[RankID],
	[RankCode],
	[RankName],
	[Description],
	[Inactive],
	[SortOrder],
	[CreatedDate],
	[ModifiedDate],
	[IPAddress],
	[ModifiedBy],
	[CreatedBy]
FROM
	[dbo].[Rank]
WHERE
	[RankID] = @RankID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectRankPaging]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectProjectAcceptanceBasisPaging]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectProjectAcceptanceBasisPaging]
-- Date Generated: 19 Tháng Chín 2017
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectRankPaging]
	@sort NVARCHAR(255) ,
    @page INT ,
    @limit INT ,
    @where NVARCHAR(MAX) ,
    @columns NVARCHAR(1000) = '*' ,
    @totalCount INT OUTPUT
AS
BEGIN
        SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
        IF ( @columns IS NULL
             OR LEN(@columns) = 0
           ) 
            SET @columns = '*'
        IF ( @sort IS NULL
             OR LEN(@sort) = 0
           ) 
            SET @sort = ' ModifiedDate DESC'
       
	   declare @start int=1;

	   set @start=(@page - 1) * @limit

        IF ( @where <> '' ) 
            SET @where = ' WHERE ' + @where
		-- Lay ve totalCount
        DECLARE @totalCountSql NVARCHAR(MAX)= 'SELECT @totalCount=count(*) FROM [dbo].Rank '
            + @where

        EXEC sp_executesql @totalCountSql, N'@totalCount INT OUT', @totalCount OUT
        
		--Lay data
        DECLARE @sql NVARCHAR(MAX)= ' SELECT *	FROM [dbo].Rank '+@where+ ' ORDER BY '+@sort+' OFFSET '+ cast(@start as nvarchar(10))+' ROWS FETCH NEXT '+cast(@limit as nvarchar(10))+' ROWS ONLY'
        
         
        EXEC sp_executesql @sql	
END

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectTermAllByEditMode]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<dvthang>
-- Create date: <20.1.2018>
-- Description:	<Lấy danh sách chức vụ>
-- =============================================
CREATE PROCEDURE [dbo].[Proc_SelectTermAllByEditMode] @editMode INT
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

        SELECT  TermID ,
                TermCode ,
                TermName 
                 FROM dbo.Term
        WHERE   ( ( @editMode IN ( 1, 2 )
                    AND Inactive = 0
                  )
                  OR @editMode NOT	 IN ( 1, 2 )
                )
				ORDER BY SortOrder
    END
	-- Proc_SelectTermAllByEditMode 0



GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectTokensAll]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectTokensAll]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   THANG using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectTokensAll]
-- Date Generated: Friday, January 12, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectTokensAll]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[TokenId],
	[UserName],
	[Token],
	[ExpiresOn],
	[IssuedOn]
FROM
	[dbo].[Tokens]

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_SelectTokensByID]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectTokensByID]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   THANG using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_SelectTokensByID]
-- Date Generated: Friday, January 12, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_SelectTokensByID]
	@TokenId uniqueidentifier
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT
	[TokenId],
	[UserName],
	[Token],
	[ExpiresOn],
	[IssuedOn]
FROM
	[dbo].[Tokens]
WHERE
	[TokenId] = @TokenId

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_UpdateAcademicRank]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_UpdateAcademicRank]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   truong using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_UpdateAcademicRank]
-- Date Generated: Saturday, January 13, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_UpdateAcademicRank]
	@AcademicRankID uniqueidentifier,
	@AcademicRankCode nvarchar(64),
	@AcademicRankName nvarchar(128),
	@AcademicRankShortName nvarchar(128),
	@Description nvarchar(255),
	@Inactive bit,
	@SortOrder int,
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@IPAddress nvarchar(128),
	@ModifiedBy nvarchar(128),
	@CreatedBy nvarchar(128)
AS


UPDATE [dbo].[AcademicRank] SET
	[AcademicRankCode] = @AcademicRankCode,
	[AcademicRankName] = @AcademicRankName,
	[AcademicRankShortName] = @AcademicRankShortName,
	[Description] = @Description,
	[Inactive] = @Inactive,
	[SortOrder] = @SortOrder,
	[CreatedDate] = @CreatedDate,
	[ModifiedDate] = @ModifiedDate,
	[IPAddress] = @IPAddress,
	[ModifiedBy] = @ModifiedBy,
	[CreatedBy] = @CreatedBy
WHERE
	[AcademicRankID] = @AcademicRankID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_UpdateAspNetUsers]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_UpdateAspNetUsers]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_UpdateAspNetUsers]
-- Date Generated: Monday, May 13, 2019
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_UpdateAspNetUsers]
	@Id NVARCHAR(128),
	@Email nvarchar(256),
	@EmailConfirmed bit,
	@PasswordHash nvarchar(max),
	@SecurityStamp nvarchar(max),
	@PhoneNumber nvarchar(max),
	@PhoneNumberConfirmed bit,
	@TwoFactorEnabled bit,
	@LockoutEndDateUtc datetime,
	@LockoutEnabled bit,
	@AccessFailedCount int,
	@UserName nvarchar(256),
	@GroupID int,
	@UserID int,
	@FullName nvarchar(50),
	@Address nvarchar(150),
	@ModifiedDate datetime,
	@CreatedDate datetime,
	@IPAddress nvarchar(128),
	@ModifiedBy nvarchar(128),
	@CreatedBy nvarchar(128),
	@oId int
AS


UPDATE [dbo].[AspNetUsers] SET
	[Email] = @Email,
	[EmailConfirmed] = @EmailConfirmed,
	[PasswordHash] = @PasswordHash,
	[SecurityStamp] = @SecurityStamp,
	[PhoneNumber] = @PhoneNumber,
	[PhoneNumberConfirmed] = @PhoneNumberConfirmed,
	[TwoFactorEnabled] = @TwoFactorEnabled,
	[LockoutEndDateUtc] = @LockoutEndDateUtc,
	[LockoutEnabled] = @LockoutEnabled,
	[AccessFailedCount] = @AccessFailedCount,
	[UserName] = @UserName,
	[GroupID] = @GroupID,
	[UserID] = @UserID,
	[FullName] = @FullName,
	[Address] = @Address,
	[ModifiedDate] = @ModifiedDate,
	[CreatedDate] = @CreatedDate,
	[IPAddress] = @IPAddress,
	[ModifiedBy] = @ModifiedBy,
	[CreatedBy] = @CreatedBy,
	[oId] = @oId
WHERE
	[Id] = @Id

--endregion


GO
/****** Object:  StoredProcedure [dbo].[Proc_UpdateCompany]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_UpdateCompany]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   truong using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_UpdateCompany]
-- Date Generated: Saturday, January 13, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_UpdateCompany]
	@CompanyID uniqueidentifier,
	@ParentID uniqueidentifier,
	@CompanyCode nvarchar(64),
	@CompanyName nvarchar(128),
	@CompanyShortName nvarchar(128),
	@Tel nvarchar(64),
	@Fax nvarchar(64),
	@Email nvarchar(64),
	@Address nvarchar(128),
	@Website nvarchar(128),
	@Director nvarchar(128),
	@AccountNumber nvarchar(64),
	@BankName nvarchar(128),
	@Description nvarchar(255),
	@IsLeaf bit,
	@Inactive bit,
	@SortOrder int,
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@IPAddress nvarchar(128),
	@ModifiedBy nvarchar(128),
	@CreatedBy nvarchar(128),
	@Owned bit
AS


UPDATE [dbo].[Company] SET
	[ParentID] = @ParentID,
	[CompanyCode] = @CompanyCode,
	[CompanyName] = @CompanyName,
	[CompanyShortName] = @CompanyShortName,
	[Tel] = @Tel,
	[Fax] = @Fax,
	[Email] = @Email,
	[Address] = @Address,
	[Website] = @Website,
	[Director] = @Director,
	[AccountNumber] = @AccountNumber,
	[BankName] = @BankName,
	[Description] = @Description,
	[IsLeaf] = @IsLeaf,
	[Inactive] = @Inactive,
	[SortOrder] = @SortOrder,
	[CreatedDate] = @CreatedDate,
	[ModifiedDate] = @ModifiedDate,
	[IPAddress] = @IPAddress,
	[ModifiedBy] = @ModifiedBy,
	[CreatedBy] = @CreatedBy,
	[Owned] = @Owned
WHERE
	[CompanyID] = @CompanyID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_UpdateContentExperiment]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_UpdateContentExperiment]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   Admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_UpdateContentExperiment]
-- Date Generated: Sunday, February 25, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_UpdateContentExperiment]
	@ID uniqueidentifier,
	@ProjectID uniqueidentifier,
	@ToDate datetime,
	@CompanyID uniqueidentifier,
	@AtCompany nvarchar(255),
	@Description nvarchar(500),
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@IPAddress nvarchar(128),
	@ModifiedBy nvarchar(128),
	@CreatedBy nvarchar(128)
AS


UPDATE [dbo].[ContentExperiment] SET
	[ProjectID] = @ProjectID,
	[ToDate] = @ToDate,
	[CompanyID] = @CompanyID,
	[AtCompany] = @AtCompany,
	[Description] = @Description,
	[CreatedDate] = @CreatedDate,
	[ModifiedDate] = @ModifiedDate,
	[IPAddress] = @IPAddress,
	[ModifiedBy] = @ModifiedBy,
	[CreatedBy] = @CreatedBy
WHERE
	[ID] = @ID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_UpdateContentServey]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Proc_UpdateContentServey]
	@ID uniqueidentifier,
	@CompanyID uniqueidentifier,
	@AtCompany nvarchar(255),
	@Description nvarchar(500),
	@ModifiedDate datetime,
	@IPAddress nvarchar(128),
	@ModifiedBy nvarchar(128),
	@ToDate DATETIME,
	@ProjectID UNIQUEIDENTIFIER
AS


UPDATE [dbo].[ContentServey] SET
	[CompanyID] = @CompanyID,
	[AtCompany] = @AtCompany,
	[Description] = @Description,
	[ModifiedDate] = @ModifiedDate,
	[IPAddress] = @IPAddress,
	[ModifiedBy] = @ModifiedBy,
	ToDate=@ToDate,
	ProjectID=@ProjectID
WHERE
	[ID] = @ID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_UpdateCustomer]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--region [dbo].[Proc_UpdateCustomer]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_UpdateCustomer]
-- Date Generated: Monday, April 22, 2019
------------------------------------------------------------------------------------------------------------------------

CREATE PROC [dbo].[Proc_UpdateCustomer]
	@CustomerID int,
	@CustomerCode nvarchar(64),
	@CustomerName nvarchar(255),
	@CustomerGender int,
	@DOB datetime,
	@HealthCareNumber nvarchar(255),
	@Tel nvarchar(64),
	@Email nvarchar(255),
	@Address nvarchar(255),
	@CustomerGroup NVARCHAR(255),
	@CustomerDescription nvarchar(max),
	@PresenterName nvarchar(255),
	@PresenterPhone nvarchar(255),
	@PresenterAddress nvarchar(255),
	@PresenterIDC nvarchar(255),
	@Relationship nvarchar(255),
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@IPAddress nvarchar(128),
	@ModifiedBy nvarchar(128),
	@CreatedBy nvarchar(128)
AS


UPDATE [dbo].[Customer] SET
	[CustomerCode] = @CustomerCode,
	[CustomerName] = @CustomerName,
	[CustomerGender] = @CustomerGender,
	[DOB] = @DOB,
	[HealthCareNumber] = @HealthCareNumber,
	[Tel] = @Tel,
	[Email] = @Email,
	[Address] = @Address,
	[CustomerGroup] = @CustomerGroup,
	[CustomerDescription] = @CustomerDescription,
	[PresenterName] = @PresenterName,
	[PresenterPhone] = @PresenterPhone,
	[PresenterAddress] = @PresenterAddress,
	[PresenterIDC] = @PresenterIDC,
	[Relationship] = @Relationship,
	[CreatedDate] = @CreatedDate,
	[ModifiedDate] = @ModifiedDate,
	[IPAddress] = @IPAddress,
	[ModifiedBy] = @ModifiedBy,
	[CreatedBy] = @CreatedBy
WHERE
	[CustomerID] = @CustomerID

--endregion

GO
/****** Object:  StoredProcedure [dbo].[Proc_UpdateDayOff]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_UpdateDayOff]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   truong using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_UpdateDayOff]
-- Date Generated: Saturday, March 3, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_UpdateDayOff]
	@DayOffID uniqueidentifier,
	@Date date,
	@Description nvarchar(255),
	@Inactive bit,
	@SortOrder int,
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@IPAddress nvarchar(128),
	@ModifiedBy nvarchar(128),
	@CreatedBy nvarchar(128)
AS


UPDATE [dbo].[DayOff] SET
	[Date] = @Date,
	[Description] = @Description,
	[Inactive] = @Inactive,
	[SortOrder] = @SortOrder,
	[CreatedDate] = @CreatedDate,
	[ModifiedDate] = @ModifiedDate,
	[IPAddress] = @IPAddress,
	[ModifiedBy] = @ModifiedBy,
	[CreatedBy] = @CreatedBy
WHERE
	[DayOffID] = @DayOffID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_UpdateDegree]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_UpdateDegree]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_UpdateDegree]
-- Date Generated: 13 Tháng Giêng 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_UpdateDegree]
	@DegreeID uniqueidentifier,
	@DegreeCode nvarchar(64),
	@DegreeName nvarchar(128),
	@DegreeShortName nvarchar(128),
	@Description nvarchar(255),
	@Inactive bit,
	@SortOrder int,
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@IPAddress nvarchar(128),
	@ModifiedBy nvarchar(128),
	@CreatedBy nvarchar(128)
AS


UPDATE [dbo].[Degree] SET
	[DegreeCode] = @DegreeCode,
	[DegreeName] = @DegreeName,
	[DegreeShortName] = @DegreeShortName,
	[Description] = @Description,
	[Inactive] = @Inactive,
	[SortOrder] = @SortOrder,
	[CreatedDate] = @CreatedDate,
	[ModifiedDate] = @ModifiedDate,
	[IPAddress] = @IPAddress,
	[ModifiedBy] = @ModifiedBy,
	[CreatedBy] = @CreatedBy
WHERE
	[DegreeID] = @DegreeID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_UpdateEmployee]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_UpdateEmployee]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   manh using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_UpdateEmployee]
-- Date Generated: Tuesday, May 29, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_UpdateEmployee]
	@EmployeeID uniqueidentifier,
	@CompanyID uniqueidentifier,
	@EmployeeCode nvarchar(64),
	@FirstName nvarchar(128),
	@LastName nvarchar(128),
	@FullName nvarchar(255),
	@RankID uniqueidentifier,
	@Gender int,
	@AcademicRankID uniqueidentifier,
	@YearOfAcademicRank int,
	@DegreeID uniqueidentifier,
	@YearOfDegree int,
	@PositionID uniqueidentifier,
	@BirthDay datetime,
	@BirthPlace nvarchar(255),
	@HomeLand nvarchar(255),
	@NativeAddress nvarchar(255),
	@Tel nvarchar(64),
	@HomeTel nvarchar(64),
	@Mobile nvarchar(64),
	@Fax nvarchar(64),
	@Email nvarchar(64),
	@OfficeAddress nvarchar(255),
	@HomeAddress nvarchar(255),
	@Website nvarchar(64),
	@Description nvarchar(255),
	@FileResourceID nvarchar(255),
	@IDNumber nvarchar(20),
	@IssuedBy nvarchar(255),
	@DateBy date,
	@AccountNumber nvarchar(20),
	@Bank nvarchar(255),
	@Inactive bit,
	@SortOrder int,
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@IPAddress nvarchar(128),
	@ModifiedBy nvarchar(128),
	@CreatedBy nvarchar(128)
AS


UPDATE [dbo].[Employee] SET
	[CompanyID] = @CompanyID,
	[EmployeeCode] = @EmployeeCode,
	[FirstName] = @FirstName,
	[LastName] = @LastName,
	[FullName] = @FullName,
	[RankID] = @RankID,
	[Gender] = @Gender,
	[AcademicRankID] = @AcademicRankID,
	[YearOfAcademicRank] = @YearOfAcademicRank,
	[DegreeID] = @DegreeID,
	[YearOfDegree] = @YearOfDegree,
	[PositionID] = @PositionID,
	[BirthDay] = @BirthDay,
	[BirthPlace] = @BirthPlace,
	[HomeLand] = @HomeLand,
	[NativeAddress] = @NativeAddress,
	[Tel] = @Tel,
	[HomeTel] = @HomeTel,
	[Mobile] = @Mobile,
	[Fax] = @Fax,
	[Email] = @Email,
	[OfficeAddress] = @OfficeAddress,
	[HomeAddress] = @HomeAddress,
	[Website] = @Website,
	[Description] = @Description,
	[FileResourceID] = @FileResourceID,
	[IDNumber] = @IDNumber,
	[IssuedBy] = @IssuedBy,
	[DateBy] = @DateBy,
	[AccountNumber] = @AccountNumber,
	[Bank] = @Bank,
	[Inactive] = @Inactive,
	[SortOrder] = @SortOrder,
	[CreatedDate] = @CreatedDate,
	[ModifiedDate] = @ModifiedDate,
	[IPAddress] = @IPAddress,
	[ModifiedBy] = @ModifiedBy,
	[CreatedBy] = @CreatedBy
WHERE
	[EmployeeID] = @EmployeeID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_UpdateGrantRatio]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_UpdateGrantRatio]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   truong using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_UpdateGrantRatio]
-- Date Generated: Wednesday, May 23, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_UpdateGrantRatio]
	@GrantRatioID uniqueidentifier,
	@GrantRatioCode nvarchar(64),
	@GrantRatioName nvarchar(128),
	@Description nvarchar(255),
	@Inactive bit,
	@SortOrder int,
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@IPAddress nvarchar(128),
	@ModifiedBy nvarchar(128),
	@CreatedBy nvarchar(128)
AS


UPDATE [dbo].[GrantRatio] SET
	[GrantRatioCode] = @GrantRatioCode,
	[GrantRatioName] = @GrantRatioName,
	[Description] = @Description,
	[Inactive] = @Inactive,
	[SortOrder] = @SortOrder,
	[CreatedDate] = @CreatedDate,
	[ModifiedDate] = @ModifiedDate,
	[IPAddress] = @IPAddress,
	[ModifiedBy] = @ModifiedBy,
	[CreatedBy] = @CreatedBy
WHERE
	[GrantRatioID] = @GrantRatioID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_UpdateLevel]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_UpdateLevel]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   Phamlai using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_UpdateLevel]
-- Date Generated: Saturday, January 13, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_UpdateLevel]
	@LevelID int,
	@LevelCode nvarchar(64),
	@LevelName nvarchar(128),
	@Description nvarchar(255),
	@Inactive bit,
	@SortOrder int,
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@IPAddress nvarchar(128),
	@ModifiedBy nvarchar(128),
	@CreatedBy nvarchar(128)
AS


UPDATE [dbo].[Level] SET
	[LevelCode] = @LevelCode,
	[LevelName] = @LevelName,
	[Description] = @Description,
	[Inactive] = @Inactive,
	[SortOrder] = @SortOrder,
	[CreatedDate] = @CreatedDate,
	[ModifiedDate] = @ModifiedDate,
	[IPAddress] = @IPAddress,
	[ModifiedBy] = @ModifiedBy,
	[CreatedBy] = @CreatedBy
WHERE
	[LevelID] = @LevelID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_UpdateMedicalRecord]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_UpdateMedicalRecord]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_UpdateMedicalRecord]
-- Date Generated: Monday, April 22, 2019
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_UpdateMedicalRecord]
	@MedicalRecordID int,
	@CustomerID int,
	@AppliedStandardID int,
	@MedicalRecordDescription nvarchar(255),
	@MedicalRecordLocation nvarchar(255),
	@MedicalRecordDate DATETIME,
	@FinalResult nvarchar(255),
	@CreatedBy nvarchar(128),
	@ModifiedBy nvarchar(128),
	@IPAddress nvarchar(128),
	@CreatedDate datetime,
	@ModifiedDate datetime
AS


UPDATE [dbo].[MedicalRecord] SET
	[CustomerID] = @CustomerID,
	[AppliedStandardID] = @AppliedStandardID,
	[MedicalRecordDescription] = @MedicalRecordDescription,
	[MedicalRecordLocation] = @MedicalRecordLocation,
	[MedicalRecordDate] = @MedicalRecordDate,
	[FinalResult] = @FinalResult,
	[CreatedBy] = @CreatedBy,
	[ModifiedBy] = @ModifiedBy,
	[IPAddress] = @IPAddress,
	[CreatedDate] = @CreatedDate,
	[ModifiedDate] = @ModifiedDate
WHERE
	[MedicalRecordID] = @MedicalRecordID

--endregion


GO
/****** Object:  StoredProcedure [dbo].[Proc_UpdatePermissionProjectMember]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Manh
-- Create date: 21.08.18
-- Description:	Cập nhật quyền cho thành viên trong đề tài
-- Proc_UpdatePermissionProjectMember 'c1644ef7-2bb9-4715-a3f8-3f21638d2c18','1c71ba3f-fba0-4533-9c81-551c2576cc7c'
-- Proc_UpdatePermissionProjectMember 'c1644ef7-2bb9-4715-a3f8-3f21638d2c18','1c71ba3f-fba0-4533-9c81-551c2576cc7c,f32ebd6e-a9d2-4703-aad2-1d83ac88b7c1'
-- Proc_UpdatePermissionProjectMember 'c1644ef7-2bb9-4715-a3f8-3f21638d2c18','1c71ba3f-fba0-4533-9c81-551c2576cc7c,f32ebd6e-a9d2-4703-aad2-1d83ac88b7c1,e97b5e01-71bb-4acf-bdf3-3278af5f7150'
-- =============================================
CREATE PROCEDURE [dbo].[Proc_UpdatePermissionProjectMember]
    @ProjectID UNIQUEIDENTIFIER ,
    @EmployeeIDs NVARCHAR(4000)
AS
    BEGIN
        IF EXISTS ( SELECT  Value
                    FROM    Func_ConvertGuidIntoTable(@EmployeeIDs, ',')
                    WHERE   Value NOT IN ( SELECT   EmployeeID
                                           FROM     dbo.ProjectInput
                                           WHERE    ProjectID = @ProjectID ) )
            BEGIN
                INSERT  INTO dbo.ProjectInput
                        ( ProjectInputID ,
                          ProjectID ,
                          EmployeeID
                        )
                        SELECT  NEWID() ,
                                @ProjectID ,
                                Value
                        FROM    Func_ConvertGuidIntoTable(@EmployeeIDs, ',')
                        WHERE   Value NOT IN ( SELECT   EmployeeID
                                               FROM     dbo.ProjectInput
                                               WHERE    ProjectID = @ProjectID )
            END
        ELSE
            BEGIN
                DELETE  FROM dbo.ProjectInput
                WHERE   ProjectID = @ProjectID
                        AND EmployeeID NOT IN (
                        SELECT  Value
                        FROM    Func_ConvertGuidIntoTable(@EmployeeIDs, ',') )
                
            END
        
    END




GO
/****** Object:  StoredProcedure [dbo].[Proc_UpdatePosition]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_UpdatePosition]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   manh using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_UpdatePosition]
-- Date Generated: Thursday, July 19, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_UpdatePosition]
	@PositionID uniqueidentifier,
	@PositionCode nvarchar(64),
	@PositionName nvarchar(128),
	@Description nvarchar(255),
	@Inactive bit,
	@SortOrder int,
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@IPAddress nvarchar(128),
	@ModifiedBy nvarchar(128),
	@CreatedBy nvarchar(128)
AS


UPDATE [dbo].[Position] SET
	[PositionCode] = @PositionCode,
	[PositionName] = @PositionName,
	[Description] = @Description,
	[Inactive] = @Inactive,
	[SortOrder] = @SortOrder,
	[CreatedDate] = @CreatedDate,
	[ModifiedDate] = @ModifiedDate,
	[IPAddress] = @IPAddress,
	[ModifiedBy] = @ModifiedBy,
	[CreatedBy] = @CreatedBy
WHERE
	[PositionID] = @PositionID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_UpdateProject]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_UpdateProject]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   THANG using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_UpdateProject]
-- Date Generated: Sunday, January 28, 2018
-- Ngày 14.05.2018. Hiệu chỉnh không cho Update giá trị: CreatedDate,CreatedBy
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_UpdateProject]
    @ProjectID UNIQUEIDENTIFIER ,
    @ProjectCode NVARCHAR(64) ,
    @ProjectName NVARCHAR(255) ,
    @ProjectNameAbbreviation NVARCHAR(255) ,
    @StartDate DATETIME ,
    @EndDate DATETIME ,
    @CompanyID UNIQUEIDENTIFIER ,
    @EmployeeID UNIQUEIDENTIFIER ,
    @Amount NUMERIC(20, 4) ,
    @Amount_Level1 NUMERIC(20, 4) ,
    @Amount_Level2 NUMERIC(20, 4) ,
    @Amount_Other NUMERIC(20, 4) ,
    @Program BIT ,
    @ProgramName NVARCHAR(255) ,
    @ProjectScience BIT ,
    @ProjectScienceName NVARCHAR(255) ,
    @IndependentTopic BIT ,
    @Nature BIT ,
    @AFF BIT ,
    @Technical BIT ,
    @Pharmacy BIT ,
    @Result NVARCHAR(255) ,
    @CompanyApply NVARCHAR(255) ,
    @Description NVARCHAR(255) ,
    @Status INT ,
    @LevelID INT ,
    @ProjectChairman UNIQUEIDENTIFIER ,
    @ProjectSecretary UNIQUEIDENTIFIER ,
    @ProjectCompanyChair UNIQUEIDENTIFIER ,
    @ProjectMember UNIQUEIDENTIFIER ,
    @ProjectCompanyCombination UNIQUEIDENTIFIER ,
    @Inactive BIT ,
    @SortOrder INT ,
    @CreatedDate DATETIME ,
    @ModifiedDate DATETIME ,
    @IPAddress NVARCHAR(128) ,
    @ModifiedBy NVARCHAR(128) ,
    @CreatedBy NVARCHAR(128) ,
    @GrantRatioID UNIQUEIDENTIFIER ,
    @MonthFin INT ,
    @YearFin INT
AS
    UPDATE  [dbo].[Project]
    SET     [ProjectCode] = @ProjectCode ,
            [ProjectName] = @ProjectName ,
            [ProjectNameAbbreviation] = @ProjectNameAbbreviation ,
            [StartDate] = @StartDate ,
            [EndDate] = @EndDate ,
            [CompanyID] = @CompanyID ,
            [EmployeeID] = @EmployeeID ,
            [Amount] = @Amount ,
            [Amount_Level1] = @Amount_Level1 ,
            [Amount_Level2] = @Amount_Level2 ,
            [Amount_Other] = @Amount_Other ,
            [Program] = @Program ,
            [ProgramName] = @ProgramName ,
            [ProjectScience] = @ProjectScience ,
            [ProjectScienceName] = @ProjectScienceName ,
            [IndependentTopic] = @IndependentTopic ,
            [Nature] = @Nature ,
            [AFF] = @AFF ,
            [Technical] = @Technical ,
            [Pharmacy] = @Pharmacy ,
            [Result] = @Result ,
            [CompanyApply] = @CompanyApply ,
            [Description] = @Description ,
            [Status] = @Status ,
            [LevelID] = @LevelID ,
            [ProjectChairman] = @ProjectChairman ,
            [ProjectSecretary] = @ProjectSecretary ,
            [ProjectCompanyChair] = @ProjectCompanyChair ,
            [ProjectMember] = @ProjectMember ,
            [ProjectCompanyCombination] = @ProjectCompanyCombination ,
            [Inactive] = @Inactive ,
            [SortOrder] = @SortOrder ,
	--[CreatedDate] = @CreatedDate,
            [ModifiedDate] = @ModifiedDate ,
            [IPAddress] = @IPAddress ,
            [ModifiedBy] = @ModifiedBy ,
	--[CreatedBy] = @CreatedBy,
            [GrantRatioID] = @GrantRatioID ,
            [MonthFin] = @MonthFin ,
            [YearFin] = @YearFin
    WHERE   [ProjectID] = @ProjectID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_UpdateProject_AttachDetail]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_UpdateProject_AttachDetail]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   THANG using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_UpdateProject_AttachDetail]
-- Date Generated: Sunday, February 4, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_UpdateProject_AttachDetail]
	@Project_AttachDetailID uniqueidentifier,
	@ProjectID uniqueidentifier,
	@Description nvarchar(255),
	@FileName nvarchar(100),
	@FileType nvarchar(64),
	@FileSize float,
	@SortOrder int,
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@IPAddress nvarchar(128),
	@ModifiedBy nvarchar(128),
	@CreatedBy nvarchar(128)
AS


UPDATE [dbo].[Project_AttachDetail] SET
	[ProjectID] = @ProjectID,
	[Description] = @Description,
	[FileName] = @FileName,
	[FileType] = @FileType,
	[FileSize] = @FileSize,
	[SortOrder] = @SortOrder,
	[CreatedDate] = @CreatedDate,
	[ModifiedDate] = @ModifiedDate,
	[IPAddress] = @IPAddress,
	[ModifiedBy] = @ModifiedBy,
	[CreatedBy] = @CreatedBy
WHERE
	[Project_AttachDetailID] = @Project_AttachDetailID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_UpdateProjectAcceptanceBasic]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_UpdateProjectAcceptanceBasic]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_UpdateProjectAcceptanceBasic]
-- Date Generated: 11 Tháng Hai 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_UpdateProjectAcceptanceBasic]
	@ProjectAcceptanceBasicID uniqueidentifier,
	@ProjectID uniqueidentifier,
	@EstablishedDate date,
	@MeetingDate date,
	@Status int,
	@Inactive bit,
	@SortOrder int,
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@IPAddress nvarchar(128),
	@ModifiedBy nvarchar(128),
	@CreatedBy nvarchar(128)
AS


UPDATE [dbo].[ProjectAcceptanceBasic] SET
	[ProjectID] = @ProjectID,
	[EstablishedDate] = @EstablishedDate,
	[MeetingDate] = @MeetingDate,
	[Status] = @Status,
	[Inactive] = @Inactive,
	[SortOrder] = @SortOrder,
	[CreatedDate] = @CreatedDate,
	[ModifiedDate] = @ModifiedDate,
	[IPAddress] = @IPAddress,
	[ModifiedBy] = @ModifiedBy,
	[CreatedBy] = @CreatedBy
WHERE
	[ProjectAcceptanceBasicID] = @ProjectAcceptanceBasicID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_UpdateProjectAcceptanceBasic_AttachDetail]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_UpdateProjectAcceptanceBasic_AttachDetail]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_UpdateProjectAcceptanceBasic_AttachDetail]
-- Date Generated: 05 Tháng Hai 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_UpdateProjectAcceptanceBasic_AttachDetail]
	@ProjectAcceptanceBasic_AttachDetailID uniqueidentifier,
	@ProjectAcceptanceBasicID uniqueidentifier,
	@Contents nvarchar(255),
	@FileName nvarchar(255),
	@FileType nvarchar(64),
	@FileSize float,
	@Inactive bit,
	@SortOrder int,
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@IPAddress nvarchar(128),
	@ModifiedBy nvarchar(128),
	@CreatedBy nvarchar(128)
AS


UPDATE [dbo].[ProjectAcceptanceBasic_AttachDetail] SET
	[ProjectAcceptanceBasicID] = @ProjectAcceptanceBasicID,
	[Contents] = @Contents,
	[FileName] = @FileName,
	[FileType] = @FileType,
	[FileSize] = @FileSize,
	[Inactive] = @Inactive,
	[SortOrder] = @SortOrder,
	[CreatedDate] = @CreatedDate,
	[ModifiedDate] = @ModifiedDate,
	[IPAddress] = @IPAddress,
	[ModifiedBy] = @ModifiedBy,
	[CreatedBy] = @CreatedBy
WHERE
	[ProjectAcceptanceBasic_AttachDetailID] = @ProjectAcceptanceBasic_AttachDetailID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_UpdateProjectAcceptanceManage]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_UpdateProjectAcceptanceManage]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_UpdateProjectAcceptanceManage]
-- Date Generated: 11 Tháng Hai 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_UpdateProjectAcceptanceManage]
	@ProjectAcceptanceManageID uniqueidentifier,
	@ProjectID uniqueidentifier,
	@EstablishedDate date,
	@MeetingDate date,
	@Status int,
	@Inactive bit,
	@SortOrder int,
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@IPAddress nvarchar(128),
	@ModifiedBy nvarchar(128),
	@CreatedBy nvarchar(128)
AS


UPDATE [dbo].[ProjectAcceptanceManage] SET
	[ProjectID] = @ProjectID,
	[EstablishedDate] = @EstablishedDate,
	[MeetingDate] = @MeetingDate,
	[Status] = @Status,
	[Inactive] = @Inactive,
	[SortOrder] = @SortOrder,
	[CreatedDate] = @CreatedDate,
	[ModifiedDate] = @ModifiedDate,
	[IPAddress] = @IPAddress,
	[ModifiedBy] = @ModifiedBy,
	[CreatedBy] = @CreatedBy
WHERE
	[ProjectAcceptanceManageID] = @ProjectAcceptanceManageID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_UpdateProjectAcceptanceManage_AttachDetail]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_UpdateProjectAcceptanceManage_AttachDetail]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_UpdateProjectAcceptanceManage_AttachDetail]
-- Date Generated: 09 Tháng Hai 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_UpdateProjectAcceptanceManage_AttachDetail]
	@ProjectAcceptanceManage_AttachDetailID uniqueidentifier,
	@ProjectAcceptanceManageID uniqueidentifier,
	@Contents nvarchar(255),
	@FileName nvarchar(255),
	@FileType nvarchar(64),
	@FileSize float,
	@Inactive bit,
	@SortOrder int,
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@IPAddress nvarchar(128),
	@ModifiedBy nvarchar(128),
	@CreatedBy nvarchar(128)
AS


UPDATE [dbo].[ProjectAcceptanceManage_AttachDetail] SET
	[ProjectAcceptanceManageID] = @ProjectAcceptanceManageID,
	[Contents] = @Contents,
	[FileName] = @FileName,
	[FileType] = @FileType,
	[FileSize] = @FileSize,
	[Inactive] = @Inactive,
	[SortOrder] = @SortOrder,
	[CreatedDate] = @CreatedDate,
	[ModifiedDate] = @ModifiedDate,
	[IPAddress] = @IPAddress,
	[ModifiedBy] = @ModifiedBy,
	[CreatedBy] = @CreatedBy
WHERE
	[ProjectAcceptanceManage_AttachDetailID] = @ProjectAcceptanceManage_AttachDetailID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_UpdateProjectClose]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_UpdateProjectClose]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_UpdateProjectClose]
-- Date Generated: 11 Tháng Hai 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_UpdateProjectClose]
	@ProjectCloseID uniqueidentifier,
	@ProjectID uniqueidentifier,
	@Date date,
	@LiquidationDate date,
	@FileName nvarchar(255),
	@FileType nvarchar(64),
	@FileSize float,
	@Inactive bit,
	@SortOrder int,
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@IPAddress nvarchar(128),
	@ModifiedBy nvarchar(128),
	@CreatedBy nvarchar(128)
AS


UPDATE [dbo].[ProjectClose] SET
	[ProjectID] = @ProjectID,
	[Date] = @Date,
	[LiquidationDate] = @LiquidationDate,
	[FileName] = @FileName,
	[FileType] = @FileType,
	[FileSize] = @FileSize,
	[Inactive] = @Inactive,
	[SortOrder] = @SortOrder,
	[CreatedDate] = @CreatedDate,
	[ModifiedDate] = @ModifiedDate,
	[IPAddress] = @IPAddress,
	[ModifiedBy] = @ModifiedBy,
	[CreatedBy] = @CreatedBy
WHERE
	[ProjectCloseID] = @ProjectCloseID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_UpdateProjectExperiment]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_UpdateProjectExperiment]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   Admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_UpdateProjectExperiment]
-- Date Generated: Sunday, February 25, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_UpdateProjectExperiment]
	@ProjectExperimentID uniqueidentifier,
	@ProjectID uniqueidentifier,
	@FileName nvarchar(255),
	@FileType nvarchar(64),
	@FileSize float,
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@IPAddress nvarchar(128),
	@ModifiedBy nvarchar(128),
	@CreatedBy nvarchar(128)
AS


UPDATE [dbo].[ProjectExperiment] SET
	[ProjectID] = @ProjectID,
	[FileName] = @FileName,
	[FileType] = @FileType,
	[FileSize] = @FileSize,
	[CreatedDate] = @CreatedDate,
	[ModifiedDate] = @ModifiedDate,
	[IPAddress] = @IPAddress,
	[ModifiedBy] = @ModifiedBy,
	[CreatedBy] = @CreatedBy
WHERE
	[ProjectExperimentID] = @ProjectExperimentID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_UpdateProjectExperiment_AttachDetail]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_UpdateProjectExperiment_AttachDetail]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   Admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_UpdateProjectExperiment_AttachDetail]
-- Date Generated: Sunday, February 25, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_UpdateProjectExperiment_AttachDetail]
    @ProjectExperiment_AttachDetailID UNIQUEIDENTIFIER ,
    @ID UNIQUEIDENTIFIER ,
    @FileName NVARCHAR(255) ,
    @FileType NVARCHAR(64) ,
    @FileSize FLOAT ,
    @Description NVARCHAR(255) ,
    @SortOrder INT ,
    @CreatedDate DATETIME ,
    @ModifiedDate DATETIME ,
    @IPAddress NVARCHAR(128) ,
    @ModifiedBy NVARCHAR(128) ,
    @CreatedBy NVARCHAR(128)
AS
    BEGIN
        UPDATE  [dbo].[ProjectExperiment_AttachDetail]
        SET     [ID] = @ID ,
                [FileName] = @FileName ,
                [FileType] = @FileType ,
                [FileSize] = @FileSize ,
                [Description] = @Description ,
                [SortOrder] = @SortOrder ,
                [CreatedDate] = @CreatedDate ,
                [ModifiedDate] = @ModifiedDate ,
                [IPAddress] = @IPAddress ,
                [ModifiedBy] = @ModifiedBy ,
                [CreatedBy] = @CreatedBy
        WHERE   [ProjectExperiment_AttachDetailID] = @ProjectExperiment_AttachDetailID

        UPDATE  dbo.ContentServey
        SET     IdFiles = dbo.Func_GroupFileContenExperimentIntoMaster(@ID)
        WHERE   ID = @ID
    END
--endregion





GO
/****** Object:  StoredProcedure [dbo].[PROC_UpdateProjectInput]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Manh
-- Create date: 22.08.18
-- Description:	Cập nhật các Cán bộ được chọn vào Project Input
-- Proc_UpdateProjectInput 'c1644ef7-2bb9-4715-a3f8-3f21638d2c18','C9491196-7815-4189-A27D-009825058117,EA948E5E-2FC1-4327-B0B6-011F3CEB38CD'
-- =============================================
CREATE PROCEDURE [dbo].[PROC_UpdateProjectInput]
    @ProjectID UNIQUEIDENTIFIER ,
    @EmployeeIDs NVARCHAR(4000)
AS
    BEGIN
        INSERT  INTO dbo.ProjectInput
                ( ProjectInputID ,
                  ProjectID ,
                  EmployeeID
	            )
                SELECT  NEWID() ,
                        @ProjectID ,
                        Value
                FROM    Func_ConvertGuidIntoTable(@EmployeeIDs, ',')
    END




GO
/****** Object:  StoredProcedure [dbo].[Proc_UpdateProjectMember]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_UpdateProjectMember]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   truong using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_UpdateProjectMember]
-- Date Generated: Sunday, January 28, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_UpdateProjectMember]
	@ProjectMemberID uniqueidentifier,
	@ProjectID uniqueidentifier,
	@EmployeeID uniqueidentifier,
	@FullName nvarchar(255),
	@StartDate date,
	@EndDate date,
	@MonthForProject numeric(20, 4),
	@ProjectPositionID uniqueidentifier,
	@Inactive bit,
	@SortOrder int,
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@IPAddress nvarchar(128),
	@ModifiedBy nvarchar(128),
	@CreatedBy nvarchar(128)
AS
--IF NOT EXISTS (SELECT 1 FROM [dbo].[ProjectMember] WHERE [FullName] = @FullName)
BEGIN
UPDATE [dbo].[ProjectMember] SET
	[ProjectID] = @ProjectID,
	[EmployeeID] = @EmployeeID,
	[FullName] = @FullName,
	[StartDate] = @StartDate,
	[EndDate] = @EndDate,
	[MonthForProject] = @MonthForProject,
	[ProjectPositionID] = @ProjectPositionID,
	[Inactive] = @Inactive,
	[SortOrder] = @SortOrder,
	[CreatedDate] = @CreatedDate,
	[ModifiedDate] = @ModifiedDate,
	[IPAddress] = @IPAddress,
	[ModifiedBy] = @ModifiedBy,
	[CreatedBy] = @CreatedBy
WHERE
	[ProjectMemberID] = @ProjectMemberID
END



--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_UpdateProjectPlanExpense]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_UpdateProjectPlanExpense]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   truong using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_UpdateProjectPlanExpense]
-- Date Generated: Sunday, January 28, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_UpdateProjectPlanExpense]
	@ProjectPlanExpenseID uniqueidentifier,
	@ProjectID uniqueidentifier,
	@Number nvarchar(64),
	@Date date,
	@Amount numeric(20, 4),
	@Inactive bit,
	@SortOrder int,
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@IPAddress nvarchar(128),
	@ModifiedBy nvarchar(128),
	@CreatedBy nvarchar(128)
AS


UPDATE [dbo].[ProjectPlanExpense] SET
	[ProjectID] = @ProjectID,
	[Number] = @Number,
	[Date] = @Date,
	[Amount] = @Amount,
	[Inactive] = @Inactive,
	[SortOrder] = @SortOrder,
	[CreatedDate] = @CreatedDate,
	[ModifiedDate] = @ModifiedDate,
	[IPAddress] = @IPAddress,
	[ModifiedBy] = @ModifiedBy,
	[CreatedBy] = @CreatedBy
WHERE
	[ProjectPlanExpenseID] = @ProjectPlanExpenseID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_UpdateProjectPlanExpense_AttachDetail]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_UpdateProjectPlanExpense_AttachDetail]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_UpdateProjectPlanExpense_AttachDetail]
-- Date Generated: 14 Tháng Giêng 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_UpdateProjectPlanExpense_AttachDetail]
	@ProjectPlanExpense_AttachDetailID uniqueidentifier,
	@ProjectPlanExpenseID uniqueidentifier,
	@FileName nvarchar(255),
	@FileType nvarchar(64),
	@Description nvarchar(255),
	@FileSize float,
	@Inactive bit,
	@SortOrder int,
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@IPAddress nvarchar(128),
	@ModifiedBy nvarchar(128),
	@CreatedBy nvarchar(128)
AS


UPDATE [dbo].[ProjectPlanExpense_AttachDetail] SET
	[ProjectPlanExpenseID] = @ProjectPlanExpenseID,
	[FileName] = @FileName,
	[FileType] = @FileType,
	[FileSize] = @FileSize,
	[Description] = @Description,
	[Inactive] = @Inactive,
	[SortOrder] = @SortOrder,
	[CreatedDate] = @CreatedDate,
	[ModifiedDate] = @ModifiedDate,
	[IPAddress] = @IPAddress,
	[ModifiedBy] = @ModifiedBy,
	[CreatedBy] = @CreatedBy
WHERE
	[ProjectPlanExpense_AttachDetailID] = @ProjectPlanExpense_AttachDetailID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_UpdateProjectPlanPerform]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_UpdateProjectPlanPerform]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   Phamlai using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_UpdateProjectPlanPerform]
-- Date Generated: Monday, January 29, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_UpdateProjectPlanPerform]
	@ProjectPlanPerformID uniqueidentifier,
	@ProjectID uniqueidentifier,
	@Number nvarchar(64),
	@Date date,
	@Inactive bit,
	@SortOrder int,
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@IPAddress nvarchar(128),
	@ModifiedBy nvarchar(128),
	@CreatedBy nvarchar(128)
AS


UPDATE [dbo].[ProjectPlanPerform] SET
	[ProjectID] = @ProjectID,
	[Number] = @Number,
	[Date] = @Date,
	[Inactive] = @Inactive,
	[SortOrder] = @SortOrder,
	[CreatedDate] = @CreatedDate,
	[ModifiedDate] = @ModifiedDate,
	[IPAddress] = @IPAddress,
	[ModifiedBy] = @ModifiedBy,
	[CreatedBy] = @CreatedBy
WHERE
	[ProjectPlanPerformID] = @ProjectPlanPerformID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_UpdateProjectPlanPerform_AttachDetail]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_UpdateProjectPlanPerform_AttachDetail]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   truong using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_UpdateProjectPlanPerform_AttachDetail]
-- Date Generated: Sunday, February 11, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_UpdateProjectPlanPerform_AttachDetail]
	@ProjectPlanPerform_AttachDetailID uniqueidentifier,
	@ProjectPlanPerformID uniqueidentifier,
	@FileName nvarchar(255),
	@FileType nvarchar(64),
	@Description nvarchar(255),
	@FileSize float,
	@Inactive bit,
	@SortOrder int,
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@IPAddress nvarchar(128),
	@ModifiedBy nvarchar(128),
	@CreatedBy nvarchar(128)
AS
BEGIN
UPDATE [dbo].[ProjectPlanPerform_AttachDetail] SET
	[ProjectPlanPerformID] = @ProjectPlanPerformID,
	[FileName] = @FileName,
	[FileType] = @FileType,
	[Description] = @Description,
	[FileSize] = @FileSize,
	[Inactive] = @Inactive,
	[SortOrder] = @SortOrder,
	[CreatedDate] = @CreatedDate,
	[ModifiedDate] = @ModifiedDate,
	[IPAddress] = @IPAddress,
	[ModifiedBy] = @ModifiedBy,
	[CreatedBy] = @CreatedBy
WHERE
	[ProjectPlanPerform_AttachDetailID] = @ProjectPlanPerform_AttachDetailID

UPDATE  dbo.ProjectPlanPerform
        SET     IdFiles = dbo.[Func_GroupFileProjectPlanPerformIntoMaster](@ProjectPlanPerformID)
        WHERE   ProjectPlanPerformID = @ProjectPlanPerformID
END


--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_UpdateProjectPosition]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_UpdateProjectPosition]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_UpdateProjectPosition]
-- Date Generated: 14 Tháng Giêng 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_UpdateProjectPosition]
	@ProjectPositionID uniqueidentifier,
	@ProjectPositionCode nvarchar(64),
	@ProjectPositionName nvarchar(128),
	@ProjectPositionShortName nvarchar(128),
	@Coefficient decimal(20, 4),
	@Description nvarchar(255),
	@Inactive bit,
	@SortOrder int,
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@IPAddress nvarchar(128),
	@ModifiedBy nvarchar(128),
	@CreatedBy nvarchar(128)
AS


UPDATE [dbo].[ProjectPosition] SET
	[ProjectPositionCode] = @ProjectPositionCode,
	[ProjectPositionName] = @ProjectPositionName,
	[ProjectPositionShortName] = @ProjectPositionShortName,
	[Coefficient] = @Coefficient,
	[Description] = @Description,
	[Inactive] = @Inactive,
	[SortOrder] = @SortOrder,
	[CreatedDate] = @CreatedDate,
	[ModifiedDate] = @ModifiedDate,
	[IPAddress] = @IPAddress,
	[ModifiedBy] = @ModifiedBy,
	[CreatedBy] = @CreatedBy
WHERE
	[ProjectPositionID] = @ProjectPositionID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_UpdateProjectPresentProtected]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_UpdateProjectPresentProtected]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_UpdateProjectPresentProtected]
-- Date Generated: 14 Tháng Giêng 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_UpdateProjectPresentProtected]
	@ProjectPresentProtectedID uniqueidentifier,
	@ProjectID uniqueidentifier,
	@DecisionNumber nvarchar(64),
	@DecisionDate date,
	@ProtectedDate date,
	@Status int,
	@Inactive bit,
	@SortOrder int,
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@IPAddress nvarchar(128),
	@ModifiedBy nvarchar(128),
	@CreatedBy nvarchar(128)
AS


UPDATE [dbo].[ProjectPresentProtected] SET
	[ProjectID] = @ProjectID,
	[DecisionNumber] = @DecisionNumber,
	[DecisionDate] = @DecisionDate,
	[ProtectedDate] = @ProtectedDate,
	[Status] = @Status,
	[Inactive] = @Inactive,
	[SortOrder] = @SortOrder,
	[CreatedDate] = @CreatedDate,
	[ModifiedDate] = @ModifiedDate,
	[IPAddress] = @IPAddress,
	[ModifiedBy] = @ModifiedBy,
	[CreatedBy] = @CreatedBy
WHERE
	[ProjectPresentProtectedID] = @ProjectPresentProtectedID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_UpdateProjectPresentProtected_AttachDetail]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_UpdateProjectPresentProtected_AttachDetail]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_UpdateProjectPresentProtected_AttachDetail]
-- Date Generated: 14 Tháng Giêng 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_UpdateProjectPresentProtected_AttachDetail]
	@ProjectPresentProtected_AttachDetailID uniqueidentifier,
	@ProjectPresentProtectedID uniqueidentifier,
	@FileName nvarchar(255),
	@FileType nvarchar(64),
	@FileSize float,
	@Inactive bit,
	@SortOrder int,
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@IPAddress nvarchar(128),
	@ModifiedBy nvarchar(128),
	@CreatedBy nvarchar(128)
AS


UPDATE [dbo].[ProjectPresentProtected_AttachDetail] SET
	[ProjectPresentProtectedID] = @ProjectPresentProtectedID,
	[FileName] = @FileName,
	[FileType] = @FileType,
	[FileSize] = @FileSize,
	[Inactive] = @Inactive,
	[SortOrder] = @SortOrder,
	[CreatedDate] = @CreatedDate,
	[ModifiedDate] = @ModifiedDate,
	[IPAddress] = @IPAddress,
	[ModifiedBy] = @ModifiedBy,
	[CreatedBy] = @CreatedBy
WHERE
	[ProjectPresentProtected_AttachDetailID] = @ProjectPresentProtected_AttachDetailID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_UpdateProjectProgressReport]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_UpdateProjectProgressReport]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   truong using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_UpdateProjectProgressReport]
-- Date Generated: Wednesday, January 31, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_UpdateProjectProgressReport]
	@ProjectProgressReportID uniqueidentifier,
	@ProjectID uniqueidentifier,
	@TermID int,
	@TermName nvarchar(255),
	@DateReport date,
	@DateCheck date,
	@Result int,
	@Inactive bit,
	@SortOrder int,
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@IPAddress nvarchar(128),
	@ModifiedBy nvarchar(128),
	@CreatedBy nvarchar(128)
AS


UPDATE [dbo].[ProjectProgressReport] SET
	[ProjectID] = @ProjectID,
	[TermID] = @TermID,
	[TermName] = @TermName,
	[DateReport] = @DateReport,
	[DateCheck] = @DateCheck,
	[Result] = @Result,
	[Inactive] = @Inactive,
	[SortOrder] = @SortOrder,
	[CreatedDate] = @CreatedDate,
	[ModifiedDate] = @ModifiedDate,
	[IPAddress] = @IPAddress,
	[ModifiedBy] = @ModifiedBy,
	[CreatedBy] = @CreatedBy
WHERE
	[ProjectProgressReportID] = @ProjectProgressReportID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_UpdateProjectProgressReport_AttachDetail]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_UpdateProjectProgressReport_AttachDetail]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   truong using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_UpdateProjectProgressReport_AttachDetail]
-- Date Generated: Sunday, February 25, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_UpdateProjectProgressReport_AttachDetail]
	@ProjectProgressReport_AttachDetailID uniqueidentifier,
	@ProjectProgressReportID uniqueidentifier,
	@FileName nvarchar(255),
	@Description nvarchar(255),
	@FileType nvarchar(64),
	@FileSize float,
	@Inactive bit,
	@SortOrder int,
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@IPAddress nvarchar(128),
	@ModifiedBy nvarchar(128),
	@CreatedBy nvarchar(128)
AS
BEGIN
UPDATE [dbo].[ProjectProgressReport_AttachDetail] SET
	[ProjectProgressReportID] = @ProjectProgressReportID,
	[FileName] = @FileName,
	[Description] = @Description,
	[FileType] = @FileType,
	[FileSize] = @FileSize,
	[Inactive] = @Inactive,
	[SortOrder] = @SortOrder,
	[CreatedDate] = @CreatedDate,
	[ModifiedDate] = @ModifiedDate,
	[IPAddress] = @IPAddress,
	[ModifiedBy] = @ModifiedBy,
	[CreatedBy] = @CreatedBy
WHERE
	[ProjectProgressReport_AttachDetailID] = @ProjectProgressReport_AttachDetailID
UPDATE  dbo.ProjectProgressReport
        SET     IdFiles = dbo.[Func_GroupFileProjectProgressReportIntoMaster](@ProjectProgressReportID)
        WHERE   ProjectProgressReportID = @ProjectProgressReportID
		
		

END


--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_UpdateProjectSurvey]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_UpdateProjectSurvey]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   THANG using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_UpdateProjectSurvey]
-- Date Generated: Saturday, February 24, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_UpdateProjectSurvey]
	@ProjectSurveyID uniqueidentifier,
	@ProjectID uniqueidentifier,
	@FileName nvarchar(255),
	@FileType nvarchar(64),
	@FileSize float,
	@ModifiedDate datetime,
	@IPAddress nvarchar(128),
	@ModifiedBy nvarchar(128)
AS


UPDATE [dbo].[ProjectSurvey] SET
	[ProjectID] = @ProjectID,
	[FileName] = @FileName,
	[FileType] = @FileType,
	[FileSize] = @FileSize,	
	[ModifiedDate] = @ModifiedDate,
	[IPAddress] = @IPAddress,
	[ModifiedBy] = @ModifiedBy	
WHERE
	[ProjectSurveyID] = @ProjectSurveyID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_UpdateProjectSurvey_AttachDetail]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_UpdateProjectSurvey_AttachDetail]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   THANG using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_UpdateProjectSurvey_AttachDetail]
-- Date Generated: Saturday, February 24, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_UpdateProjectSurvey_AttachDetail]
    @ProjectSurvey_AttachDetailID UNIQUEIDENTIFIER ,
    @ID UNIQUEIDENTIFIER ,
    @FileName NVARCHAR(255) ,
    @FileType NVARCHAR(64) ,
    @FileSize FLOAT ,
    @SortOrder INT ,
    @ModifiedDate DATETIME ,
    @IPAddress NVARCHAR(128) ,
    @ModifiedBy NVARCHAR(128) ,
    @Description NVARCHAR(255)
AS
    BEGIN
        
        UPDATE  [dbo].[ProjectSurvey_AttachDetail]
        SET     [ID] = @ID ,
                [FileName] = @FileName ,
                [FileType] = @FileType ,
                [FileSize] = @FileSize ,
                [SortOrder] = @SortOrder ,
                [ModifiedDate] = @ModifiedDate ,
                [IPAddress] = @IPAddress ,
                [ModifiedBy] = @ModifiedBy ,
                Description = @Description
        WHERE   [ProjectSurvey_AttachDetailID] = @ProjectSurvey_AttachDetailID

		UPDATE  dbo.ContentServey
        SET     IdFiles = dbo.Func_GroupFileContenServeyIntoMaster(@ID)
        WHERE   ID = @ID

    END
--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_UpdateProjectTask]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_UpdateProjectTask]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   THANG using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_UpdateProjectTask]
-- Date Generated: Sunday, February 11, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_UpdateProjectTask]
    @ProjectTaskID UNIQUEIDENTIFIER ,
    @ParentID UNIQUEIDENTIFIER ,
    @ProjectID UNIQUEIDENTIFIER ,
    @Contents NVARCHAR(4000) ,
    @Rank INT ,
    @Result NVARCHAR(255) ,
    @StartDate DATETIME ,
    @EndDate DATETIME ,
    @EmployeeID UNIQUEIDENTIFIER ,
    @Status INT ,
    @Inactive BIT ,
    @ModifiedDate DATETIME ,
    @IPAddress NVARCHAR(128) ,
    @ModifiedBy NVARCHAR(128)
AS
    BEGIN
	  
        DECLARE @code HIERARCHYID
        IF @ParentID IS NULL
            AND EXISTS ( SELECT *
                         FROM   dbo.ProjectTask
                         WHERE  ProjectTaskID = @ProjectTaskID
                                AND ParentID IS NOT NULL )
            BEGIN
                SET @code = dbo.Func_GetCodeTree(NULL)
                UPDATE  dbo.ProjectTask
                SET     Code = @code
                WHERE   ProjectTaskID = @ProjectTaskID
            END
        ELSE
            IF NOT EXISTS ( SELECT  *
                            FROM    dbo.ProjectTask
                            WHERE   ParentID = @ParentID
                                    AND ProjectTaskID = @ProjectTaskID )
                BEGIN
                        EXEC Proc_MoveProjectTask @ParentID, @ProjectTaskID
                END	

        UPDATE  [dbo].[ProjectTask]
        SET     [ParentID] = @ParentID ,
                [ProjectID] = @ProjectID ,
                [Contents] = @Contents ,
                [Rank] = @Rank ,
                [Result] = @Result ,
                [StartDate] = @StartDate ,
                [EndDate] = @EndDate ,
                [EmployeeID] = @EmployeeID ,
                [Status] = @Status ,
                [Inactive] = @Inactive ,
                [ModifiedDate] = @ModifiedDate ,
                [IPAddress] = @IPAddress ,
                [ModifiedBy] = @ModifiedBy
        WHERE   [ProjectTaskID] = @ProjectTaskID

    END
--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_UpdateProjectTaskMember]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_UpdateProjectTaskMember]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   THANG using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_UpdateProjectTaskMember]
-- Date Generated: Thursday, March 8, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_UpdateProjectTaskMember]
	@ProjectTaskMemberID uniqueidentifier,
	@ProjectTaskID uniqueidentifier,
	@EmployeeID uniqueidentifier,
	@StartDate datetime,
	@EndDate datetime,
	@MonthForTask numeric(20, 4),
	@SortOrder int,
	@ModifiedDate datetime,
	@IPAddress nvarchar(128),
	@ModifiedBy nvarchar(128)
AS


UPDATE [dbo].[ProjectTaskMember] SET
	[ProjectTaskID] = @ProjectTaskID,
	[EmployeeID] = @EmployeeID,
	[StartDate] = @StartDate,
	[EndDate] = @EndDate,
	[MonthForTask] = @MonthForTask,
	[SortOrder] = @SortOrder,
	[ModifiedDate] = @ModifiedDate,
	[IPAddress] = @IPAddress,
	[ModifiedBy] = @ModifiedBy
WHERE
	[ProjectTaskMemberID] = @ProjectTaskMemberID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_UpdateProjectTaskSortOrder]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--region [dbo].[Proc_SelectProjectTaskByID]

------------------------------------------------------------------------------------------------------------------------
-- CreatedBy:   manh
-- CreatedDate: 09.03.2018
-- Description: Cập nhật Sort Order
------------------------------------------------------------------------------------------------------------------------
--[dbo].[Proc_UpdateProjectTaskSortOrder] '7CB9A2A9-443D-47D2-9D9A-99A157459F5C','A644F5D6-F96C-43C6-9334-9CF0E03B2BAA'
CREATE PROCEDURE [dbo].[Proc_UpdateProjectTaskSortOrder]
    @projectTaskIDOld UNIQUEIDENTIFIER ,
    @projectTaskIDNew UNIQUEIDENTIFIER
AS
    BEGIN


        DECLARE @CodeOld HIERARCHYID ,
            @CodeNew HIERARCHYID;

        SELECT  @CodeOld = Code
        FROM    dbo.ProjectTask
        WHERE   ProjectTaskID = @projectTaskIDOld

        SELECT  @CodeNew = Code
        FROM    dbo.ProjectTask
        WHERE   ProjectTaskID = @projectTaskIDNew

       -- BEGIN TRANSACTION
        --BEGIN TRY  
		--Hoán đổi code giữa 2 thằng
        UPDATE  dbo.ProjectTask
        SET     CodeVirtual = @CodeNew
        WHERE   ProjectTaskID = @projectTaskIDOld

        UPDATE  dbo.ProjectTask
        SET     CodeVirtual = @CodeOld
        WHERE   ProjectTaskID = @projectTaskIDNew

			
		--Đánh lại code cho thằng cũ

        DECLARE @ParentID UNIQUEIDENTIFIER ,
            @id UNIQUEIDENTIFIER
        SELECT  1
        DECLARE curOld CURSOR FAST_FORWARD READ_ONLY
        FOR
            SELECT  ParentID ,
                    ProjectTaskID
            FROM    dbo.ProjectTask
            WHERE   Code.IsDescendantOf(@CodeOld) = 'TRUE'
                    AND Code != @CodeOld
            ORDER BY Code

        OPEN curOld

			
        FETCH NEXT FROM curOld INTO @ParentID, @id

        WHILE @@FETCH_STATUS = 0
            BEGIN
                UPDATE  dbo.ProjectTask
                SET     CodeVirtual = dbo.[Func_GetCodeVirtualree](@ParentID)
                WHERE   ProjectTaskID = @id
                FETCH NEXT FROM curOld INTO @ParentID, @id

            END

        CLOSE curOld
        DEALLOCATE curOld

		--Đánh lại code cho thằng mới
        DECLARE curNew CURSOR FAST_FORWARD READ_ONLY
        FOR
            SELECT  ParentID ,
                    ProjectTaskID
            FROM    dbo.ProjectTask
            WHERE   Code.IsDescendantOf(@CodeNew) = 'TRUE'
                    AND Code != @CodeNew
            ORDER BY Code

        OPEN curNew

        FETCH NEXT FROM curNew INTO @ParentID, @id

        WHILE @@FETCH_STATUS = 0
            BEGIN
                UPDATE  dbo.ProjectTask
                SET     CodeVirtual = dbo.[Func_GetCodeVirtualree](@ParentID)
                WHERE   ProjectTaskID = @id
  
                FETCH NEXT FROM curNew INTO @ParentID, @id

            END

        CLOSE curNew
        DEALLOCATE curNew

        UPDATE  dbo.ProjectTask
        SET     Code = CodeVirtual
        WHERE   CodeVirtual IS NOT NULL

        UPDATE  dbo.ProjectTask
        SET     CodeVirtual = NULL
            
    END



	




GO
/****** Object:  StoredProcedure [dbo].[Proc_UpdateProjectWorkshop]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_UpdateProjectWorkshop]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   truong using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_UpdateProjectWorkshop]
-- Date Generated: Sunday, January 28, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_UpdateProjectWorkshop]
	@ProjectWorkshopID uniqueidentifier,
	@ProjectID uniqueidentifier,
	@Date date,
	@Time DATETIME,
	@Adderess nvarchar(128),
	@Contents nvarchar(255),
	@SortOrder int,
	@ModifiedDate datetime,
	@IPAddress nvarchar(128),
	@ModifiedBy nvarchar(128)
AS


UPDATE [dbo].[ProjectWorkshop] SET
	[ProjectID] = @ProjectID,
	[Date] = @Date,
	[Time] = @Time,
	[Adderess] = @Adderess,
	[Contents] = @Contents,
	[SortOrder] = @SortOrder,
	[ModifiedDate] = @ModifiedDate,
	[IPAddress] = @IPAddress,
	[ModifiedBy] = @ModifiedBy
WHERE
	[ProjectWorkshopID] = @ProjectWorkshopID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_UpdateProjectWorkshop_AttachDetail]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_UpdateProjectWorkshop_AttachDetail]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   Admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_UpdateProjectWorkshop_AttachDetail]
-- Date Generated: Saturday, February 24, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_UpdateProjectWorkshop_AttachDetail]
    @ProjectWorkshop_AttachDetailID UNIQUEIDENTIFIER ,
    @ProjectWorkshopID UNIQUEIDENTIFIER ,
    @Description NVARCHAR(255) ,
    @FileName NVARCHAR(255) ,
    @FileType NVARCHAR(64) ,
    @FileSize FLOAT ,
    @SortOrder INT ,
    @ModifiedDate DATETIME ,
    @IPAddress NVARCHAR(128) ,
    @ModifiedBy NVARCHAR(128)
AS
    BEGIN

        UPDATE  [dbo].[ProjectWorkshop_AttachDetail]
        SET     [ProjectWorkshopID] = @ProjectWorkshopID ,
                [Description] = @Description ,
                [FileName] = @FileName ,
                [FileType] = @FileType ,
                [FileSize] = @FileSize ,
                [SortOrder] = @SortOrder ,
                [ModifiedDate] = @ModifiedDate ,
                [IPAddress] = @IPAddress ,
                [ModifiedBy] = @ModifiedBy
        WHERE   [ProjectWorkshop_AttachDetailID] = @ProjectWorkshop_AttachDetailID

        UPDATE  dbo.ProjectWorkshop
        SET     IdFiles = dbo.[Func_GroupFileProjectWorkshopIntoMaster](@ProjectWorkshopID)
        WHERE   ProjectWorkshopID = @ProjectWorkshopID
    END
--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_UpdateQADetail]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_UpdateQADetail]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_UpdateQADetail]
-- Date Generated: Tuesday, May 14, 2019
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_UpdateQADetail]
	@QADetailID int,
	@QATopicID int,
	@QuestionContent nvarchar(3500),
	@AnswerContent nvarchar(3500),
	@PublicState bit,
	@QuestionBy nvarchar(128),
	@QuestionDate datetime,
	@AnswerBy nvarchar(128),
	@AnswerDate datetime,
	@ModifiedDate datetime,
	@ModifiedBy nvarchar(128),
	@IPAddress nvarchar(128)
AS


UPDATE [dbo].[QADetail] SET
	[QATopicID] = @QATopicID,
	[QuestionContent] = @QuestionContent,
	[AnswerContent] = @AnswerContent,
	[PublicState] = @PublicState,
	[QuestionBy] = @QuestionBy,
	[QuestionDate] = @QuestionDate,
	[AnswerBy] = @AnswerBy,
	[AnswerDate] = @AnswerDate,
	[ModifiedDate] = @ModifiedDate,
	[ModifiedBy] = @ModifiedBy,
	[IPAddress] = @IPAddress
WHERE
	[QADetailID] = @QADetailID

--endregion


GO
/****** Object:  StoredProcedure [dbo].[Proc_UpdateQATopic]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_UpdateQATopic]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_UpdateQATopic]
-- Date Generated: Tuesday, May 14, 2019
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_UpdateQATopic]
	@QATopicID int,
	@QATopicCode nvarchar(64),
	@QATopicName nvarchar(128),
	@Description nvarchar(255),
	@Inactive bit,
	@SortOrder int,
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@IPAddress nvarchar(128),
	@ModifiedBy nvarchar(128),
	@CreatedBy nvarchar(128)
AS


UPDATE [dbo].[QATopic] SET
	[QATopicCode] = @QATopicCode,
	[QATopicName] = @QATopicName,
	[Description] = @Description,
	[Inactive] = @Inactive,
	[SortOrder] = @SortOrder,
	[CreatedDate] = @CreatedDate,
	[ModifiedDate] = @ModifiedDate,
	[IPAddress] = @IPAddress,
	[ModifiedBy] = @ModifiedBy,
	[CreatedBy] = @CreatedBy
WHERE
	[QATopicID] = @QATopicID

--endregion


GO
/****** Object:  StoredProcedure [dbo].[Proc_UpdateRank]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_UpdateRank]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   THANG using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_UpdateRank]
-- Date Generated: Monday, January 8, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_UpdateRank]
	@RankID uniqueidentifier,
	@RankCode nvarchar(50),
	@RankName nvarchar(128),
	@Description nvarchar(255),
	@Inactive bit,
	@SortOrder int,
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@IPAddress nvarchar(128),
	@ModifiedBy nvarchar(128),
	@CreatedBy nvarchar(128)
AS


UPDATE [dbo].[Rank] SET
	[RankCode] = @RankCode,
	[RankName] = @RankName,
	[Description] = @Description,
	[Inactive] = @Inactive,
	[SortOrder] = @SortOrder,
	[CreatedDate] = @CreatedDate,
	[ModifiedDate] = @ModifiedDate,
	[IPAddress] = @IPAddress,
	[ModifiedBy] = @ModifiedBy,
	[CreatedBy] = @CreatedBy
WHERE
	[RankID] = @RankID

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_UpdateRptSolidWaste]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_UpdateRptSolidWaste]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   Admin using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_UpdateRptSolidWaste]
-- Date Generated: November 19, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_UpdateRptSolidWaste]
	@RptSolidWasteID int,
	@ReportYear int,
	@CompanyID int,
	@ClassifyStatus bit,
	@WasteTypeID int,
	@Quantity numeric(18, 4),
	@CollectingType int,
	@CollectingTypeDescription nvarchar(1000),
	@CollectingContractNumber nvarchar(150),
	@CollectingContractDate datetime,
	@CollectingContractCompany nvarchar(150),
	@CreatedBy nvarchar(128),
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@ModifiedBy nvarchar(128),
	@IPAddress nvarchar(128)
AS


UPDATE [dbo].[RptSolidWaste] SET
	[ReportYear] = @ReportYear,
	[CompanyID] = @CompanyID,
	[ClassifyStatus] = @ClassifyStatus,
	[WasteTypeID] = @WasteTypeID,
	[Quantity] = @Quantity,
	[CollectingType] = @CollectingType,
	[CollectingTypeDescription] = @CollectingTypeDescription,
	[CollectingContractNumber] = @CollectingContractNumber,
	[CollectingContractDate] = @CollectingContractDate,
	[CollectingContractCompany] = @CollectingContractCompany,
	[CreatedBy] = @CreatedBy,
	[CreatedDate] = @CreatedDate,
	[ModifiedDate] = @ModifiedDate,
	[ModifiedBy] = @ModifiedBy,
	[IPAddress] = @IPAddress
WHERE
	[RptSolidWasteID] = @RptSolidWasteID

--endregion



GO
/****** Object:  StoredProcedure [dbo].[Proc_UpdateRptWasteWaterQuantity]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_UpdateRptWasteWaterQuantity]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   Quang Hải using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_UpdateRptWasteWaterQuantity]
-- Date Generated: Thursday, October 18, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_UpdateRptWasteWaterQuantity]
	@RptWasteWaterQuantityID int,
	@CompanyID int,
	@ReportYear int,
	@ProduceWasteWaterQuantity int,
	@DomesticWasteWaterQuantity int,
	@ProcessedWasteWaterQuantity int,
	@ProcessedWasteWaterRate numeric(18, 2),
	@CollingWaterQuantity int,
	@ReuseWaterQuantity int,
	@CreatedBy nvarchar(128),
	@CreatedDate datetime,
	@ModifiedDate datetime,
	@ModifiedBy nvarchar(128),
	@IPAddress nvarchar(128)
AS


UPDATE [dbo].[RptWasteWaterQuantity] SET
	[CompanyID] = @CompanyID,
	[ReportYear] = @ReportYear,
	[ProduceWasteWaterQuantity] = @ProduceWasteWaterQuantity,
	[DomesticWasteWaterQuantity] = @DomesticWasteWaterQuantity,
	[ProcessedWasteWaterQuantity] = @ProcessedWasteWaterQuantity,
	[ProcessedWasteWaterRate] = @ProcessedWasteWaterRate,
	[CollingWaterQuantity] = @CollingWaterQuantity,
	[ReuseWaterQuantity] = @ReuseWaterQuantity,
	[CreatedBy] = @CreatedBy,
	[CreatedDate] = @CreatedDate,
	[ModifiedDate] = @ModifiedDate,
	[ModifiedBy] = @ModifiedBy,
	[IPAddress] = @IPAddress
WHERE
	[RptWasteWaterQuantityID] = @RptWasteWaterQuantityID

--endregion



GO
/****** Object:  StoredProcedure [dbo].[Proc_UpdateStatusTask]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_SelectProjectTaskByID]

------------------------------------------------------------------------------------------------------------------------
-- CreatedBy:   dvthang
-- CreatedDate: 27.02.2018
-- ModifyBy: manh: 03.06.18
-- Description: Cập nhật trạng thái Task
-- [dbo].[Proc_UpdateStatusTask] '1EF10CC8-33D5-4030-9756-68B15097098A',11
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_UpdateStatusTask]
    @projectTaskID UNIQUEIDENTIFIER ,
    @status INT
AS
    BEGIN
	--Tránh bị hack code
        IF @status = 11
            UPDATE  dbo.ProjectTask
            SET     Status = 12, Inactive = 0
            WHERE   ProjectTaskID = @projectTaskID
        ELSE
            UPDATE  dbo.ProjectTask
            SET     Status = 11, Inactive = 1
            WHERE   ProjectTaskID = @projectTaskID
    END

--endregion





GO
/****** Object:  StoredProcedure [dbo].[Proc_UpdateTokens]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--region [dbo].[Proc_UpdateTokens]

------------------------------------------------------------------------------------------------------------------------
-- Generated By:   THANG using CodeSmith 6.0.0.0
-- Template:       StoredProcedures.cst
-- Procedure Name: [dbo].[Proc_UpdateTokens]
-- Date Generated: Friday, January 12, 2018
------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Proc_UpdateTokens]
	@TokenId uniqueidentifier,
	@UserName varchar(50),
	@Token nvarchar(max),
	@ExpiresOn datetime,
	@IssuedOn datetime
AS


UPDATE [dbo].[Tokens] SET
	[UserName] = @UserName,
	[Token] = @Token,
	[ExpiresOn] = @ExpiresOn,
	[IssuedOn] = @IssuedOn
WHERE
	[TokenId] = @TokenId

--endregion





GO
/****** Object:  StoredProcedure [dbo].[SPGet_TableName_BY_iID_Name]    Script Date: 8/7/2019 11:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[SPGet_TableName_BY_iID_Name]
@iID_Name NVARCHAR(50)
AS
BEGIN
	DECLARE @object_id NVARCHAR(50)
	DECLARE @name NVARCHAR(100)
	--Bắt đầu
	DECLARE Cu CURSOR FOR SELECT OBJECT_ID, name FROM sys.tables  
	OPEN Cu
	FETCH FROM Cu into @object_id ,@name
	WHILE @@FETCH_STATUS = 0
	BEGIN
		--
		if EXISTS (select * from sys.all_columns 
		           where object_id =@object_id 
		           AND (sys.all_columns.name = @iID_Name 
		           OR sys.all_columns.name = 's' + right(@iID_Name, LEN(sys.all_columns.name) -1 )))
		BEGIN
			PRINT (@name)
		END
		--
		FETCH FROM Cu into @object_id ,@name
	END
	
	CLOSE Cu
	DEALLOCATE Cu
	--Hết
END














GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Mã tham số đo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MeasurementParameter', @level2type=N'COLUMN',@level2name=N'MeasurementParameterID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ký hiệu tham số đo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MeasurementParameter', @level2type=N'COLUMN',@level2name=N'Code'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Tên tiếng Việt của tham số đo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MeasurementParameter', @level2type=N'COLUMN',@level2name=N'ViName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Tên tiếng Anh của tham số đo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MeasurementParameter', @level2type=N'COLUMN',@level2name=N'EnName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ký hiệu của tham số đo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MeasurementParameter', @level2type=N'COLUMN',@level2name=N'Symbol'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Đơn vị tính của tham số đo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MeasurementParameter', @level2type=N'COLUMN',@level2name=N'UnitOfMeasure'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Mô tả tham số đo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MeasurementParameter', @level2type=N'COLUMN',@level2name=N'Description'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ngày tạo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MeasurementParameter', @level2type=N'COLUMN',@level2name=N'CreatedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ngày sửa' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MeasurementParameter', @level2type=N'COLUMN',@level2name=N'ModifiedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'IP máy sửa' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MeasurementParameter', @level2type=N'COLUMN',@level2name=N'IPAddress'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Người sửa' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MeasurementParameter', @level2type=N'COLUMN',@level2name=N'ModifiedBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Người tạo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MeasurementParameter', @level2type=N'COLUMN',@level2name=N'CreatedBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Bảng tham số đo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MeasurementParameter'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Mã tiêu chuẩn đo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MeasurementStandard', @level2type=N'COLUMN',@level2name=N'MeasurementStandardID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ký hiệu tiêu chuẩn đo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MeasurementStandard', @level2type=N'COLUMN',@level2name=N'Code'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Tên tiêu chuẩn đo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MeasurementStandard', @level2type=N'COLUMN',@level2name=N'FullName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Mô tả tiêu chuẩn đo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MeasurementStandard', @level2type=N'COLUMN',@level2name=N'Description'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ngày tạo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MeasurementStandard', @level2type=N'COLUMN',@level2name=N'CreatedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ngày sửa' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MeasurementStandard', @level2type=N'COLUMN',@level2name=N'ModifiedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'IP máy sửa' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MeasurementStandard', @level2type=N'COLUMN',@level2name=N'IPAddress'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Người sửa' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MeasurementStandard', @level2type=N'COLUMN',@level2name=N'ModifiedBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Người tạo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MeasurementStandard', @level2type=N'COLUMN',@level2name=N'CreatedBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Bảng tiêu chuẩn đo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MeasurementStandard'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Mã tham số tiêu chuẩn đo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MeasurementStandardParameter', @level2type=N'COLUMN',@level2name=N'MeasurementStandardParameterID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Mã tiêu chuẩn đo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MeasurementStandardParameter', @level2type=N'COLUMN',@level2name=N'MeasurementStandardID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Mã tham số đo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MeasurementStandardParameter', @level2type=N'COLUMN',@level2name=N'MeasurementParameterID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Giá trị cận dưới' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MeasurementStandardParameter', @level2type=N'COLUMN',@level2name=N'C_Min'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Giá trị cận trên' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MeasurementStandardParameter', @level2type=N'COLUMN',@level2name=N'C_Max'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Giá trị khác' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MeasurementStandardParameter', @level2type=N'COLUMN',@level2name=N'C_Text'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ngày tạo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MeasurementStandardParameter', @level2type=N'COLUMN',@level2name=N'CreatedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ngày sửa' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MeasurementStandardParameter', @level2type=N'COLUMN',@level2name=N'ModifiedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'IP máy sửa' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MeasurementStandardParameter', @level2type=N'COLUMN',@level2name=N'IPAddress'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Người sửa' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MeasurementStandardParameter', @level2type=N'COLUMN',@level2name=N'ModifiedBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Người tạo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MeasurementStandardParameter', @level2type=N'COLUMN',@level2name=N'CreatedBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Bảng gán tiêu chuẩn tham số đo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MeasurementStandardParameter'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Tiêu đề tin tức' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'News', @level2type=N'COLUMN',@level2name=N'NewsTittle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'NewContent: Nội dung tin tức' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'News', @level2type=N'COLUMN',@level2name=N'NewContent'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[ExpiredDate]: Ngày hết hạn' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'News', @level2type=N'COLUMN',@level2name=N'ExpiredDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ngày tạo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'News', @level2type=N'COLUMN',@level2name=N'CreatedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ngày sửa' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'News', @level2type=N'COLUMN',@level2name=N'ModifiedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'IP máy sửa' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'News', @level2type=N'COLUMN',@level2name=N'IPAddress'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Người sửa' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'News', @level2type=N'COLUMN',@level2name=N'ModifiedBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Người tạo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'News', @level2type=N'COLUMN',@level2name=N'CreatedBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Bảng chứa thông tin cấu hình của hệ thống' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'News'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Nội dung câu hỏi' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QADetail', @level2type=N'COLUMN',@level2name=N'QuestionContent'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[PublicState]: TRạng thái của nội dung được public lên trên web hay chưa. 0: Chưa được public, 1: Được public' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QADetail', @level2type=N'COLUMN',@level2name=N'PublicState'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Người tạo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QADetail', @level2type=N'COLUMN',@level2name=N'QuestionBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ngày tạo. Các nội dung khi liệt kê sẽ được sắp xếp theo trường thông tin này' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QADetail', @level2type=N'COLUMN',@level2name=N'QuestionDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ngày sửa' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QADetail', @level2type=N'COLUMN',@level2name=N'ModifiedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Người sửa' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QADetail', @level2type=N'COLUMN',@level2name=N'ModifiedBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'IP máy sửa' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QADetail', @level2type=N'COLUMN',@level2name=N'IPAddress'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Bảng nội dung chi tiết Q&A' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QADetail'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Mã chủ đề hỏi đáp' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QATopic', @level2type=N'COLUMN',@level2name=N'QATopicID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ký hiệu chủ đề hỏi đáp' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QATopic', @level2type=N'COLUMN',@level2name=N'QATopicCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Tên chủ đề hỏi đáp' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QATopic', @level2type=N'COLUMN',@level2name=N'QATopicName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Mô tả chủ đề hỏi đáp' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QATopic', @level2type=N'COLUMN',@level2name=N'Description'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1: Ngừng theo dõi; 0: Đang theo dõi' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QATopic', @level2type=N'COLUMN',@level2name=N'Inactive'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Số thứ tự' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QATopic', @level2type=N'COLUMN',@level2name=N'SortOrder'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ngày tạo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QATopic', @level2type=N'COLUMN',@level2name=N'CreatedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ngày sửa' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QATopic', @level2type=N'COLUMN',@level2name=N'ModifiedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'IP máy sửa' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QATopic', @level2type=N'COLUMN',@level2name=N'IPAddress'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Người sửa' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QATopic', @level2type=N'COLUMN',@level2name=N'ModifiedBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Người tạo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QATopic', @level2type=N'COLUMN',@level2name=N'CreatedBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Bảng chủ đề hỏi đáp' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QATopic'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ngày hết hạn' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Tokens', @level2type=N'COLUMN',@level2name=N'ExpiresOn'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ngày bắt đầu sử dụng' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Tokens', @level2type=N'COLUMN',@level2name=N'IssuedOn'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "DayOff"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_DayOff'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_DayOff'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "E"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 201
               Right = 391
            End
            DisplayFlags = 280
            TopColumn = 32
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_Employee'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_Employee'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "GrantRatio"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 215
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_GrantRatio'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_GrantRatio'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[68] 4[5] 2[9] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Project"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 266
               Right = 286
            End
            DisplayFlags = 280
            TopColumn = 32
         End
         Begin Table = "Employee"
            Begin Extent = 
               Top = 181
               Left = 624
               Bottom = 311
               Right = 828
            End
            DisplayFlags = 280
            TopColumn = 3
         End
         Begin Table = "ProjectPresentProtected"
            Begin Extent = 
               Top = 145
               Left = 872
               Bottom = 275
               Right = 1099
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ProjectExpenseProtected"
            Begin Extent = 
               Top = 6
               Left = 831
               Bottom = 136
               Right = 1061
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ProjectClose"
            Begin Extent = 
               Top = 138
               Left = 324
               Bottom = 268
               Right = 497
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 38
         Width = 284
         Width = 3390
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 150' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_Project'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'0
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 2805
         Alias = 4035
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_Project'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_Project'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[35] 4[46] 2[7] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "ProjectMember"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 220
            End
            DisplayFlags = 280
            TopColumn = 4
         End
         Begin Table = "ProjectPosition"
            Begin Extent = 
               Top = 27
               Left = 278
               Bottom = 157
               Right = 507
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Employee"
            Begin Extent = 
               Top = 6
               Left = 525
               Bottom = 136
               Right = 729
            End
            DisplayFlags = 280
            TopColumn = 3
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 5325
         Alias = 3030
         Table = 2670
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_ProjectMember'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_ProjectMember'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "ProjectPlanExpense"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 240
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_ProjectPlanExpense'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_ProjectPlanExpense'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "ProjectPlanExpense_AttachDetail"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 310
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_ProjectPlanExpense_AttachDetail'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_ProjectPlanExpense_AttachDetail'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "ProjectPlanPerform"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 241
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_ProjectPlanPerform'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_ProjectPlanPerform'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "ProjectPlanPerform_AttachDetail"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 311
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_ProjectPlanPerform_AttachDetail'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_ProjectPlanPerform_AttachDetail'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[21] 2[21] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = -96
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Project"
            Begin Extent = 
               Top = 6
               Left = 8
               Bottom = 298
               Right = 256
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ProjectPosition"
            Begin Extent = 
               Top = 167
               Left = 740
               Bottom = 297
               Right = 969
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Employee"
            Begin Extent = 
               Top = 9
               Left = 544
               Bottom = 195
               Right = 748
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ProjectMember"
            Begin Extent = 
               Top = 20
               Left = 307
               Bottom = 281
               Right = 493
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_ProjectPosition'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_ProjectPosition'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "ProjectProgressReport"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 255
            End
            DisplayFlags = 280
            TopColumn = 11
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_ProjectProgressReport'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_ProjectProgressReport'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "ProjectProgressReport_AttachDetail"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 325
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_ProjectProgressReport_AttachDetail'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_ProjectProgressReport_AttachDetail'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[42] 4[41] 2[14] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "ProjectTaskMember"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 201
               Right = 244
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Employee"
            Begin Extent = 
               Top = 2
               Left = 590
               Bottom = 180
               Right = 794
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 4995
         Alias = 1875
         Table = 2220
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_ProjectTaskMember'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_ProjectTaskMember'
GO
USE [master]
GO
ALTER DATABASE [QLDT] SET  READ_WRITE 
GO
