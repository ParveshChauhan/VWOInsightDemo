//
//  BrowserViewController.swift
//  VWO Insights Demo
//
//  Created by Parvesh Chauhan on 24/05/24.
//

import UIKit
import WebKit

class BrowserViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var loaderIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var humburgerAction: UINavigationItem!
    
    
    @IBAction func humbergerClickAction(_ sender: Any) {
        self.slideMenuController()?.openLeft()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        self.loaderIndicator.isHidden = false
        webView.navigationDelegate = self
        refreshNavigationControls()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textField.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text, let url = URL.httpURL(withString: text) else {
            return true
        }
        webView.load(URLRequest(url: url))
        return true
    }
    
    // MARK: Button press handlers
    
    @IBAction func handleReturnPress(_ sender: UITextField) {
//        guard let text = sender.text, let url = URL.httpURL(withString: text) else {
//            return
//        }
//        webView.load(URLRequest(url: url))
    }
    
    @IBAction func handleBackButtonPress(_ sender: UIButton) {
        webView.stopLoading()
        webView.goBack()
    }
    
    @IBAction func handleForwardButtonPress(_ sender: UIButton) {
        webView.stopLoading()
        webView.goForward()
    }
    
    @IBAction func handleRefreshButtonPress(_ sender: UIButton) {
        webView.reload()
    }
    
    // MARK: Private methods
    
    private func refreshNavigationControls() {
        backButton.isEnabled = webView.canGoBack
        forwardButton.isEnabled = webView.canGoForward
        refreshButton.isEnabled = webView.url != nil
    }
}

extension BrowserViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        self.loaderIndicator.isHidden = false
        self.loaderIndicator.startAnimating()
        refreshNavigationControls()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.loaderIndicator.stopAnimating()
        textField.text = webView.url?.absoluteString
    }
}

extension URL {
    static func httpURL(withString string: String) -> URL? {
        let urlString: String
        
        if (string.starts(with: "http://") || string.starts(with: "https://")) {
            urlString = string
        } else {
            urlString = "http://" + string
        }
        
        return URL(string: urlString)
    }
}
