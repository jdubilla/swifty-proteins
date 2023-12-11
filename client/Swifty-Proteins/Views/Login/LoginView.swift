//
//  LoginView.swift
//  Swifty-Proteins
//
//  Created by Jean-baptiste DUBILLARD on 07/12/2023.
//

import SwiftUI

struct LoginView: View {

	@StateObject var authentication: Authentication

	@State var signin = true
	let fontColorButton: UInt = 0x5680E9

	var body: some View {
		ZStack {
			BackgroundImage()
			VStack {
				SigninSignupButtons(signin: $signin)
				Spacer()
					.frame(height: 10)
				if signin {
						Signin(authentication: authentication)
				} else {
					Signup(authentication: authentication)
				}
				Spacer()
			}
			.frame(width: 325, height: signin ? 325 : 525)
			.background(VisualEffectBlur(blurStyle: .light))
			.clipShape(RoundedRectangle(cornerRadius: 30.0))
		}

	}
}
