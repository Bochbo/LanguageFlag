//
//  LanguageWindow.swift
//  LanguageFlag
//
//  Created by Bohdan Bochkovskyi on 26.02.2023.
//  Copyright © 2023 Bohdan. All rights reserved.
//

import Cocoa

final class LanguageWindow: NSWindow {

    init(contentRect: NSRect) {
        super.init(contentRect: contentRect, styleMask: .borderless, backing: .buffered, defer: false)
        isOpaque = false
        backgroundColor = .clear
        level = .floating
    }
}
