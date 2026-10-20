#import "../utils/datetime-display.typ": datetime-display, datetime-en-display
#import "../utils/style.typ": 字号, 字体

// 硕士研究生封面（中文封面 + 英文扉页）
// 版式按《西南交通大学研究生学位论文撰写范式》中的硕士封面逐项对齐：
//   - 分类号、密级、单位代码行：小四号宋体，后接下划线；
//   - 校名：26 pt 黑体加粗；「硕士学位论文」：22 pt 宋体加粗；
//   - 学位论文题目：18 pt 黑体，带下划线；
//   - 学科专业等栏目：16 pt 宋体，标签四字分散对齐，值写在下划线上；
//   - 日期：16 pt 宋体居中。
// 各元素的纵向位置取自 Word 原版，按绝对坐标放置。
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
  underline-stroke: 0.75pt,
  title-size: 18pt,
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
  if type(info.title) == str {
    info.title = info.title.split("\n")
  }
  if type(info.title-en) == str {
    info.title-en = info.title-en.split("\n")
  }
  assert(type(info.submit-date) == datetime, message: "submit-date must be datetime.")
  if info.degree == auto {
    info.degree = if doctype == "doctor" { "工学博士" } else { "工学硕士" }
  }

  // 3.  内部辅助函数
  let hide(key) = anonymous and (key in anonymous-info-keys)

  // 下划线单元格：可承载居中书写的值
  let rule(width: 100%, content: none) = block(
    width: width,
    height: 1.2em,
    inset: 0pt,
    stroke: (bottom: underline-stroke + black),
    align(center + horizon, content),
  )

  // 四字标签分散对齐（两字标签放在首尾两格，与 Word 版式一致）
  let label-slot(chars) = grid(
    columns: (1fr, 1fr, 1fr, 1fr),
    align: center + horizon,
    ..chars.map(c => if c == none { [] } else { c }),
  )

  // 中文栏目行：标签 + 下划线值
  let field(chars, value) = grid(
    columns: (96pt, 1fr),
    align: horizon,
    label-slot(chars),
    rule(content: value),
  )

  // 4.  中文封面
  pagebreak(weak: true)
  set page(
    margin: 0pt,
    header: none,
    footer: none,
    numbering: none,
  )

  // 4.1 顶部分类号、密级、单位代码
  place(top + left, dx: 2.6cm, dy: 2.674cm, block(width: 15.8cm, text(font: fonts.宋体, size: 字号.小四)[
    #grid(
      columns: (auto, 90pt, 1fr, 4.6cm),
      align: horizon,
      [中国图书分类号],
      rule(width: 90pt, content: info.clc),
      [],
      grid(
        columns: (auto, 1fr),
        align: horizon,
        [密级],
        rule(content: info.secret-level),
      ),
    )
  ]))

  place(top + left, dx: 2.6cm, dy: 3.507cm, block(width: 15.8cm, text(font: fonts.宋体, size: 字号.小四, top-edge: 0.75em, bottom-edge: -0.25em)[
    #grid(
      columns: (auto, 90pt, 1fr, 4.6cm),
      align: horizon,
      [国际图书分类号],
      rule(width: 90pt, content: info.udc),
      [],
      grid(
        columns: (auto, 1fr),
        align: horizon,
        [单位代码],
        rule(content: info.school-code),
      ),
    )
  ]))

  // 4.2 校名与学位类别
  place(center + top, dy: 7.165cm, text(font: fonts.黑体, size: 26pt, weight: "bold")[西#h(0.5em)南#h(0.5em)交#h(0.5em)通#h(0.5em)大#h(0.5em)学])
  place(center + top, dy: 8.632cm, text(font: fonts.宋体, size: 22pt, weight: "bold")[硕#h(0.5em)士#h(0.5em)学#h(0.5em)位#h(0.5em)论#h(0.5em)文])

  // 4.3 学位论文题目（加下划线）
  place(top + left, dx: 2.6cm, dy: 12.35cm, block(width: 15.8cm, align(center, {
    set par(leading: 1.35em)
    underline(
      stroke: underline-stroke,
      text(font: fonts.黑体, size: title-size, info.title.join("\n")),
    )
  })))

  // 4.4 学科专业、学号、作者姓名、指导老师、学院
  let field-data = (
    (16.210cm, ("学", "科", "专", "业"), "major", info.major),
    (17.311cm, ("学", none, none, "号"), "student-id", info.student-id),
    (18.398cm, ("作", "者", "姓", "名"), "author", info.author),
    (19.502cm, ("指", "导", "老", "师"), "supervisor", info.supervisor.join(" ")),
    (20.610cm, ("学", none, none, "院"), "department", info.department),
  )
  for (y, chars, key, value) in field-data {
    place(top + left, dx: 2.6cm, dy: y, block(width: 9.05cm, text(font: fonts.宋体, size: 字号.三号, field(chars, if hide(key) { "████████" } else { value }))))
  }

  // 4.5 日期
  place(center + top, dy: 25.008cm, text(font: fonts.宋体, size: 字号.三号, datetime-display(info.submit-date)))

  // 5.  英文扉页
  pagebreak(weak: true)

  place(center + top, dy: 3.644cm, text(font: fonts.宋体, size: 字号.四号, weight: "bold", "A Thesis Submitted to"))
  place(center + top, dy: 4.731cm, text(font: fonts.宋体, size: 字号.四号, weight: "bold", "Southwest Jiaotong University for Master Degree"))

  place(top + left, dx: 2.6cm, dy: 8.149cm, block(width: 15.8cm, align(center, {
    set par(leading: 1.5em)
    text(font: fonts.宋体, size: 22pt, weight: "bold", info.title-en.join("\n"))
  })))

  let en-field-data = (
    (15.981cm, "Discipline", "major-en", info.major-en),
    (17.071cm, "Student ID", "student-id", info.student-id),
    (18.175cm, "Author", "author-en", info.author-en),
    (19.279cm, "Supervisor", "supervisor-en", info.supervisor-en + if info.supervisor-ii-en != "" { ", " + info.supervisor-ii-en } else { "" }),
    (20.380cm, "School", "department-en", info.department-en),
  )
  for (y, label, key, value) in en-field-data {
    place(top + left, dx: 2.6cm, dy: y, block(width: 15.8cm, text(font: fonts.宋体, size: 字号.三号, grid(
      columns: (110pt, 1fr),
      align: horizon,
      label,
      rule(content: if hide(key) { "████████" } else { value }),
    ))))
  }

  place(center + top, dy: 25.612cm, text(font: fonts.宋体, size: 字号.三号, datetime-en-display(info.submit-date)))
}


