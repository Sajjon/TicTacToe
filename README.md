# TicTacToe

## Play

```sh
swift run TicTacToe new
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
````