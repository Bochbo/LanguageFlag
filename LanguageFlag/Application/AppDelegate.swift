//
//  AppDelegate.swift
//  LanguageFlag
//
//  Created by Bohdan on 18.04.2020.
//  Copyright © 2020 Bohdan. All rights reserved.
//

import Cocoa
import LaunchAtLogin
import Carbon

class AppDelegate: NSObject, NSApplicationDelegate {
    
    // MARK: - Variables
    private var languageWindowControllerArray = [LanguageWindowController]()
    private lazy var statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    private var isCapsLockEnabled = false

    // MARK: - Life cycle
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        configureStatusBar()
        createWindows()
        addObservers()
    }
}

// MARK: Actions
private extension AppDelegate {

    @objc
    private func screenParametersDidChange(_ notificaion: NSNotification?) {
        reconfigureWindows()
    }

    @objc
    private func exitApplication() {
        NSApplication.shared.terminate(self)
    }

    @objc
    private func inputSourceChanged() {
        let currentLayout = TISCopyCurrentKeyboardInputSource().takeUnretainedValue()
        let localizedNameString = currentLayout.name
        let iconRef = currentLayout.iconRef
        let model = KeyboardLayoutNotification(keyboardLayout: localizedNameString,
                                               isCapsLockEnabled: isCapsLockEnabled,
                                               iconRef: iconRef)
        NotificationCenter.default.post(name: .keyboardLayoutChanged, object: model)
    }

    @objc
    private func changeMenuItemState(_ sender: NSMenuItem?) {
        guard let sender = sender else {
            return
        }
        LaunchAtLogin.isEnabled.toggle()
        let state = LaunchAtLogin.isEnabled ? NSControl.StateValue.on : NSControl.StateValue.off
        sender.state = state
    }
}

// MARK: Private
private extension AppDelegate {

    private func addObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(screenParametersDidChange(_:)),
                                               name: NSApplication.didChangeScreenParametersNotification,
                                               object: nil)
        DistributedNotificationCenter.default().addObserver(self,
                                                            selector: #selector(inputSourceChanged),
                                                            name: NSNotification.Name(kTISNotifySelectedKeyboardInputSourceChanged as String),
                                                            object: nil)

        // Create a new NSEvent object to monitor caps lock events
        let eventMask = NSEvent.EventTypeMask.flagsChanged
        NSEvent.addGlobalMonitorForEvents(matching: eventMask,
                                          handler: { [weak self] (event: NSEvent) -> Void in
            guard let self = self else { return }
            // Check if caps lock is enabled or disabled
            let flags = event.modifierFlags
            let capsLockEnabled = flags.contains(.capsLock)
            self.setCapsLockState(capsLockEnabled)
        })
    }

    private func setCapsLockState(_ isEnabled: Bool) {
        if isCapsLockEnabled != isEnabled {
            isCapsLockEnabled = isEnabled
            inputSourceChanged()
        }
        isCapsLockEnabled = isEnabled
    }

//    func getIsCapsLockEnabled() -> Bool {
//        let flags = CGEventFlags(rawValue: CGEventSource.flagsState(.hidSystemState).rawValue)
//        return flags.contains(.maskAlphaShift)
//    }

    private func reconfigureWindows() {
        languageWindowControllerArray.forEach {
            $0.close()
        }
        languageWindowControllerArray.removeAll()
        createWindows()
    }

    private func createWindows() {
        // Multiscreen
        NSScreen.screens.forEach { screen in
            let screenRect = screen.frame
            let windowController = LanguageWindowController()
            windowController.screenRect = screenRect
            windowController.windowDidLoad()
            languageWindowControllerArray.append(windowController)
        }
    }

    private func configureStatusBar() {
        guard statusItem.button != nil else { return }

        let exitMenuItem: NSMenuItem = {
            let item = NSMenuItem(
                title: "Exit",
                action: #selector(exitApplication),
                keyEquivalent: ""
            )

            item.tag = 0
            item.target = self
            item.isEnabled = true
            return item
        }()

        let loginMenuItem: NSMenuItem = {
            let item = NSMenuItem(
                title: "Launch at login",
                action: #selector(changeMenuItemState),
                keyEquivalent: ""
            )

            item.tag = 0
            item.target = self
            item.isEnabled = true
            let state = LaunchAtLogin.isEnabled ? NSControl.StateValue.on : NSControl.StateValue.off
            item.state = state
            return item
        }()

        let statusMenu = NSMenu()
        statusMenu.items = [loginMenuItem, exitMenuItem]
        statusItem.menu = statusMenu
        statusItem.button?.title = "💂‍♀️"
    }
}
