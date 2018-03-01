//
//  URLItemContainer.swift
//  URLHolster
//
//  Created by kazumi hayashida on 2018/02/14.
//  Copyright © 2018年 kazumi hayashida. All rights reserved.
//

import Foundation

class URLItemContainer {
  private var urlItems = [[URLItem]]()
  
  var count: Int {
    return urlItems.count
  }
  
  public func initializeUrlItems() {
    urlItems.removeAll()
    
    for _ in 0..<4 {
      urlItems.append([URLItem]())
    }
  }
  
  public func sectionCount(section: Int) -> Int {
    return urlItems[section].count
  }
  
  public func urlItem(section: Int, row: Int) -> URLItem {
    return urlItems[section][row]
  }
  
  public func addUrlItems(urlItem: URLItem) {
    let calendar = Calendar(identifier: .japanese)
    if calendar.isDateInToday(urlItem.preserveDate) {
      self.urlItems[0].append(urlItem)
    } else if calendar.isDateInYesterday(urlItem.preserveDate) {
      self.urlItems[1].append(urlItem)
    } else if calendar.isDateInWeekend(urlItem.preserveDate) {
      self.urlItems[2].append(urlItem)
    } else {
      self.urlItems[3].append(urlItem)
    }
  }
}
