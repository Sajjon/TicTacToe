//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-04-08.
//

import Foundation

// MARK: Board ASCII
public extension TicTacToe.Board {
    func ascii() -> String {
        
        let rowSeparator = ["\n", String(repeating: "-", count: 13), "\n"].joined()
     
        func toString(row: Int, column: Int) -> String {
            let index = Index(row: row, column: column)
            return self[index].map({ $0.rawValue }) ?? "\(index.value + 1)"
        }
        
        let body = rowsOfColumns.enumerated().map { (rowIndex, row) in
            row
                .enumerated()
                .map { toString(row: rowIndex, column: $0.offset) }
                .map { " \($0) " } // add space left right
                .joined(separator: "|")
        }
        .map { "|\($0)" }
        .joined(separator: "|\(rowSeparator)")
        .appending("|")
        
        
        return [
            rowSeparator,
            body,
            rowSeparator
        ]
            .joined()
    }
}
