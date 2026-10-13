// poster.typ —— 竖版宣传海报（参考 typst-talk/examples/poster 的结构）
#import "theme.typ": palette, font-body, font-heading, font-title, NixOS

#set page(width: 12cm, height: auto, margin: (x: 1.1cm, top: 1.4cm, bottom: 1cm), fill: palette.bg)
#set text(font: font-body, size: 13pt, fill: palette.ink, lang: "zh", region: "cn")
#set par(leading: .8em, spacing: 1.2em)
#show strong: set text(font: font-heading, fill: palette.primary)
#set enum(numbering: n => text(fill: palette.primary, font: font-heading, str(n) + "."))
#set list(marker: text(fill: palette.muted, sym.bullet))

#align(center)[
  #text(2.2em, font: font-title, weight: "bold", fill: palette.primary)[NixOS] #h(.15em)
  #text(2em, font: font-title)[讲座]
  #v(-.6em)
  #text(.85em, fill: palette.muted)[浅谈 AI 时代的 Agentic Linux 操作系统]
]

#v(.4em)
#NixOS 是一个*声明式*的、*可复现*的 Linux 发行版。

#text(1.1em)[
  整个系统 = 一份*代码*，\
  而 AI Agent 最擅长*读写代码*。
]

#underline(offset: .25em, stroke: .5pt)[本讲座]包括以下内容：

+ Linux 与发行版：为什么系统越用越乱
+ #NixOS：声明式、可复现、可回滚
+ Agentic OS：让 Agent 维护你的系统
  - Niri Computer Use 现场演示
  - 把 Android 输入法打包进 Nix
+ 如何开始

#block(
  width: 100%,
  fill: palette.code,
  inset: (x: .9em, y: .7em),
  radius: 3pt,
  text(font: font-body, size: .8em)[
    #raw("programs.codexComputerUse.enable = true;", lang: "nix")
  ],
)

#v(1.4em)
#set text(.72em, fill: palette.muted)
#grid(
  columns: (auto, 1fr),
  column-gutter: 1em,
  row-gutter: .6em,
  [主讲], [chumeng],
  [时间], [10 月 16 日（周五）],
  [地点], [1\#530],
  [主办], [程序设计社],
)
