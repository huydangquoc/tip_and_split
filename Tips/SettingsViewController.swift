//
//  SettingsViewController.swift
//  Tips
//
//  Created by Dang Quoc Huy on 5/27/16.
//  Copyright © 2016 Dang Quoc Huy. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    // MARK: properties
    
    @IBOutlet weak var satisfactionControl: UISegmentedControl!
    @IBOutlet weak var splitToField: UITextField!
    @IBOutlet weak var roundOptionControl: UISegmentedControl!
    @IBOutlet weak var currencySymbolControl: UISegmentedControl!
    @IBOutlet weak var numOfDecimalControl: UISegmentedControl!
    @IBOutlet weak var languageControl: UISegmentedControl!
    @IBOutlet weak var themeControl: UISegmentedControl!

    let defaults = NSUserDefaults.standardUserDefaults()
    
    // MARK: functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // load settings
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
        languageControl.selectedSegmentIndex = defaults.integerForKey(SettingKeys.languageKey)
        themeControl.selectedSegmentIndex = defaults.integerForKey(SettingKeys.themeColorKey)
    }
    
    func saveSettings() {
        defaults.setInteger(satisfactionControl.selectedSegmentIndex, forKey: SettingKeys.satisfactionKey)
        defaults.setObject(splitToField.text, forKey: SettingKeys.splitToKey)
        defaults.setInteger(roundOptionControl.selectedSegmentIndex, forKey: SettingKeys.roundOptKey)
        defaults.setInteger(currencySymbolControl.selectedSegmentIndex, forKey: SettingKeys.currencySymbolKey)
        defaults.setInteger(numOfDecimalControl.selectedSegmentIndex, forKey: SettingKeys.numOfDecimalKey)
        defaults.setInteger(languageControl.selectedSegmentIndex, forKey: SettingKeys.languageKey)
        defaults.setInteger(themeControl.selectedSegmentIndex, forKey: SettingKeys.themeColorKey)
        defaults.synchronize()
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

    // MARK: actions
    
    @IBAction func onValueChanged(sender: AnyObject) {
        saveSettings()
    }
    
    @IBAction func onEditingChanged(sender: AnyObject) {
        defaults.setObject(splitToField.text, forKey: SettingKeys.splitToKey)
        defaults.synchronize()
    }
    
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
}
