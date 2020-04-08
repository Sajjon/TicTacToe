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
        
        let index = repeatedReadIndex(
            prompt: "\(activePlayer), which square:",
            ifBadNumber: "☣️  Bad input",
            ifSquareTaken: "⚠️  Square not free",
            tipOnHowToExitProgram: "💡 You can quit this program by pressing: `CTRL + c`"
        ) { board.isSquare(at: $0, .free) }
            
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
    
    func repeatedReadIndex(
        prompt: String,
        ifBadNumber messageIfBadNumber: String,
        ifSquareTaken messageIfSquareTaken: String,
        tipOnHowToExitProgram: String,
        showTipOnHowToExitProgramAfterAttempts showExitTipThreshold: Int = 5,
        _ isSquareFree: (Board.Index) -> Bool
    ) -> Board.Index {
        
        var index: Board.Index?
        var numberOfAttempts = 0
        while index == nil {
            defer {
                numberOfAttempts += 1
                if numberOfAttempts >= showExitTipThreshold {
                    print(tipOnHowToExitProgram)
                }
            }
            printBoard()
            index = try? readIndex(prompt: prompt)
            if let indexIndeed = index {
                if !isSquareFree(indexIndeed) {
                    print(messageIfSquareTaken)
                    index = nil
                }
            } else {
                print(messageIfBadNumber)
            }
            
        }
        return index!
    }
    
    func readIndex(prompt: String) throws -> Board.Index? {
        print(prompt)
        guard let integer: Board.Index.IntegerLiteralType = readInteger() else {
            return nil
        }
        return try Board.Index(integer - 1)
    }
}
