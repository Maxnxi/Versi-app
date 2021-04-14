//
//  SearchVC.swift
//  versi-app
//
//  Created by Maksim on 06.04.2021.
//

import UIKit
import RxCocoa
import RxSwift
import Alamofire

class SearchVC: UIViewController, UITableViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var searchField: RoundedBorderTxtField!
    @IBOutlet weak var tableView: UITableView!
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindSearchField()
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
    }
    
    func bindSearchField() {
        let searchResultsObservable = searchField.rx.text
            .orEmpty
            .debounce(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            .map {
                $0.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
            }
            .flatMap { (query) -> Observable<[Repo]> in
                if query == "" {
                    return Observable<[Repo]>.just([])
                } else {
                    let url = searchURL + query + starsDescendingSegment
                    var searchRepos = [Repo]()
                    
                    return URLSession.shared.rx.json(url: URL(string: url)!).map {
                        let results = $0 as AnyObject
                        let items = results.object(forKey: "items") as? [Dictionary<String, Any>] ?? []
                        for item in items {
                            guard let name = item["name"] as? String,
                                  let description = item["description"] as? String,
                                  let language = item["language"] as? String,
                                  let forksCount = item["forks_count"] as? Int,
                                  let repoUrl = item["html_url"] as? String else { break }
                            let repo = Repo(image: UIImage(named: "searchIconLarge")!, name: name, description: description, numberOfForks: forksCount, language: language, numberOfContributors: 0, repoUrl: repoUrl)
                            
                            searchRepos.append(repo)
                                  
                        }
                        return searchRepos
                    }
                }
            }
            .observe(on: MainScheduler.instance)
        
        searchResultsObservable.bind(to: tableView.rx.items(cellIdentifier: "searchCell")) { (row, repo: Repo, cell: SearchCell) in
            cell.configureCell(repo: repo)
            }
            .disposed(by: disposeBag)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? SearchCell else { return }
        //print(cell.repoUrl)
        let url = cell.repoUrl!
        self.presentSFSafariVCFor(url: url)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }

}



