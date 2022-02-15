//
//  CitiesView.swift
//  Flanear
//
//  Created by Mattia Fochesato on 15/02/22.
//

import SwiftUI

struct CitiesView: View {
    @ObservedObject var viewController = VisitedCitiesViewController()
    
    var body: some View {
        NavigationView {
            List {
                //VStack {
                    ForEach(viewController.cities) { city in
                        NavigationLink {
                            DiaryView(city: city)
                        } label: {
                            CityRow(city: city)
                        }

                    }
                //}
            }.navigationTitle("Your Cities")
        }
    }
}

struct CityRow: View {
    let city: VisitedCity
    
    var body: some View {
        VStack {
            Text(city.name)
                .font(.title2)
                .bold()
            if let url = URL(string: city.image) {
                AsyncImage(url: url) { image in
                    image.resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }.clipShape(RoundedRectangle(cornerRadius: 12))
            }else{
                ProgressView()
            }
            
        }
    }
    
}

struct CitiesView_Previews: PreviewProvider {
    static var previews: some View {
        CityRow(city: VisitedCity.makeRandom())
            .frame(width: 300, height: 300)
        CitiesView()
    }
}