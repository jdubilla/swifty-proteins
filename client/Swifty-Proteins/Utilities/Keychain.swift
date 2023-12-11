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

		let deleteStatus = SecItemDelete(query as CFDictionary)
		if deleteStatus != errSecSuccess && deleteStatus != errSecItemNotFound {
			print("Erreur lors de la suppression de l'ancien token dans le Keychain")
		}

		let status = SecItemAdd(query as CFDictionary, nil)
		if status != errSecSuccess {
			print("Erreur lors de l'enregistrement du token dans le Keychain")
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
		print("Erreur lors de la récupération du token depuis le Keychain")
		return nil
	}
}
