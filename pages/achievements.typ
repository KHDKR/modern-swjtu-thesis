#import "../utils/style.typ": 字号, 字体

// 攻读学位期间取得的研究成果页（硕士、博士通用）
// 依据《西南交通大学研究生学位论文撰写范式》：
//   标题按一级标题排版；内容采用五号宋体，行距 16 磅，段前段后均为 0 磅。
#let achievements(
  // documentclass 传入的参数
  twoside: false,
  fonts: (:),
  // 其他参数
  title: "攻读博士/硕士学位期间取得的研究成果",
  body-size: auto,
  body,
) = {
  pagebreak(weak: true)
  [
    #heading(level: 1, numbering: none, outlined: true, title) <no-auto-pagebreak>

    #{
      if body-size != auto {
        set text(font: fonts.宋体, size: body-size)
        set par(leading: 16pt - body-size, spacing: 0pt)
      }
      body
    }
  ]
}
