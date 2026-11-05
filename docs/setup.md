# 环境与认证

这份文档记录本仓库在 Windows 上的推荐配置，以及当前网络环境下必须注意的 GitHub 访问方式。

## 1. 必需工具

| 工具 | 版本 | 用途 |
|---|---|---|
| Git | 2.40+ | 克隆、提交、推送 |
| Node.js | 22.19+ 或 24+ | DSH 与前端工具 |
| pnpm | 11+ | 安装依赖 |
| DSH | `0.2.1-rc.x` | 运行 agent |
| GitHub CLI | 2.60+ | 仓库、Issue、PR 操作（可选） |

检查：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\check-env.ps1
```

## 2. GitHub 认证

### 推荐：SSH（本机网络需要）

本机访问 `github.com:443` 会超时，但 `ssh.github.com:443` 可用。因此仓库使用 **SSH over 443**。

本仓库已通过 `repo` 权限自动添加了一把 **repo 级 deploy key（读写）**，所以当前仓库可以直接 clone / push。同一把公钥如果要用于账户下的其他仓库，需要手动添加到 GitHub 账户的 SSH keys；deploy key 只对这一个仓库有效。

`%USERPROFILE%\.ssh\config`：

```sshconfig
Host github.com
  HostName ssh.github.com
  Port 443
  User git
  IdentityFile ~/.ssh/id_ed25519_github
  IdentitiesOnly yes
```

生成密钥：

```powershell
ssh-keygen -t ed25519 -C "your-name@github" -f "$env:USERPROFILE\.ssh\id_ed25519_github"
```

把 `id_ed25519_github.pub` 的内容添加到：

<https://github.com/settings/ssh/new>

验证：

```powershell
ssh -T git@github.com
# Hi <username>! You've successfully authenticated...
```

### 备选：HTTPS token

如果网络能直连 `github.com:443`，也可以用 fine-grained PAT 或 classic PAT。建议最小权限：

- `repo`：仓库读写
- `read:org`：`gh` 登录校验
- `admin:public_key`：让 CLI 代加 SSH key（可选）
- `workflow`：推送 `.github/workflows`（需要 Actions 时）

不要把 token 写进仓库、脚本或 `.env`。用 `gh auth login` 存到系统凭据，或只在当前终端设置 `GH_TOKEN`。

## 3. DSH

```powershell
npm install -g @deepseek-ai/dsh@0.2.1-rc.3
dsh --version
```

在仓库根目录启动：

```powershell
dsh
```

DSH 会读取 `AGENTS.md`。如果使用 Superagent，请在面板里把仓库设为 `taylorseekdelton/Taylor-agent-`，并使用单独的 agent 账号（不要直接用人账号）。

## 4. 首次克隆

```powershell
mkdir "$env:USERPROFILE\Documents\GitHub" -Force
git clone git@github.com:taylorseekdelton/Taylor-agent-.git "$env:USERPROFILE\Documents\GitHub\Taylor-agent-"
cd "$env:USERPROFILE\Documents\GitHub\Taylor-agent-"
powershell -ExecutionPolicy Bypass -File .\scripts\check-env.ps1
```

## 5. 当前已知缺口

- Git 已安装到 `E:\CLI\Git`，用户 PATH 也已更新；**旧的终端窗口需要重开**才能继承。
- `node`、`pnpm`、`dsh` 已通过 DSH 自带运行时加入用户 PATH，新终端可直接使用。
- `gh` 已安装到 `E:\CLI\gh.exe`，但当前 token 只有 `repo` 权限，`gh auth login` 会因缺少 `read:org` 拒绝持久登录；`git` / SSH 推送不受影响。要用 `gh` 命令，可在当前终端临时设置 `GH_TOKEN`。
- 账户级 SSH key 仍需手动添加：当前 token 没有 `admin:public_key`，只能加 repo 级 deploy key。见 <https://github.com/settings/ssh/new>。
- 仓库还没有业务代码和测试；第一个任务确定后再补构建命令。
