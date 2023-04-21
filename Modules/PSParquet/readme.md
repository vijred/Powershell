PSParquet module
==============

`PSParquet` module can be used to read parquet file.

How to install the module - `Install-Module -Name PSParquet -RequiredVersion 0.0.75`
Module reference - https://www.powershellgallery.com/packages/PSParquet/0.0.24 

Example to read the data:
```
$data3= Import-Parquet -FilePath C:\Users\myfolder\filename.parquet
$data3.Count
```
