//
//  TrendingRepoCell.swift
//  versi-app
//
//  Created by Maksim on 06.04.2021.
//

import UIKit
//import Foundation

class TrendingRepoCell: UITableViewCell {

    @IBOutlet weak var repoName: UILabel!
    @IBOutlet weak var repoDescriptionLbl: UILabel!
    @IBOutlet weak var repoImageView: UIImageView!
    @IBOutlet weak var repoNumberOfForks: UILabel!
    @IBOutlet weak var repoLanguage: UILabel!
    @IBOutlet weak var repoNumberOfContributors: UILabel!
    @IBOutlet weak var repoViewReadmeBtn: RoundedButton!
    @IBOutlet weak var backView: UIView!
    
     var repoUrl: String?
    
    func configureCell(repo: Repo) {
        self.repoName.text = repo.name
        self.repoDescriptionLbl.text = repo.description
        self.repoImageView.image = repo.image
        self.repoNumberOfForks.text = String(describing: repo.numberOfForks)
        self.repoLanguage.text = repo.language
        self.repoNumberOfContributors.text = String(describing: repo.numberOfContributors)
        print("configureCell - done")
        
    }
    
    override func layoutSubviews() {
        backView.layer.cornerRadius = 15
        backView.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        backView.layer.shadowOpacity = 0.25
        backView.layer.shadowRadius = 5.0
        backView.layer.shadowOffset = CGSize(width: 0, height: 0)
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }

}
