//
//  ContentView.swift
//  Swifty-Proteins
//
//  Created by Jean-baptiste DUBILLARD on 29/11/2023.
//

import SwiftUI
import SceneKit

struct ContentView: View {

	@State var isLogin = false

	var body: some View {
		if !isLogin {
			LoginView(isLogin: $isLogin)
		} else {
			ListLigandsView()
		}
	}
}

#Preview {
	ContentView()
}
