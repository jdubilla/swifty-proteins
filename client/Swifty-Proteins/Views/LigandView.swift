//
//  LigandView.swift
//  Swifty-Proteins
//
//  Created by Jean-baptiste DUBILLARD on 02/12/2023.
//

import SwiftUI

struct LigandView: View {

	var ligandName: String

	@StateObject var request = Ligands()

	@State var responseApi: String?
	@State var showAlert = false
	@State var errorMessage = ""
	@State var isLoading = true
	@State private var isSharing = false
	@State private var selectedAtom: String?
	@State private var sharedImage: UIImage?

	var body: some View {
		VStack {
			if isLoading {
				Text("Chargement...")
			} else {
				HStack {
					Spacer()
					if let selectedAtom = selectedAtom {
						Text("Selected Atom: \(selectedAtom)")
					}
				}
				.padding()
				ProteinView(atomsDatas: request.atomsDatas, connections: request.connections, selectedAtomType: $selectedAtom, sharedImage: $sharedImage)
				Spacer()
			}
		}
		.navigationTitle(ligandName)
		.toolbar {
			ToolbarItem(placement: .navigationBarTrailing) {
				Button(action: {
					isSharing = true
				}) {
					Image(systemName: "square.and.arrow.up")
				}
				.disabled(sharedImage == nil)
			}
		}
		.sheet(isPresented: $isSharing) {
			if let image = sharedImage {
				ActivityViewController(activityItems: [image])
			}
		}
		.alert(isPresented: $showAlert) {
			Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
		}
		.task {
			fetchData()
		}
	}

	func fetchData() {
		Task {
			isLoading = true
			do {
				try await request.fetchLigands(ligandName: ligandName)
				isLoading = false
			} catch {
				isLoading = false
				handleFetchError(error)
			}
		}
	}

	func handleFetchError(_ error: Error) {
		switch error {
		case LigandError.invalidData:
			print("Invalid data")
			errorMessage = "Invalid data"
		case LigandError.invalidReponse:
			errorMessage = "Invalid response"
			print("Invalid response")
		case LigandError.invalidURL:
			errorMessage = "Invalid URL"
			print("Invalid URL")
		default:
			errorMessage = "Invalid URL \(error.localizedDescription)"
		}
		showAlert.toggle()
	}
}

#Preview {
	LigandView(ligandName: "001")
}

struct ActivityViewController: UIViewControllerRepresentable {
	var activityItems: [Any]

	func makeUIViewController(context: Context) -> UIActivityViewController {
		let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
		return activityViewController
	}

	func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
		// Update the view controller if needed
	}
}
