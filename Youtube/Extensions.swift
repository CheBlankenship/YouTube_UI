//
//  Extensions.swift
//  Youtube
//
//  Created by Che Blankenship on 7/7/17.
//  Copyright © 2017 Che Blankenship. All rights reserved.
//

import UIKit


extension UIColor{
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}

extension UIView{
    func addConstraintsWithFormat(format: String, views: UIView...) {
        
        var viewsDictionary = [String: UIView]()
        for(index, view) in views.enumerated(){
            let key = "v\(index)"
            viewsDictionary[key] = view
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}


let imageCache = NSCache<AnyObject, AnyObject>()


extension UIImageView {
    
    func loadImageUsingUrlString(urlString: String) {
        let urldif = URL(string: urlString)
        let url = URLRequest(url: urldif!)
        
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            print("Cache Image : \(imageFromCache)")
            self.image = imageFromCache
            print("Image: \(String(describing: self.image!))")
            return
        }else{
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if error != nil {
                    print(error ?? "ERROR?")
                    return
                }
                // オリジナル
                // DispatchQueue.global.asyncを利用することで、url image の処理スピードを上げることができる。
                DispatchQueue.global().async {
                    DispatchQueue.main.sync {
                        let imageToCache = UIImage(data: data!)
                        imageCache.setObject(imageToCache!, forKey: urlString as AnyObject)
                        self.image = imageToCache
                    }
                }
                
            }).resume()
        }
        
    }
}
