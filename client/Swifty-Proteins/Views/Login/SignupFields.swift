//
//  SignupFields.swift
//  Swifty-Proteins
//
//  Created by Jean-baptiste DUBILLARD on 08/12/2023.
//

import SwiftUI

struct SignupFields: View {

	@Binding var isLogin: Bool

	@State var username = ""
	@State var password = ""
	@State var confPassword = ""

    var body: some View {
		LoginTextField(placeholder: "Username", value: $username)
		LoginSecureField(placeholder: "Password", value: $password)
		LoginSecureField(placeholder: "Confirm password", value: $confPassword)
		Spacer()
			.frame(height: 25)
		Button {
			isLogin = true
		} label: {
			Text("Signup")
				.foregroundStyle(.white)
				.font(.system(size: 30))
				.fontWeight(.bold)
		}
		.padding()
		.frame(width: 300)
		.background(.accent)
		.cornerRadius(50)
    }
}

#Preview {
    SignupFields(isLogin: .constant(false))
}
