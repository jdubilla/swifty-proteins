//
//  AtomDatas.swift
//  Swifty-Proteins
//
//  Created by Jean-baptiste DUBILLARD on 30/11/2023.
//

import Foundation
import SwiftUI
import SceneKit

class AtomDatas {
    var id: Int
    var x: Float
    var y: Float
    var z: Float
    var type: String
    var color: UIColor
    var refSphere: SCNSphere?

    init(id: Int, type: String, x: Float, y: Float, z: Float, color: UIColor) {
        self.id = id
        self.type = type
        self.x = x
        self.y = y
        self.z = z
        self.color = color
    }
}
