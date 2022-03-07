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
    @State private var region: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 40.851799, longitude: 14.268120),
        span: MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15)
    )
    @State var showCameraSheet = false
    @State var showPictureSheet: Int64 = -1
    
    @State var newImage: UIImage? = nil
    
    @ObservedObject var viewController = PlaceInfoViewController()
    
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
                    Text(NSLocalizedString(place.description, comment: ""))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .fontWeight(.medium)
                        .multilineTextAlignment(.leading)
                        .padding([.leading, .trailing])
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 0) {
                            
                            ForEach(viewController.pictures) { picture in
                                Button {
                                    showPictureSheet = picture.id ?? 0
                                } label: {
                                    Image(uiImage: picture.image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 200.0, height: 200.0)
                                        .cornerRadius(22)
                                        .contextMenu {
                                            Button(role: .destructive) {
                                                viewController.delete(picture: picture)
                                            } label: {
                                                Label("delete", systemImage: "trash.fill")
                                            }
                                        }
                                        .overlay(RoundedRectangle(cornerRadius: 22)
                                                    .stroke(Color.textBlack, lineWidth: 1)
                                                    .padding(1))
                                        .shadow(color: .shadow, radius: 6, x: 0, y: 2)
                                        .padding(8)
                                }


                            }
                            Button {
                                showCameraSheet = true
                            } label: {
                                Image(systemName: "plus")
                                    .font(.largeTitle)
                                    .foregroundColor(.black)
                                    .frame(width: 200.0, height: 200.0)
                                    .background(Color(red: 0.898, green: 0.898, blue: 0.918, opacity: 1.0))
                                    .cornerRadius(22)
                                    .overlay(RoundedRectangle(cornerRadius: 22)
                                                .stroke(Color.textBlack, lineWidth: 1)
                                                .padding(1))
                                    .shadow(color: .shadow, radius: 6, x: 0, y: 2)
                            }.padding(.leading, viewController.pictures.isEmpty ? 8 : 0)

                        }.padding([.top, .bottom])
                    }
                    
                    Section() {
                        TextEditor(text: $thoughts)
                            //.accessibilityHint("hint-write-your-thoughts")
                            .cornerRadius(12)
                            .lineSpacing(20)
                            .autocapitalization(.none)
                            .padding()
                    }
                    .background(Color.textWhite)
                    .cornerRadius(12)
                    .overlay(RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.textBlack, lineWidth: 1))
                        .shadow(color: .shadow, radius: 6, x: 0, y: 2)
                    .padding([.leading, .trailing])
            }
        }
        .navigationTitle(Text("place-info"))
        .sheet(isPresented: $showCameraSheet) {
            //dismiss
        } content: {
            CameraView(isShown: $showCameraSheet, image: $newImage)
                .background(.black)
        }.onChange(of: newImage) { newValue in
            print("received new image")
            if let newValue = newValue {
                try? AppDatabase.shared.add(image: newValue, to: place)
            }
        }
        .onAppear(perform: {
            self.viewController.setup(place: place)
            self.region = MKCoordinateRegion(center: place.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            
            if place.thoughts != " " {
                self.thoughts = place.thoughts
            }
        })
        .onDisappear(perform: {
            var placeToSave = place
            placeToSave.thoughts = thoughts
            try? AppDatabase.shared.savePlace(&placeToSave)
            
            self.viewController.observableCancellable?.cancel()
            self.viewController.pictures = []
        })
        .sheet(isPresented: Binding(get: {
            self.showPictureSheet != -1
        }, set: {
            self.showPictureSheet = ($0 ? 0 : -1)
        })) {
            NavigationView {
                PicturePreviewView(pictures: viewController.pictures, pictureToShowId: $showPictureSheet)
            }
        }

    }
}
struct PlaceInfoView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceInfoView(place: VisitedPlace.makeRandom())
    }
    
}

