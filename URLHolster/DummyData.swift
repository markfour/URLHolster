//
//  DummyData.swift
//  URLHolster
//
//  Copyright © 2018 kazumi hayashida. All rights reserved.
//

import Foundation

class DummyData {
  class func enableDummy() -> Bool {
    if let enableDummy = ProcessInfo.processInfo.environment["dummy_data"] {
      return enableDummy == "1"
    } else {
      return false
    }
  }
}
