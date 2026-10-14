# NixOS —— 浅谈 AI 时代的 Agentic Linux 操作系统

听众：大一新生（扩展视野） · 时长：约 25 分钟 + 问答 · 26 页

## 核心论点

> 在 NixOS 里，整个系统就是一份代码；而 AI Agent 最擅长的事，正是读代码、改代码。

三步论证：**系统即代码**（声明式） → **可回滚的安全网**（可复现 + 原子升级） → **Agent 来读写**（可审查的 diff）。

## 结构与时间

页码均为 PDF 物理页；幻灯片页脚的编号不计封面与深色强调页，会比物理页小。

| # | 部分 | 页 | 时长 | 衔接句 |
|---|---|---|---|---|
| 0 | 开场：电脑坏了能原样恢复吗？Windows 删不掉、恢复不了、臃肿 | 1–3 | 3′ | “删除和恢复，本质上是同一个问题：状态没被记录。” |
| 1 | Linux 与发行版（一张表）+ 越用越乱 | 4–6 | 3′ | “Linux 一样会乱。有没有系统把状态本身写下来？” |
| 2 | NixOS：声明式 / 可复现 / 原子回滚 | 7–10 | 6′ | “有了回滚，让别人动我的系统就不再可怕。” |
| 3 | Agentic OS：核心论点 → 为什么适合 → 工作流 → AGENTS.md | 11–15 | 4′ | “看一个真实例子。” |
| 3a | 案例一：Niri Computer Use（patch → flake → 四行配置）+ **Live Demo** | 16–19 | 6′ | “Agent 不止能改系统，还能替你写 Nix 包。” |
| 3b | 案例二：让 Agent 写 Nix 包（例：VType，Android APK → Nix 包） | 20 | 2′ | “听起来很美，那缺点呢？” |
| 4 | 缺点 ↔ Agent 补上 / 如何开始 / 回顾 / 参考资料 / Thanks | 21–26 | 3′ | 回扣开场问题 |

开场的问题贯穿全场：越用越乱 = 问题；可复现 = 答案；Agent = 连命令都不用自己写。

## 现场演示

顺序：① Agent 对话记录 → ② `jj diff` / `programs.codexComputerUse` 配置 → ③ 现场下达任务（提示词提前写好，直接粘贴）。
现场不构建。失败就说“结束后再演示”，直接翻页。

## 放映与推流 checklist

- [ ] `just presenter` 生成双宽 PDF，`pympress` 打开（内容窗口 / 演讲者窗口）
- [ ] Niri：内容窗口 `toggle-windowed-fullscreen`；为 pympress 内容窗口写 window-rule
- [ ] OBS 采集 Niri 动态投屏目标；绑定 `set-dynamic-cast-window` / `set-dynamic-cast-monitor` 快捷键
- [ ] 演示 workspace 预先打开好终端 / Agent 会话
- [ ] 网络与 API 提前测试

## 待补

- [ ] 截图：Windows 卸不掉的软件 / C 盘（第 3 页，页脚 02）、Agent 操作窗口（第 16 页，页脚 14）、微信输入法候选框（第 20 页，页脚 17），替换 `placeholder(...)` 为 `image(...)`

## 构建

```sh
nix develop      # typst、tinymist、just、pympress
just all         # dist/ 下：放映版、演讲者版、阅读版、海报 PDF/PNG
just present     # 直接放映
```

字体：西文 Inter，中文思源黑体，代码与编号 Fira Code（使用系统字体）。
