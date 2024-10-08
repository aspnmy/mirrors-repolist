@[TOC]
# 如何优雅的换国内源？
- 由于国内源的一些历史问题，所以有时候经常会出现换源异常问题，所以这个项目存在的意义就是，缓存一批常用的repo国内源，定期更新，使用很easy，只需要git下来，挪到指定区域即可。
# git：https://gitcode.com/aspnmy/mirrors-repolist.git
# 更新时间：20240826 Msg：更新docker与podman加速镜像源

# 更新说明：
- 更新docker与podman加速镜像源
- 更新源保存在 repolosts/docker repolosts/podman 中，下载更新源覆盖对应的文件即可
- 更新脚本命令 autoRepoGit up_podman_r  如需要更新docker镜像源只需要改对应的参数变量到项目中的docker镜像源文件即可

# 更新源加速查询网址，不想添加更新源的，可以使用查询网址，查询可用的加速源。
- https://getimgurl.t2be.cn/


# 使用说明
- 1、首先下载项目
```bash
mkdir -p $HOME/downloads && cd $HOME/downloads
git clone https://gitcode.com/aspnmy/mirrors-repolist.git

```
- 2、备份官方源并清空

```bash
mkdir -p $HOME/tmp/backup
cp -r /etc/yum.repos.d/*.repo $HOME/backup
rm -rf /etc/yum.repos.d/*.repo 

```

- 3、拷贝需要的repo文件到/etc/yum.repos.d/，并重建缓存
    比如需要项目中的centos-9-stream下全部常用repo，就可以用下面代码拷贝进去

```base
mkdir -p $HOME/backupcd
cp -rf $HOME/downloads/mirrors-repolist/cn/repolists/aliyun/centos/9-stream/*.repo /etc/yum.repos.d
dnf makecache

```

# 使用sh脚本定期换源
- 为什么要定期换源呢，因为某些原因国内的镜像源可能会有访问异常，所以git上的数据会有变动
- 假设git到本地的目录是$HOME/downloads，是不变的，那么写一个简单sh脚本，定期git到本地，然后再拷贝到/etc/yum.repos.d/目录下就能无缝衔接源了，可以用定时组件操作。
- 脚本工具在git项目的./mirrors-repolist/sh/下
- 首次使用的时候先要如下进行依赖安装及脚本安装，前提是git已经安装好了

```base
cd $HOME/downloads/mirrors-repolist/cn && chmod +x ./sh/autoRepoGit.sh
./sh/autoRepoGit.sh in_bef && ./sh/autoRepoGit.sh install

```

上面的命令执行完成以后，就可以像下面这样进行操作了，简化步骤
```base

# 安装依赖
autoRepoGit in_bef
# 安装脚本工具到系统目录 （如果不使用install命令进行安装，就需要以./sh/autoRepoGit.sh start 的形式来启动）
autoRepoGit install
# 自动更新一次repo  
autoRepoGit start
# 自动备份repo文件到备份目录 
autoRepoGit backup
# 设置定时任务为每月第一天执行 
autoRepoGit set_crontab


```

## mirrors-repolist

- 主要保存一些常用镜像源的repo文件，方便快速换源
- 使用wget命令下载的对应区域即可
mirrors-repolist
└─cn
    ├─repolists
    │  └─aliyun
    │      └─centos
    │          ├─10-stream
    │          ├─8-stream
    │          └─9-stream
    └─sh

```
cd /etc/yum.repos.d
wget https://gitcode.com/aspnmy/mirrors-repolist/blob/main/mirrors-repolist/aliyun/centos/8-stream/centos-8-stearm.repo
yum makecache

```

- 好运