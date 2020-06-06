//
//  HoroscopeVC.swift
//  Daily Horoscope
//
//  Created by Jeffrey  on 6/5/20.
//  Copyright © 2020 BMCC. All rights reserved.
//

import UIKit

class HoroscopeVC: UIViewController {

    var horoscope: String = ""
    
    @IBOutlet weak var dateLabel: UILabel!
    
    
    @IBOutlet weak var horoscopeTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        horoscopeTextView.text = horoscope
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        
        let currentDate = formatter.string(from: date)
        
        dateLabel.text = currentDate
       
    }
    

   

}
