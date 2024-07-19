//
//  MainMenuView.swift
//  HackTheMoose_Exercise
//
//  Created by Vanessa Xu on 7/18/24.
//

import SwiftUI
import AVFoundation

struct MainMenuView: View {
    @State private var isViewEnabled: Bool = false

    var body: some View {
        NavigationView{
            VStack {
                NavigationLink(destination: HelpMenuView()){
                    
                    Text("HELP").padding().background(Color.green).cornerRadius(8).font(.largeTitle)
                    Image(systemName: "hand.tap").resizable().scaledToFit().frame(width: 50, height: 40).offset(x: 0, y: 0)
                    
                }
                Text("Choose Exercise").offset(x: 0, y: -200)
                    .foregroundColor(.black)
                    .font(.system(size: 30))
                    .bold()
                    .padding()
                Button {
                 //action
                 } label: {
                 //appearance of button
                 Text("Jumping Jacks").padding().background(Color.green).cornerRadius(8).font(.largeTitle).offset(x: 0, y: -50)
                 Image(systemName: "hand.tap").resizable().scaledToFit().frame(width: 50, height: 40).offset(x: 0, y: -50)
                 }
                Image(.logo).offset(x:0, y:80)
            }
        }
    }
}

#Preview {
    MainMenuView()
}
