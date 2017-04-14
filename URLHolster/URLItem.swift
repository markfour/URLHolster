//
//  URLItem.swift
//  URLHolster
//
//  Created by kazumi hayashida on 2017/02/12.
//  Copyright © 2017年 kazumi hayashida. All rights reserved.
//

import Foundation

class URLItem {
  var title: String
  var url: URL
  var preserveDate: Date
  
  init(title: String, URL: URL) {
    self.title = title
    self.url = URL
    self.preserveDate = Date()
  }
  
  init(dict: [String: Any]) {
    if let web_title = dict["web_title"] {
      if let t = web_title as? String {
        self.title = t
      } else {
        self.title = ""
      }
    } else {
      self.title = ""
    }
    
    let urlString = dict["rawurl"] as! String
    self.url = URL(string: urlString)!
    
    if let preserveDate = dict["preserveDate"] {
      print("preserveDate \(preserveDate)")
      if let dateString = preserveDate as? String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: dateString)
        self.preserveDate = date!
      } else {
        self.preserveDate = Date()
      }
    } else {
        self.preserveDate = Date()
    }
  }
}
