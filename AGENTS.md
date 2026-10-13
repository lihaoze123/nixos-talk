# Repository Guidelines

本仓库是技术沙龙讲座《NixOS —— 浅谈 AI 时代的 Agentic Linux 操作系统》的幻灯片与海报，使用 Typst + touying 排版。讲座结构、时间安排与放映 checklist 见 `PLAN.md`。

## 项目结构

- `theme.typ`：自定义极简 touying 主题（设计令牌 `palette`、字体、页面类型、备注面板）。改样式只改这里。
- `main.typ`：幻灯片正文与 `#speaker-note` 讲稿。
- `poster.typ`：竖版宣传海报，复用 `theme.typ` 的配色与字体。
- `justfile`：构建命令；`flake.nix`：devShell（typst、tinymist、just、pympress）。
- `dist/`：构建产物，不纳入版本管理。

## 构建与检查

```sh
nix develop          # 进入开发环境
just all             # 放映版、演讲者版、阅读版、海报 PDF/PNG
just slides          # 仅放映版
just watch           # 边写边预览
```

修改后至少运行一次 `typst compile main.typ` 确认无报错；涉及版面时渲染 PNG 检查是否溢出出多余页面：

```sh
typst compile --input handout=true main.typ "out/s-{0p}.png" --ppi 60
```

## 设计约定

- 简洁、留白，不加多余装饰（横线、阴影、渐变、图标堆砌）。封面居中对称。
- 颜色只用 `palette` 中的令牌，不在正文里写死色值。赭红 `palette.alert` 仅用于少量痛点强调。
- 字号只用 `scale` 中的档位，间距以 `rhythm` 为基准；页面几何见 `geometry`。
- 内容页标题由主题放在页眉，位置固定；正文自动垂直居中，不要手写 `#v(1fr)`。封面、章节页、强调页一律居中对称。
- 两栏用 `#slide(composer: side(1fr, 1fr))[…][…]`，左右互相垂直居中。
- 字体：西文 Fira Code；中文正文方正细黑一（`FZXiHeiI-Z08`）、标题方正黑体（`FZHei-B01`）、封面与海报标题方正小标宋（`FZXiaoBiaoSong-B05`）。使用系统字体，不打包字体文件。
- `*strong*` 为主色强调；`#alert[...]` 为警示色。章节编号为 `0x01 / 0x04` 格式，需关闭 Fira Code 的 `calt` 连字。
- 代码块由 `@preview/zebraw` 渲染（无行号、无左线）；需要强调某几行时用 `#code-hl(2, 3)[```nix …```]`。
- 截图暂用 `placeholder(...)`，替换时改为 `image(...)` 并放入 `images/`。

## touying 注意事项

- 版本固定为 `@preview/touying:0.8.0`。
- 演讲者模式通过 `--input presenter=true` 启用 `show-notes-on-second-screen: right`；阅读版通过 `--input handout=true`。
- `#speaker-note` 必须写在该页第一个 `#pause` 之前，否则只出现在最后一个子页。
- 两栏页中的占位图需给定固定高度，避免溢出生成空白页。
- 不要在页面顶层写 `#set text(...)`：touying 会把它带到后续所有页，字号逐页叠加。需要局部字号时用 `#text(size)[…]` 包住。

## 内容与隐私

- 讲稿与幻灯片使用中文。听众为大一新生，术语首次出现时给出直白解释。
- 主讲人 chumeng、主办方程序设计社、2026-10-16（周五）、地点 1#530 已确认；其余未确认的信息以 `‹…›` 占位，未经用户确认不要填入。
- 引用的 nixos-config 代码片段：用户名 chumeng 可直接出现；私有仓库地址、凭据等仍需脱敏。

## 版本管理

使用 Jujutsu（与 Git colocated）：`jj status`、`jj diff`、`jj describe`、`jj new`。避免使用会改变仓库状态的 Git 命令。提交信息采用 `feat(scope): 描述`、`fix(scope): 描述` 等格式，scope 如 `slides`、`theme`、`poster`、`notes`。
