//
//  MasterViewController.swift
//  Lellow
//
//  Created by Richard Svienty on 3/28/16.
//  Copyright © 2016 Richard Svienty. All rights reserved.
//

import UIKit
import CoreLocation

class MasterViewController: UITableViewController, modelObserver, CLLocationManagerDelegate {
    
    var detailViewController: DetailViewController? = nil
    
    var myDataModel = LellowDataModel()
    
    var locationManager: CLLocationManager!
    
    var sortViewController: SortViewController?
    
    var sortActive: Bool = false
    
    @IBOutlet var masterTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let addButton = UIBarButtonItem(title: "Sort", style: .Plain, target: self, action: #selector(MasterViewController.SortDataItems(_:)))
        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        // Need this to get the current location for the sort
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        // Set up Data Model
        myDataModel.setObserver(self)
        myDataModel.fetchData()
        
        // Set up pop up
        self.sortViewController = SortViewController(nibName: "SortViewController", bundle: nil)
        self.sortViewController!.preferredContentSize = CGSizeMake(250, 250);
    }
    
    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkForSortActive() {
        if (sortActive) {
            sortActive = false
            self.sortViewController?.removeAnimate()
        }
    }
    
    func SortDataItems(sender: AnyObject) {
        if (!sortActive) {
            print("Sort View Controller Enabled")
            self.sortViewController?.title = "Sort View Controller"
            self.sortViewController?.showInView(self.view, animated: true, dataModel: myDataModel)
            sortActive = true
        }
        else {
            checkForSortActive()
        }
    }
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                self.checkForSortActive()
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailViewInfo = myDataModel.arrayOfItems[indexPath.row]
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    // MARK: - Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myDataModel.arrayOfItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        let object = myDataModel.arrayOfItems[indexPath.row]
        cell.textLabel!.text = object.locationName!
        cell.detailTextLabel!.text = object.locationAddress!
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
    // MARK: modelObserver
    
    func dataAvailable() {
        print("Data is available from data model")
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.masterTableView.reloadData()
        })
        
        self.checkForSortActive()
    }
    
    // Mark: CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        let location = locations.last! as CLLocation
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        print("Center = \(center)")
        print("location = \(location)")
        locationManager.stopUpdatingLocation()
        
        // Inform the data model
        myDataModel.processDistance(location.coordinate.latitude, long: location.coordinate.longitude)
        print("\n\nStopping Location Services!!!! - just need the one for now\n\n")
    }
    
    // MARK: Rotation
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        // This is a tradeoff until we can solve using dynamic constraints to ensure proper placement
        // of the popup.
        self.checkForSortActive()
        
        if (UIDevice.currentDevice().orientation.isLandscape) {
            print("Device is Landscape")
        } else {
            print("Device is Portrait")
        }
    }
    
    
}

