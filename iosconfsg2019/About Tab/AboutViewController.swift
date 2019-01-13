//
//  AboutViewController.swift
//  iosconfsg2019
//
//  Created by Vina Melody on 10/11/18.
//  Copyright © 2018 Vina Melody. All rights reserved.
//

import UIKit
import FirebaseDatabase
import AttributedTextView

class AboutViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private var items: [About] = []
    
    private let itemCell: String = "itemCell"
    private let itemCellWithImage: String = "itemCellWithImage"
    
    // MARK: - View controller methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "iOSConfSG 2019"
        self.view.backgroundColor = UIColor.white
        
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor.white
        
        collectionView?.register(AboutCell.self, forCellWithReuseIdentifier: itemCell)
        collectionView?.register(AboutCellWithImage.self, forCellWithReuseIdentifier: itemCellWithImage)
        
        getItems()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = self.items[indexPath.item]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemCell, for: indexPath) as! AboutCell
        
        if item.imageUrl != nil {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemCellWithImage, for: indexPath) as! AboutCellWithImage
            cell.item = item
            return cell
        }
        
        cell.item = item
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = self.items[indexPath.item]
        
        var estimatedHeight: CGFloat = 18 + 1
        
        if let content = item.content {
            let netWidth = view.frame.width - 8 - 8
            let size = CGSize(width: netWidth, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedFrame = NSString(string: content).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)], context: nil)
            
            estimatedHeight = estimatedFrame.height + 30
        }

        if item.imageUrl != nil {
            
            // with image, add 120 of image thumbnail height
            estimatedHeight += 120
            
            if item.title.contains("After-party Sponsor") {
                //after-party space should be smaller than gold
            
                return CGSize(width: view.frame.width, height: estimatedHeight)
            }
            
            return CGSize(width: view.frame.width, height: estimatedHeight + 100)
        }
        return CGSize(width: view.frame.width, height: estimatedHeight + 50)
    }
    
    // MARK: - Private methods
    private func getItems() {
        
        let dbRef = Database.database().reference()
        let abtRef = dbRef.child("about")
        
        abtRef.observe(.childAdded, with: { (snapshot) in
            let itemFromFirebase = About(snapshot: snapshot)
            self.items.append(itemFromFirebase)
            self.reloadData()
        })
        
        abtRef.observe(.childChanged, with: { (snapshot) in
            self.reloadData()
        })
        
        abtRef.observe(.childRemoved, with: { (snapshot) in
            self.removeItem(id: snapshot.key)
            self.reloadData()
        })
        
        abtRef.observe(.value, with: { (snapshot) in
            self.reloadData()
        })
    }
    
    private func reloadData() {
        let items = self.items.sorted(by: { $0.order < $1.order })
        self.items = items
        self.collectionView?.reloadData()
    }
    
    private func removeItem(id: String) {
        
        OperationQueue.main.addOperation {
            var indexToRemove: Int = -1
            for index in 0...self.items.count-1 {
                let news = self.items[index]
                if news.firebaseId == id {
                    indexToRemove = index
                    break
                }
            }
            
            if indexToRemove >= 0 {
                //found thing to remove, remove it
                self.items.remove(at: indexToRemove)
                self.collectionView?.reloadData()
            }
        }
    }
}


class AboutCell: BaseCell {
    
    internal var item: About? {
        didSet {
            self.title.text = item?.title
            
            if let contentText = item?.content {
                self.content.text = contentText
                self.content.attributer = contentText.size(17).matchLinks.makeInteract({ (link) in
                    guard let url = URL(string: link) else {
                        return
                    }
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                })
                self.content.setContentOffset(.zero, animated: false)
            }
        }
    }
    
    let title: UILabel = {
        let label = UILabel()
        label.text = "News Title"
        label.textColor = UIColor.purple
        label.font = UIFont.boldSystemFont(ofSize: UIFont.xLargeSize)
        label.numberOfLines = 2
        return label
    }()
    
    let content: AttributedTextView = {
        let content = AttributedTextView()
        content.backgroundColor = UIColor.clear
        content.textContainer.lineFragmentPadding = 0
        content.showsVerticalScrollIndicator = true
        content.isEditable = false
        content.isUserInteractionEnabled = true
        content.text = ""
        return content
    }()
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.4, alpha: 0.3)
        return view
    }()
    
    override func setupViews() {
        backgroundColor = UIColor.white
        
        addSubview(title)
        addSubview(content)
        addSubview(dividerLineView)
        addConstraintsWithFormat("H:|-8-[v0]-8-|", views: title)
        addConstraintsWithFormat("H:|-8-[v0]-8-|", views: content)
        addConstraintsWithFormat("H:|-8-[v0]-8-|", views: dividerLineView)
        
        addConstraintsWithFormat("V:|-8-[v0]-12-[v1]-8-[v2(1)]|", views: title, content, dividerLineView)
    }
}

class AboutCellWithImage: AboutCell {
    
    override var item: About? {
        didSet {
            self.title.text = item?.title
            if let imageUrlString = item?.imageUrl {
                self.imageView.downloadImageFrom(urlString: imageUrlString)
            }
        }
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.isUserInteractionEnabled = true
        iv.backgroundColor = UIColor.white
        return iv
    }()
    
    override func setupViews() {
        backgroundColor = UIColor.white
        
        removeFromSuperview()
        
        addSubview(title)
        addSubview(imageView)
        addSubview(dividerLineView)
        addConstraintsWithFormat("H:|-8-[v0]-8-|", views: title)
        addConstraintsWithFormat("H:|-8-[v0]-8-|", views: imageView)
        addConstraintsWithFormat("H:|-8-[v0]-8-|", views: dividerLineView)
        
        addConstraintsWithFormat("V:|-8-[v0]-12-[v1]-8-[v2(1)]|", views: title, imageView, dividerLineView)
    }
}
