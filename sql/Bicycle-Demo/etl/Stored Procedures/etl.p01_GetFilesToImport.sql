-- =============================================
-- Author:		Stuart Williams
-- Create date: 3/20/2020
-- Description:	Get Files to Import
-- =============================================
CREATE PROCEDURE [etl].[p01_GetFilesToImport] 
	
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @DataFolder SYSNAME 

select @DataFolder = [Value] from [common].[Configuration] where [Name]='DataFilePath';

  IF OBJECT_ID('tempdb..#DirTree') IS NOT NULL
    DROP TABLE #DirTree

  CREATE TABLE #DirTree (
    Id int identity(1,1),
    SubDirectory nvarchar(255),
    Depth smallint,
    FileFlag bit,
    ParentDirectoryID int
   )

   INSERT INTO #DirTree (SubDirectory, Depth, FileFlag)
   EXEC master..xp_dirtree @DataFolder, 10, 1

   UPDATE #DirTree
   SET ParentDirectoryID = (
    SELECT MAX(Id) FROM #DirTree d2
    WHERE Depth = d.Depth - 1 AND d2.Id < d.Id
   )
   FROM #DirTree d

  DECLARE 
    @ID INT,
    @CsvFile VARCHAR(MAX),
    @Depth TINYINT,
    @FileFlag BIT,
    @ParentDirectoryID INT,
    @wkSubParentDirectoryID INT,
    @wkSubDirectory VARCHAR(MAX)

  DECLARE FileCursor CURSOR LOCAL FORWARD_ONLY FOR
  SELECT * FROM #DirTree WHERE FileFlag = 1

  OPEN FileCursor
  FETCH NEXT FROM FileCursor INTO 
    @ID,
    @CsvFile,
    @Depth,
    @FileFlag,
    @ParentDirectoryID  

  SET @wkSubParentDirectoryID = @ParentDirectoryID

  WHILE @@FETCH_STATUS = 0
  BEGIN
    --loop to generate path in reverse, starting with backup file then prefixing subfolders in a loop
    WHILE @wkSubParentDirectoryID IS NOT NULL
    BEGIN
      SELECT @wkSubDirectory = SubDirectory, @wkSubParentDirectoryID = ParentDirectoryID 
      FROM #DirTree 
      WHERE ID = @wkSubParentDirectoryID

      SELECT @CsvFile = @wkSubDirectory + '\' + @CsvFile
    END

    --no more subfolders in loop so now prefix the root backup folder
    SELECT @CsvFile = @DataFolder + @CsvFile

    --Put into table
    if(CHARINDEX('csv', @CsvFile,0) > 0)
	begin
		INSERT INTO [etl].[FilesToImport] (FileNamePath) VALUES(@CsvFile)
	end
	
	-- Update format file location
	if(CHARINDEX('fmt', @CsvFile,0) > 0)
	begin
		UPDATE [common].[Configuration] set [Value]=@CsvFile where [Name]='FormatFilePath';
	end

    FETCH NEXT FROM FileCursor INTO 
      @ID,
      @CsvFile,
      @Depth,
      @FileFlag,
      @ParentDirectoryID 

    SET @wkSubParentDirectoryID = @ParentDirectoryID      
  END

  CLOSE FileCursor
  DEALLOCATE FileCursor

  declare @ct int = 0

  select @ct = count(*) from  [etl].[FilesToImport]

  if(@ct <= 0)
  begin
	  INSERT INTO [common].[ErrorLog]
			   ([Step]
			   ,[Comment])
		 VALUES
			   ((select object_name(@@PROCID))
			   ,'No Files Found To Process');
   end
   
   print 'Total Files Found: ' + CAST(@ct as nvarchar(50)) 	

END