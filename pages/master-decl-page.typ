#import "../utils/style.typ": 字号, 字体

// 硕士研究生声明页：学位论文独创性声明 + 学位论文使用授权
// 依据《西南交通大学研究生学位论文撰写范式》
#let master-decl-page(
  anonymous: false,
  twoside: false,
  fonts: (:),
  // 其他参数
  title-size: 字号.三号,
  body-size: 字号.小四,
  signature-space: 5.2cm,
) = {
  // 0.  默认参数
  fonts = 字体 + fonts

  // 1.  统一的页面与段落设置
  pagebreak(weak: true)
  set page(
    margin: 3cm,
    header: none,
    footer: none,
    numbering: none,
  )
  set text(font: fonts.宋体, size: body-size, top-edge: 0.75em, bottom-edge: -0.25em)
  set par(leading: 8pt, spacing: 0pt, justify: true, first-line-indent: (amount: 2em, all: true))

  let decl-title(body) = block(
    width: 100%,
    above: 0pt,
    below: 1.4em,
    align(center, text(font: fonts.黑体, size: title-size, weight: "bold", body)),
  )

  let signature-line(body, width: 0pt) = block(
    above: 0pt,
    below: 1.1em,
    width: if width == 0pt { auto } else { width },
    body,
  )

  // 2.  第一页：学位论文独创性声明
  decl-title[西南交通大学 #linebreak() 学位论文独创性声明]

  [
    本人郑重声明：所呈交的学位论文是本人在导师指导下进行的研究工作及取得的研究成果。据我所知，除了文中特别加以标注和致谢的地方外，论文中不包含其他人已经发表或撰写过的研究成果，也不包含为获得西南交通大学或其它教育机构的学位或证书而使用过的材料。其他人员对本研究所做的任何贡献均已在论文中作了明确的说明并表示谢意。
  ]

  v(0.5em)
  [本学位论文的主要创新点如下：]

  v(signature-space)

  align(right)[
    #set par(first-line-indent: 0pt)
    #signature-line[作者签名：#h(6em)]
    #signature-line[日期：#h(2em) 年 #h(1.5em) 月 #h(1.5em) 日]
  ]

  // 3.  第二页：学位论文使用授权
  pagebreak(weak: true)
  decl-title[西南交通大学 #linebreak() 学位论文使用授权]

  [
    本学位论文作者完全了解西南交通大学有关保留、使用学位论文的规定，同意学校有权保留并向国家有关部门或机构送交论文的复印件和电子版，允许论文被查阅。本人授权西南交通大学可以将学位论文的全部或部分内容编入有关数据库进行检索及下载，可以采用影印、缩印、扫描等复制手段保存、汇编本学位论文。
  ]

  v(0.6em)
  [本学位论文属于]
  v(0.2em)
  [1．保密□，在 #h(3em) 年解密后适用本授权书；]
  v(0.2em)
  [2．不保密□，使用本授权书。]
  v(0.2em)
  [（请在以上方框内打“√”）]

  v(signature-space)

  align(right)[
    #set par(first-line-indent: 0pt)
    #signature-line[作者签名：#h(5em) 导师签名：#h(4em)]
    #signature-line[日期：#h(2em) 年 #h(1.5em) 月 #h(1.5em) 日]
  ]
}
