//
//  ContentView.swift
//  lunchMenu
//
//  Created by Stephen Astels on 2021-09-12.
//

import SwiftUI
import MessageUI

struct MailComposeViewController: UIViewControllerRepresentable {
    
    var toRecipients: [String]
    var mailBody: String
    
    var didFinish: ()->()
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<MailComposeViewController>) -> MFMailComposeViewController {
        
        let mail = MFMailComposeViewController()
        mail.mailComposeDelegate = context.coordinator
        mail.setToRecipients(self.toRecipients)
        mail.setMessageBody(self.mailBody, isHTML: true)
        
        return mail
    }
    
    final class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        
        var parent: MailComposeViewController
        
        init(_ mailController: MailComposeViewController) {
            self.parent = mailController
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            parent.didFinish()
            controller.dismiss(animated: true)
        }
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: UIViewControllerRepresentableContext<MailComposeViewController>) {
        
    }
}


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
        }.buttonStyle(BlueButtonStyle())
        Spacer(minLength: 100)
      }
      .padding(64)
      .font(/*@START_MENU_TOKEN@*/ .title/*@END_MENU_TOKEN@*/)
      .sheet(isPresented: $showingMail) {
                  MailComposeViewController(toRecipients: ["sastels@gmail.com"], mailBody: "\(menu)") {
                      // Did finish action
                  }
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
