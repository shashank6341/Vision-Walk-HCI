//
//  NetworkManager.swift
//  Vision Walk
//
//  Created by Shashank Verma on 2024-03-16.
//  Copyright © 2024 Shashank Verma. All rights reserved.
//

import Foundation
import Alamofire

func uploadImage(image: UIImage, completion: @escaping (String?, Error?) -> Void) {
  guard let imageData = image.jpegData(compressionQuality: 0.7) else {
    completion(nil, NSError(domain: "Image conversion failed", code: 1, userInfo: nil))
    return
  }

  let urlString = "http://your_server_ip:8089/caption" // Replace with your server address
  let parameters: [String: Any] = [:]

  AF.upload(multipartFormData: { multipartFormData in
    multipartFormData.append(imageData, withName: "image", fileName: "image.jpeg", mimeType: "image/jpeg")
  }, to: urlString, usingThreshold: UInt64.max, method: .post, parameters: parameters)
    .responseJSON { response in
      if let error = response.error {
        completion(nil, error)
        print("Error uploading image: \(error.localizedDescription)")
        return
      }

      guard let data = response.data else {
        completion(nil, NSError(domain: "Empty response", code: 2, userInfo: nil))
        print("Empty response received")
        return
      }

      do {
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        if let caption = json["caption"] as? String {
          completion(caption, nil)
          print("Caption received: \(caption)")
        } else {
          completion(nil, NSError(domain: "Invalid response format", code: 3, userInfo: nil))
          print("Invalid response format, caption missing")
        }
      } catch {
        completion(nil, error)
        print("Error parsing JSON response: \(error.localizedDescription)")
      }
  }
}

