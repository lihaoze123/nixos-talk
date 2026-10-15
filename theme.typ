// theme.typ —— 极简 touying 主题：米白底、Nix 蓝、Inter + 思源黑体，代码用 Fira Code
#import "@preview/touying:0.8.0": *
#import "@preview/zebraw:0.5.5": zebraw, zebraw-init

// ---------- 设计令牌 ----------
#let palette = (
  bg: rgb("#F7F6F2"), // 暖米白，不用纯白
  ink: rgb("#1F2328"), // 正文墨色
  muted: rgb("#6E737B"), // 页眉页脚、注释；投影下对比度约 4.4:1
  primary: rgb("#3E5C8A"), // Nix 深蓝
  light: rgb("#7EBAE4"), // Nix 浅蓝：仅用于深色页强调
  accent: rgb("#5277C3"), // Nix 中蓝：浅底上的章节编号，投影下仍可辨
  alert: rgb("#B5533C"), // 赭红，全场少量使用
  code: rgb("#EEEDE8"), // 代码块底色
  mark: rgb("#CCDCEC"), // 代码高亮行，与 code 底色拉开差距
)

// 字号阶梯：全场只用这几档
#let scale = (
  display: 3.6em, // 封面标题、Thanks
  section: 2.8em, // 章节编号
  title: 1.35em, // 页标题
  lead: 1.2em, // 引导句
  body: 1em,
  small: .8em, // 表格、注释、次要正文
  code: .85em, // 代码块
  code-lg: .95em, // 单栏纯代码页
  inline: .9em, // 行内代码，相对周围字号
  caption: .6em, // 页眉、页码、说明
  fine: .5em, // 网址等长串
)
#let rhythm = 1em // 段落、列表、块之间的间距基准

// 页面几何（pt，避免 em 随字号漂移）
#let geometry = (x: 58pt, top: 104pt, bottom: 48pt)

// 西文只负责拉丁字符，中文标点交给思源黑体；中西文间距由 Typst 自动补 1/4em，源码里不要手写空格
#let cjk = "Source Han Sans SC" // 思源黑体：字重齐全，投影下比细黑更稳
#let font-body = ((name: "Inter", covers: "latin-in-cjk"), cjk)
#let font-mono = ((name: "Fira Code", covers: "latin-in-cjk"), cjk) // 代码、编号、页码
#let weight = (light: 300, body: 400, heading: 500, strong: 700)

// 代码块外框：上下留白、小圆角；zebraw 的高亮行仍能左右贴边
#let code-frame(body) = block(
  fill: palette.code,
  inset: (y: .45em),
  radius: 3pt,
  clip: true,
  width: 100%,
  body,
)

// 高亮若干行的代码块：#code-hl(2, 3)[```nix ...```]
#let code-hl(..lines, body) = code-frame(zebraw(highlight-lines: lines.pos(), body))

// 单栏纯代码页放大代码：#code-lg[```nix ...```] 或 #code-lg(code-hl(2)[...])
// 代码块字号以 em 叠加，故按 code-lg / code 的比例放大
#let code-lg(body) = text(size: scale.code-lg / scale.code * 1em, body)

// ---------- 全局排版 ----------
#let base-style(body) = {
  set text(font: font-body, size: 22pt, weight: weight.body, fill: palette.ink, lang: "zh", region: "cn")
  set par(leading: .85em, spacing: rhythm, justify: false)
  set block(spacing: rhythm)
  set list(marker: text(fill: palette.primary, sym.bullet), indent: .2em, spacing: .8 * rhythm)
  set enum(numbering: n => text(fill: palette.primary, weight: weight.heading, str(n) + "."), spacing: .8 * rhythm)
  show strong: set text(weight: weight.strong, fill: palette.primary)
  show heading: set text(weight: weight.heading)
  show link: set text(fill: palette.primary)

  // 代码：等宽 + 浅底，不加边框；代码块交给 zebraw（支持 highlight-lines 高亮行）
  show raw: set text(font: font-mono, weight: weight.body)
  show raw.where(block: false): set text(size: scale.inline)
  show raw.where(block: false): box.with(
    fill: palette.code,
    inset: (x: .3em),
    outset: (y: .3em),
    radius: 2pt,
  )
  show raw.where(block: true): set text(size: scale.code)
  show: zebraw-init.with(
    numbering: false,
    lang: false,
    background-color: palette.code,
    highlight-color: palette.mark,
    inset: (top: .3em, bottom: .3em, left: 1em, right: 1em),
  )
  show: zebraw
  show raw.where(block: true): code-frame

  // 表格：只留横线
  set table(
    stroke: (_, y) => if y == 0 { (bottom: .6pt + palette.ink) } else { (bottom: .4pt + palette.code.darken(8%)) },
    inset: (x: .6em, y: .5em),
    align: left + horizon,
  )
  show table: set text(scale.inline)
  show table.cell.where(y: 0): set text(weight: weight.heading, fill: palette.primary)

  body
}

// ---------- 小组件 ----------
#let NixOS = text(fill: palette.primary, weight: weight.strong, "NixOS")
#let Nix = text(fill: palette.primary, weight: weight.strong, "Nix")
#let muted(body) = text(size: scale.small, fill: palette.muted, body)
#let kicker(body) = text(size: scale.caption, fill: palette.muted, tracking: .08em, upper(body))
#let hex(n) = text(font: font-mono, features: (calt: 0), "0x" + if n < 16 { "0" } + upper(str(n, base: 16)))
#let pad2(n) = if n < 10 { "0" + str(n) } else { str(n) }

// 两栏：列间距统一，左右互相垂直居中
#let side(..ratios) = grid.with(columns: ratios.pos(), column-gutter: 2em, align: left + horizon)

// 截图与图注：统一编号、字号与间距，保持图片和说明在同一页
#let captioned-image(path, caption) = {
  show figure.caption: set text(size: scale.caption, fill: palette.muted)
  figure(
    image(path, width: 100%),
    caption: caption,
    supplement: [图],
    numbering: "1",
    gap: .5 * rhythm,
  )
}

// 截图占位：现场替换为 image("...")
#let placeholder(label, height: 100%) = block(
  width: 100%,
  height: height,
  stroke: (paint: palette.muted, thickness: .6pt, dash: "dashed"),
  radius: 3pt,
  align(center + horizon, text(size: scale.caption, fill: palette.muted, label)),
)

// 仪式页（封面、章节、强调）共用：四边对称、内容居中
#let ceremony-page = config-page(margin: (x: geometry.x, y: geometry.bottom), header: none, footer: none)

// ---------- 页面类型 ----------
// 内容页：章节名 + 标题放在页眉里，位置每页固定；正文在剩余空间垂直居中
#let slide(config: (:), repeat: auto, setting: body => body, composer: auto, ..bodies) = touying-slide-wrapper(self => {
  let header(self) = align(bottom, {
    text(size: scale.caption, fill: palette.muted, utils.display-current-heading(level: 1, depth: self.slide-level))
    v(.3em)
    text(
      size: scale.title,
      weight: weight.heading,
      fill: palette.primary,
      utils.display-current-heading(level: 2),
    )
  })
  let footer(self) = align(right, text(
    size: scale.caption,
    fill: palette.muted,
    font: font-mono,
    context utils.slide-counter.display(pad2),
  ))
  let self = utils.merge-dicts(
    self,
    config-page(header: header, footer: footer),
    config-common(subslide-preamble: none),
  )
  touying-slide(
    self: self,
    config: config,
    repeat: repeat,
    setting: it => align(left + horizon, setting(it)),
    composer: composer,
    ..bodies,
  )
})

#let title-slide(config: (:)) = touying-slide-wrapper(self => {
  let info = self.info
  let meta = text(scale.small, fill: palette.muted, stack(
    spacing: .6em,
    [#info.author #h(1.5em) #info.institution],
    utils.display-info-date(self),
  ))
  // 视觉重心略高于几何中心
  let body = align(center, block(height: 100%, stack(
    v(1fr),
    text(scale.display, weight: weight.strong, fill: palette.primary, info.title),
    v(.8em),
    text(scale.lead, weight: weight.light, info.subtitle),
    v(3em),
    meta,
    v(1.15fr),
  )))
  self = utils.merge-dicts(self, config-common(freeze-slide-counter: true), ceremony-page)
  touying-slide(self: self, config: config, body)
})

// 章节页：居中对称，只有极客风编号 0x02 与章节名
#let new-section-slide(config: (:), body) = touying-slide-wrapper(self => {
  let body = align(center + horizon, context {
    let n = query(heading.where(level: 1).before(here())).filter(h => h.outlined).len()
    stack(
      text(scale.section, weight: weight.light, fill: palette.accent, hex(n)),
      v(1.3em),
      text(scale.title * 1.2, weight: weight.heading, fill: palette.primary, utils.display-current-heading(level: 1)),
    )
  })
  self = utils.merge-dicts(self, ceremony-page)
  touying-slide(self: self, config: config, body)
})

// 深色强调页：核心论点、Live Demo、Thanks，居中对称
#let focus-slide(config: (:), body) = touying-slide-wrapper(self => {
  self = utils.merge-dicts(
    self,
    config-common(freeze-slide-counter: true),
    ceremony-page,
    config-page(fill: palette.primary),
  )
  touying-slide(self: self, config: config, setting: it => {
    set text(fill: palette.bg, size: scale.lead)
    set par(leading: 1em)
    show raw: set text(fill: palette.light)
    show raw.where(block: false): it => it.text
    show strong: set text(weight: weight.strong, fill: palette.light)
    align(center + horizon, it)
  }, body)
})

#let notes(self: none, ..args) = touying-notes(
  self: self,
  header: self => pad(x: 32pt, y: 14pt, text(
    fill: palette.bg,
    weight: weight.heading,
    utils.display-current-heading(depth: self.slide-level),
  )),
  header-fill: palette.primary,
  fill: palette.bg,
  note-setting: note => pad(x: 40pt, y: 8pt, {
    set text(size: 20pt, font: font-body, fill: palette.ink)
    set par(leading: 1em)
    note
  }),
  ..args,
)

// ---------- 主题入口 ----------
#let nix-theme(aspect-ratio: "16-9", ..args, body) = {
  show: touying-slides.with(
    config-page(
      ..utils.page-args-from-aspect-ratio(aspect-ratio),
      fill: palette.bg,
      margin: geometry,
      header-ascent: 24pt,
      footer-descent: 16pt,
    ),
    config-common(
      slide-fn: slide,
      notes-fn: notes,
      new-section-slide-fn: new-section-slide,
      zero-margin-header: false,
      zero-margin-footer: false,
      show-strong-with-alert: false,
    ),
    config-methods(
      init: (self: none, body) => base-style(body),
      alert: (self: none, it) => text(fill: palette.alert, it),
    ),
    config-colors(
      primary: palette.primary,
      neutral-light: palette.muted,
      neutral-lightest: palette.bg,
      neutral-darkest: palette.ink,
    ),
    ..args,
  )
  body
}
