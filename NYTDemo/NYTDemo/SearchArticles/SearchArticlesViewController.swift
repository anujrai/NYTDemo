//
//  SearchArticlesViewController.swift
//  NYTDemo
//
//  Created by Anuj Rai on 17/09/19.
//  Copyright © 2019 Anuj Rai. All rights reserved.
//

import UIKit

class SearchArticlesViewController: UIViewController {
    
    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var activity: UIActivityIndicatorView!
    
    private var client = ArticleClient<SearchResponse>()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Search"
    }
    
    @IBAction func onSearch(_ sender: Any) {
        self.searchTextField.resignFirstResponder()
        guard let searchText = self.searchTextField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines), !searchText.isEmpty else {
            let alert = UIAlertController(title: "Error", message: "Please type anything to search.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        self.activity.startAnimating()
        self.view.isUserInteractionEnabled = false
        self.client.getArticle(forEndpoint: ArticlesEndPoint.search(string: searchText), completion: { [weak self] result in
            self?.activity.stopAnimating()
            self?.view.isUserInteractionEnabled = true
            switch result {
            case .success(let articles):
                guard let response = articles?.response, let docs = response.docs else { return }
                let controller = ArticlesListViewController.instantiate(withArticles: docs)
                controller.endPoint = .search(string: searchText)
                self?.navigationController?.pushViewController(controller, animated: true)
            case .failure(let error):
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            }
        })
    }
}
