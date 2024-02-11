//
//  Ligands.swift
//  Swifty-Proteins
//
//  Created by Jean-baptiste DUBILLARD on 30/11/2023.
//

import Foundation
import SwiftUI
import UIKit

class Ligands: ObservableObject {
	var dataFile: String = ""
	var atomsDatas: [AtomDatas] = []
	var connections: [Connection] = []

	func fetchLigandFile(ligandName: String) async throws -> String {
		let endpoint = "https://files.rcsb.org/ligands/view/\(ligandName)_ideal.sdf"

		guard let url = URL(string: endpoint) else {
			throw LigandError.invalidURL
		}

		let (data, response) = try await URLSession.shared.data(from: url)

		guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
			throw LigandError.invalidReponse
		}

		let dataFile = String(data: data, encoding: .utf8)
		guard let dataFile = dataFile else {
			throw LigandError.invalidData
		}
		return dataFile
	}

	func getLigandCoords(dataFile: String) -> [AtomDatas] {
		var atomsDatas: [AtomDatas] = []
		var idx = 1

		let splitedFile = dataFile.split(separator: "\n")

		for index in 0...splitedFile.count - 1 {
			let splitedLine = splitedFile[index].split(separator: " ")

			if splitedLine.count == 16 {
				if let x = Float(splitedLine[0]), let y = Float(splitedLine[1]), let z = Float(splitedLine[2]) {
					let color = colorAtom(atom: String(splitedLine[3]))
					let atom: AtomDatas = AtomDatas(id: idx, type: String(splitedLine[3]), x: x * 2, y: y * 2, z: z * 2, color: color)
					idx += 1
					atomsDatas.append(atom)
				}
			}
		}
		return atomsDatas
	}

	func colorAtom(atom: String) -> UIColor {
		switch atom {
		case "H": return UIColor.white
		case "C": return UIColor.black
		case "N": return UIColor.blue
		case "O": return UIColor.red
		case "F", "Cl": return UIColor.green
		case "Br": return UIColor(red: 0.54, green: 0.0, blue: 0.0, alpha: 1.0)
		case "I": return UIColor(red: 0.58, green: 0.0, blue: 0.83, alpha: 1.0)
		case "He", "Ne", "Ar", "Kr", "Xe": return UIColor.cyan
		case "P": return UIColor.orange
		case "S": return UIColor.yellow
		case "B": return UIColor(red: 0.96, green: 0.89, blue: 0.69, alpha: 1.0)
		case "Li", "Na", "K", "Rb", "Cs", "Fr": return UIColor.purple
		case "Be", "Mg", "Ca", "Sr", "Ba", "Ra": return UIColor(red: 0.0, green: 0.39, blue: 0.0, alpha: 1.0)
		case "Ti": return UIColor.gray
		case "Fe": return UIColor(red: 0.67, green: 0.33, blue: 0.0, alpha: 1.0)
		default: return UIColor(red: 1.0, green: 0.0, blue: 1.0, alpha: 1.0)
		}
	}

	func getConnections(dataFile: String) -> [Connection] {
		var connections: [Connection] = []

		let splitedFile = dataFile.split(separator: "\n")

		for index in 0...splitedFile.count - 1 {

			if splitedFile[index] == "M  END" {
				return connections
			}

			let splitedLine = splitedFile[index].split(separator: " ")

			if splitedLine.count == 7 {
				if let from = Int(splitedLine[0]), let to = Int(splitedLine[1]), let connectionType = Int(splitedLine[2]) {
					let connection: Connection = Connection(from: from, to: to, connectionType: connectionType)
					connections.append(connection)
				}
			} else if splitedLine.count == 6 {
				if let stickyNumbers = Int(splitedLine[0]), let connectionType = Int(splitedLine[1]) {

						 let firstNumber = stickyNumbers / 1000
						 let secondNumber = stickyNumbers % 1000
					let connection: Connection = Connection(from: firstNumber, to: secondNumber, connectionType: connectionType)
					connections.append(connection)
				}
			}
		}
		return connections
	}

	func fetchLigands(ligandName: String) async throws {
		self.dataFile = try await fetchLigandFile(ligandName: ligandName)
		self.atomsDatas = getLigandCoords(dataFile: dataFile)
		self.connections = getConnections(dataFile: dataFile)
	}
}

enum LigandError: Error {
	case invalidURL
	case invalidReponse
	case invalidData
}
