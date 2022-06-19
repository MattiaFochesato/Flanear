//
//  NavigatorView.swift
//  Flanear
//
//  Created by Mattia Fochesato on 11/02/22.
//

import SwiftUI
import MapKit

struct OriginalNavigatorView: View {
    @Environment(\.scenePhase) var scenePhase
    
    @ObservedObject var viewController = NavigatorViewController()
    @ObservedObject var searchViewController = PlaceSearchViewController()
    
    @State var searchText = ""
    
    var body: some View {
        //NavigationView {
            VStack(spacing: 0) {
                NavigatorViewNew()
                    .navigationTitle("explore")
                //.searchable(text: $searchViewController.searchText, placement: .navigationBarDrawer(displayMode: .always))
                
            }
        //}
        .environmentObject(viewController)
        .environmentObject(searchViewController)
        .onChange(of: scenePhase) { newPhase in
            viewController.onChange(of: newPhase)
        }
    }
}

struct NavigatorSearchableView: View {
    @State var tracking: MapUserTrackingMode = .follow
    @Environment(\.isSearching) var isSearching
    
    @EnvironmentObject var viewController: NavigatorViewController
    
    @State private var openCamera = false
    @State private var cameraImage: UIImage? = nil
    @State private var showOnboarding = false
    
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
                    //.ignoresSafeArea(.all, edges: .bottom)
                    
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
        }.sheet(isPresented: $showOnboarding) {
            Onboarding(showOnboarding: $showOnboarding)
        }.onAppear {
            if !UserDefaults.standard.bool(forKey: "onboardingDone") {
                UserDefaults.standard.set(true, forKey: "onboardingDone")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.showOnboarding = true
                }
            }
        }.navigationBarItems(trailing: Button(action: {
            self.showOnboarding = true
        }, label: {
            Image(systemName: "info.circle")
        }))
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
