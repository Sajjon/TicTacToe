//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-04-08.
//

import Foundation

extension TicTacToe.Board {
    struct Index: ExpressibleByIntegerLiteral {
        
        /// Only allow values are: 0 - 8
        let value: IntegerLiteralType
        
        init(_ value: IntegerLiteralType) throws {
            guard value < 9 else {
                throw Error.mustBeSmallerThan9
            }
            self.value = value
        }
    }
}

// MARK: ExpressibleByIntegerLiteral
extension TicTacToe.Board.Index {
    typealias IntegerLiteralType = UInt8
    init(integerLiteral value: IntegerLiteralType) {
        assert(value <= 8, "should be 0-8")
        self.value = value
    }
}

extension TicTacToe.Board.Index {
    init<I>(row: I, column: I) where I: FixedWidthInteger {
        self.init(integerLiteral: IntegerLiteralType(row*3 + column))
    }
}

// MARK: Error
extension TicTacToe.Board.Index {
    enum Error: Swift.Error {
        case mustBeSmallerThan9
    }
}
