//
//  NavigationDetailsView.swift
//  Flanear
//
//  Created by Mattia Fochesato on 19/06/22.
//

import SwiftUI
import CoreLocation

struct NavigationDetailsView: View {
    
    @EnvironmentObject var viewController: NavigatorViewController

    var body: some View {
        VStack {
            LazyVGrid(columns: [
                GridItem(.fixed(150)),
                GridItem(.flexible()),
            ], spacing: 0) {
                HStack {
                    Image(systemName: "location.fill")
                    Text("\(Int(viewController.destinationDistance))m")
                        .minimumScaleFactor(0.7)
                        .frame(maxWidth: .infinity)
                }.padding()
                    .background(RoundedRectangle(cornerRadius: 16)
                        .foregroundColor(.textWhite))
                    .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 0)
                    .frame(height: 60)
                //Spacer()
                DistanceProgressBar(startingDistance: $viewController.startingDistance, distance: $viewController.destinationDistance, arrived: $viewController.isArrived)
                    //.padding()
                    .frame(height: 55)
                    .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 0)
            }.frame(height: 60)
            HStack {
                VStack(alignment: .leading) {
                    Text("Road to...")
                        .bold()
                    Text(viewController.destinationName ?? "-")
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)
                }
                Spacer()
                Button {
                    viewController.gotTo(place: nil)
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.textWhite)
                        .padding(6)
                        .background(Circle()
                            .foregroundColor(.textBlack))
                }

            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 16)
                .foregroundColor(.textWhite))
            .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 0)


        }
    }

}

struct NavigationDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationDetailsView()
            .environmentObject(NavigatorViewController())
    }
}
