# Taylor Agent

Taylor 的 **DSH（DeepSeek Harness）agent 工作区**。

这个仓库目前是初始化骨架：先把 agent 指令、任务模板、环境检查放在这里，具体业务代码按任务逐步加入。

## 状态

- [x] 仓库初始化
- [x] agent 指令（[AGENTS.md](AGENTS.md)）
- [x] 环境检查脚本
- [x] 任务 Issue 模板
- [ ] 第一个可执行任务（待定义）

## 这个仓库怎么用

1. 在这个仓库里用 DSH 启动 agent，DSH 会读取根目录的 `AGENTS.md` 作为工作指令。
2. 需要 agent 做事时，在 Issues 里新建 **Agent task**，写清目标、验收标准和边界。
3. agent 的改动走分支 + Pull Request；`main` 不直接改。

## 快速开始

### 前置

- Windows 10/11
- Git 2.40+
- Node.js 22.19+ 或 24+
- pnpm 11+
- DSH `0.2.1-rc.x`
- GitHub CLI（可选，推荐）

### 本地检查

```powershell
git clone git@github.com:taylorseekdelton/Taylor-agent-.git
cd Taylor-agent-
powershell -ExecutionPolicy Bypass -File .\scripts\check-env.ps1
```

> 本机访问 GitHub 的 HTTPS 可能被网络阻断；仓库已配置为通过 `ssh.github.com:443` 走 SSH。细节见 [docs/setup.md](docs/setup.md)。

## 目录

```text
.
├── AGENTS.md                     # agent 工作指令
├── README.md
├── docs/
│   └── setup.md                  # 环境、认证、网络说明
├── scripts/
│   └── check-env.ps1             # 检查 git / node / pnpm / dsh / gh
└── .github/
    └── ISSUE_TEMPLATE/
        └── agent-task.yml        # 给 agent 派任务的模板
```

## 安全

- 不要提交 token、SSH 私钥、`.env` 或任何凭据。
- 本仓库的 `.gitignore` 已忽略常见密钥和本地状态文件。
- 如果 token 曾经出现在聊天/日志里，视为已泄露并立即轮换。

## License

待定。添加业务代码前先确定许可证。
