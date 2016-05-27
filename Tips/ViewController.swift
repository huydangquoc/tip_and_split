//
//  ViewController.swift
//  Tips
//
//  Created by Dang Quoc Huy on 5/27/16.
//  Copyright © 2016 Dang Quoc Huy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: properties
    
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipControl: UISegmentedControl!
    @IBOutlet weak var splitToField: UITextField!
    @IBOutlet weak var roundControl: UISegmentedControl!
    @IBOutlet weak var totalTextLabel: UILabel!
    @IBOutlet weak var tipTextLabel: UILabel!
    
    var tipPercentages = [0.05, 0.1, 0.15, 0.2, 0.25]
    var numDecimal = 0
    
    // MARK: functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tipLabel.text = "$0.00"
        totalLabel.text = "$0.00"
        billField.text = ""
        splitToField.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: actions
    
    @IBAction func onEditingChanged(sender: AnyObject) {
        let billAmount = NSString(string: billField.text!).doubleValue
        let tipPercentage = tipPercentages[tipControl.selectedSegmentIndex]
        let splitTo = NSString(string: splitToField.text!).doubleValue
        let roundOption = roundControl.selectedSegmentIndex
        var tip: Double
        var total: Double
        
        if splitTo > 1 {
            totalTextLabel.text = "Each"
            tipTextLabel.text = "Each tip"
            tip = (billAmount * tipPercentage)/splitTo
            total = (billAmount + tip)/splitTo
        } else {
            totalTextLabel.text = "Total"
            tipTextLabel.text = "Tip"
            tip = billAmount * tipPercentage
            total = billAmount + tip
        }
        
        switch roundOption {
        case 0:
            tip = ceil(tip)
            total = ceil(total)
        case 2:
            tip = floor(tip)
            total = floor(total)
        default: break
        }
        
        let numFormat = "$%.\(numDecimal)f"
        tipLabel.text = String(format: numFormat, tip)
        totalLabel.text = String(format: numFormat, total)
    }
    
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
}
