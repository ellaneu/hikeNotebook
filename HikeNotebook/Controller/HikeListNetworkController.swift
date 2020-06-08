//
//  HikeListNetworkController.swift
//  HikeNotebook
//
//  Created by Ella  Neumarker on 5/5/20.
//  Copyright © 2020 Ella Neumarker. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class HikeListNetworkController {
    
    func fetchItems(location: CLLocationCoordinate2D, completion: @escaping ([HikeListItem]?) -> Void) {
        let baseUrl = URL(string: "https://www.hikingproject.com/data/get-trails?lat=\(location.latitude)&lon=\(location.longitude)&key=200727312-558845191b8586dd2d6c5c7f1ac73fab")
        
        guard let url = baseUrl else {
            completion(nil)
            print("Unable to build URL with supplied queries.")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            let decoder = JSONDecoder()
            if let data = data,
                let hikeList = try? decoder.decode(HikeList.self, from: data) {
                completion(hikeList.trails)
            } else {
                print("Either no data was returned, or data was not serialized.")
                completion(nil)
                return
            }
        }
        task.resume()
    }
    
    
    
    
    
}
