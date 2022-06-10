//
//  PlaceSearchView.swift
//  Flanear
//
//  Created by Mattia Fochesato on 15/02/22.
//

import SwiftUI

struct PlaceSearchView: View {
    @EnvironmentObject var viewController: PlaceSearchViewController
    @EnvironmentObject var navVC: NavigatorViewController
    
    
    @Environment(\.dismissSearch) private var dismissSearch
    
    var body: some View {
        VStack(alignment: .leading) {
            GeometryReader { geometry in
                let itemWidth = geometry.size.width * 0.85
                if viewController.searchText.count == 0 {
                    if let suggestedLocations = navVC.suggestedLocations {
                        ScrollView {
                            VStack {

                                ForEach(suggestedLocations) { item in
                                    Button {
                                        let generator = UISelectionFeedbackGenerator()
                                        generator.selectionChanged()

                                        navVC.gotTo(place: item)
                                        dismissSearch()
                                    } label: {
                                        /*HStack {
                                         Image(item.image)
                                         .resizable()
                                         .foregroundColor(.textBlack)
                                         .frame(width: 30, height: 30)
                                         VStack(alignment: .leading) {
                                         Text(item.title)
                                         .foregroundColor(.textBlack)
                                         Text(NSLocalizedString(item.subtitle, comment: ""))
                                         .foregroundColor(.secondary)
                                         }
                                         Spacer()
                                         Text("\(Int(item.distance)) m")
                                         .foregroundColor(.textBlack)
                                         Image(systemName: "chevron.right")
                                         .foregroundColor(.textBlack)
                                         }*/
                                        PlaceRowView(place: item, whiteBackground: false, width: itemWidth)
                                    }.padding([.top, .bottom], 4)
                                        .padding(.horizontal)
                                }
                            }
                            //}
                        }
                    }else{
                        ProgressView("loading-suggestions")
                    }
                }else{
                    if let searchResults = viewController.searchResults {
                        if !searchResults.isEmpty {
                            ScrollView {
                                VStack {
                                    ForEach(searchResults) { item in
                                        Button {
                                            let generator = UISelectionFeedbackGenerator()
                                            generator.selectionChanged()

                                            navVC.gotTo(place: item)
                                            dismissSearch()
                                        } label: {
                                            /*HStack {
                                                VStack(alignment: .leading) {
                                                    HStack {
                                                        Image(item.image)
                                                            .resizable()
                                                            .foregroundColor(.textBlack)
                                                            .frame(width: 30, height: 30)
                                                        VStack(alignment: .leading) {
                                                            Text(item.title)
                                                                .foregroundColor(.textBlack)
                                                            Text(NSLocalizedString(item.subtitle, comment: ""))
                                                                .foregroundColor(.secondary)
                                                        }
                                                        Spacer()
                                                        Text("\(Int(item.distance))m")
                                                            .foregroundColor(.textBlack)

                                                    }
                                                    if item.distance > 3000 {
                                                        HStack {
                                                            Image(systemName: "exclamationmark.triangle.fill")
                                                                .foregroundColor(.orange)
                                                            (Text("warning")
                                                                .bold()
                                                                .foregroundColor(.orange) +
                                                             Text(" ") +
                                                             Text("place-too-far-away"))
                                                            .fixedSize(horizontal: false, vertical: true)

                                                        }.padding(.top, 4)
                                                    }
                                                }
                                                Image(systemName: "chevron.right")
                                                    .foregroundColor(.textBlack)
                                            }*/
                                            PlaceRowView(place: item, whiteBackground: false, width: itemWidth)
                                        }.padding([.top, .bottom], (item.distance > 3000 ? 0 : 4))
                                            .padding(.horizontal)
                                    }
                                }
                            }
                        }else{
                            VStack(alignment: .center) {
                                Image(systemName: "map.fill")
                                    .font(.largeTitle)
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .background(.primary)
                                    .clipShape(Circle())
                                    .padding(.bottom)
                                Text("search-no-results")
                                    .bold()
                                    .multilineTextAlignment(.center)
                            }
                        }
                    }else{
                        ScrollView {
                            VStack {
                                ForEach((0..<4)) { _ in
                                    /*HStack {
                                        Image(systemName: "greaterthan.circle.fill")
                                            .resizable()
                                            .foregroundColor(.textBlack)
                                            .frame(width: 30, height: 30)
                                        VStack(alignment: .leading) {
                                            Text(randomString(length: 10))
                                            Text(randomString(length: 6))
                                                .foregroundColor(.secondary)
                                        }*/
                                        PlaceRowView(place: PlaceSearchItem(title: randomString(length: 10), description: randomString(length: 6), latitude: 0, longitude: 0), whiteBackground: false, width: itemWidth)
                                    /*}*/.padding([.top, .bottom], 4)
                                        .redacted(reason: .placeholder)
                                        .padding(.horizontal)
                                }
                            }
                        }
                    }
                }
            }
        }
        .onReceive(
            viewController.$searchText
                .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
        ) {
            guard !$0.isEmpty else { return }
            print(">> searching for: \($0)")
            LocationUtils.shared.search(for: .pointOfInterest, text: $0)
        }.onReceive(viewController.$searchText) { _ in
            viewController.searchResults = nil
        }
    }
    
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
}

struct PlaceSearchView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceSearchView()//searchText: .constant(""))
    }
}
