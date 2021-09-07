//
//  LoginViewController.swift
//  FoodVoucher
//
//  Created by 임명심 on 2021/09/05.
//

import UIKit
import Firebase

class LoginVC: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwdTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwdTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                guard let strongSelf = self else { return }
                if let e = error {
                    print(e)
                    let alert = UIAlertController(title: nil, message: "로그인에 실패했습니다", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    strongSelf.present(alert, animated: false)
                } else {
                    print("로그인 성공")
                    guard let vc = self?.storyboard?.instantiateViewController(withIdentifier: "_tapBar") else {
                        return
                    }
                    self?.present(vc, animated: true, completion: nil)
                }
            }
        }
    }
    
}
