//
//  FirstOnboardingView.swift
//  Flanear
//
//  Created by Marco Pescosolido on 03/03/22.
//

import SwiftUI

struct FirstOnboardingView: View {
    var body: some View {
        VStack{
            Text("What's Flanear")
                .font(.system(size: 40))
                .fontWeight(.black)
            Section()
            {
            HStack{
                Image(systemName: "mappin.and.ellipse")
                    .resizable()
                    .frame(width: 50.0, height: 50.0)
                    .foregroundColor(Color("PaletteYellow"))
                    
                VStack{
                    Text("Visit Places")
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Navigate to a selected list of places")
                        .font(.system(size: 20))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.leading, 10.0)
                
            }
            .padding(.top)
            HStack{
                Image(systemName: "safari")
                    .resizable()
                    .frame(width: 50.0, height: 50.0)
                    .foregroundColor(Color("PaletteYellow"))
                VStack{
                    Text("Get lost")
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Follow the compass and choose your route")
                        .font(.system(size: 20))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.leading, 10.0)
            }
            HStack{
                Image(systemName: "book")
                    .resizable()
                    .frame(width: 50.0, height: 50.0)
                    .foregroundColor(Color("PaletteYellow"))
                VStack{
                    Text("Keep track")
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Collect your experiences")
                        .font(.system(size: 20))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.leading, 10.0)
            }
            
            }
            .padding(/*@START_MENU_TOKEN@*/.horizontal, 40.0/*@END_MENU_TOKEN@*/)
            
        }
        
        
        
        }
    }


struct FirstOnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        FirstOnboardingView()
    }
}
