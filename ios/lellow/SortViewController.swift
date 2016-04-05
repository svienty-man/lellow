//
//  SortViewController.swift
//  Lellow
//
//  Created by Richard Svienty on 3/30/16.
//  Copyright © 2016 Richard Svienty. All rights reserved.
//

import UIKit

class SortViewController: UIViewController {

    @IBAction func sortByName(sender: AnyObject) {
        print("sort by name")
        self.myDataModel?.sortData(.nameOrder)
        self.removeAnimate()
    }

    @IBAction func SortByArrTime(sender: AnyObject) {
        print("sort by time")
        self.myDataModel?.sortData(.arrivalOrder)
        self.removeAnimate()
    }
    
    @IBAction func sortByDistance(sender: AnyObject) {
        print("sort by distance")
        self.myDataModel?.sortData(.distanceOrder)
        self.removeAnimate()
    }
    
    @IBOutlet weak var sortByArrival: UIButton!
    
    var myDataModel : LellowDataModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.cornerRadius = 5;
        self.view.layer.shadowOpacity = 0.8;
        // self.view.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
        self.view.clipsToBounds = true;

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func showInView(aView: UIView!, animated: Bool, dataModel : LellowDataModel)
    {
        self.myDataModel = dataModel
        aView.addSubview(self.view)
        if animated
        {
            self.showAnimate()
        }
    }
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3)
        self.view.alpha = 0.0;
        UIView.animateWithDuration(0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransformMakeScale(1.0, 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animateWithDuration(0.25, animations: {
            self.view.transform = CGAffineTransformMakeScale(1.3, 1.3)
            self.view.alpha = 0.0;
            }, completion:{(finished : Bool)  in
                if (finished)
                {
                    self.view.removeFromSuperview()
                }
        });
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    
}
