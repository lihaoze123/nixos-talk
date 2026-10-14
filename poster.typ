// poster.typ —— 竖版宣传海报（参考 typst-talk/examples/poster 的结构）
#import "theme.typ": palette, font-body, font-mono, weight, NixOS

#set page(width: 12cm, height: auto, margin: (x: 1.1cm, top: 1.4cm, bottom: 1cm), fill: palette.bg)
#set text(font: font-body, size: 13pt, fill: palette.ink, lang: "zh", region: "cn")
#set par(leading: .8em, spacing: 1.2em)
#show strong: set text(weight: weight.strong, fill: palette.primary)
#set enum(numbering: n => text(fill: palette.primary, weight: weight.heading, str(n) + "."))
#set list(marker: text(fill: palette.primary, sym.bullet))
#show raw: set text(font: font-mono)

#align(center)[
  #text(2.2em, weight: weight.strong, fill: palette.primary)[NixOS]#text(2em, weight: weight.heading)[讲座]
  #v(.2em)
  #text(.85em, fill: palette.muted)[浅谈AI时代的Agentic Linux操作系统]
]

#v(.4em)
#NixOS 是一个*声明式*、*可复现*的Linux发行版。

#text(1.1em)[
  整个系统 = 一份*代码*，\
  而AI Agent最擅长*读写代码*。
]

本讲座包括以下内容：

+ Linux与发行版：为什么系统越用越乱
+ #NixOS：声明式、可复现、可回滚
+ Agentic OS：让Agent维护你的系统
  - Niri Computer Use现场演示
  - 让Agent把软件打包进Nix
+ 如何开始

#block(
  width: 100%,
  fill: palette.code,
  inset: (x: .9em, y: .7em),
  radius: 3pt,
  text(size: .8em)[
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
  [时间], [10月16日（周五）],
  [地点], [1\#530],
  [主办], [程序设计社],
)
