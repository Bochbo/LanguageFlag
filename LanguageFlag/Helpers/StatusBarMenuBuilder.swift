import Cocoa
import LaunchAtLogin

final class StatusBarMenuBuilder {

    /// Builds the menu for the status bar.
    /// - Parameters:
    ///   - launchAtLoginAction: Selector for toggling Launch at Login.
    ///   - exitAction: Selector for exiting the app.
    ///   - target: The target for menu actions.
    /// - Returns: A configured `NSMenu` instance.
    func buildMenu(
        launchAtLoginAction: Selector,
        exitAction: Selector,
        target: AnyObject
    ) -> NSMenu {
        let menu = NSMenu()
        
        // Add menu items
        menu.addItem(withTitle: "Language Flag", action: nil, keyEquivalent: "")
        menu.addItem(NSMenuItem.separator())
        let launchItem = menu.addItem(
            withTitle: "Launch at login",
            action: launchAtLoginAction,
            keyEquivalent: ""
        )
        menu.addItem(withTitle: "Exit", action: exitAction, keyEquivalent: "")
        
        // Configure item states and targets
        menu.items.forEach { $0.target = target }
        launchItem.state = LaunchAtLogin.isEnabled ? .on : .off

        return menu
    }
}
