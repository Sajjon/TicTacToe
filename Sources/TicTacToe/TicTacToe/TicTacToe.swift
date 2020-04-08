//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-04-08.
//

import Foundation

public struct TicTacToe {
 
    private let matchUp: MatchUp
    private var activePlayer: Player = .playerX
    
    private var state: Board = .init()
    
    public init(matchUp: MatchUp) {
        self.matchUp = matchUp
    }
}

public extension TicTacToe {

    /// Returns winning player, if game is over
    mutating func play() throws -> Result? {
        defer { activePlayer.toggle() }
        printBoard()
        print("Which index? >")
        let index = try Board.Index(readInteger()! - 1)
        try state.play(index: index, by: activePlayer)
        
        if let winningPlayer = state.hasAnyoneWon() {
            return .win(by: winningPlayer)
        } else if state.isFull() {
            return .draw
        } else {
            return nil
        }
    }

    func printBoard() {
        print("\n\nTurn: \(activePlayer)")
        print(state)
    }
}
