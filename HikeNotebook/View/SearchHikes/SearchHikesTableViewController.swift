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
    
    let spinner = UIActivityIndicatorView(style: .large)
    
    let hikeListController: HikeListController = HikeListNetworkController()
    var hikeList: HikeList = HikeList(trails: [])
//    var selectedHike: HikeListItem?
//    var hike: Hikes?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spinner.startAnimating()
        tableView.backgroundView = spinner
        
       fetchHikeInfo()
    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return hikeList.trails.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let certainHike = hikeList.trails[indexPath.row]
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
        
        let certainHike = hikeList.trails[indexPath.row]
        
        cell.hikeNameLabel.text = certainHike.name
        cell.summaryLabel.text = certainHike.summary
        cell.distanceLabel.text = String(certainHike.length)
        cell.locationLabel.text = certainHike.location
        
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    // MARK: Api Caller

    
    func fetchHikeInfo() {
        hikeListController.getHikeList { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let hikeList):
                    print(hikeList)
                    self.hikeList = hikeList
                    self.tableView.reloadData()
                case .failure:
                    let alert = UIAlertController(title: "Error", message: "Failed to load data.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
}

