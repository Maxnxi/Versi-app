//
//  DownloadService.swift
//  versi-app
//
//  Created by Maksim on 07.04.2021.
//

import Foundation
import Alamofire
import AlamofireImage

class DownloadService {
    static let instance = DownloadService()
    
    func downloadTrendingReposDictArray(completion: @escaping(_ reposDictArray: [Dictionary<String, Any>]) -> ()) {
        var trendingReposArray = [Dictionary<String, Any>]()
        AF.request(trendingRepoURL).responseJSON { (response) in
            guard let json = response.value as? Dictionary<String, Any> else { return } // .reslt.value
            //guard let json = response.value else {return}
            //debugPrint("look through",json)
            guard let repoDictionaryArray = json["items"] as? [Dictionary<String, Any>] else { return }
//            debugPrint("look through",repoDictionaryArray)
            //trendingReposArray = repoDictionaryArray
            for repoDict in repoDictionaryArray {
                if trendingReposArray.count <= 9 {
                    
                    guard let name = repoDict["name"] as? String,
                    let description = repoDict["description"] as? String,
                    let numberOfForks = repoDict["forks_count"] as? Int,
                    let language = repoDict["language"] as? String,
                    let repoUrl = repoDict["html_url"] as? String,
                    let contributorsUrl = repoDict["contributors_url"] as? String,
                    let ownerDict = repoDict["owner"] as? Dictionary<String,Any>,
                    let avatarUrl = ownerDict["avatar_url"] as? String else { break }
                    
                    let repoDictionary: Dictionary<String, Any> = ["name": name, "description": description, "forks_count": numberOfForks, "language": language, "html_url": repoUrl, "contributors_url": contributorsUrl, "avatar_url": avatarUrl]
                    
                    trendingReposArray.append(repoDictionary)
                } else {
                    break
                }
            }
            //debugPrint("look through",trendingReposArray)
            print("_____________________\n downloadTrendingReposDictArray - done\n",trendingReposArray.count)
            completion(trendingReposArray)
        }
    }
    
    func downloadTrendingRepos(completion: @escaping(_ repoArray: [Repo]) -> ()) {
        var reposArray = [Repo]()
        downloadTrendingReposDictArray { (trendingReposDictArray) in
            for dict in trendingReposDictArray {
                self.downloadTrendingRepo(fromDictionary: dict, completion: { (returnedRepo) in
                    if reposArray.count < 9 {
                        reposArray.append(returnedRepo)
                    } else {
                        let sortedArray = reposArray.sorted { (repoA, repoB) -> Bool in
                            if repoA.numberOfForks > repoB.numberOfForks {
                                return true
                            } else {
                                return false
                            }
                        }
                        
                        completion(sortedArray)
                    }
                    
                    
                    
                })
                print("_____________________\n downloadTrendingRepos - done\n",reposArray.count)
               // completion(reposArray)
                
            }
            
        }
    }
    
    func downloadTrendingRepo(fromDictionary dict: Dictionary<String, Any>, completion: @escaping(_ repo: Repo) -> ())  {
        let avatarUrl = dict["avatar_url"] as! String
        let contributorsUrl = dict["contributors_url"] as! String
        let name = dict["name"] as! String
        let description = dict["description"] as? String ?? "easy pizzy"
        let numberOfForks = dict["forks_count"] as! Int
        let language = dict["language"] as! String
        let repoUrl = dict["html_url"] as! String
        //let numberOfContributors = dict[""] //as! String
        
        downloadImageFor(avatarUrl: avatarUrl) { (returnedImage) in
            self.downloadContributorsDataFor(contributorsUrl: contributorsUrl) { (returnedContributions) in
                let repo = Repo(image: returnedImage, name: name, description: description, numberOfForks: numberOfForks, language: language, numberOfContributors: returnedContributions, repoUrl: repoUrl)
                print("_____________________\n downloadTrendingRepo - done\n",repo.language)
                
                completion(repo)
            }
        }
        
        
        
    }
    
    func downloadImageFor(avatarUrl: String, completion: @escaping (_ image: UIImage)-> ()) {
        AF.request(avatarUrl).responseImage { (imageResponse) in
            guard let image = imageResponse.value else { return }
            completion(image)
        }
    }
    
    func downloadContributorsDataFor(contributorsUrl: String, completion: @escaping (_ contributors: Int) -> ()) {
        AF.request(contributorsUrl).responseJSON { (response) in
            guard let json = response.value as? [Dictionary<String, Any>] else { return }
            if !json.isEmpty {
                let contributions = json.count
                completion(contributions)
            }
        }
    }
    
    
    
}
