//
//  TimelineCell.swift
//  iosconfsg2019
//
//  Created by Vina Melody on 5/11/18.
//  Copyright © 2018 Vina Melody. All rights reserved.
//
import UIKit

class TimelineCell: UITableViewCell {
    
    let topLineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.red
        return view
    }()
    
    let bottomLineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.blue
        return view
    }()
    
    let nodeView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    let iconFlag: UIImageView = {
        let img = UIImage(imageLiteralResourceName: "flag")
        let imgView = UIImageView(image: img)
        imgView.contentMode = .scaleToFill
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.layer.cornerRadius = 10
        imgView.backgroundColor = UIColor.yellow
        return imgView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
        addSubview(topLineView)
        addSubview(bottomLineView)
        addSubview(nodeView)
        
        nodeView.addSubview(iconFlag)
        
        topLineView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 44).isActive = true
        topLineView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5).isActive = true
        topLineView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        topLineView.widthAnchor.constraint(equalToConstant: 1).isActive = true
        
        bottomLineView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 44).isActive = true
        bottomLineView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5).isActive = true
        bottomLineView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        bottomLineView.widthAnchor.constraint(equalToConstant: 1).isActive = true
        
        nodeView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        nodeView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        nodeView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        nodeView.centerXAnchor.constraint(equalTo: topLineView.centerXAnchor).isActive = true
        
        nodeView.addConstraintsWithFormat("H:|[v0]|", views: iconFlag)
        nodeView.addConstraintsWithFormat("V:|[v0]|", views: iconFlag)
    }
    
}
