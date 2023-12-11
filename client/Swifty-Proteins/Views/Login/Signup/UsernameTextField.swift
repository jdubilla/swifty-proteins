//
//  UsernameTextField.swift
//  Swifty-Proteins
//
//  Created by Jean-baptiste DUBILLARD on 11/12/2023.
//

import SwiftUI

struct UsernameTextField: View {
	@Binding var username: String
	@Binding var isUsernameValid: Bool

	var body: some View {
		LoginTextField(placeholder: "Username", value: $username)
			.onChange(of: username) { newValue in
				isUsernameValid = newValue.count >= 4
				if newValue.count > 15 {
					username = String(username.prefix(15))
				}
			}
		Text("\(isUsernameValid ? "✔️" : "❌") Username must contain at least 4 characters.")
			.foregroundColor(isUsernameValid ? Color(hex: 0x008000) : .red)
			.font(.caption)
			.fontWeight(.bold)
	}
}
