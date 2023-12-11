//
//  CheckLoginField.swift
//  Swifty-Proteins
//
//  Created by Jean-baptiste DUBILLARD on 11/12/2023.
//

import SwiftUI

struct CheckSignupField: View {

	@Binding var condition: Bool
	var conditionName: String

    var body: some View {
		Text("\(condition ? "✔️" : "❌") \(conditionName)")
			.foregroundColor(condition ? Color(hex: 0x008000) : .red)
			.font(.caption)
			.fontWeight(.bold)
    }
}

#Preview {
	CheckSignupField(condition: .constant(true), conditionName: "One special charactere")
}
