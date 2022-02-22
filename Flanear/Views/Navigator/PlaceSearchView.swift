//
//  PlaceSearchView.swift
//  Flanear
//
//  Created by Mattia Fochesato on 15/02/22.
//

import SwiftUI

struct PlaceSearchView: View {
    @StateObject var viewController = PlaceSearchViewController()
    
    @EnvironmentObject var navVC: NavigatorViewController
    
    var body: some View {
        NavigationView {
            VStack {
                if viewController.searchText.count == 0 {
                    Text("TODO suggestions")
                }else{
                    if let searchResults = viewController.searchResults {
                        if !searchResults.isEmpty {
                            List(searchResults) { item in
                                Button {
                                    let generator = UISelectionFeedbackGenerator()
                                    generator.selectionChanged()
                                    
                                    navVC.gotTo(place: item)
                                } label: {
                                    HStack {
                                        Image(systemName: item.image)
                                            .foregroundColor(.black)
                                        VStack(alignment: .leading) {
                                            Text(item.title)
                                                .foregroundColor(.black)
                                            Text(item.subtitle)
                                                .foregroundColor(.secondary)
                                        }
                                        Spacer()
                                        Text("\(Int(item.distance))m")
                                            .foregroundColor(.black)
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.black)
                                    }
                                }
                            }
                        }else{
                            Text("no results")
                        }
                    }else{
                        List {
                            ForEach((0..<10)) { _ in
                                HStack {
                                    Image(systemName: "greaterthan.circle.fill")
                                    VStack(alignment: .leading) {
                                        Text(randomString(length: 10))
                                        Text(randomString(length: 6))
                                            .foregroundColor(.secondary)
                                    }
                                }.redacted(reason: .placeholder)
                            }
                        }
                    }
                }
            }.navigationTitle("Search")
        }
        .searchable(text: $viewController.searchText)
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
        PlaceSearchView()
    }
}
