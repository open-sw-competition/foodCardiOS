//
//  BalanceVC.swift
//  FoodVoucher
//
//  Created by 임명심 on 2021/09/05.
//

import UIKit
import WebKit

class BalanceVC: UIViewController, WKUIDelegate {
    
    //@IBOutlet weak var webView: WKWebView!
    
    var webView: WKWebView!
        
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = URL(string: "https://www.purmeecard.com/public.do?request=cardSelectForm") {
            let req = URLRequest(url: url)
            webView.load(req)
        }
    }
}
