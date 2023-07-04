// Created by Tiga Liang on 2022/6/27.
// Copyright © 2022 Airbnb Inc. All rights reserved.

import SwiftUI

class ContentViewState: ObservableObject {
  @Published var today = Date()
  @Published var displayDate = Date()
  @Published var selectedDate = Date()
}

struct ContentView: View {
  private let calendar = Calendar.current

  @ObservedObject var state: ContentViewState

  func initState() {
    state.today = Date()
    state.displayDate = Date()
    state.selectedDate = Date()
  }

  var body: some View {
    let displayComps = calendar.dateComponents([.year, .month], from: state.displayDate)

    VStack {
      ZStack(alignment: Alignment.center) {
        let displayYear = displayComps.year ?? 2022

        ZodiacEmoji(displayYear: displayYear).frame(width: 200, height: 200)

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
    }.padding(Edge.Set.top, 20)
      .padding(Edge.Set.bottom, 10)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView(state: .init())
  }
}
