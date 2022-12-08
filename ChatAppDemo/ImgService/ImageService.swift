//
//  ImageService.swift
//  ChatAppDemo
//
//  Created by BeeTech on 08/12/2022.
//

import Foundation
import UIKit
open class ImageService: NSObject {
    static var share = ImageService()
    private  var cache = NSCache<NSString, UIImage>()
    func fetchImage(with url: String, completion: @escaping (UIImage?) -> Void) {
        let keyCache = NSString(string: url)
        if let image = cache.object(forKey: keyCache)  {
            completion(image)
            return
        }
        guard let url = URL(string: url) else {
            completion(nil)
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if error != nil {
                completion(nil)
                print("vuongdv", error!.localizedDescription)
            }else {
                DispatchQueue.main.async {
                    guard let data = data else { return }
                    guard let image = UIImage(data: data) else {
                        completion(nil)
                        return
                    }
                    self.cache.setObject(image, forKey: keyCache)
                    completion(image)
                }
            }
        }
        task.resume()
    }
}
