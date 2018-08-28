//
//  TimerController.swift
//  Power Nappppppppppppper
//
//  Created by Jason Goodney on 8/28/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

import Foundation
import UserNotifications

protocol TimerControllerDelegate: class {
    var identifier: String { get }
    var timeRemaining: TimeInterval? { get set }
    
    func timerSecondTick()
    func timerCompleted()
    func timerStopped()
    
    func scheduleLocalNotification()
    
}

extension TimerControllerDelegate {
    
    func scheduleLocalNotification() {
        
        let content = UNMutableNotificationContent()
        content.title = "Wake Up"
        content.body = "💪"
        
        guard let timeRemaining = timeRemaining else { return }
        
        let date = Date(timeInterval: timeRemaining, since: Date())
        let dateComponents = Calendar.current.dateComponents([.minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Unable to make request: \(error)\n\(error.localizedDescription)")
            }
        }
    }
    
    func cancelLocalNotification() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
}

class TimerController {
    
    static let shared = TimerController()
    weak var timerDelegate: TimerControllerDelegate?
    
    var timer: Timer?
    var timeRemaining: TimeInterval?
    var isOn: Bool {
        return timeRemaining != nil ? true : false
    }
    
}

extension TimerController {
    
    func startTimer(forTime time: TimeInterval) {
        if !isOn {
            timeRemaining = time
            DispatchQueue.main.async {
                self.secondTick()
                self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
                    self.secondTick()
                })
            }
        }
    }
    
    func stopTimer() {
        if isOn {
            timer?.invalidate()
            self.timeRemaining = nil
            timerDelegate?.timerStopped()
        }
    }
    
    func timeAsString() -> String {
        let timeRemaining = Int(self.timeRemaining ?? 20 * 60)
        let minutes = timeRemaining / 60
        let seconds = timeRemaining - (minutes * 60)
        
        return String(format: "%02d : %02d", arguments: [minutes, seconds])
    }
    
    func secondTick() {
        guard let timeRemaining = timeRemaining else { return }
        if timeRemaining > 0 {
            self.timeRemaining = timeRemaining - 1
            timerDelegate?.timerSecondTick()
            print(timeRemaining)
        } else {
            timer?.invalidate()
            self.timeRemaining = nil
            timerDelegate?.timerCompleted()
        }
    }
}
