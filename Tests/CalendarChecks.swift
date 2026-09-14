import Foundation

@main
struct CalendarChecks {
  static var checks = 0

  static func expect(_ condition: @autoclosure () -> Bool, _ message: String) {
    checks += 1
    precondition(condition(), message)
  }

  static func date(_ year: Int, _ month: Int, _ day: Int, calendar: Calendar = CalendarData.calendar) -> Date {
    calendar.date(from: DateComponents(year: year, month: month, day: day, hour: 12))!
  }

  static func main() {
    // Validate every layout over a full Gregorian leap-year cycle, including DST.
    for zone in ["Asia/Shanghai", "America/Los_Angeles"] {
      var calendar = Calendar(identifier: .gregorian)
      calendar.timeZone = TimeZone(identifier: zone)!
      for year in 2000..<2400 {
        for month in 1...12 {
          let anchor = date(year, month, 15, calendar: calendar)
          let days = CalendarData.days(in: anchor, calendar: calendar)
          expect(days.count == 42 && Set(days).count == 42, "Grid must contain 42 distinct dates")
          expect(calendar.component(.weekday, from: days[0]) == 1, "Weeks must start on Sunday")
          let monthDays = days.filter { calendar.isDate($0, equalTo: anchor, toGranularity: .month) }
          expect(monthDays.count == calendar.range(of: .day, in: .month, for: anchor)!.count, "Grid omits month dates")
          for pair in zip(days, days.dropFirst()) {
            expect(calendar.dateComponents([.day], from: pair.0, to: pair.1).day == 1, "Grid skips a day around DST")
          }
        }
      }
    }

    let january = date(2026, 1, 31)
    let february = CalendarData.movingMonth(1, from: january)
    let march = CalendarData.movingMonth(1, from: february)
    expect(CalendarDay(date: february).month == 2, "January navigation skips February")
    expect(CalendarDay(date: march).day == 1 && CalendarDay(date: march).month == 3, "Month navigation drifts at month end")
    expect(CalendarDay(date: CalendarData.movingMonth(-1, from: date(2026, 1, 1))).year == 2025, "Previous-year boundary")

    let newYear = CalendarDay(date: date(2026, 2, 17))
    expect(newYear.lunarText == "正月初一" && newYear.lunarYearText == "丙午马年", "Chinese New Year conversion")
    expect(CalendarDay(date: date(2026, 2, 16)).lunarYearText == "乙巳蛇年", "Lunar year must change at Spring Festival")
    expect(CalendarDay(date: date(2025, 7, 25)).lunarMonthText == "闰六月", "Leap lunar month prefix")
    expect(CalendarDay(date: date(2026, 9, 25)).holiday == "中秋节", "Mid-Autumn label")
    expect(CalendarDay(date: date(2026, 9, 20)).workStatus == "调休上班", "Sunday makeup workday")
    expect(!CalendarDay(date: date(2026, 9, 20)).isRestDay, "Makeup work overrides weekend")
    expect(CalendarDay(date: date(2026, 10, 1)).isRestDay, "Weekday public holiday overrides workday")

    let state = ContentViewState(now: date(2026, 9, 14))
    state.select(date(2026, 10, 1))
    expect(CalendarDay(date: state.displayDate).month == 10, "Selecting a trailing day must open its month")
    expect(CalendarDay(date: state.selectedDate).day == 1, "Selected date must match detail card")
    state.returnToToday(now: date(2026, 9, 14))
    expect(state.selectedDate == state.today && state.displayDate == state.today, "Today resets selection and month")
    state.refreshToday(now: date(2026, 9, 15))
    expect(state.selectedDate == state.today, "Today selection follows midnight")
    state.select(date(2026, 10, 1))
    state.refreshToday(now: date(2026, 9, 16))
    expect(CalendarDay(date: state.selectedDate).month == 10, "Midnight must preserve an explicit selection")
    state.moveMonth(-1)
    expect(CalendarDay(date: state.displayDate).month == 9, "Month navigation from selected date")
    print("Passed \(checks) checks: calendar grids, DST, leap months, holidays, navigation, selection and midnight refresh.")
  }
}
