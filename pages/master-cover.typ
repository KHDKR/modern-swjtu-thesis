#import "../utils/datetime-display.typ": datetime-display, datetime-en-display
#import "../utils/style.typ": 字号, 字体

// 硕士研究生封面（中文封面 + 英文扉页）
// 依据《西南交通大学研究生学位论文撰写范式》中的硕士学位论文封面样式
#let master-cover(
  // documentclass 传入的参数
  doctype: "master",
  degree: "academic",
  nl-cover: false,
  anonymous: false,
  twoside: false,
  fonts: (:),
  info: (:),
  // 其他参数
  title-size: 字号.二号,
  title-weight: "bold",
  field-label-size: 字号.三号,
  field-value-size: 字号.三号,
  field-width: 68%,
  field-label-width: 132pt,
  field-row-gutter: 0.5cm,
  anonymous-info-keys: ("student-id", "author", "supervisor", "supervisor-ii", "author-en", "supervisor-en"),
  datetime-display: datetime-display,
  datetime-en-display: datetime-en-display,
) = {
  // 1.  默认参数
  fonts = 字体 + fonts
  info = (
    title: ("基于 Typst 的", "西南交通大学硕士学位论文"),
    title-en: "A Thesis Template for Southwest Jiaotong University",
    grade: "20XX",
    student-id: "1234567890",
    author: "张三",
    author-en: "Zhang San",
    department: "某学院",
    department-en: "School of XXX",
    major: "某专业",
    major-en: "XXX",
    supervisor: ("李四", "教授"),
    supervisor-en: "Professor Li Si",
    supervisor-ii: (),
    supervisor-ii-en: "",
    clc: "",
    udc: "",
    secret-level: "公开",
    school-code: "10613",
    submit-date: datetime.today(),
  ) + info

  // 2.  对参数进行处理
  // 2.1 如果是字符串，则使用换行符将标题分隔为列表
  if type(info.title) == str {
    info.title = info.title.split("\n")
  }
  if type(info.title-en) == str {
    info.title-en = info.title-en.split("\n")
  }
  // 2.2 日期在渲染时格式化
  assert(type(info.submit-date) == datetime, message: "submit-date must be datetime.")
  // 2.3 学位类型
  if info.degree == auto {
    info.degree = if doctype == "doctor" { "工学博士" } else { "工学硕士" }
  }

  // 3.  内部辅助函数
  let hide(key) = anonymous and (key in anonymous-info-keys)
  let blank(width) = box(
    width: width,
    height: 1em,
    baseline: 0pt,
    stroke: (bottom: 0.75pt + black),
  )
  let field-label(body) = text(font: fonts.黑体, size: field-label-size, body)
  let field-value(key, body) = {
    set align(left)
    text(
      font: fonts.宋体,
      size: field-value-size,
      if hide(key) { "████████" } else { body },
    )
  }

  // 4.  中文封面
  pagebreak(weak: true)
  set page(
    margin: (top: 2.54cm, bottom: 2.54cm, left: 2.6cm, right: 2.6cm),
    header: none,
    footer: none,
    numbering: none,
  )

  // 4.1 顶部分类号
  block(width: 100%)[
    #set text(font: fonts.宋体, size: 字号.小四, top-edge: 0.75em, bottom-edge: -0.25em)
    #set par(leading: 1em, justify: true, first-line-indent: 0pt)
    #grid(
      columns: (1fr, 1fr),
      column-gutter: 1em,
      row-gutter: 0.55cm,
      [中国图书分类号：#blank(2.6cm)],
      align(right)[密级：#if info.secret-level == "" { blank(2.4cm) } else { info.secret-level }],
      [国际图书分类号：#blank(2.6cm)],
      align(right)[单位代码：#info.school-code],
    )
  ]

  set align(center)

  v(1.35cm)
  text(font: fonts.黑体, size: 26pt, weight: "bold")[西 南 交 通 大 学]
  v(0.55cm)
  text(font: fonts.宋体, size: 22pt, weight: "bold")[硕 士 学 位 论 文]

  v(2.3cm)
  block(width: 100%, {
    set par(leading: 1.5em)
    text(
      font: fonts.黑体,
      size: title-size,
      weight: title-weight,
      info.title.join("\n"),
    )
  })

  v(2.3cm)
  block(
    width: field-width,
    grid(
      columns: (field-label-width, 1fr),
      column-gutter: 0.6em,
      row-gutter: field-row-gutter,
      align: (left + horizon, left + horizon),
      field-label[学 科 专 业],
      field-value("major", info.major),
      field-label[学　　　号],
      field-value("student-id", info.student-id),
      field-label[作 者 姓 名],
      field-value("author", info.author),
      field-label[指 导 老 师],
      field-value("supervisor", info.supervisor.join(" ")),
      field-label[学　　　院],
      field-value("department", info.department),
    ),
  )

  v(2.2cm)
  text(font: fonts.宋体, size: 字号.三号, datetime-display(info.submit-date))

  // 5.  英文扉页
  pagebreak(weak: true)
  set align(center)

  v(1.2cm)
  text(font: fonts.宋体, size: 字号.四号, weight: "bold")[
    A Thesis Submitted to \
    Southwest Jiaotong University for Master Degree
  ]

  v(2.6cm)
  block(width: 100%, {
    set par(leading: 1.5em)
    text(
      font: fonts.宋体,
      size: title-size,
      weight: "bold",
      info.title-en.join("\n"),
    )
  })

  v(3.4cm)
  block(
    width: field-width,
    grid(
      columns: (118pt, 1fr),
      column-gutter: 0.6em,
      row-gutter: field-row-gutter,
      align: (left + horizon, left + horizon),
      text(font: fonts.宋体, size: field-label-size)[Discipline],
      field-value("major-en", info.major-en),
      text(font: fonts.宋体, size: field-label-size)[Student ID],
      field-value("student-id", info.student-id),
      text(font: fonts.宋体, size: field-label-size)[Author],
      field-value("author-en", info.author-en),
      text(font: fonts.宋体, size: field-label-size)[Supervisor],
      field-value("supervisor-en", info.supervisor-en + if info.supervisor-ii-en != "" { ", " + info.supervisor-ii-en } else { "" }),
      text(font: fonts.宋体, size: field-label-size)[School],
      field-value("department-en", info.department-en),
    ),
  )

  v(2.4cm)
  text(font: fonts.宋体, size: 字号.三号, datetime-en-display(info.submit-date))
}
