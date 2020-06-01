//
//  AnimationViewController.swift
//  HikeNotebook
//
//  Created by Ella  Neumarker on 5/3/20.
//  Copyright © 2020 Ella Neumarker. All rights reserved.
//

import UIKit
import Lottie

class AnimationViewController: UIViewController {

    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var myHikesButton: UIButton!
    @IBOutlet weak var newHikeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.layer.cornerRadius = 20
        buttonDesign(buttonDesign: myHikesButton)
        buttonDesign(buttonDesign: newHikeButton)
        
        
        startAnimation()
    }
    
    // MARK: Animation Image
    
    func startAnimation() {
        animationView.animation = Animation.named("hikeAnimation")
        animationView.loopMode = .loop
        animationView.play()
    }
    

    // MARK: Button Design
    
    func buttonDesign(buttonDesign: UIButton) {
        buttonDesign.layer.cornerRadius = 20
        buttonDesign.layer.shadowColor = Colors.mainBlue.cgColor
        buttonDesign.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        buttonDesign.layer.shadowOpacity = 1
        buttonDesign.layer.shadowRadius = 4.0
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
