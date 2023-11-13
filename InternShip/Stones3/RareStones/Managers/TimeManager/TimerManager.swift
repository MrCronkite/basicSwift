

import Foundation

final class TimerManager {
    static let shared = TimerManager()
    
    private var timer: Timer?
    private var startTime: Date?
    
    var elapsedTime: TimeInterval {
        guard let startTime = startTime else { return 0 }
        return Date().timeIntervalSince(startTime)
    }
    
    var remainingTime: TimeInterval {
        return max(30 * 60 - elapsedTime, 0)
    }
    
    func startTimer() {
        if let savedStartTime = UserDefaults.standard.value(forKey: "startTimeKey") as? TimeInterval {
            startTime = Date(timeIntervalSinceReferenceDate: savedStartTime)
        } else {
            startTime = Date()
        }
        
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerTick), userInfo: nil, repeats: true)
        }
    }
    
    @objc private func timerTick() {
        UserDefaults.standard.set(startTime?.timeIntervalSinceReferenceDate, forKey: "startTimeKey")
        NotificationCenter.default.post(name: Notification.Name("TimerTickNotification"), object: nil)
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

