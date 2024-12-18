import Cocoa
import Carbon

class CapsLockManager {
    
    // MARK: - Variables
    private(set) var isCapsLockEnabled = false
    
    // MARK: - Init
    init() {
        setupCapsLockObserver()
    }
}

// MARK: - Private
extension CapsLockManager {
    
    /// Sets up an observer to monitor Caps Lock state changes.
    private func setupCapsLockObserver() {
        let eventMask = NSEvent.EventTypeMask.flagsChanged
        NSEvent.addGlobalMonitorForEvents(matching: eventMask) { [weak self] event in
            self?.handleCapsLockStateChange(event: event)
        }
    }
    
    /// Handles Caps Lock state changes.
    private func handleCapsLockStateChange(event: NSEvent) {
        let capsLockEnabled = event.modifierFlags.contains(.capsLock)
        if isCapsLockEnabled != capsLockEnabled {
            isCapsLockEnabled = capsLockEnabled
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) {
                self.notifyCapsLockStateChanged(newCapsLockEnabled: capsLockEnabled)
            }
        }
    }
    
    /// Notifies observers about the Caps Lock state change.
    private func notifyCapsLockStateChanged(newCapsLockEnabled: Bool) {
        let currentLayout = TISCopyCurrentKeyboardInputSource().takeUnretainedValue()
        let model = KeyboardLayoutNotification(keyboardLayout: currentLayout.name,
                                               isCapsLockEnabled: newCapsLockEnabled,
                                               iconRef: currentLayout.iconRef)

        NotificationCenter.default.post(name: .keyboardLayoutChanged,
                                        object: model)
    }
}
