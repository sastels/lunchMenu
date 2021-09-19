//
//  Styles.swift
//  lunchMenu
//
//  Created by Stephen Astels on 2021-09-16.
//

import Foundation
import SwiftUI



struct MyButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .opacity(configuration.isPressed ? 0.5 : 1.0)
  }
}


// based on https://sarunw.com/posts/swiftui-buttonstyle/

struct BlueButtonStyle: ButtonStyle {
  var bgColor: Color = .blue

  func makeBody(configuration: Self.Configuration) -> some View {
    configuration.label
      .foregroundColor(.white)
      .padding(10)
      .background(
        ZStack {
          RoundedRectangle(cornerRadius: 10, style: .continuous)
            .shadow(color: .black, radius: configuration.isPressed ? 7 : 10, x: configuration.isPressed ? 5 : 15, y: configuration.isPressed ? 5 : 15)
            .blendMode(.overlay)
          RoundedRectangle(cornerRadius: 10, style: .continuous)
            .fill(bgColor)
        }
      )
      .scaleEffect(configuration.isPressed ? 0.95 : 1)
      .animation(.spring())
  }
}

struct WhiteButtonStyle: ButtonStyle {
  var bgColor: Color = .white

  func makeBody(configuration: Self.Configuration) -> some View {
    configuration.label
      .foregroundColor(.black)
      .padding(.vertical, 2)
      .padding(.horizontal, 10)
      .background(
        ZStack {
          RoundedRectangle(cornerRadius: 10, style: .continuous)
            .shadow(color: .black, radius: configuration.isPressed ? 1 : 5, x: configuration.isPressed ? 1 : 5, y: configuration.isPressed ? 1 : 5)
            .blendMode(.overlay)
        }
      )
      .scaleEffect(configuration.isPressed ? 0.95 : 1)
      .animation(.spring())
  }
}
