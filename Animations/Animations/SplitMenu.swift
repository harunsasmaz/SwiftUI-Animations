//
//  SplitMenu.swift
//  Animations
//
//  Created by Harun Sasmaz on 30.09.2020.
//  Copyright © 2020 Harun Sasmaz. All rights reserved.
//

import SwiftUI

struct SplitMenu: View {
    
    @State var animationOne: Bool = false
    @State var animationTwo: Bool = false
    
    var body: some View {
        
        ZStack {
            ZStack {
                Square(animationOne: $animationOne, animationTwo: $animationTwo)
                Image(systemName: "plus")
                    .resizable()
                    .foregroundColor(.white)
                    .frame(width: 25, height: 25, alignment: .center)
            }
            .frame(width: 50, height: 50)
            .rotationEffect(.degrees(self.animationOne ? 45 : 0))
            .animation(Animation.linear.delay(self.animationOne ? 0 : 0.4))
            .onTapGesture {
                withAnimation {
                    if !self.animationOne {
                        self.animationTwo.toggle()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            self.animationOne.toggle()
                        }
                    } else {
                        self.animationOne.toggle()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                            self.animationTwo.toggle()
                        }
                    }
                }
            }
        }
    }
}

struct Square: View {
    
    @Binding var animationOne: Bool
    @Binding var animationTwo: Bool
    let imagename = ["gear", "envelope.circle", "pencil", "person"]
    
    var body: some View {
        
        ForEach(0..<4, id: \.self) { i in
            ZStack {
                Rectangle()
                    .cornerRadius(15)
                    .foregroundColor(.purple)
                    .frame(width: 50, height: 50, alignment: .center)
                Image(systemName: self.imagename[i])
                    .resizable()
                    .foregroundColor(.white)
                    .frame(width: 27, height: 27, alignment: .center)
                    .opacity(self.animationOne ? 1 : 0)
                    .animation(Animation.spring().delay(self.animationOne ? 0.4 : 0))
                    .rotationEffect(.degrees(-45))
            }
            .scaleEffect(self.animationOne ? 1 : 0.65)
            .animation(Animation.spring().delay(self.animationOne ? 0.4 : 0))
            .offset(x: self.offsetX(i: i), y: self.offsetY(i: i))
            .animation(Animation.spring().delay(self.animationOne ? 0.4 : 0))

        }
    }
    
    func offsetX(i: Int) -> CGFloat {
        
        if self.animationTwo {
            if self.animationOne  {
                if i == 0 || i == 2 {
                    return -50
                } else {
                    return 50
                }
            } else {
                if i == 0 || i == 2 {
                    return -20
                } else {
                    return 20
                }
            }
        } else {
            if i == 0 || i == 2 {
                return -8
            } else {
                return 8
            }
        }
    }
    
    func offsetY(i: Int) -> CGFloat {
        
        if self.animationTwo {
            if self.animationOne  {
                if i == 0 || i == 1 {
                    return -50
                } else {
                    return 50
                }
            } else {
                if i == 0 || i == 1 {
                    return -20
                } else {
                    return 20
                }
            }
        } else {
            if i == 0 || i == 1 {
                return -8
            } else {
                return 8
            }
        }
    }
}

struct SplitMenu_Previews: PreviewProvider {
    static var previews: some View {
        SplitMenu()
    }
}
