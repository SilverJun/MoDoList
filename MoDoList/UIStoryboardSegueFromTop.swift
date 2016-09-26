//
//  UIStoryboardSegueFromTop.swift
//  MoDoList
//
//  Created by Eun Jun Jang on 2016. 9. 26..
//  Copyright © 2016년 SilverJu. All rights reserved.
//

import UIKit

class UIStoryboardSegueFromTop: UIStoryboardSegue {
    
    override func perform() {
        let src = self.sourceViewController as UIViewController
        let dst = self.destinationViewController as UIViewController
        
        src.view.superview?.insertSubview(dst.view, aboveSubview: src.view)
        dst.view.transform = CGAffineTransformMakeTranslation(0, -src.view.frame.size.height)
        
        UIView.animateWithDuration(0.33, animations: {
            dst.view.transform = CGAffineTransformMakeTranslation(0, 0)
            
        }) { (Finished) in
            src.presentViewController(dst, animated: false, completion: nil)
        }
    }
    
}
