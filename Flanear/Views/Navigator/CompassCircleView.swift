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
    @Binding var arrived: Bool
    var body: some View {
        ZStack {
            if !arrived {
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
#else
                EmptyView()
#endif
            }else{
                ZStack(alignment: !isWatch ? .top : .center) {
                    Image(systemName: "checkmark")
                        .font(.largeTitle.bold())
                        .foregroundColor(Color("PaletteLightBlue"))
                        .padding(8)
                        .background(Circle()
                                        .foregroundColor(.white)
                        )
                    if !isWatch {
                        Circle()
                            .stroke(.black, lineWidth: 2)
                            .foregroundColor(.clear)
                    }
                    
                    Color.clear
                }.zIndex(1001)
                    .padding(.bottom, !isWatch ? 200 : 0)
            }
            
            ZStack {
                Circle()
                    .stroke(Color.white, lineWidth: !isWatch ? 30 : 12)
                    .background(Color("PaletteYellow").opacity(0.5))
                    .clipShape(Circle())
                
                Circle()
                    .stroke(.black, lineWidth: !isWatch ? 30 : 12)
                    .foregroundColor(.clear)
                
                Circle()
                    .stroke(.white, lineWidth: !isWatch ? 27 : 10)
                    .foregroundColor(.clear)
                
                
                
                Circle()
                    .trim(from: 0, to: getBarWidth())
                    .stroke(Color("PaletteLightBlue"), lineWidth: !isWatch ? 23 : 8)
                    .rotationEffect(getRotationBar())
                //.animation(.linear)
                
                VStack {
                    if !arrived {
                        Text("\(Int(distance))m")
                            .foregroundColor(!isWatch ? Color(.black) : .white)
                            .font(!isWatch ? .largeTitle : .title2)
                            .fontWeight(.black)
                            .minimumScaleFactor(0.6)
                            .padding([.leading, .trailing], 20)
                    }else{
                        Image("theater")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                        Text(placeName ?? "nil")
                            .foregroundColor(!isWatch ? Color(.black) : .white)
                            .font(!isWatch ? .body : .body)
                            .fontWeight(.black)
                            .minimumScaleFactor(0.4)
                            .lineLimit(3)
                            .multilineTextAlignment(.center)
                            .padding([.leading, .trailing], 20)
                    }
                }.offset(y: arrived ? -15 : 0)
                
                if arrived && !isWatch{
                    
                    ZStack(alignment: .bottom) {
                        Button {
                            print("open camera and save")
                        } label: {
                            Image(systemName: "camera")
                                .font(.system(size: 50, weight: .bold))
                                .foregroundColor(Color("PaletteLightBlue"))
                                .padding(16)
                                .background(Circle()
                                    .foregroundColor(.white)
                                )
                        }.zIndex(2)
                        
                        Circle()
                            .stroke(.black, lineWidth: 3)
                            .foregroundColor(.clear)
                            .shadow(color: .black, radius: 2, x: 2, y: 0)
                        
                        Color.clear
                    }.zIndex(1001)
                        .padding(.top, 200)
                    
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
        if !arrived {
            return 0.35
        }
        
        return 1.0
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
        CompassCircleView(degrees: .constant(.zero), near: .constant(1), distance: .constant(100), placeName: .constant("San Giorgio a Cremano in prova lunghezza testo"), arrived: .constant(true))
            .previewLayout(PreviewLayout.sizeThatFits)
            .padding(60)
            .previewDisplayName("Arrived Preview")
        
        CompassCircleView(degrees: .constant(.zero), near: .constant(1), distance: .constant(100), placeName: .constant("San Giorgio"), arrived: .constant(false))
            .previewLayout(PreviewLayout.sizeThatFits)
            .padding(80)
            .previewDisplayName("Arrived Preview")
    }
}
