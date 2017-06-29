//
//  ImageService.swift
//  Alala
//
//  Created by hoemoon on 19/06/2017.
//  Copyright © 2017 team-meteor. All rights reserved.
//

import UIKit
import Alamofire

struct ImageService {
  static func uploadImage(image: UIImage, progress: Progress?, completion: @escaping (_ imageId: String) -> Void) {
    let headers = [
      "Content-Type": "multipart/form-data; charset=utf-8; boundary=__X_PAW_BOUNDARY__"
      ]
    Alamofire.upload(multipartFormData: { multipartFormData in
      let imageData = UIImageJPEGRepresentation(image, 0.6)!
      multipartFormData.append(imageData, withName: "multipart", fileName: "\(UUID().uuidString).jpg", mimeType: "image/jpg")
    }, to: Constants.BASE_URL + "/multipart", method: .post, headers: headers, encodingCompletion: { result in
      switch result {
      case .success(let upload, _, _):
        upload.responseJSON { response in
          switch response.result {
          case .success(let multipartId):
            completion(String(describing: multipartId))
          case .failure(let error):
            print(error)
          }
        }
      case .failure(let encodingError):
        print(encodingError)
      }
    })
  }
}
