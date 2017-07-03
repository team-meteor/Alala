//
//  PostEditorViewController.swift
//  Alala
//
//  Created by junwoo on 2017. 6. 16..
//  Copyright © 2017년 team-meteor. All rights reserved.
//

import UIKit
import Photos

class PostEditorViewController: UIViewController {

  //캡쳐사진
  fileprivate let image: UIImage
  fileprivate var message: String?
  //비디오촬영
  var videoData = Data()
  var urlAssetArr = [AVURLAsset]()
  var imageArr = [UIImage]()
  var multipartsIdArr = [String]()

  fileprivate let tableView = UITableView().then {
    $0.isScrollEnabled = false
    $0.register(PostEditingCell.self, forCellReuseIdentifier: "postEditingCell")
  }

  init(image: UIImage) {
    self.image = image
    super.init(nibName: nil, bundle: nil)
    self.view.backgroundColor = UIColor.yellow
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(shareButtonDidTap))
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func getMultipartsIdArr(completion: @escaping (_ idArr: [String]) -> Void) {
    //비디오 촬영인 경우
    if videoData.count != 0 {
      MultipartService.uploadMultipart(image: nil, videoData: videoData, progress: nil) { videoId in
        self.multipartsIdArr.append(videoId)
      }

    //멀티셀렉션인 경우
    } else if imageArr.count != 0 || urlAssetArr.count != 0 {
      if imageArr.count != 0 {
        print("imarr = \(imageArr)")
        for image in imageArr {
          MultipartService.uploadMultipart(image: image, videoData: nil, progress: nil) { imageId in
            self.multipartsIdArr.append(imageId)
          }
        }
      }
      if urlAssetArr.count != 0 {
        print("assetarr = \(urlAssetArr)")
        for asset in urlAssetArr {
          let videoUrl = asset.url
          var movieData: Data?
          do {
            movieData = try Data(contentsOf: videoUrl)
          } catch _ {
            movieData = nil
            return
          }
          MultipartService.uploadMultipart(image: nil, videoData: movieData, progress: nil) { movieId in
            self.multipartsIdArr.append(movieId)
          }
        }
      }
    //사진촬영인 경우
    } else {
      MultipartService.uploadMultipart(image: self.image, videoData: nil, progress: nil) { imageId in
        self.multipartsIdArr.append(imageId)
      }
    }
    completion(multipartsIdArr)
  }

  func shareButtonDidTap() {
    print("ima = \(image)")
    print("assetarr = \(urlAssetArr)")
    print("video = \(videoData)")
    print("imarr = \(imageArr)")
    getMultipartsIdArr { idArr in
      //메시지와 함께 포스팅
      print("arr = \(idArr)")
      PostService.postWithSingleMultipart(idArr: idArr, message: self.message, progress: nil) { [weak self] response in
        guard let `self` = self else { return }
        switch response.result {
        case .success(let post):
          print("업로드 성공 = \(post)")
          self.dismiss(animated: true, completion: nil)
        case .failure(let error):
          print(error)
        }
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.tableView.dataSource = self
    self.tableView.delegate = self

    self.view.addSubview(self.tableView)
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.tableView.snp.makeConstraints { make in
      make.edges.equalTo(self.view)
    }

  }

  override func didMove(toParentViewController parent: UIViewController?) {
    if parent == nil {
      NotificationCenter.default.post(name: Notification.Name("cameraStart"), object: nil)
    }
  }

}

extension PostEditorViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "postEditingCell", for: indexPath) as! PostEditingCell
    cell.imageConfigure(image: self.image)
    cell.textDidChange = { [weak self] message in
      guard let `self` = self else { return }
      self.message = message
      self.tableView.beginUpdates()
      self.tableView.endUpdates()
      self.tableView.scrollToRow(at: indexPath, at: .none, animated: false)
    }
    return cell
  }
}

extension PostEditorViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.row == 0 { return 100 }
    return 0
  }

}
