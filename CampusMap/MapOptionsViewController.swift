//
//  MapOptionsViewController.swift
//  CampusMap
//
//  Created by Chun on 2018/11/27.
//  Copyright © 2018 Nemoworks. All rights reserved.
//

import UIKit


enum MapOptionsType: Int {
    case mapBoundary = 0
    case library
    case food
    case buildings
    case supermarket
    case firstaid
    case sport
    case mountain
    
    func displayName() -> String {
        switch (self) {
        case .mapBoundary:
            return "校园边界"
        case .library:
            return "图书馆"
        case .food:
            return "美食"
        case .buildings:
            return "教学楼"
        case .supermarket:
            return "超市"
        case .firstaid:
            return "医院"
        case .sport:
            return "体育馆"
        case .mountain:
            return "山地"
        }
    }
}

class MapOptionsViewController: UIViewController {

    var selectedOptions = [MapOptionsType]()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


// MARK: - UITableViewDataSource
extension MapOptionsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OptionCell")!
        
        if let mapOptionsType = MapOptionsType(rawValue: indexPath.row) {
            cell.textLabel!.text = mapOptionsType.displayName()
            cell.accessoryType = selectedOptions.contains(mapOptionsType) ? .checkmark : .none
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MapOptionsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        guard let mapOptionsType = MapOptionsType(rawValue: indexPath.row) else { return }
        
        if (cell.accessoryType == .checkmark) {
            // Remove option
            selectedOptions = selectedOptions.filter { $0 != mapOptionsType}
            cell.accessoryType = .none
        } else {
            // Add option
            selectedOptions += [mapOptionsType]
            cell.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
