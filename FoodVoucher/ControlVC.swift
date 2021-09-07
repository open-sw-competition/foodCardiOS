//
//  ControlVC.swift
//  FoodVoucher
//
//  Created by 임명심 on 2021/09/06.
//

import UIKit

class ControlVC: UIViewController {
    private let slider = UISlider()
    
    private let star1 = UIImageView()
    private let star2 = UIImageView()
    private let star3 = UIImageView()
    private let star4 = UIImageView()
    private let star5 = UIImageView()
    
    // 0.5 단위로
    var sliderValue: Float {
        if slider.value - Float(Int(slider.value)) >= 0.5 {
            return Float(Int(slider.value)) + 0.5
        } else {
            return Float(Int(slider.value))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        slider.minimumValue = 0
        slider.maximumValue = 5
        slider.frame = CGRect(x: 0, y: 0, width: 170, height: 30)
        self.view.addSubview(slider)
        
        star1.image = UIImage(named: "starEmpty")
        star1.frame = CGRect(x: 0, y: 0, width: 33, height: 30)
        star1.tag = 1
        self.view.addSubview(star1)
        
        star2.image = UIImage(named: "starEmpty")
        star2.frame = CGRect(x: 34, y: 0, width: 33, height: 30)
        star2.tag = 2
        self.view.addSubview(star2)

        star3.image = UIImage(named: "starEmpty")
        star3.frame = CGRect(x: 68, y: 0, width: 33, height: 30)
        star3.tag = 3
        self.view.addSubview(star3)

        star4.image = UIImage(named: "starEmpty")
        star4.frame = CGRect(x: 102, y: 0, width: 33, height: 30)
        star4.tag = 4
        self.view.addSubview(star4)

        star5.image = UIImage(named: "starEmpty")
        star5.frame = CGRect(x: 136, y: 0, width: 33, height: 30)
        star5.tag = 5
        self.view.addSubview(star5)
        
        self.preferredContentSize = CGSize(width: slider.frame.width, height: slider.frame.height + 10)
        
        slider.addTarget(self, action: #selector(onChangeValue(_:)), for: .valueChanged)
        
        // 슬라이더 안보이게 처리하기
        self.slider.minimumTrackTintColor = .clear
        self.slider.maximumTrackTintColor = .clear
        self.slider.thumbTintColor = .clear
    }
    
    @objc func onChangeValue(_ sender: UISlider) {
        let floatVlaue = floor(sender.value * 10) / 10
        
        for index in 1...5 {
            if let starImage = view.viewWithTag(index) as? UIImageView {
                if Float(index) <= floatVlaue {
                    starImage.image = UIImage(named: "starFull")
                } else if (Float(index)-floatVlaue) <= 0.5 {
                    starImage.image = UIImage(named: "starHalf")
                } else {
                    starImage.image = UIImage(named: "starEmpty")
                }
            }
        }
    }
}
