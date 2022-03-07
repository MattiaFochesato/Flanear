//
//  CameraView.swift
//  Flanear
//
//  Created by Mattia Fochesato on 25/02/22.
//

import SwiftUI

/**
 Boilerplate to implement the native camera picker in SwiftUI
 */
struct CameraView: UIViewControllerRepresentable {
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        @Binding var isCoordinatorShown: Bool
        @Binding var imageInCoordinator: UIImage?
        init(isShown: Binding<Bool>, image: Binding<UIImage?>) {
            _isCoordinatorShown = isShown
            _imageInCoordinator = image
        }
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let unwrapImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
            imageInCoordinator = unwrapImage.fixedOrientation()//Image(uiImage: unwrapImage)
            isCoordinatorShown = false
        }
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            isCoordinatorShown = false
        }
    }
    
    @Binding var isShown: Bool
    @Binding var image: UIImage?
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(isShown: $isShown, image: $image)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<CameraView>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        #if DEBUG
        picker.sourceType = .photoLibrary
        #else
        picker.sourceType = .camera
        #endif
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<CameraView>) {
        
    }
    
}
