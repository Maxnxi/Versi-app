//
//  DownloadService.swift
//  versi-app
//
//  Created by Maksim on 07.04.2021.
//

import Foundation
import RxSwift
import Alamofire
import AlamofireImage

class DownloadService {
    static let instance = DownloadService()
    
    func downloadTrendingReposDictArray(completion: @escaping(_ reposDictArray: [Dictionary<String, Any>]) -> ()) {
        var trendingReposDictArray = [Dictionary<String, Any>]()
        
        AF.request(TRENDING_REPO_URL).responseJSON { response in
            guard let json = response.value as? Dictionary<String, Any> else {
                print("escape code #1")
                return } // .reslt.value
            //guard let json = response.value else {return}
            //debugPrint("look through",json)
            guard let repoDictionaryArray = json["items"] as? [Dictionary<String, AnyObject>] else {
                print("escape code #2")
                return }
            //debugPrint("look through",trendingReposDictArray)
            //trendingReposArray = repoDictionaryArray
            for repoDict in repoDictionaryArray {
                if trendingReposDictArray.count <= 9 {
                    
                    //guard
                        let name = repoDict["name"] as? String
                        let description = repoDict["description"] as? String
                        let numberOfForks = repoDict["forks_count"] as? Int
                        let language = repoDict["language"] as? String ?? "not specified"
                        let repoUrl = repoDict["html_url"] as? String
                        let contributorsUrl = repoDict["contributors_url"] as? String
                        let ownerDict = repoDict["owner"] as? Dictionary<String, AnyObject>
                    let avatarUrl = ownerDict?["avatar_url"] as? String
//                    else {
//                        print("escape code #3")
//                        break }
                    
                    let repoDictionary: Dictionary<String, Any> = [
                        "name": name?.uppercased(),
                        "description": description,
                        "forksCount": numberOfForks,
                        "language": language,
                        "repoUrl": repoUrl,
                        "contributorsUrl": contributorsUrl,
                        "avatarUrl": avatarUrl
                    ]
                    print("append", repoDictionary )
                    trendingReposDictArray.append(repoDictionary)
                } else {
                    print("9 repos Downloaded - success")
                    break
                }
            }
            //debugPrint("look through",trendingReposArray)
            print("_____________________\n downloadTrendingReposDictArray - done\n",trendingReposDictArray.count)
            completion(trendingReposDictArray)
        }
    }
    
    func downloadImageFor(avatarUrl: String, completion: @escaping (_ image: UIImage)-> ()) {
        AF.request(avatarUrl).responseImage { (imageResponse) in
            guard let image = imageResponse.value else {
                print("escape code #4")
                return }
            completion(image)
        }
    }
    
    func downloadContributorsDataFor(contributorsUrl url: String, completion: @escaping (_ contributors: Int) -> Void) {
        AF.request(url).responseJSON { response in
            guard let json = response.value as? [Dictionary<String, Any>] else {
                print("escape code #5")
                return }
            if !json.isEmpty {
                let contributions = json[0]["contributions"] as! Int
                completion(contributions)
            }
        }
    }
    
    func downloadTrendingRepo(fromDictionary dictionary: Dictionary<String, Any>, completion: @escaping(_ repo: Repo) -> Void)  {
        
        let avatarUrl = dictionary["avatarUrl"] as! String
        let contributorsUrl = dictionary["contributorsUrl"] as! String
        let name = dictionary["name"] as! String
        let description = dictionary["description"] as! String
        let numberOfForks = dictionary["forksCount"] as! Int
        let language = dictionary["language"] as! String
        let repoUrl = dictionary["repoUrl"] as! String
        
        downloadImageFor(avatarUrl: avatarUrl) { (imageForRepo) in
            self.downloadContributorsDataFor(contributorsUrl: contributorsUrl, completion: { (contributions) in
                
                let repo = Repo(image: imageForRepo, name: name, description: description, numberOfForks: numberOfForks, language: language, numberOfContributors: contributions, repoUrl: repoUrl)
                print("_____________________\n downloadTrendingRepo - done\n",repo.language)
                
                completion(repo)
            })
        }
    }
    
    func downloadTrendingRepos(completion: @escaping(_ repoArray: [Repo]) -> ()) {
        
        
        downloadTrendingReposDictArray { (trendingReposDictArray) in
            var trendingReposArray = [Repo]()
            for dict in trendingReposDictArray {
                self.downloadTrendingRepo(fromDictionary: dict, completion: { (returnedRepo) in
                    if trendingReposArray.count < 9 {
                        trendingReposArray.append(returnedRepo)
                    } else {
                        let sortedRepoArray = trendingReposArray.sorted(by: { (repoA, repoB) -> Bool in
                            if repoA.numberOfForks > repoB.numberOfForks {
                                return true
                            } else {
                                return false
                            }
                        })
                        print("_____________________\n downloadTrendingRepos - done\n",sortedRepoArray.count)
                        completion(sortedRepoArray)
                    }
                })
            }
        }
    }
}
