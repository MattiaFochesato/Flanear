//
//  PickPlaceView.swift
//  FlanearWatch WatchKit Extension
//
//  Created by Mattia Fochesato on 12/02/22.
//

import SwiftUI

struct PickPlaceView: View {
    @EnvironmentObject var viewController: NavigatorViewController
    
    var body: some View {
        VStack {
            if let searchResults = viewController.searchResults {
                if searchResults.isEmpty {
                    Image(systemName: "location.slash.fill")
                        .font(.largeTitle)
                        .padding(4)
                        .background(Circle().foregroundColor(.blue))
                        .padding(.bottom, 8)
                    Text("We cannot find anything. Please check your GPS and internet connection.")
                        .multilineTextAlignment(.center)
                }else{
                    List {
                        ForEach(searchResults) { item in
                            Button {
                                viewController.visit(place: item)
                                viewController.selectedTab = 0
                            } label: {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(item.title)
                                        Text(item.subtitle)
                                            .font(.footnote)
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                    Text("\(Int(item.distance))m")
                                }
                            }
                        }
                    }
                }
            }else{
                ProgressView()
            }
        }.navigationTitle("Pick Place")
            .onAppear {
                viewController.loadSuggestions()
            }
    }
}

struct PickPlaceView_Previews: PreviewProvider {
    static var previews: some View {
        PickPlaceView()
    }
}
