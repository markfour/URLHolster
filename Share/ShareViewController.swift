//
//  ShareViewController.swift
//  Share
//
//  Created by kazumi hayashida on 2017/04/12.
//  Copyright © 2017年 kazumi hayashida. All rights reserved.
//

import UIKit
import Social

class ShareViewController: SLComposeServiceViewController {
  
  override func isContentValid() -> Bool {
    return true
  }
  
  override func didSelectPost() {
    let extensionItem: NSExtensionItem = self.extensionContext?.inputItems.first as! NSExtensionItem
    let itemProvider = extensionItem.attachments?.first as! NSItemProvider
    
    let puclicURL = "public.url"
    
    // shareExtension で URL を取得
    if itemProvider.hasItemConformingToTypeIdentifier(puclicURL) {
      itemProvider.loadItem(forTypeIdentifier: puclicURL, options: nil, completionHandler: { (item, error) in
        print("title? \(self.contentText)")
        print("items \(item)")
        // URLを取得する
        if let url: URL = item as? URL {
          self.postWith(title: self.contentText!, url: url)
        }
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
      })
    }
  }
  
  override func configurationItems() -> [Any]! {
    // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
    return []
  }
  
  func postWith(title: String, url: URL) {
    let date = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    let dateString = formatter.string(from: date)
    
    let urlItem = ["user_id": 1,
                   "web_title": title,
                   "rawurl": url.absoluteString,
                   "preserveDate": dateString
      ] as [String : Any]
    let paramater = ["urlitem": urlItem] as [String : Any]
    var jsonData: Data?
    do {
      jsonData = try JSONSerialization.data(withJSONObject: paramater, options: .prettyPrinted)
    } catch {
      print("json parse error")
    }
    let requestURL = URL(string: "http://localhost:3000/urlitems")
    var request = URLRequest(url: requestURL!)
    request.addValue("application/json", forHTTPHeaderField: "Content-type")
    request.httpMethod = "POST"
    request.httpBody = jsonData
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
      print("response \(String(describing: response))")
    }
    task.resume()
  }
}
