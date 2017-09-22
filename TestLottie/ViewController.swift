//
//  ViewController.swift
//  TestLottie
//
//  Created by Kyle Kirkland on 9/22/17.
//  Copyright © 2017 Kirkland Enterprises. All rights reserved.
//

import UIKit
import Lottie

class ViewController: UIViewController {
    
    @IBOutlet var loadingView: UIView!
    
    var animationView: LOTAnimationView?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let refreshViewFrame = CGRect(x: 0, y: 0, width: 32, height: 32)
        let refreshView = UIView(frame: refreshViewFrame)
        refreshView.center = loadingView.center
        refreshView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
        refreshView.backgroundColor = UIColor.clear
        
        animationView =  loadingView.halogenAddLoadingAnimation(style: .medium)
        
        //loadingView.addSubview(refreshView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Uncommenting this makes the animation view play when returning back to the screen.
        //animationView?.play()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

