// theme.typ —— 极简 touying 主题：米白底、Nix 蓝、Fira Code + 方正
#import "@preview/touying:0.8.0": *

// ---------- 设计令牌 ----------
#let palette = (
  bg: rgb("#F7F6F2"), // 暖米白，不用纯白
  ink: rgb("#1F2328"), // 正文墨色
  muted: rgb("#8A8F98"), // 页眉页脚、注释
  primary: rgb("#3E5C8A"), // Nix 深蓝
  light: rgb("#7EBAE4"), // Nix 浅蓝，只用于细线
  alert: rgb("#B5533C"), // 赭红，全场少量使用
  code: rgb("#EEEDE8"), // 代码块底色
)

// Fira Code 只负责西文；中文标点交给方正
#let latin = (name: "Fira Code", covers: "latin-in-cjk")
#let font-body = (latin, "FZXiHeiI-Z08") // 方正细黑一
#let font-heading = (latin, "FZHei-B01") // 方正黑体
#let font-title = (latin, "FZXiaoBiaoSong-B05") // 方正小标宋，仅封面与海报

// ---------- 全局排版 ----------
#let base-style(body) = {
  set text(font: font-body, size: 22pt, fill: palette.ink, lang: "zh", region: "cn")
  set par(leading: .85em, spacing: 1.1em, justify: false)
  set list(marker: text(fill: palette.primary, sym.bullet), indent: .2em, spacing: .9em)
  set enum(numbering: n => text(fill: palette.primary, font: font-heading, str(n) + "."), spacing: .9em)
  show strong: set text(font: font-heading, weight: "semibold", fill: palette.primary)
  show heading: set text(font: font-heading, weight: "semibold")
  show link: set text(fill: palette.primary)

  // 代码：等宽 + 浅底，不加边框，左侧一条浅蓝细线
  show raw: set text(font: (latin, "FZXiHeiI-Z08"), size: .78em)
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
  show table.cell.where(y: 0): set text(font: font-heading, fill: palette.primary)

  body
}

// ---------- 小组件 ----------
#let NixOS = text(fill: palette.primary, weight: "bold", "NixOS")
#let Nix = text(fill: palette.primary, weight: "bold", "Nix")
#let muted(body) = text(fill: palette.muted, body)
#let kicker(body) = text(size: .6em, fill: palette.muted, tracking: .08em, upper(body))

// 截图占位：现场替换为 image("...")
#let placeholder(label, height: 100%) = block(
  width: 100%,
  height: height,
  stroke: (paint: palette.muted, thickness: .6pt, dash: "dashed"),
  radius: 3pt,
  align(center + horizon, text(size: .7em, fill: palette.muted, label)),
)

// ---------- 页面类型 ----------
#let slide(config: (:), repeat: auto, setting: body => body, composer: auto, ..bodies) = touying-slide-wrapper(self => {
  let header(self) = align(bottom, text(
    size: .55em,
    fill: palette.muted,
    utils.display-current-heading(level: 1, depth: self.slide-level),
  ))
  let footer(self) = align(right, text(
    size: .55em,
    fill: palette.muted,
    font: font-body,
    context utils.slide-counter.display(n => if n < 10 { "0" + str(n) } else { str(n) }),
  ))
  let self = utils.merge-dicts(
    self,
    config-page(header: header, footer: footer),
    config-common(subslide-preamble: block(
      below: 1em,
      text(1.35em, font: font-heading, weight: "medium", fill: palette.primary, utils.display-current-heading(level: 2)),
    )),
  )
  touying-slide(self: self, config: config, repeat: repeat, setting: setting, composer: composer, ..bodies)
})

#let title-slide(config: (:)) = touying-slide-wrapper(self => {
  let info = self.info
  let body = {
    set align(center + horizon)
    block(text(3.6em, font: font-title, weight: "bold", fill: palette.primary, info.title))
    v(.2em)
    text(1.3em, font: font-title, fill: palette.ink, info.subtitle)
    v(3em)
    set text(.7em, fill: palette.muted)
    [#info.author #h(1.5em) #info.institution \ ]
    utils.display-info-date(self)
  }
  self = utils.merge-dicts(
    self,
    config-common(freeze-slide-counter: true),
    config-page(margin: 3em, header: none, footer: none),
  )
  touying-slide(self: self, config: config, body)
})

#let new-section-slide(config: (:), body) = touying-slide-wrapper(self => {
  let body = {
    // 极客风编号：0x01 / 0x04
    let hex(n) = "0x" + if n < 16 { "0" } + upper(str(n, base: 16))
    set align(left + horizon)
    context {
      let sections = query(heading.where(level: 1)).filter(h => h.outlined)
      let n = query(heading.where(level: 1).before(here())).filter(h => h.outlined).len()
      text(2.6em, font: font-body, weight: "light", fill: palette.light, features: (calt: 0), hex(n))
      h(.4em)
      text(.8em, font: font-body, fill: palette.muted, features: (calt: 0), "/ " + hex(sections.len()))
    }
    v(-.2em)
    text(1.6em, font: font-heading, fill: palette.primary, utils.display-current-heading(level: 1))
  }
  self = utils.merge-dicts(self, config-page(margin: (x: 3em), header: none))
  touying-slide(self: self, config: config, body)
})

// 深色强调页：核心论点、Live Demo
#let focus-slide(config: (:), body) = touying-slide-wrapper(self => {
  self = utils.merge-dicts(
    self,
    config-common(freeze-slide-counter: true),
    config-page(fill: palette.primary, margin: 3em),
  )
  touying-slide(self: self, config: config, setting: it => {
    set text(fill: palette.bg, size: 1.3em)
    show raw: set text(fill: palette.bg)
    show raw.where(block: false): it => it.text
    show strong: set text(font: font-heading, fill: palette.light)
    align(left + horizon, it)
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
      margin: (x: 2.6em, top: 3.4em, bottom: 2em),
      header-ascent: 1.4em,
      footer-descent: .8em,
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
