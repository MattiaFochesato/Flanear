//
//  DistanceProgressBar.swift
//  Flanear
//
//  Created by Mattia Fochesato on 19/06/22.
//

import SwiftUI
import CoreLocation

struct DistanceProgressBar: View {
    @Binding var startingDistance: CLLocationDistance
    @Binding var distance: CLLocationDistance
    @Binding var arrived: Bool

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle().frame(width: geometry.size.width , height: geometry.size.height)
                    .foregroundColor(Color.textWhite)

                Rectangle()
                    .frame(width: min(getProgress() * geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(Color.appOrange)
                    .animation(.linear)
            }.cornerRadius(16)
        }
    }

    func getProgress() -> CGFloat {
        if !arrived {
            let val = 1 - (self.distance / self.startingDistance)
            if val < 0.03 {
                return 0.03
            }
            if self.startingDistance == 0 || val == .nan {
                return 0.0
            }
            return val
        }

        return 1.0
    }
}
