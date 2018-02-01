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
  
  // TODO ArrayよりSetのほうがいいか?
  fileprivate var urlItems = [[URLItem]]()
  
  override func viewDidLoad() {
    for _ in 0..<4 {
      urlItems.append([URLItem]())
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    print("viewWillAppear")
    
    urlItems.removeAll()
    
    for _ in 0..<4 {
      urlItems.append([URLItem]())
    }
    
    getURL()
  }
  
  func getURL() {
    let url = URL(string: "http://localhost:3000/urlitems.json")
    let task = URLSession.shared.dataTask(with: url!) { (data, respons, error) in
      guard let data = data else { return }
      
      do {
        let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
        var _urlItems: [URLItem] = []
        guard let array = json as? NSArray else { return }
        array.forEach {
          _urlItems.append(URLItem(dict: $0 as! [String: Any]))
        }
        _urlItems.sort {$0.preserveDate > $1.preserveDate}
        _urlItems.forEach {
          print($0.preserveDate)
          let calendar = Calendar(identifier: .japanese)
          if calendar.isDateInToday($0.preserveDate) {
            self.urlItems[0].append($0)
          } else if calendar.isDateInYesterday($0.preserveDate) {
            self.urlItems[1].append($0)
          } else if calendar.isDateInWeekend($0.preserveDate) {
            self.urlItems[2].append($0)
          } else {
            self.urlItems[3].append($0)
          }
        }
        
        DispatchQueue.main.async {
          self.tableView.reloadData()
        }
        
      } catch {
        print("json parse error")
      }
    }
    task.resume()
  }
  
  @IBAction func refreshButtonAction(_ sender: UIBarButtonItem) {
    
  }
}

extension RootViewController: UITableViewDelegate {
  func numberOfSections(in tableView: UITableView) -> Int {
    return urlItems.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return urlItems[section].count
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch section {
    case 0:
      return "今日"
    case 1:
      return "昨日"
    case 2:
      return "今週"
    case 3:
      return "それ以前"
    default:
      return nil
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "")
    let item = urlItems[indexPath.section][indexPath.row]
    
    cell.textLabel?.text = item.title
    cell.detailTextLabel?.text = item.url.absoluteString
    cell.detailTextLabel?.textColor = UIColor.gray
    return cell
  }
  
  
}

extension RootViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let item = urlItems[indexPath.section][indexPath.row]
    
    UIApplication.shared.open(item.url, options: [:], completionHandler: nil)
  }
}
