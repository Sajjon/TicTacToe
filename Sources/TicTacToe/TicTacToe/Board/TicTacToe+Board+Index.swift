//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-04-08.
//

import Foundation

extension TicTacToe.Board {
    struct Index: ExpressibleByIntegerLiteral {
        typealias IntegerLiteralType = UInt8
        
        /// 0 - 8
        let value: IntegerLiteralType
        
        enum Error: Swift.Error {
            case mustBeSmallerThan9
        }
        
        init(_ value: IntegerLiteralType) throws {
            guard value < 9 else {
                throw Error.mustBeSmallerThan9
            }
            self.value = value
        }
        
        init(integerLiteral value: IntegerLiteralType) {
            assert(value <= 8, "should be 0-8")
            self.value = value
        }
    }
    
}
