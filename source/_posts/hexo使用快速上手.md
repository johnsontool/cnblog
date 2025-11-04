---
title: hexo使用快速上手
date: 2019-01-01
author: 官方文档
---
---

Welcome to [Hexo](https://hexo.io/)! This is your very first post. Check [documentation](https://hexo.io/docs/) for more info. If you get any problems when using Hexo, you can find the answer in [troubleshooting](https://hexo.io/docs/troubleshooting.html) or you can ask me on [GitHub](https://github.com/hexojs/hexo/issues).



#### Quick Start

##### Create a new post

``` bash
$ hexo new "My New Post"
```

More info: [Writing](https://hexo.io/docs/writing.html)

##### Run server

``` bash
$ hexo server
```

More info: [Server](https://hexo.io/docs/server.html)

##### Generate static files

``` bash
$ hexo generate
```

More info: [Generating](https://hexo.io/docs/generating.html)

##### Deploy to remote sites

``` bash
$ hexo deploy
```

More info: [Deployment](https://hexo.io/docs/one-command-deployment.html)



#### 其他内容：

当前我使用的是[aircloud模版](https://github.com/aircloud/hexo-theme-aircloud)，与该模版相关的设置，有安装搜索插件：
另外对应的[demo的blog源码](https://github.com/aircloud/hexo-aircloud-blog)。
```bash
npm i hexo-generator-search --save
```

然后在主目录的\_config.yml文件中配置：

```bash
search:
  path: search.json
  field: post
```

关于*"标签"*页面和*"关于"*页面的创建：

```bash
hexo new page tags
hexo new page about
```

