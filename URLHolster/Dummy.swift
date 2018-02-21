//
//  Dummy.swift
//  URLHolster
//
//  Copyright © 2018 kazumi hayashida. All rights reserved.
//

import Foundation

class Dummy {
  static let userDefaults = UserDefaults.init(suiteName: "group.com.khayashida.app")!
  static let forceEnable = true
  
  class func enable() -> Bool {
    if forceEnable {
      return true
    }
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
    guard let fileData = NSArray(contentsOfFile: path) as? [[String: Any?]] else {
      print("error")
      assertionFailure()
      return
    }
    var data = [[String: Any?]]()
    fileData.forEach {
      var urlItem = [String: Any?]()
      urlItem["web_title"] = $0["web_title"]
      urlItem["rawurl"] = $0["rawurl"]
      urlItem["preserveDate"] = $0["preserveDate"]
      data.append(urlItem)
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
