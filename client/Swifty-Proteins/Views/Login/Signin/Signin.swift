//
//  SigninFields.swift
//  Swifty-Proteins
//
//  Created by Jean-baptiste DUBILLARD on 08/12/2023.
//

import SwiftUI
import LocalAuthentication

struct Signin: View {

	@StateObject var authentication: Authentication

	@State var username = "Bubonn"
	@State var password = "aA!111"
	@State var disabledButton = true
	@State var asyncOperation = false
	@State var errorMessage = ""
	@State var showAlert = false
	@State var faceId = false

	@Environment(\.scenePhase) private var scenePhase

	var body: some View {
		VStack {
			LoginTextField(placeholder: "Username", value: $username)
				.onChange(of: username) { _ in
					disabledBtn()
				}
			LoginSecureField(placeholder: "Password", value: $password)
				.onChange(of: password) { _ in
					disabledBtn()
				}
			Spacer()
				.frame(height: 25)
			Button {
				Task {
					do {
						asyncOperation = true
						try await authentication.signin(username: username, password: password)
						saveTokenToKeychain(token: authentication.token)
						asyncOperation = false
					} catch {
						handleFetchError(error)
						asyncOperation = false
					}
				}
			} label: {
				Text("Signin")
					.foregroundStyle(disabledButton || asyncOperation ? .white.opacity(0.8) : .white)
					.font(.system(size: 30))
					.fontWeight(.bold)
					.frame(width: 300)
			}
			.padding()
			.frame(width: 300)
			.background(disabledButton || asyncOperation ? .accent.opacity(0.7) : .accent)
			.cornerRadius(50)
//			.disabled(disabledButton || asyncOperation)
		}
		.alert("Error", isPresented: $showAlert) {

		} message: {
			Text(errorMessage)
		}
		.onChange(of: scenePhase) { newPhase in
			if newPhase == .active && faceId == false {
				Task {
					let token = getTokenFromKeychain()
					if let token = token {
						let isValidToken = await authentication.checkToken(token: token)
						if isValidToken {
							authenticate()
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

	func disabledBtn() {
		self.disabledButton = username.isEmpty || password.isEmpty
	}

	func handleFetchError(_ error: Error) {
		switch error {
		case AuthenticationError.invalidFields:
			print("Invalid Field")
			errorMessage = "Incorrect username or password"
		case AuthenticationError.invalidResponse:
			print("Invalid response")
			errorMessage = "An error occurred. Please try again later."
		case AuthenticationError.invalidURL:
			print("Invalid URL")
			errorMessage = "An error occurred. Please try again later."
		default:
			print("Error default")
			errorMessage = "An error occurred. Please try again later."
		}
		showAlert.toggle()
	}
}
