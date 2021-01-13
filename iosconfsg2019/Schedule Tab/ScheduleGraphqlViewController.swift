//
//  ScheduleGraphqlViewController.swift
//  iosconfsg2019
//
//  Created by Vina Rianti on 10/10/19.
//  Copyright © 2019 Vina Melody. All rights reserved.
//

import UIKit
import Apollo
import NVActivityIndicatorViewExtended

class ScheduleGraphqlViewController: BaseViewController, NVActivityIndicatorViewable {

    private let timelineCellId: String = "timelineCell"
    private let headerViewId: String = "headerView"
    private var tableView: UITableView!
    var daySegmentedControlView: HeaderTableView?
    
    private let rezoneButton: UIBarButtonItem = {
        let btn = UIBarButtonItem()
        return btn
    }()

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
        navigationItem.title = "Conference Schedule"
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

        let segmentFrame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: DateTimeUtils.shared.shouldEnableZoneToggle() ? 64 : 44)
        let segmentTitles = viewModel.segmentedControlLabels()
        let selectedIndex = viewModel.segmentedControlSelectedIndex()
        daySegmentedControlView = HeaderTableView(frame: segmentFrame, initialItems: segmentTitles, selectedIndex: selectedIndex, didChangeAction: { [weak self] (selectedIndex) in
            self?.viewModel.selectedDay = selectedIndex
            self?.tableView.reloadData()
        })
        self.tableView.tableHeaderView = daySegmentedControlView

        viewModel.delegate = self
        if DateTimeUtils.shared.shouldEnableZoneToggle() {
            rezoneButton.style = .plain
            rezoneButton.target = self
            rezoneButton.action = #selector(changeTimezone)
            rezoneButton.title = DateTimeUtils.shared.titleForRezoneButton()
            navigationItem.rightBarButtonItem = rezoneButton
        }        
    }
    
    @objc private func changeTimezone() {
        DateTimeUtils.shared.toggleSelectedTimezone()
        rezoneButton.title = DateTimeUtils.shared.titleForRezoneButton()
        daySegmentedControlView?.timezoneLabel.attributedText = DateTimeUtils.shared.titleForCurrentZoneInfo()
        tableView.reloadData()        
    }

    func handleGraphqlError() {
        stopAnimating()
    }

    private func logTap(talkId: Int) {
        let event = TrackingEvent(tap: "Activity \(talkId)", category: "Activity Detail")
        AnalyticsManager.shared.log(event: event)
    }
}

extension ScheduleGraphqlViewController: UITableViewDataSource, UITableViewDelegate {
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
            logTap(talkId: talk.id)
            let _ = self.navigationController?.pushViewController(detailViewController, animated: true)
        }
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
    
    let timezoneLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: UIFont.smallSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let timezoneContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = StyleSheet.shared.theme.secondaryBackgroundColor
        return view
    }()

    init(frame: CGRect, initialItems: [String], selectedIndex: Int, didChangeAction: ((_ selectedIndex: Int) -> Void)?) {
        super.init(frame: frame)
        backgroundColor = StyleSheet.shared.theme.primaryBackgroundColor
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
        daySegmentControl.tintColor = StyleSheet.shared.theme.primaryLabelColor
        daySegmentControl.backgroundColor = StyleSheet.shared.theme.secondaryBackgroundColor
        addSubview(daySegmentControl)
        
        if DateTimeUtils.shared.shouldEnableZoneToggle() {
            timezoneContainer.addSubview(timezoneLabel)
            timezoneContainer.addConstraintsWithFormat("H:|[v0]|", views: timezoneLabel)
            timezoneContainer.addConstraintsWithFormat("V:|-4-[v0]-4-|", views: timezoneLabel)
            addSubview(timezoneContainer)
            
            addConstraintsWithFormat("H:|[v0]|", views: timezoneContainer)
            addConstraintsWithFormat("H:|-16-[v0]-16-|", views: daySegmentControl)
            addConstraintsWithFormat("V:|-8-[v0]-2-[v1(22)]-8-|", views: daySegmentControl, timezoneContainer)
            
            timezoneContainer.isHidden = false
            timezoneLabel.attributedText = DateTimeUtils.shared.titleForCurrentZoneInfo()
        } else {
            timezoneContainer.isHidden = true
            addConstraintsWithFormat("H:|-16-[v0]-16-|", views: daySegmentControl)
            addConstraintsWithFormat("V:|-8-[v0]-8-|", views: daySegmentControl)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

