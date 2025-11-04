@echo off  
chcp 65001
setlocal enabledelayedexpansion

  
:: 设置日期前缀  
set "date_prefix=2024-02-05-"  
  
:: 遍历当前目录下的所有文件  
for %%F in (*) do (  
    :: 获取文件的基本名（不含扩展名）和扩展名  
    set "filename=%%~nF"  
    set "extension=%%~xF"  
      
    :: 构建新的文件名  
    set "new_filename=!date_prefix!!filename!!extension!"  
      
    :: 重命名文件  
    ren "%%F" "!new_filename!"  
)  
  
echo 文件重命名完成。  
pause