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

Alternative option is to install pip module and use it - Ref: https://github.com/chhantyal/parquet-cli (Yes, this is not the Powershell)
```
#install 
pip install parquet-cli


parq 'C:\Users\20230612\haha.parquet'

parq 'C:\Users\20230612\haha.parquet' --schema

parq 'C:\Users\20230612\haha.parquet' --head 10

```
