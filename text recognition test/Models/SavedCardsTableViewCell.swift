//
//  SavedCardsTableViewCell.swift
//  text recognition test
//
//  Created by IFTS 25 on 17/03/22.
//

import UIKit

class SavedCardsTableViewCell: UITableViewCell {

    @IBOutlet weak var nomeLabel: UILabel!
   
    @IBOutlet weak var numeroLabel: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup(with contatto : Contatto){
        
        nomeLabel.text = contatto.nome
        numeroLabel.text = contatto.numero.first
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
