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
    private var screenManager: ScreenManager!
    private var capsLockManager: CapsLockManager!
    private var notificationManager: NotificationManager!

    // MARK: - Life cycle
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusBarManager = StatusBarManager()
        screenManager = ScreenManager()
        capsLockManager = CapsLockManager()
        notificationManager = NotificationManager(capsLockManager: capsLockManager)
    }
}
