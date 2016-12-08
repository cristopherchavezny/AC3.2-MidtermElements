//
//  ElementsTableViewController.swift
//  AC3.2-MidtermElements
//
//  Created by Cris on 12/8/16.
//  Copyright © 2016 Cris. All rights reserved.
//

import UIKit

private let reusableCellIdentifier = "ElementCell"
private let getElementsURL = "https://api.fieldbook.com/v1/58488d40b3e2ba03002df662/elements"

class ElementsTableViewController: UITableViewController {
    var elements = [Elements]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Elements"
        APICall()
    }
    func APICall() {
        APIRequestManager.manager.getData(endPoint: getElementsURL) { (data: Data?) in
            if let validData = data,
                let parsedElements = Elements.parseElements(from: validData) {
                self.elements = parsedElements.sorted{$0.name < $1.name}
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return elements.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reusableCellIdentifier, for: indexPath)
        if let customCell = cell as? ElementTableViewCell {
            let sortedElements = elements[indexPath.row]
            customCell.nameLabel.text = sortedElements.name
            customCell.symbolAtomicWeightLabel.text = "\(sortedElements.symbol)(\(sortedElements.number)) \(sortedElements.weight) "
            
            APIRequestManager.manager.getData(endPoint: sortedElements.thumbnail) { (data) in
                if let validData = data {
                    let validImage = UIImage(data: validData)
                    DispatchQueue.main.async {
                        customCell.thumbnailView.image = validImage
                        customCell.setNeedsLayout()
                    }
                }
            }
        }
        return cell
    }

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let selected = sender as? ElementTableViewCell,
            let indexPath = tableView.indexPath(for: selected),
            let destinationVC = segue.destination as? DetailsViewController {
            destinationVC.elements = elements[indexPath.row]
        }
    }
    
}
