//
//  Line.swift
//  WordFect
//
//  Created by Martin Wiingaard on 26/04/2020.
//  Copyright © 2020 Wiingaard. All rights reserved.
//

import Foundation
import Combine

class Line<Element> {
    
    var line: [Element]
    
    var count: Int {
        line.count
    }
    
    init(_ line: [Element]) {
        self.line = line
    }
    
    subscript(index: Int) -> Element {
        get { line[index] }
        set { line[index] = newValue }
    }
    
    func map<S>(_ transform: (Element) -> S) -> Line<S> {
        return Line<S>(line.map(transform))
    }
}
