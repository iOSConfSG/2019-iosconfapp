//
//  NewsWithoutImageCell.swift
//  iosconfsg2019
//
//  Created by Vina Melody on 9/1/19.
//  Copyright © 2019 Vina Melody. All rights reserved.
//

import UIKit

class BaseCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {}
    
}

class NewsCellWithoutImage: BaseCell {
    
    var newsItem: NewsFeed? {
        didSet {
            if let title = newsItem?.title {
                newsTitle.text = title
            }
            if let content = newsItem?.content {
                newsContent.text = content
                newsContent.setContentOffset(.zero, animated: false)
            }
            if let time = newsItem?.date {
                newsTimestamp.text = time
            }
        }
    }
    
    let newsTitle: UILabel = {
        let label = UILabel()
        label.text = "News Title"
        label.textColor = UIColor.purple
        label.font = UIFont.boldSystemFont(ofSize: UIFont.xLargeSize)
        label.numberOfLines = 2
        return label
    }()
    
    let newsTimestamp: UILabel = {
        let label = UILabel()
        label.text = "Today, 9.30am"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.darkGray
        return label
    }()
    
    let newsContent: UITextView = {
        let content = UITextView()
        content.backgroundColor = UIColor.white
        content.textContainer.lineFragmentPadding = 0
        content.showsVerticalScrollIndicator = true
        content.isEditable = false
        content.font = UIFont.systemFont(ofSize: 14)
        content.text = "Sugar iced fair trade, mocha bar wings whipped to go french press half and half coffee americano. Cappuccino robusta organic redeye filter viennese robusta. Macchiato, flavour black body cortado sit grinder irish. Mug beans viennese, organic ristretto, macchiato single origin percolator at robusta. Sugar iced fair trade, mocha bar wings whipped to go french press half and half coffee americano. Cappuccino robusta organic redeye filter viennese robusta. Macchiato, flavour black body cortado sit grinder irish. Mug beans viennese, organic ristretto, macchiato single origin percolator at robusta."
        return content
    }()
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.4, alpha: 0.3)
        return view
    }()
    
    override func setupViews() {
        
        addSubview(newsTitle)
        addSubview(newsTimestamp)
        addSubview(newsContent)
        addSubview(dividerLineView)
        
        addConstraintsWithFormat("H:|-8-[v0]|", views: newsTitle)
        addConstraintsWithFormat("H:|-8-[v0]|", views: newsTimestamp)
        addConstraintsWithFormat("H:|-8-[v0]-8-|", views: newsContent)
        addConstraintsWithFormat("H:|-8-[v0]|", views: dividerLineView)
        addConstraintsWithFormat("V:|-14-[v0]-5-[v1]-10-[v2]-10-[v3(1)]|", views: newsTitle, newsTimestamp, newsContent, dividerLineView)
        
    }
}
