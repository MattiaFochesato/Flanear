//
//  SecondOnboardingView.swift
//  Flanear
//
//  Created by Marco Pescosolido on 03/03/22.
//

import SwiftUI

struct SecondOnboardingView: View {
    var body: some View {
        VStack{
            Image(systemName: "mappin.and.ellipse")
                .resizable()
                .frame(width: 160.0, height: 160.0)
                .foregroundColor(Color("PaletteYellow"))
           
            Text("Explore")
                .font(.system(size: 40))
                .fontWeight(.black)
            Text("Choose a place to visit")
                .font(.system(size: 20))
                .fontWeight(.bold)
                
            Text("Select a place to explore on the map or search for a location")
                .font(.system(size: 20))
                .multilineTextAlignment(.center)
                .padding(.top)
            HStack{
                Image(systemName: "exclamationmark.triangle.fill")
                    .resizable()
                    .frame(width: 20.0, height: 20.0)
                    .foregroundColor(Color("PaletteYellow"))
                Text("Be careful of the distance")
                
                .font(.system(size: 16))
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            }
            .padding(.top)
            
        
    }
        .padding(.horizontal, 40.0)
}

struct SecondOnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        SecondOnboardingView()
    }
}
}
