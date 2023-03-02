//
//  LanguageWindow.swift
//  LanguageFlag
//
//  Created by Bohdan on 19.04.2020.
//  Copyright © 2020 Bohdan. All rights reserved.
//

import Cocoa

@propertyWrapper
struct ScheduledTimer {

    private var timer: Timer = Timer()
    var wrappedValue: Timer {
        get { timer }
        set {
            timer.invalidate()
            timer = newValue
            RunLoop.main.add(timer, forMode: .common)
        }
    }
}

final class LanguageWindowController: NSWindowController {

    // MARK: - Variables
    var screenRect: NSRect?
    @ScheduledTimer private var timer: Timer

    // MARK: - Life cycle
    override func windowDidLoad() {
        super.windowDidLoad()
        configureWindow()
        configureContentViewController()
        addObserver()
    }
}

// MARK: - Actions
extension LanguageWindowController {

    @objc
    private func keyboardLayoutChanged(notification: NSNotification) {
        timer.invalidate()
        runShowWindowAnimation()
        scheduleTimer()
    }

    @objc
    private func hideApplication() {
        timer.invalidate()
        runHideWindowAnimation()
    }
}

// MARK: - Configure
extension LanguageWindowController {

    private func configureWindow() {
        let screenRect = screenRect ?? NSScreen.main?.visibleFrame
        guard let screenRect else { return }
        let rect = createRect(in: screenRect)
        window = LanguageWindow(contentRect: rect)
        window?.setFrame(rect, display: true)
    }

    private func createRect(in screen: CGRect) -> CGRect {
        let posX: CGFloat = screen.minX + (screen.width - LanguageViewController.width) / 2
        let posY: CGFloat = screen.minY + screen.height * 0.16
        let rect = NSRect(x: posX, y: posY, width: LanguageViewController.width, height: LanguageViewController.height)
        return rect
    }

    private func configureContentViewController() {
        let mainStoryboard = NSStoryboard.init(name: "Main", bundle: nil)
        guard let flagVC = mainStoryboard.instantiateController(withIdentifier: "flagController") as? LanguageViewController else {
            return
        }
        window?.contentViewController = flagVC
        let cornerRadius: CGFloat = 16
        window?.contentView?.wantsLayer = true
        window?.contentView?.layer?.cornerRadius = cornerRadius
        window?.contentView?.superview?.wantsLayer = true
        window?.contentView?.superview?.layer?.cornerRadius = cornerRadius
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardLayoutChanged),
                                               name: .keyboardLayoutChanged,
                                               object: nil)
    }
    
    private func scheduleTimer() {
        timer = Timer(
            timeInterval: 1,
            target: self,
            selector: #selector(hideApplication),
            userInfo: nil,
            repeats: false)
    }
    
    private func runShowWindowAnimation() {
        window?.orderFrontRegardless()
        NSAnimationContext.runAnimationGroup { (context) -> Void in
            context.duration = 0.3
            window?.contentView?.animator().alphaValue = 1
            window?.animator().alphaValue = 1
        }
    }
    
    private func runHideWindowAnimation() {
        NSAnimationContext.runAnimationGroup { (context) -> Void in
            context.duration = 0.4
            window?.animator().alphaValue = 0
            window?.contentView?.animator().alphaValue = 0
        }
    }
}
