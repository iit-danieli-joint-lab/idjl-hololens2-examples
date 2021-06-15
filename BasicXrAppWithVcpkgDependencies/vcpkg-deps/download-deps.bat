@ECHO OFF
ECHO Downloading vcpkg-provided dependencies from zip file

REM Download zip file
curl -LO https://github.com/iit-danieli-joint-lab/idjl-hololens2-examples/releases/download/storage/vcpkg-export-20210611-183728.zip

REM Unzip file
tar -xf vcpkg-export-20210611-183728.zip

REM Remove temporary zip file
del vcpkg-export-20210611-183728.zip

ECHO Dowloaded vcpkg-provided dependencies from zip file

