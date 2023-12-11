//
//  SignupFields.swift
//  Swifty-Proteins
//
//  Created by Jean-baptiste DUBILLARD on 08/12/2023.
//

import SwiftUI

struct Signup: View {

	@StateObject var authentication: Authentication

	@State private var username = ""
	@State private var password = ""
	@State private var confPassword = ""
	@State private var disabledBtn = true
	@State private var showAlert = false
	@State private var errorMessage = ""
	@State private var isUsernameValid = false
	@State private var isPasswordLenValid = false
	@State private var isSamePasswordValid = false
	@State private var isPasswordSpecialCharValid = false
	@State private var isPasswordMinValid = false
	@State private var isPasswordMajValid = false
	@State private var isPasswordNumberValid = false

	var body: some View {
		VStack {
			UsernameTextField(username: $username, isUsernameValid: $isUsernameValid)
				.onChange(of: username) { _ in
					disabledButton()
				}
			PasswordFields(password: $password, confPassword: $confPassword, isPasswordLenValid: $isPasswordLenValid, isSamePasswordValid: $isSamePasswordValid, isPasswordSpecialCharValid: $isPasswordSpecialCharValid, isPasswordMinValid: $isPasswordMinValid, isPasswordMajValid: $isPasswordMajValid, isPasswordNumberValid: $isPasswordNumberValid)
				.onChange(of: password) { _ in
					disabledButton()
				}
				.onChange(of: confPassword) { _ in
					disabledButton()
				}
			SignupButton(disabledBtn: $disabledBtn, username: $username, password: $password, confPassword: $confPassword, authentication: authentication, showAlert: $showAlert, errorMessage: $errorMessage)
				.padding()
				.frame(width: 300)
		}
		.alert("Error", isPresented: $showAlert) {

		} message: {
			Text(errorMessage)
		}
	}

	func disabledButton() {
//		return(
		self.disabledBtn = !isUsernameValid ||
			!isPasswordLenValid ||
			!isSamePasswordValid ||
			!isPasswordSpecialCharValid ||
			!isPasswordMinValid ||
			!isPasswordMajValid ||
			!isPasswordNumberValid
//			disabledBtn
//		print(disabledBtn)
//		)
	}
}

//struct Signup: View {
//
//	@StateObject var authentication: Authentication
//
//	@State var username = ""
//	@State var password = ""
//	@State var confPassword = ""
//	@State var disabledBtn = false
//	@State var showAlert = false
//	@State var errorMessage = ""
//	@State var isUsernameValid = false
//	@State var isPasswordLenValid = false
//	@State var isSamePasswordValid = false
//	@State var isPasswordSpecialCharValid = false
//	@State var isPasswordMinValid = false
//	@State var isPasswordMajValid = false
//	@State var isPasswordNumberValid = false
//
//	var body: some View {
//		VStack {
//			LoginTextField(placeholder: "Username", value: $username)
//				.onChange(of: username) { newValue in
//					isUsernameValid = newValue.count <= 3 ? false : true
//					if newValue.count > 15 {
//						username = String(username.prefix(15))
//					}
//				}
//			Text("\(isUsernameValid ? "✔️" : "❌") Username must contain at least 4 characters.")
//				.foregroundColor(isUsernameValid ? Color(hex: 0x008000) : .red)
//				.font(.caption)
//				.fontWeight(.bold)
//			LoginSecureField(placeholder: "Password", value: $password)
//				.onChange(of: password) { newValue in
//					checkPasswordField(newValue: newValue)
//				}
//
//			LoginSecureField(placeholder: "Confirm password", value: $confPassword)
//				.onChange(of: confPassword) { newValue in
//					isSamePasswordValid = password == newValue && newValue.count > 0
//				}
//			VStack(alignment: .leading) {
//				Text("Password must be contains at least:")
//					.foregroundColor(.gray)
//					.font(.caption)
//					.fontWeight(.bold)
//				CheckSignupField(condition: $isPasswordMinValid, conditionName: "One lowercase")
//				CheckSignupField(condition: $isPasswordMajValid, conditionName: "One uppercase")
//				CheckSignupField(condition: $isPasswordSpecialCharValid, conditionName: "One special charactere")
//				CheckSignupField(condition: $isPasswordNumberValid, conditionName: "One number")
//				CheckSignupField(condition: $isPasswordLenValid, conditionName: "6 characteres")
//				CheckSignupField(condition: $isSamePasswordValid, conditionName: "Passwords must match")
//			}
//			Spacer()
//				.frame(height: 15)
//			Button {
//				Task {
//					do {
//						disabledBtn = true
//						try await authentication.signup(username: username, password: password, confPassword: confPassword)
//						disabledBtn = false
//					} catch {
//						handleFetchError(error)
//						disabledBtn = false
//					}
//				}
//			} label: {
//				Text("Signup")
//					.foregroundStyle(disabledButton() ? .white.opacity(0.8) : .white)
//					.font(.system(size: 30))
//					.fontWeight(.bold)
//					.frame(width: 300)
//			}
//			.padding()
//			.frame(width: 300)
//			.background(disabledButton() ? .accent.opacity(0.7) : .accent)
//			.cornerRadius(50)
//			.disabled(disabledButton())
//		}.alert("Error", isPresented: $showAlert) {
//
//		} message: {
//			Text(errorMessage)
//		}
//	}
//
//	func checkPasswordField(newValue: String) {
//		isPasswordLenValid = newValue.count >= 6
//		isSamePasswordValid = newValue == confPassword && newValue.count > 0
//
//		isPasswordSpecialCharValid = checkRegexString(newValue: newValue, expression: "(?=.*[!@#$%^&*()_+])[!@#$%^&*()_+]+")
//		isPasswordMinValid =  checkRegexString(newValue: newValue, expression: "(?=.*[a-z])")
//		isPasswordMajValid = checkRegexString(newValue: newValue, expression: "(?=.*[A-Z])")
//		isPasswordNumberValid = checkRegexString(newValue: newValue, expression: "(?=.*\\d)")
//	}
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
//
//	func checkRegexString(newValue: String, expression: String) -> Bool {
//		do {
//			let regex = try NSRegularExpression(pattern: expression)
//
//			let range = NSRange(newValue.startIndex..., in: newValue)
//			let isMatch = regex.firstMatch(in: newValue, options: [], range: range) != nil
//			return isMatch
//		} catch {
//			return false
//		}
//	}
//
//	func handleFetchError(_ error: Error) {
//		switch error {
//		case AuthenticationError.invalidData:
//			print("Invalid data")
//			errorMessage = "An error occurred. Please try again later."
//		case AuthenticationError.invalidUsername:
//			print("Username already taken")
//			errorMessage = "The username is not available. Please choose another one."
//		case AuthenticationError.invalidURL:
//			print("Invalid URL")
//			errorMessage = "An error occurred. Please try again later."
//		default:
//			print("Error default")
//			errorMessage = "An error occurred. Please try again later."
//		}
//		showAlert.toggle()
//	}
//}
