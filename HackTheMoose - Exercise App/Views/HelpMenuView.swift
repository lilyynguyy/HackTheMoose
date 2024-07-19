//
//  HelpMenuView.swift
//  HackTheMoose_Exercise
//
//  Created by Vanessa Xu on 7/18/24.
//

import SwiftUI

struct HelpMenuView: View {
    var body: some View {
        ZStack{
            Color(.green)
            Text("Welcome to Proactive! This app is designated to track your fitness and reach goals in losing fat. Click on the jumping-jacks button to track your reps and calories burned.").font(.largeTitle).padding()
        }
    }
}

#Preview {
    HelpMenuView()
}
