# github_vps

在 GitHub 上申请免费的 VPS。

> 图文教程：https://mp.weixin.qq.com/s/vnA2AXD5zXiXGJNPdNH0BA

## 创建示例

### Ubuntu
<p align="center">
  <img width="512" alt="image" src="https://github.com/user-attachments/assets/93f97616-8aaf-4206-857a-5d17aed8c4d2" />
</p>

### Windows
<p align="center">
  <img width="512" alt="image" src="https://github.com/user-attachments/assets/f40bc167-62b7-4b29-91e0-15e07a76e21c" />
</p>

## 部署教程

先给脚本添加执行权限。

```bash
chmod +x start.sh
```

## Ubuntu 使用教程

### 启动 Ubuntu

```bash
bash start.sh ubuntu
```

### 默认登录信息

Web 终端：

```text
地址：http://<url>:4200
用户名：root
密码：root
```

SSH：

```text
地址：<url>:8022
用户名：root
密码：root
```

RDP：

```text
地址：<url>:3389
用户名：root
密码：root
```

### 修改 Ubuntu root 密码

启动时可以通过 `ROOT_PASSWORD` 指定 root 密码。

```bash
ROOT_PASSWORD='admin@123' bash start.sh ubuntu
```

### 连接 SSH

本地连接示例：

```bash
ssh root@localhost -p 8022
```

如果使用外部地址，将 `localhost` 替换为你的访问地址。

```bash
ssh root@<url> -p 8022
```

### 连接 RDP

```text
地址：<url>:3389
用户名：root
密码：root
```

如果你启动时设置了 `ROOT_PASSWORD`，这里的密码就是你设置的值。

### 停止 Ubuntu

```bash
bash start.sh stop ubuntu
```

## Windows 使用教程

> 不同Windows版本可以在这里看：https://hub.docker.com/r/dockurr/windows
> 
> 然后改：
> ```bash
> environment:
>     VERSION: "11"
> ```

### 启动 Windows 11

默认启动 Windows 11。

```bash
bash start.sh
```

也可以显式指定 Win11。

```bash
bash start.sh win11
```

### 下次使用速查

1. 启动 Codespace 后，在终端执行：

  ```bash
  cd /workspaces/github_vps
  docker compose -f windows/docker-compose.yml up -d
  ```

2. 打开 Windows 管理界面：

  ```text
  http://<url>:8006
  ```

3. 使用完毕后执行：

  ```bash
  docker compose -f windows/docker-compose.yml down
  ```

  然后在 GitHub 页面点击 `Stop codespace`。

Windows ISO 保存在 `/tmp/win11-storage/win11x64.iso`。不要删除 `/tmp/win11-storage`，否则下次可能需要重新下载。

### 默认登录信息

管理界面：

```text
地址：http://<url>:8006
```

RDP：

```text
地址：<url>:3389
用户名：MASTER
密码：admin@123
```

### 修改 Windows 登录信息

启动前可以通过环境变量修改用户名和密码。

```bash
WINDOWS_USERNAME='MASTER' WINDOWS_PASSWORD='admin@123' bash start.sh win11
```

也可以修改资源配置。

```bash
WINDOWS_RAM_SIZE='8G' WINDOWS_CPU_CORES='4' WINDOWS_DISK_SIZE='64G' bash start.sh win11
```

### 停止 Windows

```bash
bash start.sh stop win11
```

## 停止全部

如果需要同时停止 Windows 和 Ubuntu，执行：

```bash
bash start.sh stop
```

## 端口说明

| 系统      | 服务       | 端口   |
| ------- | -------- | ---- |
| Ubuntu  | Web 终端   | 4200 |
| Ubuntu  | SSH      | 8022 |
| Ubuntu  | RDP      | 3389 |
| Windows | Web 管理界面 | 8006 |
| Windows | RDP      | 3389 |

注意，Ubuntu 和 Windows 都会使用 `3389` 端口。如果需要切换系统，请先停止当前正在运行的系统。

```bash
bash start.sh stop ubuntu
```

或者：

```bash
bash start.sh stop win11
```

## 常见问题
### Windows 可以启动但无法联网
如果 Windows 已经启动，但系统内无法访问互联网，通常是 Docker 网络规则没有写入
`iptables-legacy`。按以下顺序修复：

1. 启动 Windows 容器：

  ```bash
  cd /workspaces/github_vps
  docker compose -f windows/docker-compose.yml up -d
  ```

2. 执行网络修复脚本：

  ```bash
  bash fix-network.sh
  ```

  脚本需要 `sudo` 权限，会自动找到 `windows_default` 网络，并添加容器出网所需的
  NAT 和转发规则。看到 `DONE_docker_egress_fixed` 表示规则已添加或已经存在。

3. 通过 Windows 浏览器或 RDP 测试访问互联网。如果仍然无法联网，先确认网络存在：

  ```bash
  docker network inspect windows_default
  ```

每次 Codespace 重启后如果再次出现无法联网，可以重新执行 `bash fix-network.sh`。
脚本可以重复执行，不需要删除 Windows 数据目录，也不要删除 `data.img` 或 ISO。

### 远程控制延迟太高
默认codespaces的VNC是卡的。可以在系统里装一个远程控制软件，比如Todesk、向日葵等，速度就很快了。

### 远程怎么访问
把URL从private改为public：

<img width="1080" height="434" alt="image" src="https://github.com/user-attachments/assets/f96a9008-dd7f-4874-954f-bcbb4dd6caf9" />

### 一小时就自动删了
没有活动下会被删，可以跑点任务，并把auto-delete关了：

<img width="1080" height="491" alt="image" src="https://github.com/user-attachments/assets/88001754-7bc5-4b43-b854-e3b2a02ee033" />






