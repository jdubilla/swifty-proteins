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
    
    @State private var selectedAtom: String? = nil
    
    var body: some View {
        VStack {
            if isLoading {
                Text("Chargement...")
            } else {
                HStack {
                    Text("Molecule: \(ligandName)")
                    Spacer()
                    if let selectedAtom = selectedAtom {
                        Text("Selected Atom: \(selectedAtom)")
                    }
                }
                .padding()
                ProteinView(atomsDatas: request.atomsDatas, connections: request.connections, selectedAtomType: $selectedAtom)
                
                Spacer()
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
