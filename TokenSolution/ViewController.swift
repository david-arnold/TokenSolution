//
//  ViewController.swift
//  TokenSolution
//
//  Created by David Arnold on 14/12/2017.
//  Copyright © 2017 David Arnold. All rights reserved.
//

import UIKit

class ViewController: UIViewController, URLSessionDelegate {
    
    var useToken:Bool {
        get {
            let useTokenConfig:Any = getManagedAppConfigValue(key: "useToken", defaultValue: true);
            return useTokenConfig as! Bool;
        }
    };
    
    var updateURL:String {
        get {
            let updateURLConfig:Any = getManagedAppConfigValue(key: "updateURL", defaultValue: "http://www.originalurl.com/endpoint?queryStringParameter=");
            return updateURLConfig as! String;
        }
    };
    
    func getManagedAppConfigValue(key:String, defaultValue:Any) -> Any {
        if let managedConfig = UserDefaults.standard.dictionary(forKey: "com.apple.configuration.managed"){
            if let keyValue = managedConfig[key]{
                return keyValue;
            }
            else {
                return defaultValue;
            }
        }else{
            return defaultValue;
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func requestDataFromServer(_ sender: UIButton) {
        
        NSLog("updateURL: %@", self.updateURL);
        NSLog("useToken: %@", (self.useToken ? "true" : "false"));
        
        
        var token:String = "";
        
        if(self.useToken) {
            //perform getToken Action
            token = "result to go here";
        }
        
        //Set up Network Request
        let operationQueue:OperationQueue = OperationQueue.main;
        
        let session:URLSession = URLSession.init(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: operationQueue);
        
        //clear any previous caching
        URLSessionConfiguration.default.urlCache?.removeAllCachedResponses();

        //dummy date example
        let lastUpdatedDate:String = "2017-08-01";
        
        let urlString = String.init(format: "%@%@", self.updateURL, lastUpdatedDate);
        
        let url:URL = URL.init(string: urlString)!;
        
        var urlRequest:URLRequest = URLRequest.init(url: url);
        
        urlRequest.addValue("example value", forHTTPHeaderField: "exampleHeader");
        
        if(self.useToken) {
            urlRequest.addValue(token, forHTTPHeaderField: "Authorization");
        }
        
        let task:URLSessionDataTask = session.dataTask(with: urlRequest) { (data, response, error) -> Void in
            NSLog("Asynchronous NSURLSessionDataTask completionHandler");
            }
       
        task.resume();
    }
    
    
}

