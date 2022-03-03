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
    /// Pictures and current picture index
    var pictures: [PlaceInfoPicture]
    @Binding var showIndex: Int
    
    var body: some View {
        /// Pager view used to a page for every picture
        PagerView(pageCount: pictures.count, currentIndex: $showIndex) {
            ForEach(pictures) { picture in
                /// Simple image. Not zoomable
                VStack {
                    Spacer()
                    Image(uiImage: picture.image)
                        .resizable()
                        .scaledToFit()
                    Spacer()
                }
            }
        }.navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                //Close
                showIndex = -1
            }, label: {
                Image(systemName: "xmark")
            }))
            .background(.black)
    }
}

struct PicturePreviewView_Previews: PreviewProvider {
    static var previews: some View {
        PicturePreviewView(pictures: [PlaceInfoPicture(image: UIImage(named: "monastero-santa-chiara-porticato-esterno")!, object: Picture(data: Data()))], showIndex: .constant(0))
    }
}
