//
//  WorkshopViewController.swift
//  iosconfsg2019
//
//  Created by Vina Melody on 11/1/19.
//  Copyright © 2019 Vina Melody. All rights reserved.
//

import UIKit
//import AttributedTextView
import Apollo
import NVActivityIndicatorView
import NVActivityIndicatorViewExtended

class WorkshopViewController: BaseViewController, NVActivityIndicatorViewable {
    
    private let timelineCellId: String = "timelineCell"
    private let headerViewId: String = "headerView"
    private var tableView: UITableView!

    lazy var viewModel: WorkshopViewModel = {
        return WorkshopViewModel(failInitClosure: {
            handleGraphqlError()
        })
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        viewModel.tryFetchSchedule()
        startAnimating()
    }
    
    private func setupViews() {
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        self.navigationItem.title = "Workshop Schedule"
        view.backgroundColor = .white

        tableView = UITableView(frame: view.frame, style: .plain)

        view.addSubview(tableView)
        view.addConstraintsWithFormat("V:|[v0]|", views: tableView)
        view.addConstraintsWithFormat("H:|[v0]|", views: tableView)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        tableView.register(TimelineCellV2.self, forCellReuseIdentifier: timelineCellId)

        let skylineView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 70))
        if isDarkMode {
            skylineView.image = UIImage(imageLiteralResourceName: "skyline-orange")
        } else {
            skylineView.image = UIImage(imageLiteralResourceName: "skyline")
        }
        skylineView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        skylineView.contentMode = .scaleAspectFill
        self.tableView.tableFooterView = skylineView

        let segmentFrame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44)
        let segmentTitles = viewModel.segmentedControlLabels()
        let selectedIndex = viewModel.segmentedControlSelectedIndex()
        let daySegmentedControlView = HeaderTableView(frame: segmentFrame, initialItems: segmentTitles, selectedIndex: selectedIndex, didChangeAction: { [weak self] (selectedIndex) in
            self?.viewModel.selectedDay = selectedIndex
            self?.tableView.reloadData()
        })
        self.tableView.tableHeaderView = daySegmentedControlView

        viewModel.delegate = self
    }

    func handleGraphqlError() {
        stopAnimating()
    }

    private func logTap(talkTitle: String) {
        let event = TrackingEvent(tap: "Workshop Detail - \(talkTitle)", category: "Workshop Detail")
        AnalyticsManager.shared.log(event: event)
    }
}

extension WorkshopViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows = viewModel.numberOfRows()
        if isDarkMode {
            tableView.tableFooterView?.backgroundColor = numberOfRows % 2 == 0 ? StyleSheet.shared.theme.secondaryBackgroundColor : UIColor.black

        } else {
            tableView.tableFooterView?.backgroundColor = numberOfRows % 2 == 0 ? StyleSheet.shared.theme.secondaryBackgroundColor : StyleSheet.shared.theme.primaryBackgroundColor
        }
        return numberOfRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: timelineCellId) as! TimelineCellV2
        if let talk = viewModel.getTalkForIndexpath(indexPath: indexPath) {
            cell.setupCell(talk: talk)
        }
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = StyleSheet.shared.theme.primaryBackgroundColor
        } else {
            cell.backgroundColor = StyleSheet.shared.theme.secondaryBackgroundColor
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let talk = viewModel.getTalkForIndexpath(indexPath: indexPath) {
            let detailViewController = DetailGraphqlViewController()
            detailViewController.hidesBottomBarWhenPushed = true
            detailViewController.talk = talk
            logTap(talkTitle: talk.title)
            let _ = self.navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}

extension WorkshopViewController: WorkshopViewModelDelegate {
    func didFetchSchedule() {
        DispatchQueue.main.async {
            self.stopAnimating()
            self.tableView.reloadData()
        }
    }
}
