//
//  CCircleView.swift
//  FlanearWatch WatchKit Extension
//
//  Created by Mattia Fochesato on 17/02/22.
//
/*

import SwiftUI
import CoreLocation

struct CCircleView: View {
    #if os(watchOS)
    let isWatch = true
    #else
    let isWatch = false
    #endif
    
    @Binding var degrees: Double// = .zero
    @Binding var near: Double//= 1
    @Binding var distance: CLLocationDistance
    @Binding var placeName: String
    var body: some View {
        ZStack {
            /*Triangle()
                .fill(Color("TextDarkBlue"))
                .frame(width: 70, height: 50)
#if os(watchOS)
                .padding(.bottom, 10)
            #else
                .padding(.bottom, 350)
            #endif
                .rotationEffect(Angle(degrees: degrees))
                //.animation(.linear)*/
            
            ZStack {
                Circle()
                    .stroke(Color.white, lineWidth: !isWatch ? 30 : 12)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [.blue, .clear]), startPoint: .top, endPoint: .bottom)
                            .clipShape(Circle())
                    )
                
                Circle()
                    .trim(from: 0, to: getBarWidth())
                    .stroke(Color.blue, lineWidth: !isWatch ? 15 : 8)
                    .rotationEffect(getRotationBar())
                    //.animation(.linear)
                
                VStack {
                    Text("\(Int(distance))m")
                        .foregroundColor(!isWatch ? Color("TextDarkBlue") : .white)
                        .font(!isWatch ? .largeTitle : .title2)
                        .bold()
                        .minimumScaleFactor(0.6)
                        .padding([.leading, .trailing], 20)
                        
                    if !isWatch {
                        Text(placeName)
                            .font(.title2)
                            .foregroundColor(Color("TextDarkBlue"))
                    }
                }
                
            }
#if os(iOS)
            .frame(width: 300, height: 300, alignment: .center)
            #endif
        }
#if os(iOS)
            .frame(width: 300, height: 300, alignment: .center)
            #endif
    }
    
    func getBarWidth() -> CGFloat {
        return 0.35
    }
    
    func getRotationBar() -> Angle {
        let width = getBarWidth() / 2
        let deg = radiansToDegrees(radians: width * .pi * 2)
        
        return Angle(degrees: -90 - deg + degrees)
    }
    
    func radiansToDegrees(radians: Double) -> Double { return radians * 180.0 / .pi }
}

struct CCircleView_Previews: PreviewProvider {
    static var previews: some View {
        /*CCircleView(degrees: .constant(.zero), near: .constant(1), distance: .constant(100), placeName: .constant("San Giorgio"))*/
        NavigatorView()
            //.background(.yellow)
            .previewDevice("Apple Watch Series 7 - 45mm")
    }
}*/
