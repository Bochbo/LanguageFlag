//
//  LayoutImageContainer.swift
//  LanguageFlag
//
//  Created by Bohdan Bochkovskyi on 20.07.2021.
//  Copyright © 2021 Bohdan. All rights reserved.
//

import Foundation

final class LayoutImageContainer {

    // MARK: Variables
    static let shared = LayoutImageContainer()
    
    public lazy var layoutDictionary: Dictionary<String, String> = {
        createLayoutDictionary()
    }()
    
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
