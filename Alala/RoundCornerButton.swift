//
//  RoundCornerButton.swift
//  Alala
//
//  Created by Ellie Kwon on 2017. 7. 1..
//  Copyright © 2017 team-meteor. All rights reserved.
//

import UIKit

/**
 * 모서리가 둥글게 라운딩 된 커스텀 버튼
 *
 * - 사용처 : 프로필 정보 화면, 팔로우/팔로잉 화면 등
 * - 버튼 컬러 타입
 * 1. buttonColorTypeWhite : backgroundColor white, titleColor black
 * 2. buttonColorTypeBlue  : backgroundColor blue,  titleColor white
 */
class RoundCornerButton: UIButton {

  enum ButtonColorType: Int {
    case buttonColorTypeWhite  = 0
    case buttonColorTypeBlue   = 1
  }

  var nomalBorderColor: UIColor!
  var highlightBorderColor: UIColor!

  var nomalBackgroundColor: UIColor!
  var highlightBackgroundColor: UIColor!

  override init(frame: CGRect) {
    super.init(frame: frame)

    setupWhiteType()
    setupCommon()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  required init(_ type: ButtonColorType) {
    super.init(frame: .zero)

    setButtonType(type)
  }

  func setupCommon() {
    self.backgroundColor = nomalBackgroundColor

    self.layer.borderColor = nomalBorderColor.cgColor
    self.layer.cornerRadius = 3
    self.layer.borderWidth = 1

    self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
  }

  func setupWhiteType() {
    self.setTitleColor(UIColor.black, for: .normal)

    nomalBorderColor = UIColor(rgb: 0xdddddd)
    nomalBackgroundColor = UIColor.white

    highlightBorderColor = UIColor(rgb: 0xeeeeee)
    highlightBackgroundColor = UIColor.white
  }

  func setupBlueType() {
    self.setTitleColor(UIColor.white, for: .normal)

    nomalBorderColor = UIColor(rgb: 0x3E99ED)
    nomalBackgroundColor = UIColor(rgb: 0x3E99ED)

    highlightBorderColor = UIColor(rgb: 0x3EB7ED)
    highlightBackgroundColor = UIColor(rgb: 0x3EB7ED)
  }

  func setButtonType(_ type: ButtonColorType) {
    switch type {
    case .buttonColorTypeWhite:
      setupWhiteType()
    case .buttonColorTypeBlue:
      setupBlueType()
    }

    setupCommon()
  }

  override var isHighlighted: Bool {
    didSet {
      switch isHighlighted {
      case true:
        layer.borderColor = highlightBorderColor.cgColor
        self.backgroundColor = highlightBackgroundColor
      case false:
        layer.borderColor = nomalBorderColor.cgColor
        self.backgroundColor = nomalBackgroundColor
      }
    }
  }
}
