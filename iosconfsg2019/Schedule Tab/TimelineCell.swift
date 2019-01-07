//
//  TimelineCell.swift
//  iosconfsg2019
//
//  Created by Vina Melody on 5/11/18.
//  Copyright © 2018 Vina Melody. All rights reserved.
//
import UIKit

class TimelineCell: UITableViewCell {
    
    var talk: Talk? {
        didSet {
            self.titleLabel.text = talk?.title
            self.speakerLabel.text = talk?.speaker?.name
            
            if let iconFilename = talk?.talkIconFilename {
                self.iconImageView.image = UIImage(imageLiteralResourceName: iconFilename)
            }
            
            var duration = talk?.startAt.toConferenceTime()
            duration?.append(contentsOf: " - ")
            duration?.append(contentsOf: talk?.endAt.toConferenceTime() ?? "")
            self.timeLabel.text = duration
        }
    }
    
    let iconImageView: UIImageView = {
        let img = UIImage(imageLiteralResourceName: "flag")
        let imgView = UIImageView(image: img)
        imgView.contentMode = .scaleToFill
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.layer.cornerRadius = 10
        imgView.backgroundColor = UIColor.clear
        return imgView
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: UIFont.smallSize, weight: .light)
        label.text = "10.00 - 10.30"
        label.numberOfLines = 0
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Codable in Swift 4"
        label.font = UIFont.boldSystemFont(ofSize: UIFont.largeSize)
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byTruncatingTail
        label.textColor = UIColor.purple
        return label
    }()
    
    let speakerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Sam Davies"
        label.font = UIFont.systemFont(ofSize: UIFont.normalSize)
        label.numberOfLines = 1
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    private func setupViews() {
        
        let marginGuide = contentView.layoutMarginsGuide
        
        contentView.addSubview(timeLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(speakerLabel)
        contentView.addSubview(iconImageView)
        
        iconImageView.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor, constant: 0).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 27).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 27).isActive = true
        iconImageView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        
        timeLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: 0).isActive = true
        timeLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 8).isActive = true
        timeLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor, constant: 0).isActive = true

        titleLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 8).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: timeLabel.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor, constant: 0).isActive = true
        speakerLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
        speakerLabel.leadingAnchor.constraint(equalTo: timeLabel.leadingAnchor, constant: 0).isActive = true
        speakerLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor, constant: 0).isActive = true
        speakerLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor, constant: 0).isActive = true

        // Went thru heaven creating the dynamic cell height but these 4 lines work like charm!
//        addConstraintsWithFormat("H:|-16-[v0]", views: timeLabel)
//        addConstraintsWithFormat("H:|-16-[v0]-32-|", views: titleLabel)
//        addConstraintsWithFormat("H:|-16-[v0]|", views: speakerLabel)
//        addConstraintsWithFormat("V:|-4-[v0]-4-[v1]-4-[v2]-4-|", views: timeLabel, titleLabel, speakerLabel)
        
    }
    
}
