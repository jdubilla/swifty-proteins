//
//  ProteinView.swift
//  Swifty-Proteins
//
//  Created by Jean-baptiste DUBILLARD on 30/11/2023.
//

import SwiftUI
import SceneKit

struct ProteinView: UIViewRepresentable {
    
    @Binding var atomsDatas: [AtomDatas]
    
    func makeUIView(context: Context) -> SCNView {
        let scene = SCNScene()
        
        
        let scnView = SCNView()
        scnView.scene = scene
        
        return scnView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
