---
title: 基于Ollama与AnythingLLM构建私人知识管理GPT
date: 2024-04-02 11:04:55
author: John
tags:
  - 大语言模型
---

Ollama是一个用于在本地运行大型语言模型（LLM）的开源框架，可以极大地简化大语言模型在本地的部署。Ollama的功能强大、易于使用和灵活多变的大型语言模型服务工具，可以让用户能够在自己的硬件环境中轻松部署和使用大规模预训练模型。

AnythingLLM是一个全栈应用程序，能够将任何文档、资源或内容片段转化为上下文，供任何LLM（大语言模型）在聊天时作为参考使用。此外，它允许用户灵活选择所使用的LLM或向量数据库，并提供给LLM训练或者使用。

本文探讨的私人知识助理GPT，主要思路由Ollama提供LLM能力，而由AnythingLLM整合各种文档、资源，供Ollama在聊天时作为参考使用。

##### 1、安装Ollama

访问Ollama官网：https://ollama.com/，下载对应操作系统的版本，比如windows。下载完成后，双击完成安装。

完成安装后，需要下载大语言模型，选择"Models"，我们查找中文大模型，输入"chinese"，可以找到"llama2-chinese"，

![2024-04-02-ollama下载大预言模型](/img/2024-04-02-ollama下载大预言模型-1712038932753-6.jpg)

该模型不同的参数对硬件有不同的要求：

- 7b models generally require at least 8GB of RAM
- 13b models generally require at least 16GB of RAM

如果受限本机内存，可以选择7b的版本，在命令行终端输入如下命令，会开启下载安装，安装完成后会自动启动大语言模型。

```bash
ollama run llama2-chinese:7b-chat
```



##### 2、安装AnythingLLM

AnythingLLM的官方地址：https://useanything.com/。下载对应操作系统的版本，比如windows，下载后双击完成安装。



##### 3、设置AnythingLLM工作空间

要使用AnythingLLM，首先要创建一个工作空间：

![2024-04-02-新建workspace](/img/2024-04-02-新建workspace.jpg)

创建工作空间后，要配置如下：

1. 选择大语言模型
2. 选择词嵌入模型
3. 选择向量数据库

因为已经安装本地Ollama大语言模型，所以我们选择Ollama作为大语言模型；

![2024-04-02-选择llm模型](D:\Desktop\hexo-test\source\_posts\imgpic\2024-04-02-选择llm模型.jpg)

词嵌入模型，我们也选择Ollama；

![2024-04-02-选择嵌入模型](/img/2024-04-02-选择嵌入模型.jpg)

而向量数据库，我们选择

![2024-04-02-选择向量数据库](/img/2024-04-02-选择向量数据库.jpg)



##### 4、上传各类文档

要将AnythingLLM配置为私人GPT，我们需要上传个人的各种文档，比如pdf，txt，doc等等，点击工作空间旁的上传按钮：

![2024-04-02-点击上传文档](/img/2024-04-02-点击上传文档.jpg)

然后先将本地文档拖拽到对应的目录，再将目录中的文档挪移到工作空间。

![2024-04-02-文档加入到工作空间](/img/2024-04-02-文档加入到工作空间.jpg)

当完成文档移动到后侧的工作空间，再点击提交，AnythingLLM会对文档进行解析，进行向量化处理。一旦完成处理，就可以和AnythingLLM就文档中的相关内容进行对话，十分方便。

> 注意事项：如果计算机硬件配置较低的话，不管是文档解析，还是回答问题，都会比较卡。



##### 5、其他：

国内同类的基于大语言模型的知识管理模型，推荐免费的网易有道云：[QAnything](https://qanything.ai/)

获取本文的同款Ollama和AnythingLLM的windows安装软件，可以分别发送"ollama"和"anythingllm"到公众号"青椒工具"。





