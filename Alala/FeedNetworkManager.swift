//
//  FeedNetworkManager.swift
//  Alala
//
//  Created by hoemoon on 24/06/2017.
//  Copyright © 2017 team-meteor. All rights reserved.
//

import Alamofire
import ObjectMapper

enum Paging {
  case refresh
  case next(String)
}

struct FeedNetworkManager: FeedNetworkService {
  let userDataManager = UserDataManager.shared
  func feed(userId: String? = nil, paging: Paging, completion: @escaping (DataResponse<Feed>) -> Void) {
    guard let token = userDataManager.authToken else { return }
    let headers = ["Authorization": "Bearer " + token]
    var body: [String: Any]
    var url = ""

    switch paging {
    case .refresh:
      body = ["page": "1"]
    case .next(let nextpage):
      body = ["page": nextpage]
    }

    if userId != nil {
      url = "post/user"
      body.updateValue(userId!, forKey: "id")
    } else {
      url = "post/feed"
    }

    Alamofire.request(Constants.BASE_URL + url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers)
      .validate(statusCode: 200..<300)
      .responseJSON { (response) in
        if let feed = Mapper<Feed>().map(JSONObject: response.result.value) {
          let response = DataResponse(request: response.request, response: response.response, data: response.data, result: Result.success(feed))
          completion(response)
        }
    }
  }
}
