//
//  StorageDataSource.swift
//  StorageDataSource
//
//  Created by 황신택 on 2021/08/10.
//

import Foundation
import UIKit

enum StorageType {
    case userDefaults
    case fileSystem
}

class StorageDataSource {
    static let shard = StorageDataSource()
    private init() { }
    
    private func store(image: UIImage, forkey key: String, withStorageType storageType: StorageType) {
        if let pngRepresentation = image.pngData() {
            switch storageType {
            case .userDefaults:
                UserDefaults.standard.set(pngRepresentation, forKey: key)
            case .fileSystem:
                if let filePath = filePath(forKey: key) {
                    do {
                        try pngRepresentation.write(to: filePath, options: .atomic)
                    } catch {
                        print(error)
                    }
                }
                
            }
        }
    }
    
    
    private func retriveImage(forkey key: String, withStorageType storageType: StorageType) -> UIImage? {
        switch storageType {
        case .userDefaults:
            if let imageData = UserDefaults.standard.object(forKey: key) as? Data {
                let image = UIImage(data: imageData)
                
                return image
            }
        case .fileSystem:
            if let filePath = filePath(forKey: key),
               let fileData = FileManager.default.contents(atPath: filePath.path),
               let image = UIImage(data: fileData) {
                return image
            }
        }
        
        return nil
    }
    
    
    private func filePath(forKey key: String) -> URL? {
        let fileManager = FileManager.default
        guard let documentURL = fileManager.urls(for: .documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first else { return nil}
        
        return documentURL.appendingPathComponent(key + ".png")
    }
    
    func save(image: UIImage) {
        DispatchQueue.global().async {
            self.store(image: image, forkey: "profileKey", withStorageType: .fileSystem)
        }
    }
    
    func display(with model: UIImageView) {
        DispatchQueue.global(qos: .background).async {
            if let savedImage = self.retriveImage(forkey: "profileKey",
                                                  withStorageType: .fileSystem) {
                
                DispatchQueue.main.async {
                    model.image = savedImage
                }
                
            }
        }
    }
    
}



