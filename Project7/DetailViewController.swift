//
//  DetailViewController.swift
//  Project7
//
//  Created by Lucas Rocha on 19/09/22.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    var webView: WKWebView!
    var detailItem: Petition?
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let detailItem = detailItem else{ return }

        let html = """
        <html>
        <head>
        <meta name="viewport" content="width=device-width, inicial-scale=1">
        <style> body { font-size: 150%; } </style>
        </head>
        <body>
        <h2> \(detailItem.title) </h1>
        \(detailItem.body)
        </body>
        </html>
        """
        
        webView.loadHTMLString(html, baseURL: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}