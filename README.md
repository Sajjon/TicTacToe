# TicTacToe

## Play

```sh
swift run TicTacToe
```

Which starts the game, presenting this beautiful ascii graphics:

```bash
 1 │ 2 │ 3
───┼───┼───
 4 │ 5 │ 6
───┼───┼───
 7 │ 8 │ 9

playerX, which square:
```

And since this is the most pointless game in the history of games, get used to seeing the draw result.

```bash
⚖️ Game ended with a draw


 o │ x │ x
───┼───┼───
 x │ x │ o
───┼───┼───
 o │ o │ x
```

And in some rare cases where your partner had one to many 🍺 you might see this:

```bash
playerX, which square:
9

🎉  playerX won!


 x │ o │ o
───┼───┼───
 4 │ x │ 6
───┼───┼───
 7 │ 8 │ x
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
    
    let index = repeatedReadSquare(
        prompt: "\(activePlayer), which square:",
        ifBadNumber: "☣️  Bad input",
        ifSquareTaken: "⚠️  Square not free",
        tipOnHowToExitProgram: "💡 You can quit this program by pressing: `CTRL + c`"
    ) { board.is(square: $0, .free) }
        
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
        internal var fillAtSquare: [Square: Fill] = [:]
    }
}

extension TicTacToe.Board {
    /// Squares 0 through 8
    enum Square: UInt8, ExpressibleByIntegerLiteral, CaseIterable, Hashable {
        case zero, one, two, three, four, five, six, seven, eight
    }
}
```

#### Got smarter ASCII print? PR!

```swift
public extension TicTacToe.Board {
    func ascii() -> String {
        Self.rows
            .map(ascii(row:))
            .joined(separator: "\n───┼───┼───\n")
    }
}

private extension TicTacToe.Board {
    
    func ascii(row: Row) -> String {
        " " + row.map(ascii(square:)).joined(separator: " │ ")
    }

    func ascii(square: Square) -> String {
        self[square].map({ $0.ascii }) ?? square.ascii
    }
}

private extension TicTacToe.Board.Fill {
    var ascii: String { rawValue }
}

private extension TicTacToe.Board.Square {
    var ascii: String { "\(rawValue + 1)" }
}


```

#### Got smarter win condition check? PR!

```swift
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

```
