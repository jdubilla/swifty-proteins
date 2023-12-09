//
//  ColorHexa.swift
//  Swifty-Proteins
//
//  Created by Jean-baptiste DUBILLARD on 08/12/2023.
//

import SwiftUI

extension Color {
	init(hex: UInt, alpha: Double = 1.0) {
		self.init(
			.sRGB,
			red: Double((hex >> 16) & 0xFF) / 255.0,
			green: Double((hex >> 8) & 0xFF) / 255.0,
			blue: Double(hex & 0xFF) / 255.0,
			opacity: alpha
		)
	}
}
