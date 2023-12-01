//
//  Ligands.swift
//  Swifty-Proteins
//
//  Created by Jean-baptiste DUBILLARD on 30/11/2023.
//

import Foundation

class Ligands: ObservableObject {
            
    func fetchLigandFile() async throws -> String {
        let endpoint = "https://files.rcsb.org/ligands/view/004_ideal.sdf"

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
        
        let splitedFile = dataFile.split(separator: "\n")
        
        for index in 0...splitedFile.count - 1 {
            let splitedLine = splitedFile[index].split(separator: " ")
            
            if (splitedLine.count == 16) {
                if let x = Double(splitedLine[0]), let y = Double(splitedLine[1]), let z = Double(splitedLine[2]) {
                    let atom: AtomDatas = AtomDatas(x: x, y: y, z: z, type: String(splitedLine[3]))
                    atomsDatas.append(atom)
                }
            }
        }
        
        return atomsDatas
    }
    
    func fetchLigands() async throws -> [AtomDatas] {
        let dataFile = try await fetchLigandFile()
        let atomsDatas = getLigandCoords(dataFile: dataFile)
        return atomsDatas
    }
}

enum LigandError: Error {
    case invalidURL
    case invalidReponse
    case invalidData
}
