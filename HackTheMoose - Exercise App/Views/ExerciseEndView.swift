//
//  ExerciseEndView.swift
//  HackTheMoose_Exercise
//
//  Created by Kevin Tun on 7/19/24.
//

import SwiftUI

struct ExerciseEndView: View {
    
    let formattedTime: String
    let repCount: Int
    let timeSeconds: Int
   @State private var weightSlider: Float = 100
    
    var body: some View {
        VStack {
            Text("Training Results")
                .font(.system(.largeTitle, weight: .bold))
                .frame(width: 260)
                .clipped()
                .multilineTextAlignment(.center)
                .padding(.top, 82)
                .padding(.bottom, 52)
            VStack(spacing: 28) {
                VStack {
                    HStack {
                        Image(systemName: "clock")
                            .symbolRenderingMode(.monochrome)
                            .foregroundStyle(.blue)
                            .font(.system(.title, weight: .regular))
                            .frame(width: 60, height: 50)
                            .clipped()
                        // Title
                        Text("Time" )
                            .font(.system(.title3, weight: .semibold))
                        Text(formattedTime)
                            .font(.system(.title3, weight: .regular))
                        Spacer()
                    }
                    .padding(.vertical, 20)
                    HStack {
                        Image(systemName: "textformat.123")
                            .symbolRenderingMode(.monochrome)
                            .foregroundStyle(.blue)
                            .font(.system(.title, weight: .regular))
                            .frame(width: 60, height: 50)
                            .clipped()
                        // Title
                        Text("Repetitions")
                            .font(.system(.title3, weight: .semibold))
                        Text("\(repCount)")
                            .font(.system(.title3, weight: .regular))
                        Spacer()
                    }
                    .padding(.vertical, 20)
                    
                    HStack {
                        Text("Weight")
                            .foregroundStyle(.blue)
                            .font(.system(.title3, weight: .semibold))
                        // Title
                        VStack{
                            Text(String(format: "%.2f", weightSlider))
                            Slider(value: $weightSlider, in: 50...300, step: 1)
                                .padding(.horizontal)
                                .frame(width: 220)
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical, 20)
                    
                    HStack {
                        Image(systemName: "flame")
                            .symbolRenderingMode(.monochrome)
                            .foregroundStyle(.blue)
                            .font(.system(.title, weight: .regular))
                            .frame(width: 60, height: 50)
                            .clipped()
                        // Title
                        Text("Calories Burnt")
                            .font(.system(.title3, weight: .semibold))
                        // Title
                        Text(String(format: "%.2f", calcCalories(weightPounds: weightSlider, timeSeconds: self.timeSeconds)))
                            .font(.system(.title3, weight: .regular))
                        Spacer()
                    }
                    .padding(.vertical, 20)
                }
            }
            Spacer()
            Text("Continue")
                .font(.system(.callout, weight: .semibold))
                .padding()
                .frame(maxWidth: .infinity)
                .clipped()
                .foregroundStyle(.white)
                .background(.blue)
                .mask { RoundedRectangle(cornerRadius: 16, style: .continuous) }
                .padding(.bottom, 60)
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

#Preview {
    ExerciseEndView(formattedTime: "12", repCount: 12, timeSeconds: 30000)
}


func calcCalories(weightPounds: Float, timeSeconds: Int) -> Float{
    let hours = (timeSeconds / 60)/60
    return 8 * weightPounds * Float(hours)
    
}
