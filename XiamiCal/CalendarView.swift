// Created by Tiga Liang on 2022/6/30.
// Copyright © 2022 Airbnb Inc. All rights reserved.

import SwiftUI

struct CalendarView: View {
  let today: Date
  let selectedDate: Date
  let displayDate: Date
  let onDaySelected: (Date) -> Void

  @FocusState private var hasKeyboardFocus: Bool
  private let columns = Array(repeating: GridItem(.flexible(), spacing: 3), count: 7)

  var body: some View {
    VStack(spacing: 10) {
      HStack(spacing: 3) {
        ForEach(Array(["日", "一", "二", "三", "四", "五", "六"].enumerated()), id: \.offset) { index, label in
          Text(label)
            .font(.system(size: 10, weight: .medium))
            .foregroundStyle(index == 0 || index == 6 ? CalendarStyle.rest : .secondary)
            .frame(maxWidth: .infinity)
        }
      }
      .accessibilityHidden(true)

      LazyVGrid(columns: columns, spacing: 4) {
        ForEach(CalendarData.days(in: displayDate), id: \.self) { date in
          CalendarDayButton(
            item: CalendarDay(date: date),
            isToday: CalendarData.calendar.isDate(date, inSameDayAs: today),
            isSelected: CalendarData.calendar.isDate(date, inSameDayAs: selectedDate),
            hasKeyboardFocus: hasKeyboardFocus,
            isDisplayedMonth: CalendarData.calendar.isDate(date, equalTo: displayDate, toGranularity: .month)
          ) {
            onDaySelected(date)
            hasKeyboardFocus = true
          }
        }
      }
    }
    .focusable()
    .focused($hasKeyboardFocus)
    .calendarFocusAppearance()
    .onMoveCommand { direction in
      let offset: Int
      switch direction {
      case .left: offset = -1
      case .right: offset = 1
      case .up: offset = -7
      case .down: offset = 7
      default: return
      }
      if let date = CalendarData.calendar.date(byAdding: .day, value: offset, to: selectedDate) {
        onDaySelected(date)
      }
    }
  }
}

private struct CalendarDayButton: View {
  let item: CalendarDay
  let isToday: Bool
  let isSelected: Bool
  let hasKeyboardFocus: Bool
  let isDisplayedMonth: Bool
  let action: () -> Void

  @Environment(\.accessibilityReduceMotion) private var reduceMotion
  @Environment(\.colorSchemeContrast) private var contrast
  @State private var isHovered = false

  private var emphasis: Color { item.isRestDay ? CalendarStyle.rest : CalendarStyle.accent }

  var body: some View {
    Button(action: action) {
      VStack(spacing: 4) {
        Text("\(item.day)")
          .font(.system(size: 15, weight: isToday || isSelected ? .bold : .medium, design: .rounded))
          .foregroundStyle(isToday ? CalendarStyle.accent : .primary)
          .overlay(alignment: .topTrailing) {
            if let dayOff = item.dayOff {
              Text(dayOff)
                .font(.system(size: 7, weight: .bold))
                .foregroundStyle(dayOff == "休" ? CalendarStyle.rest : CalendarStyle.accent)
                .offset(x: 10, y: -3)
            }
          }
        Text(item.subtitle)
          .font(.system(size: 9, weight: item.holiday == nil ? .regular : .medium))
          .lineLimit(1)
          .minimumScaleFactor(0.7)
          .foregroundStyle(item.holiday == nil ? Color.secondary : emphasis)
      }
      .frame(maxWidth: .infinity)
      .frame(height: 46)
      .background {
        RoundedRectangle(cornerRadius: 13, style: .continuous)
          .fill(isSelected ? CalendarStyle.accent.opacity(0.15) : (isHovered ? Color.primary.opacity(0.06) : .clear))
      }
      .overlay {
        RoundedRectangle(cornerRadius: 13, style: .continuous)
          .strokeBorder(isSelected ? CalendarStyle.accent.opacity(contrast == .increased || hasKeyboardFocus ? 1 : 0.4) : .clear, lineWidth: hasKeyboardFocus ? 1.5 : 1)
      }
      .overlay(alignment: .bottom) {
        if isToday {
          Circle().fill(CalendarStyle.accent).frame(width: 3, height: 3).offset(y: -2)
        }
      }
      .opacity(isDisplayedMonth ? 1 : (contrast == .increased ? 0.7 : 0.4))
      .contentShape(RoundedRectangle(cornerRadius: 13))
    }
    .buttonStyle(CalendarControlStyle())
    .onHover { isHovered = $0 }
    .animation(reduceMotion ? nil : .easeOut(duration: 0.14), value: isHovered)
    .accessibilityLabel(item.accessibilityText + (isToday ? "，今天" : ""))
    .accessibilityAddTraits(.isButton)
    .accessibilityAddTraits(isSelected ? .isSelected : [])
    .accessibilityIdentifier("day-\(item.year)-\(item.month)-\(item.day)")
    .help(item.accessibilityText)
  }
}
