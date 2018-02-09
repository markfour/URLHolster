//
//  DummyData.swift
//  URLHolster
//
//  Copyright © 2018 kazumi hayashida. All rights reserved.
//

import Foundation

class DummyData {
  static let userDefaults = UserDefaults.standard
  
  class func enable() -> Bool {
    if let enableDummy = ProcessInfo.processInfo.environment["dummy_data"] {
      return enableDummy == "1"
    } else {
      return false
    }
  }
  
  class func didIntialize() -> Bool {
    return userDefaults.bool(forKey: "didInitialize")
  }

  class func initializeData() {
    guard let path = Bundle.main.path(forResource: "URLItemDummyData.plist", ofType:nil) else {
      print("error")
      assertionFailure()
      return
    }
    guard let data = NSArray(contentsOfFile: path) else {
      print("error")
      assertionFailure()
      return
    }
    userDefaults.set(data, forKey: "dummyData")
    userDefaults.set(true, forKey: "didInitialize")
  }
  
  class func fetch() -> [URLItem] {
    if !didIntialize() {
      initializeData()
    }
    var urlItems: [URLItem] = []
    
    let dummyDataArray = userDefaults.array(forKey: "dummyData")!
    dummyDataArray.forEach {
       urlItems.append(URLItem(dict: $0 as! [String: Any]))
    }
    
    return urlItems
  }
}
