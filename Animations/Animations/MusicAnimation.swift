//
//  MusicAnimation.swift
//  Animations
//
//  Created by Harun Sasmaz on 30.09.2020.
//  Copyright © 2020 Harun Sasmaz. All rights reserved.
//

import SwiftUI

struct Bar: Identifiable, Hashable {
    var id: Int
    var height: CGFloat
}

class BarManager: ObservableObject {
    @Published var bars: [Bar] = []
}

struct MusicAnimation: View {
    @ObservedObject var barManager = BarManager()
    
    var body: some View {
        ZStack {
            Circle()
                .frame(width: circleSize, height: circleSize)
                .foregroundColor(circleColor)
            HStack {
                ForEach(1..<(barManager.bars.count + 1)) { i in
                    ZStack {
                        LinearGradient(gradient: Gradient(colors: [self.topColor, self.bottomColor]), startPoint: .top, endPoint: .bottom)
                            .frame(width: self.barWidth, height: self.barMaxHeight)
                            .mask(
                                ZStack {
                                    Capsule()
                                        .frame(width: self.barWidth, height: self.barManager.bars[i - 1].height)
                                }
                                .frame(height: self.barMaxHeight, alignment: .bottom)
                            )
                    }
                }
            }
        }
        .onAppear {
            self.startAnimation()
        }
    }
    
    init() {
        for i in 0..<4 {
            barManager.bars.append(Bar(id: i, height: barMinHeight))
        }
    }
    
    // MARK: - Drawing constants
    let topColor: Color = Color(red: 0.51, green: 0.20, blue: 0.69)
    let bottomColor: Color = Color(red: 0.32, green: 0.36, blue: 0.83)
    let circleColor: Color = Color(red: 0.189, green: 0.187, blue: 0.256)
    
    let circleSize: CGFloat = 200
    let barMaxHeight: CGFloat = 100
    let barMinHeight: CGFloat = 50
    let barWidth: CGFloat = 20
    let loopTime: Double = 1.5
    
    
    // MARK: - Functions
    func startAnimation() {
        for i in 1..<(barManager.bars.count + 1) {
            let speedUp = (loopTime / 3) / Double(i)
            let speedDown = speedUp * 3
            Timer.scheduledTimer(withTimeInterval: speedUp + speedDown, repeats: true) { _ in
                withAnimation(Animation.linear(duration: speedUp)) {
                    self.barManager.bars[i - 1].height = self.barMaxHeight
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + speedUp) {
                    withAnimation(Animation.linear(duration: speedDown)) {
                        self.barManager.bars[i - 1].height = self.barMinHeight
                    }
                }
            }
        }
    }
}

struct SoundVisualizer_Previews: PreviewProvider {
    static var previews: some View {
        MusicAnimation()
    }
}
