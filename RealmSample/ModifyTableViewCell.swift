//
//  ModifyTableViewCell.swift
//  RealmSample
//
//  Created by blesssecret on 11/11/16.
//  Copyright © 2016 usc. All rights reserved.
//

import UIKit

class ModifyTableViewCell: UITableViewCell {


    @IBOutlet weak var labelTitle: UILabel!
    var index : Int!
    var preview: ViewController!

    @IBAction func actionUpdate(_ sender: UIButton) {
        //print(index)
        preview.updateAtIndex(index: index)
    }

    @IBAction func actionDelete(_ sender: UIButton) {
        preview.deleteAtIndex(index: index)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
