//
//  NavigatorViewNew.swift
//  Flanear
//
//  Created by Mattia Fochesato on 09/06/22.
//

import SwiftUI
import MapKit

struct NavigatorView: View {

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
                if viewController.destinationName == nil {
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
                }
                
                ZStack(alignment: .bottom) {
                    MapView()
                        .disabled(viewController.destinationLocation == nil ? false : true)

                    if viewController.destinationLocation != nil {
                        ZStack(alignment: .center) {
                            Color.clear
                            CompassView(degrees: $viewController.degrees, arrived: $viewController.isArrived, openCamera: .constant(false))
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
                                            //self.viewController.gotTo(place: suggestion)
                                            searchController.showPlaceInfo = suggestion
                                            self.bottomSheetShown = true
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
                            if let showPlaceInfo = searchController.showPlaceInfo {
                                LocationOverviewView(place: showPlaceInfo)
                                    .environmentObject(viewController)
                                    .onChange(of: self.bottomSheetShown) { newValue in
                                        if !newValue {
                                            searchController.showPlaceInfo = nil
                                        }
                                    }
                            }else{
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
                                        /*VStack {
                                            Text("Coming Soon!")
                                                .bold()
                                        }*/
                                        CitiesView()
                                    }
                                }
                            }
                            }
                        }
                    }else{
                        NavigationDetailsView()
                            .environmentObject(viewController)
                            .padding()
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


struct NavigatorViewNew_Previews: PreviewProvider {
    static var previews: some View {
        FlanearViewHolder()
    }
}
