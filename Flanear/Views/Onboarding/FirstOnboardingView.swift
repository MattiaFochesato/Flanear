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
            Text("what-is-flanear")
                .font(.system(size: 40))
                .fontWeight(.bold)
                .padding(.top)
            
            Section() {
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                        .resizable()
                        .frame(width: 50.0, height: 50.0)
                        .foregroundColor(Color("PaletteYellow"))
                    
                    VStack{
                        Text("visit-places")
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("visit-places-description")
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
                        Text("get-lost")
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("get-lost-description")
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
                        Text("keep-track")
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("keep-track-description")
                            .font(.system(size: 20))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.leading, 10.0)
                }
                
            }
            .padding(.horizontal, 40.0)
            .padding(.vertical, 20)
            //Spacer()
        }
        
        
        
    }
}


struct FirstOnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        FirstOnboardingView()
    }
}
