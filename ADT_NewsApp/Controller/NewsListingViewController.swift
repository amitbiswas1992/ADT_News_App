//
//  NewsListingViewController.swift
//  ADT_NewsApp
//
//  Created by Amit Biswas on 9/9/20.
//  Copyright © 2020 Amit Biswas. All rights reserved.
//


import UIKit

class NewsListingViewController: UIViewController {
    
    //MARK: App Constants
    
    private let bannerNewsNibName = "BannerNewsTableViewCell"
    private let bannerNewsCellIdentifier = "bannerNewsCellIdentifier"
    
    private let newsListingNibName = "NewsListingTableViewCell"
    private let newsCellIdentifier = "newsListingCellIdentifier"
    
    private var refreshControl = UIRefreshControl()
    private var isRefresh = false
    
    private var indicator: UIActivityIndicatorView!
    
    private var newsArticlesList = [News]()
    
    //MARK: Outlets
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.tableFooterView = UIView()
            tableView.backgroundColor = UIColor.white
        }
    }
    
    private func setupNavBar() {
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemBlue]
        self.title = "ADT News"
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = UIColor.white
    }
    
    //MARK: Override Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRefreshControl()
        fetchNewsData()
        registerNib()
        setupNavBar()
    }
    
    
    @objc func handleRefresh(refreshControl: UIRefreshControl) {
        isRefresh = true
        fetchNewsData()
    }
    
}

//MARK: Api Calls

extension NewsListingViewController {
    
    private func fetchNewsData() {
        if self.isRefresh {
            self.newsArticlesList.removeAll()
        } else {
            self.indicator.startAnimating()
        }
        
        NetworkManager.shared.getNewsList(
            
            apiKey: AppConstant.apiKey.rawValue,
            completed: { (result: NewsListResult) in
                switch result {
                    case .success(let list):
                        
                        DispatchQueue.main.async {
                            self.newsArticlesList.append(contentsOf: list)
                            if self.isRefresh {
                                self.isRefresh = false
                                self.refreshControl.endRefreshing()
                            }
                            
                            self.tableView.reloadData()
                            self.indicator.stopAnimating()
                    }
                    
                    
                    case .failure( _):
                        self.tableView.reloadData()
                        self.indicator.stopAnimating()
                }
        })
        
    }
}

extension NewsListingViewController {
    
    private func setupRefreshControl() {
        refreshControl.tintColor = UIColor.blue
        refreshControl.addTarget(self, action: #selector(handleRefresh(refreshControl:)), for: UIControl.Event.valueChanged)
        self.tableView.addSubview(refreshControl)
        
        indicator = UIActivityIndicatorView(style: .large)
        indicator.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
        indicator.center = view.center
        view.addSubview(indicator)
        indicator.bringSubviewToFront(view)
    }
    
    private func registerNib() {
        let nib = UINib(nibName: bannerNewsNibName, bundle: Bundle.main)
        self.tableView.register(nib, forCellReuseIdentifier: bannerNewsCellIdentifier)
        
        let newsListingNib = UINib(nibName: newsListingNibName, bundle: Bundle.main)
        self.tableView.register(newsListingNib, forCellReuseIdentifier: newsCellIdentifier)
    }
    
    private func openUrlInBrowser(url: String?) {
        guard let urlString = url,
            let newsUrl = URL(string: urlString) else {
                return
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(newsUrl, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(newsUrl)
        }
    }
    
}


//MARK: - UITableView Delegate

extension NewsListingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let news = self.newsArticlesList[indexPath.row]
        openUrlInBrowser(url: news.url)
    }
}

//MARK: - Table View Data Source
extension NewsListingViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: bannerNewsCellIdentifier, for: indexPath) as! BannerNewsTableViewCell
            if self.newsArticlesList.count != 0 {
                cell.setData(newsArticle: self.newsArticlesList[indexPath.row])
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: newsCellIdentifier, for: indexPath) as! NewsListingTableViewCell
            if self.newsArticlesList.count != 0 {
                cell.setData(newsArticle: self.newsArticlesList[indexPath.row])
            }
            
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.newsArticlesList.count
        
    }
}
