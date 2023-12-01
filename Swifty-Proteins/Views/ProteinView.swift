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
    
    func makeUIView(context: Context) -> SCNView {
        let scene = SCNScene()
        let bondMaterial = SCNMaterial()
        bondMaterial.diffuse.contents = UIColor.white

        addAtomsToScene(scene: scene)
        addConnectionsToScene(scene: scene)

        let scnView = configureSceneView(scene: scene)
        addCamera(to: scene, for: scnView)

        return scnView
    }

    func addAtomsToScene(scene: SCNScene) {
        for atomData in atomsDatas where atomData.type != "H" {
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
        cameraNode.position = SCNVector3(1, 0, 30)

        scene.rootNode.addChildNode(cameraNode)
        scnView.pointOfView = cameraNode
    }
    
    func createAtomNode(atomData: AtomDatas) -> SCNNode {
        let atomGeometry = SCNSphere(radius: 0.15)
        let atomMaterial = SCNMaterial()
        atomMaterial.diffuse.contents = atomData.type == "O" ? UIColor.red : UIColor.gray
        atomGeometry.materials = [atomMaterial]
        let atomNode = SCNNode(geometry: atomGeometry)
        return atomNode
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) {
        
    }

//    func addConnectionsToScene(scene: SCNScene) {
//        let bondMaterial = SCNMaterial()
//        bondMaterial.diffuse.contents = UIColor.white
//        
//        for connection in connections {
//            guard let fromAtom = atomsDatas.first(where: { $0.id == connection.from }),
//                  let toAtom = atomsDatas.first(where: { $0.id == connection.to }) else {
//                continue
//            }
//            
//            if (fromAtom.type == "H" || toAtom.type == "H") {
//                continue
//            }
//            
//            let fromPosition = SCNVector3(fromAtom.x, fromAtom.y, fromAtom.z)
//            let toPosition = SCNVector3(toAtom.x, toAtom.y, toAtom.z)
//            
//            let deltaX = toPosition.x - fromPosition.x
//            let deltaY = toPosition.y - fromPosition.y
//            let deltaZ = toPosition.z - fromPosition.z
//            
//            let distance = sqrt(deltaX * deltaX + deltaY * deltaY + deltaZ * deltaZ)
//            
//            let bondGeometry = SCNCylinder(radius: 0.05, height: CGFloat(distance))
//            bondGeometry.materials = [bondMaterial]
//            
//            let bondNode = SCNNode(geometry: bondGeometry)
//            
//            bondNode.position = SCNVector3((fromPosition.x + toPosition.x) / 2,
//                                           (fromPosition.y + toPosition.y) / 2,
//                                           (fromPosition.z + toPosition.z) / 2)
//            
//            let xAxis = SCNVector3(1, 0, 0)
//
//            let bondDirection = SCNVector3(deltaX / distance, deltaY / distance, deltaZ / distance)
//
//            let dotProduct = dotProduct(xAxis, bondDirection)
//            let rotationAxis = crossProduct(xAxis, bondDirection)
//            
//            let rotationAngle = acos(dotProduct)
//            let rotationQuaternion = rotationAxis.angleAxis(angle: rotationAngle)
//            bondNode.orientation = rotationQuaternion
//
//            
//            scene.rootNode.addChildNode(bondNode)
//        }
//    }
    
    func addConnectionsToScene(scene: SCNScene) {
        let bondMaterial = SCNMaterial()
        bondMaterial.diffuse.contents = UIColor.white
        
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
            
            let bondNode = SCNNode()
            scene.rootNode.addChildNode(bondNode)
            
            let deltaX = toPosition.x - fromPosition.x
            let deltaY = toPosition.y - fromPosition.y
            let deltaZ = toPosition.z - fromPosition.z
            
            let distance = sqrt(deltaX * deltaX + deltaY * deltaY + deltaZ * deltaZ)


            let bondGeometry = SCNCylinder(radius: 0.05, height: CGFloat(distance))
            bondGeometry.materials = [bondMaterial]
            
            bondNode.geometry = bondGeometry
            
            bondNode.position = SCNVector3(
                (fromPosition.x + toPosition.x) / 2,
                (fromPosition.y + toPosition.y) / 2,
                (fromPosition.z + toPosition.z) / 2
            )
            
            let direction = SCNVector3(
                toPosition.x - fromPosition.x,
                toPosition.y - fromPosition.y,
                toPosition.z - fromPosition.z
            )
            
            bondNode.look(at: toPosition, up: direction, localFront: SCNVector3(0, 1, 0))
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

