#import "../utils/style.typ": 字号, 字体

// 硕士研究生声明页：学位论文独创性声明 + 学位论文使用授权
// 纵向位置按 Word 原版（A4，页边距 3 cm）逐项对齐。
#let master-decl-page(
  anonymous: false,
  twoside: false,
  fonts: (:),
  // 其他参数
  title-size: 字号.三号,
  body-size: 字号.小四,
) = {
  // 0.  默认参数
  fonts = 字体 + fonts

  // 统一的正文样式
  let body-text(offset, content) = place(
    top + left,
    dx: 0cm,
    dy: offset,
    block(width: 15.8cm, content),
  )

  let decl-title(offset, content) = place(
    center + top,
    dy: offset,
    text(font: fonts.黑体, size: title-size, weight: "bold", content),
  )

  let signature(offset, content) = place(
    top + left,
    dx: 8.0cm,
    dy: offset,
    block(width: 6.2cm, align(left, content)),
  )

  // 1.  学位论文独创性声明
  pagebreak(weak: true)
  set page(margin: 3cm, header: none, footer: none, numbering: none)
  set text(font: fonts.宋体, size: body-size, top-edge: 0.75em, bottom-edge: -0.25em)
  set par(leading: 8pt, spacing: 0pt, justify: true, first-line-indent: (amount: 2em, all: true))

  decl-title(0cm, "西南交通大学")
  decl-title(0.847cm, "学位论文独创性声明")

  body-text(2.641cm)[
    本人郑重声明：所呈交的学位论文是本人在导师指导下进行的研究工作及取得的研究成果。据我所知，除了文中特别加以标注和致谢的地方外，论文中不包含其他人已经发表或撰写过的研究成果，也不包含为获得西南交通大学或其它教育机构的学位或证书而使用过的材料。其他人员对本研究所做的任何贡献均已在论文中作了明确的说明并表示谢意。
  ]

  body-text(6.980cm)[本学位论文的主要创新点如下：]

  signature(15.250cm)[作者签名：#h(4em)]
  signature(16.718cm)[日期：#h(2em) 年 #h(1.5em) 月 #h(1.5em) 日]

  // 2.  学位论文使用授权
  pagebreak(weak: true)

  decl-title(0cm, "西南交通大学")
  decl-title(0.847cm, "学位论文使用授权")

  body-text(2.430cm)[
    本学位论文作者完全了解西南交通大学有关保留、使用学位论文的规定，同意学校有权保留并向国家有关部门或机构送交论文的复印件和电子版，允许论文被查阅。本人授权西南交通大学可以将学位论文的全部或部分内容编入有关数据库进行检索及下载，可以采用影印、缩印、扫描等复制手段保存、汇编本学位论文。
  ]

  body-text(6.360cm)[本学位论文属于]
  body-text(7.192cm)[1．保密□，在 #h(3em) 年解密后适用本授权书；]
  body-text(8.008cm)[2．不保密□，使用本授权书。]
  body-text(8.827cm)[（请在以上方框内打“√”）]

  place(top + left, dx: 7.2cm, dy: 10.293cm, block(width: 8.6cm)[
    #grid(columns: (1fr, 1fr), [作者签名：#h(2em)], [导师签名：#h(2em)])
  ])
  signature(11.112cm)[日期：#h(2em) 年 #h(1.5em) 月 #h(1.5em) 日]
}

