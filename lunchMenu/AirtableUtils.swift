//
//  AirtableUtils.swift
//  lunchMenu
//
//  Created by Stephen Astels on 2021-09-19.
//

import AirtableKit
import Combine
import SwiftUI

private var subscriptions: Set<AnyCancellable> = []

private var airtableApiKey: String {
  // 1
  guard let filePath = Bundle.main.path(forResource: "Airtable-Info", ofType: "plist") else {
    fatalError("Couldn't find file 'Airtable-Info.plist'.")
  }
  // 2
  let plist = NSDictionary(contentsOfFile: filePath)
  guard let value = plist?.object(forKey: "API_KEY") as? String else {
    fatalError("Couldn't find key 'API_KEY' in 'Airtable-Info.plist'.")
  }
  return value
}

private var airtable: Airtable {
  Airtable(baseID: "appam5yxp2c3gLb6q", apiKey: airtableApiKey)
}

/// A publisher that lists the items from Airtable
private var listFromAirtablePublisher: AnyPublisher<AirtableKit.Record, AirtableError> {
  airtable
    .list(tableName: "Breakfast", fields: ["Cereal", "Bread", "Drink"])
    .receive(on: DispatchQueue.main)
    .compactMap(\.first)
    .eraseToAnyPublisher()
}

private func update(with record: AirtableKit.Record) {
  let cereal: [String] = record.Cereal ?? []
  let bread: [String] = record.Bread ?? []
  let drink: [String] = record.Drink ?? []

  print("cereal: \(cereal)")
  print("bread: \(bread)")
  print("drink: \(drink)")

  Menu.shared.sections =
    [Section(name: "Cereal", items: cereal.map { Item($0) }),
     Section(name: "Bread", items: bread.map { Item($0) }),
     Section(name: "Drink", items: drink.map { Item($0) })]

//  print("\(record.Cereal)")
//       self.record = record
//       self.state.name = record.name ?? ""
//       self.state.age = record.age ?? 0
//       self.state.isCool = record.isCool ?? false
//       self.state.createdTime = record.createdTime ?? Date()
//       self.state.updatedTime = record.updatedTime ?? Date()
//       self.state.imageUrl = record.attachments["image"]?.first?.url ?? URL(string: AppState.placeholderStringUrl)!
}

func fetchMenu() {
  listFromAirtablePublisher
    .replaceError(with: .init(fields: [:]))
    .sink(receiveValue: update(with:))
    .store(in: &subscriptions)
}
