//
//  TimerViewController.swift
//  Power Nappppppppppppper
//
//  Created by Jason Goodney on 8/28/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var timerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TimerController.shared.timerDelegate = self
        
        updateView()
    }
}

// MARK: - Methods
private extension TimerViewController {
    
    func updateView() {
        updateButton()
        updateTimerLabel()
    }
    
    func updateButton() {
        if TimerController.shared.isOn {
            timerButton.setTitle("⏰", for: .normal)
            timerButton.backgroundColor = #colorLiteral(red: 1, green: 0.3106256949, blue: 0.2868524406, alpha: 0.6866508152)
        } else {
            timerButton.setTitle("🛌", for: .normal)
            timerButton.backgroundColor = #colorLiteral(red: 1, green: 0.7267512362, blue: 0.04096615336, alpha: 0.6365276834)
        }
    }
    
    func updateTimerLabel() {
        timerLabel.text = TimerController.shared.timeAsString()
    }
    
    func presentAlert() {
        let alertController = UIAlertController(title: "Wake Up!", message: "🚨🚨🚨🚨", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "🛌 a few more minutes..."
            textField.textAlignment = .center
            textField.keyboardType = .numberPad
        }
        
        let snoozeAction = UIAlertAction(title: "Snooze", style: .default) { _ in
            guard let snoozeText = alertController.textFields?[0].text,
                let snoozeTime = Double(snoozeText) else { return }
            
            DispatchQueue.main.async {
                TimerController.shared.startTimer(forTime: snoozeTime)
                self.scheduleLocalNotification()
                self.updateView()
            }
        }
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        
        alertController.addAction(snoozeAction)
        alertController.addAction(dismissAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - Actions
private extension TimerViewController {
    
    @IBAction func timerButtonTapped(_ sender: UIButton) {
        let timerIsOn = TimerController.shared.isOn
        
        if timerIsOn {
            TimerController.shared.stopTimer()
            return
        }
        TimerController.shared.startTimer(forTime: 5)
        scheduleLocalNotification()
        updateView()
    }
}

// MARK: - TimerControllerDelegate
extension TimerViewController: TimerControllerDelegate {
    var timeRemaining: TimeInterval? {
        get {
            return TimerController.shared.timeRemaining
        }
        set {}
    }
    
    var identifier: String {
        return "PowerNapIdentifier"
    }
    
    func timerSecondTick() {
        updateTimerLabel()
    }
    
    func timerCompleted() {
        presentAlert()
        updateView()
    }
    
    func timerStopped() {
        updateView()
    }
}



















