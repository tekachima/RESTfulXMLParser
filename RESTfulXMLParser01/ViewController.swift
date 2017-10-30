//
//  ViewController.swift
//  RESTfulXMLParser01
//  Created as example while in iOs swift training education
//  Uses Console only to fetch and show news headline (finnish only)
//  change website for other similar news RSS feeds, this is saved to github too as
//  useful and helpful codebase for later projects
//  Improvemts ToDo make UI, parse news headlines, create more tableviews and so on...

import UIKit

class ViewController: UIViewController, XMLParserDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // First we need a target website that has some XML material
        // Typically this is a RSS-feed. Website used is Finnish most common news company
        let targetwebservice : String = "https://feeds.yle.fi/uutiset/v1/majorHeadlines/YLE_UUTISET.rss"
        
        // The RESTful API using data fetching is typically done using NSURL
        //let targetwebserviceurl = NSURL(string: targetwebservice)
        // This can be changed into URL
        let targetwebserviceurl = URL(string: targetwebservice)
        
        // NSURLSession based request has been renamed into URLSession
        // let targetwebservicerequest = NSURLRequest(url: targetwebserviceurl! as URL)
        // Similarly we use URLRequest
        let targetwebservicerequest = URLRequest(url: targetwebserviceurl!)
        let targetnsurlsession = URLSession.shared
        
        // This is a typical datatask which is asynchronous task driven in background
        // Usually all tasks that go over interfaces should be implemented as datatasks.
        // This datatask uses URLSession as input
        let datatask =
            targetnsurlsession.dataTask(with: targetwebservicerequest, completionHandler: { (data, response, error) in
                if (error == nil)
                {
                    // datatask was successful
                    // Create a parser and use data as input
                    var parser = XMLParser()
                    parser = XMLParser(data: data!)
                    // Add parser's delegate to this class
                    // Now you can add functions for parser in this class
                    parser.delegate = self
                    parser.parse()
                } else
                {
                    // datatask was not successful
                    NSLog(String(describing: error))
                }
            })
        datatask.resume()
    }
    
    // Following four functions are parser's most important functions we can use
    // didStartElement
    // didEndElement
    // foundCharacters
    // parserDidEndDocument
    
    var titlelist : [String] = []
    var descriptionlist : [String] = []
    var foundCharacters = "";
    var isItem : Bool = false
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "item" {
            isItem = true
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "title" && isItem == true {
            titlelist.append(self.foundCharacters)
        }
        if elementName == "description" && isItem == true {
            descriptionlist.append(self.foundCharacters)
        }
        if elementName == "item" {
            isItem = false
        }
        self.foundCharacters = ""
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        self.foundCharacters += string
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        for iter : String in titlelist {
            NSLog(iter)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}

