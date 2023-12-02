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
    
    func makeUIView(context: Context) -> SCNView {
        let scene = SCNScene()
        let scnView = configureSceneView(scene: scene)

        scnView.scene = scene
        
        let tapGesture = UITapGestureRecognizer(target: context.coordinator,
                                                 action: #selector(Coordinator.handleTap(_:)))
        scnView.addGestureRecognizer(tapGesture)
        
        addAtomsToScene(scene: scene)
        addConnectionsToScene(scene: scene)
        
//        let scnView = configureSceneView(scene: scene)
        addCamera(to: scene, for: scnView)
        
        return scnView
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: ProteinView
        
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
            
            scene.rootNode.addChildNode(firstHalfNode)
            scene.rootNode.addChildNode(secondHalfNode)
            
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

