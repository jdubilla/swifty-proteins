//
//  Authentication.swift
//  Swifty-Proteins
//
//  Created by Jean-baptiste DUBILLARD on 09/12/2023.
//

import Foundation

class Authentication: ObservableObject {
	var baseUrl = "http://localhost:3000"
	var token: String = ""
	@Published var isAuthenticated = false

	func signup(username: String, password: String, confPassword: String) async throws {
		let endpoint = "\(baseUrl)/authentication/signup"

		guard let url = URL(string: endpoint) else {
			throw AuthenticationError.invalidURL
		}

		let parameters: [String: String] = [
			"username": username,
			"password": password,
			"confPassword": confPassword
		]

		do {
			let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])

			var request = URLRequest(url: url)
			request.httpMethod = "POST"
			request.setValue("application/json", forHTTPHeaderField: "Content-Type")
			request.httpBody = jsonData

			let (data, response) = try await URLSession.shared.data(for: request)

			guard let httpResponse = response as? HTTPURLResponse else {
				throw AuthenticationError.invalidResponse
			}
			if httpResponse.statusCode == 200 {
				let decoder = JSONDecoder()
				let tokenData = try decoder.decode(TokenResponse.self, from: data)
				print(tokenData.token)
				self.token = tokenData.token
				DispatchQueue.main.async {
					self.isAuthenticated = true
				}
			} else {
				if httpResponse.statusCode == 409 {
					throw AuthenticationError.invalidUsername
				} else {
					throw AuthenticationError.invalidData
				}
			}
		} catch {
			throw error
		}
	}

	func signin(username: String, password: String) async throws {
		let endpoint = "\(baseUrl)/authentication/signin"

		guard let url = URL(string: endpoint) else {
			throw AuthenticationError.invalidURL
		}

		let parameters: [String: String] = [
			"username": username,
			"password": password
		]

		do {
			let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])

			var request = URLRequest(url: url)
			request.httpMethod = "POST"
			request.setValue("application/json", forHTTPHeaderField: "Content-Type")
			request.httpBody = jsonData

			let (data, response) = try await URLSession.shared.data(for: request)

			guard let httpResponse = response as? HTTPURLResponse else {
				throw AuthenticationError.invalidResponse
			}
			if httpResponse.statusCode == 200 {
				let decoder = JSONDecoder()
				let tokenData = try decoder.decode(TokenResponse.self, from: data)
				print(tokenData.token)
				self.token = tokenData.token
				DispatchQueue.main.async {
					self.isAuthenticated = true
				}
			} else {
					throw AuthenticationError.invalidFields
			}
		} catch {
			throw error
		}
	}

	func checkToken(token: String) async -> Bool {
		print(token)
		let endpoint = "\(baseUrl)/authentication/checkToken?token=\(token)"

		guard let url = URL(string: endpoint) else {
			return false
		}

		do {
			var request = URLRequest(url: url)
			request.setValue("application/json", forHTTPHeaderField: "Content-Type")

			let (_, response) = try await URLSession.shared.data(for: request)

			guard let httpResponse = response as? HTTPURLResponse else {
				throw AuthenticationError.invalidResponse
			}
			if httpResponse.statusCode == 200 {
				return true
			} else {
				return false
			}
		} catch {
			return false
		}
	}
}

enum AuthenticationError: Error {
	case invalidURL
	case invalidBodyData
	case invalidData
	case invalidResponse
	case invalidUsername
	case invalidFields
}

struct TokenResponse: Decodable {
	let token: String
}
