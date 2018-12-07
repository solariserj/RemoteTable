//
//  ViewController.swift
//  RemoteTable
//
//  Created by SolariSerj on 11/27/18.
//  Copyright © 2018 Attribute. All rights reserved.
//

import UIKit
import FirebaseStorage



class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var mainTable: UITableView!
    @IBOutlet weak var getButton: UIButton!

    let languageCell = "languageCell"

    var languageList = [String]()
    
    var localURL: URL? = {
        if let urlMask = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let url = urlMask.appendingPathComponent("languages.plist", isDirectory: false)
            return url
        } else {
            fatalError("Could not create URL for specified directory!")
        }
        return nil
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        mainTable.register(UITableViewCell.self, forCellReuseIdentifier: languageCell)
        
    }

    @IBAction func getFromFirebase(_ sender: Any) {
        // Get a reference to the storage service using the default Firebase App
        let storage = Storage.storage()
        
        // Create a storage reference from our storage service
        let storageRef = storage.reference()
        
//        // Create a reference with an initial file path and name
        let pathReference = storage.reference(withPath: "Test/languages.plist")
//
//        // Create a reference from a Google Cloud Storage URI
        let gsReference = storage.reference(forURL: "gs://iossampleproject-6b500.appspot.com/Test/languages.plist")
//
//        // Create a reference from an HTTPS URL
//        // Note that in the URL, characters are URL escaped!
//        let httpsReference = storage.reference(forURL: "https://firebasestorage.googleapis.com/b/bucket/o/images%20stars.jpg")
      
        
        // Create a reference to the file you want to download
//        let islandRef = storageRef.child("Test/languages.plist")
        
        if let localUrl = localURL {
            // Download to the local filesystem
            let downloadTask = gsReference.write(toFile: localUrl) { url, error in
                if let error = error {
                    // Uh-oh, an error occurred!
                    print("save failed")

                } else {
                    // Local file URL for "images/island.jpg" is returned
                    print("save succes")
                    if  let nsList = NSArray(contentsOfFile: localUrl.path) {
                        print(" print contries \(nsList) ")
                    
                        self.languageList = nsList.map({ (objArray) -> String in
                            if let obj = objArray as? Dictionary<String, Any>, let name = obj["name"] as? String {
                               return name
                            }
                            return "no"
                        })
                       self.mainTable.reloadData()
                    }
                    print(" finish read plist");
                
                    
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: languageCell) as? UITableViewCell {
            
            cell.textLabel?.text = self.languageList[indexPath.row]
            
            return cell
        }
        return UITableViewCell()
    }
    
    
    
}

