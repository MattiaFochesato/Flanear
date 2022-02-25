//
//  PlaceInfoView.swift
//  Flanear
//
//  Created by Mattia Fochesato on 14/02/22.
//

import SwiftUI
import CoreLocation
import MapKit

struct PlaceInfoView: View {
    var place: VisitedPlace
    
    @State var thoughts: String = "hint-write-your-thoughts"
    @State private var region: MKCoordinateRegion
    @State var showCameraSheet = false
    
    init(place: VisitedPlace) {
        self.place = place
        
        region = MKCoordinateRegion(center: place.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    }
    
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Map(coordinateRegion: $region, annotationItems: [self.place]) { item in
                    MapPin(coordinate: item.coordinate)
                }
                    .frame(height: 250)
                    .frame(maxWidth: .infinity)
                    .disabled(true)
                
                
                    Text(place.title)
                        .font(.title)
                        .fontWeight(.black)
                        .multilineTextAlignment(.leading)
                        .padding([.leading, .trailing])
                    Text(place.description)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .fontWeight(.medium)
                        .multilineTextAlignment(.leading)
                        .padding([.leading, .trailing])
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(0..<1) { i in
                                Image("monastero-santa-chiara-porticato-esterno")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 200.0, height: 200.0)
                                    .cornerRadius(22)
                                    .overlay(RoundedRectangle(cornerRadius: 22)
                                                .stroke(Color.textBlack, lineWidth: 2)
                                                .padding(1))
                                    .padding(i == 0 ? 8 : 0)
                            }
                            Button {
                                print("Open Camera")
                                showCameraSheet = true
                            } label: {
                                Image(systemName: "plus")
                                    .font(.largeTitle)
                                    .foregroundColor(.black)
                                    .frame(width: 200.0, height: 200.0)
                                    .background(Color(red: 0.898, green: 0.898, blue: 0.918, opacity: 1.0))
                                    .cornerRadius(22)
                                    .overlay(RoundedRectangle(cornerRadius: 22)
                                                .stroke(Color.textBlack, lineWidth: 2)
                                                .padding(1))
                            }

                        }
                    }
                    Section() {
                        TextEditor(text: $thoughts)
                            .accessibilityHint("hint-write-your-thoughts")
                            .cornerRadius(12)
                            .lineSpacing(20)
                            .autocapitalization(.none)
                        //.frame(width: 300, height: 250)
                        //.clipShape(RoundedRectangle(cornerRadius: 16))
                            .padding([.leading, .trailing])
                        
                        
                    }
                    //.cornerRadius(/*@START_MENU_TOKEN@*/12.0/*@END_MENU_TOKEN@*/)
                    //.border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: 2)
                    .overlay(RoundedRectangle(cornerRadius: 12)
                                .stroke(.black, lineWidth: 3))
                    
                
            }
        }
        .navigationTitle("place-info")
        .sheet(isPresented: $showCameraSheet) {
            //dismiss
        } content: {
            CameraView()
        }

    }
}
struct PlaceInfoView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceInfoView(place: VisitedPlace.makeRandom())
    }
    
}

