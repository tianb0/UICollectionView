//
//  ImageStore.swift
//  UICollectionView
//
//  Created by Tianbo Qiu on 12/30/22.
//

import UIKit

class ImageStore {
    
    let cache = NSCache<NSString, UIImage>()
    
    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
        
        let url = imageURL(forKey: key)
        if let data = image.jpegData(compressionQuality: 0.5) {
            try? data.write(to: url)
        }
    }
    
    func image(forKey key: String) -> UIImage? {
        // return from in-memory cache
        if let image = cache.object(forKey: key as NSString) {
            return image
        }
        
        // read from file
        let url = imageURL(forKey: key)
        guard let image = UIImage(contentsOfFile: url.path) else {
            return nil
        }
        cache.setObject(image, forKey: key as NSString)
        return image
    }
    
    func deleteImage(forKey key: String) {
        cache.removeObject(forKey: key as NSString)
        
        let url = imageURL(forKey: key)
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            print("Error removing the image from disk: \(error)")
        }
    }
    
    
    func imageURL(forKey key: String) -> URL {
        let dirs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let dir = dirs.first!
        return dir.appending(path: key)
    }
    
}
