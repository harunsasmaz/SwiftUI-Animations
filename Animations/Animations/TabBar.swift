//
//  TabBar.swift
//  Animations
//
//  Created by Harun Sasmaz on 3.10.2020.
//  Copyright © 2020 Harun Sasmaz. All rights reserved.
//

import SwiftUI

struct TabBar: View {
    let darkBackground = UIColor(red: 0.189, green: 0.187, blue: 0.256, alpha: 1.0)

    @ObservedObject var tabItems = TabItems.shared
    
    @State private var circleSize: CGFloat = 50
    @State private var iconeSize: CGFloat = 30
    
    var body: some View {
        ZStack {
            Color(darkBackground)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                ZStack {
                    MyBar(tab: tabItems.selectedTabIndex)
                        .foregroundColor(.white)
                        .frame(width: UIScreen.main.bounds.width, height: 100)
                    HStack(spacing: (UIScreen.main.bounds.width - (CGFloat(TabItems.shared.items.count + 1) * self.circleSize)) / (CGFloat(TabItems.shared.items.count) + 1)) {
                        ForEach(0..<tabItems.items.count, id: \.self) { i in
                            ZStack {
                                Circle()
                                    .frame(width: self.circleSize, height: self.circleSize)
                                    .foregroundColor(.white)
                                    .onTapGesture {
                                        self.tabItems.select(i)
                                        
                                        // Code to change tab screen can go here...
                                        
                                    }
                                Image(systemName: self.tabItems.items[i].imageName)
                                    .resizable()
                                    .foregroundColor(Color(self.darkBackground))
                                    .frame(width: self.iconeSize, height: self.iconeSize)
                                    .opacity(self.tabItems.items[i].opacity)
                            }
                            .offset(y: self.tabItems.items[i].offset)
                            
                        }
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
    }
}

// MARK - Overriden Bar Struct

struct MyBar: Shape {
    var tab: CGFloat
    
    var animatableData: Double {
        get { return Double(tab) }
        set { tab = CGFloat(newValue) }
    }
    
    func path(in rect: CGRect) -> Path {
        
        var path = Path()
        
        let widthFactor = rect.maxX/(CGFloat(TabItems.shared.items.count) + 1)
        let widthFactorTimesCount = (rect.maxX/(CGFloat(TabItems.shared.items.count) + 1)) * tab
        
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: widthFactorTimesCount + widthFactor, y: rect.minY))
        path.addCurve(to: CGPoint(x: widthFactorTimesCount, y: rect.midY),
                      control1: CGPoint(x: widthFactorTimesCount + 40, y: rect.minY),
                      control2: CGPoint(x: widthFactorTimesCount + 40, y: rect.minY + 50))
        path.addCurve(to: CGPoint(x: widthFactorTimesCount - widthFactor, y: rect.minY),
                      control1: CGPoint(x: widthFactorTimesCount - 40, y: rect.minY + 50),
                      control2: CGPoint(x: widthFactorTimesCount - 40, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - widthFactorTimesCount, y: rect.minY))
        return path
    }
}

// MARK - Tab Item Class

class TabItem: Identifiable, ObservableObject {
    let id = UUID().uuidString
    let imageName: String
    var offset: CGFloat = -10
    var opacity: Double = 1
    
    init(imageName: String, offset: CGFloat) {
        self.imageName = imageName
        self.offset = offset
    }
    init(imageName: String) {
        self.imageName = imageName
    }
    static func == (lhs: TabItem, rhs: TabItem) -> Bool {
        lhs.id <= rhs.id
    }
}

// MARK - Tab Items Class

class TabItems: ObservableObject {
    static let shared = TabItems()
    
    @Published var items: [TabItem] = [
        TabItem(imageName: "house.fill", offset: -40),
        TabItem(imageName: "magnifyingglass"),
        TabItem(imageName: "plus.app"),
        TabItem(imageName: "heart"),
        TabItem(imageName: "person.fill"),
    ]
    
    @Published var selectedTabIndex: CGFloat = 1
    
    func select(_ index: Int) {
        let tabItem = items[index]
        
        tabItem.opacity = 0
        tabItem.offset = 30
        
        withAnimation(Animation.easeInOut) {
            selectedTabIndex = CGFloat(index + 1)
            for i in 0..<items.count {
                if i != index {
                    items[i].offset = -10
                }
            }
        }
        withAnimation(Animation.easeOut(duration: 0.2).delay(0.2)) {
            tabItem.opacity = 1
            tabItem.offset = -40
        }
    }
}
