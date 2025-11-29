---
title: Ubuntu上基于Hexo与Jekyll构建静态博客网站
date: 2024-04-06 11:04:26
author: John
tags:
  - 计算机网络
---

所谓的静态博客，就是只有静态资源，包括html，图片等，没有数据库，没有php动态语言的博客网站。

静态博客主打一个：简单、快速。只需要你会使用markdown笔记，就可以快速地借助模板，搭建一个人博客。

本文主要介绍Hexo和Jekyll两种创建静态博客的框架:

- Hexo基于Node.js开发，对于javascript熟悉的话，可以快速上手；
- Jekyll基于Ruby开发；

两者除了开发语言的区别，使用习惯与社区资源大同小异，建议根据自己对编程语言的熟悉度来选择。

#### Hexo的安装与使用

##### 1、安装Node.js

访问Node.js的官网[Node.js — Download Node.js® (nodejs.org)](https://nodejs.org/en/download/package-manager)

我们先安装nvm，然后再来安装node.js，

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
```

安装成功后，我们再使用nvm来安装Node.js的v18.19.1版本：

```bash
nvm install 18
##输出版本号，检查是否安装成功
node -v
npm -v
```

上述的node是Node.js的主程序，npm是其包管理工具，类似于ubuntu的apt角色，只不过apt是用来下载、安装、管理ubuntu下的应用程序，而npm是下载、安装、管理Node.js中的库。

##### 2、安装Hexo与使用

```bash
###安装hexo脚手架命令
npm install -g hexo-cli
### hexo项目初始化
hexo init
### 创建新的博文
hexo new "文章标题"
### 博文编译为html输出文件；
hexo generate
### 开启hexo自带服务器，查看效果；
hexo server
```

开启hexo自带服务后，可以在http://localhost:4000/查看网站的效果。

##### 3、Hexo博客模板

在官网[Themes | Hexo](https://hexo.io/themes/)上可以看到各种模板，选择自己喜欢的模版，可以下载到当前Hexo项目中的themes/目录下，然后在Hexo的配置文件\_config.yml文件中，指定要使用的模版名称，比如我们使用的aircloud模版：

```bash
theme: aircloud
```

完成模版设置后，我们的博客就会呈现对应的视觉效果，非常方便。

##### 4、Hexo在Ubuntu上的使用

使用“hexo generate”命令后，会在Hexo项目文件下生成导出文件夹/public/，其中保存有经markdown格式转化而来的html文件夹；将整个public目录经过git命令，导入到Ubuntu的/var/www/目录下，然后再配置Ubuntu上的Nginx服务器，将public目录作为站点的root目录即可。

#### Jekyll的安装与使用

Jekyll 是一个静态网站生成器，它将纯文本转化为静态网站和博客，比如将你的markdown笔记转为博客。使用 Jekyll 的主要好处之一是，由于生成的是静态网站，所以不需要数据库或其他后端组件，这使得网站更容易部署和维护。

为了下载安装最新版的ruby，我们使用rvm来安装Ruby，而不是用ubuntu默认的apt命令。

步骤：先安装rvm，使用rvm来安装ruby，再使用gem来安装jekyll和bundler.

**1、安装rvm**

```bash
curl -sSL https://rvm.io/mpapis.asc | gpg --import -
curl -sSL https://rvm.io/pkuczynski.asc | gpg --import -
```

下载rvm安装包

```bash
curl -sSL https://get.rvm.io | bash -s stable
```

使得终端生效：

```bash
source /home/tfzhang/.rvm/scripts/rvm
```

注意上述的home目录，需要根据你自己的系统目录调整；

**安装最新版ruby**

安装ruby：

```bash 
rvm install ruby
```

安装完成后，检查ruby和rubygems是否正确安装：

```bash
ruby -v
gem -v
```

如果有版本输出，说明安装成功。

安装jekyll和bundler：

```bash
gem install jekyll bundler
```

安装成功后，创建新的jekyll站点：

```bash
jekyll new my-new-site
```

进入新创建的my-new-site，然后开启jekyll服务器：

```bash
cd my-new-site && jekyll serve
```

运行服务器时，可能会提醒错误：

```bash
could not find gem 'minima (~>2.5) in locally installed gems.'
```

需要安装minima：

```bash
gem install minima
```

安装完成版后，再运行：jekyll server

这将启动一个开发服务器，在本地主机的某个端口上提供你的站点（通常是http://localhost:4000/）。现在，你可以通过浏览器访问这个地址来查看你的站点。

![2024-03-21-jekyll启动首页](/img/2024-03-21-jekyll启动首页.jpg)
