//
//  SignupFields.swift
//  Swifty-Proteins
//
//  Created by Jean-baptiste DUBILLARD on 08/12/2023.
//

import SwiftUI

struct SignupFields: View {

//	@Binding var isLogin: Bool
	@StateObject var authentication: Authentication

	@State var username = "Jbjbjb"
	@State var password = "Aa1!!!"
	@State var confPassword = "Aa1!!!"

    var body: some View {
		LoginTextField(placeholder: "Username", value: $username)
		LoginSecureField(placeholder: "Password", value: $password)
		LoginSecureField(placeholder: "Confirm password", value: $confPassword)
		Spacer()
			.frame(height: 25)
		Button {
			Task {
				do {
					try await authentication.signup(username: username, password: password, confPassword: confPassword)
//					try await authentication.test()
				} catch {
					print("Erreur !!!")
					handleFetchError(error)
				}
			}
		} label: {
			Text("Signup")
				.foregroundStyle(.white)
				.font(.system(size: 30))
				.fontWeight(.bold)
				.frame(width: 300)
		}
		.padding()
		.frame(width: 300)
		.background(.accent)
		.cornerRadius(50)
    }

	func handleFetchError(_ error: Error) {
		switch error {
		case AuthenticationError.invalidData:
			print("Invalid data")
//			errorMessage = "Invalid data"
//		case AuthenticationError.invalidReponse:
//			errorMessage = "Invalid response"
			print("Invalid response")
		case AuthenticationError.invalidURL:
//			errorMessage = "Invalid URL"
			print("Invalid URL")
		default:
			print("Error default")
//			errorMessage = "Invalid URL \(error.localizedDescription)"
		}
//		showAlert.toggle()
	}
}
