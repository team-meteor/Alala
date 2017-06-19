//
//  CameraViewController.swift
//  Alala
//
//  Created by junwoo on 2017. 6. 18..
//  Copyright © 2017년 team-meteor. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class CameraViewController: UIViewController {
	
	private let camView = UIView().then {
		$0.backgroundColor = UIColor.black
	}
	private let scrollView = UIScrollView().then {
		$0.backgroundColor = UIColor.yellow
		$0.isPagingEnabled = true
		$0.bounces = false
	}
	
	private let bottomView = UIView().then {
		$0.backgroundColor = UIColor.green
	}
	
	private let takePhotoButton = UIButton().then {
		$0.backgroundColor = UIColor.red
		$0.layer.cornerRadius = 30
		$0.addTarget(self, action: #selector(takePhotoButtonDidTap), for: .touchUpInside)
	}
	
	private let takeVideoButton = UIButton().then {
		$0.backgroundColor = UIColor.red
		$0.layer.cornerRadius = 30
		$0.addTarget(self, action: #selector(takeVideoButtonDidTap), for: .touchUpInside)
	}
	
	init() {
		super.init(nibName: nil, bundle: nil)
		
		self.checkCameraAuthorization { authorized in
			if authorized {
				// Proceed to set up and use the camera.
			} else {
				print("Permission to use camera denied.")
			}
		}
	
		//cancle 버튼 생성
		self.navigationItem.leftBarButtonItem = UIBarButtonItem(
			barButtonSystemItem: .cancel,
			target: self,
			action: #selector(cancelButtonDidTap)
		)
		
		//done 버튼 생성
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(
			barButtonSystemItem: .done,
			target: self,
			action: #selector(doneButtonDidTap)
		)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func cancelButtonDidTap() {
		self.dismiss(animated: true, completion: nil)
	}
	
	func doneButtonDidTap() {
		
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.scrollView.delegate = self
		self.title = "Photo"
		NotificationCenter.default.addObserver(self, selector: #selector(photoModeSetting), name: Notification.Name("photoMode"), object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(videoModeSetting), name: Notification.Name("videoMode"), object: nil)
		self.bottomView.addSubview(takePhotoButton)
		self.bottomView.addSubview(takeVideoButton)
		self.scrollView.addSubview(bottomView)
		self.view.addSubview(camView)
		self.view.addSubview(scrollView)
		
		self.camView.snp.makeConstraints { make in
			make.left.right.equalTo(self.view)
			make.bottom.equalTo(self.scrollView.snp.top)
			make.height.equalTo(self.camView.snp.width)
		}
		
		self.scrollView.snp.makeConstraints { make in
			make.left.right.equalTo(self.view)
		}
		
		self.scrollView.snp.makeConstraints { make in
			make.height.equalTo(667 - 44 - 375 - 50)
		}
		
		self.bottomView.snp.makeConstraints { make in
			make.width.equalTo(self.view.bounds.width * 2)
			make.height.equalTo(self.scrollView.snp.height)
			make.centerY.equalTo(self.scrollView.snp.centerY)
			make.centerX.equalTo(self.view.bounds.width)
		}
		
		self.takePhotoButton.snp.makeConstraints { make in
			make.center.equalTo(self.scrollView.snp.center)
			make.height.width.equalTo(60)
		}
		
		self.takeVideoButton.snp.makeConstraints { make in
			make.centerX.equalTo(self.view.frame.width * 3/2)
			make.centerY.equalTo(self.scrollView.snp.centerY)
			make.width.height.equalTo(60)
		}
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		self.camView.snp.makeConstraints { make in
			make.top.equalTo((self.navigationController?.navigationBar.snp.bottom)!)
		}
		
		DispatchQueue.main.async {
			self.scrollView.contentSize = self.bottomView.bounds.size
		}
	}
	
	func takePhotoButtonDidTap() {
		
	}
	
	func takeVideoButtonDidTap() {
		
	}
	
	func photoModeSetting() {
		
		self.title = "Photo"
		let page = Int(scrollView.contentOffset.x / scrollView.bounds.size.width)
		if page != 0 {
			UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {
				self.scrollView.contentOffset.x = 0}, completion: nil)
		}
		
	}
	
	func videoModeSetting() {
		self.title = "Video"
		let page = Int(scrollView.contentOffset.x / scrollView.bounds.size.width)
		if page != 1 {
			UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {
				self.scrollView.contentOffset.x = self.scrollView.bounds.size.width}, completion: nil)
		}
		
	}
	
	func checkCameraAuthorization(_ completionHandler: @escaping ((_ authorized: Bool) -> Void)) {
		switch AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) {
		case .authorized:
			//The user has previously granted access to the camera.
			completionHandler(true)
			
		case .notDetermined:
			// The user has not yet been presented with the option to grant video access so request access.
			AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { success in
				completionHandler(success)
			})
			
		case .denied:
			// The user has previously denied access.
			completionHandler(false)
			
		case .restricted:
			// The user doesn't have the authority to request access e.g. parental restriction.
			completionHandler(false)
		}
	}
	
}

extension CameraViewController: UIScrollViewDelegate {
	func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		let page = Int(scrollView.contentOffset.x / scrollView.bounds.size.width)
		if page == 0 {
			photoModeSetting()
			NotificationCenter.default.post(name: Notification.Name("photoModeOnTabBar"), object: nil)
		} else if page == 1 {
			videoModeSetting()
			NotificationCenter.default.post(name: Notification.Name("videoModeOnTabBar"), object: nil)
		}
	}
}