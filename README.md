# mirrors-repolist

- 主要保存一些常用镜像源的repo文件，方便快速换源
- 使用wget命令下载的对应区域即可
    mirrors-repolist
        └─aliyun
            └─centos
                ├─10-stream
                ├─8-stream
                └─9-stream

```
cd /etc/yum.repos.d
wget https://gitcode.com/aspnmy/mirrors-repolist/blob/main/mirrors-repolist/aliyun/centos/8-stream/centos-8-stearm.repo
yum makecache

```

- 好运