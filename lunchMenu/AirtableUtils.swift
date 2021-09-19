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
  guard let filePath = Bundle.main.path(forResource: "Secrets", ofType: "plist") else {
    fatalError("Couldn't find file 'Secrets.plist'.")
  }
  // 2
  let plist = NSDictionary(contentsOfFile: filePath)
  guard let value = plist?.object(forKey: "API_KEY") as? String else {
    fatalError("Couldn't find key 'API_KEY' in 'Secrets.plist'.")
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
  Menu.shared.sections = record.fields.map {
    key, value in
    Section(name: key, items: (value as! [String]).map { Item($0) })
  }
}

func fetchMenu() {
  listFromAirtablePublisher
    .replaceError(with: .init(fields: [:]))
    .sink(receiveValue: update(with:))
    .store(in: &subscriptions)
}
