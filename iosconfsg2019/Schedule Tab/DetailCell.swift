//
//  DetailCell.swift
//  iosconfsg2019
//
//  Created by Vina Melody on 6/11/18.
//  Copyright © 2018 Vina Melody. All rights reserved.
//

import UIKit

class DetailCell: UITableViewCell {
    
    let talkTitle: UILabel = {
        let title = UILabel()
        title.text = "Scaling At Large - Lessons learned rewriting Instagram's feed. Plus some very long and super long title to show"
        //title.text = "Scaling At Large"
        title.font = UIFont.boldSystemFont(ofSize: 22)
        title.textColor = UIColor.orange
        title.numberOfLines = 2
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    let talkTime: UILabel = {
        let time = UILabel()
        time.text = "10:00 - 10.35"
        time.font = UIFont.systemFont(ofSize: 14)
        time.translatesAutoresizingMaskIntoConstraints = false
        return time
    }()
    
    let speakerImage: UIImageView = {
        let face = UIImageView()
        face.image = UIImage(named: "iosconfsg-fb")
        face.translatesAutoresizingMaskIntoConstraints = false
        return face
    }()
    
    let speakerName: UILabel = {
        let name = UILabel()
        name.numberOfLines = 3
        name.translatesAutoresizingMaskIntoConstraints = false
        
        let attributedText = NSMutableAttributedString(string: "iOSConfSG", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)])
        
        attributedText.append(NSAttributedString(string: "\n@iosconfsg\nwww.iosconf.sg", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]))
        
        name.attributedText = attributedText
        
        return name
    }()
    
    let descriptionTextView: UITextView = {
        let tv = UITextView()
        tv.isEditable = false
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.isScrollEnabled = true
        tv.showsHorizontalScrollIndicator = true
        tv.showsVerticalScrollIndicator = true
        tv.text = "Earlier this year, Instagram released a rewritten newsfeed on iOS. When rebuilding its feed, the team undertook a huge refactor of its most-used feature, all while other teams were actively working on it. From this refactor, they learned a lot about how to build a highly-performant and stable feed, and through this work built a new open source project called IGListKit.   Come learn about how and why the Instagram team took on rewriting their iOS feed from the bottom up, see what it takes to ship a successful refactor, and learn about their new open source project being released."
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    private func setupViews() {
        
        addSubview(talkTitle)
        
        talkTitle.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive = true
        talkTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 12).isActive = true
        talkTitle.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12).isActive = true
        
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}
