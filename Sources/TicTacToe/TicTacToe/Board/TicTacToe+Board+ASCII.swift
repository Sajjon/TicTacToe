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
        let rowSeparator: String = .init(repeating: "-", count: 13) + "\n"
        var output = rowSeparator
        for row in Self.rows {
            defer { output += "\n" + rowSeparator }
            output += row.map({ "| \(ascii(square: $0)) "}).joined() + "|"
        }
        return output
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
