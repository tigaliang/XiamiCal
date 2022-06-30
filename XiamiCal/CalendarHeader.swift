// Created by Tiga Liang on 2022/6/30.
// Copyright © 2022 Airbnb Inc. All rights reserved.

import SwiftUI

struct CalendarHeader: View {
  // private let displayDate: Date!
  private let today: Date!
  private let onBackToToday: (() -> Void)!
  private let onYearAdded: ((Int) -> Void)!
  private let onMonthAdded: ((Int) -> Void)!
  private let displayComps: DateComponents!
  private let currentComps: DateComponents!

  init(
    displayDate: Date,
    today: Date,
    onBackToToday:@escaping () -> Void,
    onYearAdded:@escaping (Int) -> Void,
    onMonthAdded:@escaping (Int) -> Void
  ) {
    // self.displayDate = displayDate
    self.today = today
    self.onBackToToday = onBackToToday
    self.onYearAdded = onYearAdded
    self.onMonthAdded = onMonthAdded

    let calendar = Calendar.current
    displayComps = calendar.dateComponents([.year, .month], from: displayDate)
    currentComps = calendar.dateComponents([.year, .month], from: today)
  }

  var body: some View {
    ZStack {
      HStack {
        Button(action: {
          onBackToToday()
        }) {
          Image(systemName: "gobackward")
        }.padding(Edge.Set.trailing, 15)
          .help("回到今天")
          .buttonStyle(PlainButtonStyle())
      }.frame(maxWidth: .infinity, alignment: Alignment.trailing)
        .opacity(displayComps.year != currentComps.year
                 || displayComps.month != currentComps.month ? 0.6 : 0)

      HStack {
        Button(action: {
          onYearAdded(-1)
        }) {
          Image(systemName: "chevron.left.2")
        }.buttonStyle(PlainButtonStyle())
          .padding(Edge.Set.trailing, 10)

        Button(action: {
          onMonthAdded(-1)
        }) {
          Image(systemName: "chevron.left")
        }.buttonStyle(PlainButtonStyle())

        Text("\(displayComps.year ?? 2022) 年 \(displayComps.month ?? 6) 月".replacingOccurrences(of: ",", with: ""))
          .font(Font.title3)
          .bold()

        Button(action: {
          onMonthAdded(1)
        }) {
          Image(systemName: "chevron.right")
        }.buttonStyle(PlainButtonStyle())

        Button(action: {
          onYearAdded(1)
        }) {
          Image(systemName: "chevron.right.2")
        }.buttonStyle(PlainButtonStyle())
          .padding(Edge.Set.leading, 10)
      }
    }
  }
}

struct CalendarHeader_Previews: PreviewProvider {
  static var previews: some View {
    CalendarHeader(displayDate: Date(), today: Date(), onBackToToday: {}, onYearAdded: {_ in}, onMonthAdded: {_ in})
  }
}
