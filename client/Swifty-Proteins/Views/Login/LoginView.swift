//
//  LoginView.swift
//  Swifty-Proteins
//
//  Created by Jean-baptiste DUBILLARD on 07/12/2023.
//

import SwiftUI
import LocalAuthentication

struct LoginView: View {

	@StateObject var authentication: Authentication

	@State var signin = true
	let fontColorButton: UInt = 0x5680E9
	@State var keyboard = false

	@State var faceId = false

	@Environment(\.scenePhase) private var scenePhase

	var body: some View {
		ZStack {
			BackgroundImage()
			VStack {
				SigninSignupButtons(signin: $signin)
				Spacer()
					.frame(height: 5)
				if signin {
					Signin(authentication: authentication)
				} else {
					ScrollView {
						Signup(authentication: authentication)
					}
				}
				Spacer()
			}
			.frame(width: 325, height: signin ? 325 : keyboard ? 400 : 510)
			.onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidShowNotification)) { _ in
				keyboard = true
			}.onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidHideNotification)) { _ in
				keyboard = false
			}
			.background(VisualEffectBlur(blurStyle: .light))
			.clipShape(RoundedRectangle(cornerRadius: 30.0))
		}
		.onChange(of: scenePhase) { newPhase in
			if newPhase == .active && faceId == false {
				Task {
					print("Task")
					let token = getTokenFromKeychain()
					if let token = token {
						let isValidToken = await authentication.checkToken(token: token)
						if isValidToken {
							print("isValidToken")
							authenticate()
						} else {
							print("is NOT ValidToken")
						}
					}
				}
			} else if newPhase == .background || newPhase == .inactive {
				faceId = false
			}
		}
	}

	func authenticate() {
		let context = LAContext()
		var error: NSError?
		print("fct authenticate()")

		if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
			let reason = "We need to unlock your data."

			context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, _ in
				if success {
					DispatchQueue.main.async {
						authentication.isAuthenticated = true
					}
				} else {
					faceId = true
					return
				}
			}
		}
	}
}
