//
//  DataResponse+MapResults.swift
//  Alala
//
//  Created by hoemoon on 14/06/2017.
//  Copyright © 2017 team-meteor. All rights reserved.
//

import Alamofire

//extension DataResponse {
//  
//  /// `Result`의 값을 가지고 만든 새로운 `Result`를 사용하는 `DataResponse`를 반환합니다.
//  func flatMap<T>(_ transform: (Value) -> Result<T>) -> DataResponse<T> {
//    let result: Result<T>
//    switch self.result {
//    case .success(let value):
//      result = transform(value)
//    case .failure(let error):
//      result = .failure(error)
//    }
//    return DataResponse<T>(
//      request: self.request,
//      response: self.response,
//      data: self.data,
//      result: result,
//      timeline: self.timeline
//    )
//  }
//}
