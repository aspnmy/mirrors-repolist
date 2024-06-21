#!/bin/bash
# 自动更新一次repo  autoRepoGit start
# 自动备份repo文件到备份目录 autoRepoGit backup
# 安装脚本工具到系统目录 autoRepoGit install
# 设置定时任务为每月第一天执行 autoRepoGit set_crontab
# git：https://gitcode.com/aspnmy/mirrors-repolist.git
# 作者：aspnmy（support@e2bank.cn）
# 版本更新：20240622


# 只支持root用户操作，如果需要使用非root用户需要脚本每个命令中都加上sudo 不然执行是不成功的
# 执行脚本前需要确认 依赖组件 git  已经安装完成
# 如果需要定时业务 确认依赖组件 crontabs 已经安装完成
USERNAME="root"
SCNAME="autoRepoGit"
# $Barce_VER 代表git目录中需要下载的repo文件的类别路径，用变量就方便进行路径切换，这里假设拉取阿里云-centos-9-stream的repo文件
Barce_VER="aliyun/centos/9-stream"
DL_PATH="$HOME/downloads"
#$HOME/downloads/mirrors-repolist/cn/repolists/aliyun/centos/9-stream/*.repo
RCOPY_PATH="$DL_PATH/mirrors-repolist/cn/repolists/$Barce_VER"
SERVICE="autoRepoGit"
#$REPO_DIR 就是 /etc/yum.repos.d/目录
REPO_DIR="/etc/yum.repos.d"
BACK_DIR="$HOME/backupcd"
 

ME=`whoami`
 
if [ $ME != $USERNAME ] ; then
   echo "Please run the $USERNAME user."
   exit
fi
 
startOnce() {

   echo $RCOPY_PATH 
    rm -rf $DL_PATH/mirrors-repolist 
    cd $DL_PATH 
    git clone -q https://gitcode.com/aspnmy/mirrors-repolist.git  
    cp -r $RCOPY_PATH/*.repo $REPO_DIR  
    dnf makecacheecho "$SERVICE is Succeed!"

   exit
}
 
back_repo() {

 
   cp -r $REPO_DIR/*.repo $BACK_DIR
   exit
}
 
install_unit() {
    # 安装脚本到系统目录下
    # 默认脚本路径在 ./mirrors-repolist/sh/autoRepoGit.sh
    mkdir -p $HOME/downloads
    mkdir -p $HOME/backupcd 
    touch $HOME/backupcd/logs.txt 
    cd $HOME/downloads/mirrors-repolist/cn/sh/ 

   cp -r  ./autoRepoGit.sh /usr/bin/autoRepoGit 
   chmod +x /usr/bin/autoRepoGit 
   dnf -y install crontabs 
   systemctl enable crond  
   systemctl start crond 
   echo "$SERVICE is Succeed!" 
   exit
}

install_bef() {
    # 安装依赖程序
    # 默认脚本路径在 ./mirrors-repolist/sh/autoRepoGit.sh
   dnf -y install crontabs
   systemctl enable crond
   systemctl start crond
   echo "$SERVICE is Succeed!"
   exit
}


set_crontab_mouth() {
    # 设置定时任务一个月执行一次
    # 默认脚本路径在 ./mirrors-repolist/sh/autoRepoGit.sh
 
   cat >> /etc/crontab << 'EOF'
# 将当前时间写入到log文件,每个月的1号执行一次
0 0 1 * * autoRepoGit start echo `date` >> /root/date.log
EOF

crontab /etc/crontab
systemctl enable crond
systemctl reload crond
   echo "Crontab is Succeed!"

   exit
}

case "$1" in
   start)
       startOnce
       ;;
   backup)
       back_repo
       ;;
   install)
       install_unit
       ;;   
   set_crontab)
       set_crontab_mouth
       ;;  
    in_bef)
       install_bef
       ;;          
   *)
       echo  $"Usage: $0 {in_bef(安装脚本依赖)|start(更新repo一次)|backup(备份repo)|install(安装脚本到系统目录)|set_crontab(设置定时任务为每月1号)}"
     
esac