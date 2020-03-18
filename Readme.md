# cloudreve docker

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

| 容器内的数据卷 | 说明                                                         |
| -------------- | ------------------------------------------------------------ |
| /core/update   | 存储用户上传的文件                                           |
| /core/log      | 存储aria2和cloudreve的日志                                   |
| /core/etc      | 存储cloudreve的配置                                          |
| /core/db       | 存储数据库文件，这个项依赖于配置文件`conf.ini`里[Database]->DBFile |
| /core/bin      | 存储cloudreve的主程序（不推荐映射）                          |

### 使用方法

我们直接如上所示，我们在创建并启动容器的时候docker run使用 -v参数来指定，下面是个完整的配置。

```bash
docker run -d --name cloudreve -p 5212:5212 \
	-v /root/own/log:/core/log \
	-v /root/own/data:/core/update \
	-v /root/own/db:/core/db \
	-v /root/own/etc:/core/etc \
    cloudreve
```

我们通过查看/root/own/log/cloudreve.log文件来获取账号和密码

![image-20200318195104454](Readme.assets/image-20200318195104454.png)

我们建议端口映射和cloudreve的端口设置为一样，以防止出现意外。