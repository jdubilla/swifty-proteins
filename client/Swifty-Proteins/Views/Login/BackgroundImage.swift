//
//  BackgroundImage.swift
//  Swifty-Proteins
//
//  Created by Jean-baptiste DUBILLARD on 08/12/2023.
//

import SwiftUI

struct BackgroundImage: View {
    var body: some View {
		Image("BackgroundLogin")
			.resizable()
			.aspectRatio(contentMode: .fill)
			.edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    BackgroundImage()
}
