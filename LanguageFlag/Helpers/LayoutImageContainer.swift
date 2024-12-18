//
//  LayoutImageContainer.swift
//  LanguageFlag
//
//  Created by Bohdan Bochkovskyi on 20.07.2021.
//  Copyright © 2021 Bohdan. All rights reserved.
//

import Cocoa

final class LayoutImageContainer {

    // MARK: Variables
    static let shared = LayoutImageContainer()

    private lazy var layoutDictionary: Dictionary<String, String> = {
        createLayoutDictionary()
    }()
    private var cachedIcons = NSCache<NSString, NSImage>()

    // MARK: Internal
    func getImage(for keyboardLayout: String) -> NSImage? {
        guard
            let imageName = layoutDictionary[keyboardLayout],
            let image = NSImage(named: "Flags/" + imageName)
        else {
            return nil
        }
        return image
    }

    func getFlagItem(for keyboardLayout: String, size: NSSize) -> NSImage? {
        if let cachedIcon = cachedIcons.object(forKey: keyboardLayout as NSString) {
            return cachedIcon
        }
        guard let image = getImage(for: keyboardLayout) else {
            return nil
        }
        let resizedimage = NSImage(size: size, flipped: false) { (rect) -> Bool in
            image.draw(in: rect)
            return true
        }
        cachedIcons.setObject(resizedimage, forKey: keyboardLayout as NSString)
        return resizedimage
    }

    // MARK: Private
    private func createLayoutDictionary() -> [String: String] {
        guard
            let filePath = Bundle.main.path(forResource: "Layout", ofType: "json"),
            let jsonData = try? Data(contentsOf: URL(fileURLWithPath: filePath), options: .uncached),
            let jsonDictionary = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: String]
        else {
            assertionFailure("No json found")
            return [String: String]()
        }
        return jsonDictionary
    }
}
