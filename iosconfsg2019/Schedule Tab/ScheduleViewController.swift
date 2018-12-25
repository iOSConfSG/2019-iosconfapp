//
//  ViewController.swift
//  iosconfsg2019
//
//  Created by Vina Melody on 3/11/18.
//  Copyright © 2018 Vina Melody. All rights reserved.
//

import UIKit
import RealmSwift

class ScheduleViewController: UITableViewController {
    
    private let viewModel = ScheduleViewModel()

    private let daySegmentControl = UISegmentedControl(items: ["Day 1", "Day 2"])
    private let timelineCellId: String = "timelineCell"
    private let detailCellId: String = "detailCell"

    private var schedule: Results<Talk>?

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.connect()
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
        if let schedule = self.schedule {
            detailViewController.talk = schedule[indexPath.row]
        }
        let _ = self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.schedule?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: timelineCellId) as! TimelineCell
        cell.selectionStyle = .none
        if let schedule = self.schedule {
            cell.talk = schedule[indexPath.row]
        }
        return cell
    }

}

extension ScheduleViewController: ScheduleViewModelDelegate {

    func didDownloadRealm(error: Error?, result: Results<Talk>?) {
        if let error = error {
            // Display error
            print("Realm error: \(error.localizedDescription)")
        }

        if let result = result {
            self.schedule = result
            tableView.reloadData()
            print("Result: \(result)")
        }

        
    }
}

