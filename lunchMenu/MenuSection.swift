//
//  MenuSection.swift
//  lunchMenu
//
//  Created by Stephen Astels on 2021-09-16.
//

import SwiftUI

struct MenuSection: View {
  @EnvironmentObject var menu: Menu
  @State var section: Section
  @State private var isOn: [Bool] = []

  var body: some View {
    VStack(spacing: 16) {
      Text(section.name).font(.title)
      HStack {
        ForEach(section.items.indices) { index in
          let item = section.items[index]
          Button("\(item.name)") {
            menu.toggle(sectionId: section.id, itemId: item.id)
            isOn[index].toggle()
          }.buttonStyle(WhiteButtonStyle())
            .background(
              ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                  .fill(index < isOn.count && isOn[index] ? Color( red: 0.48, green: 0.85, blue: 0.58, opacity: 1.0) : Color.white)//.opacity(0.3)
                RoundedRectangle(cornerRadius: 10, style: .continuous).strokeBorder(Color.black, lineWidth: 1)
              }
            )
        }.font(.title2)
      }
    }.padding()
      .onAppear {
        isOn = section.items.map { $0.chosen }
      }
  }
}

struct MenuSection_Previews: PreviewProvider {
  @State static var menu = Menu(sections:
    [Section(name: "Cereal", items: [Item("Cheerios"), Item("Granola")]),
     Section(name: "Bread", items: [Item("Toast"), Item("Bagel"), Item("English muffin")]),
     Section(name: "Drink", items: [Item("Juice"), Item("Water"), Item("Milk")])])

  static var previews: some View {
    menu.sections[0].items[0].chosen = true
    return (
      MenuSection(section: menu.sections[0]).environmentObject(menu)
    )
  }
}
