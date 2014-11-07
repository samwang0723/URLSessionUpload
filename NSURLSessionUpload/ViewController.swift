//
//  ViewController.swift
//  NSURLSessionUpload
//
//  Created by Gemtek iOS team on 11/5/14.
//  Copyright (c) 2014 Sam Wang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate {

    var responseData = NSMutableData()
    @IBOutlet weak var progressView: UIProgressView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bundle = NSBundle.mainBundle()
        let path = bundle.pathForResource("swift", ofType: "png")
        var data: NSData = NSData(contentsOfFile: path!)
        
        var request = NSMutableURLRequest(URL: NSURL(string: "http://127.0.0.1:8000/swift.png"))
        request.HTTPMethod = "POST"
        request.setValue("Keep-Alive", forHTTPHeaderField: "Connection")
        uploadFiles(request, data: data)
    }
    
    func uploadFiles(request: NSURLRequest, data: NSData) {
        var configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        var session = NSURLSession(configuration: configuration, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        var task = session.uploadTaskWithRequest(request, fromData: data)
        task.resume()
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        if error != nil {
            println("session \(session) occurred error \(error?.localizedDescription)")
        } else {
            println("session \(session) upload completed, response: \(NSString(data: responseData, encoding: NSUTF8StringEncoding))")
        }
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        var uploadProgress: Float = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
        println("session \(session) uploaded \(uploadProgress * 100)%.")
        progressView.progress = uploadProgress
    }
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveResponse response: NSURLResponse, completionHandler: (NSURLSessionResponseDisposition) -> Void) {
        println("session \(session), received response \(response)")
        completionHandler(NSURLSessionResponseDisposition.Allow)
    }
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
        responseData.appendData(data)
    }
}

