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
    
    var horoscope: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
    
    
    @IBAction func zodiacPressed(_ sender: UIButton) {
        let signNumber: Int = sender.tag
        
        let address: String = "https://www.horoscope.com/us/horoscopes/general/horoscope-general-daily-today.aspx?sign=" + "\(signNumber)"
        
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
        
        guard let paragraphs: Elements = try?
            document.getElementsByTag("p") else {
                print("Could not hunt for paragraphs.");
                return;
        }
        
        guard paragraphs.count > 0 else {
            print("The web page had 0 paragraphs");
            return;
        }
        
        let firstParagraph: Element = paragraphs[0];   //The first paragraph in the webPage.
        
        guard firstParagraph.children().count == 1 else {
            print("The first paragraph is supposed to have exactly one child.")
            return;
        }
        
        let strong: Element = firstParagraph.child(0);
        
        guard strong.nodeName() == "strong" else {
            print("The child of the first paragraph is supposed to be a \"strong\".")
            return;
        }
        
        try? firstParagraph.removeChild(strong);    //Remove the date.
        
        guard let horoscopeText = try? firstParagraph.text() else {
            print("The first paragraph had no text.");
            return;
        }
        
        horoscope = horoscopeText
        
        performSegue(withIdentifier: "showHoroscope", sender: self)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let horoscopeV = segue.destination as? HoroscopeVC else {return}
        
        horoscopeV.horoscope = horoscope
    }
    
}

