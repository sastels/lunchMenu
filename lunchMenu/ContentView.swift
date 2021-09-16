//
//  ContentView.swift
//  lunchMenu
//
//  Created by Stephen Astels on 2021-09-12.
//

import SwiftUI

struct ContentView: View {
  @EnvironmentObject var menu: Menu

  var body: some View {
    return (
      VStack {
        Text("Menu").font(.largeTitle)
        List(menu.sections) { section in
          Spacer()
          MenuSection(section: section)
          Spacer()
        }
        Spacer()
        Button("Order!") {
          print(menu)
        }
      }.padding(64)
    )
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    let menu = Menu(sections:
      [Section(name: "Cereal", items: [Item("Cheerios"), Item("Granola")]),
       Section(name: "Bread", items: [Item("Toast"), Item("Bagel"), Item("English muffin")]),
       Section(name: "Drink", items: [Item("Juice"), Item("Water"), Item("Milk")])])
    return (
      ContentView().environmentObject(menu)
    )
  }
}
