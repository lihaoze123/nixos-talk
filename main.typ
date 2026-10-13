#import "theme.typ": *

// 编译模式：
//   typst compile main.typ --input presenter=true main-presenter.pdf   演讲者模式（右半为备注）
//   typst compile main.typ                                  放映 / 分发
//   typst compile main.typ --input handout=true  main-handout.pdf      阅读版（合并 #pause）
#let presenter = sys.inputs.at("presenter", default: "false") == "true"
#let handout = sys.inputs.at("handout", default: "false") == "true"

#show: nix-theme.with(
  config-info(
    title: [NixOS],
    subtitle: [浅谈 AI 时代的 Agentic Linux 操作系统],
    author: [chumeng],
    institution: [程序设计社],
    date: datetime(year: 2026, month: 10, day: 16),
  ),
  config-common(
    datetime-format: "[year] 年 [month padding:none] 月 [day padding:none] 日",
    handout: handout,
    show-notes-on-second-screen: if presenter { right } else { none },
  ),
)

#title-slide()

#speaker-note[
  自我介绍一句。今天不教命令，只讲一个想法：当整个操作系统变成一份代码，AI 就能替你维护它。
]

// ================================================================
== 先问一个问题 <touying:hidden>

#v(1fr)
#text(1.3em)[如果明天电脑坏了，\ 你能在一小时内把它*原样*恢复吗？]
#v(.6em)
#muted[装过的软件、改过的设置、调好的输入法 —— 全部。]
#v(1fr)

#speaker-note[
  停顿三秒，让大家想一想。大多数人的答案是“不能”，最多恢复个文件。
]

== Windows：装得上，删不掉，复刻不了

#slide(composer: (1fr, 1fr))[
  - *删除难*：卸载后残留注册表、服务、驱动，流氓软件“卸了又回来” #pause
  - *恢复难*：系统状态 = 多年点击的累积，没有任何记录 #pause
  - *臃肿*：C 盘只增不减，后台常驻越来越多
][
  #placeholder(height: 9em)[截图：控制面板里卸不掉的全家桶 \ / 臃肿的 C 盘]
]

#speaker-note[
  这里可以现场吐槽，或者放一张自己的截图。重点落在两个词上：删除、恢复。
  这两件事本质是同一个问题：系统的“状态”没有被记录下来。
]

// ================================================================
= Linux 与发行版

== Linux 发行版 = 内核 + 包管理 + 一套默认选择

#set text(.85em)
#table(
  columns: (auto, 1fr, 1fr, 1fr),
  [], [Ubuntu / Debian], [Arch], [#NixOS],
  [定位], [稳定，企业与服务器], [极客，滚动更新], [声明式，可复现],
  [包管理], [`apt`], [`pacman` + AUR], [`nix`],
  [软件], [稳定但偏旧], [多且新], [12 万+，又多又新],
  [系统状态], alert[命令的累积], alert[命令的累积], [*一份配置文件*],
)

#speaker-note[
  这一页最多一分钟。Ubuntu 稳、Arch 新，两者都很好用。
  但请看最后一行 —— 这是今天唯一要记住的差别。
]

== 但最后，都会越用越乱

#grid(
  columns: (1fr, auto, 1fr),
  column-gutter: 1.2em,
  align: horizon,
  [
    ```sh
    sudo apt install foo
    sudo vim /etc/xxx.conf
    curl ... | sh
    pip install --user bar
    # ……三年后
    ```
  ],
  text(1.6em, fill: palette.muted)[→],
  [
    #text(1.2em)[系统状态 = #alert[？]]
    #v(.3em)
    #muted[没人记得改过什么，\ 也就没法复刻、没法干净地删除。]
  ],
)

#speaker-note[
  这叫“配置漂移”。命令式管理的系统，状态就是所有历史操作的总和，而历史没有被保存下来。
  所以不只是 Windows，Linux 一样会乱。过渡：有没有一个系统，把状态本身写下来？
]

// ================================================================
= NixOS

== 声明式：整个系统写在一份文件里

#slide(composer: (1.25fr, 1fr))[
  ```nix
  { pkgs, ... }: {
    networking.hostName = "laptop";
    services.openssh.enable = true;
    programs.niri.enable = true;
    i18n.inputMethod.type = "fcitx5";

    environment.systemPackages = with pkgs; [
      git firefox typst
    ];
  }
  ```
][
  - 描述*要什么*，而不是*怎么做*
  - 删掉一行 = 干净地卸载
  - `nixos-rebuild switch` 让系统变成文件所写的样子
]

#speaker-note[
  对照开场的两个问题：删除 —— 删一行就删干净了；恢复 —— 这份文件就是系统本身。
]

== 可复现：同一份代码，同一个系统

// 备注须在 #pause 之前，否则只出现在最后一个子页
#speaker-note[
  哈希这一点不用讲细，点到即可：同样的输入一定得到同样的输出，就像纯函数。
]

- `/nix/store/<hash>-firefox-131.0`：每个包按*全部输入*的哈希存放，互不干扰，多版本共存 #pause
- `flake.lock` 锁定所有依赖的确切版本 #pause
- 换一台电脑：`git clone` + 一条命令 → 一模一样的系统

#v(.6em)
#muted[我自己的三台机器（笔记本、台式机、机房）共用同一个仓库，只用开关区分差异。]

== 原子升级，随时回滚

#slide(composer: (1fr, 1fr))[
  ```text
  NixOS
    Generation 214  (current)
    Generation 213
    Generation 212
    ...
  ```
][
  - 每次 rebuild 生成一个新*代际*，旧的原样保留
  - 改坏了？启动菜单选上一代，或 \ `nixos-rebuild switch --rollback`
  - 升级要么全部成功，要么什么都没发生
]

#speaker-note[
  这一点是后面 Agent 部分的伏笔：有了回滚，“让别人动我的系统”就不再可怕。
]

// ================================================================
= Agentic OS

#focus-slide[
  在 NixOS 里，*整个系统就是一份代码*。

  而 AI Agent 最擅长的事，\ 正是*读代码、改代码*。
]

#speaker-note[
  全场核心论点。慢慢讲，讲完停一下。
]

== 为什么 NixOS 天然适合交给 Agent

#table(
  columns: (auto, 1fr, 1fr),
  [], [传统发行版], [#NixOS],
  [Agent 怎么改], alert[直接执行 `sudo` 命令], [改配置文件],
  [能看懂改了什么吗], alert[只有一串 shell 历史], [一个清晰的 diff],
  [改坏了怎么办], alert[祈祷], [回滚到上一代],
  [换台机器], alert[再让 Agent 做一遍], [`git pull` 即可],
)

#v(.4em)
#muted[人负责审查和决定，Agent 负责动手。]

#speaker-note[
  三个关键词：文本、可审查、可回滚。合起来就是“安全地把系统交给 Agent”。
]

== 我的日常：把需求或 patch 丢给 Agent

#grid(
  columns: (1fr, auto, 1fr, auto, 1fr, auto, 1fr),
  align: center + horizon,
  column-gutter: .5em,
  ..{
    let step(n, title, desc) = block(
      width: 100%,
      height: 5.2em,
      inset: .7em,
      radius: 3pt,
      fill: palette.code,
      [#text(.7em, fill: palette.light, font: font-body, n) \ *#title* \ #text(.6em, fill: palette.muted, desc)],
    )
    let arrow = text(fill: palette.muted)[→]
    (
      step("01", "需求", "一句话或一个 patch"),
      arrow,
      step("02", "Agent 改配置", "nixos-config 仓库"),
      arrow,
      step("03", "我审查 diff", "jj diff / 求值检查"),
      arrow,
      step("04", "rebuild", "不行就回滚"),
    )
  },
)

#v(1em)
#muted[git 历史里的每一次提交，几乎都是这样完成的。]

#speaker-note[
  举一个最近的例子：想试一个新功能，就把上游的 patch 发给 Agent，它负责接进配置。
]

== AGENTS.md：写给 Agent 的系统手册

```md
## 构建、检查与开发命令
除非用户明确要求，否则永远不要运行完整构建。

## 配置安全与代理约定
不得提交明文凭据、私钥或解密内容；加密凭据按现有 ragenix 规则维护。
只有用户明确要求构建或部署时才执行相应操作，且先构建再激活。
```

#muted[规矩写进仓库，Agent 每次开工前都会读。]

#speaker-note[
  这是真实文件的节选。重点：边界是人定的、写成文字的，Agent 在边界内自由发挥。
]

// ---------------- 案例一 ----------------
== 案例一：让 Agent 操作我的电脑

#slide(composer: (1fr, 1fr))[
  *目标*：在 Niri 窗口管理器上实现 Computer Use

  #v(.4em)
  #set text(.85em)
  + 给 Niri 打 patch：IPC 暴露窗口坐标、截图
  + patch 越积越多：8 个文件、1200+ 行
  + 整体抽成独立 flake，别人也能直接复用
][
  #placeholder(height: 9em)[截图：Agent 正在操作窗口 \ （高亮边框 + 状态栏指示）]
]

#speaker-note[
  这是 Agent 改“系统本身”，而不是在系统上跑个程序。窗口管理器是桌面最底层的组件之一。
]

== 上游没有的功能，patch 一下

```diff
   pub fn tiles_with_ipc_layouts(&self) -> ... {
+      // Computer-use clients need the position in the current workspace view.
+      self.tiles_with_render_positions().map(move |(tile, pos, _)| {
         ...
         let layout = WindowLayout {
             pos_in_scrolling_layout: Some((col_idx + 1, tile_idx + 1)),
+            tile_pos_in_workspace_view: Some(pos.into()),
```

#muted[`patches/niri-ipc-tiled-window-position.patch` —— Agent 读 Niri 源码后写出。]

#speaker-note[
  不用看懂 Rust。要点：上游不支持的东西，在 NixOS 里可以用一个 patch 文件声明式地加上，而且这个 patch 是 Agent 写的。
]

== 最后，只剩四行

```nix
programs.codexComputerUse = {
  enable = true;
  users = [ "chumeng" ];
  package = inputs.computer-use.packages.${system}.codex-desktop;
};
```

#muted[1200 行 patch → 一个可复用的模块。任何一台 NixOS 都能一行开启。]

#speaker-note[
  讲完切去演示。先展示和 Agent 的对话，再展示这段配置，最后现场操作。
]

#focus-slide[
  #text(.8em, font: font-body)[`$` live demo]

  让 Agent 操作这台电脑
]

#speaker-note[
  Niri 切到演示 workspace；OBS 动态投屏目标切到该输出。
  顺序：① 对话记录 ② jj diff / 配置 ③ 现场下达任务。
  任务提示词提前写好，直接粘贴。出问题就说“结束后再演示”，直接翻页，不要恋战。
]

// ---------------- 案例二 ----------------
== 案例二：把手机输入法搬到 Linux

#slide(composer: (1fr, 1fr))[
  官方只有 *Android APK*。Agent 做了这些事：

  #set text(.85em)
  - 拉取 Android NDK 与系统镜像，提取 bionic 运行时
  - 解包 APK，补齐 Nix 运行库
  - 打上自己的补丁：小鹤双拼、云延迟
  - 写成一个 Nix 包
][
  ```sh
  nix profile install .#vtype-linux
  ```
  #v(.6em)
  #muted[另一台机器？同一条命令。]
]

#speaker-note[
  “只有别的平台的安装包”在传统 Linux 上基本等于“用不了”。
  在 NixOS + Agent 的组合下，逆向和打包的成本降到了一次对话；打包结果是代码，可以复用、可以分享。
]

// ================================================================
= 开始之前

== 缺点？Agent 恰好补上

#table(
  columns: (1fr, 1fr),
  [NixOS 的缺点], [有了 Agent 之后],
  [Nix 语言学习曲线陡峭], [Agent 写，你读；读懂比写出来容易得多],
  [文档分散、过时], [Agent 直接读 nixpkgs 源码，源码就是文档],
  [打包新软件门槛高], [一次对话完成，结果留在仓库里],
  [报错信息晦涩], [交给 Agent 解读、定位、修复],
)

#speaker-note[
  坦诚讲缺点，但要强调：这些缺点恰恰是“写代码、读代码”类的问题，而这正是 Agent 擅长的。
  NixOS 和 Agent 是互补的。
]

== 如何开始

- *零成本试水*：在现有 Linux / macOS 上装 #Nix 包管理器
- *虚拟机*：装一个 #NixOS，把配置交给 Agent 慢慢改
- *资料*：见最后的参考资料页

#v(.8em)
#muted[第一句提示词可以是：“帮我把这台电脑的配置写成 NixOS。”]

== 回顾

#v(1fr)
#set text(1.15em)
+ *系统即代码* —— 删除和恢复都只是改一份文件
+ *可回滚的安全网* —— 改坏了随时退回上一代
+ *Agent 来读写* —— 你负责想要什么，它负责做到
#v(1fr)

== 参考资料

#let res(title, url, desc) = block(below: 1.1em, {
  set par(leading: .5em)
  link(url, text(.75em, title))
  h(.5em)
  text(.55em, fill: palette.muted, desc)
  linebreak()
  text(.5em, fill: palette.muted, url.trim("https://", at: start).trim("/", at: end).trim("/zh"))
})


#grid(
  columns: (1.15fr, 1fr, 1fr),
  column-gutter: 1em,
  [
    #kicker[入门]
    #v(.3em)
    #res([NixOS 与 Flakes], "https://nixos-and-flakes.thiscute.world/zh/", "中文入门")
    #res([Zero to Nix], "https://zero-to-nix.com", "快速上手")
    #res([nix.dev], "https://nix.dev", "官方教程")
    #res([NixOS 中文社区], "https://nixos-cn.org", "交流与求助")
  ],
  [
    #kicker[查阅]
    #v(.3em)
    #res([NixOS Search], "https://search.nixos.org/packages", "查包与选项")
    #res([NixOS Manual], "https://nixos.org/manual/nixos/stable/", "官方手册")
    #res([NixOS Wiki], "https://wiki.nixos.org", "社区维基")
    #res([Nix Pills], "https://nixos.org/guides/nix-pills/", "深入原理")
  ],
  [
    #kicker[延伸]
    #v(.3em)
    #res([Niri], "https://github.com/YaLTeR/niri", "平铺窗口管理器")
    #res([AGENTS.md], "https://agents.md", "Agent 项目说明")
    #res([Typst], "https://typst.app", "本幻灯片的排版系统")
    #res([Touying], "https://github.com/touying-typ/touying", "Typst 幻灯片框架")
  ],
)

#speaker-note[
  不用念，告诉大家会后会分发 PDF，链接都可以点。推荐新手从第一本中文书开始。
]

#focus-slide[
  Thanks

  #v(.4em)
  #text(.7em)[`$ nixos-rebuild switch --flake .#future`]
]
