// Created by Tiga Liang on 2022/6/29.
// Copyright © 2022 Airbnb Inc. All rights reserved.

import SwiftUI

@main
struct XiamiCalApp: App {
  @NSApplicationDelegateAdaptor(AppDelegate.self)
  private var delegate

  var body: some Scene {
    Settings {
      EmptyView()
    }
  }
}

class AppDelegate: NSObject, NSApplicationDelegate {
  var statusItem: NSStatusItem?
  var popOver = NSPopover()
  private let state = ContentViewState()

  func applicationDidFinishLaunching(_ notification: Notification) {
    popOver.behavior = .transient
    popOver.animates = !NSWorkspace.shared.accessibilityDisplayShouldReduceMotion
    popOver.contentViewController = NSHostingController(rootView: ContentView(state: state))

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

    DispatchQueue.main.async { [weak self] in
      self?.showCalendar()
    }
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
