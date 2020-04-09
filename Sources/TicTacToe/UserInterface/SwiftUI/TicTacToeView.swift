//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-04-09.
//

import Foundation
import SwiftUI

typealias Square = TicTacToe.Board.Square

struct TicTacToeView {
    @ObservedObject
    private var model = Model()
}

// MARK: Model
extension TicTacToeView {
    final class Model: ObservableObject {
        
        @Published
        var gameNumber = 1
        
        @Published
        var game = TicTacToe(matchUp: .humanVersusHuman)
        
        @Published
        var result: TicTacToe.Result?
        
        @Published
        var errorMessage: String?
    }
}

extension TicTacToeView.Model {
    
    func newGame() {
        game = TicTacToe(matchUp: .humanVersusHuman)
        result = nil
        errorMessage = nil
        gameNumber += 1
    }
    
    func tryFill(square: Square) {
        do {
            result = try game.play(square: square)
            errorMessage = nil
        } catch let error as TicTacToe.Board.Error {
            switch error {
            case .squareAlreadyFilled:
                errorMessage = "⚠️ Invalid Move: Square already filled"
            }
        } catch {
            fatalError("Unrecognized error: \(error)")
        }
    }
    
    func buttonText(square: Square) -> String {
        game.board[square].map({ $0.rawValue }) ?? ""
    }
}

// MARK: View
extension TicTacToeView: SwiftUI.View {
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Group {
                    if self.model.errorMessage != nil {
                        self.errorView
                    } else if self.model.result != nil {
                        self.gameOverView
                    } else {
                        self.gameView(geometry: geometry)
                    }
                }
            }.frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

// MARK: SubViews
private extension TicTacToeView {
    
    var errorView: some View {
        VStack {
            Text("\(self.model.errorMessage!)")
                .font(.largeTitle)
                .multilineTextAlignment(.center)
            
            Button(
                action: { self.model.errorMessage = nil },
                label: { Text("Dismiss").font(.largeTitle) }
            )
                .buttonStyle(BorderedButtonStyle())
                .padding(30)
        }
    }
    
    var gameOverView: some View {
        VStack {
            Text("\(self.model.result!.description)")
                .font(.largeTitle)
            
            Button(
                action: { self.model.newGame() },
                label: { Text("One more?").font(.title) }
            )
                .buttonStyle(BorderedButtonStyle())
                .padding(30)
        }
    }
    
    
    func gameView(geometry: GeometryProxy) -> some View {
        VStack {
            Text("Game number: \(self.model.gameNumber)").font(.subheadline)
            Text("Turn: \(self.model.game.activePlayer.description)").font(.headline)
            ForEach(TicTacToe.Board.rows, id: \.self) { row in
                VStack {
                    Divider()
                    HStack {
                        ForEach(row, id: \.self) { square in
                            HStack {
                                Divider()
                                
                                Button(
                                    action: {
                                        self.model.tryFill(square: square)
                                },
                                    label: {
                                        Text("\(self.model.buttonText(square: square))")
                                            .font(.system(size: geometry.size.height/10))
                                            .frame(width: geometry.size.height/10, height: geometry.size.height/10)
                                            .padding(geometry.size.height/20)
                                            .background(Color.white)
                                            .foregroundColor(.black)
                                    }
                                )
                                    .buttonStyle(PlainButtonStyle())
                                
                                
                                if TicTacToe.Board.columns.last!.contains(square) {
                                    Divider()
                                }
                            }
                        }
                    }
                    
                }
            }
        }
    }
}
