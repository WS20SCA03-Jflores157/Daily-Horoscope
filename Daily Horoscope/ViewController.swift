//
//  ViewController.swift
//  Daily Horoscope
//
//  Created by Jeffrey  on 6/5/20.
//  Copyright © 2020 BMCC. All rights reserved.
//

import UIKit
import SwiftSoup

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let address: String = "https://www.horoscope.com/us/horoscopes/general/horoscope-general-daily-today.aspx?sign=4";
        
        guard let url: URL = URL(string: address) else {
            print("Could not create URL from address \"\(address)\".");
            return;
        }
        
        guard let webPage: String = textFromURL(url: url) else {
            print("Received nothing from URL \"\(url)\".");
            return;
        }
        
        print(webPage)
        
        guard let document: Document = try? SwiftSoup.parse(webPage) else {
            print("Could not parse webPage.");
            return;
        }
        
        guard let elements: Elements = try? document.getElementsByAttributeValueContaining("class", "</strong>") else {
            print("Could not find element whose class contains \"Fz(36px)\".");
            return;
        }
        
        guard elements.count == 1 else {
            print("elements.count == \(elements.count)");
            return;
        }
        
        guard let text = try? elements[0].text() else {
            print("The element had no text.");
            return;
        }
        
      
        
        print(text);
        
        
        
        
    }
    
    func textFromURL(url: URL) -> String? {
        let semaphore: DispatchSemaphore = DispatchSemaphore(value: 0);
        var result: String? = nil;
        
        let task: URLSessionDataTask = URLSession.shared.dataTask(with: url) {(data: Data?, response: URLResponse?, error: Error?) in
            if let error: Error = error { //I hope this if is false.
                print(error);
            }
            if let data: Data = data {    //I hope this if is true.
                result = String(data: data, encoding: String.Encoding.utf8);
            }
            semaphore.signal();   //Cause the semaphore's wait method to return.
        }
        
        task.resume();    //Try to download the web page into the Data object, then execute the closure.
        semaphore.wait(); //Wait here until the download and closure have finished executing.
        return result;    //Do this return after the closure has finished executing.
    }
    
}

