//
//  CitiesView.swift
//  Flanear
//
//  Created by Mattia Fochesato on 15/02/22.
//

import SwiftUI

/*
 View that shows you the list of cities that you have visited
 */
struct CitiesView: View {
    @ObservedObject var viewController = VisitedCitiesViewController()
    
    //Filter variables
    @State var searchText = ""
    @State var citiesToShow: [VisitedCity] = []
    
    var body: some View {
        //NavigationView {
            ScrollView {
                VStack {
                    ForEach(citiesToShow) { city in
                        NavigationLink {
                            PlacesView(city: city)
                        } label: {
                            CityRow(city: city)
                                .padding()
                        }.contextMenu {
                            Button(role: .destructive) {
                                viewController.deleteCity(city: city)
                            } label: {
                                Label("delete", systemImage: "trash.fill")
                            }
                        }
                        Divider()
                            .padding([.leading, .trailing])
                    }
                }.navigationTitle("your-cities")
            }
        //}
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        .onChange(of: searchText) { _ in
            filterCities()
        }
        .onChange(of: viewController.cities, perform: { _ in
            filterCities()
        })
        .onAppear {
            filterCities()
        }
    }
    
    /**
     Function to call when you need to update the list of cities to show.
     */
    func filterCities() {
        if !searchText.isEmpty {
            citiesToShow = viewController.cities.filter { $0.name.contains(searchText) }
        } else {
            citiesToShow = viewController.cities
        }
    }
    
    struct CityRow: View {
        let city: VisitedCity
        
        var body: some View {
            
            VStack(alignment: .leading) {
                Text(city.name)
                    .font(.title)
                    .bold()
                    .foregroundColor(.textBlack)
                VStack (alignment: .leading){
                    if let url = URL(string: city.image) {
                        AsyncImage(url: url) { image in
                            image.resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity)
                                .frame(height: 200)
                        } placeholder: {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                                .frame(height: 200)
                        }.clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(RoundedRectangle(cornerRadius: 12)
                                        .stroke(.black, lineWidth: 2))
                        Text("completed \(String(city.getCompletion()))")
                            .fontWeight(.medium)
                            .padding([.leading, .bottom, .top])
                    }else{
                        ProgressView()
                    }
                }
                .background(.yellow)
                .cornerRadius(12)
                .overlay(RoundedRectangle(cornerRadius: 12)
                            .stroke(.black, lineWidth: 2))
                .shadow(color: .shadow, radius: 6, x: 0, y: 2)
            }.foregroundColor(.black)
        }
        
        struct CitiesView_Previews: PreviewProvider {
            static var previews: some View {
                CityRow(city: VisitedCity.makeRandom())
                    .frame(width: 300, height: 300)
                CitiesView()
            }
        }
    }
}
