//
//  TimerController.swift
//  Power Nappppppppppppper
//
//  Created by Jason Goodney on 8/28/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

import Foundation

class TimerController {
    
    var timer: Timer?
    var timeRemaining: TimeInterval?
    var isOn: Bool {
        return timeRemaining != nil ? true : false
    }
}

extension TimerController {
    
    func startTimer(for time: TimeInterval) {
        if !isOn {
            timeRemaining = time
            DispatchQueue.main.async {
                self.secondTick()
                self.timer = Timer.scheduledTimer(withTimeInterval: time, repeats: true, block: { _ in
                    self.secondTick()
                })
            }
        }
    }
    
    func stopTimer() {
        if isOn {
            timer?.invalidate()
            self.timeRemaining = nil
        }
    }
    
    func secondTick() {
        guard let timeRemaining = timeRemaining else { return }
        if timeRemaining > 0 {
            self.timeRemaining = timeRemaining - 1
            print(self.timeRemaining!)
        } else {
            timer?.invalidate()
            self.timeRemaining = nil
        }
    }
    
    func timeAsString() -> String {
        let timeRemaining = Int(self.timeRemaining ?? 20 * 60)
        let miuntes = timeRemaining / 60
        let seconds = timeRemaining % 60 //- (miuntes * 60)
        
        return String(format: "%02d : %02d", arguments: [miuntes, seconds])
    }
}
