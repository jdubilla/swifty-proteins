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
		self.disabledBtn = !isUsernameValid ||
			!isPasswordLenValid ||
			!isSamePasswordValid ||
			!isPasswordSpecialCharValid ||
			!isPasswordMinValid ||
			!isPasswordMajValid ||
			!isPasswordNumberValid
	}
}
