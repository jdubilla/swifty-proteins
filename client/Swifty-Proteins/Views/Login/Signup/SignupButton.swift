//
//  SignupButton.swift
//  Swifty-Proteins
//
//  Created by Jean-baptiste DUBILLARD on 11/12/2023.
//

import SwiftUI

struct SignupButton: View {
	@Binding var disabledBtn: Bool
	@Binding var username: String
	@Binding var password: String
	@Binding var confPassword: String
	@StateObject var authentication: Authentication
	@Binding var showAlert: Bool
	@Binding var errorMessage: String

	@State var asyncOperation = false

	var body: some View {
		Button {
			Task {
				do {
					asyncOperation = true
					try await authentication.signup(username: username, password: password, confPassword: confPassword)
					asyncOperation = false
				} catch {
					handleFetchError(error)
					asyncOperation = false
				}
			}
		} label: {
			Text("Signup")
				.foregroundStyle(disabledBtn ? .white.opacity(0.8) : .white)
				.font(.system(size: 30))
				.fontWeight(.bold)
				.frame(width: 300)
		}
		.padding()
		.frame(width: 300)
		.background(disabledBtn ? .accent.opacity(0.7) : .accent)
		.cornerRadius(50)
		.disabled(disabledBtn || asyncOperation)
	}
//
//	func disabledButton() -> Bool {
//		return(
//			!isUsernameValid ||
//			!isPasswordLenValid ||
//			!isSamePasswordValid ||
//			!isPasswordSpecialCharValid ||
//			!isPasswordMinValid ||
//			!isPasswordMajValid ||
//			!isPasswordNumberValid ||
//			disabledBtn
//		)
//	}

	func handleFetchError(_ error: Error) {
		switch error {
		case AuthenticationError.invalidData:
			print("Invalid data")
			errorMessage = "An error occurred. Please try again later."
		case AuthenticationError.invalidResponse:
			print("Invalid response")
			errorMessage = "An error occurred. Please try again later."
		case AuthenticationError.invalidUsername:
			print("Username already taken")
			errorMessage = "The username is not available. Please choose another one."
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
