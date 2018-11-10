//
//  ViewController.swift
//  iosconfsg2019
//
//  Created by Vina Melody on 3/11/18.
//  Copyright © 2018 Vina Melody. All rights reserved.
//

import UIKit

class HomeViewController: UITableViewController {
    
    private let timelineCellId: String = "timelineCell"
    private let detailCellId: String = "detailCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        tableView.register(TimelineCell.self, forCellReuseIdentifier: timelineCellId)
        tableView.register(DetailCell.self, forCellReuseIdentifier: detailCellId)
        
    }

    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let _ = self.navigationController?.pushViewController(DetailViewController(), animated: true)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: timelineCellId) as! TimelineCell
        return cell
    }

}

