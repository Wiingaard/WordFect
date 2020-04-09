//
//  ValidateTests.swift
//  Tests
//
//  Created by Martin Wiingaard on 09/04/2020.
//  Copyright © 2020 Wiingaard. All rights reserved.
//

import XCTest
@testable import WordFect

class ValidateTests: XCTestCase {
    
    typealias Bricks = Matrix<PlacedBrick?>
    
    func testIsValidWord() {
        assert(Validate.isValidWord(hus(), list: testList()) == true)
        assert(Validate.isValidWord(lol(), list: testList()) == false)
    }
    
    func testFindWord() {
        let testMap = self.testMap()
        testMap[MatrixIndex.init(row: 1, column: 6)] = .character("h")
        testMap[MatrixIndex.init(row: 4, column: 3)] = .character("o")
        
        testMap[MatrixIndex.init(row: 0, column: 12)] = .character("1")
        testMap[MatrixIndex.init(row: 0, column: 13)] = .character("2")
        testMap[MatrixIndex.init(row: 0, column: 14)] = .character("3")
        
        assert(Validate.findWord(
            at: .init(row: 1, column: 3),
            brick: .character("a"),
            direction: .horizontal,
            bricks: testMap
            ) == controlWord(characters: "cat", starting: -1) )
        
        assert(Validate.findWord(
            at: .init(row: 1, column: 3),
            brick: .character("a"),
            direction: .vertical,
            bricks: testMap
            ) == [] )
        
        assert(Validate.findWord(
            at: .init(row: 7, column: 6),
            brick: .character("i"),
            direction: .vertical,
            bricks: testMap
            ) == controlWord(characters: "martin", starting: -4) )
        
        assert(Validate.findWord(
            at: .init(row: 0, column: 10),
            brick: .character("0"),
            direction: .horizontal,
            bricks: testMap
            ) == [] )
        
        assert(Validate.findWord(
            at: .init(row: 0, column: 11),
            brick: .character("0"),
            direction: .horizontal,
            bricks: testMap
            ) == controlWord(characters: "0123", starting: 0) )
        
        assert(Validate.findWord(
            at: .init(row: 0, column: 12),
            brick: .character("1"),
            direction: .horizontal,
            bricks: testMap
            ) == controlWord(characters: "123", starting: 0) )
    }
    
    func testCrossWords() {
        let testMap = self.testMap()
        testMap[MatrixIndex.init(row: 0, column: 3)] = .character("f")
        testMap[MatrixIndex.init(row: 2, column: 3)] = .character("t")
        
        testMap[MatrixIndex.init(row: 3, column: 4)] = .character("m")
        testMap[MatrixIndex.init(row: 3, column: 5)] = .character("o")
        testMap[MatrixIndex.init(row: 3, column: 7)] = .character("s")
        testMap[MatrixIndex.init(row: 5, column: 4)] = .character("d")
        testMap[MatrixIndex.init(row: 5, column: 5)] = .character("e")
        testMap[MatrixIndex.init(row: 5, column: 7)] = .character("p")
        testMap[MatrixIndex.init(row: 8, column: 7)] = .character("o")
        testMap[MatrixIndex.init(row: 8, column: 8)] = .character("p")
        testMap.dump()
        
        let catResult = Validate.findCrossWords(
            cat(),
            wordDirection: .horizontal,
            position: .init(row: 1, column: 2),
            bricks: testMap
        )
        let fatControl = Validate.CrossWord.init(crossingIndex: 1, word: controlWord(characters: "fat", starting: -1))
        assert(catResult.crossWords == [fatControl])
        assert(catResult.originalWord == cat())
        
        let martinResult = Validate.findCrossWords(
            martin(),
            wordDirection: .vertical,
            position: .init(row: 3, column: 6),
            bricks: testMap
        )
        let momsControl = Validate.CrossWord.init(crossingIndex: 0, word: controlWord(characters: "moms", starting: -2))
        let derpControl = Validate.CrossWord.init(crossingIndex: 2, word: controlWord(characters: "derp", starting: -2))
        let nopControl = Validate.CrossWord.init(crossingIndex: 5, word: controlWord(characters: "nop", starting: 0))
        assert(martinResult.crossWords == [momsControl, derpControl, nopControl])
        assert(martinResult.originalWord == martin())
    }
    
    func testCrossWords2() {
        let testMap = self.testMap()
        testMap.dump()
        
        let result = Validate.findCrossWords(
            makeWord("zap"),
            wordDirection: .vertical,
            position: .init(row: 1, column: 5),
            bricks: testMap
        )
        
        let catzControl = Validate.CrossWord.init(crossingIndex: 0, word: controlWord(characters: "catz", starting: -3))
        let pmControl = Validate.CrossWord.init(crossingIndex: 2, word: controlWord(characters: "pm", starting: 0))
        assert(result.crossWords == [catzControl, pmControl])
        assert(result.originalWord == makeWord("zap"))
    }
    
    func testValidateDirection() {
        let testMap = self.testMap()
        testMap.dump()
        
        let search = Search.DirectionSearch(
            origin: .init(row: 0, column: 3),
            direction: .vertical,
            fixedBricks: [],
            length: 15,
            results: Set([makeWord("fat"), makeWord("fatty"), makeWord("matty"), makeWord("saz")])
        )
        
        let results = Validate.validateDirection(search, list: testList(), bricks: testMap)
        let resultWords = results.map { String($0.originalWord.map { $0.character }) }
        let catControlCrossword = Validate.CrossWord.init(
            crossingIndex: 1,
            word: controlWord(characters: "cat", starting: -1)
        )
        assert(results.count == 2)
        assert(resultWords.contains("fat"))
        assert(resultWords.contains("fatty"))
        assert(results[0].crossWords.contains(catControlCrossword))
        assert(results[1].crossWords.contains(catControlCrossword))
    }
    
    func testValidateDirection2() {
        let testMap = self.testMap()
        testMap.dump()
        
        let search = Search.DirectionSearch(
            origin: .init(row: 1, column: 5),
            direction: .vertical,
            fixedBricks: [],
            length: 15,
            results: Set([makeWord("zap"), makeWord("wrap"), makeWord("chat")])
        )
        
        let results = Validate.validateDirection(search, list: testList(), bricks: testMap)
        let resultsWords = results.map { String($0.originalWord.map { $0.character }) }
        let catzControlCrossword = Validate.CrossWord.init(
            crossingIndex: 0,
            word: controlWord(characters: "catz", starting: -3)
        )
        let pmControlCrossword = Validate.CrossWord.init(
            crossingIndex: 2,
            word: controlWord(characters: "pm", starting: 0)
        )
        assert(resultsWords.count == 1)
        assert(resultsWords.contains("zap"))
        assert(results.first!.crossWords.count == 2)
        assert(results.first!.crossWords.contains(catzControlCrossword))
        assert(results.first!.crossWords.contains(pmControlCrossword))
    }

}

extension ValidateTests {
    
    func testList() -> [String] {
        ["hus","fat","fatty","cat","zap","catz","pm"]
    }
    
    func makeWord(_ word: String) -> [PlacedBrick] {
        word.map(PlacedBrick.character)
    }
    
    func hus() -> [PlacedBrick] {
        makeWord("hus")
    }
    
    func lol() -> [PlacedBrick] {
        makeWord("lol")
    }
    
    func cat() -> [PlacedBrick] {
        makeWord("cat")
    }
    
    func martin() -> [PlacedBrick] {
        makeWord("martin")
    }
    
    func testMap() -> Search.Bricks {
        let map = Bricks(TestMap.empty)
        map[.horizontal, 1] = TestLine.cat
        map[.vertical, 6] = TestLine.martin
        return map
    }
    
    func controlWord(characters: String, starting: Int) -> [FixedBrick] {
        var result = [FixedBrick]()
        var index = starting
        characters.forEach { char in
            result.append(.init(brick: .character(char), index: index))
            index += 1
        }
        return result
    }
    
    func printCrossWord(_ crossWord: Validate.CrossWord) {
        let word = String(crossWord.word.map { $0.brick.character })
        let startingAt = crossWord.word.first?.index
        print("crossing: ", crossWord.crossingIndex, " starting at: ", startingAt ?? "X", " word: ", word)
    }
    
    func printResult(_ result: Validate.CrossWordsResult) {
        print("Word: ", String(result.originalWord.map { $0.character }))
        result.crossWords.forEach(printCrossWord)
    }
    
}
