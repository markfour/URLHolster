//
//  ItemTableViewCell.swift
//  URLHolster
//
//  Created by kazumi hayashida on 2018/03/02.
//  Copyright © 2018年 kazumi hayashida. All rights reserved.
//

import Foundation
import UIKit

class ItemTableViewCell: UITableViewCell {
  @IBOutlet private weak var titleLabel: UILabel!
  @IBOutlet private weak var urlLabel: UILabel!
  
  public var title: String? {
    get {
      return self.title
    }
    set {
      self.title = newValue
      self.titleLabel.text = self.title
    }
  }
  
  public var url: String? {
    get {
      return self.title
    }
    set {
      self.url = newValue
      self.urlLabel.text = self.url
    }
  }
}
