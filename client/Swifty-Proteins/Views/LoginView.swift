//
//  LoginView.swift
//  Swifty-Proteins
//
//  Created by Jean-baptiste DUBILLARD on 07/12/2023.
//

import SwiftUI

struct LoginView: View {

	@State var signin = true
	@State var barOffset: CGFloat = 0
	@State var barWidth: CGFloat = 80

	var body: some View {
		ZStack {
			Image("BackgroundLogin")
				.resizable()
				.aspectRatio(contentMode: .fill)
				.edgesIgnoringSafeArea(.all)

			VStack {
				GeometryReader { geometry in
					HStack(spacing: 40) {
						Button("Signin") {
							withAnimation {
								signin = true
								barOffset = geometry.frame(in: .local).minX - 11
							}
						}
						.foregroundStyle(.white)
						.font(.system(size: 25))
						.fontWeight(.medium)

						Button("Signup") {
							withAnimation {
								signin = false
								barOffset = geometry.frame(in: .local).maxX - (geometry.size.width / 2) - 62
							}
						}
						.foregroundStyle(.white)
						.font(.system(size: 25))
						.fontWeight(.medium)
					}
					.onAppear {
						barOffset = geometry.frame(in: .local).minX - 11
					}
					.overlay(
						Rectangle()
							.frame(width: barWidth, height: 3)
							.foregroundColor(.white)
							.offset(x: barOffset - (geometry.size.width / 7), y: 5), alignment: .bottom
					)
					.frame(width: geometry.size.width, alignment: .center)
				}
			}
			.frame(width: 325, height: 400)
			.background(VisualEffectBlur(blurStyle: .light))
			.clipShape(RoundedRectangle(cornerRadius: 30.0))
		}
	}
}

#Preview {
	LoginView()
}
