//
//  ContentView.swift
//  HackTheMoose - Exercise App
//
//  Created by Kevin Tun on 7/11/24.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @State private var isViewEnabled: Bool = false
    var body: some View {
        
        
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
        
        
        
        
        
       
        
    //    VideoPreviewSwiftView()
         
         
    }
}

#Preview {
    ContentView()
}
