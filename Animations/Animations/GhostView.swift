//
//  GhostView.swift
//  Animations
//
//  Created by Harun Sasmaz on 22.10.2020.
//  Copyright © 2020 Harun Sasmaz. All rights reserved.
//

import SwiftUI

struct Ghost: Shape {
    var time: CGFloat
    let width: CGFloat
    let height: CGFloat
    let curveHeight: CGFloat
    let curveLength: CGFloat
    
    func path(in rect: CGRect) -> Path {
        return (
            Path { path in
                path.move(to: CGPoint(x: rect.maxX, y: rect.minY))
                path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
                for i in stride(from: 0, to: CGFloat(rect.width), by: 1) {
                    path.addLine(to: CGPoint(x: i, y: sin(((i / rect.height) + time) * curveLength * .pi) * curveHeight + rect.midY))
                }
                path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            }
        )
    }
}

struct GhostView: View {
    
    @State private var time: Double = 0
    @State private var offset: CGFloat = 0
    @State private var shadowSize: CGFloat = 10
    
    var body: some View {
        ZStack {
            Circle()
                .frame(width: backgroundSize, height: backgroundSize)
                .foregroundColor(Color(red: 0.189, green: 0.187, blue: 0.256))
            Circle()
                .trim(from: 3/4, to: 1)
                .frame(width: backgroundSize, height: backgroundSize)
                .foregroundColor(.white)
                .rotationEffect(.degrees(135))
                .offset(y: 1)
            Circle()
                .frame(width: ghostSize - shadowSize, height: ghostSize - shadowSize)
                .rotation3DEffect(.degrees(80), axis: (x: 1.0, y: 0.0, z: 0.0))
                .offset(x: 0, y: ghostSize / 1.6)
                .blur(radius: 3)
            ZStack {
                Ghost(time: CGFloat(time), width: ghostSize, height: ghostSize * 2.5, curveHeight: ghostCurveHeight, curveLength: ghostCurveLength)
                    .foregroundColor(.white)
                    .mask(Capsule().frame(width: ghostSize, height: ghostSize * 2.5))
                    .offset(x: 0, y: ghostSize / 2)
                Circle()
                    .frame(width: ghostSize / 6, height: ghostSize / 6)
                    .offset(x: 0, y: -(ghostSize / 3))
                Circle()
                    .frame(width: ghostSize / 6, height: ghostSize / 6)
                    .offset(x: ghostSize / 3.75, y: -(ghostSize / 3))
                Circle()
                    .frame(width: ghostSize / 10, height: ghostSize / 10)
                    .offset(x: ghostSize / 5, y: -(ghostSize / 7.5))
            }
            .offset(y: offset)
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { _ in
                self.time += 0.004
            }
            withAnimation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                offset += -30
                shadowSize = 30
            }
        }
    }
    
    //MARK: - Drawing constant
    let backgroundSize: CGFloat = 350
    let ghostSize: CGFloat = 150
    let ghostCurveHeight: CGFloat = 10
    let ghostCurveLength: CGFloat = 12
}

struct Ghost_Previews: PreviewProvider {
    static var previews: some View {
        GhostView()
    }
}
