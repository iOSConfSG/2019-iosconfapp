//
//  NewsViewController.swift
//  iosconfsg2019
//
//  Created by Vina Melody on 10/11/18.
//  Copyright © 2018 Vina Melody. All rights reserved.
//

import UIKit
import FirebaseDatabase

class NewsViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private var newsFeed: [NewsFeed] = []
    
    private let newsCellWithoutImage: String = "newsCellWithoutImage"
    private let newsCellWithImage: String = "newsCellWithImage"
    
    let zoomImageView = UIImageView()
    let blackBackgroundView = UIView()
    var focusImageView: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "iOSConfSG News"
        self.view.backgroundColor = UIColor.white
        
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor.white
        
        collectionView?.register(NewsCellWithoutImage.self, forCellWithReuseIdentifier: newsCellWithoutImage)
        collectionView?.register(NewsCellWithImage.self, forCellWithReuseIdentifier: newsCellWithImage)
        
        getNews()
    }
    
    private func getNews() {
        
        let dbRef = Database.database().reference()
        let newsRef = dbRef.child("news")
        
        newsRef.observe(.childAdded, with: { (snapshot) in
            let newsItemFromFirebase = NewsFeed(snapshot: snapshot)
            self.newsFeed.insert(newsItemFromFirebase, at: 0)
        })
        
        newsRef.observe(.childChanged, with: { (snapshot) in
            self.collectionView?.reloadData()
        })
        
        newsRef.observe(.childRemoved, with: { (snapshot) in
            print("News child removed")
            self.removeNews(newsId: snapshot.key)
            self.collectionView?.reloadData()
        })
        
        newsRef.observe(.value, with: { (snapshot) in
            self.collectionView?.reloadData()
        })
    }
    
    func animateImageView(focusImageView: UIImageView) {
        
        self.focusImageView = focusImageView
        
        if let startingFrame = focusImageView.superview?.convert(focusImageView.frame, to: nil) {
            
            focusImageView.alpha = 0
            
            blackBackgroundView.frame = self.view.frame
            blackBackgroundView.backgroundColor = UIColor.black
            blackBackgroundView.alpha = 0
            view.addSubview(blackBackgroundView)
            
            zoomImageView.backgroundColor = UIColor.red
            zoomImageView.frame = startingFrame
            zoomImageView.image = focusImageView.image
            zoomImageView.contentMode = .scaleToFill
            zoomImageView.clipsToBounds = true
            zoomImageView.isUserInteractionEnabled = true
            view.addSubview(zoomImageView)
            
            zoomImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.zoomOut)))
            blackBackgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.zoomOut)))
            
            UIView.animate(withDuration: 0.3, animations: {
                
                let height:  CGFloat = (self.view.frame.width / startingFrame.width) * startingFrame.height
                
                let y: CGFloat = self.view.frame.height / 2 - height / 2
                self.zoomImageView.frame = CGRect(x: 0, y: y, width: self.view.frame.width, height: height)
                
                self.blackBackgroundView.alpha = 1
            })
        }
    }
    
    @objc func zoomOut() {
        if let startingFrame = focusImageView!.superview?.convert(focusImageView!.frame, to: nil) {
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.zoomImageView.frame = startingFrame
                self.blackBackgroundView.alpha = 0
            }, completion: { (didComplete) -> Void in
                self.zoomImageView.removeFromSuperview()
                self.blackBackgroundView.removeFromSuperview()
                self.focusImageView?.alpha = 1
            })
        }
    }
    
    func removeNews(newsId: String) {
        
        OperationQueue.main.addOperation {
            var indexToRemove: Int = -1
            for index in 0...self.newsFeed.count-1 {
                let news = self.newsFeed[index]
                if news.firebaseId == newsId {
                    indexToRemove = index
                    break
                }
            }
            
            if indexToRemove >= 0 {
                //found thing to remove, remove it
                self.newsFeed.remove(at: indexToRemove)
                self.collectionView?.reloadData()
            }
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.newsFeed.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let newsItem = newsFeed[indexPath.item]
        
        // For news without image
        // addConstraintsWithFormat(format: "V:|-14-[v0]-5-[v1]-10-[v2]-10-[v3(1)]|", views: newsTitle, newsTimestamp, newsContent, dividerLineView)
        // height here is 14 + newsTitle (18) + 5 + newsTimestamp(16) + 10 + newsContent(?) + 10 + 1
        
        var estimatedHeight: CGFloat = 14 + 18 + 5 + 16 + 10 + 10 + 1
        
        let newsContentText = newsItem.content
        let netWidth = view.frame.width - 8 - 8
        let size = CGSize(width: netWidth, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: newsContentText).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], context: nil)
        
        estimatedHeight = estimatedFrame.height + 20
        
        if newsItem.images != nil {
            // with image, add 120 of image thumbnail height
            estimatedHeight += 120
            return CGSize(width: view.frame.width, height: estimatedHeight + 90)
        }
        return CGSize(width: view.frame.width, height: estimatedHeight + 90)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let newsItem = newsFeed[indexPath.item]
        
        // if newsItem has image, use NewsCellWithImage otherwise, use NewsCellWithoutImage only
        if newsItem.images != nil {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: newsCellWithImage, for: indexPath) as! NewsCellWithImage
            cell.newsItem = newsFeed[indexPath.item]
            cell.newsViewController = self
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: newsCellWithoutImage , for: indexPath) as! NewsCellWithoutImage
        cell.newsItem = newsFeed[indexPath.item]
        return cell
    }
}

class NewsFeed {
    
    var title: String
    var date: String
    var timestamp: Int
    var images: [String]?
    var content: String
    var firebaseId: String
    
    init(snapshot: DataSnapshot) {
        
        self.firebaseId = snapshot.key
        let newsDict = snapshot.value as! NSDictionary
        self.title = newsDict["title"] as! String
        self.content = newsDict["content"] as! String
        
        // Vina's timestamp for other purposes
        let timestamp = newsDict["timestamp"] as! NSNumber
        self.timestamp = timestamp.intValue
        self.date = newsDict["date"] as! String
        
        if newsDict["images"] != nil {
            self.images = newsDict["images"] as? [String]
        }
        else {
            self.images = nil
        }
        
    }    
}


