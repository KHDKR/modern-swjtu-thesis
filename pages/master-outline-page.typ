#import "../utils/style.typ": 字号, 字体
#import "../utils/invisible-heading.typ": invisible-heading
#import "../layouts/master-preface.typ": master-header, master-footer, master-pagebreak

// 硕士研究生目录页
// 依据《西南交通大学研究生学位论文撰写范式》：
//   目录从「第 1 章」开始，列出章、节、条三级标题及起始页码；
//   目录标题小三号黑体居中，条目小四号宋体，页码用 Times New Roman。
#let master-outline-page(
  // documentclass 传入的参数
  twoside: false,
  fonts: (:),
  // 其他参数
  depth: 3,
  title: "目　录",
  header-title: "目 录",
  outlined: false,
  title-gap: (24pt, 18pt),
  font: auto,
  size: 字号.小四,
  reference-size: 字号.小四,
  indent: (0pt, 1em, 2em),
  above: (12pt, 6pt, 6pt),
  below: (6pt, 6pt, 6pt),
  gap: 0.3em,
  ..args,
) = {
  // 1.  默认参数
  fonts = 字体 + fonts
  if font == auto {
    font = fonts.宋体
  }

  // 2.  分页与页眉页脚
  master-pagebreak(twoside: twoside)
  set page(
    margin: 3cm,
    header: master-header(header-title, fonts: fonts),
    footer: master-footer(numbering: "I", fonts: fonts),
  )

  // 3.  目录标题
  block(
    width: 100%,
    above: title-gap.at(0),
    below: title-gap.at(1),
    align(center, text(font: fonts.黑体, size: 字号.小三, title)),
  )
  invisible-heading(level: 1, outlined: outlined, title)

  // 4.  目录条目样式
  set text(font: font, size: size)
  show link: set text(fill: black)
  show outline.entry: entry => {
    let idx = calc.min(entry.level, indent.len()) - 1
    block(
      above: above.at(calc.min(entry.level, above.len()) - 1),
      below: below.at(calc.min(entry.level, below.len()) - 1),
      link(
        entry.element.location(),
        entry.indented(
          none,
          {
            if entry.prefix() not in (none, []) {
              entry.prefix()
              h(gap)
            }
            entry.body()
            box(width: 1fr, inset: (x: .25em), repeat([.], gap: 0.15em))
            text(font: fonts.宋体, size: reference-size, entry.page())
          },
          gap: 0pt,
        ),
      ),
    )
  }

  // 5.  渲染目录
  outline(title: none, depth: depth)
}
