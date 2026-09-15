import Foundation

/// Festival names do not imply a statutory day off. Makeup workdays come from
/// the independently sourced annual schedule in HolidayUtils.
enum CalendarFestival {
  private static let solar = [
    101: "元旦", 308: "妇女节", 312: "植树节", 501: "劳动节",
    504: "青年节", 601: "儿童节", 701: "建党节", 711: "航海日",
    801: "建军节", 910: "教师节", 1001: "国庆节", 1108: "记者节"
  ]
  private static let lunar = [
    101: "春节", 115: "元宵节", 202: "中和节", 505: "端午节",
    707: "七夕节", 715: "中元节", 815: "中秋节", 909: "重阳节"
  ]
  // Qingming is a solar term, not a lunar or fixed Gregorian festival.
  // Verified calendar dates: https://www.hko.gov.hk/en/gts/time/conversion.htm
  private static let qingming = [2022: 5, 2023: 5, 2024: 4, 2025: 4, 2026: 5]

  static func name(year: Int, month: Int, day: Int, lunarMonth: Int,
                   lunarDay: Int, isLeapMonth: Bool) -> String? {
    var names: [String] = []
    if let name = solar[month * 100 + day] { names.append(name) }
    if month == 4, qingming[year] == day { names.append("清明节") }
    if !isLeapMonth, let name = lunar[lunarMonth * 100 + lunarDay] { names.append(name) }
    return names.isEmpty ? nil : names.joined(separator: "\n")
  }
}

struct HolidayScheduleSource {
  let url: URL
  let title: String

  static func forYear(_ year: Int) -> HolidayScheduleSource? {
    let paths = [
      2022: "https://www.gov.cn/zhengce/content/2021-10/25/content_5644835.htm",
      2023: "https://www.gov.cn/zhengce/content/2022-12/08/content_5730844.htm",
      2024: "https://www.gov.cn/zhengce/content/202310/content_6911527.htm",
      2025: "https://www.gov.cn/gongbao/2024/issue_11726/202411/content_6989767.html",
      2026: "https://www.gov.cn/gongbao/2025/issue_12406/202511/content_7048922.html"
    ]
    guard let path = paths[year], let url = URL(string: path) else { return nil }
    return HolidayScheduleSource(url: url, title: "国务院办公厅关于\(year)年部分节假日安排的通知")
  }
}
