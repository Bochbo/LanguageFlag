import Cocoa

class ScreenManager {
    
    // MARK: - Variables
    private var languageWindowControllers = [LanguageWindowController]()
    
    // MARK: - Init
    init() {
        setupObservers()
        createLanguageWindows()
    }
}

// MARK: - Private
extension ScreenManager {

    /// Sets up observers for screen parameter changes.
    private func setupObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(screenParametersDidChange),
            name: NSApplication.didChangeScreenParametersNotification,
            object: nil
        )
    }
    
    /// Handles screen parameter changes and refreshes windows.
    @objc
    private func screenParametersDidChange() {
        refreshLanguageWindows()
    }
    
    /// Creates windows for all screens.
    private func createLanguageWindows() {
        languageWindowControllers = NSScreen.screens.map { screen in
            let windowController = LanguageWindowController()
            windowController.screenRect = screen.frame
            windowController.windowDidLoad()
            return windowController
        }
    }
    
    /// Refreshes language windows by recreating them.
    private func refreshLanguageWindows() {
        languageWindowControllers.forEach { $0.close() }
        languageWindowControllers.removeAll()
        createLanguageWindows()
    }
}
