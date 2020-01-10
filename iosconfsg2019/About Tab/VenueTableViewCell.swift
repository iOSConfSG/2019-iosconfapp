//
//  VenueTableViewCell.swift
//  iosconfsg2019
//
//  Created by Hotha Santhanakrishnan Swarup on 5/1/20.
//  Copyright © 2020 Vina Melody. All rights reserved.
//

import UIKit
import MapKit

class VenueTableViewCell: UITableViewCell {

    var mapView: MKMapView = {
        let mapView = MKMapView(frame: CGRect.zero)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.isZoomEnabled = false
        mapView.isScrollEnabled = false
        return mapView
    }()

    var titleLabel: UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = StyleSheet.shared.theme.primaryLabelColor
        label.font = UIFont.boldSystemFont(ofSize: UIFont.largeSize)
        return label
    }()

    var addressTextView: UITextView = {
        let textView = UITextView.init(frame: CGRect.zero)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = StyleSheet.shared.theme.secondaryLabelColor
        textView.font = UIFont.boldSystemFont(ofSize: UIFont.normalSize)
        textView.isScrollEnabled = false
        textView.dataDetectorTypes = .address
        textView.isSelectable = true
        textView.isEditable = false
        return textView
    }()

    var venue: Venue?
    var annotation: MKPointAnnotation?
    var tapAction: (() -> Void)?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }

    private func configureView() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(addressTextView)
        contentView.addSubview(mapView)

        let marginGuide = contentView.layoutMarginsGuide
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor),
            addressTextView.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor, constant: -4),
            addressTextView.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor),
            addressTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0),
            mapView.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor),
            mapView.topAnchor.constraint(equalTo: addressTextView.bottomAnchor, constant: 10),
            mapView.heightAnchor.constraint(equalToConstant: 200),
            mapView.bottomAnchor.constraint(lessThanOrEqualTo: marginGuide.bottomAnchor),
        ])

        // add tap gesture on maps
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(mapViewAction))
        tapGesture.numberOfTapsRequired = 1
        mapView.addGestureRecognizer(tapGesture)
    }

    @objc func mapViewAction() {
        tapAction?()
    }

    func configure(venue: Venue, tapAction: (() -> Void)?) {
        self.venue = venue
        titleLabel.text = venue.title
        addressTextView.text = venue.address
        // set map region
        let region = MKCoordinateRegion.init(center: venue.placeMark.coordinate, span: MKCoordinateSpan.init(latitudeDelta: 0.005, longitudeDelta: 0.005))
        mapView.setRegion(region, animated: true)
        // add annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = venue.placeMark.coordinate
        annotation.title = venue.address
        mapView.addAnnotation(annotation)
        self.tapAction = tapAction
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        if let annotation = annotation  {
            mapView.removeAnnotation(annotation)
        }
    }
}
