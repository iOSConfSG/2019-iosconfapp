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
    
    private let kSecondDay: Date = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return df.date(from: "2019-01-19")!
    }()
    
    private let kFirstDay: Date = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return df.date(from: "2019-01-18")!
    }()
    
    let daySegmentControl = UISegmentedControl(items: ["18 Jan", "19 Jan"])
    
    private let timelineCellId: String = "timelineCell"
    
    var day1: [Talk] = []
    var day2: [Talk] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        getSchedule()
        
        tableView.register(TimelineCell.self, forCellReuseIdentifier: timelineCellId)
    }
    
    // MARK: - Private method
    private func getSchedule() {
        let dbRef = Database.database().reference()
        let scheduleRef = dbRef.child("schedule")
        scheduleRef.keepSynced(true)
        
        scheduleRef.observe(.childAdded) { (snapshot) in
            let talk = Talk(snapshot: snapshot)
            talk.reloadSpeakerData()
            
            switch talk.day {
            case 1:
                self.day1.append(talk)
            default:
                self.day2.append(talk)
            }
            
            #if DEBUG
            print("Got talk: \(talk.title)")
            #endif
        }
        
        scheduleRef.observe(.childChanged) { (snapshot) in
            let newTalk = Talk(snapshot: snapshot)
            newTalk.reloadSpeakerData()
            
            switch newTalk.day {
            case 1:
                let index = self.day1.firstIndex(where: { (talk) -> Bool in
                    return talk.firebaseId == newTalk.firebaseId
                })
                
                if let talkIndex = index {
                    self.day1.remove(at: talkIndex)
                    self.day1.insert(newTalk, at: talkIndex)
                }
            default:
                let index = self.day2.firstIndex(where: { (talk) -> Bool in
                    return talk.firebaseId == newTalk.firebaseId
                })
                
                if let talkIndex = index {
                    self.day2.remove(at: talkIndex)
                    self.day2.insert(newTalk, at: talkIndex)
                }
            }
            
            
            
        }
        
        scheduleRef.observe(.value) { (snapshot) in
            self.reloadData()
        }
        
    }
    
    private func isSecondDay() -> Bool {
        let today = Date()
        
        let isSecondDay = Calendar.current.compare(today, to: kSecondDay, toGranularity: .day)
        
        switch isSecondDay {
        case .orderedSame:
            return true
        default:
            return false
        }
    }
    
    private func reloadData() {
        OperationQueue.main.addOperation {
            self.tableView.reloadData()
        }
    }
    
    private func setupViews() {
        self.view.backgroundColor = UIColor.white
        
        self.daySegmentControl.selectedSegmentIndex = isSecondDay() ? 1 : 0
        self.daySegmentControl.addTarget(self, action: #selector(handleChangeDay), for: .valueChanged)
        self.daySegmentControl.tintColor = UIColor.purple
        self.navigationItem.titleView = self.daySegmentControl
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = UITableView.automaticDimension
        
        
//        self.tableView.separatorInset.right = self.tableView.separatorInset.left
    }
    
    @objc private func handleChangeDay() {
        let selectedIndex = self.daySegmentControl.selectedSegmentIndex
        print("Switch to \(selectedIndex)")
        self.reloadData()
    }

    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = DetailViewController()
        detailViewController.hidesBottomBarWhenPushed = true
        let _ = self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.daySegmentControl.selectedSegmentIndex == 1 {
            return self.day2.count
        } else {
            return self.day1.count
        }
    }
    
//    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.row == 0 {
//            return UITableView.automaticDimension
//        } else {
//            return 98.0
//        }
//        return UITableView.automaticDimension
//    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.row == 0 {
//            return UITableView.automaticDimension
//        } else {
//            return 98.0
//        }
//        return 80
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: timelineCellId) as! TimelineCell
        cell.accessoryType = .disclosureIndicator
        cell.separatorInset = .zero
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        } else {
            cell.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        }
        
        if self.daySegmentControl.selectedSegmentIndex == 1 {
            cell.talk = self.day2[indexPath.row]
        } else {
            cell.talk = self.day1[indexPath.row]
        }
        return cell
    }
    
    

}

