//
//  SnapVC.swift
//  SnapchatClone
//
//  Created by Muhammet Kadir on 13.03.2023.
//

import UIKit
import ImageSlideshow

class SnapVC: UIViewController {

    @IBOutlet weak var timeText: UILabel!
    
    var selectedSnap : Snap?
    var inputArray = [KingfisherSource]()

    
    override func viewDidLoad() {
        super.viewDidLoad()

      
        
        if let snap = selectedSnap{
            timeText.text = "Time Left : \(snap.timeDifference)"
            for imageUrl in snap.imageUrlArray{
                inputArray.append(KingfisherSource(urlString: imageUrl)!)
            }
            
            let imageSlideShow = ImageSlideshow(frame: CGRect(x: 10, y: 10, width: self.view.frame.width * 0.95, height: self.view.frame.height * 0.9))
            imageSlideShow.backgroundColor = UIColor.white
            
            let pageIndicator = UIPageControl()
            pageIndicator.currentPageIndicatorTintColor = UIColor.lightGray
            pageIndicator.pageIndicatorTintColor = UIColor.black
            imageSlideShow.pageIndicator = pageIndicator
            
            imageSlideShow.contentScaleMode = UIViewContentMode.scaleAspectFit
            imageSlideShow.setImageInputs(inputArray)
            self.view.addSubview(imageSlideShow)
            self.view.bringSubviewToFront(timeText)
        }
        
    }
    

}
