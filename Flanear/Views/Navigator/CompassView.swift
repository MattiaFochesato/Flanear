//
//  NewCompassCircleView.swift
//  Flanear
//
//  Created by Mattia Fochesato on 09/06/22.
//

import SwiftUI
import CoreLocation

struct CompassView: View {
#if os(watchOS)
    let isWatch = true
#else
    let isWatch = false
#endif

    @Binding var degrees: Double?// = .zero
    @Binding var arrived: Bool
    @Binding var openCamera: Bool

    var body: some View {
        ZStack {
            if !arrived {
                EmptyView()
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
                Image("Union")
                    .rotationEffect(getRotationBar())
                    .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 0)

                VStack {
                    if arrived {
                        Image("theater")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                        Text("TODO")
                            .foregroundColor(!isWatch ? Color(.black) : .white)
                            .font(!isWatch ? .body : .body)
                            .fontWeight(.black)
                            .minimumScaleFactor(0.4)
                            .lineLimit(3)
                            .multilineTextAlignment(.center)
                            .padding([.leading, .trailing], 20)
                    }
                }.offset(y: arrived ? -15 : 0)

                if arrived && !isWatch{ //arrived

                    ZStack(alignment: .bottom) {
                        Button {
                            print("open camera and save")
                            self.openCamera.toggle()
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
        .onChange(of: arrived) { arrived in
            if arrived {
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
            }
        }
        .frame(width: 200, height: 200, alignment: .center)
#endif
    }

    func getRotationBar() -> Angle {
        guard let degrees = degrees else {
            return Angle(degrees: 0)
        }

        return Angle(degrees: degrees)
    }

    func radiansToDegrees(radians: Double) -> Double { return radians * 180.0 / .pi }
}


struct CompassView_Previews: PreviewProvider {
    static var previews: some View {
        CompassView(degrees: .constant(.zero), arrived: .constant(true), openCamera: .constant(false))
            .previewLayout(PreviewLayout.sizeThatFits)
            .padding(60)
            .previewDisplayName("Arrived Preview")

        CompassView(degrees: .constant(.zero), arrived: .constant(false), openCamera: .constant(false))
            .previewLayout(PreviewLayout.sizeThatFits)
            .padding(80)
            .previewDisplayName("Arrived Preview")
    }
}
