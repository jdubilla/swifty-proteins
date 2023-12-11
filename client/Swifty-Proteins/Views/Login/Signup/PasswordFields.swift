//
//  PasswordFields.swift
//  Swifty-Proteins
//
//  Created by Jean-baptiste DUBILLARD on 11/12/2023.
//

import SwiftUI

struct PasswordFields: View {
	@Binding var password: String
	@Binding var confPassword: String
	@Binding var isPasswordLenValid: Bool
	@Binding var isSamePasswordValid: Bool
	@Binding var isPasswordSpecialCharValid: Bool
	@Binding var isPasswordMinValid: Bool
	@Binding var isPasswordMajValid: Bool
	@Binding var isPasswordNumberValid: Bool

	var body: some View {
		LoginSecureField(placeholder: "Password", value: $password)
			.onChange(of: password) { newValue in
				checkPasswordField(newValue: newValue)
			}
		LoginSecureField(placeholder: "Confirm password", value: $confPassword)
			.onChange(of: confPassword) { newValue in
				isSamePasswordValid = password == newValue && newValue.count > 0
			}
		VStack(alignment: .leading) {
			Text("Password must be contains at least:")
				.foregroundColor(.gray)
				.font(.caption)
				.fontWeight(.bold)
			CheckSignupField(condition: $isPasswordMinValid, conditionName: "One lowercase")
			CheckSignupField(condition: $isPasswordMajValid, conditionName: "One uppercase")
			CheckSignupField(condition: $isPasswordSpecialCharValid, conditionName: "One special charactere")
			CheckSignupField(condition: $isPasswordNumberValid, conditionName: "One number")
			CheckSignupField(condition: $isPasswordLenValid, conditionName: "6 characteres")
			CheckSignupField(condition: $isSamePasswordValid, conditionName: "Passwords must match")
		}
		Spacer()
			.frame(height: 15)
	}

	func checkPasswordField(newValue: String) {
		isPasswordLenValid = newValue.count >= 6
		isSamePasswordValid = newValue == confPassword && newValue.count > 0

		isPasswordSpecialCharValid = checkRegexString(newValue: newValue, expression: "(?=.*[!@#$%^&*()_+])[!@#$%^&*()_+]+")
		isPasswordMinValid =  checkRegexString(newValue: newValue, expression: "(?=.*[a-z])")
		isPasswordMajValid = checkRegexString(newValue: newValue, expression: "(?=.*[A-Z])")
		isPasswordNumberValid = checkRegexString(newValue: newValue, expression: "(?=.*\\d)")
	}

	func checkRegexString(newValue: String, expression: String) -> Bool {
		do {
			let regex = try NSRegularExpression(pattern: expression)

			let range = NSRange(newValue.startIndex..., in: newValue)
			let isMatch = regex.firstMatch(in: newValue, options: [], range: range) != nil
			return isMatch
		} catch {
			return false
		}
	}
}
