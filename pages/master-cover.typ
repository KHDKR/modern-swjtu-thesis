#import "../utils/datetime-display.typ": datetime-display, datetime-en-display
#import "../utils/style.typ": 字号, 字体

// 硕士研究生封面（中文封面 + 英文扉页）
// 全部元素按 Word 原版 PDF 的坐标逐项复刻：
//   - 中文封面：分类号/密级/单位代码、校名、学位类别、加下划线的题目、五个栏目、日期；
//   - 英文扉页：提交说明、英文题目、Discipline 等栏目、日期。
// 坐标单位为 pt，原点为纸张左上角（封面页页边距为 0）。
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
  underline-stroke: 0.6pt,
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
  // 中文字形墨迹相对 block 顶端的偏移（实测值，随字号线性变化）
  let cjk-dy(y, size) = y * 1pt + 0.109 * size
  // 西文数字墨迹偏移
  let latin-dy(y, size) = y * 1pt - 0.057 * size
  let put(x, y, body) = place(top + left, dx: x * 1pt, dy: y * 1pt, body)
  let hline(x, y, width, stroke: underline-stroke) = put(x, y, line(length: width * 1pt, stroke: stroke))

  // 4.  中文封面
  pagebreak(weak: true)
  set page(margin: 0pt, header: none, footer: none, numbering: none)
  set text(font: fonts.宋体, top-edge: 0.75em, bottom-edge: -0.25em)

  // 4.1 顶部分类号、密级、单位代码（12 pt 宋体）
  put(73.7, 79.11, text(size: 12pt, "中国图书分类号"))
  put(397.8, 79.11, text(size: 12pt, "密级"))
  put(73.7, 102.51, text(size: 12pt, "国际图书分类号"))
  put(397.8, 102.51, text(size: 12pt, "单位代码"))

  hline(157.7, 89.4, 90)
  hline(421.8, 89.4, 100)
  hline(157.7, 112.8, 90)
  hline(457.8, 112.8, 64)

  if info.clc != "" {
    put(157.7, 79.11, block(width: 90pt, align(center, text(size: 12pt, info.clc))))
  }
  if info.udc != "" {
    put(157.7, 102.51, block(width: 90pt, align(center, text(size: 12pt, info.udc))))
  }
  if info.secret-level != "" {
    put(421.8, 79.11, block(width: 100pt, align(center, text(size: 12pt, info.secret-level))))
  }
  put(457.8, 100.12, block(width: 64pt, align(center, text(size: 12pt, info.school-code))))

  // 4.2 校名与学位类别
  put(0, 210.04, block(width: 595.3pt, align(center, text(font: fonts.黑体, size: 26pt, weight: "bold", stroke: 0.015em + 0.25pt)[
    西#h(13pt)南#h(13pt)交#h(13pt)通#h(13pt)大#h(13pt)学
  ])))
  put(0, 250.71, block(width: 595.3pt, align(center, text(font: fonts.宋体, size: 22pt, weight: "bold", stroke: 0.015em + 0.25pt)[
    硕#h(11pt)士#h(11pt)学#h(11pt)位#h(11pt)论#h(11pt)文
  ])))

  // 4.3 学位论文题目（18 pt 黑体，居中；每行一条连续下划线）
  // Typst 的 underline() 会在空格和字体切换处断开，形成逐字下划线；
  // 这里按每行文字的实际宽度单独画一条连续的线。
  put(73.7, 361.47, block(width: 448pt, align(center, {
    set par(leading: 13pt)
    text(font: fonts.黑体, size: title-size, info.title.join("\n"))
  })))
  for (i, title-line) in info.title.enumerate() {
    context {
      let w = measure(text(font: fonts.黑体, size: title-size, title-line)).width
      place(
        top + left,
        dx: (595.3pt - w) / 2,
        dy: (377.4 + i * 31) * 1pt,
        line(length: w, stroke: underline-stroke),
      )
    }
  }

  // 4.4 学科专业、学号、作者姓名、指导老师、学院
  // 值过长时等比缩小，但最小保留 11 pt，避免出现难以辨认的小字
  let fit-value(value, width, font) = context {
    let base = text(font: font, size: 16pt, value)
    let w = measure(base).width
    if w <= width * 1pt {
      base
    } else {
      text(font: font, size: calc.max(11pt, 16pt * ((width * 1pt) / w)), value)
    }
  }
  let label-slot(chars) = grid(
    columns: (26.7pt, 26.5pt, 26.5pt, 16.3pt),
    ..chars.map(c => if c == none { [] } else { text(size: 16pt, c) }),
  )
  let field-row(y, chars, key, value) = {
    put(175.7, y + 1.73, label-slot(chars))
    hline(271.8, y + 15.4, 159.9, stroke: 0.7pt)
    if not hide(key) {
      put(271.8, y + 1.73, block(width: 159.9pt, pad(left: 6pt, fit-value(value, 150.9, fonts.宋体))))
    }
  }
  field-row(461.9, ("学", "科", "专", "业"), "major", info.major)
  field-row(493.1, ("学", none, none, "号"), "student-id", info.student-id)
  field-row(524.3, ("作", "者", "姓", "名"), "author", info.author)
  field-row(555.5, ("指", "导", "老", "师"), "supervisor", info.supervisor.join(" "))
  field-row(586.8, ("学", none, none, "院"), "department", info.department)

  // 4.5 日期
  put(0, 712.73, block(width: 595.3pt, align(center, text(size: 16pt, datetime-display(info.submit-date)))))

  // 5.  英文扉页
  pagebreak(weak: true)

  put(0, 102.80, block(width: 595.3pt, align(center, text(font: "Times New Roman", size: 14pt, weight: "bold", "A Thesis Submitted to"))))
  put(0, 134.00, block(width: 595.3pt, align(center, text(font: "Times New Roman", size: 14pt, weight: "bold", "Southwest Jiaotong University for Master Degree"))))

  put(85.1, 230.75, block(width: 425.2pt, align(center, {
    set par(leading: 9.2pt)
    text(font: "Times New Roman", size: 22pt, weight: "bold", info.title-en.join("\n"))
  })))

  let en-field(y, label, key, value) = {
    put(173.0, y - 0.91, block(width: 73.4pt, align(right, text(font: "Times New Roman", size: 16pt, label))))
    // 英文栏目的值紧接标签书写，下框线随内容延伸到右侧页边距
    hline(252, y + 16.0, 258, stroke: 0.7pt)
    if not hide(key) {
      put(252, y - 0.91, block(width: 258pt, align(left, fit-value(value, 258, "Times New Roman"))))
    }
  }
  en-field(453.6, "Discipline", "major-en", info.major-en)
  en-field(484.8, "Student ID", "student-id", info.student-id)
  en-field(516.0, "Author", "author-en", info.author-en)
  en-field(547.2, "Supervisor", "supervisor-en", info.supervisor-en + if info.supervisor-ii-en != "" { ", " + info.supervisor-ii-en } else { "" })
  en-field(578.4, "School", "department-en", info.department-en)

  put(0, 725.69, block(width: 595.3pt, align(center, text(font: "Times New Roman", size: 16pt, datetime-en-display(info.submit-date)))))
}









