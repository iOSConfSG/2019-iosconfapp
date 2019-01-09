//
//  NewsWithImageCell.swift
//  iosconfsg2019
//
//  Created by Vina Melody on 9/1/19.
//  Copyright © 2019 Vina Melody. All rights reserved.
//

import UIKit

class NewsCellWithImage: NewsCellWithoutImage, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
//    var newsCellWithoutImage = NewsCellWithoutImage()
    
    var newsViewController: NewsViewController?
    var newsImages: [String?] = []
    
    override var newsItem: NewsFeed? {
        didSet {            
            if let title = newsItem?.title {
                self.newsTitle.text = title
            }
            if let content = newsItem?.content {
                self.newsContent.text = content
                self.newsContent.setContentOffset(.zero, animated: false)
            }
            if let pictures = newsItem?.images {
                newsImages = pictures
            }
            if let time = newsItem?.date {
                self.newsTimestamp.text = time
            }
        }
    }
    
    
    let collectionImageView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.clear
        return cv
    }()
    
    private let newsImageCellId = "cellId"
    
    override func setupViews() {
        
        removeFromSuperview()
        
        collectionImageView.dataSource = self
        collectionImageView.delegate = self
        collectionImageView.register(NewsImageCell.self, forCellWithReuseIdentifier: newsImageCellId)
        
        addSubview(newsTitle)
        addSubview(newsTimestamp)
        addSubview(newsContent)
        addSubview(collectionImageView)
        addSubview(dividerLineView)
        
        addConstraintsWithFormat("H:|-8-[v0]|", views: newsTitle)
        addConstraintsWithFormat("H:|-8-[v0]|", views: newsTimestamp)
        addConstraintsWithFormat("H:|-8-[v0]-8-|", views: newsContent)
        addConstraintsWithFormat("H:|-8-[v0]|", views: dividerLineView)
        addConstraintsWithFormat("H:|-14-[v0]|", views: collectionImageView)
        
        addConstraintsWithFormat("V:|-8-[v0]-8-[v1]-12-[v2]-5-[v3(120)]-8-[v4(1)]|", views: newsTitle, newsTimestamp, newsContent, collectionImageView, dividerLineView)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newsImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionImageView.dequeueReusableCell(withReuseIdentifier: newsImageCellId, for: indexPath) as! NewsImageCell
        
        cell.newsViewController = self.newsViewController
        cell.cellImageURL = self.newsImages[indexPath.item]
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 110)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    private class NewsImageCell: BaseCell {
        
        var newsViewController: NewsViewController?
        
        var cellImageURL: String? {
            didSet {
                if let url = cellImageURL {
                    imageView.downloadImageFrom(urlString: url)
                }
            }
        }
        
        let imageView: UIImageView = {
            let iv = UIImageView()
            iv.contentMode = .scaleAspectFit
            iv.isUserInteractionEnabled = true
            return iv
        }()
        
        override func setupViews() {
            
            layer.masksToBounds = true
            backgroundColor = UIColor.clear
            addSubview(imageView)
            
            imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.animate)))
            addConstraintsWithFormat("H:|[v0]|", views: imageView)
            addConstraintsWithFormat("V:|[v0]|", views: imageView)
        }
        
        @objc func animate() {            
            newsViewController?.animateImageView(focusImageView: imageView)
        }
    }
}
