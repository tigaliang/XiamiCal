// Created by Tiga Liang on 2022/6/27.
// Copyright © 2022 Airbnb Inc. All rights reserved.

import SwiftUI

class ContentViewState: ObservableObject {
  @Published var calculatorShowing = false
  @Published var today = Date()
  @Published var displayDate = Date()
  @Published var selectedDate = Date()
}

struct ContentView: View {
  private let calendar = Calendar.current

  @ObservedObject var state: ContentViewState

  func initState() {
    state.calculatorShowing = false
    state.today = Date()
    state.displayDate = Date()
    state.selectedDate = Date()
  }

  var body: some View {
    let displayComps = calendar.dateComponents([.year, .month], from: state.displayDate)

    VStack {
      ZStack(alignment: Alignment.center) {
        let displayYear = displayComps.year ?? 2022

        ZodiacEmoji(displayYear: displayYear)

        VStack {
          TianganDizhi(displayYear: displayYear)

          CalendarHeader(
            displayDate: state.displayDate,
            today: state.today,
            onBackToToday: { state.displayDate = state.today },
            onYearAdded: { v in
              state.displayDate = calendar.date(byAdding: .year, value: v, to: state.displayDate) ?? state.displayDate
            },
            onMonthAdded: { v in
              state.displayDate = calendar.date(byAdding: .month, value: v, to: state.displayDate) ?? state.displayDate
            }
          ).padding(Edge.Set.bottom, 10)

          CalendarView(
            today: state.today,
            selectedDate: state.selectedDate,
            displayDate: state.displayDate
          ) { date in
            state.selectedDate = date
          }
        }
      }
      
      Divider()

      HStack {
        Label("Date calculator", systemImage: "wand.and.stars")
          .labelStyle(.iconOnly)
          .help("日期计算器")
          .onTapGesture {
            state.calculatorShowing.toggle()
          }

        Menu {
          Button("退出") {
            exit(0)
          }
        } label: {
          Label("Settings", systemImage: "gear")
            .labelStyle(.iconOnly)
        }
        .frame(width: 20)
        .menuStyle(.borderlessButton)
        .menuIndicator(.hidden)

      }.padding(Edge.Set.bottom, 10)
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(.trailing, 10)
        .padding(.top, 3)

      if state.calculatorShowing {
        DateCalculator(startDate: state.selectedDate)
      }
    }.padding(Edge.Set.top, state.calculatorShowing ? 35 : 19)
      .padding(Edge.Set.bottom, state.calculatorShowing ? 35 : 10)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView(state: .init())
  }
}
