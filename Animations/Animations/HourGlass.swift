//
//  HourGlass.swift
//  Animations
//
//  Created by Harun Sasmaz on 12.11.2020.
//  Copyright © 2020 Harun Sasmaz. All rights reserved.
//

import SwiftUI

struct HourGlassView: View {
    var body: some View {
        ZStack {
            Color(red: 0.189, green: 0.187, blue: 0.256)
                .edgesIgnoringSafeArea(.all)
            Circle()
                .frame(width: 300, height: 300)
                .foregroundColor(.white)
            HourGlass(hourglassSize: 130, glassColor: .black, sandColor: Color(red: 0.96, green: 0.84, blue: 0.69))
        }
    }
}

struct HourGlass: View {
    
    let hourglassSize: CGFloat
    let glassColor: Color
    let sandColor: Color
    
    @State private var topOffset: CGFloat = 0
    @State private var middleOffset: CGFloat = 0
    @State private var bottomOffset: CGFloat = 0
    
    @State private var rotation: Double = 0
    
    var body: some View {
        ZStack {
            ZStack {
                Rectangle()
                    .frame(width: hourglassSize, height: hourglassSize / 2)
                    .foregroundColor(sandColor)
                    .offset(y: topOffset)
                    .mask(
                        Rectangle()
                            .frame(width: hourglassSize, height: hourglassSize / 2)
                    )
                    .offset(y: -hourglassSize / 4 - hourglassSize * 0.03)

                Rectangle()
                    .frame(width: hourglassSize * 0.07, height: hourglassSize / 2)
                    .foregroundColor(sandColor)
                    .offset(y: middleOffset)

                Rectangle()
                    .frame(width: hourglassSize, height: hourglassSize / 2)
                    .foregroundColor(sandColor)
                    .offset(y: bottomOffset)
                    .mask(
                        Rectangle()
                            .frame(width: hourglassSize, height: hourglassSize / 2)
                    )
                    .offset(y: hourglassSize / 4 + hourglassSize * 0.03)

            }
            .mask(
                HourGlassShape()
                    .frame(width: hourglassSize * 0.8, height: hourglassSize)
            )
            
            HourGlassShape()
                .stroke(glassColor, style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                .frame(width: hourglassSize * 0.8, height: hourglassSize)
                
        }
        .rotationEffect(.degrees(rotation))
        .onAppear {
            bottomOffset = hourglassSize / 2
            middleOffset = -hourglassSize / 4 - hourglassSize * 0.03
        }
        .onTapGesture(count: 1, perform: {
            startAnimation()
            Timer.scheduledTimer(withTimeInterval: 1.8, repeats: true) { _ in
                startAnimation()
            }
        })
    }
    
    func startAnimation() {
        withAnimation(Animation.linear(duration: 0.15)) {
            middleOffset = (hourglassSize / 4) - hourglassSize * 0.03
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.95) {
            withAnimation(Animation.linear(duration: 0.25)) {
                middleOffset += (hourglassSize / 4)
            }
        }
        withAnimation(Animation.linear(duration: 1)) {
            topOffset = hourglassSize / 2
        }
        withAnimation(Animation.linear(duration: 1).delay(0.15)) {
            bottomOffset = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
            withAnimation(Animation.easeInOut(duration: 0.3)) {
                rotation = 180
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                rotation = 0
                topOffset = 0
                bottomOffset = hourglassSize / 2
                middleOffset = -hourglassSize / 4 - hourglassSize * 0.03
            }
        }
    }
    
}

struct HourGlassShape: Shape {
    func path(in rect: CGRect) -> Path {
        
        let midTopY = rect.midY - (rect.maxY * 0.03)
        let midBotT = rect.midY + (rect.maxY * 0.03)
        
        let midLeftX = rect.midX - (rect.maxY * 0.05)
        let midRightX = rect.midX + (rect.maxY * 0.05)
        
        var path = Path()
        
        let r: CGFloat = rect.maxY / 10
        
        let rcd = sqrt(((sqrt((r*r) + (r*r)) - r)*(sqrt((r*r) + (r*r)) - r)) / 2)
        
        let trs = CGPoint(x: rect.maxX - r, y: rect.minY)
        let trc = CGPoint(x: rect.maxX - r, y: rect.minY + r)
        let brs = CGPoint(x: rect.maxX - rcd, y: rect.maxY - r - ( r - rcd))
        let brc = CGPoint(x: rect.maxX - r, y: rect.maxY - r)
        
        let bls = CGPoint(x: rect.minX + r, y: rect.maxY)
        let blc = CGPoint(x: rect.minX + r, y: rect.maxY - r)
        let tls = CGPoint(x: rect.minX + rcd, y: rect.minY + r + (r - rcd))
        let tlc = CGPoint(x: rect.minX + r, y: rect.minY + r)
        
        path.move(to: trs)
        path.addRelativeArc(center: trc, radius: r, startAngle: Angle.degrees(270), delta: Angle.degrees(135))
        path.addLine(to: CGPoint(x: midRightX, y: midTopY))
        path.addLine(to: CGPoint(x: midRightX, y: midBotT))
        path.addLine(to: brs)
        path.addRelativeArc(center: brc, radius: r, startAngle: Angle.degrees(315), delta: Angle.degrees(135))
        path.addLine(to: bls)
        path.addRelativeArc(center: blc, radius: r, startAngle: Angle.degrees(90), delta: Angle.degrees(135))
        path.addLine(to: CGPoint(x: midLeftX, y: midBotT))
        path.addLine(to: CGPoint(x: midLeftX, y: midTopY))
        path.addLine(to: tls)
        path.addRelativeArc(center: tlc, radius: r, startAngle: Angle.degrees(135), delta: Angle.degrees(135))
        path.addLine(to: trs)
        
        return path
    }
}

struct HourGlass_Previews: PreviewProvider {
    static var previews: some View {
        HourGlassView()
    }
}
