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
            if viewController.searchText.count == 0 {
                
                List(navVC.locations) { item in
                    Button {
                        let generator = UISelectionFeedbackGenerator()
                        generator.selectionChanged()
                        
                        navVC.gotTo(place: item)
                        dismissSearch()
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
                if let searchResults = viewController.searchResults {
                    if !searchResults.isEmpty {
                        List(searchResults) { item in
                            Button {
                                let generator = UISelectionFeedbackGenerator()
                                generator.selectionChanged()
                                
                                navVC.gotTo(place: item)
                                dismissSearch()
                            } label: {
                                HStack {
                                    VStack(alignment: .leading) {
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
                                            
                                        }
                                        if item.distance > 3000 {
                                            HStack {
                                                Image(systemName: "exclamationmark.triangle.fill")
                                                    .foregroundColor(.orange)
                                                Text("Warning! ")
                                                    .bold()
                                                    .foregroundColor(.orange) +
                                                Text("The place can be too far away.")
                                            }.padding(.top, 4)
                                        }
                                    }
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.black)
                                }
                            }
                        }
                    }else{
                        Image(systemName: "map.fill")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .padding(10)
                            .background(.primary)
                            .clipShape(Circle())
                        Text("No results")
                            .bold()
                    }
                }else{
                    List {
                        ForEach((0..<4)) { _ in
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
