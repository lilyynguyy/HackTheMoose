//
//  ExerciseSessionView.swift
//  HackTheMoose_Exercise
//
//  Created by Kevin Tun on 7/18/24.
//

import SwiftUI

struct ExerciseSessionView: View {
    
    //rep variable is in output subscriber cause lazy
    
    
    //timerModel
    @ObservedObject var stopwatchViewModel = StopwatchViewModel()
    
    //predicitionOutput
    
    @StateObject private var outputSubscriber = PredictionSubscriber()
    
    
    var body: some View {
        
        
        ZStack {
           // Image(.dummyVideoPreview)
              //  .resizable()
               // .ignoresSafeArea()
            VideoPreviewSwiftView()
                 .edgesIgnoringSafeArea(.all)
            
           
            VStack {
                Text("Jumping Jacks")
                    .frame(width: 300)
                    .clipped()
                    .font(.title)
                    .padding(5)
                    .background {
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .fill(Color(.tertiaryLabel))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .clipped()
                    }
                Text("Time: " + stopwatchViewModel.formattedElapsedTime())
                    .frame(width: 250)
                    .clipped()
                    .font(.title2)
                    .padding(5)
                    .background {
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .fill(Color(.tertiaryLabel))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .clipped()
                    }
                Text("Repititions: \(outputSubscriber.repCount)")
                    .frame(width: 250)
                    .clipped()
                    .font(.title2)
                    .padding(5)
                    .background {
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .fill(Color(.tertiaryLabel))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .clipped()
                    }
                
                
                //for debug
                Text("Prediction: \(outputSubscriber.receivedMessage)")
                    .frame(width: 250)
                    .clipped()
                    .font(.title2)
                    .padding(5)
                    .background {
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .fill(Color(.tertiaryLabel))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .clipped()
                    }
                
                
                
                Spacer()
                Button("Start Exercise"){
                    self.stopwatchViewModel.startStop()
                    //button logic
                    let predictor = Predictor()
                    predictor.subscribeToFramePublisher()
                    
                    outputSubscriber.subscribe(to: predictor)
                  

                    
                }
                    .frame(width: 300)
                    .clipped()
                    .font(.title)
                    .padding(5)
                    .background {
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .fill(Color(.tertiaryLabel))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .clipped()
                    }
            }
            .padding(.vertical, 30)
            .frame(maxHeight: .infinity, alignment: .top)
            .clipped()
        }
        .foregroundColor(.white)
        
        
        
        
    }
}

#Preview {
    ExerciseSessionView()
}
