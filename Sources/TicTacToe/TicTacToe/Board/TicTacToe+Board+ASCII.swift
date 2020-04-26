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
        Self.rows
            .map(ascii(row:))
            .joined(separator: "\n───┼───┼───\n")
    }
}

private extension TicTacToe.Board {
    
    func ascii(row: Row) -> String {
        " " + row.map(ascii(square:)).joined(separator: " │ ")
    }

    func ascii(square: Square) -> String {
        self[square].map({ $0.ascii }) ?? square.ascii
    }
}

private extension TicTacToe.Board.Fill {
    var ascii: String { rawValue }
}

private extension TicTacToe.Board.Square {
    var ascii: String { "\(rawValue + 1)" }
}
