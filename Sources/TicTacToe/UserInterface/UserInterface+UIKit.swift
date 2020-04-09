//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-04-09.
//


#if os(iOS) || os(watchOS) || os(tvOS)
import Foundation
import UIKit

public extension UserInterface {
    
    static func show<V>(view: V) where V: SwiftUI.View{
        fatalError()
    }
}

#endif
