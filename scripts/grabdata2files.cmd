@REM Grab some data from staging tables
set bex=C:\Utility\BlitzSqlExtract2SeedData.exe
set cs="Server=.\sqlexpress;Database=Bicycle;Trusted_Connection=True;"

pushd ..\data\
%bex% -c %cs% -v -a -t "etl.Orders-Raw"
popd
