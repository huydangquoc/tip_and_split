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
    
    @IBOutlet weak var billTextLabel: UILabel!
    @IBOutlet weak var tipPercentageTextLabel: UILabel!
    @IBOutlet weak var shareTextLabel: UILabel!
    
    let tipPercentages = [0.05, 0.1, 0.15, 0.2, 0.25]
    let locales = [ NSLocale(localeIdentifier: "en_US"),
                    NSLocale(localeIdentifier: "vi_VN")]
    let roundBases = [1.0, 1000.0]
    let themeColors = [ UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1),
                        UIColor(red: 255/255, green: 255/255, blue: 230/255, alpha: 1),
                        UIColor(red: 230/255, green: 255/255, blue: 255/255, alpha: 1)]
    let defaults = NSUserDefaults.standardUserDefaults()
    let formatter = NSNumberFormatter()
    
    var localeIndex = 0
    
    // MARK: functions
    
    func loadSettings() {
        // load locale and format formatter
        localeIndex = defaults.integerForKey(SettingKeys.currencySymbolKey)
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
            total = ceil(total/roundBases[localeIndex])*roundBases[localeIndex]
            tip = ceil(tip/roundBases[localeIndex])*roundBases[localeIndex]
        case 2:
            total = floor(total/roundBases[localeIndex])*roundBases[localeIndex]
            tip = floor(tip/roundBases[localeIndex])*roundBases[localeIndex]
        default: break
        }
        
        totalLabel.text = formatter.stringFromNumber(total)
        tipLabel.text = formatter.stringFromNumber(tip)
    }
    
    func saveBillInfo() {
        defaults.setObject(billField.text, forKey: Bill.Amount)
        defaults.setObject(NSDate(), forKey: Bill.Time)
        defaults.synchronize()
    }
    
    func loadBillInfo() {
        if let time = defaults.objectForKey(Bill.Time) as! NSDate? {
            // get elapsed time
            let elapsedTime = Int(NSDate().timeIntervalSinceDate(time))
            // check if within 10 mins
            if abs(elapsedTime) < 10*60 {
                // load previous bill amount
                if let billAmount = defaults.objectForKey(Bill.Amount) as! String? {
                    billField.text = billAmount
                }
            }
        }
    }
    
    func animateControls() {
        // prepare control location
        billTextLabel.frame.origin.x -= 100
        tipPercentageTextLabel.frame.origin.x -= 100
        shareTextLabel.frame.origin.x -= 100
        
        // let aminate something :-)
        UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            var billAmounLabeltFrame = self.billTextLabel.frame
            var tipPercentageLabelFrame = self.tipPercentageTextLabel.frame
            var shareLabelFrame = self.shareTextLabel.frame
            
            billAmounLabeltFrame.origin.x += 100
            tipPercentageLabelFrame.origin.x += 100
            shareLabelFrame.origin.x += 100
            
            self.billTextLabel.frame = billAmounLabeltFrame
            self.tipPercentageTextLabel.frame = tipPercentageLabelFrame
            self.shareTextLabel.frame = shareLabelFrame
            
            }, completion: nil)
    }
    
    // MARK: life-cycle Event
    
    override func viewDidLoad() {
        super.viewDidLoad()
        billField.becomeFirstResponder()
        
        loadBillInfo()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        loadSettings()
        reCalculate()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        animateControls()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: actions
    
    @IBAction func onEditingChanged(sender: AnyObject) {
        reCalculate()
        saveBillInfo()
    }
    
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
}
