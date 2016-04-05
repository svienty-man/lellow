//
//  DetailViewController.swift
//  Lellow
//
//  Created by Richard Svienty on 3/28/16.
//  Copyright © 2016 Richard Svienty. All rights reserved.
//

import UIKit
import MapKit

let regionRadius: CLLocationDistance = 1000

class DetailViewController: UIViewController, CLLocationManagerDelegate  {
    
    @IBOutlet weak var detailMapView: MKMapView!
    
    @IBOutlet weak var arrivalLabelp: UILabel!
    
    @IBOutlet weak var locationLabelp: UILabel!
    
    @IBOutlet weak var addressLabelp: UILabel!
    
    @IBOutlet weak var latLabelp: UILabel!
    
    @IBOutlet weak var longLabelp: UILabel!
    
    var detailViewInfo: DataModelItem?
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailViewInfo {
            
            // Center Map
            let newLocation = CLLocation(latitude: detail.locationLat!, longitude: detail.locationLong!)
            self.centerMapOnLocation(newLocation)
            
            // Drop Pin
            let new2DLocation = CLLocationCoordinate2DMake(detail.locationLat!, detail.locationLong!)
            let dropPin = MKPointAnnotation()
            dropPin.coordinate = new2DLocation
            dropPin.title = detail.locationName
            detailMapView.addAnnotation(dropPin)
            
            // Set title
            self.title = detail.locationName
            
            // Set the view data
            self.arrivalLabelp.text = "Arrival Time: \(detail.minutes!) minutes"
            self.locationLabelp.text = detail.locationName
            self.addressLabelp.text = detail.locationAddress
            let latString = String(format: "%.2f", detail.locationLat!)
            let longString = String(format: "%.2f", detail.locationLong!)
            self.latLabelp.text = "Lat: \(latString)"
            self.longLabelp.text = "Long: \(longString)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Mark: MapStuffs
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        detailMapView.setRegion(coordinateRegion, animated: true)
    }
    
    // MARK: Rotation
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        if (UIDevice.currentDevice().orientation.isLandscape) {
            print("Device is Landscape")
        } else {
            print("Device is Portrait")
        }
    }
    
    
    
}

