#import "../utils/style.typ": 字号, 字体

// ============================================================
// 硕士研究生学位论文的页面基础设置
// 依据《西南交通大学研究生学位论文撰写范式》（2024-07 版）
//   - A4 纸，上、下、左、右边距均为 3.0 cm，页眉、页脚距边界 2.0 cm
//   - 页眉：五号宋体居中，单横线 0.75 磅
//   - 页码：小五号 Times New Roman 居中，数字两侧不加修饰线
//   - 从中文摘要开始行距固定值 20 磅
// ============================================================

// 页眉：小五号宋体居中，下方 0.8 磅单横线（与 Word 原版一致）
#let master-header(
  title,
  fonts: (:),
  stroke-width: 0.8pt,
  gap: 0.25em,
) = {
  fonts = 字体 + fonts
  set align(center)
  stack(
    text(font: fonts.宋体, size: 字号.小五, title),
    v(gap),
    line(length: 100%, stroke: stroke-width + black),
  )
}

// 页脚：小五号 Times New Roman 居中，仅显示页码
#let master-footer(numbering: "1", fonts: (:)) = context {
  let fonts = 字体 + fonts
  align(center, text(font: fonts.宋体, size: 字号.小五, counter(page).display(numbering)))
}

// 分页到下一部分。
// 说明：PDF 中不插入空白背页，空白背页由双面打印时自然产生；
// 这样页码可以保持连续，也不会因为修改页码计数器而导致版面无法收敛。
#let master-pagebreak(twoside: false) = {
  pagebreak(weak: true)
}

// 前置部分：页码使用大写罗马数字，页眉由各页自行设置
#let master-preface(
  // documentclass 传入的参数
  twoside: false,
  fonts: (:),
  ..args,
  it,
) = {
  // 0.  默认参数
  fonts = 字体 + fonts

  // 1.  分页到前置部分第一页（双面模式下从奇数页开始）
  master-pagebreak(twoside: twoside)

  // 2.  将当前页设为第 I 页
  counter(page).update(1)

  // 3.  设置页脚为罗马数字页码
  set page(
    numbering: none,
    header: none,
    footer: master-footer(numbering: "I", fonts: fonts),
    margin: 3cm,
  )
  it
}
