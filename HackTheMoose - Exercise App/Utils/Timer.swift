//
//  Timer.swift
//  HackTheMoose_Exercise
//
//  Created by Kevin Tun on 7/19/24.
//

import Foundation
import UIKit
import Combine

class StopwatchViewModel: ObservableObject {
    
    
    
    // Timer object to track elapsed time
    var stopwatchTimer: Timer?
    
    // Variable to keep track of elapsed time
    @Published var elapsedTime: TimeInterval = 0
    
    
    
    func startStop() {
        // If the timer is running, stop it
        if let timer = stopwatchTimer {
            timer.invalidate()
            stopwatchTimer = nil
            //elapsedTime = 0
        } else {
            
            
            // Start the timer
            stopwatchTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { [weak self] timer in
                
                // Update the elapsed time
                self?.elapsedTime += timer.timeInterval
            })
        }
    }
    
    func formattedElapsedTime() -> String {
        // Format the elapsed time as a stopwatch time
        let minutes = Int(elapsedTime) / 60 % 60
        let seconds = Int(elapsedTime) % 60
        let milliseconds = Int(elapsedTime * 100) % 100
        
        // Return the formatted time
        return String(format: "%02d:%02d:%02d", minutes, seconds, milliseconds)
    }
}


class ViewController: UIViewController {
    
    
    // Label to display the stopwatch time
    @IBOutlet weak var timeLabel: UILabel!
    
    // ViewModel to handle the stopwatch logic
    var stopwatchViewModel = StopwatchViewModel()
    
    // Cancelable to stop observing the elapsed time
    var cancellable: AnyCancellable?
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the initial time to 0
        timeLabel.text = "0:00:00"
        
        // Observe changes in the elapsed time
        cancellable = stopwatchViewModel.$elapsedTime.sink { elapsedTime in
            // Update the label with the formatted time
            self.timeLabel.text = self.stopwatchViewModel.formattedElapsedTime()
        }
    }
    
    
    
    @IBAction func startStopButtonTapped(_ sender: UIButton) {
        stopwatchViewModel.startStop()
        
        // Update the button text
        if stopwatchViewModel.stopwatchTimer == nil {
            sender.setTitle("Start", for: .normal)
        } else {
            sender.setTitle("Stop", for: .normal)
        }
    }
}
