//
//  ViewController.swift
//  LanguageFlag
//
//  Created by Bohdan on 18.04.2020.
//  Copyright © 2020 Bohdan. All rights reserved.
//

import Cocoa

class LanguageViewController: NSViewController {

    // MARK: - Variables
    static let height: CGFloat = 155
    static let width: CGFloat = 250

    // MARK: - IBOutlets
    @IBOutlet private weak var bigLabel: NSTextField!
    @IBOutlet private weak var flagImageView: NSImageView!
    @IBOutlet private weak var languageNameLabel: NSTextField!
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addObserver()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Actions
extension LanguageViewController {

    @objc
    private func keyboardLayoutChanged(notification: NSNotification) {
        guard let model = notification.object as? KeyboardLayoutNotification else { return }
        changeFlagImage(keyboardLayout: model.keyboardLayout, isCapsLockEnabled: model.isCapsLockEnabled, iconRef: model.iconRef)
    }
}

// MARK: - Private
extension LanguageViewController {

    private func setupUI() {
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: Self.height),
            view.widthAnchor.constraint(equalToConstant: Self.width),
        ])
        bigLabel.cell?.wraps = true
    }

    private func addObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardLayoutChanged),
                                               name: .keyboardLayoutChanged,
                                               object: nil)

    }
    
    private func changeFlagImage(keyboardLayout: String, isCapsLockEnabled: Bool, iconRef: IconRef?) {
        let layoutDictionary = LayoutImageContainer.shared.layoutDictionary
        let languageText = isCapsLockEnabled ? "⇪ " + keyboardLayout : keyboardLayout
        guard
            let imageName = layoutDictionary[keyboardLayout],
            let image = NSImage(named: "Flags/" + imageName)
        else {
            if let iconRef {
                let image = NSImage(iconRef: iconRef)
                set(bigLabelText: "", flagImage: image, languageLabelText: languageText)
            }
            else {
                set(bigLabelText: languageText, flagImage: nil, languageLabelText: "")
            }
            return
        }
        set(bigLabelText: "", flagImage: image, languageLabelText: languageText)
    }
    
    private func set(bigLabelText: String, flagImage: NSImage?, languageLabelText: String) {
        bigLabel.stringValue = bigLabelText
        flagImageView.image = flagImage
        languageNameLabel.stringValue = languageLabelText
    }
}
