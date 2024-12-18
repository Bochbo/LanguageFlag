import Cocoa

final class LanguageWindow: NSWindow {

    // MARK: - Init
    init(contentRect: NSRect) {
        super.init(contentRect: contentRect, styleMask: .borderless, backing: .buffered, defer: false)
        configureAppearance()
    }
    
    // MARK: - Private
    private func configureAppearance() {
        isOpaque = false
        backgroundColor = .clear
        level = .floating
    }
}
