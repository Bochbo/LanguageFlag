import Cocoa
import Carbon

class CapsLockManager {
    
    // MARK: - Variables
    private(set) var isCapsLockEnabled: Bool = false
    
    // MARK: - Init
    init() {
        setupCapsLockObserver()
        isCapsLockEnabled = isCapsLockOn()
    }
    
    func isCapsLockOn() -> Bool {
        let flags = CGEventSource.flagsState(.combinedSessionState)
        return flags.contains(.maskAlphaShift)
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
        let capsLockEnabled = isCapsLockOn()
        if isCapsLockEnabled != capsLockEnabled {
            isCapsLockEnabled = capsLockEnabled
            notifyCapsLockStateChanged(newCapsLockEnabled: capsLockEnabled)
        }
    }
    
    /// Notifies observers about the Caps Lock state change.
    private func notifyCapsLockStateChanged(newCapsLockEnabled: Bool) {
        NotificationCenter.default.post(name: .capsLockChanged,
                                        object: newCapsLockEnabled)
    }
}
