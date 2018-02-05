#前言
由于大家都懂的, 国内使用go get的时候, 经常会各种失败, 如果有vpn的话, 打开vpn, 问题就解决了, 但vpn其实挺不灵活的.

相对来说shadowsock则灵活得多.

#解决方案
shadowsock + Privoxy

思路就是, 使用shadowsock建立一个本地sock5代理, 但因为go get 需要http代理, 所以需要使用privoxy把sock5代理转为http代理.


## shadowsock
首先你要有一个自己的shadowsock服务器, 确保好用.

我目前用的是https://bandwagonhost.com/clientarea.php, 貌似24人民币买了一年的. 详情配置自己查, 很简单.

然后:
```
sudo apt-get install python-pip
sudo pip install shadowsocks
```

找到:sslocal(sudo find / -name sslocal) 这个命令所在的目录, 将sslocal软链接到/bin中.
```
sudo ln -s /usr/local/bin/sslocal /bin/sslocal
```

之后找个目录新建个文件startSslocal.sh, 

将下面的内容写到里面, 将ip, port, password替换为自己的shadowsock的配置.(其余配置不需要管,使用默认即可)
```
#!/bin/bash
sslocal -s ip -p port -k "password"
```

然后就是设置startSslocal.sh开机自动启动, 编辑/etc/rc.local, 将下面内容(按情况修改为你自己的)写到rc.local中
```
nohup bash /home/tom/shadow-sock/startSslocal.sh>/home/tom/shadow-sock/startSslocal.log &
```

重新启动, 如果startSslocal.log中的日志为:
```
2015-11-08 22:36:34 INFO     loading libcrypto from libcrypto.so.1.0.0
2015-11-08 22:36:34 INFO     starting local at 127.0.0.1:1080
```
则证明ubuntu目前已经启动好了sock5的代理, 代理为: 127.0.0.1:1080. 

此时如果配合SwitchyOmega, 配置一下sock5的代理, 则可以完成类似之前goagent的自动科学上网(PS:在此沉痛悼念下goagent同志).



#使用Privoxy将sock5代理映射为http代理.

安装Privoxy
```
sudo apt-get update
sudo apt-get install privoxy
```

配置Privoxy, 打开 /etc/privoxy/config, 

注释掉
```
listen-address  localhost:8118
```
```
#listen-address  localhost:8118
```

在最后一行后边加上
```
forward-socks5 / 127.0.0.1:1080 .
listen-address 127.0.0.1:8118
```

然后重启Privoxy
```
sudo service privoxy restart
```
这样就完成了sock5到http代理的映射

然后就可以配置全局http proxy, sudo vi /etc/environment, 加入下面的代码
```
export http_proxy=http://127.0.0.1:8118
export https_proxy=http://127.0.0.1:8118
```
当然也可以只对当前命令行设置http_proxy, 在当前窗口执行上面的代码即可(使用全局配置, 可以在安装 vim插件时也生效,如GoInstallBinaries)


重启机器 
```
sudo shutdown -r now
```

尝试一次不纯洁的go get
```
转载 来自：https://gist.github.com/9a4f1791fe4305b0750a.git
