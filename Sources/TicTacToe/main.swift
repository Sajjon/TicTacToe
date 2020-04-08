import ArgumentParser

// MARK: TicTacToeParser
struct TicTacToeParser: ParsableCommand {
}

//  MARK: CommandConfiguration
extension TicTacToeParser {
    // Customize your command's help and subcommands by implementing the
    // `configuration` property.
    static var configuration = CommandConfiguration(
        // Optional abstracts and discussions are used for help output.
        abstract: "A Tic Tac Toe game in pure swift.",
        
        // Pass an array to `subcommands` to set up a nested tree of subcommands.
        // With language support for type-level introspection, this could be
        // provided by automatically finding nested `ParsableCommand` types.
        subcommands: [New.self],
        
        // A default subcommand, when provided, is automatically selected if a
        // subcommand is not given on the command line.
        defaultSubcommand: New.self
    )
}

struct Options: ParsableArguments {
    @Flag(name: [.customLong("ai")], help: "Play vs AI (else PvP)")
    var vsAI: Bool
}

extension TicTacToeParser {
    struct New: ParsableCommand {
        static var configuration =
            CommandConfiguration(abstract: "Starts a new tic tac toe game")
        
        // The `@OptionGroup` attribute includes the flags, options, and
        // arguments defined by another `ParsableArguments` type.
        @OptionGroup()
        var options: Options
        
        func run() throws {
            print(options)
            var game = TicTacToe(
                matchUp: options.vsAI ? .humanVersusComputer(.easy) : .humanVersusHuman
            )
            
            var result: TicTacToe.Result?
            repeat {
                result = try game.play()
            } while result == nil
            game.printState()
            print(result!)
        }
    }
}

struct TicTacToe {
    enum MatchUp {
        case humanVersusHuman
        case humanVersusComputer(ComputerPlayer)
        //        case computerVersusComputer(ComputerPlayer, ComputerPlayer)
    }
    
    let matchUp: MatchUp
    var activePlayer: Player = .playerX
    
    private var state: State = .init()
    
    public init(matchUp: MatchUp) {
        self.matchUp = matchUp
    }

    /// Returns winning player, if game is over
    mutating func play() throws -> Result? {
        defer { activePlayer.toggle() }
        printState()
        print("Which index? >")
        let index = try State.Index(readInteger()! - 1)
        try state.play(index: index, by: activePlayer)
        
        if let winningPlayer = state.hasAnyoneWon() {
            return .win(by: winningPlayer)
        } else if state.isFull() {
            return .draw
        } else {
            return nil
        }
    }
    
    enum Result: CustomStringConvertible {
        case draw
        case win(by: Player)
        
        var description: String {
            switch self {
            case .draw: return "Game ended with a draw"
            case .win(let winningPlayer): return "\(winningPlayer) won!"
            }
        }
    }
    
    func printState() {
        print("\n\nTurn: \(activePlayer)")
        print(state)
    }
}


extension TicTacToe {
    struct State: Equatable, CustomStringConvertible {
        enum Fill: String, Equatable {
            case cross = "✖"
            case nought = "◯" // "○"
        }
        
        var threeByThreeSquares = [[Fill?]](repeating: [Fill?](repeating: nil, count: 3), count: 3)
        
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
        
        private func getFill(at index: Index) -> Fill? {
            let (row, column) = rowAndColumnFrom(index: index)
            return threeByThreeSquares[Int(row)][Int(column)]
        }
        
        private func rowAndColumnFrom(index i: Index) -> (row: UInt8, column: UInt8) {
            let index = i.value
            let row = index / 3
            let column = index % 3
            return (row: UInt8(row), column: UInt8(column))
        }
        
        enum Error: Swift.Error {
            case squareAlreadyOccupied(by: Fill)
        }
        
        mutating func play(index: Index, by player: Player) throws {
            if let occupiyingFill = getFill(at: index) {
                throw Error.squareAlreadyOccupied(by: occupiyingFill)
            }
            let (row, column) = rowAndColumnFrom(index: index)
      
            threeByThreeSquares[Int(row)][Int(column)] = player.fill
        }
        
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
                    return diagonal.allSatisfy({ getFill(at: $0) == player.fill })
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
        
        func isFull() -> Bool {
            threeByThreeSquares.allSatisfy({ $0.allSatisfy({ $0 != nil }) })
        }
        
        var description: String {
            ascii()
        }
        
        func ascii() -> String {
            func rowSeparator(
                leadingNewline: Bool = true,
                trailingNewline: Bool = true
            ) -> String {
                
                [
                    leadingNewline ? "\n" : "",
                    String(repeating: "-", count: 13),
                    trailingNewline ? "\n" : "",
                ]
                .joined()
            }
            
            return [
                    [""],
                    threeByThreeSquares.enumerated().map { (rowIndex, row) in
                        
                        return [
                            "|",
                            row.enumerated().map { (columnIndex, maybeFill) -> String in
                                if let fill = maybeFill {
                                    return fill.rawValue
                                } else {
                                    return "\(columnIndex + (rowIndex * 3) + 1)"
                                }
                            }
                            .map { " \($0) " } // add space left right
                            .joined(separator: "|"),
                            "|"
                        ].joined()
                        
                    },
                    [""]
                ]
                    .flatMap { $0 }
                    .joined(separator: rowSeparator())
        }
    }
}

struct ComputerPlayer {}
extension ComputerPlayer {
    static let easy = Self()
    static let hard = Self()
}

enum Player: UInt8, Equatable, CaseIterable {
    case playerX
    case playerO
    
    mutating func toggle() {
        self = Self(rawValue: (rawValue + 1) % 2)!
    }
    
    var fill: TicTacToe.State.Fill {
        switch self {
        case .playerO: return .nought
        case .playerX: return.cross
        }
    }
}

TicTacToeParser.main()
