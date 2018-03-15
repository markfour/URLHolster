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
  
  fileprivate let urlItemContiner = URLItemContainer()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.register(UINib(nibName: "ItemTableViewCell", bundle: nil), forCellReuseIdentifier: "item")
    tableView.rowHeight = 60
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(self.enteredForeground(_:)),
                                           name: NSNotification.Name.UIApplicationWillEnterForeground,
                                           object: nil)
    reloadURLItems()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    
    NotificationCenter.default.removeObserver(self)
  }
  
  @objc func enteredForeground(_ notification: Notification?) {
    if (self.isViewLoaded && (self.view.window != nil)) {
      reloadURLItems()
    }
  }
  
  private func getURL() {
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
        _urlItems.sort{$0.preserveDate > $1.preserveDate}
        _urlItems.forEach {
          self.urlItemContiner.addUrlItems(urlItem: $0)
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
  
  private func initizalieURLItems() {
    Dummy.initializeData()
    reloadURLItems()
  }
  
  private func reloadURLItems() {
    urlItemContiner.initializeUrlItems()
    
    if Dummy.enable() {
      let urlItems = Dummy.fetch().sorted{$0.preserveDate > $1.preserveDate}
      urlItems.forEach {
        self.urlItemContiner.addUrlItems(urlItem: $0)
      }
      tableView.reloadData()
    } else {
      getURL()
    }
  }
  
  @IBAction func refreshButtonAction(_ sender: UIBarButtonItem) {
    initizalieURLItems()
  }
}

extension RootViewController: UITableViewDelegate {
  func numberOfSections(in tableView: UITableView) -> Int {
    return urlItemContiner.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return urlItemContiner.sectionCount(section: section)
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if urlItemContiner.sectionCount(section: section) == 0 {
      return nil
    }

    switch section {
    case 0:
      return "今日"
    case 1:
      return "昨日"
    case 2:
      return "今週"
    case 3:
      return "2週間以上前"
    default:
      return nil
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "item") as! ItemTableViewCell
    let item = urlItemContiner.urlItem(section: indexPath.section, row: indexPath.row)
    
    cell.title = item.title
    cell.url = item.url.absoluteString
    return cell
  }
}

extension RootViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let item = urlItemContiner.urlItem(section: indexPath.section, row: indexPath.row)
    
    UIApplication.shared.open(item.url, options: [:], completionHandler: nil)
  }
}
