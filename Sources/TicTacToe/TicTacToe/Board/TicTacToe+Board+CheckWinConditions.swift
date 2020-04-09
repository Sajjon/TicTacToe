//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-04-08.
//

import Foundation

public extension TicTacToe.Board {
    
    func winner() -> Player? {
        func hasPlayerWon(_ player: Player) -> Bool {
            func check(_ squareMatrix: [[Square]]) -> Bool {
                squareMatrix.reduce(false, { hasWon, squareList in
                    hasWon || squareList.allSatisfy({ hasPlayer(player, filledSquare: $0) })
                })
            }
            
            return Self.winConditions.reduce(false, { hasWon, squareMatrix in
                hasWon || check(squareMatrix)
            })
        }
        
        return Player.allCases.first(where: { hasPlayerWon($0) })
    }
    
}

extension TicTacToe.Board {
    
    typealias Row       = [Square]
    typealias Column    = [Square]
    typealias Diagonal  = [Square]
    
    // MARK: Rows
    static let firstRow:        Row = [0, 1, 2]
    static let secondRow:       Row = [3, 4, 5]
    static let thirdRow:        Row = [6, 7, 8]
    static let rows:            [Row] = [firstRow, secondRow, thirdRow]
    
    // MARK: Columns
    static let firstColumn:     Column = [0, 3, 6]
    static let secondColumn:    Column = [1, 4, 7]
    static let thirdColumn:     Column = [2, 5, 8]
    static let columns:         [Column] = [firstColumn, secondColumn, thirdColumn]
    
    // MARK: Diagonals
    
    /// Main, Major, Principal, Primary; diagonal: ╲
    /// from top left, to bottom right
    static let mainDiagonal:    Diagonal = [2, 4, 6]
    
    /// Anti-, Minor, Counter, Secondary; diagonal: ╱
    /// from bottom left, to top right
    static let antiDiagonal:    Diagonal = [0, 4, 8]
    static let diagonals:       [Diagonal] = [mainDiagonal, antiDiagonal]
    
    static let winConditions: [[[Square]]] = [rows, columns, diagonals]
}
