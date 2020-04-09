//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-04-08.
//

import Foundation

public enum Player: UInt8, Equatable, CaseIterable, CustomStringConvertible {
    case playerX
    case playerO
}

public extension Player {
    mutating func toggle() {
        self = Self(rawValue: (rawValue + 1) % 2)!
    }
    
    var fill: TicTacToe.Board.Fill {
        switch self {
        case .playerO: return .nought
        case .playerX: return.cross
        }
    }
    
    var description: String {
        switch self {
        case .playerO:
            return "Player O"
        case .playerX:
            return "Player X"
        }
    }
}
