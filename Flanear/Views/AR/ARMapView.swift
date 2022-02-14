//
//  ARView.swift
//  Flanear
//
//  Created by Mattia Fochesato on 12/02/22.
//

import SwiftUI
import RealityKit

struct ARMapView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    
    var body: some View {
        ARViewContainer()
            .edgesIgnoringSafeArea(.all)
            //.navigationBarTitle("")
            //        .navigationBarBackButtonHidden(true)
            //        .navigationBarHidden(true)
    }
}

struct ARViewContainer: UIViewRepresentable {
    //let arView: ARView = ARView(frame: .zero, cameraMode: .ar, automaticallyConfigureSession: true)
    func makeUIView(context: Context) -> ARView {
        //arView = ARView(frame: .zero)
        
        return ARView(frame: .zero, cameraMode: .ar, automaticallyConfigureSession: true)
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        
    }
    
}

struct ARMapView_Previews: PreviewProvider {
    static var previews: some View {
        ARMapView()
    }
}
