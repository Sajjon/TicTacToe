//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-04-08.
//

import Foundation

// MARK: Result
public extension TicTacToe {
    enum Result: CustomStringConvertible {
        case draw
        case win(by: Player)
    }
}

// MARK: CustomStringConvertible
public extension TicTacToe.Result {
    var description: String {
        switch self {
        case .draw: return "Game ended with a draw"
        case .win(let winningPlayer): return "\(winningPlayer) won!"
        }
    }
}
