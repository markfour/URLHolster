//
//  ShareViewController.swift
//  Share
//
//  Created by kazumi hayashida on 2017/04/12.
//  Copyright © 2017年 kazumi hayashida. All rights reserved.
//

import UIKit
import Social

class ShareViewController: SLComposeServiceViewController {

    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

    override func didSelectPost() {
      let extensionItem: NSExtensionItem = self.extensionContext?.inputItems.first as! NSExtensionItem
      let itemProvider = extensionItem.attachments?.first as! NSItemProvider
      
      let puclicURL = "public.url"
      
      // shareExtension で NSURL を取得
      if itemProvider.hasItemConformingToTypeIdentifier(puclicURL) {
        itemProvider.loadItem(forTypeIdentifier: puclicURL, options: nil, completionHandler: { (item, error) in
          // NSURLを取得する
          if let url: NSURL = item as? NSURL {
            // ----------
            // 保存処理
            // ----------
            print("URL \(url)")
            // TODO ここで URL と時間を Postする
          }
          self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
        })
      }
      
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
//        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
        print("contentText \(contentText)")
      
    }

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }

}
