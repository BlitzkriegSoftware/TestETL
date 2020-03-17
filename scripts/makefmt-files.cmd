 @REM MAke FMT Files for OPENROWSET
 @REM See: https://docs.microsoft.com/en-us/sql/relational-databases/import-export/use-a-format-file-to-bulk-import-data-sql-server?view=sql-server-ver15#nonxml_format_file

set bcpex="C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\130\Tools\Binn\bcp.exe" 

pushd ..\data\

%bcpex% [etl].[Orders-Raw] format nul -c -f .\Orders-Raw.fmt -t\t -T -S .\sqlexpress -d Bicycle

dir /b *.fmt

popd