// Created by Tiga Liang on 2022/6/29.
// Copyright © 2022 Airbnb Inc. All rights reserved.

import SwiftUI
import Combine
import Carbon

@main
struct XiamiCalApp: App {
  @NSApplicationDelegateAdaptor(AppDelegate.self)
  private var delegate

  var body: some Scene {
    Settings {
      AppPreferencesView(preferences: .shared)
    }
  }
}

class AppDelegate: NSObject, NSApplicationDelegate {
  var statusItem: NSStatusItem?
  var popOver = NSPopover()
  private let state = ContentViewState()
  private var subscriptions = Set<AnyCancellable>()
  private var settingsWindow: NSWindow?
  private var dataWindow: NSWindow?

  func applicationDidFinishLaunching(_ notification: Notification) {
    popOver.behavior = .transient
    popOver.animates = !NSWorkspace.shared.accessibilityDisplayShouldReduceMotion
    popOver.contentViewController = NSHostingController(rootView: ContentView(
      state: state,
      onOpenSettings: { [weak self] in self?.showSettings() },
      onShowHolidayData: { [weak self] year in self?.showHolidayData(year: year) }
    ))

    statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    if let itemButton = statusItem?.button {
      let icon = NSImage(named: NSImage.Name("MenuIcon"))?.tint(color: NSColor.controlTextColor)
      icon?.isTemplate = true // reactive tint color.
      itemButton.image = icon
      itemButton.setAccessibilityLabel("虾米日历")
      itemButton.toolTip = "虾米日历"
      itemButton.target = self
      itemButton.action = #selector(itemButtonToggle)
    }

    AppPreferences.shared.$showsMenuBarDate.sink { [weak self] show in
      self?.updateMenuBar(showsDate: show)
    }.store(in: &subscriptions)
    Timer.publish(every: 60, tolerance: 10, on: .main, in: .common).autoconnect()
      .sink { [weak self] _ in self?.refreshDate() }.store(in: &subscriptions)
    for name in [Notification.Name.NSCalendarDayChanged, Notification.Name.NSSystemTimeZoneDidChange,
                 NSApplication.didBecomeActiveNotification] {
      NotificationCenter.default.publisher(for: name)
        .receive(on: RunLoop.main).sink { [weak self] _ in self?.refreshDate() }
        .store(in: &subscriptions)
    }
    NSWorkspace.shared.notificationCenter.publisher(for: NSWorkspace.didWakeNotification)
      .receive(on: RunLoop.main).sink { [weak self] _ in self?.refreshDate() }
      .store(in: &subscriptions)

    // Login items are launched with the system's login-item Apple Event.
    // A normal launch or reopen still reveals the menu bar entry immediately.
    if !Self.launchedAtLogin {
      DispatchQueue.main.async { [weak self] in self?.showCalendar() }
    }
  }

  private static var launchedAtLogin: Bool {
    NSAppleEventManager.shared().currentAppleEvent?
      .paramDescriptor(forKeyword: keyAEPropData)?.enumCodeValue == keyAELaunchedAsLogInItem
  }

  private func refreshDate() {
    state.refreshToday()
    updateMenuBar(showsDate: AppPreferences.shared.showsMenuBarDate)
  }

  private func updateMenuBar(showsDate: Bool) {
    guard let button = statusItem?.button else { return }
    let day = CalendarDay(date: Date())
    button.title = showsDate ? day.menuBarText : ""
    button.imagePosition = showsDate ? .noImage : .imageOnly
    button.font = .monospacedDigitSystemFont(ofSize: 12, weight: .regular)
    button.toolTip = "虾米日历 · \(day.dateText) · 农历\(day.lunarText)"
    button.setAccessibilityLabel("虾米日历，" + day.accessibilityText)
  }

  private func showSettings() {
    popOver.performClose(nil)
    if settingsWindow == nil {
      settingsWindow = makeWindow(title: "虾米日历设置", view: AppPreferencesView(preferences: .shared))
    }
    NSApp.activate(ignoringOtherApps: true)
    settingsWindow?.makeKeyAndOrderFront(nil)
  }

  private func showHolidayData(year: Int) {
    popOver.performClose(nil)
    dataWindow?.close()
    dataWindow = makeWindow(title: "假期数据说明", view: HolidayDataView(year: year))
    NSApp.activate(ignoringOtherApps: true)
    dataWindow?.makeKeyAndOrderFront(nil)
  }

  private func makeWindow<V: View>(title: String, view: V) -> NSWindow {
    let window = NSWindow(contentViewController: NSHostingController(rootView: view))
    window.title = title
    window.styleMask = [.titled, .closable]
    window.isReleasedWhenClosed = false
    window.center()
    return window
  }

  func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
    showCalendar()
    return true
  }

  @objc func itemButtonToggle(sender: AnyObject) {
    if popOver.isShown {
      popOver.performClose(sender)
    } else {
      showCalendar()
    }
  }

  private func showCalendar() {
    guard let itemButton = statusItem?.button else { return }
    NSApp.activate(ignoringOtherApps: true)
    if !popOver.isShown {
      state.returnToToday()
      popOver.animates = !NSWorkspace.shared.accessibilityDisplayShouldReduceMotion
      popOver.show(relativeTo: itemButton.bounds, of: itemButton, preferredEdge: .minY)
    }
    popOver.contentViewController?.view.window?.makeKey()
  }
}
