//
//  SigninFields.swift
//  Swifty-Proteins
//
//  Created by Jean-baptiste DUBILLARD on 08/12/2023.
//

import SwiftUI

struct Signin: View {

	@StateObject var authentication: Authentication

	@State var username = ""
	@State var password = ""
	@State var disabledButton = true
	@State var asyncOperation = false
	@State var errorMessage = ""
	@State var showAlert = false

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
						if let token = getTokenFromKeychain() {
							print("TEST TOKEN", token)
						}
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
			.disabled(disabledButton || asyncOperation)
		}
		.alert("Error", isPresented: $showAlert) {

		} message: {
			Text(errorMessage)
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
