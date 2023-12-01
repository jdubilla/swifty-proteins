//
//  Ligands.swift
//  Swifty-Proteins
//
//  Created by Jean-baptiste DUBILLARD on 30/11/2023.
//

import Foundation

class Ligands: ObservableObject {
    
    var dataFile: String = ""
    var atomsDatas: [AtomDatas] = []
    var connections: [Connection] = []
            
    func fetchLigandFile() async throws -> String {
        let endpoint = "https://files.rcsb.org/ligands/view/001_ideal.sdf"

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
        var i = 1
        
        let splitedFile = dataFile.split(separator: "\n")
        
        for index in 0...splitedFile.count - 1 {
            let splitedLine = splitedFile[index].split(separator: " ")
            
            if (splitedLine.count == 16) {
                if let x = Float(splitedLine[0]), let y = Float(splitedLine[1]), let z = Float(splitedLine[2]) {
                    let atom: AtomDatas = AtomDatas(id: i, x: x, y: y, z: z, type: String(splitedLine[3]))
                    i += 1
                    atomsDatas.append(atom)
                }
            }
        }
        return atomsDatas
    }
    
    func getConnections(dataFile: String) -> [Connection] {
        var connections: [Connection] = []
        
        let splitedFile = dataFile.split(separator: "\n")
        
        for index in 0...splitedFile.count - 1 {
            let splitedLine = splitedFile[index].split(separator: " ")
            
            if (splitedLine.count == 7) {
                if let from = Int(splitedLine[0]), let to = Int(splitedLine[1]), let connectionType = Int(splitedLine[2]) {
                    let connection: Connection = Connection(from: from, to: to, connectionType: connectionType)
                    connections.append(connection)
                }
            }
        }
        return connections
    }

    
    func fetchLigands() async throws {
        self.dataFile = try await fetchLigandFile()
        self.atomsDatas = getLigandCoords(dataFile: dataFile)
        self.connections = getConnections(dataFile: dataFile)
    }
}

enum LigandError: Error {
    case invalidURL
    case invalidReponse
    case invalidData
}
