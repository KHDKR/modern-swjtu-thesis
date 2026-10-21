// 南京大学学位论文模板 modern-nju-thesis
// Author: https://github.com/OrangeX4
// Repo: https://github.com/nju-lug/modern-nju-thesis
// 在线模板可能不会更新得很及时，如果需要最新版本，请关注 Repo

#import "layouts/doc.typ": doc
#import "layouts/preface.typ": preface
#import "layouts/master-preface.typ": master-preface
#import "layouts/mainmatter.typ": mainmatter
#import "layouts/appendix.typ": appendix
#import "pages/fonts-display-page.typ": fonts-display-page
#import "pages/bachelor-cover.typ": bachelor-cover
#import "pages/bachelor-copyright.typ": bachelor-copyright
#import "pages/master-cover.typ": master-cover
#import "pages/bachelor-decl-page.typ": bachelor-decl-page
#import "pages/master-decl-page.typ": master-decl-page
#import "pages/bachelor-abstract.typ": bachelor-abstract
#import "pages/master-abstract.typ": master-abstract
#import "pages/bachelor-abstract-en.typ": bachelor-abstract-en
#import "pages/bachelor-evaluation-page.typ": bachelor-evaluation-page
#import "pages/bachelor-task-page.typ": bachelor-task-page
#import "pages/master-abstract-en.typ": master-abstract-en
#import "pages/bachelor-outline-page.typ": bachelor-outline-page
#import "pages/master-outline-page.typ": master-outline-page
#import "pages/master-notation.typ": master-notation
#import "pages/list-of-figures.typ": list-of-figures
#import "pages/list-of-tables.typ": list-of-tables
#import "pages/notation.typ": notation
#import "pages/acknowledgement.typ": acknowledgement
#import "pages/achievements.typ": achievements
#import "utils/custom-cuti.typ": *
#import "utils/bilingual-bibliography.typ": bilingual-bibliography
#import "utils/custom-numbering.typ": custom-numbering
#import "utils/custom-heading.typ": heading-display, active-heading, current-heading
#import "@preview/i-figured:0.2.4": show-figure, show-equation
#import "utils/style.typ": 字体, 字号

#let indent = h(2em)

// 原生 bibliography 元素函数（documentclass 内的 bibliography 参数会遮蔽同名函数）
#let bibliography-element = bibliography

// 使用函数闭包特性，通过 `documentclass` 函数类进行全局信息配置，然后暴露出拥有了全局配置的、具体的 `layouts` 和 `templates` 内部函数。
#let documentclass(
  doctype: "bachelor",  // "bachelor" | "master" | "doctor" | "postdoc"，文档类型，默认为本科生 bachelor
  degree: "academic",  // "academic" | "professional"，学位类型，默认为学术型 academic
  nl-cover: false,  // TODO: 是否使用国家图书馆封面，默认关闭
  twoside: false,  // 双面模式，会加入空白页，便于打印
  anonymous: false,  // 盲审模式
  bibliography: none,  // 原来的参考文献函数
  fonts: (:),  // 字体，应传入「宋体」、「黑体」、「楷体」、「仿宋」、「等宽」
  info: (:),
) = {
  // 默认参数
  fonts = 字体 + fonts
  // 研究生模板目前不在 PDF 中插入空白背页（双面打印时的空白背页由打印环节自然产生），
  // 以免修改页码计数器导致版面无法收敛。
  if doctype == "master" or doctype == "doctor" {
    twoside = false
  }
  info = (
    title: ("基于 Typst 的", "西南交通大学学位论文"),
    title-en: "SWJTU Thesis Template for Typst",
    grade: "20XX",
    student-id: "1234567890",
    author: "张三",
    author-en: "Zhang San",
    department: "某学院",
    department-en: "School of XXX",
    major: "某专业",
    major-en: "XXX Major",
    field: "某方向",
    field-en: "XX Field",
    supervisor: ("李四", "教授"),
    supervisor-en: "Professor Li Si",
    supervisor-ii: (),
    supervisor-ii-en: "",
    submit-date: datetime.today(),
    // 以下为研究生项
    defend-date: datetime.today(),
    confer-date: datetime.today(),
    bottom-date: datetime.today(),
    chairman: "某某某 教授",
    reviewer: ("某某某 教授", "某某某 教授"),
    clc: "",
    udc: "",
    secret-level: "公开",
    supervisor-contact: "西南交通大学 四川省成都市郫都区犀安路999号",
    email: "xxx@my.swjtu.edu.cn",
    school-code: "10613",
    degree: auto,
    degree-en: auto,
  ) + info

  return (
    // 将传入参数再导出
    doctype: doctype,
    degree: degree,
    nl-cover: nl-cover,
    twoside: twoside,
    anonymous: anonymous,
    fonts: fonts,
    info: info,
    // 页面布局
    doc: (..args) => {
      let named = args.named()
      let margin = named.at(
        "margin",
        default: if doctype == "master" or doctype == "doctor" { 3cm } else { auto },
      )
      let opts = (
        margin: margin,
        header-ascent: if doctype == "master" or doctype == "doctor" { 7.4pt } else { none },
        footer-descent: if doctype == "master" or doctype == "doctor" { 0pt } else { none },
        info: info + named.at("info", default: (:)),
        fonts: fonts + named.at("fonts", default: (:)),
      ) + named
      doc(..args.pos(), ..opts)
    },
    preface: (..args) => {
      let named = args.named()
      let opts = (twoside: twoside, fonts: fonts + named.at("fonts", default: (:))) + named
      if doctype == "master" or doctype == "doctor" {
        master-preface(..args.pos(), ..opts)
      } else {
        preface(..args.pos(), ..opts)
      }
    },
    mainmatter: (..args) => {
      let named = args.named()
      if doctype == "master" or doctype == "doctor" {
        let opts = (
          twoside: twoside,
          display-header: false,
          header-text: if doctype == "doctor" { "西南交通大学博士学位论文" } else { "西南交通大学硕士学位论文" },
          header-font: fonts.宋体,
          header-size: 字号.小五,
          header-stroke: 0.8pt,
          footer-style: "plain",
          blank-page-before: false,
          page-header-ascent: 7.4pt,
          page-footer-descent: 0pt,
          footer-size: 字号.小五,
          numbering: custom-numbering.with(first-level: "第1章 ", depth: 4, "1.1 "),
          heading-size: (字号.小三, 字号.四号, 字号.四号, 字号.小四),
          heading-above: (24pt, 23.3pt, 12pt, 12pt),
          heading-below: (18pt, 13.8pt, 6pt, 6pt),
          heading-weight: ("regular", "regular", "regular", "regular"),
          heading-top-space: 29pt,
          leading: 8pt,
          spacing: 0pt,
          caption-style: it => it,
          figure-above: 12pt,
          figure-below: 12pt,
          figure-gap: 6pt,

          text-args: (
            font: fonts.宋体,
            size: 字号.小四,
            top-edge: 0.75em,
            bottom-edge: -0.25em,
            cjk-latin-spacing: none,
          ),
        ) + named + (fonts: fonts + named.at("fonts", default: (:)))
        mainmatter(..args.pos(), ..opts)
      } else {
        mainmatter(
          twoside: twoside,
          ..args,
          fonts: fonts + args.named().at("fonts", default: (:)),
        )
      }
    },
    appendix: (..args) => {
      let named = args.named()
      if doctype == "master" or doctype == "doctor" {
        // 附录按「附录 A、附录 B……」编号
        let opts = (
          numbering: custom-numbering.with(first-level: "附录A", depth: 4, "1.1 "),
          reset-counter: true,
        ) + named
        appendix(..args.pos(), ..opts)
      } else {
        appendix(..args)
      }
    },

    // 字体展示页
    fonts-display-page: (..args) => {
      fonts-display-page(
        twoside: twoside,
        ..args,
        fonts: fonts + args.named().at("fonts", default: (:)),
      )
    },

    // 封面页，通过 type 分发到不同函数
    cover: (..args) => {
      if doctype == "master" or doctype == "doctor" {
        master-cover(
          doctype: doctype,
          degree: degree,
          nl-cover: nl-cover,
          anonymous: anonymous,
          twoside: twoside,
          ..args,
          fonts: fonts + args.named().at("fonts", default: (:)),
          info: info + args.named().at("info", default: (:)),
        )
      } else if doctype == "postdoc" {
        panic("postdoc has not yet been implemented.")
      } else {
        bachelor-cover(
          anonymous: anonymous,
          twoside: twoside,
          ..args,
          fonts: fonts + args.named().at("fonts", default: (:)),
          info: info + args.named().at("info", default: (:)),
        )
      }
    },

    // 声明页，通过 type 分发到不同函数
    decl-page: (..args) => {
      if doctype == "master" or doctype == "doctor" {
        master-decl-page(
          anonymous: anonymous,
          twoside: twoside,
          ..args,
          fonts: fonts + args.named().at("fonts", default: (:)),
        )
      } else if doctype == "postdoc" {
        panic("postdoc has not yet been implemented.")
      } else {
        bachelor-decl-page(
          anonymous: anonymous,
          twoside: twoside,
          ..args,
          fonts: fonts + args.named().at("fonts", default: (:)),
          info: info + args.named().at("info", default: (:)),
        )
      }
    },

    // 版权页
    copyright: (..args) => {
      if doctype == "bachelor" {
        bachelor-copyright(
          anonymous: anonymous,
          twoside: twoside,
          ..args,
          fonts: fonts + args.named().at("fonts", default: (:)),
        )
      }
    },

    // 评阅/成绩页
    evaluation-page: (..args) => {
      if doctype == "bachelor" {
        bachelor-evaluation-page(
          anonymous: anonymous,
          twoside: twoside,
          ..args,
          fonts: fonts + args.named().at("fonts", default: (:)),
          info: info + args.named().at("info", default: (:)),
        )
      }
    },
    
    task-page: (..args) => {
      if doctype == "bachelor" {
        bachelor-task-page(
          anonymous: anonymous,
          twoside: twoside,
          ..args,
          fonts: fonts + args.named().at("fonts", default: (:)),
          info: info + args.named().at("info", default: (:)),
        )
      }
    },

    // 中文摘要页，通过 type 分发到不同函数
    abstract: (..args) => {
      if doctype == "master" or doctype == "doctor" {
        master-abstract(
          doctype: doctype,
          degree: degree,
          anonymous: anonymous,
          twoside: twoside,
          ..args,
          fonts: fonts + args.named().at("fonts", default: (:)),
          info: info + args.named().at("info", default: (:)),
        )
      } else if doctype == "postdoc" {
        panic("postdoc has not yet been implemented.")
      } else {
        bachelor-abstract(
          anonymous: anonymous,
          twoside: twoside,
          ..args,
          fonts: fonts + args.named().at("fonts", default: (:)),
          info: info + args.named().at("info", default: (:)),
        )
      }
    },

    // 英文摘要页，通过 type 分发到不同函数
    abstract-en: (..args) => {
      if doctype == "master" or doctype == "doctor" {
        master-abstract-en(
          doctype: doctype,
          degree: degree,
          anonymous: anonymous,
          twoside: twoside,
          ..args,
          fonts: fonts + args.named().at("fonts", default: (:)),
          info: info + args.named().at("info", default: (:)),
        )
      } else if doctype == "postdoc" {
        panic("postdoc has not yet been implemented.")
      } else {
        bachelor-abstract-en(
          anonymous: anonymous,
          twoside: twoside,
          ..args,
          fonts: fonts + args.named().at("fonts", default: (:)),
          info: info + args.named().at("info", default: (:)),
        )
      }
    },

    // 目录页
    outline-page: (..args) => {
      if doctype == "master" or doctype == "doctor" {
        master-outline-page(
          twoside: twoside,
          ..args,
          fonts: fonts + args.named().at("fonts", default: (:)),
        )
      } else {
        bachelor-outline-page(
          twoside: twoside,
          ..args,
          fonts: fonts + args.named().at("fonts", default: (:)),
        )
      }
    },

    // 插图目录页
    list-of-figures: (..args) => {
      let named = args.named()
      if doctype == "master" or doctype == "doctor" {
        let opts = (
          twoside: twoside,
          title: "图目录",
          header-title: "图目录",
          title-vspace: 25.17pt,
          title-text-args: (font: fonts.黑体, size: 字号.小三),
        ) + named
        list-of-figures(..args.pos(), ..opts, fonts: fonts + named.at("fonts", default: (:)))
      } else {
        list-of-figures(
          twoside: twoside,
          ..args,
          fonts: fonts + args.named().at("fonts", default: (:)),
        )
      }
    },

    // 表格目录页
    list-of-tables: (..args) => {
      let named = args.named()
      if doctype == "master" or doctype == "doctor" {
        let opts = (
          twoside: twoside,
          title: "表目录",
          header-title: "表目录",
          title-vspace: 25.17pt,
          title-text-args: (font: fonts.黑体, size: 字号.小三),
        ) + named
        list-of-tables(..args.pos(), ..opts, fonts: fonts + named.at("fonts", default: (:)))
      } else {
        list-of-tables(
          twoside: twoside,
          ..args,
          fonts: fonts + args.named().at("fonts", default: (:)),
        )
      }
    },

    // 符号表页
    notation: (..args) => {
      if doctype == "master" or doctype == "doctor" {
        master-notation(
          twoside: twoside,
          ..args,
          fonts: fonts + args.named().at("fonts", default: (:)),
        )
      } else {
        notation(
          twoside: twoside,
          ..args,
        )
      }
    },

    // 参考文献页
    bilingual-bibliography: (..args) => {
      if doctype == "master" or doctype == "doctor" {
        // 参考文献：五号字，悬挂缩进，两端对齐，固定行距 20 磅
        show bibliography-element: set text(font: fonts.宋体, size: 字号.五号, top-edge: 0.75em, bottom-edge: -0.25em)
        show bibliography-element: set par(
          hanging-indent: 2.5em,
          leading: 4.4pt,
          spacing: 0pt,
          justify: true,
          first-line-indent: 0pt,
        )
        bilingual-bibliography(
          bibliography: bibliography,
          ..args,
        )
      } else {
        bilingual-bibliography(
          bibliography: bibliography,
          ..args,
        )
      }
    },

    // 致谢页
    acknowledgement: (..args) => {
      acknowledgement(
        anonymous: anonymous,
        twoside: twoside,
        ..args,
      )
    },

    // 攻读学位期间取得的研究成果页
    achievements: (..args) => {
      let named = args.named()
      let opts = (
        twoside: twoside,
        body-size: if doctype == "master" or doctype == "doctor" { 字号.五号 } else { auto },
      ) + named + (fonts: fonts + named.at("fonts", default: (:)))
      achievements(..args.pos(), ..opts)
    },
  )
}












