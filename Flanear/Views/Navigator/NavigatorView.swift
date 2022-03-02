//
//  NavigatorView.swift
//  Flanear
//
//  Created by Mattia Fochesato on 11/02/22.
//

import SwiftUI
import MapKit

struct NavigatorView: View {
    
    @ObservedObject var viewController = NavigatorViewController()
    @ObservedObject var searchViewController = PlaceSearchViewController()
    
    @State var searchText = ""
    @State private var showingChildView = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                NavigationLink(destination: CitiesView(),
                               isActive: self.$showingChildView)
                { EmptyView() }
                .frame(width: 0, height: 0)
                .disabled(true)
                
                NavigatorSearchableView()
                    .navigationTitle("explore")
                    .searchable(text: $searchViewController.searchText, placement: .navigationBarDrawer(displayMode: .always))
                    //.ignoresSafeArea(.all, edges: .bottom)
                    .navigationBarItems(trailing:
                                            Button(action: {
                        self.showingChildView.toggle()
                    }) {
                        Image(systemName: "book.closed.fill").imageScale(.large)
                    }
                    )
            }
        }.environmentObject(viewController)
            .environmentObject(searchViewController)
            
    }
}

struct NavigatorSearchableView: View {
    @State var tracking: MapUserTrackingMode = .follow
    @Environment(\.isSearching) var isSearching
    
    @EnvironmentObject var viewController: NavigatorViewController
    
    @State private var openCamera = false
    @State private var cameraImage: UIImage? = nil
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                if !isSearching {
                    MapView()
                        .overlay(Rectangle()
                                    .foregroundColor(.clear)
                                    .background(viewController.destinationLocation == nil ? RadialGradient(gradient: Gradient(colors: [.clear]), center: .center, startRadius: 1000, endRadius: 1000) : RadialGradient(gradient: Gradient(colors: [.clear, .textWhite]), center: .center, startRadius: 140, endRadius: 400))
                                    .allowsHitTesting(false) )
                        .disabled(viewController.destinationLocation == nil ? false : true)
                    .ignoresSafeArea(.all, edges: .bottom)
                    
                    if viewController.destinationLocation != nil {
                        CompassCircleView(degrees: $viewController.degrees, startingDistance: $viewController.startingDistance, distance: $viewController.destinationDistance, placeName: $viewController.destinationName, arrived: $viewController.isArrived, openCamera: $openCamera)
                        .ignoresSafeArea(.all, edges: .bottom)
                        
                    }
                    
                }else{
                    PlaceSearchView()
                }
            }
            if let destName = viewController.destinationName {
                if !isSearching {
                    Divider()
                    HStack {
                        Image(systemName: "location.fill")
                            .font(.title.bold())
                        Text(destName)
                            .bold()
                        Spacer()
                        Button {
                            viewController.gotTo(place: nil)
                        } label: {
                            Image(systemName: "xmark")
                                .font(.title.bold())
                                .foregroundColor(.textBlack)
                        }
                        
                    }
                    .padding([.leading, .trailing])
                    
                    .frame(maxWidth: .infinity)
                    .padding([.top, .bottom], 6)
                    .background(Color("DestinationSheetColor"))
                    Divider()
                }
            }
        }.sheet(isPresented: $openCamera) {
            CameraView(isShown: $openCamera, image: $cameraImage)
                .background(.black)
        }.onChange(of: cameraImage) { newImage in
            print("got new image!")
            guard let currentPlace = LocationUtils.shared.currentPlace else { return }
            
            if let newValue = newImage {
                try? AppDatabase.shared.add(image: newValue, to: currentPlace)
            }
            
            viewController.gotTo(place: nil)
        }
    }
    
}

struct SuggestedPlacesView: View {
    var body: some View {
        List {
            Text("Test")
        }.foregroundColor(.white)
    }
}

struct NavigatorView_Previews: PreviewProvider {
    static var previews: some View {
        NavigatorView()
    }
}
