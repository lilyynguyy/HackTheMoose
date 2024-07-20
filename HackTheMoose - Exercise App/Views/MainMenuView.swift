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
            ScrollView {
                VStack {
                    Image(.logo)
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 120)
                        .clipped()
                    Text("Welcome to Proactive")
                        .font(.system(.largeTitle, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .clipped()
                        .padding(.leading)
                        .padding(.bottom, 8)
                    Text("Choose an exercise")
                        .font(.title)
                        .padding(7)
                    Spacer()
                        .frame(height: .infinity)
                        .clipped()
                    
                    NavigationLink(destination: ExerciseSessionView()){
                        Text("Jumping Jacks")
                            .font(.title2)
                            .foregroundColor(.black)
                            .padding(7)
                            .background {
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .fill(Color(.quaternaryLabel))
                            }
                    }
                }
                .frame(maxWidth: .infinity)
                .clipped()
                .padding(.top)
            }
            .overlay(alignment: .top) {
                Group {
                    
                }
            }
            .overlay(alignment: .bottom) {
                // Tab Bar
                VStack(spacing: 0) {
                    Divider()
                    NavigationLink(destination: HelpMenuView()){
                        Text("Help")
                            .font(.title2)
                            .foregroundColor(.black)
                            .padding(7)
                            .padding(.horizontal, 20)
                            .background {
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .fill(Color(.quaternaryLabel))
                            }
                            .padding(.horizontal, 15)
                            .padding(.top, 20)
                    }
                   
                }
                .frame(height: 84, alignment: .top)
                .clipped()
                .background {
                    Rectangle()
                        .fill(.clear)
                        .background(Material.bar)
                }
            }
        }
        
        /*
        
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
         */
    }
}

#Preview {
    MainMenuView()
}
