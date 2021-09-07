//
//  SignupViewController.swift
//  FoodVoucher
//
//  Created by 임명심 on 2021/09/03.
//

import UIKit
import Firebase

class SignupVC: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwdTextField: UITextField!
    
    @IBAction func signupPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let passwd = passwdTextField.text {
            Auth.auth().createUser(withEmail: email, password: passwd) { authResult, error in
                if let e = error {
                    print(e)
                    let alert = UIAlertController(title: nil, message: "회원가입에 실패했습니다", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: false)
                } else {
                    print("회원가입완료")
                    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "_tapBar") else {
                        return
                    }
                    self.present(vc, animated: true, completion: nil)
                }
            }
        }
    }
}
