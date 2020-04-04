//
//  CSVImporter.swift
//  WordFect
//
//  Created by Martin Wiingaard on 20/03/2020.
//  Copyright © 2020 Wiingaard. All rights reserved.
//

import UIKit

class CSVImporter<Output> {
    
    let fileName: String
    let parseLine: (String) -> Output?
    
    init(fileName: String, parseLine: @escaping (String) -> Output?) {
        self.fileName = fileName
        self.parseLine = parseLine
    }
    
    func read() -> [Output] {
        switch openFile(name: fileName) {
        case .success(let string):
            return parse(file: string)
        case .failure(let error):
            print("CSVImporter Error: \(error)")
            return []
        }
    }
    
    private func openFile(name: String) -> Result<String, DomainError> {
        guard let asset = NSDataAsset.init(name: "list") else {
            return .failure(.noAssetFound)
        }
        
        guard let fileString = String.init(data: asset.data, encoding: .utf8) else {
            return .failure(.noString)
        }
        
        return .success(fileString)
    }
    
    private func parse(file: String) -> [Output] {
        return file
            .components(separatedBy: .newlines)
            .compactMap(parseLine)
    }
    
    private enum DomainError: Error, CustomStringConvertible {
        case noAssetFound
        case noString
        
        var description: String {
            switch self {
            case .noAssetFound:
                return "Could not open file from Assets.xcassets"
            case .noString:
                return "Could not read file data as a string"
            }
        }
    }
}
