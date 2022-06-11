//
//  NavigatorViewNew.swift
//  Flanear
//
//  Created by Mattia Fochesato on 09/06/22.
//

import SwiftUI
import MapKit

struct NavigatorViewNew: View {

    @State var tracking: MapUserTrackingMode = .follow
    @FocusState private var isSearching: Bool

    @EnvironmentObject var viewController: NavigatorViewController
    @EnvironmentObject var searchController: PlaceSearchViewController

    @State private var showOnboarding = false

    @State private var bottomSheetShown = false
    @State private var showingAroundYouTab = true

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                VStack {
                    Text("explore")
                        .bold()
                        .padding()
                }
                .frame(maxWidth: .infinity)
                .background(Color.textWhite)
                .shadow(color: .black.opacity(0.25), radius: 24, x: 0, y: 0)
                .zIndex(2)
                //.ignoresSafeArea(.all, edges: [.top])
                //Spacer()
                
                ZStack(alignment: .bottom) {
                    MapView()
                        .disabled(viewController.destinationLocation == nil ? false : true)

                    if viewController.destinationLocation != nil {
                        ZStack(alignment: .center) {
                            Color.clear
                            NewCompassCircleView(degrees: $viewController.degrees, startingDistance: $viewController.startingDistance, distance: $viewController.destinationDistance, placeName: $viewController.destinationName, arrived: $viewController.isArrived, openCamera: .constant(false))
                                .frame(alignment: .center)
                                .ignoresSafeArea(.all, edges: .bottom)
                        }
                    }

                    if viewController.destinationLocation == nil {
                        let maxSheetHeight = geometry.size.height * 0.8
                        let bottomPadding = 0.3 * maxSheetHeight
                        let itemWidth = geometry.size.width * 0.7
                        if let suggestionsToShow = viewController.getSuggestions(max: 5) {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 0) {
                                    ForEach(suggestionsToShow) { suggestion in
                                        Button {
                                            let generator = UISelectionFeedbackGenerator()
                                            generator.selectionChanged()
                                            self.viewController.gotTo(place: suggestion)
                                        } label: {
                                            PlaceRowView(place: suggestion, whiteBackground: true, width: itemWidth, shadows: true)
                                                .padding(.vertical)
                                                .padding(.leading)
                                        }
                                    }
                                }
                            }//.frame(maxWidth: .infinity)
                            //.background(Color.green)
                            .padding(.bottom, bottomPadding)
                            //.zIndex(1)
                        }
                        BottomSheetView(
                            isOpen: self.$bottomSheetShown,
                            maxHeight: maxSheetHeight
                        ) {
                            VStack {
                                HStack(spacing: 0) {
                                    Image(systemName: "magnifyingglass")
                                    TextField("Search...", text: $searchController.searchText)
                                        .focused($isSearching)
                                        .padding()
                                }.padding(.horizontal)
                                    .background(RoundedRectangle(cornerRadius: 24)
                                        .foregroundColor(Color(.secondarySystemBackground)))
                                    .padding(.horizontal)
                                //if self.bottomSheetShown {
                                HStack {
                                    Spacer()
                                    Button {
                                        showingAroundYouTab = true
                                        isSearching = false
                                    } label: {
                                        Text("Around You")
                                            .font(.title3)
                                            .foregroundColor(showingAroundYouTab ? .textBlack : .gray)
                                            .bold()
                                    }
                                    Spacer()
                                    Button {
                                        showingAroundYouTab = false
                                        isSearching = false
                                    } label: {
                                        Text("Already Visited")
                                            .font(.title3)
                                            .bold()
                                            .foregroundColor(!showingAroundYouTab ? .textBlack : .gray)
                                    }
                                    Spacer()
                                }.padding(.vertical)
                                if showingAroundYouTab {
                                    PlaceSearchView()
                                        .environmentObject(searchController)
                                }else{
                                    ScrollView {
                                        VStack {
                                            Text("Coming Soon!")
                                                .bold()
                                        }
                                    }
                                }
                            }
                        }
                    }else{
                        VStack {
                            HStack {
                                HStack {
                                    Image(systemName: "location.fill")
                                    Text("\(Int(viewController.destinationDistance))m")
                                }.padding()
                                    .background(RoundedRectangle(cornerRadius: 16)
                                        .foregroundColor(.textWhite))
                                    .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 0)
                                Spacer()
                                HStack {
                                    Text(" ")
                                        .frame(maxWidth: .infinity)
                                }.padding()
                                    .background(RoundedRectangle(cornerRadius: 16)
                                        .foregroundColor(.textWhite))
                                    .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 0)
                            }
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Road to...")
                                        .bold()
                                    Text(viewController.destinationName!)
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


                        }.padding()
                            .padding(.bottom, geometry.safeAreaInsets.bottom + 10)
                    }
                }.zIndex(1)
            }
        }
        .ignoresSafeArea(.all, edges: [.bottom])
        .onChange(of: isSearching) { newValue in
            if newValue {
                self.bottomSheetShown = true
                self.showingAroundYouTab = true
            }
        }
    }
}

struct PlaceRowView: View {
    var place: PlaceSearchItem
    var whiteBackground: Bool
    var width: CGFloat
    var shadows: Bool = false

    var body: some View {
        HStack {
            Image(systemName: "location.fill")
                .foregroundColor(.white)
                .padding(6)
                .background(Circle()
                    .foregroundColor(.orange))
            VStack(alignment: .leading) {
                Text(place.title)
                    .lineLimit(1)
                //.minimumScaleFactor(0.75)
                    .foregroundColor(.textBlack)
                Text("\(Int(place.distance)) m")
                    .lineLimit(1)
                //.minimumScaleFactor(0.75)
                    .foregroundColor(.gray)
            }
            Spacer()
        }.frame(width: width)
            .padding()
            .background(RoundedRectangle(cornerRadius: 16)
                .foregroundColor(whiteBackground ? .textWhite : Color(.secondarySystemBackground)))
            .shadow(color: shadows ? .black.opacity(0.15) : .clear, radius: 10, x: 0, y: 0)
        //.padding(.vertical)

        //.foregroundColor(.textWhite))
    }
}

struct MapPlaceInfoView: View {
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
                //TODO
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

struct NavigatorViewNew_Previews: PreviewProvider {
    static var previews: some View {
        NavigatorView()
        MapPlaceInfoView(place: PlaceSearchItem(title: "Spiaggia di San Giovanni", description: "Demo Description", latitude: 0, longitude: 0))
        //    .background(Color.blue)
    }
}
