//
//  ContentView.swift
//  Swifty-Proteins
//
//  Created by Jean-baptiste DUBILLARD on 29/11/2023.
//

import SwiftUI
import SceneKit

struct ContentView: View {
    
    @StateObject var request = Ligands()
    
    @State var responseApi: String?
    @State var showAlert = false
    @State var errorMessage = ""
    @State var atomsDatas: [AtomDatas] = []
    @State var isLoading = true
    
    var body: some View {
        VStack {
            if isLoading {
                Text("Chargement...")
            } else {
                ProteinView(atomsDatas: $atomsDatas)
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
        .task {
            fetchData()
        }
    }
    
    func fetchData() {
        Task {
            isLoading = true
            do {
                self.atomsDatas = try await request.fetchLigands()
                isLoading = false
            } catch {
                isLoading = false
                handleFetchError(error)
            }
        }
    }
    
    func handleFetchError(_ error: Error) {
        switch error {
        case LigandError.invalidData:
            print("Invalid data")
            errorMessage = "Invalid data"
        case LigandError.invalidReponse:
            errorMessage = "Invalid response"
            print("Invalid response")
        case LigandError.invalidURL:
            errorMessage = "Invalid URL"
            print("Invalid URL")
        default:
            errorMessage = "Invalid URL \(error.localizedDescription)"
        }
        showAlert.toggle()
    }
}

#Preview {
    ContentView()
}

//struct MoleculeSceneView: UIViewRepresentable {
//    func makeUIView(context: Context) -> SCNView {
//        // Création d'une scène 3D
//        let scene = SCNScene()
//
//        // Création d'une sphère pour représenter un atome d'oxygène
//        let oxygenGeometry = SCNSphere(radius: 0.15)
//        let oxygenMaterial = SCNMaterial()
//        oxygenMaterial.diffuse.contents = UIColor.red
//        oxygenGeometry.materials = [oxygenMaterial]
//        let oxygenNode = SCNNode(geometry: oxygenGeometry)
//        oxygenNode.position = SCNVector3(0, 0, 0) // Position de l'atome d'oxygène
//
//        // Création de deux sphères pour représenter les atomes d'hydrogène
//        let hydrogenGeometry = SCNSphere(radius: 0.1)
//        let hydrogenMaterial = SCNMaterial()
//        hydrogenMaterial.diffuse.contents = UIColor.gray
//        hydrogenGeometry.materials = [hydrogenMaterial]
//
//        let hydrogenNode1 = SCNNode(geometry: hydrogenGeometry)
//        hydrogenNode1.position = SCNVector3(-0.2, 0, 0.2) // Position du premier atome d'hydrogène
//
//        let hydrogenNode2 = SCNNode(geometry: hydrogenGeometry)
//        hydrogenNode2.position = SCNVector3(0.2, 0, 0.2) // Position du deuxième atome d'hydrogène
//
//        // Création d'une liaison entre l'oxygène et les atomes d'hydrogène
//        let bond = SCNCylinder(radius: 0.05, height: 0.4) // Taille de la liaison
//        let bondMaterial = SCNMaterial()
//        bondMaterial.diffuse.contents = UIColor.white
//        bond.firstMaterial = bondMaterial
//        let bondNode1 = SCNNode(geometry: bond)
//        bondNode1.position = SCNVector3(-0.1, 0, 0.1) // Position du premier lien
//        let bondNode2 = SCNNode(geometry: bond)
//        bondNode2.position = SCNVector3(0.1, 0, 0.1) // Position du deuxième lien
//
//        // Ajout des nœuds à la scène
//        scene.rootNode.addChildNode(oxygenNode)
//        scene.rootNode.addChildNode(hydrogenNode1)
//        scene.rootNode.addChildNode(hydrogenNode2)
//        scene.rootNode.addChildNode(bondNode1)
//        scene.rootNode.addChildNode(bondNode2)
//
//        // Liaison des nœuds (création des connexions entre les atomes)
//        bondNode1.eulerAngles.x = Float.pi / 3 // Ajustement de l'orientation du premier lien
//        bondNode2.eulerAngles.x = Float.pi / 2 // Ajustement de l'orientation du deuxième lien
//
//        // Configuration de la vue SceneKit pour afficher la scène
//        let scnView = SCNView()
//        scnView.scene = scene
//        scnView.autoenablesDefaultLighting = true // Activer l'éclairage par défaut de la scène
//        scnView.allowsCameraControl = true
//
//        return scnView
//    }
//
//    func updateUIView(_ uiView: SCNView, context: Context) {
//        // Mettre à jour la vue si nécessaire
//    }
//}

//struct AtomSceneView: UIViewRepresentable {
//    func makeUIView(context: Context) -> SCNView {
//        // Création d'une scène 3D
//        let scene = SCNScene()
//
//        // Création d'une sphère pour représenter l'atome
//        let atomGeometry = SCNSphere(radius: 0.1) // Changer le rayon pour la taille de l'atome
//        let atomMaterial = SCNMaterial()
//        atomMaterial.diffuse.contents = UIColor.red // Changer la couleur de l'atome
//        atomGeometry.materials = [atomMaterial]
//
//        // Création d'un nœud avec la géométrie de la sphère (représentant l'atome)
//        let atomNode = SCNNode(geometry: atomGeometry)
//
//        // Positionnement de l'atome dans la scène
//        atomNode.position = SCNVector3(0, 0, -2) // Changer les valeurs pour positionner l'atome
//
//        // Ajout de l'atome à la scène
//        scene.rootNode.addChildNode(atomNode)
//
//        // Configuration de la vue SceneKit pour afficher la scène
//        let scnView = SCNView()
//        scnView.scene = scene
//        scnView.autoenablesDefaultLighting = true // Activer l'éclairage par défaut de la scène
//
//        return scnView
//    }
//
//    func updateUIView(_ uiView: SCNView, context: Context) {
//        // Mettre à jour la vue si nécessaire
//    }
//}



//struct MoleculeView: UIViewRepresentable {
//    func makeUIView(context: Context) -> SCNView {
//        let sceneView = SCNView()
//        let scene = SCNScene()
//        
//        let carbon = SCNSphere(radius: 0.1)
//        carbon.firstMaterial?.diffuse.contents = UIColor.gray
//        let carbonNode = SCNNode(geometry: carbon)
//        carbonNode.position = SCNVector3(0, 0, 0)
//        scene.rootNode.addChildNode(carbonNode)
//        
//        let hydrogen = SCNSphere(radius: 0.1)
//        hydrogen.firstMaterial?.diffuse.contents = UIColor.black
//        let hydrogenNode = SCNNode(geometry: hydrogen)
//        hydrogenNode.position = SCNVector3(0, 0, 0)
//        scene.rootNode.addChildNode(hydrogenNode)
//        
//        let bond = SCNCylinder(radius: 0.05, height: 1.0)
//        bond.firstMaterial?.diffuse.contents = UIColor.gray
//        let bondNode = SCNNode(geometry: bond)
//        bondNode.position = SCNVector3(0, 0, 0)
//        bondNode.eulerAngles.z = Float.pi / 2
//        
//        let bond2 = SCNCylinder(radius: 0.05, height: 1.0)
//        bond2.firstMaterial?.diffuse.contents = UIColor.gray
//        let bond2Node = SCNNode(geometry: bond2)
//        bond2Node.position = SCNVector3(0, 0, 0)
//        bond2Node.eulerAngles.z = Float.pi / 2
//        
//        let bondNodeWrapper = SCNNode()
//        bondNodeWrapper.addChildNode(bondNode)
//        scene.rootNode.addChildNode(bondNodeWrapper)
//        
//        hydrogenNode.position = SCNVector3(0.5, 0, 0)
//        bondNodeWrapper.addChildNode(hydrogenNode)
//        
//        carbonNode.position = SCNVector3(-0.5, 0, 0)
//        bondNodeWrapper.addChildNode(carbonNode)
//        
//        bond2Node.position = SCNVector3(1, 0, 0)
//        bondNodeWrapper.addChildNode(bond2Node)
//        
//        sceneView.scene = scene
//        sceneView.allowsCameraControl = true
//        
//        return sceneView
//    }
//    
//    func updateUIView(_ uiView: SCNView, context: Context) {
//        // Update view if needed
//    }
//}
