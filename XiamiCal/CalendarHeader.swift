// Created by Tiga Liang on 2022/6/30.
// Copyright © 2022 Airbnb Inc. All rights reserved.

import SwiftUI

struct CalendarHeader: View {
  let displayDate: Date
  let onYearAdded: (Int) -> Void
  let onMonthAdded: (Int) -> Void

  private var month: CalendarDay { CalendarDay(date: displayDate) }

  var body: some View {
    HStack(alignment: .center) {
      VStack(alignment: .leading, spacing: 3) {
        Text("\(String(month.year)) 年")
          .font(.system(size: 12, weight: .medium, design: .rounded))
          .foregroundStyle(.secondary)
        Text("\(month.month)月")
          .font(.system(size: 32, weight: .semibold, design: .rounded))
          .tracking(-1)
      }
      .accessibilityElement(children: .ignore)
      .accessibilityLabel("\(String(month.year))年\(month.month)月")
      .accessibilityAddTraits(.isHeader)
      .accessibilityIdentifier("displayed-month")

      Spacer()

      HStack(spacing: 2) {
        navigationButton("上一年", symbol: "chevron.left.2") { onYearAdded(-1) }
          .keyboardShortcut(.leftArrow, modifiers: [.command, .option])
        navigationButton("上个月", symbol: "chevron.left") { onMonthAdded(-1) }
          .keyboardShortcut(.leftArrow, modifiers: .command)
        Rectangle().fill(.primary.opacity(0.1)).frame(width: 1, height: 14).padding(.horizontal, 2)
        navigationButton("下个月", symbol: "chevron.right") { onMonthAdded(1) }
          .keyboardShortcut(.rightArrow, modifiers: .command)
        navigationButton("下一年", symbol: "chevron.right.2") { onYearAdded(1) }
          .keyboardShortcut(.rightArrow, modifiers: [.command, .option])
      }
      .padding(5)
      .calendarGlass(radius: 22, interactive: true)
    }
  }

  private func navigationButton(_ label: String, symbol: String, action: @escaping () -> Void) -> some View {
    Button(action: action) {
      Image(systemName: symbol)
        .font(.system(size: 11, weight: .semibold))
        .frame(width: 27, height: 28)
        .contentShape(Circle())
    }
    .buttonStyle(CalendarControlStyle())
    .accessibilityLabel(label)
    .help(label)
  }
}
