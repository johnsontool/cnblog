---
title: 使用9esim实体esim卡让国行手机支持esims
date: 2025-11-29 11:04:26
author: John
tags:
    - esim
---



9esim实体esim卡，可以通过“一张实体 SIM 卡 + 一个 App”，就能 “为你的手机启用 eSIM 功能"。具体是将esim卡信息写入9esim的实体sim卡，再插入到国内手机的卡槽中，使得不支持esim的国内手机变为可使用esim的手机。

下面是本人使用 9esim的sim卡+国行iphone15的使用体验。

![实体卡](/img/实体卡.jpg)

首先，去[9esim官网](https://www.9esim.com/?coupon=sduanjucc2)购买9esim卡，我购买的V0卡+card reader套餐，其中的V0卡容量为450kB，按每个esim电子卡70~80kB计算，大概可以写入5-6个esim号码。card reader建议购买，方便后续直接使用电脑写入esim号码。

![image-20251128205328886](/img/image-20251128205328886.png)

![image-20251128205400241](/img/image-20251128205400241.png)

同时可以领取如下的1GB的eskimo的流量套餐，只要在购买页面点击如下buy product，redirect到eskimo的官网注册账户后，1GB的全球免费流量就到手.

[Free eSIM – 9eSIM](https://www.9esim.com/product/free-esim/)

![image-20251128205617813](/img/image-20251128205617813.png)

![image-20251128205846317](/img/image-20251128205846317.png)

##### 如何将eskimo电子esim写入到9esim卡?

![app-store](/img/app-store.PNG)

在苹果app store中安装eskimo的app,采用你在领取1GB流量时注册的账号登录,点击"账户"->"如何安装esim"->"手动",获取SM-DP+地址和激活代码.

![esikmo账户-horz](/img/esikmo账户-horz.jpg)

访问[9esim官网](https://www.9esim.com/?coupon=sduanjucc2)下载电脑对应的读卡软件,以windows电脑为例,下载EasyLPAC,下载地址为:https://github.com/creamlike1024/EasyLPAC/releases,  下载压缩包后,解压,可以看到EasyPAC.exe可执行文件.

![image-20251128210614155](/img/image-20251128210614155.png)

将9esim的sim卡插入card reader,再将card reader插入到电脑的USB接口,然后双击打开电脑上的EasyLPAC.exe软件,出现图1:

![SM-DP+activation](/img/SM-DP+activation.png)

点击"download",复制粘贴来自eskimo app的SM-DP+和激活代码,点击确定后,将esim卡信息写入到sim卡中,写入完成后,鼠标左键选中eskimo号码,点击软件右下角的enable,激活该esim号码.

![enable-esim](/img/enable-esim.png)

##### 插入手机并使用

再将sim卡从card reader中取出,插入到iphone15手机的卡槽,设置eskimo号码作为手机蜂窝流量卡,同时开启漫游,即可启用eskimo号码,并使用免费的1GB全球流量套餐.

![蜂窝与数据漫游](/img/蜂窝与数据漫游.PNG)

##### 注意事项：

在电脑端写入esim到实体卡时，一定要选择enable激活，要是不激活的话，插入到手机就不能使用。
