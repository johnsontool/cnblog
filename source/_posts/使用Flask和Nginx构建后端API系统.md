---
title: 使用Flask和Nginx构建后端API系统
date: 2024-03-27 11:04:26
author: tfzhang
tags:
  - flask
  - nginx
  - python
  - api
---

本文主要介绍基于Flask和Nginx构建简单的API系统。作为演示，该系统只有一个后端API，接收来自前端的参数并返回生成的随机数。整个部署环境是**Ubuntu 18.04**操作系统。

Flask是Python下的轻量级Web应用程序框架，主要优点：

- 轻量级且足够简单易用
- 基于Python，易于上手

使用Nginx与Flask的基本架构图如下：

- Nginx作为Web服务器，接收用户请求并反向代理到Gunicorn服务器
- Gunicorn是WSGI（Web服务器网关接口）HTTP服务器，运行Python Web应用程序
- Supervisor是一个进程管理工具，可以监控Gunicorn的运行，如果意外关闭可以自动重启
- Flask App是我们开发的应用服务

## 1. Flask应用程序开发：

要开发Flask应用程序，首先安装Python环境：

### 1.1 安装Python虚拟环境

检查是否安装了Python3：

```bash
python3 --version
```

安装虚拟环境模块：

```bash
sudo apt install python3-venv
```

为Flask执行创建虚拟环境：

```bash
python3 -m venv myflask
```

创建后，进入myflask文件夹并运行以下命令激活虚拟环境：

```bash
source ./bin/activate
```

激活后，安装Flask库：

```python
pip3 install Flask
```

### 1.2 开发Flask应用程序

类似于C语言中的Hello World，我们的第一个页面将开发一个Flask版本的Hello World。完成1.1步骤后，进入myflask目录。

创建一个名为app.py的Python文件，内容如下：

```python
from flask import Flask
app=Flask(__name__)

@app.route('/')
def index():
    return '<h1>Hello World! From Flask!</h1>'
```

编辑保存后，在终端中运行：

```bash
flask run
```

按照终端提示，在浏览器中打开 http://127.0.0.1:5000/ 即可看到输出结果。

![2024-03-26-浏览器打开helloflask](/img/2024-03-26-浏览器打开helloflask.jpg)

仔细观察终端输出，可以发现当前的开发环境是：production，当前访问端口是5000。

那么如何修改这些配置呢？比如从生产环境切换到开发环境，端口从5000改为8000等。这时就需要使用环境变量。我们在当前开发目录下创建一个.flaskenv环境变量文件：

```bash
FLASK_ENV=development ## 设置为开发环境
FLASK_APP=app.py ## 如果你的应用名是app，不需要明确指定；如果不是，必须明确指定
FLASK_RUN_PORT=8000
```

那么flask是如何读取这个.flaskenv环境变量文件的呢？我们需要安装python-dotenv库：

```bash
pip3 install python-dotenv
```

然后再次运行flask run：

![2024-03-26-flaskenv环境变量](/img/2024-03-26-flaskenv环境变量.jpg)

在上图中，可以看到已经是开发模式，端口也已经切换到8000。

### 1.3 完善Flask应用的随机数功能：

为了根据客户端关于随机数长度、字符数等请求信息返回随机数，路由代码如下：

```python
@app.route('/getrandomstr', methods=['POST'])
def getrandomstr():
    if request.method == 'POST':
        data_json=request.get_json()

        ## 获取参数，从客户端获取信息
        intlen=data_json.get("intlen")
        intnum=data_json.get("intnum")
        withnum=data_json.get("withnum")
        withlow=data_json.get("withlow")
        withup=data_json.get("withup")
        withspecial=data_json.get("withspecial")

        ## 如果请求的随机数长度过长或数量过多，返回失败
        if intlen>30 or intnum >1000:
            return jsonify(data=[], datalen=0, msg="fail")

        strings=[]
        ## 根据客户端信息生成随机字符串
        strings=generate_random_string(intlen, intnum, withnum, withlow, withup, withspecial)
        datalen=len(strings)

        if datalen>0:
            return jsonify(data=strings, datalen=datalen, msg="success")
        else:
            return jsonify(data=[], datalen=0, msg="fail")
```

上面路由代码中的核心随机字符串生成函数是`generate_random_string`：

```python
def generate_random_string(length, num_strings, use_numbers, use_lower_case, use_upper_case, use_special_chars):
    # 创建要选择的字符列表
    chars = []
    if use_numbers:
        chars += [str(i) for i in range(10)]
    if use_lower_case:
        chars += [chr(i) for i in range(97, 123)]
    if use_upper_case:
        chars += [chr(i) for i in range(65, 91)]
    if use_special_chars:
         chars += ['!','@','#','$']

    # 生成字符串
    strings = []
    for _ in range(num_strings):
        string = ''
        for _ in range(length):
            string += random.choice(chars)
        strings.append(string)

    return strings
```

还需要导入必要的Python库：

```python
from flask import request
from flask import jsonify
import random
```

写完代码后，运行`flask run`查看是否有错误。如果没有错误，那么我们需要测试随机数接口，看它是否能根据客户端提供的参数返回相应结果。

我们使用Bruno软件测试API接口，先测试hello接口：

![2024-03-26-bruno测试gethello](/img/2024-03-26-bruno测试gethello.jpg)

测试随机数生成接口：

![2024-03-26-postbruno测试](/img/2024-03-26-postbruno测试.jpg)

这说明Flask App功能已经完成，下一步就是生产环境部署。对于部署，我们首先修改.flaskenv文件：

```bash
FLASK_ENV=production ## 设置为生产环境
FLASK_APP=app.py ## 如果你的应用名是app，不需要明确指定；如果不是，必须明确指定
FLASK_RUN_PORT=5000  ## 重置为端口5000
```

## 2. Gunicorn的安装和使用

在生产环境中，Flask内置的WSGI服务器是不够的。我们需要使用更专业的服务器，比如Gunicorn。

在Python虚拟环境中安装Gunicorn：

```python
pip3 install gunicorn
```

安装成功后，在当前目录运行Gunicorn：

```bash
gunicorn -w 3 -b 0.0.0.0:5000 app:app
```

- `-w`：表示启动三个进程，Gunicorn应该使用的工作进程数。这里设置为3，意味着将有3个工作进程并行处理请求，这有助于提高应用程序吞吐量
- `-b`：表示接受所有IP访问，端口是5000
- `app:app`：从app（.py文件）模块启动app对象

![2024-03-26-gunicorn启动三个进程](/img/2024-03-26-gunicorn启动三个进程.jpg)

如上图所示，Gunicorn开始运行并开启了三个工作进程。再次使用Bruno测试POST，注意端口是5000，可以看到工作正常。

## 3. Supervisor的安装和配置

参考我们的架构图，现在需要安装Supervisor。Supervisor的主要作用是监控Gunicorn的运行。如果Gunicorn因各种原因宕机，Supervisor可以自动重启Gunicorn，确保生产环境的稳定性。

![2024-03-26-Nginx与Flask架构图](/img/2024-03-26-Nginx与Flask架构图.jpg)

在Ubuntu下安装Supervisor的命令如下：

```bash
sudo apt install supervisor
```

进入Supervisor的配置文件夹`/etc/supervisor/conf.d/`，创建一个名为"flaskrandom.conf"的配置文件，主要内容如下：

```bash
[program:flaskrandom]
command=/home/tfzhang/myflask/bin/gunicorn -w 3 -b 0.0.0.0:5000 app:app
directory=/home/tfzhang/myflask/  ## app.py所在的目录
user=tfzhang  ## 当前操作系统用户名
autostart=true
autorestart=true
stopasgroup=true
killasgroup=true
```

更新"flaskrandom.conf"配置文件后，输入以下两个命令：

```bash
sudo supervisorctl reread  ## 重新读取配置文件
sudo supervisorctl update  ## 使新配置文件生效
```

查看当前Supervisor监控任务：

```bash
sudo supervisorctl
```

![2024-03-26-supervisor基本操作](/img/2024-03-26-supervisor基本操作.jpg)

可以发现Flask App对应的进程已经在运行，并且可以用浏览器或Bruno正常访问服务，说明Supervisor配置正确。

假设**Ubuntu意外重启**，可以测试Flask App是否会在机器重启时**自动运行**。

要停止应用服务，在Supervisor终端中：

```bash
sudo supervisorctl ## 启动Supervisor终端
supervisor > stop flaskrandom
```

如果要启动，同样适用：

```bash
supervisor > start flaskrandom
```

## 4. 配置Nginx反向代理

在生产环境中，不是直接使用Gunicorn来接收用户请求。用户请求首先到达Nginx，然后Nginx反向代理访问Gunicorn。

为什么要使用Nginx作为反向代理？

- Nginx更强大
- 安全性：通过Nginx隔离内外网

在Ubuntu下安装Nginx的命令：

```bash
sudo apt install nginx
```

完成Nginx安装后，配置Nginx文件`/etc/nginx/sites-available/default`：

```bash
server {
	listen 80 default_server;
	listen [::]:80 default_server;

	root /var/www/html;

	# 如果您使用PHP，请将index.php添加到列表中
	index index.html index.htm index.php index.nginx-debian.html;

	server_name _;

	location / {
		proxy_pass http://127.0.0.1:5000/;
		try_files $uri $uri/ =404;
	}

	# 将PHP脚本传递给FastCGI服务器
	#
	location ~ \.php$ {
		include snippets/fastcgi-php.conf;

	#	# 使用php-fpm（或其他unix套接字）：
		fastcgi_pass unix:/var/run/php/php7.2-fpm.sock;
	}
}
```

在上面配置文件中，最重要的一行是：

```bash
proxy_pass http://127.0.0.1:5000/;
```

主要意思是将对"/"的原始访问重定向到"http://127.0.0.1:5000/"。保存配置文件并重启Nginx使新配置生效：

```bash
sudo service nginx reload
```

当我们再次测试时，可以发现不再需要在浏览器或Bruno中包含端口号5000来访问Flask App数据，说明Nginx的反向代理正在工作。

![2024-03-26-nginx反向代理成功](/img/2024-03-26-nginx反向代理成功.jpg)

## 5. 总结

以上所有操作都在Ubuntu 18.04系统上测试过。由于是本地虚拟机，无法演示如何配置网站域名和SSL证书。关于部署内容，可以直接查看其他关于Nginx部署的内容，这与Flask App无关，完全只与Nginx相关。

在实际的云服务器环境中，只要选择Ubuntu 18.04作为操作系统，以上操作都可以复现。唯一可能需要注意的就是防火墙和端口访问权限相关的问题。