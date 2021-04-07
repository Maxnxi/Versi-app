//
//  TrendingFeedVC.swift
//  versi-app
//
//  Created by Maksim on 06.04.2021.
//

import UIKit

class TrendingFeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
//        DownloadService.instance.downloadTrendingReposDictArray { (json) in
//            print("\n \n \n downloaded") //????
//        }
//        DownloadService.instance.downloadTrendingReposDictArray { (reposDictArray) in
//            print(reposDictArray)
//        }
        DownloadService.instance.downloadTrendingRepos { (repoArray) in
            print(repoArray)
        }
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "trendingRepoCell", for: indexPath) as? TrendingRepoCell else { return UITableViewCell() }
        let repo = Repo(image: UIImage(named: "searchIconLarge")!, name: "SWIFT", description: "Amazing Apple langue for programming.", numberOfForks: 1024, language: "SWIFT", numberOfContributors: 65535, repoUrl: "www.apple.com")
        cell.configureCell(repo: repo)
        return cell
    }
    

}

