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
    private var statusBarManager: StatusBarManager?
    private var isCapsLockEnabled = false

    // MARK: - Life cycle
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusBarManager = StatusBarManager()
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
    private func inputSourceChanged() {
        let currentLayout = TISCopyCurrentKeyboardInputSource().takeUnretainedValue()
        let model = KeyboardLayoutNotification(keyboardLayout: currentLayout.name,
                                               isCapsLockEnabled: isCapsLockEnabled,
                                               iconRef: currentLayout.iconRef)
        NotificationCenter.default.post(name: .keyboardLayoutChanged, object: model)
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

        let eventMask = NSEvent.EventTypeMask.flagsChanged
        NSEvent.addGlobalMonitorForEvents(matching: eventMask,
                                          handler: { [weak self] (event: NSEvent) -> Void in
            guard let self = self else { return }
            let capsLockEnabled = event.modifierFlags.contains(.capsLock)
            self.setCapsLockState(capsLockEnabled)
        })
    }

    private func setCapsLockState(_ isEnabled: Bool) {
        if isCapsLockEnabled != isEnabled {
            isCapsLockEnabled = isEnabled
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { [weak self] in
                self?.inputSourceChanged()
            }
        }
        isCapsLockEnabled = isEnabled
    }

//    func getIsCapsLockEnabled() -> Bool {
//        let flags = CGEventFlags(rawValue: CGEventSource.flagsState(.hidSystemState).rawValue)
//        return flags.contains(.maskAlphaShift)
//    }
//
//    func getIsCapsLockIOEnabled() -> Bool {
//        var ioConnect: io_connect_t = .init(0)
//        let ioService = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching(kIOHIDSystemClass))
//        IOServiceOpen(ioService, mach_task_self_, UInt32(kIOHIDParamConnectType), &ioConnect)
//
//        var modifierLockState = false
//        IOHIDGetModifierLockState(ioConnect, Int32(kIOHIDCapsLockState), &modifierLockState)
//        IOServiceClose(ioConnect)
//        return modifierLockState
//    }

    private func reconfigureWindows() {
        languageWindowControllerArray.forEach { $0.close() }
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
}
