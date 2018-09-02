//
//  Extensions.swift
//  gameofchats
//
//  Created by Brian Voong on 7/5/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit
import Firebase

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {

    func loadImageUsingCacheWithUrlString(_ urlString: String) {

        self.image = nil

        //check cache for image first
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }

        //otherwise fire off a new download
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, _, error) in

            //download hit an error so lets return out
            if error != nil {
                print(error!)
                return
            }

            DispatchQueue.main.async(execute: {

                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)

                    self.image = downloadedImage
                }
            })

        }).resume()
    }
}
