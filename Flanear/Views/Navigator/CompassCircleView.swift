//
//  CompassCircleView.swift
//  Flanear
//
//  Created by Mattia Fochesato on 11/02/22.
//

import SwiftUI
import CoreLocation

struct CompassCircleView: View {
    @Binding var degrees: Double// = .zero
    @Binding var near: Double//= 1
    @Binding var distance: CLLocationDistance
    @Binding var placeName: String
    var body: some View {
        ZStack {
            Triangle()
                .fill(Color("TextDarkBlue"))
                .frame(width: 70, height: 50)
#if os(watchOS)
                .padding(.bottom, 10)
            #else
                .padding(.bottom, 350)
            #endif
                .rotationEffect(Angle(degrees: degrees))
                //.animation(.linear)
            
            ZStack {
                Circle()
                    .stroke(Color.white, lineWidth: 30)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [.blue, .clear]), startPoint: .top, endPoint: .bottom)
                            .clipShape(Circle())
                    )
                
                Circle()
                    .trim(from: 0, to: getBarWidth())
                    .stroke(Color.blue, lineWidth: 15)
                    .rotationEffect(getRotationBar())
                    //.animation(.linear)
                
                VStack {
                    Text("\(Int(distance))m")
                        .foregroundColor(Color("TextDarkBlue"))
                        .font(.largeTitle)
                        .bold()
                    Text(placeName)
                        .font(.title2)
                        .foregroundColor(Color("TextDarkBlue"))
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

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))

        return path
    }
    
    /*
     arc:
     func path(in rect: CGRect) -> Path {
         let rotationAdjustment = Angle.degrees(90)
         let modifiedStart = startAngle - rotationAdjustment
         let modifiedEnd = endAngle - rotationAdjustment

         var path = Path()
         path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width / 2, startAngle: modifiedStart, endAngle: modifiedEnd, clockwise: !clockwise)

         return path
     }
     */
}

struct CompassCircleView_Previews: PreviewProvider {
    static var previews: some View {
        CompassCircleView(degrees: .constant(.zero), near: .constant(1), distance: .constant(100), placeName: .constant("San Giorgio"))
            //.background(.yellow)
    }
}
