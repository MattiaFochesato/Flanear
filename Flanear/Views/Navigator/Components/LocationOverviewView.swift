//
//  LocationOverviewView.swift
//  Flanear
//
//  Created by Mattia Fochesato on 19/06/22.
//

import SwiftUI

struct LocationOverviewView: View {
    @EnvironmentObject var viewController: NavigatorViewController

    var place: PlaceSearchItem

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(place.title)
                    .bold()
                    .font(.title2)
                Spacer()
                Button {
                    //TODO
                } label: {
                    Image(systemName: "star")
                        .font(.title2)
                        .foregroundColor(.yellow)
                        .padding(4)
                }
            }
            HStack {
                Image(systemName: "location.fill")
                Text("\(Int(place.distance)) m")
                    .fontWeight(.medium)
            }
            Text(place.subtitle)
                .foregroundColor(.gray)
                .fontWeight(.light)
            Button {
                viewController.gotTo(place: place)
            } label: {
                HStack {
                    Image(systemName: "location.circle.fill")
                        .font(.title2)
                    Text("Get me there!")
                        .fontWeight(.semibold)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 16)
                    .fill(Color.appOrange))
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 4)
            }.foregroundColor(.white)
                .padding(.top, 8)

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct LocationOverviewView_Previews: PreviewProvider {
    static var previews: some View {
        LocationOverviewView(place: PlaceSearchItem(title: "Spiaggia di San Giovanni", description: "Demo Description", latitude: 0, longitude: 0))
    }
}
