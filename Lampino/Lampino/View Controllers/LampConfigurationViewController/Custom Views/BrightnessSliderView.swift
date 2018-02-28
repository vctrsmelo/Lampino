//
//  BrightnessSliderView.swift
//  Lampino
//
//  Created by Victor S Melo on 26/02/18.
//  Copyright © 2018 Lampino Organization. All rights reserved.
//

import UIKit

protocol BrightnessSliderViewDelegate {
    func didChangePercentValue(_ newValue: Int)
}

class BrightnessSliderView: UIView {
    
    let nibName = "BrightnessSliderView"
    var contentView: UIView?
    
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
    
    private var brightnessBeingTouched: BrightnessView?
    
    var delegate: BrightnessSliderViewDelegate?
    
    func setPercentValue(_ newValue: Int) {
        
        turnOnUntil(newValue/100)
        
        delegate?.didChangePercentValue(newValue)
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
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let firstTouch = touches.first else { return }
        
        for i in 0 ..< brightnessViews.count {
            if i == 0 && firstTouch.location(in: self).x < (brightnessViews[0].frame.width+brightnessViews[0].frame.origin.x) {
                turnAllOff()
                delegate?.didChangePercentValue(0)
                break
            }
            if brightnessViews[i].frame.contains(firstTouch.location(in: self)) {
                turnOnUntil(i)
                break
            }
            if i == 9 && firstTouch.location(in: self).x > (brightnessViews[9].frame.width+brightnessViews[9].frame.origin.x) {
                turnAllOn()
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let firstTouch = touches.first else { return }
        
        for i in 0 ..< brightnessViews.count {
            if i == 0 && firstTouch.location(in: self).x < (brightnessViews[0].frame.width+brightnessViews[0].frame.origin.x) {
                turnAllOff()
                delegate?.didChangePercentValue(0)
                break
            }
            if brightnessViews[i].frame.contains(firstTouch.location(in: self)) {
                turnOnUntil(i)
                delegate?.didChangePercentValue(i*10)
                break
            }
            if i == 9 && firstTouch.location(in: self).x > (brightnessViews[9].frame.width+brightnessViews[9].frame.origin.x) {
                turnAllOn()
                delegate?.didChangePercentValue(100)
            }
        }
    }
    
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    private func turnOnUntil(_ lampNumber: Int) {

        turnAllOff()
        
        if lampNumber == 0 {
            return
        }

        for i in 0 ..< lampNumber {
            brightnessViews[i].turnOn()
        }
        
        self.setNeedsDisplay()
    }
    
    private func turnAllOff() {
        brightnessViews.forEach({$0.turnOff()})
    }
    
    private func turnAllOn() {
        brightnessViews.forEach({$0.turnOn()})
    }

    
}
