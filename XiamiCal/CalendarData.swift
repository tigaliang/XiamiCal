import Foundation

/// Use a Gregorian grid even when the system's preferred calendar is different.
enum CalendarData {
  static var calendar: Calendar {
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = .current
    return calendar
  }

  static func days(in month: Date, calendar: Calendar = calendar) -> [Date] {
    guard let start = calendar.dateInterval(of: .month, for: month)?.start,
          let gridStart = calendar.date(byAdding: .day, value: 1 - calendar.component(.weekday, from: start), to: start)
    else { return [] }
    // Six complete weeks keep the popover stable while browsing months.
    return (0..<42).compactMap { calendar.date(byAdding: .day, value: $0, to: gridStart) }
  }

  static func movingMonth(_ offset: Int, from date: Date, calendar: Calendar = calendar) -> Date {
    let start = calendar.dateInterval(of: .month, for: date)?.start ?? date
    return calendar.date(byAdding: .month, value: offset, to: start) ?? start
  }
}

struct CalendarDay: Identifiable {
  let date: Date
  let year: Int
  let month: Int
  let day: Int
  let weekday: Int
  let lunarMonth: Int
  let lunarDay: Int
  let isLeapMonth: Bool
  let lunarYear: Int

  var id: Date { date }
  var holiday: String? {
    CalendarFestival.name(year: year, month: month, day: day, lunarMonth: lunarMonth,
                          lunarDay: lunarDay, isLeapMonth: isLeapMonth)
  }
  var hasHolidaySchedule: Bool { HolidayScheduleSource.forYear(year) != nil }
  var dayOff: String? { getDayOffText(year: year, month: month, day: day) }
  var isWeekend: Bool { weekday == 1 || weekday == 7 }
  var isRestDay: Bool { dayOff == "休" || (dayOff != "班" && isWeekend) }
  var weekdayText: String { ["星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"][weekday - 1] }
  var dateText: String { "\(month)月\(day)日 · \(weekdayText)" }
  var menuBarText: String { "\(day) 周" + ["日", "一", "二", "三", "四", "五", "六"][weekday - 1] }
  var workStatus: String {
    guard hasHolidaySchedule else { return "调休安排未收录" }
    if dayOff == "班" { return "调休上班" }
    if dayOff == "休" { return "放假" }
    return isWeekend ? "周末" : "工作日"
  }

  private static let lunarMonths = ["正月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"]
  private static let lunarDays = ["初一", "初二", "初三", "初四", "初五", "初六", "初七", "初八", "初九", "初十", "十一", "十二", "十三", "十四", "十五", "十六", "十七", "十八", "十九", "二十", "廿一", "廿二", "廿三", "廿四", "廿五", "廿六", "廿七", "廿八", "廿九", "三十"]

  var lunarMonthText: String { (isLeapMonth ? "闰" : "") + Self.lunarMonths[lunarMonth - 1] }
  var lunarDayText: String { Self.lunarDays[lunarDay - 1] }
  var lunarText: String { lunarMonthText + lunarDayText }
  var subtitle: String { holiday?.replacingOccurrences(of: "\n", with: "·") ?? (lunarDay == 1 ? lunarMonthText : lunarDayText) }
  var lunarYearText: String {
    let stems = Array("甲乙丙丁戊己庚辛壬癸")
    let branches = Array("子丑寅卯辰巳午未申酉戌亥")
    let animals = Array("鼠牛虎兔龙蛇马羊猴鸡狗猪")
    return "\(stems[(lunarYear - 1) % 10])\(branches[(lunarYear - 1) % 12])\(animals[(lunarYear - 1) % 12])年"
  }
  var accessibilityText: String {
    ["\(year)年\(month)月\(day)日", weekdayText, "农历" + lunarText, holiday, workStatus]
      .compactMap { $0 }.joined(separator: "，")
  }

  init(date: Date, calendar: Calendar = CalendarData.calendar) {
    self.date = date
    let solar = calendar.dateComponents([.year, .month, .day, .weekday], from: date)
    year = solar.year!
    month = solar.month!
    day = solar.day!
    weekday = solar.weekday!
    var lunar = Calendar(identifier: .chinese)
    lunar.timeZone = calendar.timeZone
    let components = lunar.dateComponents([.year, .month, .day], from: date)
    lunarMonth = components.month!
    lunarDay = components.day!
    lunarYear = components.year!
    isLeapMonth = components.isLeapMonth ?? false
  }
}
