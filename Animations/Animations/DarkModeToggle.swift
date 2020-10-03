//
//  DarkModeToggle.swift
//  Animations
//
//  Created by Harun Sasmaz on 30.09.2020.
//  Copyright © 2020 Harun Sasmaz. All rights reserved.
//

import SwiftUI

struct DarkModeToggle: View {
    let darkBackground = Color(red: 0.189, green: 0.187, blue: 0.256)
    
    @State private var offsetGray: CGFloat = 0
    @State private var offsetGreen: CGFloat = 0
    
    @State private var offsetRect: CGFloat = 0
    
    @State private var darkmode = false
    @State private var toggled = false
    @State private var animating = false
    
    var body: some View {
        ZStack {
            if darkmode {
                darkBackground.edgesIgnoringSafeArea(.all)
            } else {
                Color.white.edgesIgnoringSafeArea(.all)
            }

            Capsule()
                .frame(width: toggleSize + buttonPadding, height: (toggleSize / 2) + buttonPadding)
                .foregroundColor(.gray)
            ZStack {
                Rectangle()
                    .frame(width: toggleSize, height: toggleSize / 2)
                    .opacity(0)
                if toggled {
                    ButtonOff(size: toggleSize)
                        .offset(x: offsetGray, y: 0)
                    ButtonOn(size: toggleSize)
                        .offset(x: offsetGreen, y: 0)
                } else {
                    ButtonOn(size: toggleSize)
                        .offset(x: offsetGreen, y: 0)
                    ButtonOff(size: toggleSize)
                        .offset(x: offsetGray, y: 0)
                }
            }
            .mask(Rectangle().offset(x: self.offsetRect, y: 0))
            .offset(x: -self.toggleSize / 4, y: 0)
        }
        .onAppear {
            self.offsetGreen = 0
            self.offsetGray = -self.toggleSize / 2
            self.offsetRect = self.toggleSize / 4
        }
        .onTapGesture {
            if !self.animating {
                withAnimation {
                    self.darkmode.toggle()
                }
                self.animating = true
                if self.toggled {
                    self.offsetGreen = self.toggleSize
                    self.offsetGray = self.toggleSize / 2
                    self.offsetRect = self.toggleSize / 4
                    withAnimation(Animation.easeIn) {
                        self.offsetGreen = 0
                        self.offsetRect = -self.toggleSize / 4
                    }
                } else {
                    self.offsetGreen = 0
                    self.offsetGray = -self.toggleSize / 2
                    self.offsetRect = self.toggleSize / 4
                    withAnimation(Animation.easeIn) {
                        self.offsetGray = self.toggleSize / 2
                        self.offsetRect = self.toggleSize * 0.75
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.toggled.toggle()
                    self.animating = false
                }
            }
        }
        .preferredColorScheme(self.darkmode ? .dark : .light)
    }
    
    let toggleSize: CGFloat = 120
    let buttonPadding: CGFloat = 10
    let toggleSwitchSize: CGFloat = 75
}

struct ButtonOn: View {
    
    @State var size: CGFloat
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(Color(red: 0.67, green: 0.81, blue: 1.00))
                .frame(width: size / 2, height: size / 2)
            Image(systemName: "sun.max.fill")
                .resizable()
                .foregroundColor(.yellow)
                .frame(width: size / 4, height: size / 4)
            Image(systemName: "cloud.fill")
                .resizable()
                .foregroundColor(.white)
                .frame(width: size / 6, height: size / 8)
                .offset(x: size / 10, y: size / 10)
        }
    }
}

struct ButtonOff: View {
    
    @State var size: CGFloat
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(.black)
                .frame(width: size / 2, height: size / 2)
            Image(systemName: "moon.fill")
                .resizable()
                .foregroundColor(.white)
                .frame(width: size / 4, height: size / 4)
            Image(systemName: "star.fill")
                .resizable()
                .foregroundColor(.yellow)
                .frame(width: size / 20, height: size / 20)
                .offset(x: size / 6, y: 0)
            Image(systemName: "star.fill")
                .resizable()
                .foregroundColor(.yellow)
                .frame(width: size / 20, height: size / 20)
                .offset(x: size / 15, y: -size / 8)
        }
    }
}

struct DarkModeToggle_Previews: PreviewProvider {
    static var previews: some View {
        DarkModeToggle()
    }
}
