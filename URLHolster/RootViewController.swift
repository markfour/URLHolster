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
  
  fileprivate var urlItems: [URLItem] = []
  
  override func viewDidLoad() {
    
    let i1 = URLItem(title: "google", URL: URL(string: "https://www.google.co.jp/")!)
    urlItems.append(i1)
    let i2 = URLItem(title: "apple", URL: URL(string: "https://www.apple.com/jp")!)
    urlItems.append(i2)
    
    getURL()
  }
  
  func getURL() {
    let url = URL(string: "http://localhost:3000/urlitems.json")
    let task = URLSession.shared.dataTask(with: url!) { (data, respons, error) in
      guard let data = data else { return }
      
      do {
        let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
        guard let array = json as? NSArray else { return }
        array.forEach {
          self.urlItems.append(URLItem(dict: $0 as! [String: Any]))
        }
//        self.urlItems.sort(by: $0.)
        
        DispatchQueue.main.async {
          self.tableView.reloadData()
        }

      } catch {
        print("json parse error")
      }
    }
    task.resume()
  }
}

extension RootViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return urlItems.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "")
    let item = urlItems[indexPath.row]
    
    cell.textLabel?.text = item.title
    cell.detailTextLabel?.text = item.url.absoluteString
    
    return cell
  }
}

extension RootViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let item = urlItems[indexPath.row]
    
    UIApplication.shared.open(item.url, options: [:], completionHandler: nil)
  }
}
