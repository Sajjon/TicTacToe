# TicTacToe

## Play

```sh
swift run TicTacToe
```

Which starts the game, presenting this beautiful ascii graphics:

```bash
Turn: playerX

-------------
| 1 | 2 | 3 |
-------------
| 4 | 5 | 6 |
-------------
| 7 | 8 | 9 |
-------------

Which index? >
```

And since this is the most pointless game in the history of games, get used to seeing the draw result.

```bash
⚖️ Game ended with a draw

-------------
| ✖ | ✖ | ◯ |
-------------
| ◯ | ◯ | ✖ |
-------------
| ✖ | ✖ | ◯ |
-------------
```

And in some rare cases where your partner had one to many 🍺 you might see this:

```bash
playerX, which square:
7

🎉  playerX won!

-------------
| ✖ | ◯ | ✖ |
-------------
| ◯ | ✖ | ◯ |
-------------
| ✖ | ✖ | ◯ |
-------------
```


## Implementation

### `main.swift`

```swift
func run() throws {
    var game = TicTacToe(matchUp: .humanVersusHuman)
    
    var result: TicTacToe.Result!
    repeat {
        result = try game.play()
    } while result == nil
    
    print("\n\(result!)")
    game.printBoard()
}
```

### `TicTacToe.swift`

```swift
mutating func play() throws -> Result? {
    defer { activePlayer.toggle() }
    
    printBoard()
    
    let index = try readIndex(prompt: "\(activePlayer), which square:")
    try board.play(index: index, by: activePlayer)
    
    if board.isFull() {
        return .draw
    } else {
        return board.winner().map { .win(by: $0) }
    }
}
```

### `Board` 

```swift
public extension TicTacToe {
    struct Board: Equatable, CustomStringConvertible {
        
        internal var rowsOfColumns: [[Fill?]] // `.cross`, `.nought` or `nil`
        
        internal init() {
            rowsOfColumns = [[Fill?]](
                repeating: [Fill?](
                    repeating: nil, count: 3
                ), count: 3
            )
        }
    }
}
```

#### Got smarter ASCII print? PR!

```swift
public extension TicTacToe.Board {
    func ascii() -> String {
        
        let rowSeparator = ["\n", String(repeating: "-", count: 13), "\n"].joined()
     
        func toString(row: Int, column: Int) -> String {
            let index = Index(row: row, column: column)
            return self[index].map({ $0.rawValue }) ?? "\(index.value + 1)"
        }
        
        let body = rowsOfColumns.enumerated().map { (rowIndex, row) in
            row
                .enumerated()
                .map { toString(row: rowIndex, column: $0.offset) }
                .map { " \($0) " } // add space left right
                .joined(separator: "|")
        }
        .map { "|\($0)" }
        .joined(separator: "|\(rowSeparator)")
        .appending("|")
        
        
        return [
            rowSeparator,
            body,
            rowSeparator
        ]
            .joined()
    }
}

```

#### Got smarter win condition check? PR!

```swift
public extension TicTacToe.Board {
    func hasPlayerWon(_ player: Player) -> Bool {
        // check 3 rows
        for row in rowsOfColumns {
            if row.allSatisfy({ $0 == player.fill }) {
                return true
            }
        }
        
        // check 3 columns
        columnLoop: for column in 0..<3 {
            for row in 0..<3 {
                guard self[Index(row: row, column: column)] == player.fill else {
                    continue columnLoop
                }
            }
            return true
        }
        
        // check 2 diagonals
        func check(diagonal: [Index]) -> Bool {
           diagonal.allSatisfy({ self[$0] == player.fill })
        }
        
        if check(diagonal: .mainDiagonal) || check(diagonal: .antiDiagonal) {
            return true
        }
        
        return false
    }
}

// Sugar
private extension Array where Element == TicTacToe.Board.Index {
    /// Main, Major, Principal, Primary; diagonal: ╲
    /// from top left, to bottom right
    static let mainDiagonal: [Element] = [2, 4, 6]
    
    /// Anti-, Minor, Counter, Secondary; diagonal: ╱
    /// from bottom left, to top right
    static let antiDiagonal: [Element] = [0, 4, 8]
}
```