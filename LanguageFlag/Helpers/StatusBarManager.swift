//
//  StatusBarManager.swift
//  LanguageFlag
//
//  Created by Bohdan Bochkovskyi on 05.03.2023.
//  Copyright © 2023 Bohdan. All rights reserved.
//

import Cocoa
import LaunchAtLogin
import Carbon

final class StatusBarManager {

    // MARK: Variables
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    private let layoutImageContainer: LayoutImageContainer

    // MARK: Init
    init(layoutImageContainer: LayoutImageContainer = LayoutImageContainer.shared) {
        self.layoutImageContainer = layoutImageContainer
        configureStatusBar()
        addObserver()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: Actions
private extension StatusBarManager {

    @objc
    private func keyboardLayoutChanged(notification: NSNotification) {
        let model = notification.object as? KeyboardLayoutNotification
        setImageForStatItem(keyboardLayout: model?.keyboardLayout)
    }

    @objc
    private func changeLaunchAtLoginState(_ sender: NSMenuItem?) {
        LaunchAtLogin.isEnabled.toggle()
        sender?.state = LaunchAtLogin.isEnabled ? NSControl.StateValue.on : NSControl.StateValue.off
    }

    @objc
    private func exitApplication() {
        NSApplication.shared.terminate(self)
    }
}

// MARK: Private
private extension StatusBarManager {

    private func setImageForStatItem(keyboardLayout: String?) {
        let iconSize = NSSize(width: 24, height: 24)
        statusItem.button?.image = keyboardLayout.flatMap { layoutImageContainer.getFlagItem(for: $0, size: iconSize) }
        statusItem.button?.title = keyboardLayout == nil ? "💂‍♀️" : ""
    }

    private func configureStatusBar() {
        let statusMenu = NSMenu()
        statusMenu.addItem(withTitle: "Language Flag", action: nil, keyEquivalent: "")
        statusMenu.addItem(NSMenuItem.separator())
        statusMenu.addItem(withTitle: "Launch at login", action: #selector(changeLaunchAtLoginState), keyEquivalent: "")
        statusMenu.addItem(withTitle: "Exit", action: #selector(exitApplication), keyEquivalent: "")
        statusMenu.items.forEach { $0.target = self }
        statusMenu.item(at: 2)?.state = LaunchAtLogin.isEnabled ? NSControl.StateValue.on : NSControl.StateValue.off
        statusItem.menu = statusMenu
        let keyboardLayout = TISCopyCurrentKeyboardInputSource().takeUnretainedValue().name
        setImageForStatItem(keyboardLayout: keyboardLayout)
    }

    private func addObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardLayoutChanged),
                                               name: .keyboardLayoutChanged,
                                               object: nil)
    }
}
