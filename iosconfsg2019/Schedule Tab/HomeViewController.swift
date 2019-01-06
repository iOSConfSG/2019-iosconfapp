//
//  ViewController.swift
//  iosconfsg2019
//
//  Created by Vina Melody on 3/11/18.
//  Copyright © 2018 Vina Melody. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ScheduleViewController: UITableViewController {
    
    let daySegmentControl = UISegmentedControl(items: ["Day 1", "Day 2"])
    
    private let timelineCellId: String = "timelineCell"
    private let detailCellId: String = "detailCell"
    
    var schedule: [Talk] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        tableView.register(TimelineCell.self, forCellReuseIdentifier: timelineCellId)
        tableView.register(DetailCell.self, forCellReuseIdentifier: detailCellId)
        
        getSchedule()
        
    }
    
    // MARK: - Private method
    private func getSchedule() {
        let dbRef = Database.database().reference()
        let scheduleRef = dbRef.child("schedule")
        scheduleRef.keepSynced(true)
        
        scheduleRef.observe(.childAdded) { (snapshot) in
            let talk = Talk(snapshot: snapshot)
            self.schedule.append(talk)
            
            #if DEBUG
            print("Got talk: \(talk.title)")
            #endif
        }
        
        scheduleRef.observe(.childChanged) { (snapshot) in
            let newTalk = Talk(snapshot: snapshot)
            
            let index = self.schedule.firstIndex(where: { (talk) -> Bool in
                return talk.firebaseId == newTalk.firebaseId
            })
            
            if let talkIndex = index {
                self.schedule.remove(at: talkIndex)
                self.schedule.insert(newTalk, at: talkIndex)
            }
            
        }
        
        scheduleRef.observe(.value) { (snapshot) in
            self.reloadData()
        }
        
    }
    
    private func reloadData() {
        OperationQueue.main.addOperation {
            self.tableView.reloadData()
        }
    }
    
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
        return self.schedule.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: timelineCellId) as! TimelineCell
        cell.talk = self.schedule[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }

}

