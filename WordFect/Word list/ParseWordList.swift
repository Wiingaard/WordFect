//
//  ParseWordList.swift
//  WordFect
//
//  Created by Martin Wiingaard on 20/03/2020.
//  Copyright © 2020 Wiingaard. All rights reserved.
//

import Foundation

class ParseWordList {
    
    struct Line {
        let base: String
        let fullWord: String
        let wordType: WordType
    }
    
    enum WordType {
        case sb
        case vb
        case prop
        case adj
        case uadj
        case sbpl
        case callout
        case pron
        
        static func parse(form input: String) -> WordType {
            switch input {
            case "sb.": return .sb
            case "vb.": return .vb
            case "prop.": return .prop
            case "adj.": return .adj
            case "sb. pl.": return .sbpl
            case "udråbsord": return .callout
            case "pron.": return .pron
            case "ubøj. adj.": return .uadj
            default: fatalError("Could not parse '\(input)' into a 'WordType'")
            }
        }
    }
    
    static let parseLine: (String) -> Line? = { line in
        var lineParts = line.split(separator: ";")
        
        guard let wordTypeString = lineParts.popLast() else {
            return nil
        }
        
        guard let fullWord = lineParts.popLast(),
            isValidWord(String(fullWord)) else {
            return nil
        }
        
        guard let base = lineParts.popLast() else {
            return nil
        }
        
        return Line(
            base: String(base),
            fullWord: String(fullWord),
            wordType: WordType.parse(form: String(wordTypeString))
        )
    }
    
    static let isValidWord: (String) -> Bool = { line in
        let illegalCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzæøå").inverted
        let hasIlligalCharacters = line.rangeOfCharacter(from: illegalCharacters) != nil
        return !hasIlligalCharacters
    }
}
