//
//  NewsDisplayVC.swift
//  Yml_Application
//
//  Created by Prakruth Nagaraj on 23/08/19.
//  Copyright © 2019 Prakruth Nagaraj. All rights reserved.
//

import UIKit

class NewsDisplayVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    var data: [DesignData] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
    }
    
    
    //Design DataSource Function for cell
    func getDesignData() -> [DesignData]{
        return [DesignData(imageName: "https://ymedialabs.com/wp-content/uploads/2019/07/mcdonalds-lead.jpeg", titleText: "Agency / Culture / Design / Leadership / Technology", descriptionTextL: "We Are People: What it Means to Have a People-First Approach"), DesignData(imageName: "https://ymedialabs.com/wp-content/uploads/2021/17/31_CpkmgfGBP59ieX6t6dT2wA.png", titleText: "Design / Technology", descriptionTextL: "Speaking the Same Language: How UX and Data Strategy Can Work Together to Design for Voice-Based AI"), DesignData(imageName: "https://ymedialabs.com/wp-content/uploads/2019/06/design-mocks.png", titleText: "Customer Experience / Design / Technology", descriptionTextL: "Don’t Overthink It: Design is a Tool For Making Businesses Better")]
    }
    
    //FinTech DataSource Function for cell
    func getFinTechData() -> [DesignData]{
        return [DesignData(imageName: "https://ymedialabs.com/wp-content/uploads/2019/05/earnin-rect.png", titleText: "Customer Experience / Fintech / Technology / Trending", descriptionTextL: "YML Partners With FinTech App, Earnin, on Customer Experience Development Work"), DesignData(imageName: "https://ymedialabs.com/wp-content/uploads/2018/05/pexels-photo-905869.jpeg", titleText: "FinTech", descriptionTextL: "B2B and B2C Applications for IoT in Banking"), DesignData(imageName: "", titleText: "", descriptionTextL: "")]
    }
    
    //Action function to capture segment change
    @IBAction func segmentIndexChanged(sender: UISegmentedControl){
        
        print(sender)
        switch sender.selectedSegmentIndex{
            case 0:
                data = getDesignData()
            
            case 1:
                data = getFinTechData()
            default:
                print(3)
        }
    }
}

extension NewsDisplayVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }


}

extension NewsDisplayVC{
    
    struct DesignData {
        let imageName: String
        let titleText: String
        let descriptionTextL: String
    }
    
    struct FinTechData {
        
    }
}

extension UIImageView{
    func loadImageFromURL(url: URL){
        if let imageData = try? Data(contentsOf: url){
            if let image = UIImage(data: imageData){
                self.image = image
            }
        }
    }
}