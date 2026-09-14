// Created by Tiga Liang on 2022/6/27.
// Copyright © 2022 Airbnb Inc. All rights reserved.

import SwiftUI

class ContentViewState: ObservableObject {
  @Published var today: Date
  @Published var displayDate: Date
  @Published var selectedDate: Date

  init(now: Date = Date()) {
    today = now
    displayDate = now
    selectedDate = now
  }

  func returnToToday(now: Date = Date()) {
    today = now
    displayDate = now
    selectedDate = now
  }

  func select(_ date: Date) {
    selectedDate = date
    if !CalendarData.calendar.isDate(date, equalTo: displayDate, toGranularity: .month) {
      displayDate = date
    }
  }

  func moveMonth(_ offset: Int) {
    displayDate = CalendarData.movingMonth(offset, from: displayDate)
  }

  func refreshToday(now: Date = Date()) {
    guard !CalendarData.calendar.isDate(today, inSameDayAs: now) else { return }
    let wasShowingToday = CalendarData.calendar.isDate(selectedDate, inSameDayAs: today)
      && CalendarData.calendar.isDate(displayDate, equalTo: today, toGranularity: .month)
    today = now
    if wasShowingToday { returnToToday(now: now) }
  }
}

struct ContentView: View {
  @ObservedObject var state: ContentViewState
  @Environment(\.accessibilityReduceMotion) private var reduceMotion

  private var selection: CalendarDay { CalendarDay(date: state.selectedDate) }
  private var isAtToday: Bool {
    CalendarData.calendar.isDate(state.selectedDate, inSameDayAs: state.today)
      && CalendarData.calendar.isDate(state.displayDate, equalTo: state.today, toGranularity: .month)
  }

  var body: some View {
    VStack(spacing: 20) {
      HStack {
        HStack(spacing: 7) {
          Image(systemName: "calendar")
            .font(.system(size: 13, weight: .semibold))
            .foregroundStyle(CalendarStyle.accent)
            .accessibilityHidden(true)
          Text("虾米日历")
            .font(.system(size: 12, weight: .medium))
            .foregroundStyle(.secondary)
        }
        Spacer()
        Button { update { state.returnToToday() } } label: {
          HStack(spacing: 5) {
            Image(systemName: "arrow.uturn.backward").font(.system(size: 9, weight: .semibold))
            Text("今天").font(.system(size: 11, weight: .semibold))
          }
          .padding(.horizontal, 12).frame(height: 28)
          .contentShape(Capsule())
        }
        .buttonStyle(CalendarControlStyle())
        .calendarGlass(radius: 16, interactive: true)
        .disabled(isAtToday)
        .keyboardShortcut("t", modifiers: .command)
        .accessibilityLabel("回到今天")
        .help("回到今天（⌘T）")
      }

      CalendarHeader(
        displayDate: state.displayDate,
        onYearAdded: { offset in update { state.moveMonth(offset * 12) } },
        onMonthAdded: { offset in update { state.moveMonth(offset) } }
      )

      CalendarView(today: state.today, selectedDate: state.selectedDate, displayDate: state.displayDate) { date in
        update { state.select(date) }
      }

      selectionCard

      HStack(spacing: 12) {
        legend("休", label: "放假", color: CalendarStyle.rest)
        legend("班", label: "调休", color: CalendarStyle.accent)
        Spacer()
        Menu {
          Button("回到今天") { state.returnToToday() }
            .keyboardShortcut("t", modifiers: .command)
          Divider()
          Button("退出虾米日历") { NSApp.terminate(nil) }
            .keyboardShortcut("q", modifiers: .command)
        } label: {
          Image(systemName: "ellipsis").font(.system(size: 14, weight: .semibold))
            .frame(width: 28, height: 22)
            .contentShape(Rectangle())
        }
        .menuStyle(.borderlessButton)
        .menuIndicator(.hidden)
        .fixedSize()
        .accessibilityLabel("更多选项")
        .help("更多选项")
      }
      .padding(.top, -6)
      .accessibilityElement(children: .contain)
    }
    .padding(22)
    .frame(width: 384)
    .background(CalendarSurface())
    .accessibilityElement(children: .contain)
    .onReceive(NotificationCenter.default.publisher(for: .NSCalendarDayChanged)) { _ in
      state.refreshToday()
    }
    .onReceive(NotificationCenter.default.publisher(for: NSApplication.didBecomeActiveNotification)) { _ in
      state.refreshToday()
    }
  }

  private var selectionCard: some View {
    HStack(spacing: 13) {
      VStack(spacing: 2) {
        Text("\(selection.month)月").font(.system(size: 9, weight: .semibold))
          .foregroundStyle(CalendarStyle.accent)
        Text("\(selection.day)").font(.system(size: 28, weight: .medium, design: .rounded))
      }
      .frame(width: 52, height: 58)
      .background(CalendarStyle.accent.opacity(0.09), in: RoundedRectangle(cornerRadius: 12))
      .accessibilityHidden(true)

      VStack(alignment: .leading, spacing: 6) {
        HStack(spacing: 6) {
          Text("\(String(selection.year))年\(selection.dateText)")
            .font(.system(size: 11, weight: .semibold))
            .lineLimit(1).minimumScaleFactor(0.85)
          Spacer(minLength: 0)
          if CalendarData.calendar.isDate(state.selectedDate, inSameDayAs: state.today) {
            Text("今天").font(.system(size: 9, weight: .medium))
              .foregroundStyle(CalendarStyle.accent)
          }
        }
        Text("农历\(selection.lunarText) · \(selection.lunarYearText)")
          .font(.system(size: 10)).foregroundStyle(.secondary)
        HStack(spacing: 5) {
          Circle().fill(selection.isRestDay ? CalendarStyle.rest : CalendarStyle.accent).frame(width: 4, height: 4)
          Text([selection.holiday?.replacingOccurrences(of: "\n", with: " · "), selection.workStatus, constellationForDate(month: selection.month, day: selection.day)]
            .compactMap { $0 }.joined(separator: " · "))
            .font(.system(size: 9)).foregroundStyle(.secondary)
            .lineLimit(1).minimumScaleFactor(0.8)
        }
      }
    }
    .padding(13)
    .calendarGlass(radius: 20)
    .accessibilityElement(children: .ignore)
    .accessibilityLabel("所选日期，" + selection.accessibilityText + "，" + selection.lunarYearText + "，" + constellationForDate(month: selection.month, day: selection.day))
    .accessibilityAddTraits(.isStaticText)
    .accessibilityIdentifier("selected-date-details")
  }

  private func legend(_ symbol: String, label: String, color: Color) -> some View {
    HStack(spacing: 4) {
      Text(symbol).font(.system(size: 9, weight: .semibold)).foregroundStyle(color)
      Text(label).foregroundStyle(.secondary)
    }
    .font(.system(size: 9))
    .accessibilityElement(children: .combine)
  }

  private func update(_ action: () -> Void) {
    withAnimation(reduceMotion ? nil : .easeInOut(duration: 0.18), action)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView(state: .init())
  }
}
