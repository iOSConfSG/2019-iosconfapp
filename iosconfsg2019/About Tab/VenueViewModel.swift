//
//  VenueViewModel.swift
//  iosconfsg2019
//
//  Created by Hotha Santhanakrishnan Swarup on 5/1/20.
//  Copyright © 2020 Vina Melody. All rights reserved.
//

import Foundation
import MapKit
import Contacts

class VenueViewModel {
    private(set) var venues: [Venue] = {
        let cPlaceMark = MKPlacemark.init(coordinate: CLLocationCoordinate2D(latitude: 1.292790, longitude: 103.770770),
                                          addressDictionary: [CNPostalAddressStreetKey: "11 Kent Ridge Drive",
                                                              CNPostalAddressPostalCodeKey: "119244",
                                                              CNPostalAddressCityKey: "Singapore",
                                                              CNPostalAddressISOCountryCodeKey: "SG"])
        let conferenceVenue = Venue(title: "Conference",
                                    address: "11 Kent Ridge Drive Singapore 119244",
                                    placeMark: cPlaceMark)
        let workshopVenue = Venue(title: "Workshop",
                                  address: "11 Kent Ridge Drive Singapore 119244",
                                  placeMark: cPlaceMark)
        let aPlaceMark = MKPlacemark.init(coordinate: CLLocationCoordinate2D(latitude: 1.292790, longitude: 103.770770),
                                          addressDictionary: [CNPostalAddressStreetKey: "11 Kent Ridge Drive",
                                                              CNPostalAddressPostalCodeKey: "119244",
                                                              CNPostalAddressCityKey: "Singapore",
                                                              CNPostalAddressISOCountryCodeKey: "SG"])
        let afterPartyVenue = Venue(title: "After Party",
                                    address: "11 Kent Ridge Drive Singapore 119244",
                                    placeMark: cPlaceMark)
        return [conferenceVenue, workshopVenue, afterPartyVenue]
    }()

    var canOpenGoogleMaps: Bool {
        let googleURL: URL! = URL(string: "comgooglemaps://")
        return UIApplication.shared.canOpenURL(googleURL)
    }
}
