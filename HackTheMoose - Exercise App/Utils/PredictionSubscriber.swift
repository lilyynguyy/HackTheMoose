//
//  Subscriber.swift
//  HackTheMoose_Exercise
//
//  Created by Kevin Tun on 7/19/24.
//

import Foundation
import Combine

class PredictionSubscriber: ObservableObject {
    var receivedMessage: String = ""
    private var cancellables = Set<AnyCancellable>()
    
    var repCount : Int = 0
    private var lastState : String = "other"
    
    
   
    
    // Function to subscribe to the publisher
    func subscribe(to publisher: Predictor) {
        
        
        
        publisher.predictionOutSubject
            .sink(receiveValue: processOutput)
            .store(in: &cancellables)
        
       
    }
    
    func processOutput(message:String) -> Void {
        lastState = receivedMessage
        receivedMessage = message
        
        
        if wasRep() {
            repCount += 1
        }
        
        print(repCount)
    }
    
    func wasRep() -> Bool{
        
        if lastState == "jumping_jack_eccentric" && receivedMessage == "jumping_jack_concentric" {
            return true
        }
        else{
            return false
        }
    }
}
