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
    @IBOutlet weak var tipTextLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var separator2: UIView!
    
    let tipPercentages = [0.05, 0.1, 0.15, 0.2, 0.25]
    let locales = [ NSLocale(localeIdentifier: "en_US"),
                    NSLocale(localeIdentifier: "vi_VN")]
    let themeColors = [ UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1),
                        UIColor(red: 255/255, green: 255/255, blue: 230/255, alpha: 1),
                        UIColor(red: 230/255, green: 255/255, blue: 255/255, alpha: 1)]
    let defaults = NSUserDefaults.standardUserDefaults()
    let formatter = NSNumberFormatter()
    
    // MARK: functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        billField.becomeFirstResponder()
    }
    
    func loadSettings() {
        // load locale
        let localeIndex = defaults.integerForKey(SettingKeys.currencySymbolKey)
        let numDecimal = defaults.integerForKey(SettingKeys.numOfDecimalKey)
        formatter.numberStyle = .CurrencyStyle
        formatter.locale = locales[localeIndex]
        formatter.maximumFractionDigits = numDecimal
        formatter.minimumFractionDigits = numDecimal
        
        // load theme color and apply
        applyTheme(themeColors[defaults.integerForKey(SettingKeys.themeColorKey)])
        
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
    
    func applyTheme(color: UIColor) {
        self.view.backgroundColor = color
        billField.backgroundColor = color
        splitToField.backgroundColor = color
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        loadSettings()
        reCalculate()
    }
    
    func showResult(state: Bool) {
        totalTextLabel.hidden = state
        totalLabel.hidden = state
        roundControl.hidden = state
        separator.hidden = state
        tipTextLabel.hidden = state
        tipLabel.hidden = state
        separator2.hidden = state
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
            if formatter.currencySymbol ==  "₫" {
                total = ceil(total/1000)*1000
                tip = ceil(tip/1000)*1000
            } else {
                total = ceil(total)
                tip = ceil(tip)
            }
        case 2:
            if formatter.currencySymbol ==  "₫" {
                total = floor(total/1000)*1000
                tip = floor(tip/1000)*1000
            } else {
                total = floor(total)
                tip = floor(tip)
            }
        default: break
        }
        
        totalLabel.text = formatter.stringFromNumber(total)
        tipLabel.text = formatter.stringFromNumber(tip)
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
