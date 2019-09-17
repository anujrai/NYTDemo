//
//  ViewController.swift
//  NYTDemo
//
//  Created by Anuj Rai on 17/09/19.
//  Copyright © 2019 Anuj Rai. All rights reserved.
//

import UIKit

class ArticlesListViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            self.tableView.estimatedRowHeight = 70
            self.tableView.rowHeight = UITableView.automaticDimension
            self.tableView.tableFooterView = UIView()
        }
    }
    @IBOutlet private weak var activity: UIActivityIndicatorView!
        
    private var client = ArticleClient<ArticleResult>()
    var endPoint: ArticlesEndPoint = ArticlesEndPoint.emailed(inDays: 1)
    var articles = [ModelData]()
    
    class func instantiate(withArticles articles: [ModelData]) -> ArticlesListViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let controller = storyboard.instantiateViewController(withIdentifier: String(describing: self)) as? ArticlesListViewController else {
            return ArticlesListViewController()
        }
        controller.articles = articles
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Articles"
        if self.articles.isEmpty {
            self.getArticles(forEndPoint: self.endPoint)
        }
    }
    
    private func getArticles(forEndPoint endPoint: ArticlesEndPoint) {
        self.activity.startAnimating()
        self.view.isUserInteractionEnabled = false
        self.client.getArticle(forEndpoint: endPoint, completion: { [weak self] result in
            self?.activity.stopAnimating()
            self?.view.isUserInteractionEnabled = true
            switch result {
            case .success(let articles):
                guard let articles = articles?.articles else { return }
                self?.articles = articles
                self?.tableView.reloadData()
            case .failure(let error):
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            }
        })
    }
}

extension ArticlesListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArticlesTableViewCell", for: indexPath) as? ArticlesTableViewCell else { return ArticlesTableViewCell() }
        let article = self.articles[indexPath.row]
        cell.configure(title: article.title, date: article.publishedDate)
        return cell
    }
}

