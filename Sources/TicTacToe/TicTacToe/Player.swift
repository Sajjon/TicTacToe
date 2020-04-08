//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-04-08.
//

import Foundation

public enum Player: UInt8, Equatable, CaseIterable {
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
}
