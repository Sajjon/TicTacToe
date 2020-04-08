//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-04-08.
//

import Foundation

public extension TicTacToe {
    struct Board: Equatable, CustomStringConvertible {
        
        internal var rowsOfColumns: [[Fill?]]
        
        internal init() {
            rowsOfColumns = [[Fill?]](
                repeating: [Fill?](
                    repeating: nil, count: 3
                ), count: 3
            )
        }
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
    mutating func play(index: Index, by player: Player) throws {
        guard self[index] == nil else {
            throw Error.squareAlreadyFilled
        }
        self[index] = player.fill
    }
    
    func isFull() -> Bool {
        rowsOfColumns.allSatisfy({ $0.allSatisfy({ $0 != nil }) })
    }
    
    subscript(index: Index) -> Fill? {
        get {
            let (row, column) = rowAndColumnFrom(index: index)
            return rowsOfColumns[Int(row)][Int(column)]
        }
        
        set {
            let (row, column) = rowAndColumnFrom(index: index)
            rowsOfColumns[Int(row)][Int(column)] = newValue
        }
    }
}

// MARK: CustomStringConvertible
public extension TicTacToe.Board {
    var description: String {
        ascii()
    }
}

// MARK: Private
private extension TicTacToe.Board {
    
    func rowAndColumnFrom(index i: Index) -> (row: UInt8, column: UInt8) {
        let index = i.value
        let row = index / 3
        let column = index % 3
        return (row: UInt8(row), column: UInt8(column))
    }
}
