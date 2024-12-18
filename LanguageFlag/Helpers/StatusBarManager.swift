import Cocoa
import LaunchAtLogin
import Carbon

final class StatusBarManager {

    // MARK: - Properties
    private let statusItem: NSStatusItem
    private let layoutImageContainer: LayoutImageContainer
    private let menuBuilder: StatusBarMenuBuilder

    // MARK: - Initialization
    init(
        layoutImageContainer: LayoutImageContainer = LayoutImageContainer.shared,
        menuBuilder: StatusBarMenuBuilder = StatusBarMenuBuilder()
    ) {
        self.layoutImageContainer = layoutImageContainer
        self.menuBuilder = menuBuilder
        self.statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        setupStatusBar()
        addObservers()
    }

    // MARK: - Deinit
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Setup Methods
private extension StatusBarManager {

    /// Configures the status bar and menu items.
    func setupStatusBar() {
        // Build and assign the menu
        let menu = menuBuilder.buildMenu(
            launchAtLoginAction: #selector(toggleLaunchAtLogin),
            exitAction: #selector(exitApplication),
            target: self
        )
        statusItem.menu = menu

        // Set the initial icon or title
        let keyboardLayout = TISCopyCurrentKeyboardInputSource().takeUnretainedValue().name
        updateStatusBarIcon(for: keyboardLayout)
    }

    /// Subscribes to relevant notifications.
    func addObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardLayoutChanged),
            name: .keyboardLayoutChanged,
            object: nil
        )
    }
}

// MARK: - Actions
private extension StatusBarManager {

    /// Handles keyboard layout change notifications.
    @objc
    func keyboardLayoutChanged(notification: NSNotification) {
        guard let model = notification.object as? KeyboardLayoutNotification else { return }
        updateStatusBarIcon(for: model.keyboardLayout)
    }

    /// Toggles the Launch at Login state.
    @objc
    func toggleLaunchAtLogin(_ sender: NSMenuItem?) {
        LaunchAtLogin.isEnabled.toggle()
        sender?.state = LaunchAtLogin.isEnabled ? .on : .off
    }

    /// Exits the application.
    @objc
    func exitApplication() {
        NSApplication.shared.terminate(self)
    }
}

// MARK: - Helper Methods
private extension StatusBarManager {

    /// Updates the status bar icon or title based on the keyboard layout.
    func updateStatusBarIcon(for keyboardLayout: String?) {
        let iconSize = NSSize(width: 24, height: 24)
        if let keyboardLayout = keyboardLayout {
            statusItem.button?.image = layoutImageContainer.getFlagItem(for: keyboardLayout, size: iconSize)
            statusItem.button?.title = ""
        } else {
            statusItem.button?.image = nil
            statusItem.button?.title = "💂‍♀️"
        }
    }
}
