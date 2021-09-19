//
//  ContentView.swift
//  lunchMenu
//
//  Created by Stephen Astels on 2021-09-12.
//

import SwiftUI

struct MenuView: View {
  @EnvironmentObject var menu: Menu
  @State private var showingMail = false

  var body: some View {
    return (
      VStack {
        Text("Ben's Breakfast").font(.largeTitle)
        List(menu.sections) { section in
          Spacer()
          MenuSection(section: section)
          Spacer()
        }
        Button("Order!") {
          print(menu)
          showingMail = true
        }.buttonStyle(CustomButtonStyle(.rounded(type: .primary), size: .large, isFullWidth: true))
        Spacer(minLength: 100)
      }
      .padding(64)
      .font(/*@START_MENU_TOKEN@*/ .title/*@END_MENU_TOKEN@*/)
      .sheet(isPresented: $showingMail) {
        MessageComposeView(recipients: ["sastels@gmail.com"], body: "\(menu)") { messageSent in
          print("MessageComposeView with message sent? \(messageSent)")
        }
      }
      .onAppear {
        fetchMenu()
      }
    )
  }
}

struct MenuView_Previews: PreviewProvider {
  static var previews: some View {
    let menu = Menu(sections:
      [Section(name: "Cereal", items: [Item("Cheerios"), Item("Granola")]),
       Section(name: "Bread", items: [Item("Toast"), Item("Bagel"), Item("English muffin")]),
       Section(name: "Drink", items: [Item("Juice"), Item("Water"), Item("Milk")])])
    return (
      MenuView().environmentObject(menu)
    )
  }
}
