// poster.typ —— 竖版宣传海报（参考 typst-talk/examples/poster 的结构）
#import "theme.typ": palette, font-body, font-mono, weight, NixOS

#set page(width: 12cm, height: auto, margin: (x: 1.1cm, top: 1.4cm, bottom: 1cm), fill: palette.bg)
#set text(font: font-body, size: 13pt, fill: palette.ink, lang: "zh", region: "cn")
#set par(leading: .8em, spacing: 1.2em)
#show strong: set text(weight: weight.strong, fill: palette.primary)
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

从系统为什么越用越乱讲起，到让Agent维护你的系统，附现场演示。

// 议程写成一份 NixOS 模块：每个选项对应一个观点，比逐条列章节更抽象
#block(
  width: 100%,
  fill: palette.code,
  inset: (x: .9em, y: .8em),
  radius: 3pt,
  text(size: .8em, raw(block: true, lang: "nix", ```
services.nixosTalk = {
  enable      = true;
  declarative = true;    # 系统即代码
  rollback    = true;    # 改坏了就回滚
  maintainer  = "agent"; # 交给 AI 维护
  liveDemo    = true;    # 现场演示
};```.text)),
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
