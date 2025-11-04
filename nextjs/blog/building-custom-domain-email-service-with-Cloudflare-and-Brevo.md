---
title: 使用Cloudflare和Brevo构建自定义域名邮件服务
date: 2025-10-29 11:04:26
author: tfzhang
tags:
  - Cloudflare
  - Brevo
---

当您注册域名时，通常希望拥有带有该域名后缀的电子邮件地址，以便发送和接收外观专业的邮件。

作为示例，我将使用在Cloudflare注册的域名来演示如何使用Cloudflare + Brevo + Gmail设置类似contact@johnstool.net的邮件服务。

邮件服务包括接收和发送功能。对于接收邮件，您可以使用Cloudflare的免费邮件路由服务，该服务将发送到contact@johnstool.net的所有邮件转发到我的Gmail地址。

---

### 入站邮件分步设置

1. 登录**Cloudflare仪表板** → 电子邮件 → *邮件路由*

![image-20251029093303833](/img/image-20251029093303833.png)

2. 添加规则以配置自定义地址（在我的情况下是"contact@johnstool.net"）并设置目标邮箱（例如，我的Gmail）。

```text
contact@johntool.net → mygmail@gmail.com
```

![image-20251029093816487](/img/image-20251029093816487.png)

3. 验证您的目标地址。

4. 配置您的DNS：您需要在DNS中添加MX和TXT记录的组合，以便邮件路由正常工作。

![image-20251029094125379](/img/image-20251029094125379.png)

5. 通过向`contact@johnstool.net`发送邮件进行测试 — 它应该会出现在您的Gmail收件箱中。

---

### 出站邮件分步设置

由于Cloudflare只能转发邮件但不能主动发送，您需要第三方邮件服务，如[Brevo](https://www.brevo.com/)。

1. 访问[Brevo](https://www.brevo.com/) → 注册（免费计划 = 300封邮件/天）。验证您的电子邮件和电话号码。

2. 在Brevo仪表板中 → **发件人和IP** → **域名** → 添加域名，然后选择自己验证域名。

```text
johnstool.net
```

![image-20251029100918166](/img/image-20251029100918166.png)

![image-20251029101054318](/img/image-20251029101054318.png)

3. Brevo将为您提供**DNS记录**（Brevo代码、DKIM1、DKIM2和DMARC）。

- 在Cloudflare DNS中添加这些记录。（不要为DKIM1和DKIM2开启代理状态）
- 添加所有记录后，在Brevo中点击"验证此邮件域名"。如果一切配置正确，验证只需几秒钟。

![domain-record](/img/domain-record.jpg)

---

### 分步配置Gmail"作为发送"

1. 打开**Gmail** → **设置** → 查看所有设置，转到**帐户和导入**选项卡，在*作为发送邮件*下，点击**添加另一个电子邮件地址**，

![image-20251029103311470](/img/image-20251029103311470.png)

然后输入（在我的情况下）：

- 姓名：johnson
- 电子邮件：`contact@johnstool.net`
- 如果您想将Gmail和支持邮件分开，请取消选中*作为别名处理*。

![image-20251029104327963](/img/image-20251029104327963.png)

SMTP设置（您可以从*Brevo → 设置 → SMTP和API*获取此信息）：

![image-20251029105043996](/img/image-20251029105043996.png)



![image-20251029104810819](/img/image-20251029104810819.png)

Gmail将向`contact@johnstool.net`发送验证码。

- 由于Cloudflare路由，它会到达您的Gmail收件箱。
- 点击链接并确认。

![image-20251029105445294](/img/image-20251029105445294.png)

2. 现在打开Gmail，转到**撰写**，选择`发件人：contact@johnstool.net`并发送到另一个电子邮件地址。发送邮件后，检查收件人的收件箱 - 它应该显示为来自您的域名，没有"通过Gmail"标记。

![image-20251029191024789](/img/image-20251029191024789.png)

---

### 结论

所有**入站邮件** → Cloudflare转发到Gmail。

所有**出站邮件** → Gmail使用Brevo SMTP，通过SPF/DKIM验证。

此设置的限制是Brevo有每日发送限制。免费计划只允许每天300封邮件。如果您需要更多，可以升级到其他计划：

![image-20251029192034824](/img/image-20251029192034824.png)

如果您的域名没有托管在Cloudflare上，您可以检查您的域名注册商是否提供邮件转发服务。如果他们提供，您可以直接使用；如果不提供，您可以考虑将您的域名迁移到Cloudflare。