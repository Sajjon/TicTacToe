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
        func rowSeparator(
            leadingNewline: Bool = true,
            trailingNewline: Bool = true
        ) -> String {
            
            [
                leadingNewline ? "\n" : "",
                String(repeating: "-", count: 13),
                trailingNewline ? "\n" : "",
            ]
            .joined()
        }
        
        return [
                [""],
                threeByThreeSquares.enumerated().map { (rowIndex, row) in
                    
                    return [
                        "|",
                        row.enumerated().map { (columnIndex, maybeFill) -> String in
                            if let fill = maybeFill {
                                return fill.rawValue
                            } else {
                                return "\(columnIndex + (rowIndex * 3) + 1)"
                            }
                        }
                        .map { " \($0) " } // add space left right
                        .joined(separator: "|"),
                        "|"
                    ].joined()
                    
                },
                [""]
            ]
                .flatMap { $0 }
                .joined(separator: rowSeparator())
    }

}
