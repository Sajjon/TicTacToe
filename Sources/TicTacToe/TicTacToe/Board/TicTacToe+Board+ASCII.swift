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

extension TicTacToe.Board {
    func ascii(square: Square, offset: UInt8 = 1) -> String {
        self[square].map({ $0.ascii }) ?? square.ascii(offset: offset)
    }
}

private extension TicTacToe.Board.Fill {
    var ascii: String { rawValue }
}

private extension TicTacToe.Board.Square {
    func ascii(offset: UInt8 = 1) -> String { "\(rawValue + offset)" }
}
