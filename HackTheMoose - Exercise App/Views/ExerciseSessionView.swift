//
//  ExerciseSessionView.swift
//  HackTheMoose_Exercise
//
//  Created by Kevin Tun on 7/18/24.
//

import SwiftUI

struct ExerciseSessionView: View {
    //rep variable
    @State private var repCount: Int = 0;
    var body: some View {
        
        VStack {
            Text("reps " + "\(repCount)")
            
            Image(.dummyVideoPreview)
                .resizable()
                .ignoresSafeArea()
                
            Button("Start Prediction") {
                let predictor = Predictor()
                predictor.subscribeToPublisher()
                
            }
                
           //VideoPreviewSwiftView()
                //.edgesIgnoringSafeArea(.all)
        }
        
        
        
        
    }
}

#Preview {
    ExerciseSessionView()
}
