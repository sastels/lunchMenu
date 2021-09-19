//
//  SMSUtils.swift
//  lunchMenu
//
//  Created by Stephen Astels on 2021-09-17.
//
//  from https://stackoverflow.com/questions/60014299/sending-sms-programmatically-using-swiftui

import MessageUI
import SwiftUI

private var smsTo: [String] {
  guard let filePath = Bundle.main.path(forResource: "Secrets", ofType: "plist") else {
    fatalError("Couldn't find file 'Secrets.plist'.")
  }
  let plist = NSDictionary(contentsOfFile: filePath)
  guard let value = plist?.object(forKey: "SMS_TO") as? [String] else {
    fatalError("Couldn't find key 'SMS_TO' in 'Secrets.plist'.")
  }
  return value
}

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
    controller.recipients = smsTo
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
