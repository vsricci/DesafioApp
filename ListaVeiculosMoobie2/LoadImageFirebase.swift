//
//  LoadImageFirebase.swift
//  ListaVeiculosMoobie2
//
//  Created by Joel Sene on 24/08/17.
//  Copyright © 2017 Vinicius Santos Ricci. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()


extension  UIImageView {

    func loadImageUsingCacheWithString(urlString: String){
        
        self.image = nil
        //checando o cache para a imagem
        
        if let cacheImage = imageCache.object(forKey: urlString as AnyObject){
            self.image = cacheImage as! UIImage
            return
        }
        
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!) {data,response,error in
            
            if (error != nil){
                print(error)
                return
            }
            DispatchQueue.main.async {
                
                if let downloadImage = UIImage(data: data!){
                    
                    imageCache.setObject(downloadImage, forKey: urlString as AnyObject)
                    self.image = downloadImage
                    
                    
                    
                }
                
            }
            
            }.resume()
    }


}
