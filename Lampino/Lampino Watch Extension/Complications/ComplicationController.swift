//
//  ComplicationController.swift
//  Lampino Watch Extension
//
//  Created by Rodrigo Cardoso Buske on 06/03/18.
//  Copyright © 2018 Lampino Organization. All rights reserved.
//

import ClockKit

let ComplicationCurrentEntry = "ComplicationCurrentEntry"
let ComplicationTextData = "ComplicationTextData"
let ComplicationShortTextData = "ComplicationShortTextData"

class ComplicationController: NSObject, CLKComplicationDataSource {
    
    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.forward, .backward])
    }
    
    func getTimelineStartDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
    }
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.showOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        // Call the handler with the current timeline entry

        var entry: CLKComplicationTimelineEntry?
        let now = Date()
        
        switch complication.family {
        case .circularSmall:
            let circularTemplate = CLKComplicationTemplateCircularSmallSimpleImage()
            circularTemplate.imageProvider =  CLKImageProvider.init(onePieceImage: #imageLiteral(resourceName: "Complication/Circular"))
            entry = CLKComplicationTimelineEntry(date: now, complicationTemplate: circularTemplate)
        case .modularSmall:
            let modularTemplate = CLKComplicationTemplateCircularSmallSimpleImage()
            modularTemplate.imageProvider =  CLKImageProvider.init(onePieceImage: #imageLiteral(resourceName: "Complication/Modular"))
            entry = CLKComplicationTimelineEntry(date: now, complicationTemplate: modularTemplate)
        default:
            break
        }
        handler(entry)
    }
    
    func getTimelineEntries(for complication: CLKComplication, before date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries prior to the given date
        handler(nil)
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after to the given date
        handler(nil)
    }
    
    // MARK: - Placeholder Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        handler(nil)
    }
    
    private func getCircularSmallTimelyEntry() {
        
    }
    
}
