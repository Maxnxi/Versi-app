//
//  SearchCell.swift
//  versi-app
//
//  Created by Maksim on 13.04.2021.
//

import UIKit

class SearchCell: UITableViewCell {

    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var repoDescriptionLbl: UILabel!
    @IBOutlet weak var repoNameLbl: UILabel!
    @IBOutlet weak var repoForksCountLabel: UILabel!
    @IBOutlet weak var repoLanguageLbl: UILabel!
    
    public private(set) var repoUrl: String?
    
    
    func configureCell(repo: Repo) {
        repoNameLbl.text = repo.name
        repoDescriptionLbl.text = repo.description
        repoForksCountLabel.text = String(describing: repo.numberOfForks)
        repoLanguageLbl.text = repo.language
        repoUrl = repo.repoUrl
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backView.layer.cornerRadius = 15
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
