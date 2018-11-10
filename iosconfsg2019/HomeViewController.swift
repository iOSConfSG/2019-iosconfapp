//
//  ViewController.swift
//  iosconfsg2019
//
//  Created by Vina Melody on 3/11/18.
//  Copyright © 2018 Vina Melody. All rights reserved.
//

import UIKit

class HomeViewController: UITableViewController {
    
    let daySegmentControl = UISegmentedControl(items: ["Day 1", "Day 2"])
    
    private let timelineCellId: String = "timelineCell"
    private let detailCellId: String = "detailCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        tableView.register(TimelineCell.self, forCellReuseIdentifier: timelineCellId)
        tableView.register(DetailCell.self, forCellReuseIdentifier: detailCellId)
        
    }
    
    // MARK: - Private method
    private func setupViews() {
        self.view.backgroundColor = UIColor.white
        
        self.daySegmentControl.selectedSegmentIndex = activeSegmentIndex()
        self.daySegmentControl.addTarget(self, action: #selector(handleChangeDay), for: .valueChanged)
        self.daySegmentControl.tintColor = UIColor.purple
        self.navigationItem.titleView = self.daySegmentControl
    }
    private func activeSegmentIndex() -> Int {
        let today = Date()
        let calendar = Calendar.current
        let component = calendar.dateComponents([.day], from: today)
        
        // Todo: get from config
        if component.day == 17 {
            return 0
        } else {
            return 1
        }
    }
    
    @objc private func handleChangeDay() {
        let selectedIndex = self.daySegmentControl.selectedSegmentIndex
        print("Switch to \(selectedIndex)")
    }

    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = DetailViewController()
        detailViewController.hidesBottomBarWhenPushed = true
        let _ = self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: timelineCellId) as! TimelineCell
        cell.selectionStyle = .none
        return cell
    }

}

