//
//  SigninButton.swift
//  Swifty-Proteins
//
//  Created by Jean-baptiste DUBILLARD on 08/12/2023.
//

import SwiftUI

struct SigninButton: View {

	@Binding var signin: Bool
	@Binding var barOffset: CGFloat
	let fontColorButton: UInt
	let geometry: GeometryProxy

    var body: some View {
		Button {
			withAnimation {
				signin = true
				barOffset = geometry.frame(in: .local).minX - 11
			}
		} label: {
			Text("Signin")
				.font(.system(size: 25))
				.fontWeight(.medium)
				.foregroundStyle(Color(hex: fontColorButton))
		}
    }
}
