//
//  UIImageViewExtensions.swift
//  iosconfsg2019
//
//  Created by Vina Melody on 9/1/19.
//  Copyright © 2019 Vina Melody. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func downloadImageFrom(urlString: String) {
        
        contentMode = .scaleAspectFit
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { () -> Void in
                self.image = image
            }
            }.resume()
    }
}
