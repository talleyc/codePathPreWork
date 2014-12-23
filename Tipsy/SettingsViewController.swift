//
//  SettingsViewController.swift
//  Tipsy
//
//  Created by Chris Talley on 12/17/14.
//  Copyright (c) 2014 Chris Talley. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDataSource,UIPickerViewDelegate {

    @IBOutlet weak var defaultTipSelector: UIPickerView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    let pickerData = [14,16,18,20,22,24]
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultTipSelector.dataSource = self
        defaultTipSelector.delegate = self
        self.view.backgroundColor = UIColor(red: 0.97, green: 0.91, blue: 0.87, alpha: 1)
        defaultTipSelector.selectRow(find(pickerData, getDefaultSatisfactionLevel())!, inComponent:0, animated: true)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    //MARK: Delegates
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return "\(pickerData[row])%"
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(pickerData[row], forKey: "defaultTip")
        defaults.synchronize()
    }
    
    @IBAction func backButtonPushed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func getDefaultSatisfactionLevel() -> Int {
        var defaultTip: NSInteger? = NSUserDefaults.standardUserDefaults().objectForKey("defaultTip") as? NSInteger
        if defaultTip == nil
        {
            defaultTip = NSInteger(16)
        }
        return defaultTip!
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
