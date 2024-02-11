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
	@State private var selectedAtom: AtomDatas?
	@State private var sharedImage: UIImage?
    @Environment(\.presentationMode) var presentationMode

	var body: some View {
		VStack {
			if isLoading {
				LoadingLigandView()
			} else {
				ZStack {
					Protein3D(atomsDatas: request.atomsDatas, connections: request.connections, selectedAtom: $selectedAtom, sharedImage: $sharedImage)
					HStack(alignment: .center) {
						if let selectedAtom = selectedAtom {
							Text("Selected Atom: \(selectedAtom.type) \(selectedAtom.id)")
								.frame(height: 30)
								.padding()
								.background(.gray.opacity(0.7))
								.foregroundStyle(.white)
								.clipShape(RoundedRectangle(cornerRadius: 130))
								.offset(y: 200)
								.shadow(color: .gray, radius: 30)
						}
					}
				}
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
			errorMessage = "Invalid response or molecule not found"
			print("Invalid response")
		case LigandError.invalidURL:
			errorMessage = "Invalid URL"
			print("Invalid URL")
		default:
			errorMessage = "Invalid URL \(error.localizedDescription)"
		}
        self.presentationMode.wrappedValue.dismiss()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.showAlert.toggle()
        }
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

    }
}
