//
//  WorkshopViewController.swift
//  iosconfsg2019
//
//  Created by Vina Melody on 11/1/19.
//  Copyright © 2019 Vina Melody. All rights reserved.
//

import UIKit
import AttributedTextView
import FirebaseDatabase

class WorkshopViewController: UIViewController {
    
    private let timelineCellId: String = "timelineCell"
    var schedule: [Talk] = []
    
    let locationView: AttributedTextView = {
        let view = AttributedTextView()
        view.isUserInteractionEnabled = true
        view.isEditable = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.bounces = false
        view.textContainerInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        return view
    }()
    
    let tableView: UITableView = {
        let tbl = UITableView()
        tbl.translatesAutoresizingMaskIntoConstraints = false
        return tbl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        tableView.register(TimelineCell.self, forCellReuseIdentifier: timelineCellId)
//        locationView.setContentOffset(.zero, animated: false)
        getSchedule()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    private func setupViews() {
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "Workshop"
        
        self.view.addSubview(locationView)
        self.view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            locationView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0),
            locationView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0),
            locationView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor, constant: 0),
            locationView.heightAnchor.constraint(equalToConstant: 140),
            tableView.topAnchor.constraint(equalTo: locationView.bottomAnchor, constant: 10),
            tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0),
            tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor, constant: 0)
            ])
        
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 80
        
        locationView.attributer =
            "Workshop Location".purple.font(UIFont.boldSystemFont(ofSize: UIFont.largeSize))
            .append("\n\n")
            .append("PlugIn@BLK71\n")
            .append("71 Ayer Rajah Crescent, 02-18, Singapore 139951\n")
                .append("https://goo.gl/maps/vZB8otAC5yL2").matchLinks.makeInteract({ (link) in
                    guard let url = URL(string: link) else {
                        return
                    }
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                })
            .append("\n\nWorkshop Schedule").purple.font(UIFont.boldSystemFont(ofSize: UIFont.largeSize))
    }
    
    private func getSchedule() {
        let dbRef = Database.database().reference()
        let scheduleRef = dbRef.child("workshop")
        scheduleRef.keepSynced(true)
        
        scheduleRef.observe(.childAdded) { (snapshot) in
            let talk = Talk(snapshot: snapshot)
            talk.reloadSpeakerData()
            self.schedule.append(talk)
            
            self.reloadData()
        }
        
        scheduleRef.observe(.childChanged) { (snapshot) in
            let newTalk = Talk(snapshot: snapshot)
            newTalk.reloadSpeakerData()
            
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
}

extension WorkshopViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.schedule.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: timelineCellId) as! TimelineCell
        cell.accessoryType = .disclosureIndicator
        cell.separatorInset = .zero
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        } else {
            cell.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        }
        
        cell.talk = self.schedule[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = DetailViewController()
        detailViewController.hidesBottomBarWhenPushed = true
        
        detailViewController.talk = self.schedule[indexPath.row]
        
        let _ = self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
}
