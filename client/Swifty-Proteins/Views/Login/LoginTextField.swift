//
//  LoginTextField.swift
//  Swifty-Proteins
//
//  Created by Jean-baptiste DUBILLARD on 09/12/2023.
//

import SwiftUI

struct LoginTextField: View {

	var placeholder: String
	@Binding var value: String

    var body: some View {
		TextField("", text: $value, prompt: Text("\(placeholder)").foregroundColor(.blue))
			.padding()
			.opacity(0.5)
			.background(.white)
			.cornerRadius(50)
			.frame(width: 300)
			.font(.system(size: 23))
    }
}

#Preview {
	LoginTextField(placeholder: "Username", value: .constant(""))
}
