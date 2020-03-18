# cloudreve docker

[GitHub](https://github.com/holleworldabc/cloudreve-docker)	[Gitee](https://gitee.com/wuma/cloudreve-docker)	[Docker手册内置安装](https://www.jianshu.com/p/6d44b7d1a267)

> cloureve-docker 是对cloudreve的docker封装，这里我们致敬cloudreve的开发者，我试过很多的云盘cloudreve是最舒服的，而且开发者没有因为割韭菜而阉割免费版，非常感谢。
>
> 用户通过cloudreve-docker安装cloudreve可以快速的体验私人云盘的快感（去tm的百度云），并且cloudreve-docker提供了aria2的离线下载功能，通过简单的配置就可以使用离线下载，并且通过docker的数据卷可以非常灵活的对cloudreve进行备份、升级、配置以及日志的记录。

## 准备

- Docker19+
- git

## 快速体验

```bash
git clone https://gitee.com/wuma/cloudreve-docker.git
docker build -t cloudreve ./cloudreve-docker
docker run -d --name cloudreve -p 83:83 -v /root/log:/core/log cloudreve
cat /root/log/cloudreve.log
```

### 执行上面的代码后可以得到账号和密码

![启动成功](Readme.assets/image-20200318190112678.png)

### 在浏览器输入`http://ip:83`，登录后我们就可以看到登录成功

![image-20200318190348342](Readme.assets/image-20200318190348342.png)

### 接下来就可以体验私人云盘的快感

![上传文件](Readme.assets/image-20200318190605649.png)

### 如何使用离线下载呢

默认离线下载是开启的但是需要一些网页上的简单配置，记住下面这些信息。

- RPC 服务器地址：http://localhost:6800
- RPC Secret：ownaria2
- 临时下载目录：/tmp

然后我们跳转到后台管理的离线下载配置页面，输入网站`http://你的ip:83/#/admin/aria2`，在第一次进入后台的时候会弹出一个设置，这个设置是要你设置以后通过什么地址来访问你的私有云盘。如果你不是用localhost:83上来的你只需要点确认即可。

![image-20200318191227907](Readme.assets/image-20200318191227907.png)

我们将刚刚记得的配置信息填入，其他保持默认即可，点击测试连接，会出现连接成功就okl。

![image-20200318191312625](Readme.assets/image-20200318191312625.png)

测试一下离线下载。

![image-20200318191842186](Readme.assets/image-20200318191842186.png)

测试完成可以下载，这个速度是和你的资源有关系。

## 可操作数据卷

前面提到cloudreve-docker是一个灵活的Docker封装，我们可以通过数据卷的方式可以将数据库、日志、配置信息进行物理空间的映射，映射到宿主机的某个位置后可以方便的进行修改与备份。

| 容器内的数据卷   | 说明                                                         |
| ---------------- | ------------------------------------------------------------ |
| /core/uploads    | 存储用户上传的文件                                           |
| /core/log        | 存储aria2和cloudreve的日志                                   |
| /core/etc        | 存储cloudreve的配置                                          |
| /core/db         | 存储数据库文件，这个项依赖于配置文件`conf.ini`里[Database]->DBFile |
| /core/aria2/conf | aria2的配置文件，不建议修改（除非你会）                      |

### 使用方法

我们直接如上所示，我们在创建并启动容器的时候docker run使用 -v参数来指定，下面是个完整的配置。

```bash
docker run -d --name cloudreve -p 5212:5212 \
	-v /root/own/log:/core/log \
	-v /root/own/data:/core/uploads \
	-v /root/own/db:/core/db \
	-v /root/own/etc:/core/etc \
    cloudreve
```

我们通过查看/root/own/log/cloudreve.log文件来获取账号和密码

![image-20200318195104454](Readme.assets/image-20200318195104454.png)

我们建议端口映射和cloudreve的端口设置为一样，以防止出现意外。

### 查看日志

```bash
cat /root/own/log/cloudreve.log 
# 查看cloudreve的日志，这里存储着网页登录的初始密码
cat /root/own/log/aria2.log
# 这里存储着离线下载的日志
```

### 备份数据库与文件

```bash
mkdir /root/backup
cp /root/own/db /root/backup
cp /root/own/data /root/backup
```

### 修改配置文件

```bash
vi /root/own/etc/conf.ini
```

详细的配置文件如下

```php
[System]
; 运行模式
Mode = master
; 监听端口
Listen = :83
; 是否开启 Debug
Debug = false
; Session 密钥, 一般在首次启动时自动生成
SessionSecret = 23333
; Hash 加盐, 一般在首次启动时自动生成
HashIDSalt = something really hard to guss

; 数据库相关，如果你只想使用内置的 SQLite数据库，这一部分直接删去即可
[Database]
; sqlite数据库位置
DBFile= /core/db/cloudreve.db
; 数据库类型，目前支持 sqlite | mysql
;Type = mysql
; 用户名
;User = owncloud
; 密码
;Password =
; 数据库地址
;Host = mysql
; 数据库名称
;Name = owncloud
; 数据表前缀
;TablePrefix = own

; 从机模式下的配置
[Slave]
; 通信密钥
Secret = 1234567891234567123456789123456712345678912345671234567891234567
; 回调请求超时时间 (s)
CallbackTimeout = 20
; 签名有效期
SignatureTTL = 60

; 跨域配置
[CORS]
AllowOrigins = *
AllowMethods = OPTIONS,GET,POST
AllowHeaders = *
AllowCredentials = false

; Redis 相关
;[Redis]
;Server = 127.0.0.1:6379
;Password =
;DB = 0

; 从机模式缩略图
[Thumbnail]
MaxWidth = 400
MaxHeight = 300
FileSuffix = ._thumb

```



## 操作cloudreve

### 创建并运行（第一次使用）

```bash
docker run -d \
	--name own \
	-p 5212:5212 \
	-v /root/own/log:/core/log \
	-v /root/own/data:/core/uploads \
	-v /root/own/db:/core/db \
	-v /root/own/etc:/core/etc \
    cloudreve
# -p 端口的映射默认端口是5212，如果不映射/core/etc，默认加载cloudreve-docker自带的完整配置文件端口为83
# -v 端口映射
# -d 后台运行
# --name own 这个我给这个容器起的是own这个名字,这个名字很重要,下面的操作已经使用
# --link <ip|域名|其他容器名>:<容器内host>
# eg:
# 	--link localhost:roothost 这里将127.0.0.1映射到容器内roothost这个名字，我们可以ping roothost来测试
```

### 启动

```bash
docker start own
```

### 重启

```bash
docker restart own
```

### 关闭

```bash
docker stop own
```

### 开机自启动

```bash
systemctl enable docker
docker update --restart=always own
```



## 升级cloudreve

```bash
git clone https://gitee.com/wuma/cloudreve-docker.git
docker build -t cloudreve ./cloudreve-docker
docker restart own
```

> 因为我会关注着cloudreve最新版，并且会在发布的第一时间进行测试，测试完成后我会放到cloudreve-docker的仓库中，所以大家使用这两句代码就可以快速的升级，并且不会丢失文件和数据。

## 最后

首先非常感谢cloudreve团队做出来的这个云盘，正因为他们的东西，我才可以去搞cloudreve-docker版。

对于cloudreve后期有时间我会做一些实用的辅助，大家可以关注我，来获取动态。

最后如果可以，请帮忙点个start让更多的人看见，谢谢。

致敬 cloudreve团队

