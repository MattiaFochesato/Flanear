//
//  Onboarding.swift
//  Flanear
//
//  Created by Marco Pescosolido on 03/03/22.
//

import SwiftUI
import Foundation

/*struct Onboarding: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}*/

struct Onboarding: View{
    
    var body: some View{
        
        
        TabView{
            FirstOnboardingView()
            SecondOnboardingView()
            ThirdOnboardingView()
            FourthOnboardingView()
        } // TabView
        .tabViewStyle(PageTabViewStyle())
        

    }
    
}
struct Onboarding_Previews: PreviewProvider {
    static var previews: some View {
        Onboarding()
    }
}
