//
//  Keychain.swift
//  Swifty-Proteins
//
//  Created by Jean-baptiste DUBILLARD on 11/12/2023.
//

import Foundation
import Security

func saveTokenToKeychain(token: String) {
	if let data = token.data(using: .utf8) {
		let query: [String: Any] = [
			kSecClass as String: kSecClassGenericPassword,
			kSecAttrAccount as String: "swiftyProteinsToken",
			kSecValueData as String: data,
			kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
		]

		SecItemDelete(query as CFDictionary)

		let status = SecItemAdd(query as CFDictionary, nil)
		if status != errSecSuccess {
			print("Error while saving the token to Keychain")
		}
	}
}

func getTokenFromKeychain() -> String? {
	let query: [String: Any] = [
		kSecClass as String: kSecClassGenericPassword,
		kSecAttrAccount as String: "swiftyProteinsToken",
		kSecReturnData as String: kCFBooleanTrue!,
		kSecMatchLimit as String: kSecMatchLimitOne
	]

	var dataTypeRef: AnyObject?
	let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

	if status == errSecSuccess, let retrievedData = dataTypeRef as? Data {
		return String(data: retrievedData, encoding: .utf8)
	} else {
		return nil
	}
}

func deleteTokenFromKeychain() {
	let query: [String: Any] = [
		kSecClass as String: kSecClassGenericPassword,
		kSecAttrAccount as String: "swiftyProteinsToken"
	]

	let status = SecItemDelete(query as CFDictionary)
	if status != errSecSuccess && status != errSecItemNotFound {
		print("Error while deleting the token from Keychain")
	}
}
