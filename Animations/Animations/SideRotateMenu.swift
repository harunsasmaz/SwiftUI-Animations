//
//  SideRotateMenu.swift
//  Animations
//
//  Created by Harun Sasmaz on 30.09.2020.
//  Copyright © 2020 Harun Sasmaz. All rights reserved.
//

import SwiftUI

struct SideRotateMenu: View {
    
    @State var rotation: Double = 0.0
    let imagename = ["gear", "person", "envelope.circle", "pencil", "trash"]
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(.white)
                .frame(width: 250, height: 250)
                .shadow(radius: 5)
            
            ForEach(0..<5, id: \.self) { i in
                ZStack {
                    Circle()
                        .foregroundColor(.purple)
                        .shadow(radius: 5)
                    
                    Image(systemName: self.imagename[i])
                }
                .frame(width: 50, height: 50)
                .offset(x: -75, y: 0)
                .rotationEffect(.degrees(self.rotation + Double(i * 72)))
            
            }
        }
        .frame(width: 250, height: 250)
        .offset(x: UIScreen.main.bounds.width/2, y: 0)
        .gesture(
            DragGesture()
                .onEnded() { gesture in
                    if gesture.translation.height > 0 {
                        withAnimation(.linear(duration: 0.3)) {
                            self.rotation -= 72
                        }
                    } else {
                        withAnimation(.linear(duration: 0.3)) {
                            self.rotation += 72
                        }
                    }
            }
        )
    }
}

struct RotateMenu: View {
    @State private var offset = false
    var body: some View {
        ZStack {
            SideRotateMenu()
                .offset(x: offset ? 0 : 100, y: 0)
                .onTapGesture {
                    withAnimation(.linear(duration: 0.3)) {
                        self.offset.toggle()
                    }
            }
        }
    }
}

struct SideRotateMenu_Previews: PreviewProvider {
    static var previews: some View {
        RotateMenu()
    }
}
