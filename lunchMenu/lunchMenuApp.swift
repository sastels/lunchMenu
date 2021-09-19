//
//  lunchMenuApp.swift
//  lunchMenu
//
//  Created by Stephen Astels on 2021-09-12.
//

import SwiftUI

@main
struct lunchMenuApp: App {
  var body: some Scene {
    let menu = Menu(sections: [])
    Menu.shared = menu

    return (
      WindowGroup {
        MenuView().environmentObject(menu)
      }
    )
  }
}
