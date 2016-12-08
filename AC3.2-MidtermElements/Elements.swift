//
//  Elements.swift
//  AC3.2-MidtermElements
//
//  Created by Cris on 12/8/16.
//  Copyright © 2016 Cris. All rights reserved.
//

import Foundation

class Elements {
    
    let id: Int
    let record_url: String
    let number: Int
    let weight: Float
    let name: String
    let symbol: String
    let melting_c: String?
    let boiling_c: String?
    let density: String?
    let crust_percent: String?
    let discovery_year: String
    let group: Int
    let electrons: String?
    let ion_energy: String?
    
    var thumbnail: String {
        return "https://s3.amazonaws.com/ac3.2-elements/\(symbol)_200.png"
    }
    
    var fullSize: String {
        return "https://s3.amazonaws.com/ac3.2-elements/\(symbol).png"
    }
    
    init( id: Int, record_url: String, number: Int, weight: Float, name: String, symbol: String, melting_c: String?, boiling_c: String?, density: String?, crust_percent: String?, discovery_year: String, group: Int, electrons: String?, ion_energy: String?) {
        self.id = id
        self.record_url = record_url
        self.number = number
        self.weight = weight
        self.name = name
        self.symbol = symbol
        self.melting_c = melting_c
        self.boiling_c = boiling_c
        self.density = density
        self.crust_percent = crust_percent
        self.discovery_year = discovery_year
        self.group = group
        self.electrons = electrons
        self.ion_energy = ion_energy
    }
    
    convenience init?(from Dict: [String : Any]) {
        guard let id = Dict["id"] as? Int,
            let record_url = Dict["record_url"] as?  String,
            let number = Dict["number"] as? Int,
            let weight = Dict["weight"] as? Float,
            let name = Dict["name"] as?String,
            let symbol = Dict["symbol"] as? String,
            let discovery_year = Dict["discovery_year"] as? String,
            let group = Dict["group"] as? Int
            else { return nil }
        
        let melting_c = Dict["melting_c"] as? Int ?? nil
        let boiling_c = Dict["boiling_c"] as? Int ?? nil
        let density = Dict["density"] as? Int ?? nil
        let crust_percent = Dict["crust_percent"] as? Int ?? nil
        let electrons = Dict["electrons"] as? String ?? nil
        let ion_energy = Dict["ion_energy"] as? Int ?? nil
        
        self.init(id: id, record_url: record_url, number: number, weight: weight, name: name, symbol: symbol, melting_c: melting_c?.description, boiling_c: boiling_c?.description, density:density?.description, crust_percent: crust_percent?.description, discovery_year: discovery_year, group: group, electrons: electrons, ion_energy: ion_energy?.description)
        
    }
    
    static func parseElements(from data: Data) -> [Elements]? {
        var parsedElements = [Elements]()
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            guard let jsonArray = json as? [[String : Any]] else { return nil}
            jsonArray.forEach({ (elementObject) in
                guard let returnedElement = Elements(from: elementObject) else { return }
                parsedElements.append(returnedElement)
            })
        }
        catch {
            print("ERROR: \(error.localizedDescription)")
        }
        return parsedElements
    }
    
    
}
