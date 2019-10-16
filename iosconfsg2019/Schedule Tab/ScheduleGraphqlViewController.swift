//
//  ScheduleGraphqlViewController.swift
//  iosconfsg2019
//
//  Created by Vina Rianti on 10/10/19.
//  Copyright © 2019 Vina Melody. All rights reserved.
//

import UIKit
import Apollo
import NVActivityIndicatorView

class ScheduleGraphqlViewController: UITableViewController, NVActivityIndicatorViewable {

    private let timelineCellId: String = "timelineCell"
    private let headerViewId: String = "headerView"

    lazy var viewModel: ScheduleGraphqlViewModel = {
        return ScheduleGraphqlViewModel(failInitClosure: {
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
        self.navigationItem.title = "Conference Schedule"
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
}

extension ScheduleGraphqlViewController: ScheduleGraphqlViewModelDelegate {
    func didFetchSchedule() {
        DispatchQueue.main.async {
            self.stopAnimating()
            self.tableView.reloadData()
        }
    }
}

class HeaderTableView: UIView {

    var daySegmentControl: UISegmentedControl!
    var didChangeAction: ((_ selectedIndex: Int) -> Void)?

    init(frame: CGRect, initialItems: [String], selectedIndex: Int, didChangeAction: ((_ selectedIndex: Int) -> Void)?) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        setupView(items: initialItems)
        daySegmentControl.selectedSegmentIndex = selectedIndex
        self.didChangeAction = didChangeAction
        daySegmentControl.addTarget(self, action: #selector(handleChange), for: .valueChanged)
    }

    @objc func handleChange() {
        didChangeAction?(daySegmentControl.selectedSegmentIndex)
    }

    private func setupView(items: [String]) {
        daySegmentControl = UISegmentedControl(items: items)
        daySegmentControl.translatesAutoresizingMaskIntoConstraints = false
        daySegmentControl.tintColor = UIColor.purple
        addSubview(daySegmentControl)
        addConstraintsWithFormat("H:|-16-[v0]-16-|", views: daySegmentControl)
        addConstraintsWithFormat("V:|-8-[v0]-8-|", views: daySegmentControl)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
