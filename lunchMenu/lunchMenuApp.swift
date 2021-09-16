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
    let menu = Menu(sections:
      [Section(name: "Cereal", items: [Item("Cheerios"), Item("Granola")]),
       Section(name: "Bread", items: [Item("Toast"), Item("Bagel"), Item("English muffin")]),
       Section(name: "Drink", items: [Item("Juice"), Item("Water"), Item("Milk")])])

    return (
      WindowGroup {
        MenuView().environmentObject(menu)
      }
    )
  }
}
