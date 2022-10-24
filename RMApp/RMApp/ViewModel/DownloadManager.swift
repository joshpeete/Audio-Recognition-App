//
//  DownloadManager.swift
//  RMApp
//
//  Created by Vaishnavi Nannur on 10/21/22.
//

import Foundation
import FirebaseStorage

class DownloadManager {
    static let instance = DownloadManager()
    
    private init() { }
    
    var cachedFiles: [String: Data] = [:]
    
    func download(filePath: String, completion: @escaping (Data?, Error?) -> Void) {
        if let cached = cachedFiles[filePath] {
            completion(cached, nil)
            return
        }
        
        let ref = Storage.storage().reference(withPath: filePath)
        ref.getData(maxSize: 1024 * 1024 * 100) { data, error in
            DispatchQueue.main.async {
                if let data = data {
                    self.cachedFiles[filePath] = data
                }
                
                completion(data, error)
            }
        }
    }
}
