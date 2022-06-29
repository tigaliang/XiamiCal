// Created by Tiga Liang on 2022/6/29.
// Copyright © 2022 Airbnb Inc. All rights reserved.

import SwiftUI

@main
struct XiamiCalApp: App {
  @NSApplicationDelegateAdaptor(AppDelegate.self)
  private var delegate

  var body: some Scene {
    //    WindowGroup {
    //      ContentView()
    //    }

    Settings {
      EmptyView()
    }
  }
}

class AppDelegate: NSObject, NSApplicationDelegate {
  var statusItem: NSStatusItem?
  var popOver = NSPopover()

  func applicationDidFinishLaunching(_ notification: Notification) {
    popOver.behavior = .transient
    popOver.animates = false
    popOver.contentViewController = NSViewController()
    popOver.contentViewController?.view = NSHostingView(rootView: ContentView())
    popOver.contentViewController?.view.window?.makeKey()

    statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    if let itemButton = statusItem?.button {
      itemButton.image = NSImage(systemSymbolName: "alarm", accessibilityDescription: nil)
      //itemButton.imagePosition = NSControl.ImagePosition.imageLeft
      //itemButton.title = "TigaCal"
      itemButton.action = #selector(itemButtonToggle)
    }
  }

  @objc func itemButtonToggle(sender: AnyObject) {
    if popOver.isShown {
      popOver.performClose(sender)
    } else if let itemButton = statusItem?.button {
      NSApp.activate(ignoringOtherApps: true)
      popOver.show(relativeTo: itemButton.bounds, of: itemButton, preferredEdge: NSRectEdge.minY)
    }
  }
}
