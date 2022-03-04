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
            
            Text("explore")
                .font(.system(size: 40))
                .fontWeight(.black)
            Text("choose-a-place")
                .font(.system(size: 20))
                .fontWeight(.bold)
            
            Text("choose-a-place-description")
                .font(.system(size: 20))
                .multilineTextAlignment(.center)
                .padding(.top)
            HStack{
                Image(systemName: "exclamationmark.triangle.fill")
                    .resizable()
                    .frame(width: 20.0, height: 20.0)
                    .foregroundColor(Color("PaletteYellow"))
                Text("be-careful-distance")
                
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
