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

//struct Options: ParsableArguments {
//    @Flag(name: [.customLong("ai")], help: "Play vs AI (else PvP)")
//    var vsAI: Bool
//}

extension TicTacToeParser {
    struct New: ParsableCommand {
        static var configuration =
            CommandConfiguration(abstract: "Starts a new tic tac toe game")
        
//        // The `@OptionGroup` attribute includes the flags, options, and
//        // arguments defined by another `ParsableArguments` type.
//        @OptionGroup()
//        var options: Options
        
        func run() throws {
//            print(options)
//            var game = TicTacToe(
//                matchUp: options.vsAI ? .humanVersusComputer(.easy) : .humanVersusHuman
//            )
            var game = TicTacToe(matchUp: .humanVersusHuman)
            
            var result: TicTacToe.Result?
            repeat {
                result = try game.play()
            } while result == nil
            game.printBoard()
            print(result!)
        }
    }
}

TicTacToeParser.main()
