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
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipControl: UISegmentedControl!
    @IBOutlet weak var splitToField: UITextField!
    @IBOutlet weak var roundControl: UISegmentedControl!
    @IBOutlet weak var totalTextLabel: UILabel!
    @IBOutlet var separator: UIView!
    
    let tipPercentages = [0.05, 0.1, 0.15, 0.2, 0.25]
    let currencySymbols = ["$", "€", "₫"]
    let themeColors = [ UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1),
                        UIColor(red: 255/255, green: 255/255, blue: 230/255, alpha: 1),
                        UIColor(red: 230/255, green: 255/255, blue: 255/255, alpha: 1)]
    let defaults = NSUserDefaults.standardUserDefaults()
    
    var numDecimal = 0
    var currencySymbol = ""
    var themeColor: UIColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
    
    // MARK: functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func loadSettings() {
        // load currency symbol
        let currencySymbolIndex = defaults.integerForKey(SettingKeys.currencySymbolKey)
        currencySymbol = currencySymbols[currencySymbolIndex]
        // load number of decimal
        numDecimal = defaults.integerForKey(SettingKeys.numOfDecimalKey)
        // load language
        //let lang = defaults.integerForKey(SettingKeys.languageKey)
        // load theme color
        themeColor = themeColors[defaults.integerForKey(SettingKeys.themeColorKey)]
        
        // load tip rating
        tipControl.selectedSegmentIndex = defaults.integerForKey(SettingKeys.satisfactionKey)
        // load split to
        if let splitToText = defaults.objectForKey(SettingKeys.splitToKey) as! String? {
            splitToField.text = splitToText
        } else {
            splitToField.text = ""
        }
        // load round option
        roundControl.selectedSegmentIndex = defaults.integerForKey(SettingKeys.roundOptKey)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        loadSettings()
        reCalculate()
        // apply themeColor.blueColor()
        self.view.backgroundColor = themeColor
        billField.backgroundColor = themeColor
        splitToField.backgroundColor = themeColor
    }
    
    func showResult(state: Bool) {
        totalTextLabel.hidden = state
        totalLabel.hidden = state
        roundControl.hidden = state
        separator.hidden = state
    }
    
    func reCalculate() {
        let billAmount = NSString(string: billField.text!).doubleValue
        let tipPercentage = tipPercentages[tipControl.selectedSegmentIndex]
        let splitTo = NSString(string: splitToField.text!).doubleValue
        let roundOption = roundControl.selectedSegmentIndex
        var tip: Double
        var total: Double
        
        if billAmount <= 0 {
            showResult(true)
        } else {
           showResult(false)
        }
        
        if splitTo > 1 {
            totalTextLabel.text = "Each"
            tip = (billAmount * tipPercentage)/splitTo
            total = (billAmount + tip)/splitTo
        } else {
            totalTextLabel.text = "Total"
            tip = billAmount * tipPercentage
            total = billAmount + tip
        }
        
        switch roundOption {
        case 0:
            if currencySymbol == currencySymbols[2] {
                total = ceil(total/1000)*1000
            } else {
                total = ceil(total)
            }
        case 2:
            if currencySymbol == currencySymbols[2] {
                total = floor(total/1000)*1000
            } else {
                total = floor(total)
            }
        default: break
        }
        
        let numFormat = currencySymbol + "%.\(numDecimal)f"
        totalLabel.text = String(format: numFormat, total)
        
    }
    
//    override func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(animated)
//    }
//    
//    override func viewWillDisappear(animated: Bool) {
//        super.viewWillDisappear(animated)
//    }
//    
//    override func viewDidDisappear(animated: Bool) {
//        super.viewDidDisappear(animated)
//    }
    
    // MARK: actions
    
    @IBAction func onEditingChanged(sender: AnyObject) {
        reCalculate()
    }
    
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
}
