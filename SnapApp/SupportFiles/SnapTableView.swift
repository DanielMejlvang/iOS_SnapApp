//
//  SnapTableView.swift
//  SnapApp
//
//  Created by Daniel Mejlvang Rasmussen on 20/05/2021.
//

import UIKit

class SnapTableView: NSObject, UITableViewDataSource, UITableViewDelegate {
    // MARK: - Table View

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fbs.snaps.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mycell", for: indexPath)
        let object = fbs.snaps[indexPath.row]
        cell.textLabel!.text = "New snap from \(object.from!)"
        cell.textLabel!.font = UIFont(name: cell.textLabel!.font.fontName, size:24)
        return cell
    }
        
    //methods which will be called when you interact with the table
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        fbs.deleteRecipe(docID: fbs.recipes[indexPath.row].recipeID, index: indexPath.row)
//        tableView.deleteRows(at: [indexPath], with: .fade)
    }
}
