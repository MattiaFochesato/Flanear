//
//  CompassCircleView.swift
//  Flanear
//
//  Created by Mattia Fochesato on 11/02/22.
//

import SwiftUI
import CoreLocation

struct CompassCircleView: View {
#if os(watchOS)
    let isWatch = true
#else
    let isWatch = false
#endif
    
    @Binding var degrees: Double?// = .zero
    @Binding var near: Double//= 1
    @Binding var distance: CLLocationDistance
    @Binding var placeName: String?
    var body: some View {
        ZStack {
            #if os(iOS)
            if let degrees = degrees {
                Triangle()
                .stroke(style: StrokeStyle(lineWidth: 12, lineJoin: .round))
                .fill(Color("PaletteLightBlue"))
                 .frame(width: 60, height: 40)
                 .padding(.bottom, 300)
                 .rotationEffect(Angle(degrees: degrees))
                
                Triangle()
                 .fill(Color("PaletteLightBlue"))
                 .frame(width: 60, height: 40)
                 .padding(.bottom, 300)
                 .rotationEffect(Angle(degrees: degrees))
                
            }
             //.animation(.linear)
            #endif
            
            ZStack {
                Circle()
                    .stroke(Color.white, lineWidth: !isWatch ? 30 : 12)
                    .background(Color("PaletteYellow").opacity(0.5))
                            .clipShape(Circle())
                            
                        Circle()
                    .stroke(.black, lineWidth: 30)
                    .foregroundColor(.clear)
                
                        Circle()
                    .stroke(.white, lineWidth: 27)
                    .foregroundColor(.clear)
                   
                    
                
                Circle()
                    .trim(from: 0, to: getBarWidth())
                    .stroke(Color("PaletteLightBlue"), lineWidth: !isWatch ? 23 : 8)
                    .rotationEffect(getRotationBar())
                //.animation(.linear)
                
                VStack {
                    Text("\(Int(distance))m")
                        .foregroundColor(!isWatch ? Color(.black) : .white)
                        .font(!isWatch ? .largeTitle : .title2)
                        .fontWeight(.black)
                        .minimumScaleFactor(0.6)
                        .padding([.leading, .trailing], 20)
                    
                }
                
            }
#if os(iOS)
            .frame(width: 200, height: 200, alignment: .center)
#endif
        }
#if os(iOS)
        .frame(width: 200, height: 200, alignment: .center)
#endif
    }
    
    func getBarWidth() -> CGFloat {
        return 0.35
    }
    
    func getRotationBar() -> Angle {
        guard let degrees = degrees else {
            return Angle(degrees: -90)
        }

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
        path.closeSubpath()
        
        return path
    }
    
}

struct CompassCircleView_Previews: PreviewProvider {
    static var previews: some View {
        CompassCircleView(degrees: .constant(.zero), near: .constant(1), distance: .constant(100), placeName: .constant("San Giorgio"))
        //.background(.yellow)
        //.previewDevice("Apple Watch Series 7 - 45mm")
    }
}
