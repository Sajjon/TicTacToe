//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-04-08.
//

import Foundation

public struct TicTacToe {
    
    private var activePlayer: Player = .playerX
    private var board: Board = .init()
    
    public init(matchUp _ : MatchUp) {
        // no AI support yet...
    }
}

// MARK: Public
public extension TicTacToe {
    mutating func play() throws -> Result? {
        defer { activePlayer.toggle() }
        
        printBoard()
        
        let index = try readIndex(prompt: "\(activePlayer), which square:")
        try board.play(index: index, by: activePlayer)
        
        if board.isFull() {
            return .draw
        } else {
            return board.winner().map { .win(by: $0) }
        }
    }
    
    func printBoard() {
        print(board)
    }
}

// MARK: Private
private extension TicTacToe {
    
    func readIndex(prompt: String) throws -> Board.Index {
        print(prompt)
        return try Board.Index(readInteger()! - 1)
    }
}
