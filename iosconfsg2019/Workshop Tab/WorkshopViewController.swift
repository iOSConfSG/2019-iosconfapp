//
//  WorkshopViewController.swift
//  iosconfsg2019
//
//  Created by Vina Melody on 11/1/19.
//  Copyright © 2019 Vina Melody. All rights reserved.
//

import UIKit
import AttributedTextView
import Apollo
import NVActivityIndicatorView

class WorkshopViewController: UITableViewController, NVActivityIndicatorViewable {
    
    private let timelineCellId: String = "timelineCell"
    private let headerViewId: String = "headerView"

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

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        tableView.register(TimelineCellV2.self, forCellReuseIdentifier: timelineCellId)

        let skylineView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 70))
        skylineView.image = UIImage(imageLiteralResourceName: "skyline")
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
        print("Something wrong with Graphql connection")
    }

    // MARK: - UITableViewDelegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: timelineCellId) as! TimelineCellV2
        if let talk = viewModel.getTalkForIndexpath(indexPath: indexPath) {
            cell.setupCell(talk: talk)
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let talk = viewModel.getTalkForIndexpath(indexPath: indexPath) {
            let detailViewController = DetailGraphqlViewController()
            detailViewController.hidesBottomBarWhenPushed = true
            detailViewController.talk = talk
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
