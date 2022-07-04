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
  var contentView: ContentView!

  func applicationDidFinishLaunching(_ notification: Notification) {
    popOver.behavior = .transient
    popOver.animates = false
    popOver.contentViewController = NSViewController()
    contentView = ContentView(state: .init())
    popOver.contentViewController?.view = NSHostingView(rootView: contentView)
    popOver.contentViewController?.view.window?.makeKey()

    statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    if let itemButton = statusItem?.button {
      let icon = NSImage(named: NSImage.Name("MenuIcon"))?.tint(color: NSColor.controlTextColor)
      icon?.isTemplate = true // reactive tint color.
      itemButton.image = icon
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
      contentView.initState()
      popOver.show(relativeTo: itemButton.bounds, of: itemButton, preferredEdge: NSRectEdge.minY)
    }
  }
}
