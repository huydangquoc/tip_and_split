//
//  SettingsTableViewController.swift
//  Tips
//
//  Created by Dang Quoc Huy on 5/28/16.
//  Copyright © 2016 Dang Quoc Huy. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    // MARK: properties
    
    @IBOutlet weak var satisfactionControl: UISegmentedControl!
    @IBOutlet weak var splitToField: UITextField!
    @IBOutlet weak var currencySymbolControl: UISegmentedControl!
    @IBOutlet weak var numOfDecimalControl: UISegmentedControl!
    @IBOutlet weak var roundOptionControl: UISegmentedControl!
    @IBOutlet weak var themeControl: UISegmentedControl!

    let defaults = NSUserDefaults.standardUserDefaults()
    
    // MARK: functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadSettings()
    }
    
    func loadSettings() {
        satisfactionControl.selectedSegmentIndex = defaults.integerForKey(SettingKeys.satisfactionKey)
        if let splitToText = defaults.objectForKey(SettingKeys.splitToKey) as! String? {
            splitToField.text = splitToText
        } else {
            splitToField.text = ""
        }
        roundOptionControl.selectedSegmentIndex = defaults.integerForKey(SettingKeys.roundOptKey)
        currencySymbolControl.selectedSegmentIndex = defaults.integerForKey(SettingKeys.currencySymbolKey)
        numOfDecimalControl.selectedSegmentIndex = defaults.integerForKey(SettingKeys.numOfDecimalKey)
        themeControl.selectedSegmentIndex = defaults.integerForKey(SettingKeys.themeColorKey)
    }
    
    func saveChangedValues() {
        defaults.setInteger(satisfactionControl.selectedSegmentIndex, forKey: SettingKeys.satisfactionKey)
        defaults.setInteger(roundOptionControl.selectedSegmentIndex, forKey: SettingKeys.roundOptKey)
        defaults.setInteger(currencySymbolControl.selectedSegmentIndex, forKey: SettingKeys.currencySymbolKey)
        defaults.setInteger(numOfDecimalControl.selectedSegmentIndex, forKey: SettingKeys.numOfDecimalKey)
        defaults.setInteger(themeControl.selectedSegmentIndex, forKey: SettingKeys.themeColorKey)
        defaults.synchronize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 && indexPath.row == 1 {
            splitToField.becomeFirstResponder()
        }
    }
    
    // MARK: - actions
    
    @IBAction func onValueChanged(sender: AnyObject) {
        saveChangedValues()
    }
    
    @IBAction func onEditingEnd(sender: UITextField) {
        defaults.setObject(splitToField.text, forKey: SettingKeys.splitToKey)
        defaults.synchronize()
    }
}
