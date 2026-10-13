// theme.typ —— 极简 touying 主题：米白底、Nix 蓝、Fira Code + 方正
#import "@preview/touying:0.8.0": *

// ---------- 设计令牌 ----------
#let palette = (
  bg: rgb("#F7F6F2"), // 暖米白，不用纯白
  ink: rgb("#1F2328"), // 正文墨色
  muted: rgb("#8A8F98"), // 页眉页脚、注释
  primary: rgb("#3E5C8A"), // Nix 深蓝
  light: rgb("#7EBAE4"), // Nix 浅蓝：章节编号、代码块左线、深色页强调
  alert: rgb("#B5533C"), // 赭红，全场少量使用
  code: rgb("#EEEDE8"), // 代码块底色
)

// 字号阶梯：全场只用这几档
#let scale = (
  display: 3.6em, // 封面标题、Thanks
  section: 2.8em, // 章节编号
  title: 1.35em, // 页标题
  lead: 1.2em, // 引导句
  body: 1em,
  small: .8em, // 表格、注释、次要正文
  code: .75em,
  caption: .6em, // 页眉、页码、说明
  fine: .5em, // 网址等长串
)
#let rhythm = 1em // 段落、列表、块之间的间距基准

// 页面几何（pt，避免 em 随字号漂移）
#let geometry = (x: 58pt, top: 104pt, bottom: 48pt)

// Fira Code 只负责西文；中文标点交给方正
#let latin = (name: "Fira Code", covers: "latin-in-cjk")
#let font-body = (latin, "FZXiHeiI-Z08") // 方正细黑一
#let font-heading = (latin, "FZHei-B01") // 方正黑体
#let font-title = (latin, "FZXiaoBiaoSong-B05") // 方正小标宋，仅封面与海报

// ---------- 全局排版 ----------
#let base-style(body) = {
  set text(font: font-body, size: 22pt, fill: palette.ink, lang: "zh", region: "cn")
  set par(leading: .85em, spacing: rhythm, justify: false)
  set block(spacing: rhythm)
  set list(marker: text(fill: palette.primary, sym.bullet), indent: .2em, spacing: .8 * rhythm)
  set enum(numbering: n => text(fill: palette.primary, font: font-heading, str(n) + "."), spacing: .8 * rhythm)
  show strong: set text(font: font-heading, weight: "semibold", fill: palette.primary)
  show heading: set text(font: font-heading, weight: "semibold")
  show link: set text(fill: palette.primary)

  // 代码：等宽 + 浅底，不加边框，左侧一条浅蓝细线
  show raw: set text(font: (latin, "FZXiHeiI-Z08"), size: scale.code)
  show raw.where(block: false): box.with(
    fill: palette.code,
    inset: (x: .3em),
    outset: (y: .3em),
    radius: 2pt,
  )
  show raw.where(block: true): block.with(
    fill: palette.code,
    inset: (x: 1em, y: .8em),
    radius: 3pt,
    width: 100%,
    stroke: (left: 2pt + palette.light),
  )

  // 表格：只留横线
  set table(
    stroke: (_, y) => if y == 0 { (bottom: .6pt + palette.ink) } else { (bottom: .4pt + palette.code.darken(8%)) },
    inset: (x: .6em, y: .5em),
    align: left + horizon,
  )
  show table: set text(scale.small)
  show table.cell.where(y: 0): set text(font: font-heading, fill: palette.primary)

  body
}

// ---------- 小组件 ----------
#let NixOS = text(fill: palette.primary, weight: "bold", "NixOS")
#let Nix = text(fill: palette.primary, weight: "bold", "Nix")
#let muted(body) = text(size: scale.small, fill: palette.muted, body)
#let kicker(body) = text(size: scale.caption, fill: palette.muted, tracking: .08em, upper(body))
#let hex(n) = text(features: (calt: 0), "0x" + if n < 16 { "0" } + upper(str(n, base: 16)))
#let pad2(n) = if n < 10 { "0" + str(n) } else { str(n) }

// 两栏：列间距统一，左右互相垂直居中
#let side(..ratios) = grid.with(columns: ratios.pos(), column-gutter: 2em, align: left + horizon)

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
      font: font-heading,
      weight: "medium",
      fill: palette.primary,
      utils.display-current-heading(level: 2),
    )
  })
  let footer(self) = align(right, text(
    size: scale.caption,
    fill: palette.muted,
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
    text(scale.display, font: font-title, weight: "bold", fill: palette.primary, info.title),
    v(1.2em),
    text(scale.lead, font: font-title, info.subtitle),
    v(3em),
    meta,
    v(1.15fr),
  )))
  self = utils.merge-dicts(self, config-common(freeze-slide-counter: true), ceremony-page)
  touying-slide(self: self, config: config, body)
})

// 章节页：居中对称，极客风编号 0x02，下方小字进度 02 / 04
#let new-section-slide(config: (:), body) = touying-slide-wrapper(self => {
  let body = align(center + horizon, context {
    let total = query(heading.where(level: 1)).filter(h => h.outlined).len()
    let n = query(heading.where(level: 1).before(here())).filter(h => h.outlined).len()
    stack(
      text(scale.section, weight: "light", fill: palette.light, hex(n)),
      v(.9em),
      text(scale.title * 1.2, font: font-heading, fill: palette.primary, utils.display-current-heading(level: 1)),
      v(1.6em),
      text(scale.caption, fill: palette.muted, pad2(n) + " / " + pad2(total)),
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
    show strong: set text(font: font-heading, fill: palette.light)
    align(center + horizon, it)
  }, body)
})

#let notes(self: none, ..args) = touying-notes(
  self: self,
  header: self => pad(x: 32pt, y: 14pt, text(
    fill: palette.bg,
    font: font-heading,
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
