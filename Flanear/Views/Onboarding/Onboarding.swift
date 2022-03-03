//
//  Onboarding.swift
//  Flanear
//
//  Created by Marco Pescosolido on 03/03/22.
//

import SwiftUI
import Foundation

struct Onboarding: View{
    @Binding var showOnboarding: Bool
    @State private var selectedPage = 0
    
    var body: some View{
        ZStack {
            TabView(selection: $selectedPage) {
                FirstOnboardingView()
                    .tag(0)
                SecondOnboardingView()
                    .tag(1)
                ThirdOnboardingView()
                    .tag(2)
                FourthOnboardingView()
                    .tag(3)
            }
            .tabViewStyle(PageTabViewStyle())
            .onAppear {
                setupAppearance()
            }
            
            ZStack(alignment: .bottom) {
                Color.clear
                HStack {
                    Spacer()
                    Button {
                        if selectedPage != 3 {
                            selectedPage = selectedPage + 1
                        }else{
                            showOnboarding = false
                        }
                    } label: {
                        
                        Image(systemName: selectedPage != 3 ? "arrow.right" : "paperplane.fill")
                                .font(.title2.bold())
                                .foregroundColor(.textWhite)
                                .padding(selectedPage != 3 ? 20 : 17)
                                .background(Circle())
                            
                        
                    }.padding(.bottom, 24)
                }.padding(36)
                    
            }

        }
    }
    
    /**
     Change the page indicator color to black
     */
    func setupAppearance() {
        UIPageControl.appearance().currentPageIndicatorTintColor = .black
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)
      }
}
struct Onboarding_Previews: PreviewProvider {
    static var previews: some View {
        Onboarding(showOnboarding: .constant(true))
    }
}
