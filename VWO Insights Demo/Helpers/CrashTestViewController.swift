//
//  CrashTestViewController.swift
//  VWO Insights Demo
//
//  Created by Parvesh Chauhan on 14/02/24.
//

import UIKit

class CrashTestViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func IndexOutOfRangeEx(_ sender: Any) {
        let array = [1, 2, 3]
        let value = array[5]
    }
    
    @IBAction func InvalidArgumentEx(_ sender: Any) {
        let invalidArgument: Any? = nil
        let _ = NSString(format: "%@", invalidArgument! as! CVarArg)
        
    }
    
    @IBAction func InternalInconsistency(_ sender: Any) {
        // Throwing an NSInternalInconsistencyException
        assert(false, "This is an internal inconsistency")
        
    }
    
    @IBAction func genericEx(_ sender: Any) {
        // Throwing an NSGenericException
        NSException(name: NSExceptionName.genericException, reason: "Generic exception", userInfo: nil).raise()
        
    }
    
}
