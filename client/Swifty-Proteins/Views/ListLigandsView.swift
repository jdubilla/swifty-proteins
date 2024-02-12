//
//  ListLigandsView.swift
//  Swifty-Proteins
//
//  Created by Jean-baptiste DUBILLARD on 02/12/2023.
//

import SwiftUI

struct ListLigandsView: View {

	@StateObject var authentication: Authentication

	@State var searchText = ""
	@State var listLigands: [String] = []
	@Environment(\.scenePhase) var scenePhase

	var filteredLigands: [String] {
		if searchText.isEmpty {
			return listLigands
		} else {
			return listLigands.filter { $0.localizedCaseInsensitiveContains(searchText)}
		}
	}

	var body: some View {
		VStack {
			NavigationView {
				VStack {
					List(filteredLigands, id: \.self) { ligand in
						NavigationLink {
							LigandView(ligandName: ligand)
						} label: {
							Text(ligand)
						}
					}.listStyle(.plain)
						.padding()
					Button("Logout") {
						deleteTokenFromKeychain()
						authentication.isAuthenticated = false
					}.foregroundStyle(.red)
				}.navigationTitle("Ligands")
			}
            .searchable(text: $searchText)
            .autocorrectionDisabled()
		}
		.onAppear {
			self.listLigands = getListLigands()
		}
		.onChange(of: scenePhase, perform: { newScenePhase in
			if newScenePhase == .inactive {
				authentication.isAuthenticated = false
			}
		})
	}

	func getListLigands() -> [String] {
		if let file = Bundle.main.path(forResource: "ligands", ofType: "txt") {
			do {
				let fileContent = try String(contentsOfFile: file)
				let ligands = fileContent.components(separatedBy: "\n")
				return ligands
			} catch {
				print("Error reading file: \(error.localizedDescription)")
			}
		} else {
			print("File not found")
		}
		return []
	}
}
