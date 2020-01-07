//
//  VenueViewController.swift
//  iosconfsg2019
//
//  Created by Hotha Santhanakrishnan Swarup on 2/1/20.
//  Copyright © 2020 Vina Melody. All rights reserved.
//

import UIKit
import MapKit

class VenueViewController: UITableViewController {

    let viewModel = VenueViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }

        self.navigationItem.title = "Venue"
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.tableFooterView = UIView()
        // register cells
        tableView.register(VenueTableViewCell.self, forCellReuseIdentifier: "cell")
    }
}

extension VenueViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.venues.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let venue = viewModel.venues[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! VenueTableViewCell
        cell.selectionStyle = .none
        cell.separatorInset = .zero
        cell.configure(venue: venue) { 
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
    func showAlert(with placemark: MKPlacemark) {
        let alert = UIAlertController(title: "Open in", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Apple Maps", style: .default) { _ in
            self.openInAppleMaps(placemark: placemark)
        })

        alert.addAction(UIAlertAction(title: "Google Maps", style: .default) { _ in
            self.openInGoogleMaps(placemark: placemark)
        })

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true)
    }

    func openInAppleMaps(placemark: MKPlacemark) {
        MKMapItem(placemark: placemark).openInMaps(launchOptions: nil)
    }

    func openInGoogleMaps(placemark: MKPlacemark) {
        let url: URL! = URL(string:
            "comgooglemaps-x-callback://" +
            "?daddr=\(placemark.coordinate.latitude),\(placemark.coordinate.longitude)")
        UIApplication.shared.open(url)
    }
}
