//
//  ContentView.swift
//  Swifty-Proteins
//
//  Created by Jean-baptiste DUBILLARD on 29/11/2023.
//

import SwiftUI
import SceneKit

struct ContentView: View {
    
    @StateObject var request = Ligands()
    
    @State var responseApi: String?
    @State var showAlert = false
    @State var errorMessage = ""
    @State var isLoading = true
    
    var body: some View {
        VStack {
            if isLoading {
                Text("Chargement...")
            } else {
                ProteinView(atomsDatas: request.atomsDatas, connections: request.connections)
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
                try await request.fetchLigands()
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
    ContentView()
}
