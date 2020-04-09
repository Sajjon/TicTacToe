//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-04-08.
//

import Foundation

// MARK: Board
public extension TicTacToe {
    struct Board: Equatable, CustomStringConvertible {
        internal var fillAtSquare: [Square: Fill] = [:]
    }
}

// MARK: Error
public extension TicTacToe.Board {
    enum Error: Swift.Error {
        case squareAlreadyFilled
    }
}

// MARK: Internal
internal extension TicTacToe.Board {
    mutating func play(index: Square, by player: Player) throws {
        guard self[index] == nil else {
            throw Error.squareAlreadyFilled
        }
        self[index] = player.fill
    }
}

// MARK: Query
internal extension TicTacToe.Board {
    // sugar
    subscript(square: Square) -> Fill? {
        get { fillAtSquare[square] }
        
        set {
            precondition(`is`(square: square, .free))
            fillAtSquare[square] = newValue
        }
    }
    
    func isFull() -> Bool {
        fillAtSquare.count == Square.allCases.count
    }
    
    func hasPlayer(_ player: Player, filledSquare square: Square) -> Bool {
        self[square] == player.fill
    }
    
    enum Query {
        case free, taken
    }
    
    func `is`(square: Square, _ query: Query) -> Bool {
        switch query {
        case .free: return self[square] == nil
        case .taken: return self[square] != nil
        }
    }
}

// MARK: CustomStringConvertible
public extension TicTacToe.Board {
    var description: String {
        ascii()
    }
}
