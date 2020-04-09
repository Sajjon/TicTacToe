//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-04-09.
//

import Foundation
import SwiftUI

public protocol UserInterfaceProtocol {
    static func show<V>(view: V) where V: SwiftUI.View
}

public enum UserInterface: UserInterfaceProtocol {}
