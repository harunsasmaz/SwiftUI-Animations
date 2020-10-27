//
//  SearchBar.swift
//  Animations
//
//  Created by Harun Sasmaz on 27.10.2020.
//  Copyright © 2020 Harun Sasmaz. All rights reserved.
//

import SwiftUI

struct SearchBox: View {
    
    @State private var searchText = ""
    @State private var seaching = false
    @State private var animating = false
    
    @State private var searchWidth: CGFloat = 0
    @State private var searchHeight: CGFloat = 0
    
    @State private var handleOffset: CGFloat = 0
    @State private var handleLength: CGFloat = 0
    
    
    var body: some View {
        VStack {
            ZStack {
                Capsule()
                    .stroke(lineWidth: lineWidth)
                    .frame(width: searchWidth, height: searchHeight)
                TextField("", text: $searchText)
                    .frame(width: searchWidth * 0.8, height: searchHeight * 0.9)
                
                ZStack {
                    Circle()
                        .frame(width: searchHeight, height: searchHeight)
                        .foregroundColor(.clear)
                    Capsule()
                        .frame(width: lineWidth, height: searchHeight / 1.5)
                        .offset(x: 0, y: handleOffset)
                        .rotationEffect(.degrees(-45))
                    Capsule()
                        .frame(width: lineWidth, height: handleLength)
                        .rotationEffect(.degrees(90))
                        .offset(x: 0, y: handleOffset)
                        .rotationEffect(.degrees(-45))
                }
                .offset(x: (searchWidth / 2) - (searchHeight / 2), y: 0)
                .onTapGesture {
                    if seaching && !animating {
                        clearText()
                        endSeaching()
                    }
                }
            }
            .onTapGesture {
                if !seaching && !animating {
                    startSeaching()
                }
            }
        }
        .onAppear {
            searchWidth = searchSize / 4
            searchHeight = searchSize / 4
            handleOffset = (5 * (searchSize / 4)) / 6
        }
    }

    
    //MARK: -Drawing constants
    let searchSize: CGFloat = 200
    let lineWidth: CGFloat = 5
    
    //MARK: - Functions
    
    func clearText() {
        searchText = ""
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func startSeaching() {
        animating = true
        seaching = true
        withAnimation(Animation.easeInOut(duration: 0.5)) {
            searchWidth = searchSize
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(Animation.easeInOut(duration: 0.3)) {
                handleOffset = 0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(Animation.easeInOut(duration: 0.3)) {
                    handleLength = searchHeight / 1.5
                }
                animating = false
            }
        }
    }
    func endSeaching() {
        animating = true
        seaching = false
        withAnimation(Animation.easeInOut(duration: 0.3)) {
            handleLength = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(Animation.easeInOut(duration: 0.3)) {
                handleOffset = (5 * searchHeight) / 6
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(Animation.easeInOut(duration: 0.5)) {
                    searchWidth = searchSize / 4
                    animating = false
                }
            }
        }
    }
}

struct SearchBox_Previews: PreviewProvider {
    static var previews: some View {
        SearchBox()
    }
}

