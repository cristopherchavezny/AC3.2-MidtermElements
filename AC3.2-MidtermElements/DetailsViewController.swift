//
//  DetailsViewController.swift
//  AC3.2-MidtermElements
//
//  Created by Cris on 12/8/16.
//  Copyright © 2016 Cris. All rights reserved.
//

import UIKit

private let postURL = "https://api.fieldbook.com/v1/58488d40b3e2ba03002df662/favorites"

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var detailsTextView: UITextView!
    @IBOutlet weak var spinningCircle: UIActivityIndicatorView!
    
    
    
    var elements: Elements?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDetails()
        // Do any additional setup after loading the view.
    }
    
//    let id: Int
//    let record_url: String
//    let number: Int
//    let weight: Float
//    let name: String
//    let symbol: String
//    let melting_c: Int?
//    let boiling_c: Int?
//    let density: Int?
//    let crust_percent: Int?
//    let discovery_year: String
//    let group: Int
//    let electrons: String?
//    let ion_energy: Int?

    func loadDetails() {
        if let unwrappedElement = elements {
            self.title = unwrappedElement.name
            getImage(url: unwrappedElement.fullSize)
            
            let crust = unwrappedElement.crust_percent ?? ""
            let density = unwrappedElement.density ?? ""
            let boiling = unwrappedElement.boiling_c ?? ""
            let melting = unwrappedElement.melting_c ?? ""
            let electrons = unwrappedElement.electrons ?? ""
            let ions = unwrappedElement.ion_energy ?? ""
            
            detailsTextView.text = " Name: \(unwrappedElement.name) \n Symbol: \(unwrappedElement.symbol) \n Discovery Year: \(unwrappedElement.discovery_year) \n Weight: \(unwrappedElement.weight) \n Boiling: \(boiling)C \n Melting: \(melting)C \n Density: \(density) \n Crust Percent: \(crust) \n Group: \(unwrappedElement.group) \n Ion Energy: \(ions) \n Electrons: \(electrons)"
        }
        
    }
    func getImage(url: String) {
        spinningCircle.startAnimating()
        APIRequestManager.manager.getData(endPoint: url) { (data) in
            if let validata = data,
                let validImage = UIImage(data: validata) {
                DispatchQueue.main.async {
                    self.imageView.image = validImage
                    self.imageView.setNeedsLayout()
                    self.spinningCircle.stopAnimating()
                    self.spinningCircle.isHidden = true
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func AddToFavoritesPressed(_ sender: UIButton) {
        let dict = ["my_name" : "Chris",
        "favorite_element" : elements?.name]
        APIRequestManager.manager.postRequest(endPoint: postURL, data: dict)
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
