//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-04-08.
//

import Foundation

extension TicTacToe.Board {
    /// Squares 0 through 8
    enum Square: UInt8, ExpressibleByIntegerLiteral, CaseIterable, Hashable {
        case zero, one, two, three, four, five, six, seven, eight
    }
}

extension ExpressibleByIntegerLiteral where Self: RawRepresentable, RawValue: _ExpressibleByBuiltinIntegerLiteral {
    public typealias IntegerLiteralType = RawValue
    public init(integerLiteral value: RawValue) {
        self = Self(rawValue: value)!
    }
}
