//
//  HelpMenuView.swift
//  HackTheMoose_Exercise
//
//  Created by Vanessa Xu on 7/18/24.
//

import SwiftUI

struct HelpMenuView: View {
    var body: some View {
        NavigationView{
            VStack {
                Text("How to use Proactive?")
                    .font(.system(.largeTitle, weight: .bold))
                    .frame(width: 240)
                    .clipped()
                    .multilineTextAlignment(.center)
                    .padding(.top)
                    .padding(.bottom, 52)
                VStack(spacing: 28) {
                    VStack {
                        HStack {
                            Image(systemName: "figure.run")
                                .symbolRenderingMode(.monochrome)
                                .foregroundStyle(.blue)
                                .font(.system(.title, weight: .regular))
                                .frame(width: 60, height: 50)
                                .clipped()
                            VStack(alignment: .leading, spacing: 3) {
                                // Title
                                Text("Choose an Exercise")
                                    .font(.system(.footnote, weight: .semibold))
                                // Description
                                Text("Pick one of the exercises to start a training session.")
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                            }
                            .fixedSize(horizontal: false, vertical: true)
                            Spacer()
                        }
                        .padding(.vertical, 20)
                        HStack {
                            Image(systemName: "play")
                                .symbolRenderingMode(.monochrome)
                                .foregroundStyle(.blue)
                                .font(.system(.title, weight: .regular))
                                .frame(width: 60, height: 50)
                                .clipped()
                            VStack(alignment: .leading, spacing: 3) {
                                // Title
                                Text("Training")
                                    .font(.system(.footnote, weight: .semibold))
                                // Description
                                Text("Get in position and press begin to start tracking your repetitions with AI Vision.")
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                            }
                            .fixedSize(horizontal: false, vertical: true)
                            Spacer()
                        }
                        .padding(.vertical, 20)
                        HStack {
                            Image(systemName: "figure.cooldown")
                                .symbolRenderingMode(.monochrome)
                                .foregroundStyle(.blue)
                                .font(.system(.title, weight: .regular))
                                .frame(width: 60, height: 50)
                                .clipped()
                            VStack(alignment: .leading, spacing: 3) {
                                // Title
                                Text("Tips")
                                    .font(.system(.footnote, weight: .semibold))
                                // Description
                                Text("Use slow controlled reps for the best accuracy. The app works best with only one person in frame and the entire body visible.")
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                            }
                            .fixedSize(horizontal: false, vertical: true)
                            Spacer()
                        }
                        .padding(.vertical, 20)
                    }
                }
                Spacer()
                
                
            }
            .frame(maxWidth: .infinity)
            .clipped()
            .padding(.top, 53)
            .padding(.bottom, 0)
            .padding(.horizontal, 29)
            .overlay(alignment: .top) {
                Group {
                    
                }
            }
        }
        }
}

#Preview {
    HelpMenuView()
}
