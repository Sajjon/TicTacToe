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
        let rowSeparator: String = "\n───┼───┼───\n"
        var output = "\n"
        output += ascii(row: Self.firstRow)
        output += rowSeparator
        output += ascii(row: Self.secondRow)
        output += rowSeparator
        output += ascii(row: Self.thirdRow)
        return output
    }
}

private extension TicTacToe.Board {
    func ascii(row: Row) -> String {
        " " + ascii(square: row[0]) + " │ "
            + ascii(square: row[1]) + " │ "
            + ascii(square: row[2])
    }
}

private extension TicTacToe.Board {
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
