//
//  SettingVC.swift
//  FoodVoucher
//
//  Created by 임명심 on 2021/09/05.
//

import UIKit
import Firebase

class SettingVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let sectionHeader = ["계정 관리", "앱 정보", "고객 지원"]
    let cellDataSource = [["로그아웃", "회원탈퇴"], ["앱 버전"], ["저작권 정보"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Section
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionHeader.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeader[section]
    }
    
    //MARK: - Row cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellDataSource[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell") {
            cell.textLabel?.text = cellDataSource[indexPath.section][indexPath.row]
            cell.textLabel?.font = UIFont.systemFont(ofSize: 17)
            if indexPath.section == 1 && indexPath.row == 0 {
                cell.detailTextLabel?.text = "v1.0.0"
            } else {
                cell.detailTextLabel?.text = ""
                cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
            }
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            do {
                try Auth.auth().signOut()
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "_root") else {
                    return
                }
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: false, completion: nil)
                
            } catch let signOutError as NSError {
                print("Error signing out: %@", signOutError)
            }
        } else if indexPath.section == 0 && indexPath.row == 1 {
            let alert = UIAlertController(title: "회원 탈퇴", message: "탈퇴하시겠습니까?", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            let ok = UIAlertAction(title: "확인", style: .default) { _ in
                
                let user = Auth.auth().currentUser
                user?.delete(completion: { error in
                    if let e = error {
                        print("회원 탈퇴 에러: \(e)")
                    } else {
                        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "_root") else {
                            return
                        }
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: false, completion: nil)
                    }
                })
                
            }
            alert.addAction(cancel)
            alert.addAction(ok)
            self.present(alert, animated: false)
            
        } else if indexPath.section == 2 && indexPath.row == 0 {
            // 저작권 정보
        }
    }
}
