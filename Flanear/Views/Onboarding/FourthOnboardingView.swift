//
//  SecondOnboardingView.swift
//  Flanear
//
//  Created by Marco Pescosolido on 03/03/22.
//

import SwiftUI

struct FourthOnboardingView: View {
    var body: some View {
        VStack{
            Image(systemName: "book")
                .resizable()
                .padding(.bottom, 20.0)
                .frame(width: 160.0, height: 160.0)
                .foregroundColor(Color("PaletteYellow"))
            
            Text("collect")
                .font(.system(size: 40))
                .fontWeight(.black)
            Text("memories")
                .font(.system(size: 20))
                .fontWeight(.bold)
            Text("memories-description")
                .font(.system(size: 20))
                .multilineTextAlignment(.center)
                .padding(.top)
            HStack{
                Image(systemName: "exclamationmark.triangle.fill")
                    .resizable()
                    .frame(width: 20.0, height: 20.0)
                    .foregroundColor(Color("PaletteYellow"))
                Text("be-careful-love")
                
                    .font(.system(size: 16))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
            }
            .padding(.top)
            
        }
        .padding(.horizontal, 40.0)
    }
    
    struct FourthOnboardingView_Previews: PreviewProvider {
        static var previews: some View {
            FourthOnboardingView()
        }
    }
}
