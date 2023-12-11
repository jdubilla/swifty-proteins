//
//  SigninSignupButtons.swift
//  Swifty-Proteins
//
//  Created by Jean-baptiste DUBILLARD on 08/12/2023.
//

import SwiftUI

struct SigninSignupButtons: View {

	@Binding var signin: Bool

	@State var barOffset: CGFloat = 0
	@State var barWidth: CGFloat = 80
	let fontColorButton: UInt = 0x5680E9

	var body: some View {
		GeometryReader { geometry in
			HStack(spacing: 40) {
				HeaderSigninButton(signin: $signin, barOffset: $barOffset, fontColorButton: fontColorButton, geometry: geometry)
				HeaderSignupButton(signin: $signin, barOffset: $barOffset, fontColorButton: fontColorButton, geometry: geometry)
			}
			.padding()
			.onAppear {
				barOffset = geometry.frame(in: .local).minX - 11
			}
			.overlay(
				Rectangle()
					.frame(width: barWidth, height: 3)
					.foregroundColor(Color(hex: fontColorButton))
					.offset(x: barOffset - (geometry.size.width / 7), y: -13), alignment: .bottom
			)
			.frame(width: geometry.size.width, alignment: .center)
		}
		.frame(height: 70)
	}
}
