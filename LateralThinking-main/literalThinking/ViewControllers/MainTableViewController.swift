//
//  MainTableViewController.swift
//  literalThinking
//
//  Created by Dilan Öztürk on 18.10.2024.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    let gameTitles : [[String]] = [["Indoor Hotel Room","The Missing Woman","Locked House","Last Record","The Corpse in the Locked Safe","Name on Target","The Silent Prisoner","The Witness","The Drawn Line","A Corpse in the Middle of the Desert"],
        ["Asansör Yolculuğu","Zehirli Yemek","Çalışan Bilgisayar","","",""],
        ["Ormanın derinliklerinde","Neredeyse Ölüyorlardı","","","",""],
        ["","","","","","","","","",""],
        ["","","","","","","","","",""]]
    
    let gameImages : [[String]] = [["hotelRoom","missingWoman","lockedHouse","lastRecord","bankVault","target","silentPrisoner","theWitness","drawnLine","corpseInDesert"],["corpseInDesert","lockedHouse","lastRecord","","",""],
        ["hotelRoom","missingWoman","","","","","","","","","","",""],
        ["","","","","","","","","",""],
        ["","","","","","","","","",""],
        ["","","","","","","","","",""]]
    
    let sectionNames = ["Mystery & Crime", "Supernatural", "Science & Technology","Everyday Life","Nature & Environment"]
    
    let sectionTitleColorsMain: [[UIColor]] = [[.black, .black, .systemBackground, .black, .systemBackground, .systemBackground, .systemBackground, .black, .systemBackground, .systemBackground],
        [.systemBackground, .systemBackground, .black],
        [.black, .black, .systemBackground, .systemBackground, .black],
        [],
        []]
    /*
    let checkmarkButton: [[UIColor]] = [[.systemIndigo, .systemIndigo, .systemBackground, .systemIndigo],
    [.systemBackground, .systemBackground, .systemIndigo],
    [],
    [],
    []]
    
    let favoritesButton: [[UIColor]] = [[.systemIndigo, .systemIndigo, .systemBackground, .systemIndigo, .systemBackground, .systemBackground, .systemBackground, .systemIndigo, .systemBackground, .systemBackground],
    [.systemBackground, .systemBackground, .systemIndigo],
    [],
    [],
    []]
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.selectedIndex = 1 //uygulama ilk açıldığında bu tabbar'ı göster
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor.systemRed
        self.navigationItem.scrollEdgeAppearance = appearance
        
        let titleLabel = UILabel()
        titleLabel.text = "Lateral Thinking"
        titleLabel.font = UIFont(name: "Rockwell-Bold", size: 24)
        titleLabel.textColor = .systemGray6
        titleLabel.sizeToFit() // Boyutunu metne göre ayarla
        titleLabel.frame = CGRect(x: 0, y: 0, width: 500, height: 44) // navigationItem'ı sola kaydırma
        self.navigationItem.titleView = titleLabel // TitleView olarak label'ı ayarla
        
        tabBarController?.tabBar.barTintColor = UIColor.systemBackground
        
        
        if let tabBarController = self.tabBarController {
            let tabBarItemImage = UIImage(named: "puzzle")?.withRenderingMode(.alwaysOriginal)
            tabBarController.tabBar.items?[1].image = tabBarItemImage // 0, ilk item'ı temsil eder
        }
    
    }
}

extension MainTableViewController {

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 5
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return 1
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return section == 0 ? 50 : 17
        }
    
        // Section ayaklıklarının yüksekliğini ayarlama
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
            return 25
        }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let section = indexPath.section // Seçilen section
        performSegue(withIdentifier: "toDetails", sender: section)
        
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
            if segue.identifier == "toDetails",
                let destinationVC = segue.destination as? DetailsCollectionViewController {
                if let section = sender as? Int {
                    // Verileri ikinci ViewController'a gönder
                    destinationVC.sectionTitles = gameTitles[section]
                    destinationVC.sectionImages = gameImages[section]
                    destinationVC.sectionName = sectionNames[section] // navigation bar daki başlıklar
                    destinationVC.sectionTitleColors = sectionTitleColorsMain[section] // Her label için farklı renk atama
                    destinationVC.selectedSection = section // Seçilen section bilgisini DetailsCollectionViewController'a aktar
           //         destinationVC.detailsCheckmarkButton = checkmarkButton[section]
           //         destinationVC.detailsFavoriteButton = favoritesButton[section]
                }
            }
        }
    
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
