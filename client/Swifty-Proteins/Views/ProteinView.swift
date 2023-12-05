//
//  ProteinView.swift
//  Swifty-Proteins
//
//  Created by Jean-baptiste DUBILLARD on 30/11/2023.
//

import SwiftUI
import SceneKit

struct ProteinView: UIViewRepresentable {
    var atomsDatas: [AtomDatas]
    var connections: [Connection]
    @Binding var selectedAtomType: String?
        
    @Binding var sharedImage: UIImage?
    
    func makeUIView(context: Context) -> SCNView {
        let scene = SCNScene()
        let scnView = configureSceneView(scene: scene)
        
//        ForEach(atomsDatas) { atom in
//            print(atom)
//        }
//        print(atomsDatas)
//        for i in 0..<atomsDatas.count {
//            print(atomsDatas[i].x)
//            print(atomsDatas[i].y)
//            print(atomsDatas[i].z)
//            print(atomsDatas[i].type)
//            print("\n\n")
//        }
//        print("\n\n")
//        print(connections)

        scnView.scene = scene
        
        let tapGesture = UITapGestureRecognizer(target: context.coordinator,
                                                 action: #selector(Coordinator.handleTap(_:)))
        scnView.addGestureRecognizer(tapGesture)
        
        addAtomsToScene(scene: scene)
        addConnectionsToScene(scene: scene)
        
        addCamera(to: scene, for: scnView)
        
        context.coordinator.scnView = scnView
        
        DispatchQueue.main.async {
            captureImage(context: context)
        }

        return scnView
    }

    func captureImage(context: Context) {
        guard let scnView = context.coordinator.scnView else { return }
        self.sharedImage = scnView.snapshot()
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: ProteinView
        var scnView: SCNView? // Ajoutez cette propriété
        
        init(_ parent: ProteinView) {
            self.parent = parent
        }
        
        @objc func handleTap(_ gesture: UITapGestureRecognizer) {
            let location = gesture.location(in: gesture.view)
            guard let scnView = gesture.view as? SCNView else { return }
            let hitResults = scnView.hitTest(location, options: nil)
            
            
            guard let hit = hitResults.first else {
                parent.selectedAtomType = nil
                return
            }
            
            if let sphereHit = hit.node.geometry {
                if let atomData = parent.atomsDatas.first(where: { $0.refSphere == sphereHit }) {
                    parent.selectedAtomType = atomData.type
                }
            }
            
        }
    }

    func addAtomsToScene(scene: SCNScene) {
        for atomData in atomsDatas where atomData.type != "H" {
//            print("Atom")
            let atomNode = createAtomNode(atomData: atomData)
            atomNode.position = SCNVector3(
                Float(atomData.x),
                Float(atomData.y),
                Float(atomData.z)
            )
            scene.rootNode.addChildNode(atomNode)
        }
    }

    func configureSceneView(scene: SCNScene) -> SCNView {
        let scnView = SCNView()
        scnView.scene = scene
        scnView.autoenablesDefaultLighting = true
        scnView.allowsCameraControl = true
        return scnView
    }

    func addCamera(to scene: SCNScene, for scnView: SCNView) {
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()

        var minX = self.atomsDatas[0].x
        var maxX = self.atomsDatas[0].x
        
        for i in 0..<self.atomsDatas.count {
            if (self.atomsDatas[i].x < minX) {
                minX = self.atomsDatas[i].x
            } else if (self.atomsDatas[i].x > maxX) {
                maxX = self.atomsDatas[i].x
            }
        }
        
        let moyX = (minX + maxX) / 2
        
//        cameraNode.position = SCNVector3(1, 0, 30)
//        cameraNode.position = SCNVector3(self.atomsDatas[0].x, self.atomsDatas[0].y, self.atomsDatas[0].z + 50)
        cameraNode.position = SCNVector3(moyX, self.atomsDatas[0].y, self.atomsDatas[0].z + 60)
        
        scene.rootNode.addChildNode(cameraNode)
        scnView.pointOfView = cameraNode
    }
    
    func createAtomNode(atomData: AtomDatas) -> SCNNode {
        let atomGeometry = SCNSphere(radius: 0.6)
        atomData.refSphere = atomGeometry
        let atomMaterial = SCNMaterial()
        atomMaterial.diffuse.contents = atomData.color
        atomGeometry.materials = [atomMaterial]
        let atomNode = SCNNode(geometry: atomGeometry)
        return atomNode
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) {
        
    }
    

    
    func addConnectionsToScene(scene: SCNScene) {
        for connection in connections {
            guard let fromAtom = atomsDatas.first(where: { $0.id == connection.from }),
                  let toAtom = atomsDatas.first(where: { $0.id == connection.to }) else {
                continue
            }
            
            if (fromAtom.type == "H" || toAtom.type == "H") {
                continue
            }
            
            let fromPosition = SCNVector3(fromAtom.x, fromAtom.y, fromAtom.z)
            let toPosition = SCNVector3(toAtom.x, toAtom.y, toAtom.z)
            
            let deltaX = toPosition.x - fromPosition.x
            let deltaY = toPosition.y - fromPosition.y
            let deltaZ = toPosition.z - fromPosition.z
            
            let distance = sqrt(deltaX * deltaX + deltaY * deltaY + deltaZ * deltaZ)
            
            let halfDistance = distance / 2.0
            
            let bondMaterialFirstHalf = SCNMaterial()
            bondMaterialFirstHalf.diffuse.contents = fromAtom.color

            let bondMaterialSecondHalf = SCNMaterial()
            bondMaterialSecondHalf.diffuse.contents = toAtom.color

            
            let firstHalfPosition = SCNVector3(
                fromPosition.x + deltaX / 4,
                fromPosition.y + deltaY / 4,
                fromPosition.z + deltaZ / 4
            )
            
            let secondHalfPosition = SCNVector3(
                fromPosition.x + deltaX / 4 * 3,
                fromPosition.y + deltaY / 4 * 3,
                fromPosition.z + deltaZ / 4 * 3
            )
            
            let firstHalfGeometry = SCNCylinder(radius: 0.3, height: CGFloat(halfDistance))
            firstHalfGeometry.materials = [bondMaterialFirstHalf]
            
            let secondHalfGeometry = SCNCylinder(radius: 0.3, height: CGFloat(halfDistance))
            secondHalfGeometry.materials = [bondMaterialSecondHalf]
            
            let firstHalfNode = SCNNode(geometry: firstHalfGeometry)
            let secondHalfNode = SCNNode(geometry: secondHalfGeometry)
            
            let connectionParentNode = SCNNode()

            scene.rootNode.addChildNode(connectionParentNode)

            connectionParentNode.addChildNode(firstHalfNode)
            connectionParentNode.addChildNode(secondHalfNode)
            
            firstHalfNode.position = firstHalfPosition
            secondHalfNode.position = secondHalfPosition
            
            let firstHalfDirection = SCNVector3(
                firstHalfPosition.x - fromPosition.x,
                firstHalfPosition.y - fromPosition.y,
                firstHalfPosition.z - fromPosition.z
            )
            
            let secondHalfDirection = SCNVector3(
                toPosition.x - secondHalfPosition.x,
                toPosition.y - secondHalfPosition.y,
                toPosition.z - secondHalfPosition.z
            )
            
            firstHalfNode.look(at: fromPosition, up: firstHalfDirection, localFront: SCNVector3(0, 1, 0))
            secondHalfNode.look(at: toPosition, up: secondHalfDirection, localFront: SCNVector3(0, 1, 0))
        }
    }

    
    func dotProduct(_ a: SCNVector3, _ b: SCNVector3) -> Float {
        return a.x * b.x + a.y * b.y + a.z * b.z
    }

    func crossProduct(_ a: SCNVector3, _ b: SCNVector3) -> SCNVector3 {
        return SCNVector3(a.y * b.z - a.z * b.y,
                         a.z * b.x - a.x * b.z,
                         a.x * b.y - a.y * b.x)
    }  
}


extension SCNVector3 {
    func normalized() -> SCNVector3 {
        let length = sqrt(x * x + y * y + z * z)
        if length != 0.0 {
            return SCNVector3(x / length, y / length, z / length)
        } else {
            return SCNVector3(0, 0, 0)
        }
    }

    func angleAxis(angle: Float) -> SCNQuaternion {
        let halfAngle = angle / 2.0
        let axis = self.normalized()
        let sinHalfAngle = sin(halfAngle)
        return SCNQuaternion(x: axis.x * sinHalfAngle,
                             y: axis.y * sinHalfAngle,
                             z: axis.z * sinHalfAngle,
                             w: cos(halfAngle))
    }
}





//    func addConnectionsToScene(scene: SCNScene) {
//            let bondMaterial = SCNMaterial()
//            bondMaterial.diffuse.contents = UIColor.white
//
//            for connection in connections {
//                guard let fromAtom = atomsDatas.first(where: { $0.id == connection.from }),
//                      let toAtom = atomsDatas.first(where: { $0.id == connection.to }) else {
//                    continue
//                }
//
//                if (fromAtom.type == "H" || toAtom.type == "H") {
//                    continue
//                }
//
//                let fromPosition = SCNVector3(fromAtom.x, fromAtom.y, fromAtom.z)
//                let toPosition = SCNVector3(toAtom.x, toAtom.y, toAtom.z)
//
//                let bondNode = SCNNode()
//                scene.rootNode.addChildNode(bondNode)
//
//                let deltaX = toPosition.x - fromPosition.x
//                let deltaY = toPosition.y - fromPosition.y
//                let deltaZ = toPosition.z - fromPosition.z
//
//                let distance = sqrt(deltaX * deltaX + deltaY * deltaY + deltaZ * deltaZ)
//
//
//                let bondGeometry = SCNCylinder(radius: 0.05, height: CGFloat(distance))
//                bondGeometry.materials = [bondMaterial]
//
//                bondNode.geometry = bondGeometry
//
//                bondNode.position = SCNVector3(
//                    (fromPosition.x + toPosition.x) / 2,
//                    (fromPosition.y + toPosition.y) / 2,
//                    (fromPosition.z + toPosition.z) / 2
//                )
//
//                let direction = SCNVector3(
//                    toPosition.x - fromPosition.x,
//                    toPosition.y - fromPosition.y,
//                    toPosition.z - fromPosition.z
//                )
//
//                bondNode.look(at: toPosition, up: direction, localFront: SCNVector3(0, 1, 0))
//            }
//        }
