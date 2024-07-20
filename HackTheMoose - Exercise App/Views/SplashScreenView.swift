//
//  SplashScreenView.swift
//  Proactive
//
//  Created by lily on 7/14/24.
//

import SwiftUI

struct SplashScreenView: View {
    @State var isActive : Bool = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    // Customise your SplashScreen here
    var body: some View {
        if isActive {
            MainMenuView()
        } else {
            VStack{
                Spacer()
                    .frame(height: 200)
                VStack(spacing:-100) {
                    Image(.logo)
                        .font(.system(size: 80))
                        .foregroundColor(.red)
                        .padding(.vertical, 40)
                            
                    Text("Proactive")
                        .font(.system(size:50))
                        
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 1.2)) {
                        self.size = 0.9
                        self.opacity = 1.00
                    }
                }
            }
            .frame(maxHeight: .infinity,alignment: .top)
                
            
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
