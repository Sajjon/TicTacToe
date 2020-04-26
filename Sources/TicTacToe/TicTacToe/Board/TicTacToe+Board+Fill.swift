//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-04-08.
//

import Foundation

public extension TicTacToe.Board {
    enum Fill: String, Equatable {
        case cross = "\u{1b}[31;1mx\u{1b}[m"
        case nought = "\u{1b}[32;1mo\u{1b}[m"
    }
}
