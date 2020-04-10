//
//  Helper.swift
//  Tests
//
//  Created by Martin Wiingaard on 10/04/2020.
//  Copyright © 2020 Wiingaard. All rights reserved.
//

import Foundation
@testable import WordFect

func makeList(withExtra words: [String] = []) -> List {
    List(["hus","fat","fatty","cat","zap","catz","pm"] + words)
}

func makeWord(_ word: String) -> [PlacedBrick] {
    word.map(PlacedBrick.character)
}

func makeFixed(_ word: String) -> [FixedBrick] {
    word.enumerated().map { FixedBrick(brick: PlacedBrick.character($1), index: $0) }
}

func makeBricks() -> Search.Bricks {
    let map = Search.Bricks(TestMap.empty)
    map[.horizontal, 1] = TestLine.cat
    map[.vertical, 6] = TestLine.martin
    return map
}

func makeBoard() -> Matrix<BoardPosition> {
    Matrix(Board.standart)
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

func printValidatedResult(_ result: Validate.ValidatedResult) {
    print("Word: ", String(result.word.map { $0.character }))
    result.crossWords.forEach(printCrossWord)
}

func printMatches(_ matches: Set<[PlacedBrick]>) {
    print(matches
        .map { match in match.reduce("") { $0 + String($1.character) } }
        .sorted()
        .joined(separator: "\n")
    )
}

func printDirectionSearch(_ results: Search.DirectionSearch) {
    print(results.results.count, " results for ", results.direction)
    printMatches(results.results)
}

func printRankingWord(_ word: [Rank.RankingBrick]) {
    let printableWord = String(word.map { $0.brick.character })
    let printablePositions = word.map { String($0.position.description) }.joined(separator: " ")
    print(printableWord, " - [", printablePositions ,"]")
}
