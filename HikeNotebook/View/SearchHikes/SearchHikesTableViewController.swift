//
//  SearchHikesTableViewController.swift
//  HikeNotebook
//
//  Created by Ella  Neumarker on 4/13/20.
//  Copyright © 2020 Ella Neumarker. All rights reserved.
//

import UIKit
import MapKit

class SearchHikesTableViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
   
    let spinner = UIActivityIndicatorView(style: .large)
    
    var items = [HikeListItem]()
    var hikeListController = HikeListNetworkController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
//        spinner.startAnimating()
//        tableView.backgroundView = spinner
    }
    
    // MARK: CLLocation Implementation
    
    func getLocation(forPlaceCalled name: String, completion: @escaping(CLLocation?) -> Void) {
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(name) { (placemarks, error) in
            
            guard error == nil else {
                print("Error")
                completion(nil)
                return
            }
            
            guard let placemark = placemarks?[0] else {
                print("Error placemark is nil")
                completion(nil)
                return
            }
            
            guard let location = placemark.location else {
                print("Error placemark is nil")
                completion(nil)
                return
            }
            
            completion(location)
        }
    }
    
    // MARK: API Caller
    
    func fetchHikeInformation() {
        
        self.items = []
        self.tableView.reloadData()
        
        let searchTerm = searchBar.text ?? ""
        
        if !searchTerm.isEmpty {
            
//            let query: [String: String] = [
//                "lat": searchTerm
//            ]
            let location = CLLocation(latitude: 40.0274, longitude: -105.2519)
            hikeListController.fetchItems(matching: [:], location: location) { (fetchItems) in
                if let fetchItems = fetchItems {
                    DispatchQueue.main.async {
                        self.items = fetchItems
                        self.tableView.reloadData()
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
    }
}

