//
//  CitiesView.swift
//  Flanear
//
//  Created by Mattia Fochesato on 15/02/22.
//

import SwiftUI

struct CitiesView: View {
    @ObservedObject var viewController = VisitedCitiesViewController()
    
    @State var searchText = ""
    
    @State var citiesToShow: [VisitedCity] = []
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    ForEach(citiesToShow) { city in
                        NavigationLink {
                            DiaryView(city: city)
                        } label: {
                            CityRow(city: city)
                                .padding()
                                
                        }.contextMenu {
                            Button("Delete", action: {})
                        }
                        Divider()
                            .padding([.leading, .trailing])
                    }
                }.navigationTitle("Your Cities")
            }
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        .onChange(of: searchText) { searchText in
            if !searchText.isEmpty {
                citiesToShow = viewController.cities.filter { $0.name.contains(searchText) }
            } else {
                citiesToShow = viewController.cities
            }
        }
        .onAppear {
            self.citiesToShow = viewController.cities
        }
    }
    
    struct CityRow: View {
        let city: VisitedCity
        
        var body: some View {
            
            VStack(alignment: .leading) {
                Text(city.name)
                    .font(.title)
                    .bold()
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
                        Text("20% completed")
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
                .shadow(color: Color("Shadow"), radius: 6, x: 0, y: 2)
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
