// Created by Tiga Liang on 2022/6/27.
// Copyright © 2022 Airbnb Inc. All rights reserved.

import SwiftUI

struct ContentView: View {
  private let calendar = Calendar.current

  @State private var calculatorShowing = false
  @State private var displayDate = Date()
  @State private var selectedDate = Date()

  var body: some View {
    let today = Date()

    let displayComps = calendar.dateComponents([.year, .month], from: displayDate)

    VStack {
      ZStack(alignment: Alignment.center) {
        let displayYear = displayComps.year ?? 2022

        ZodiacEmoji(displayYear: displayYear)

        VStack {
          TianganDizhi(displayYear: displayYear)

          CalendarHeader(
            displayDate: displayDate,
            today: today,
            onBackToToday: { displayDate = today },
            onYearAdded: { v in
              displayDate = calendar.date(byAdding: .year, value: v, to: displayDate) ?? displayDate
            },
            onMonthAdded: { v in
              displayDate = calendar.date(byAdding: .month, value: v, to: displayDate) ?? displayDate
            }
          ).padding(Edge.Set.bottom, 10)

          CalendarView(
            today: today,
            selectedDate: selectedDate,
            displayDate: displayDate
          ) { date in
            selectedDate = date
          }
        }
      }

      Divider()

      HStack{
        Label("日期计算", systemImage: "calendar.badge.plus")
          .labelStyle(.titleAndIcon)

        if calculatorShowing {
          Image(systemName: "chevron.up")
        } else {
          Image(systemName: "chevron.down")
        }
      }.padding(Edge.Set.bottom, 10)
        .onTapGesture {
          calculatorShowing.toggle()
        }

      if calculatorShowing {
        DateCalculator()
      }
    }.padding(Edge.Set.top, calculatorShowing ? 35 : 19)
      .padding(Edge.Set.bottom, calculatorShowing ? 35 : 10)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
