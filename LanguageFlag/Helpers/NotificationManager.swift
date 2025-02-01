import Foundation
import Carbon
import Combine

class NotificationManager {

    // MARK: - Init
    init() {
        setupObservers()
    }
}

// MARK: - Private
extension NotificationManager {

    /// Sets up all required notifications.
    private func setupObservers() {
        DistributedNotificationCenter.default().addObserver(
            self,
            selector: #selector(handleInputSourceChange),
            name: NSNotification.Name(kTISNotifySelectedKeyboardInputSourceChanged as String),
            object: nil
        )
    }

    /// Handles input source changes.
    @objc
    private func handleInputSourceChange() {
        let currentLayout = TISCopyCurrentKeyboardInputSource().takeUnretainedValue()
        let model = KeyboardLayoutNotification(keyboardLayout: currentLayout.name,
                                               isCapsLockEnabled: false,
                                               iconRef: currentLayout.iconRef)
        NotificationCenter.default.post(name: .keyboardLayoutChanged, object: model)
    }
}
