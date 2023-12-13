//
//  LoadingLigandView.swift
//  Swifty-Proteins
//
//  Created by Jean-baptiste DUBILLARD on 13/12/2023.
//

import SwiftUI

struct LoadingLigandView: View {

	@State var isRotating = 0.0

	var body: some View {
		VStack {
			Image("MoleculeLoading")
				.resizable()
				.frame(width: 125, height: 125)
				.rotationEffect(.degrees(isRotating))
				.onAppear {
					withAnimation(.linear(duration: 0.5)
						.speed(0.1).repeatForever(autoreverses: false)) {
							isRotating = 360.0
						}
				}
		}
	}
}

#Preview {
	LoadingLigandView()
}
