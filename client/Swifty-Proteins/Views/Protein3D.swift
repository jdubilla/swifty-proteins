//
//  ProteinView.swift
//  Swifty-Proteins
//
//  Created by Jean-baptiste DUBILLARD on 30/11/2023.
//

import SwiftUI
import SceneKit

struct Protein3D: UIViewRepresentable {
	var atomsDatas: [AtomDatas]
	var connections: [Connection]
	@Binding var selectedAtom: AtomDatas?

	@Binding var sharedImage: UIImage?

	func makeUIView(context: Context) -> SCNView {
		let scene = SCNScene()
		let scnView = configureSceneView(scene: scene)

		scnView.scene = scene

		let tapGesture = UITapGestureRecognizer(target: context.coordinator,
												action: #selector(Coordinator.handleTap(_:)))
		scnView.addGestureRecognizer(tapGesture)

		addAtomsToScene(scene: scene)
		addConnectionsToScene(scene: scene)

		addCamera(to: scene, for: scnView)

		context.coordinator.scnView = scnView

		DispatchQueue.main.async {
			DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
				captureImage(context: context)
			}
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
		var parent: Protein3D
		var scnView: SCNView?

		init(_ parent: Protein3D) {
			self.parent = parent
		}

		@objc func handleTap(_ gesture: UITapGestureRecognizer) {
			let location = gesture.location(in: gesture.view)
			guard let scnView = gesture.view as? SCNView else { return }
			let hitResults = scnView.hitTest(location, options: nil)

			guard let hit = hitResults.first else {
				parent.selectedAtom = nil
				return
			}

			if let sphereHit = hit.node.geometry {
				if let atomData = parent.atomsDatas.first(where: { $0.refSphere == sphereHit }) {
					parent.selectedAtom = atomData
				}
			}

		}
	}

	func addAtomsToScene(scene: SCNScene) {
		for atomData in atomsDatas {
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
			if self.atomsDatas[i].x < minX {
				minX = self.atomsDatas[i].x
			} else if self.atomsDatas[i].x > maxX {
				maxX = self.atomsDatas[i].x
			}
		}

		let moyX = (minX + maxX) / 2

		var minY = self.atomsDatas[0].y
		var maxY = self.atomsDatas[0].y

		for i in 0..<self.atomsDatas.count {
			if self.atomsDatas[i].y < minY {
				minY = self.atomsDatas[i].y
			} else if self.atomsDatas[i].y > maxY {
				maxY = self.atomsDatas[i].y
			}
		}

		let moyY = (minY + maxY) / 2

		var cameraY = maxX - minX > maxY - minY ? maxX - minX : maxY - minY
		cameraY = cameraY * 2 > 90 ? 90 : cameraY * 2

		cameraNode.position = SCNVector3(moyX, moyY, self.atomsDatas[0].z + cameraY)

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

	func simpleConnection(fromAtom: AtomDatas, toAtom: AtomDatas, scene: SCNScene) {
        // Calculate positions of atoms
		let fromPosition = SCNVector3(fromAtom.x, fromAtom.y, fromAtom.z)
		let toPosition = SCNVector3(toAtom.x, toAtom.y, toAtom.z)

        // Calculate the distance between the atoms
		let deltaX = toPosition.x - fromPosition.x
		let deltaY = toPosition.y - fromPosition.y
		let deltaZ = toPosition.z - fromPosition.z
		let distance = sqrt(deltaX * deltaX + deltaY * deltaY + deltaZ * deltaZ)

        // Calculate the midpoint between the atoms
		let halfDistance = distance / 2.0

        // Create materials for the connection halves
		let bondMaterialFirstHalf = SCNMaterial()
		bondMaterialFirstHalf.diffuse.contents = fromAtom.color

		let bondMaterialSecondHalf = SCNMaterial()
		bondMaterialSecondHalf.diffuse.contents = toAtom.color

        // Calculate positions of the first and second halves of the connection
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

        // Create geometries for the first and second halves of the connection
		let firstHalfGeometry = SCNCylinder(radius: 0.3, height: CGFloat(halfDistance))
		firstHalfGeometry.materials = [bondMaterialFirstHalf]

		let secondHalfGeometry = SCNCylinder(radius: 0.3, height: CGFloat(halfDistance))
		secondHalfGeometry.materials = [bondMaterialSecondHalf]

        // Create nodes for the first and second halves of the connection
		let firstHalfNode = SCNNode(geometry: firstHalfGeometry)
		let secondHalfNode = SCNNode(geometry: secondHalfGeometry)

        // Create a parent node for the connection
		let connectionParentNode = SCNNode()

        // Add the first and second halves to the parent node
		connectionParentNode.addChildNode(firstHalfNode)
		connectionParentNode.addChildNode(secondHalfNode)

        // Set positions for the first and second halves
		firstHalfNode.position = firstHalfPosition
		secondHalfNode.position = secondHalfPosition

        // Orient the first and second halves toward their respective atoms
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

        // Add the parent node to the scene
		scene.rootNode.addChildNode(connectionParentNode)
	}

	func doubleConnection(fromAtom: AtomDatas, toAtom: AtomDatas, scene: SCNScene) {
		for i in 0...1 {
			let fromPosition = SCNVector3(fromAtom.x + (i == 0 ? 0.15 : -0.15), fromAtom.y + (i == 0 ? 0.15 : -0.15), fromAtom.z + (i == 0 ? 0.15 : -0.15))
			let toPosition = SCNVector3(toAtom.x + (i == 0 ? 0.15 : -0.15), toAtom.y + (i == 0 ? 0.15 : -0.15), toAtom.z + (i == 0 ? 0.15 : -0.15))

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

			let firstHalfGeometry = SCNCylinder(radius: 0.15, height: CGFloat(halfDistance))
			firstHalfGeometry.materials = [bondMaterialFirstHalf]

			let secondHalfGeometry = SCNCylinder(radius: 0.15, height: CGFloat(halfDistance))
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

	func addConnectionsToScene(scene: SCNScene) {

		for connection in connections {
			guard let fromAtom = atomsDatas.first(where: { $0.id == connection.from }),
				  let toAtom = atomsDatas.first(where: { $0.id == connection.to }) else {
				continue
			}

			if connection.connectionType == 2 {
				doubleConnection(fromAtom: fromAtom, toAtom: toAtom, scene: scene)
			} else {
				simpleConnection(fromAtom: fromAtom, toAtom: toAtom, scene: scene)
			}
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
