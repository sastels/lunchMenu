//
//  SMSUtils.swift
//  lunchMenu
//
//  Created by Stephen Astels on 2021-09-17.
//
//  from https://stackoverflow.com/questions/60014299/sending-sms-programmatically-using-swiftui

import MessageUI
import SwiftUI

struct MessageComposeView: UIViewControllerRepresentable {
  typealias Completion = (_ messageSent: Bool) -> Void

  static var canSendText: Bool { MFMessageComposeViewController.canSendText() }
        
  let recipients: [String]?
  let body: String?
  let completion: Completion?
    
  func makeUIViewController(context: Context) -> UIViewController {
    guard Self.canSendText else {
      let errorView = MessagesUnavailableView()
      return UIHostingController(rootView: errorView)
    }
        
    let controller = MFMessageComposeViewController()
    controller.messageComposeDelegate = context.coordinator
    controller.title = "Ben's Order"
    controller.recipients = recipients
    controller.body = body
    controller.subject = "Order"
    
    return controller
  }
    
  func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
    
  func makeCoordinator() -> Coordinator {
    Coordinator(completion: completion)
  }
    
  class Coordinator: NSObject, MFMessageComposeViewControllerDelegate {
    private let completion: Completion?

    public init(completion: Completion?) {
      self.completion = completion
    }
        
    public func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
      controller.dismiss(animated: true, completion: nil)
      completion?(result == .sent)
    }
  }
}

struct MessagesUnavailableView: View {
  var body: some View {
    VStack {
      Image(systemName: "xmark.octagon")
        .font(.system(size: 64))
        .foregroundColor(.red)
      Text("Messages is unavailable")
        .font(.system(size: 24))
    }
  }
}
