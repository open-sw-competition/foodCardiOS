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
        var content = ""
        if let path = Bundle.main.path(forResource: "script", ofType: "js") {
            do {
                content = try String(contentsOfFile: path)
            } catch {
                print("error")
            }
        }
        
        // 자바스크립트 웹뷰에서 실행시키기
        let webConfiguration = WKWebViewConfiguration()
        let userScript = WKUserScript(source: content, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let contentController = WKUserContentController()
        contentController.addUserScript(userScript)
        webConfiguration.userContentController = contentController
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
