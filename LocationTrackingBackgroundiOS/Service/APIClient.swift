//
//  APIClient.swift
//  LocationTrackingBackgroundiOS
//
//  Created by Chathura Hettiarachchi on 2/5/18.
//  Copyright © 2018 Chathura Hettiarachchi. All rights reserved.
//

import Foundation
import Alamofire

class APIClient {
    
    func callUpdateLocation(completion: @escaping (Bool?) -> Void) {
        
        let params = [
            "UserKey":"1",
            "lat": "lat",
            "lang": "lang",
            "apikey":"SC:mobiletestbed:6d2cb442c55e2ebf"
        ]

        Alamofire.request(
            URL(string: "http://mobiletestbed.ivivacloud.com/OI/SmartFMAPI-2/UpdateUserGPSCoordinates")!,
            method: .post,
            parameters: params)
            .validate()
            .responseJSON { (response) -> Void in
                print("\n\n*** This is test api ***\n\n")
//                guard response.result.isSuccess else {
//                    print("Error while fetching remote rooms: \(String(describing: response.result.error))")
//                    completion(nil)
//                    return
//                }
//
//                completion(rooms)
        }
    }
    
}
