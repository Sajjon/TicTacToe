//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-04-08.
//

import Foundation

public extension TicTacToe.Board {
     func hasAnyoneWon() -> Player? {
         func hasPlayerWon(_ player: Player) -> Bool {
             // check 3 rows
             for row in threeByThreeSquares {
                 if row.allSatisfy({ $0 == player.fill }) {
                     return true
                 }
             }
             
             // check 3 columns
             columnLoop: for columnIndex in 0..<3 {
                 for rowIndex in 0..<3 {
                     guard threeByThreeSquares[rowIndex][columnIndex] == player.fill else {
                         continue columnLoop
                     }
                 }
                 return true
             }
             
             // check 2 diagonals
             func check(diagonal: [Index]) -> Bool {
                 precondition(diagonal.count == 3)
                 return diagonal.allSatisfy({ self[$0] == player.fill })
             }
             
             if check(diagonal: [2, 4, 6]) || check(diagonal: [0, 4, 8]) {
                 return true
             }
             
             return false
         }
         
         for player in Player.allCases {
             guard hasPlayerWon(player) else {
                 continue
             }
             return player
         }
    
         return nil
     }
     

}
