//
//  PicturePreviewView.swift
//  Flanear
//
//  Created by Mattia Fochesato on 28/02/22.
//

import SwiftUI

/**
 View used to show the pictures that you have taken like a photo gallery
 */
struct PicturePreviewView: View {
    /// Pictures and current picture to show id
    var pictures: [PlaceInfoPicture]
    @Binding var pictureToShowId: Int64
    
    var body: some View {
        /// Pager view used to a page for every picture
        TabView(selection: $pictureToShowId) {
            ForEach(pictures) { picture in
                /// Simple image. Not zoomable
                VStack {
                    Spacer()
                    Image(uiImage: picture.image)
                        .resizable()
                        .scaledToFit()
                    Spacer()
                }.background(.black)
                    .padding([.leading, .trailing], 1)
                    .tag(picture.id ?? 0)
                
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .background(.black)
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            /// Close view
            pictureToShowId = -1
        }, label: {
            Image(systemName: "xmark")
        }))
        
    }
}

struct PicturePreviewView_Previews: PreviewProvider {
    static var previews: some View {
        PicturePreviewView(pictures: [PlaceInfoPicture(image: UIImage(named: "monastero-santa-chiara-porticato-esterno")!, object: Picture(data: Data()))], pictureToShowId: .constant(0))
    }
}
