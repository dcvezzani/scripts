goto(){
# Linux code here
#uname -o
echo "unixish"
}

goto $@
exit

:(){
rem Windows script here
rem echo %OS%
echo "windows"
exit

