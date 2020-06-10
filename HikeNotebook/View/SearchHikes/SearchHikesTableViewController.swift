//
//  SearchHikesTableViewController.swift
//  HikeNotebook
//
//  Created by Ella  Neumarker on 4/13/20.
//  Copyright © 2020 Ella Neumarker. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class SearchHikesTableViewController: UITableViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
   
    let spinner = UIActivityIndicatorView(style: .large)
    
    var items = [HikeListItem]()
    var hikeListController = HikeListNetworkController()
    let locationManager = CLLocationManager()
    var shouldShowSearchResults = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    
        searchBar.delegate = self
//        spinner.startAnimating()
//        tableView.backgroundView = spinner
    }
    
    // MARK: CLLocation Implementation
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            
            print(location.coordinate)
            
            self.items = []
            self.tableView.reloadData()
            
            hikeListController.fetchItems(location: location.coordinate) { (fetchItems) in
                if let fetchItems = fetchItems {
                    DispatchQueue.main.async {
                        self.items = fetchItems
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == CLAuthorizationStatus.denied) {
            showLocationDisabledPopUp()
        }
    }
    
    func showLocationDisabledPopUp() {
        let alertController = UIAlertController(title: "Background Location Access Disabled", message: "In order to find hikes near you we need your location or you can manually search a location.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        alertController.addAction(openAction)
        self.present(alertController, animated: true, completion: nil)
    }
   
    // MARK: API Caller
    
    func fetchHikeInformation() {
        
        self.items = []
        self.tableView.reloadData()
        
        let searchTerm = searchBar.text ?? ""
        let geocoder = CLGeocoder()
        
        if !searchTerm.isEmpty {
            
            geocoder.geocodeAddressString(searchTerm) { (placemarks, error) in
                self.processResponse(withPlacemarks: placemarks, error: error)
            }
    
        }
    }
    
    func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        
        if let error = error {
            print("Unable to Forward Geocode Address \(error)")
        } else {
            
            var location: CLLocation?
            
            if let placemarks = placemarks, placemarks.count > 0 {
                location = placemarks.first?.location
            }
            
            if let location = location {
                let coordinate = location.coordinate
                
                hikeListController.fetchItems(location: coordinate) { (fetchItems) in
                    if let fetchItems = fetchItems {
                        DispatchQueue.main.async {
                            self.items = fetchItems
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let certainHike = items[indexPath.row]
        let latitude: CLLocationDegrees = certainHike.latitude
        let longitude: CLLocationDegrees = certainHike.longitude
        
        let regionDistance: CLLocationDistance = 1000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        
        let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]
        
        let placemark = MKPlacemark(coordinate: coordinates)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = certainHike.name
        mapItem.openInMaps(launchOptions: options)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "hikeCell", for: indexPath) as! SearchHikesTableViewCell
        
        let certainHike = items[indexPath.row]
        
        cell.hikeNameLabel.text = certainHike.name
        cell.summaryLabel.text = certainHike.summary
        cell.distanceLabel.text = String(certainHike.length)
        cell.locationLabel.text = certainHike.location
        
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
}

extension SearchHikesTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        fetchHikeInformation()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Search bar is working.")
    }
}

