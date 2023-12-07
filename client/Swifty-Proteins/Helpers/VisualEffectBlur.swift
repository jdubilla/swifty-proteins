//
//  VisualEffectBlur.swift
//  Swifty-Proteins
//
//  Created by Jean-baptiste DUBILLARD on 07/12/2023.
//

import SwiftUI

struct VisualEffectBlur: UIViewRepresentable {
	let blurStyle: UIBlurEffect.Style

	func makeUIView(context: Context) -> UIVisualEffectView {
		UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
	}

	func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}
