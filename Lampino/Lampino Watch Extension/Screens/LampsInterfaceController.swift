//
//  InterfaceController.swift
//  Lampino Watch Extension
//
//  Created by Rodrigo Cardoso Buske on 06/03/18.
//  Copyright © 2018 Lampino Organization. All rights reserved.
//

import WatchKit

class LampsInterfaceController: WKInterfaceController {

    let lampsManager = LampsManager.sharedInstance
    
    private let rowType = "lampCell"
    
    @IBOutlet private weak var lampsTable: WKInterfaceTable!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        self.lampsManager.delegate = self
        
//        self.lampsTable.setRowTypes([self.rowType])
    }
    
    override func willActivate() {
        self.loadTable()
        
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        // TODO: disconnect
        super.didDeactivate()
    }
    
    private func loadTable() {
        print(#function)
        
        self.lampsTable.setNumberOfRows(self.lampsManager.lamps.count, withRowType: self.rowType)
        
        for index in 0 ..< self.lampsTable.numberOfRows {
            guard let cell = self.lampsTable.rowController(at: index) as? LampCell else { return }
            
            cell.lamp = self.lampsManager.lamps[index]
        }
    }
}

extension LampsInterfaceController: LampsManagerDelegate {
    func didConnect() { // TODO: notify
        self.loadTable()
    }
    
    func didDisconnect() { // TODO: notify
        self.loadTable()
    }
    
    func updatedLamps() {
        self.loadTable()
    }
}
