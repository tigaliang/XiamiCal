// Created by Tiga Liang on 2022/6/30.
// Copyright © 2022 Airbnb Inc. All rights reserved.

import SwiftUI

extension DateComponents {
  func isSameDay(_ otherDate: Date) -> Bool {
    let other = Calendar.current.dateComponents([.year, .month, .day], from: otherDate)
    return self.year == other.year && self.month == other.month && self.day == other.day
  }

  func isSameMonth(_ otherDate: Date) -> Bool {
    let other = Calendar.current.dateComponents([.year, .month], from: otherDate)
    return self.year == other.year && self.month == other.month
  }
}

struct CalendarView: View {
  private let lunarMonths = [
    "一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"
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

  private func constellationForDate(month: Int, day: Int) -> String {
    let mmdd = month * 100 + day;
    var result = ""

    if ((mmdd >= 321 && mmdd <= 331) ||
        (mmdd >= 401 && mmdd <= 419)) {
      result = "白羊座"
    } else if ((mmdd >= 420 && mmdd <= 430) ||
               (mmdd >= 501 && mmdd <= 520)) {
      result = "金牛座"
    } else if ((mmdd >= 521 && mmdd <= 531) ||
               (mmdd >= 601 && mmdd <= 621)) {
      result = "双子座"
    } else if ((mmdd >= 622 && mmdd <= 630) ||
               (mmdd >= 701 && mmdd <= 722)) {
      result = "巨蟹座"
    } else if ((mmdd >= 723 && mmdd <= 731) ||
               (mmdd >= 801 && mmdd <= 822)) {
      result = "狮子座"
    } else if ((mmdd >= 823 && mmdd <= 831) ||
               (mmdd >= 901 && mmdd <= 922)) {
      result = "处女座"
    } else if ((mmdd >= 923 && mmdd <= 930) ||
               (mmdd >= 1001 && mmdd <= 1023)) {
      result = "天秤座"
    } else if ((mmdd >= 1024 && mmdd <= 1031) ||
               (mmdd >= 1101 && mmdd <= 1122)) {
      result = "天蝎座"
    } else if ((mmdd >= 1123 && mmdd <= 1130) ||
               (mmdd >= 1201 && mmdd <= 1221)) {
      result = "射手座"
    } else if ((mmdd >= 1222 && mmdd <= 1231) ||
               (mmdd >= 101 && mmdd <= 119)) {
      result = "摩羯座"
    } else if ((mmdd >= 120 && mmdd <= 131) ||
               (mmdd >= 201 && mmdd <= 218)) {
      result = "水瓶座"
    } else if ((mmdd >= 219 && mmdd <= 229) ||
               (mmdd >= 301 && mmdd <= 320)) {
      result = "双鱼座"
    }
    return result
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
          repeating: GridItem(.fixed(40), alignment: Alignment.center),
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

            let lunarText = lunarDay == 1 ? lunarMonths[lunarMonth - 1] : lunarDays[lunarDay - 1]
            Text(lunarText)
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
