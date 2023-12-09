//
//  SignupButton.swift
//  Swifty-Proteins
//
//  Created by Jean-baptiste DUBILLARD on 08/12/2023.
//

import SwiftUI

struct SignupButton: View {

	@Binding var signin: Bool
	@Binding var barOffset: CGFloat
	let fontColorButton: UInt
	let geometry: GeometryProxy

    var body: some View {
		Button {
			withAnimation {
				signin = false
				barOffset = geometry.frame(in: .local).maxX - (geometry.size.width / 2) - 62
			}
		} label: {
			Text("Signup")
				.font(.system(size: 25))
				.fontWeight(.medium)
				.foregroundStyle(Color(hex: fontColorButton))
		}
    }
}
