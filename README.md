# NixOS —— 浅谈 AI 时代的 Agentic Linux 操作系统

程序设计社技术沙龙讲座的幻灯片与宣传海报，使用 [Typst](https://typst.app) + [Touying](https://github.com/touying-typ/touying) 排版。

- 主讲：chumeng
- 时间：2026 年 10 月 16 日（周五）
- 地点：1#530

> 在 NixOS 里，整个系统就是一份代码；而 AI Agent 最擅长的事，正是读代码、改代码。

## 构建

依赖通过 Nix flake 提供（typst、tinymist、just、pympress）：

```sh
nix develop
just all        # 生成全部产物到 dist/
```

| 命令 | 产物 | 用途 |
|---|---|---|
| `just slides` | `dist/nixos-talk.pdf` | 放映版 |
| `just presenter` | `dist/nixos-talk-presenter.pdf` | 演讲者版，右半为讲稿，配合 pympress |
| `just handout` | `dist/nixos-talk-handout.pdf` | 阅读版，合并动画，会后分发 |
| `just poster` | `dist/poster.pdf`、`dist/poster.png` | 竖版海报 |
| `just watch` | — | 边写边预览 |
| `just present` | — | 用 pympress 放映 |

### 字体

字体使用系统已安装的版本，不随仓库分发：

- 西文：Fira Code
- 中文正文：方正细黑一（`FZXiHeiI-Z08`）
- 中文标题：方正黑体（`FZHei-B01`）
- 封面与海报标题：方正小标宋（`FZXiaoBiaoSong-B05`）

可用 `typst fonts` 确认是否已安装。

## 目录

```
theme.typ    极简 touying 主题：配色、字号、页面类型、讲稿面板
main.typ     幻灯片正文与 #speaker-note 讲稿
poster.typ   宣传海报
PLAN.md      讲座结构、时间安排与放映 checklist
AGENTS.md    排版约定（同时供 AI Agent 阅读）
```

## 参考资料

- [NixOS 与 Flakes](https://nixos-and-flakes.thiscute.world/zh/)：中文入门
- [Zero to Nix](https://zero-to-nix.com)、[nix.dev](https://nix.dev)：快速上手与官方教程
- [NixOS Search](https://search.nixos.org/packages)：查包与选项
