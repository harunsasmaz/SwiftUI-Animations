//
//  PlaneLoading.swift
//  Animations
//
//  Created by Harun Sasmaz on 30.09.2020.
//  Copyright © 2020 Harun Sasmaz. All rights reserved.
//

import SwiftUI

struct PlaneLoading: View {
    
    @State private var rotation: Double = 0
    
    var body: some View {
        
        ZStack {
            Color.blue.edgesIgnoringSafeArea(.all)
            LinearGradient(gradient: Gradient(colors: [.white, .blue]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
                .opacity(0.7)
            Circle()
                .stroke()
                .frame(width: 200, height: 200)
                .foregroundColor(.white)
                
            Image(systemName: "cloud.fill")
                .resizable()
                .frame(width: 140, height: 100)
                .foregroundColor(.white)
            Text("Loading...")
                .italic()
                .bold()
                .offset(y: 10)
            Image(systemName: "airplane")
                .resizable()
                .frame(width: 50, height: 50)
                .offset(y: -100)
                .rotationEffect(.degrees(self.rotation))
                .animation(Animation.linear(duration: 3)
                    .repeatForever(autoreverses: false))
                .foregroundColor(.white)
        }
        .onAppear{
            self.rotation = 360
        }
    }
}

struct PlaneLoading_Previews: PreviewProvider {
    static var previews: some View {
        PlaneLoading()
    }
}
