//
//  ContentView.swift
//  Swifty-Proteins
//
//  Created by Jean-baptiste DUBILLARD on 29/11/2023.
//

import SwiftUI
import SceneKit

struct ContentView: View {

	@StateObject var authentication = Authentication()

	var body: some View {
		if !authentication.isAuthenticated {
			LoginView(authentication: authentication)
		} else {
			ListLigandsView(authentication: authentication)
		}
	}
}
