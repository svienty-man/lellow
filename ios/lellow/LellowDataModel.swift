//
//  LellowDataModel.swift
//  Lellow
//
//  Created by Richard Svienty on 3/28/16.
//  Copyright © 2016 Richard Svienty. All rights reserved.
//

import Foundation
import CoreLocation

let dataURL = "http://localhost:8080/questions"

enum sortOrder {
    case nameOrder
    case distanceOrder
    case arrivalOrder
}

struct DataModelItem {
    let locationName : String?
    let locationAddress : String?
    let arrivalTime : String?
    let locationID : Int?
    let locationLat : Double?
    let locationLong : Double?
    let minutes: Int?
    var distance: Double?
}

protocol modelObserver {
    func dataAvailable()
}

class LellowDataModel {
    
    // This holds a basic flat data model.
    var arrayOfItems: Array<DataModelItem> = Array()
    
    // This is the current sort method
    var sortMethod: sortOrder?
    
    // This is the model observer
    var observer: modelObserver?
    
    // My current location
    var myLat: Double?
    var myLong: Double?
    
    func setObserver(obs: modelObserver) {
        self.observer = obs
    }
    
    func sortData(sortBy: sortOrder) {
        switch sortBy {
        case .nameOrder:
            self.arrayOfItems.sortInPlace { $0.locationName < $1.locationName }
            self.sortMethod = .nameOrder
        case .distanceOrder:
            self.calculateDistances()
            self.arrayOfItems.sortInPlace { $0.distance < $1.distance }
            self.sortMethod = .distanceOrder
            print(arrayOfItems)
        case .arrivalOrder:
            self.arrayOfItems.sortInPlace { $0.minutes < $1.minutes }
            self.sortMethod = .arrivalOrder
        }
        self.observer?.dataAvailable()
    }
    
    func parseData(jsonData: NSData?) {
        // Note: Below code gives strange warning "Cast from 'XCUIElement!' to unrelated String always fails."
        // When included in test target. So removing the test target for now. Looks like a known issue googling around.'
        //
        // Also going to unpack this in a slow and methodical way. Unpacking JSON in Swift has some unique challenges
        // with casting and unwrapping. Likely there is some library available or let's get more experience and
        // then optimize the code. Or use: https://github.com/hkellaway/Gloss
        do{
            let json = try NSJSONSerialization.JSONObjectWithData(jsonData!, options:.AllowFragments)
            
            // There must be a better way to iterate from json - but can't find the magic
            for i in 0 ..< json.count  {
                let newItem = json[i]
                print(newItem["Name"] as! String)
                
                let name = newItem["Name"] as? String
                let address = newItem["Address"]  as? String
                let arrTime = newItem["ArrivalTime"] as? String
                let locationID = newItem["ID"] as? Int
                let locationLat = newItem["Latitude"] as? Double
                let locationLong = newItem["Longitude"] as? Double
                
                let locMinutes = self.processDateString(arrTime!)
                let tempDistance = Double.init(0)
                
                let newThing = DataModelItem (
                    locationName: name,
                    locationAddress: address,
                    arrivalTime: arrTime,
                    locationID: locationID,
                    locationLat: locationLat,
                    locationLong: locationLong,
                    minutes: locMinutes,
                    distance: tempDistance
                )
                
                // Append new item to data model array
                self.arrayOfItems.append(newThing)
            }
            
            // Initially sort by name
            self.sortData(.nameOrder)
            print(self.arrayOfItems)
        }catch {
            print("Error with Json: \(error)")
        }

    }
    
    func fetchData() {
        let requestURL: NSURL = NSURL(string: dataURL)!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) -> Void in
            
            if(error != nil){
                print(error)
            } else {
                let httpResponse = response as! NSHTTPURLResponse
                let statusCode = httpResponse.statusCode
                
                if (statusCode == 200) {
                    self.parseData(data)
                    self.observer!.dataAvailable()
                }
            }
        }
        task.resume()
    }
    
    // Note this function determines arrival minutes from the current time. The numbers seem high and disjoint.
    // Its not clear if all the data is in GMT or why the data is skewed.
    // Also cheating for now and storing the data from the intial time the data was fetched.
    func processDateString(str: String) -> Int {
        let format="yyyy-MM-dd'T'HH:mm:ss.SS"
        let dateFmt = NSDateFormatter()
        dateFmt.dateFormat = format
        
        // Now test our date
        let testOurDate = dateFmt.dateFromString(str)
        print(testOurDate)
        
        // Now get minutes
        let minutes = NSCalendar.currentCalendar().components(.Minute, fromDate: NSDate(), toDate: testOurDate!, options: []).minute
        print (minutes)
        return minutes
    }
    
    // The update of location had to come from a view so this may prove problematic
    // from a timing and threading POV. For now updating the model on the callback thread.
    func processDistance(lat: Double, long: Double) {
        print("Processing Distance in Data Model")
        myLat = lat
        myLong = long
    }
    
    func calculateDistances() {
        
        // Let's try a guard in case lat is not here.
        guard let _ = self.myLat else {
            return
        }
        
        let firstLoc = CLLocation(latitude: self.myLat!, longitude: self.myLong!)
        // for var dataItem in arrayOfItems {
        for i in 0 ..< arrayOfItems.count  {
            let secondLoc = CLLocation(latitude: arrayOfItems[i].locationLat!, longitude: arrayOfItems[i].locationLong!)
            arrayOfItems[i].distance = firstLoc.distanceFromLocation(secondLoc)
            print("Distance \(arrayOfItems[i].distance)")
        }
    }
}