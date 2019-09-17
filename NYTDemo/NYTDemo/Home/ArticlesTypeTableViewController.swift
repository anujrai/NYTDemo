//
//  ArticlesTypeTableViewController.swift
//  NYTDemo
//
//  Created by Anuj Rai on 17/09/19.
//  Copyright © 2019 Anuj Rai. All rights reserved.
//

import UIKit

enum ScreenType: String {
    case search
    case emailed
    case viewed
    case shared
}

class ArticlesTypeTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        func navigateToArticles(endPoint: ArticlesEndPoint) {
            if let listVc = segue.destination as? ArticlesListViewController {
                listVc.endPoint = endPoint
            }
        }
        
        let endPoint: ArticlesEndPoint
        switch segue.identifier {
        case ScreenType.emailed.rawValue:
            endPoint = ArticlesEndPoint.emailed(inDays: 1)
            navigateToArticles(endPoint: endPoint)
        case ScreenType.viewed.rawValue:
            endPoint = ArticlesEndPoint.viewed(inDays: 1)
            navigateToArticles(endPoint: endPoint)
        case ScreenType.shared.rawValue:
            endPoint = ArticlesEndPoint.shared(inDays: 1)
            navigateToArticles(endPoint: endPoint)
        default:
            break
        }
    }
}

extension ArticlesTypeTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
