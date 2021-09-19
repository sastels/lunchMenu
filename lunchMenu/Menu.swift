//
//  Menu.swift
//  lunchMenu
//
//  Created by Stephen Astels on 2021-09-16.
//

import Foundation

class Item: Identifiable, ObservableObject {
  let id = UUID()
  let name: String
  @Published var chosen = false

  init(_ name: String) {
    self.name = name
  }
}

class Section: Identifiable, ObservableObject {
  let id = UUID()
  let name: String
  @Published var items: [Item] = []

  init(name: String, items: [Item]) {
    self.name = name
    self.items.append(contentsOf: items)
  }
}

class Menu: ObservableObject, CustomStringConvertible {
  static var shared = Menu(sections: [])
  
  var description: String
  @Published var sections: [Section] = []

  init(sections: [Section]) {
    description = "Ben's Breakfast Order\n"
    self.sections.append(contentsOf: sections)
  }

  func toggle(sectionId: UUID, itemId: UUID) {
    for section in sections {
      for item in section.items {
        if section.id == sectionId, item.id == itemId {
          item.chosen.toggle()
        }
      }
    }
    setDescription()
  }

  func setDescription() {
    description = "Ben's Breakfast Order:\n"
    for section in sections {
      var firstUse = true
      for item in section.items {
        if item.chosen {
          if firstUse {
            description += "- "
          }
          else {
            description += ", "
          }
          description += "\(item.name) "
          firstUse = false
        }
      }
      if !firstUse {
        description += "\n"
      }
    }
  }
}
