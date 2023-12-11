//
//  SigninFields.swift
//  Swifty-Proteins
//
//  Created by Jean-baptiste DUBILLARD on 08/12/2023.
//

import SwiftUI

struct Signin: View {

	@StateObject var authentication: Authentication
//	@Binding var isLogin: Bool

	@State var username = ""
	@State var password = ""

    var body: some View {
		LoginTextField(placeholder: "Username", value: $username)
		LoginSecureField(placeholder: "Password", value: $password)
		Spacer()
			.frame(height: 25)
		Button {
//			authentication.isAuthenticated = true
		} label: {
			Text("Signin")
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
}
