//
//  ViewController.swift
//  Tipsy
//
//  Created by Chris Talley on 12/14/14.
//  Copyright (c) 2014 Chris Talley. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipPercentageSlider: UISlider!
    @IBOutlet weak var emojiField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeView()
    }
    
    override func viewWillAppear(animated :Bool) {
        initializeView()
        billField.becomeFirstResponder()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeView() {
        tipPercentageSlider.value = Float(getDefaultSatisfactionLevel())
        setPercentLabelText(percentageLabel, value: roundTipPercentage()*100)
        placeEmoji()
        self.view.backgroundColor = UIColor(red: 0.97, green: 0.91, blue: 0.87, alpha: 1)
        billField.becomeFirstResponder()
    }
    
    @IBAction func onChangeSlider(sender: AnyObject) {
        hideKeyboard(sender)
        onUpdateInput(sender)
    }
    
    @IBAction func onUpdateInput(sender: AnyObject) {
        var billAmount = (billField.text as NSString).floatValue
        var tipAmount = roundTipPercentage() * billAmount
        setDollarLabelText(tipLabel, value: tipAmount)
        setDollarLabelText(totalLabel, value: tipAmount + billAmount)
        setPercentLabelText(percentageLabel, value: roundTipPercentage()*100)
        placeEmoji()
    }
    
    @IBAction func hideKeyboard(sender: AnyObject) {
        view.endEditing(true)
    }
    
    func setPercentLabelText(label :UILabel, value :Float) {
        var labelText = String(format: "%.0f", value)
        label.text = "\(labelText)%"
    }
    
    func setDollarLabelText(label :UILabel, value :Float) {
        var labelText = String(format: "%.2f", value)
        label.text = "$\(labelText)"
    }
    
    /**
     *   Rounding the tip percentage so that it goes in increments of 2%
     *   Involved a Float->Int->Float hack in order to lose the precision
     *   and force it to round. There's got to be a much cleaner way to do this.
    */
    func roundTipPercentage() -> Float {
        var roundedTipDelta :Float = Float(getSatisfactionLevel()*2)
        var tipPercentage = roundedTipDelta + tipPercentageSlider.minimumValue
        if roundedTipDelta == 0 {
            tipPercentage = 0
        }
        tipPercentageSlider.value = tipPercentage
        return tipPercentage / 100
    }
    
    func getSatisfactionLevel() -> Int {
        var originalTipPercentage :Float = tipPercentageSlider.value
        var tipDelta :Float = originalTipPercentage - tipPercentageSlider.minimumValue
        return Int((tipDelta+1)/2)
    }
    
    func getCenterOfThumbForSlider(aSlider :UISlider) -> CGFloat {
        var sliderRange :CGFloat = aSlider.frame.size.width - aSlider.currentThumbImage!.size.width
        var sliderOrigin :CGFloat = (aSlider.frame.origin.x + (aSlider.currentThumbImage!.size.width / 2.0))
        var sliderRatio :CGFloat = CGFloat(((aSlider.value-aSlider.minimumValue)/(aSlider.maximumValue-aSlider.minimumValue)))
        var sliderLocation :CGFloat = (sliderRatio * sliderRange)
        var sliderValueToPixels = sliderLocation + sliderOrigin
        return sliderValueToPixels
    }
    
    func getDefaultSatisfactionLevel() -> Int {
        var defaultTip: NSInteger? = NSUserDefaults.standardUserDefaults().objectForKey("defaultTip") as? NSInteger
        if defaultTip == nil
        {
            defaultTip = NSInteger(18)
        }
        return defaultTip!
    }
    
    func placeEmoji(){
        var satisfactionFaces = ["\u{1F4A9}","\u{1F621}","\u{1F620}","\u{1F611}","\u{1F604}","\u{1F60A}","\u{1F607}"]
        var emojiY = tipPercentageSlider.frame.origin.y - tipPercentageSlider.frame.size.height/2 - emojiField.frame.size.height/2
        var emojiX = getCenterOfThumbForSlider(tipPercentageSlider) - 15 //For some reason, these numbers seem to be off by about 15 px
        emojiField.frame.origin.x = emojiX
        emojiField.frame.origin.y = emojiY
        emojiField.text = satisfactionFaces[getSatisfactionLevel()]
    }
}















