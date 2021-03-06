//
//  TrendingFeedVC.swift
//  versi-app
//
//  Created by Maksim on 06.04.2021.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire

class TrendingFeedVC: UIViewController /*, UITableViewDelegate, UITableViewDataSource*/ {

    @IBOutlet weak var tableView: UITableView!
    
    var dataSource = PublishSubject<[Repo]>()
    var disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        print("fetchData - passed")
        
        dataSource.bind(to: tableView.rx.items(cellIdentifier: "trendingRepoCell")) { (row, repo: Repo, cell: TrendingRepoCell) in
            
            cell.configureCell(repo: repo)
        }.disposed(by: disposeBag)
        //tableView.reloadData()
    }
    
    func fetchData() {
        DownloadService.instance.downloadTrendingRepos { (trendingRepoArray) in
            print("fetchData - done", trendingRepoArray.count)
            self.dataSource.onNext(trendingRepoArray)
           
        }
    }
}
        





//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.reloadData()
        
//        DownloadService.instance.downloadTrendingReposDictArray { (json) in
//            print("\n \n \n downloaded") //????
//        }
//        DownloadService.instance.downloadTrendingReposDictArray { (reposDictArray) in
//            print(reposDictArray)
//        }
//        DownloadService.instance.downloadTrendingRepos { (reposArray) in
//            print("\n \n \n",reposArray.count)
//        }
        
    

//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 2
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "trendingRepoCell", for: indexPath) as? TrendingRepoCell else { return UITableViewCell() }
//        let repo = Repo(image: UIImage(named: "searchIconLarge")!, name: "SWIFT", description: "Amazing Apple langue for programming.", numberOfForks: 1024, language: "SWIFT", numberOfContributors: 65535, repoUrl: "www.apple.com")
//        cell.configureCell(repo: repo)
//        return cell
//    }


