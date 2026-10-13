out := "dist"

# 构建全部产物
all: slides presenter handout poster

# 放映版
slides:
    mkdir -p {{out}}
    typst compile main.typ {{out}}/nixos-talk.pdf

# 演讲者版：每页右半为备注，交给 pympress 拆分
presenter:
    mkdir -p {{out}}
    typst compile --input presenter=true main.typ {{out}}/nixos-talk-presenter.pdf

# 阅读版：合并 #pause 动画，用于会后分发
handout:
    mkdir -p {{out}}
    typst compile --input handout=true main.typ {{out}}/nixos-talk-handout.pdf

# 海报：PDF + 300 ppi PNG
poster:
    mkdir -p {{out}}
    typst compile poster.typ {{out}}/poster.pdf
    typst compile --ppi 300 poster.typ {{out}}/poster.png

# 边写边看
watch:
    typst watch main.typ {{out}}/nixos-talk.pdf

# 现场放映
present: presenter
    pympress {{out}}/nixos-talk-presenter.pdf
