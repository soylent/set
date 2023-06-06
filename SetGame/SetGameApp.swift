//
//  SetGameApp.swift
//  SetGame
//
//  Created by user on 6/3/23.
//

import SwiftUI

@main
struct SetGameApp: App {
    let game = SetGameViewModel()

    var body: some Scene {
        WindowGroup {
            SetGameView(game: game)
        }
    }
}
