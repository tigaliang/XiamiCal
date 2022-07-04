// Created by Tiga Liang on 2022/6/30.
// Copyright © 2022 Airbnb Inc. All rights reserved.

import SwiftUI

struct CalendarView: View {
  private let lunarMonths = [
    "正月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"
  ]
  private let lunarDays = [
    "初一", "初二", "初三", "初四", "初五", "初六",
    "初七", "初八", "初九", "初十", "十一", "十二",
    "十三", "十四", "十五", "十六", " 十七", "十八",
    "十九", "二十", "廿一", "廿二", "廿三", "廿四",
    "廿五", "廿六", "廿七", "廿八", "廿九", "三十"
  ]

  let today: Date!
  let selectedDate: Date!
  let displayDate: Date!
  let onDaySelected: ((Date) -> Void)!

  private func displayDateComponents() -> [DateComponents] {
    let calendar = Calendar.current
    let displayComps = calendar.dateComponents([.year, .month], from: displayDate)
    let range = calendar.range(of: .day, in: .month, for: displayDate)!

    var dateComps = [DateComponents]()
    let firstDayOfMonth = calendar.date(
      from: DateComponents(
        year: displayComps.year,
        month: displayComps.month,
        day: 1
      )
    )!
    let lastDayOfMonth = calendar.date(
      from: DateComponents(
        year: displayComps.year,
        month: displayComps.month,
        day: range.count
      )
    )!

    for dayOffset in (0..<range.count) {
      let date = calendar.date(byAdding: .day, value: dayOffset, to: firstDayOfMonth)!
      dateComps.append(calendar.dateComponents([.year, .month, .day, .weekday], from: date))
    }

    let daysToInsert = (dateComps.first?.weekday ?? 1) - 1
    if daysToInsert > 0 {
      for dayOffset in (1...daysToInsert) {
        let date = calendar.date(byAdding: .day, value: dayOffset * -1, to: firstDayOfMonth)!
        dateComps.insert(calendar.dateComponents([.year, .month, .day, .weekday], from: date), at: 0)
      }
    }

    let daysToAppend = 7 - (dateComps.last?.weekday ?? 7)
    if daysToAppend > 0 {
      for dayOffset in (1...daysToAppend) {
        let date = calendar.date(byAdding: .day, value: dayOffset, to: lastDayOfMonth)!
        dateComps.append(calendar.dateComponents([.year, .month, .day, .weekday], from: date))
      }
    }

    return dateComps
  }

  private func lunarDateComponent(solarDateComp: DateComponents) -> DateComponents {
    let calendar = Calendar.init(identifier: .chinese)
    return calendar.dateComponents([.year, .month, .day], from: Calendar.current.date(from: solarDateComp) ?? Date())
  }

  private func gridHelpText(month: Int, day: Int, lunarMonth: Int, lunarDay: Int) -> String {
    let solar = "阳历：\(month)月\(day)日"
    let constellation = "星座：\(constellationForDate(month: month, day: day))"
    let lunar = "农历：\(lunarMonths[lunarMonth - 1])\(lunarDays[lunarDay - 1])"

    return "\(solar)\n\(constellation)\n\(lunar)"
  }

  var body: some View {
    VStack {
      HStack{
        ForEach(["日", "一", "二", "三", "四", "五", "六"], id: \.self) { day in
          Text(day).font(Font.body)
            .bold()
            .frame(width: 40, alignment: .center)
        }
      }

      LazyVGrid(
        columns: [GridItem](
          repeating: GridItem(.fixed(44), alignment: Alignment.center),
          count: 7
        ),
        spacing: 10
      ) {
        let displayDateComps = displayDateComponents()

        ForEach(displayDateComps, id: \.self) { item in
          let lunarComp = lunarDateComponent(solarDateComp: item)
          let lunarDay = lunarComp.day ?? 1
          let lunarMonth = lunarComp.month ?? 1

          VStack {
            ZStack {
              if item.isSameDay(today) {
                Circle()
                  .frame(width: 25, height: 25, alignment: Alignment.center)
                  .foregroundColor(Color.accentColor)
              } else if item.isSameDay(selectedDate) {
                Circle()
                  .strokeBorder(Color.accentColor)
                  .frame(width: 25, height: 25, alignment: Alignment.center)
                  .foregroundColor(Color.accentColor)
              } else {
                Circle()
                  .frame(width: 25, height: 25, alignment: Alignment.center)
                  .hidden()
              }
              Text("\(item.day!)").font(Font.body)
                .opacity(item.isSameMonth(displayDate) ? 1 : 0.3)
            }

            let holidayText = getHolidayText(year: item.year!, month: item.month!, day: item.day!)
            let lunarText = lunarDay == 1 ? lunarMonths[lunarMonth - 1] : lunarDays[lunarDay - 1]
            let dayOff = getDayOffText(year: item.year!, month: item.month!, day: item.day!)
            let dayOffText = dayOff == nil ? "" : "(\(dayOff ?? ""))"
            Text("\(holidayText ?? lunarText)\(dayOffText)")
              .font(.system(size: 8))
              .foregroundColor(Color.gray)
              .padding(Edge.Set.top, -8)
              .opacity(item.isSameMonth(displayDate) ? 1 : 0.3)
          }.onTapGesture {
            onDaySelected(Calendar.current.date(from: item) ?? today)
          }.help(
            gridHelpText(month: item.month!, day: item.day!, lunarMonth: lunarMonth, lunarDay: lunarDay)
          )
        }
      }
    }
  }
}

struct CalendarView_Previews: PreviewProvider {
  static var previews: some View {
    CalendarView(
      today: Date(),
      selectedDate: Calendar.current.date(from: DateComponents(year: 2022, month: 6, day: 28)),
      displayDate: Date()
    ) { _ in }
  }
}
