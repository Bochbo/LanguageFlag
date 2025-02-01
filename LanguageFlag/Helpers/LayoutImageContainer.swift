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

    func getFlagItem(for keyboardLayout: String,
                     size: NSSize) -> NSImage? {
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

        cachedIcons.setObject(resizedimage,
                              forKey: keyboardLayout as NSString)

        return resizedimage
    }

    func getFlagItem(for keyboardLayout: String,
                     size: NSSize,
                     isCapsLock: Bool) -> NSImage? {
        let cacheKey = "\(keyboardLayout)-\(size.width)x\(size.height)-\(isCapsLock)" as NSString

        if let cachedIcon = cachedIcons.object(forKey: cacheKey) {
            return cachedIcon
        }

        guard let image = getImage(for: keyboardLayout) else {
            return nil
        }

        let resizedImage = NSImage(size: size, flipped: false) { (rect) -> Bool in
            image.draw(in: rect)

            if isCapsLock {
                let capsLockSymbol = "⇪"
                let attributes: [NSAttributedString.Key: Any] = [
                    .font: NSFont.systemFont(ofSize: size.height * 0.3), // Adjust size as needed
                    .foregroundColor: NSColor.white
                ]
                let attributedString = NSAttributedString(string: capsLockSymbol, attributes: attributes)
                let stringSize = attributedString.size()

                // Padding and positioning for the symbol
                let padding: CGFloat = 2.0
                let x = rect.origin.x + padding
                let y = rect.origin.y + padding

                // Calculate background size and create a rounded rectangle path
                let backgroundPadding: CGFloat = 1.0 // Padding around the symbol inside the background
                let backgroundRect = NSRect(
                    x: x - backgroundPadding,
                    y: y - backgroundPadding,
                    width: stringSize.width + 2 * backgroundPadding,
                    height: stringSize.height + 2 * backgroundPadding
                )
                let cornerRadius: CGFloat = 4.0 // Adjust for desired roundness
                let backgroundPath = NSBezierPath(roundedRect: backgroundRect, xRadius: cornerRadius, yRadius: cornerRadius)

                // Set the background color (semi-transparent black)
                NSColor(white: 0, alpha: 0.5).setFill() // Adjust alpha for desired transparency
                backgroundPath.fill()

                // Draw the symbol
                let stringRect = NSRect(x: x, y: y, width: stringSize.width, height: stringSize.height)
                attributedString.draw(in: stringRect)
            }

            return true
        }

        cachedIcons.setObject(resizedImage,
                              forKey: cacheKey)

        return resizedImage
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
