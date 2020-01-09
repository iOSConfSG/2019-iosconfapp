//
//  VenueViewController.swift
//  iosconfsg2019
//
//  Created by Hotha Santhanakrishnan Swarup on 2/1/20.
//  Copyright © 2020 Vina Melody. All rights reserved.
//

import UIKit
import MapKit

class VenueViewController: BaseViewController {

    let viewModel = VenueViewModel()
    private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        self.navigationItem.title = "Venue"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: isDarkMode ? UIColor.orange : UIColor.purple]

        // configure tableview
        tableView = UITableView(frame: view.frame, style: .plain)
        view.addSubview(tableView)
        view.addConstraintsWithFormat("V:|[v0]|", views: tableView)
        view.addConstraintsWithFormat("H:|[v0]|", views: tableView)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        // register cells
        tableView.register(VenueTableViewCell.self, forCellReuseIdentifier: "cell")
    }
}

extension VenueViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.venues.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let venue = viewModel.venues[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! VenueTableViewCell
        cell.selectionStyle = .none
        cell.separatorInset = .zero
        cell.configure(venue: venue) {
            self.logTap(event: "map")
            if self.viewModel.canOpenGoogleMaps {
                self.showAlert(with: venue.placeMark)
            } else {
                self.openInAppleMaps(placemark: venue.placeMark)
            }
        }

        return cell
    }
}

extension VenueViewController {
    func showAlert(with venue: Venue) {
        let alert = UIAlertController(title: "Open in", message: nil, preferredStyle: .actionSheet)

        let appleMapsAction = UIAlertAction(title: "Apple Maps", style: .default) { _ in
            self.openInAppleMaps(placemark: venue.placeMark)
        }
        let googleMapsAction = UIAlertAction(title: "Google Maps", style: .default) { _ in
            self.openInGoogleMaps(placemarkString: venue.placeMarkString)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        appleMapsAction.setValue(isDarkMode ? UIColor.orange : UIColor.purple, forKey: "titleTextColor")
        googleMapsAction.setValue(isDarkMode ? UIColor.orange : UIColor.purple, forKey: "titleTextColor")
        cancelAction.setValue(isDarkMode ? UIColor.white : UIColor.darkGray, forKey: "titleTextColor")
        alert.addAction(appleMapsAction)
        alert.addAction(googleMapsAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }

    func openInAppleMaps(placemark: MKPlacemark) {
        logTap(event: "Apple Maps")
        MKMapItem(placemark: placemark).openInMaps(launchOptions: nil)
    }

    func openInGoogleMaps(placemark: MKPlacemark) {
        logTap(event: "Google Maps")
        let url: URL! = URL(string:
            "comgooglemaps-x-callback://" +
            "?daddr=\(placemark.coordinate.latitude),\(placemark.coordinate.longitude)")
        UIApplication.shared.open(url)
    }

    private func logTap(event: String) {
        let event = TrackingEvent(tap: event, category: "Venue")
        AnalyticsManager.shared.log(event: event)
    }
}
