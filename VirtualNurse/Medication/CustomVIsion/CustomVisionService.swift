//
//  CustomVisionService.swift
//  mediTrack
//
//  Created by SURA's MacBookAir on 3/1/18.
//  Copyright © 2018 SURA's MacBookAir. All rights reserved.
//

import Foundation
class CustomVisionService{
    
//var preductionUrl = "https://southcentralus.api.cognitive.microsoft.com/customvision/v1.1/Prediction/9e39ab45-846f-4389-aa3a-b9042b289f2f/image?iterationId=1b3f2e0c-593c-4e8c-b28b-dc586302090f"
    var preductionUrl = "https://southcentralus.api.cognitive.microsoft.com/customvision/v1.1/Prediction/9e39ab45-846f-4389-aa3a-b9042b289f2f/image"
    
var predictionKey = "6074b2b8ea7a447f8199182e49f9c3a0"
var contentType = "application/octet-stream"

var defaultSession = URLSession(configuration: .default)
var dataTask: URLSessionDataTask?

func predict(image: Data, completion: @escaping (CustomVisionResult?, Error?) -> Void) {
    
    // Create URL Request
    var urlRequest = URLRequest(url: URL(string: preductionUrl)!)
    urlRequest.addValue(predictionKey, forHTTPHeaderField: "Prediction-Key")
    urlRequest.addValue(contentType, forHTTPHeaderField: "Content-Type")
    urlRequest.httpMethod = "POST"
    
    // Cancel existing dataTask if active
    dataTask?.cancel()
    
    // Create new dataTask to upload image
    dataTask = defaultSession.uploadTask(with: urlRequest, from: image) { data, response, error in
        defer { self.dataTask = nil }
        
        if let error = error {
            completion(nil, error)
        } else if let data = data,
            let response = response as? HTTPURLResponse,
            response.statusCode == 200 {
            
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                let result = try? CustomVisionResult(json: json!) {
                completion(result, nil)
            }
        }
    }
    
    // Start the new dataTask
    dataTask?.resume()
}
}


