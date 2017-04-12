//
//  RootViewController.swift
//  URLHolster
//
//  Created by kazumi hayashida on 2017/02/12.
//  Copyright © 2017年 kazumi hayashida. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
  
  let host = "localhost"
  
  @IBOutlet weak var tableView: UITableView!
  
  fileprivate var URLItems: [URLItem] = []
  
  override func viewDidLoad() {
    
    let i1 = URLItem(title: "google", URL: URL(string: "https://www.google.co.jp/")!)
    URLItems.append(i1)
    let i2 = URLItem(title: "apple", URL: URL(string: "https://www.apple.com/jp")!)
    URLItems.append(i2)
    
    getURL()
  }
  
  func getURL() {
    let url = URL(string: "http://localhost:3000/urlitems.json")
    let task = URLSession.shared.dataTask(with: url!) { (data, respons, error) in
      print(String(bytes: data!, encoding: .utf8))
    }
    task.resume()
  }
}

extension RootViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return URLItems.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "")
    let item = URLItems[indexPath.row]
    
    cell.textLabel?.text = item.title
    cell.detailTextLabel?.text = item.URL.absoluteString
    
    return cell
  }
}

extension RootViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let item = URLItems[indexPath.row]
    
    UIApplication.shared.open(item.URL, options: [:], completionHandler: nil)
  }
}
