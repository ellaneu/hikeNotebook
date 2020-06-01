//
//  HikeListNetworkController.swift
//  HikeNotebook
//
//  Created by Ella  Neumarker on 5/5/20.
//  Copyright © 2020 Ella Neumarker. All rights reserved.
//

import Foundation
import UIKit

class HikeListNetworkController: HikeListController {
    let baseURL = URL(string: "https://www.hikingproject.com/data/get-trails-by-id?ids=7000108,7001726,7001623,7015185,7015350,7011064,7016979,7001585,7007940,7002256,7002254,7002257,7002685,7006813,7002269,7002420,7002658,7010494&key=200727312-558845191b8586dd2d6c5c7f1ac73fab")!
    let session = URLSession.shared
    
//    ,7002660,7023366,7027699,7031956,7005938,7089012,7034161,7043919,7003467,7031765,7030662
    
    
    func getHikeList(completion: @escaping (Result<HikeList, HikeListError>) -> Void) {
        let hikeListURL = baseURL
        
        let request = URLRequest(url: hikeListURL)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard error == nil else { return completion(.failure(.failed)) }
            
            
            print((response as? HTTPURLResponse)?.statusCode)
            print(data)
            if (response as? HTTPURLResponse)?.statusCode == 200,
                let data = data {
                let decoder = JSONDecoder()
                
                do {
                    let hikeList = try decoder.decode(HikeList.self, from: data)
                    
                    completion(.success(hikeList))
                } catch {
                    print(error)
                    completion(.failure(.failed))
                }
            } else {
                completion(.failure(.failed))
            }
        }
        task.resume()
    }
    
}
