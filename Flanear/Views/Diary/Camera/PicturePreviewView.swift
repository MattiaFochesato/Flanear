//
//  PicturePreviewView.swift
//  Flanear
//
//  Created by Mattia Fochesato on 28/02/22.
//

import SwiftUI

struct PicturePreviewView: View {
    var pictures: [PlaceInfoPicture]
    @Binding var showIndex: Int
    
    
    var body: some View {
        PagerView(pageCount: 3, currentIndex: $showIndex) {
            ForEach(pictures) { picture in
                Image(uiImage: picture.image)
                    .resizable()
                    .scaledToFit()
            }
        }
    }
}

struct PicturePreviewView_Previews: PreviewProvider {
    static var previews: some View {
        PicturePreviewView(pictures: [PlaceInfoPicture(image: UIImage(named: "monastero-santa-chiara-porticato-esterno")!, object: Picture(data: Data()))], showIndex: .constant(0))
    }
}
