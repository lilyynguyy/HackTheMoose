//
//  ContentView.swift
//  HackTheMoose - Exercise App
//
//  Created by Kevin Tun on 7/11/24.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @ObservedObject var stopwatchViewModel = StopwatchViewModel()

    var body: some View {
        
        /*
        VStack {
            Text("Choose Your Exercise")
                .foregroundColor(.black)
                .font(.system(size: 30))
                .bold()
                .padding()
            
            List {
                /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Content@*/Text("Content")/*@END_MENU_TOKEN@*/
                /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Content@*/Text("Content")/*@END_MENU_TOKEN@*/
                /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Content@*/Text("Content")/*@END_MENU_TOKEN@*/
                /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Content@*/Text("Content")/*@END_MENU_TOKEN@*/
                /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Content@*/Text("Content")/*@END_MENU_TOKEN@*/
                /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Content@*/Text("Content")/*@END_MENU_TOKEN@*/
                
            }
        }
        */
        // Label to display the stopwatch time
                    Text(stopwatchViewModel.formattedElapsedTime())
                        .font(.largeTitle)
                    
                    // Button to start and stop the stopwatch
                    Button(action: {
                        self.stopwatchViewModel.startStop()
                    }) {
                        Text(stopwatchViewModel.stopwatchTimer == nil ? "Start" : "Stop")
                    }
        
        
        
       
        
    //    VideoPreviewSwiftView()
         
         
    }
}

#Preview {
    ContentView()
}
