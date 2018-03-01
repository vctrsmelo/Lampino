//
//  BrightnessSliderView.swift
//  Lampino
//
//  Created by Victor S Melo on 26/02/18.
//  Copyright © 2018 Lampino Organization. All rights reserved.
//

import UIKit
import MediaAccessibility

protocol BrightnessSliderViewDelegate {
    func didChangePercentValue(_ newValue: Int)
}

class BrightnessSliderView: UIView {
    
    let nibName = "BrightnessSliderView"
    var contentView: UIView?
    var currentValue: Int! {
        didSet {
            if currentValue == nil || currentValue == oldValue { return }
            delegate?.didChangePercentValue(currentValue*10)

        }
    }

    @IBOutlet weak var brightnessViewsContainerView: UIView!
    
    @IBOutlet weak var brightnessView1: BrightnessView!
    @IBOutlet weak var brightnessView2: BrightnessView!
    @IBOutlet weak var brightnessView3: BrightnessView!
    @IBOutlet weak var brightnessView4: BrightnessView!
    @IBOutlet weak var brightnessView5: BrightnessView!
    @IBOutlet weak var brightnessView6: BrightnessView!
    @IBOutlet weak var brightnessView7: BrightnessView!
    @IBOutlet weak var brightnessView8: BrightnessView!
    @IBOutlet weak var brightnessView9: BrightnessView!
    @IBOutlet weak var brightnessView10: BrightnessView!
    
    var brightnessViews: [BrightnessView] {
        return [brightnessView1,
               brightnessView2,
               brightnessView3,
               brightnessView4,
               brightnessView5,
               brightnessView6,
               brightnessView7,
               brightnessView8,
               brightnessView9,
               brightnessView10]
    }
    
    override func accessibilityIncrement() {
        if currentValue == 10 { return }
        turnOnUntil(currentValue+1)
    }
    
    override func accessibilityDecrement() {
        if currentValue == 0 { return }
        turnOnUntil(currentValue-1)
    }
    
    private var brightnessBeingTouched: BrightnessView?
    
    var delegate: BrightnessSliderViewDelegate?
    
    func setPercentValue(_ newValue: Int) {
        turnOnUntil(newValue/10)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        view.backgroundColor = UIColor.clear
        self.addSubview(view)
        contentView = view
        self.backgroundColor = UIColor.clear
        brightnessViewsContainerView.layer.borderColor = UIColor.white.cgColor
        brightnessViewsContainerView.layer.borderWidth = 3
        brightnessViewsContainerView.layer.cornerRadius = 8
        brightnessViewsContainerView.layer.masksToBounds = true
        
        initializeAccessibility()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let firstTouch = touches.first else { return }
        
        for i in 0 ..< brightnessViews.count {
            if firstTouch.location(in: self).x < brightnessViews[0].frame.origin.x {
                turnAllOff()
                break
            }
            if firstTouch.location(in: self).x >= (brightnessViews[9].frame.width+brightnessViews[9].frame.origin.x) {
                turnAllOn()
                break
            }
            
            if brightnessViews[i].frame.contains(firstTouch.location(in: self)) {
                turnOnUntil(i)
                break
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let firstTouch = touches.first else { return }
        
        for i in 0 ..< brightnessViews.count {
            if firstTouch.location(in: self).x < brightnessViews[0].frame.origin.x {
                turnAllOff()
                break
            }
            if firstTouch.location(in: self).x >= (brightnessViews[9].frame.width+brightnessViews[9].frame.origin.x) {
                turnAllOn()
                break
            }
            
            if brightnessViews[i].frame.contains(firstTouch.location(in: self)) {
                turnOnUntil(i)
                break
            }
        }
    }
    
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    private func turnOnUntil(_ lampNumber: Int) {
        brightnessViews.forEach({$0.turnOff()})

        for i in 0 ..< lampNumber {
            brightnessViews[i].turnOn()
        }

        currentValue = lampNumber
        self.setNeedsDisplay()
    }
    
    private func turnAllOff() {
        brightnessViews.forEach({$0.turnOff()})
        currentValue = 0
    }

    private func turnAllOn() {
        brightnessViews.forEach({$0.turnOn()})
        currentValue = 10
    }
    
    
    private func initializeAccessibility() {
        
        self.isAccessibilityElement = true
        self.accessibilityTraits = UIAccessibilityTraitAdjustable
        
    }
    
}
