#import "../utils/style.typ": 字号, 字体
#import "../layouts/master-preface.typ": master-header, master-footer, master-pagebreak

// 硕士研究生英文摘要页（ABSTRACT）
// 依据《西南交通大学研究生学位论文撰写范式》：
//   标题 ABSTRACT 小三号黑体加粗居中，段前 24 磅、段后 18 磅；
//   正文小四号 Times New Roman，固定行距 20 磅，首行缩进 2 字符，两端对齐；
//   关键词与摘要正文之间空一行，顶格书写，用逗号隔开。
#let master-abstract-en(
  // documentclass 传入的参数
  doctype: "master",
  degree: "academic",
  anonymous: false,
  twoside: false,
  fonts: (:),
  info: (:),
  // 其他参数
  keywords: (),
  title: "ABSTRACT",
  header-title: "ABSTRACT",
  outlined: false,
  keyword-gap: 20pt,
  body,
) = {
  // 1.  默认参数
  fonts = 字体 + fonts
  info = (
    title-en: "A Thesis Template for Southwest Jiaotong University",
    author-en: "Zhang San",
    major-en: "XXX",
    supervisor-en: "Professor Li Si",
  ) + info

  // 2.  分页与页眉页脚
  master-pagebreak(twoside: twoside)
  set page(
    margin: 3cm,
    header-ascent: 7.4pt,
    footer-descent: 0pt,
    header: master-header(header-title, fonts: fonts),
    footer: master-footer(numbering: "I", fonts: fonts),
  )

  // 3.  正文样式
  set text(font: fonts.宋体, size: 字号.小四, top-edge: 0.75em, bottom-edge: -0.25em)
  set par(leading: 8pt, spacing: 0pt, justify: true, first-line-indent: (amount: 2em, all: true))

  // 4.  标题（与 Word 原版墨迹位置对齐）
  v(26.44pt)
  block(
    width: 100%,
    above: 0pt,
    below: 25.67pt,
    align(center, text(font: fonts.黑体, size: 字号.小三, weight: "bold", stroke: 0.015em + 0.25pt, title)),
  )

  // 5.  摘要正文
  body

  // 6.  关键词（顶格，悬挂缩进与 Word 对齐）
  v(keyword-gap)
  block(
    width: 100%,
    above: 0pt,
    below: 0pt,
    {
      set par(first-line-indent: 0pt, hanging-indent: 6.2em, leading: 8pt, spacing: 0pt, justify: true)
      text(weight: "bold", [Keywords:])
      if keywords.len() > 0 {
        h(0.4em)
        keywords.join(", ")
      }
    },
  )
}




