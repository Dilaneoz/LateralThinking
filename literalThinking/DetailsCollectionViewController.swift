//
//  DetailsCollectionViewController.swift
//  literalThinking
//
//  Created by Dilan Öztürk on 29.10.2024.
//

import UIKit

private let reuseIdentifier = "Cell"

class DetailsCollectionViewController: UICollectionViewController {
    
    var sectionTitles: [String] = []
    var sectionImages: [String] = []
    var sectionName: String? // Başlık için
    
    var sectionTitleColors: [UIColor] = []
    
    var selectedSection: Int = 0 // MainViewController'dan gelen section bilgisi
    
    let scenarioImages: [[String]] = [["hotelRoom2","missingWoman2","lockedHouse2","lastRecord2","bankVault2","target2","silentPrisoner2","theWitness2","drawnLine2","corpseInDesert2"],
    ["corpseInDesert2","lockedHouse2","lastRecord2","","",""],
    ["lockedHouse2","lastRecord2","","","",""],
    ["","",""],
    ["","",""],
    ["","",""]]
    
    let visualImages: [[String]] = [["hotelRoom","missingWoman","lockedHouse","lastRecord","bankVault","target","silentPrisoner","theWitness","drawnLine","corpseInDesert"],
    ["corpseInDesert","lockedHouse",""],
    ["","",""],
    [],
    []]
    
    let gameTitle: [[String]] = [["Indoor Hotel Room","The Missing Woman","Locked House","Last Record","The Corpse in the Locked Safe","Name on Target","The Silent Prisoner","The Witness","The Drawn Line","A Corpse in the Middle of the Desert"],
    ["xyz", "zyx", "xxx"],
    [],
    [],
    []]
    
    let gameScenarios: [[String]] = [["Bir adam bir otel odasında, odanın kapısı içeriden zincirle kapatılmış şekilde ölü bulunur. Odanın camları içeriden kilitlidir ve kırılmamıştır.","Bir kadın gece evde yalnızken kapıyı kilitler ve yatmaya gider. Sabah uyandığında, evin kapısı hala kilitlidir, ancak evde bir başkasının ayak izleri vardır.","Bir kadın gece evde yalnızken kapıyı kilitler ve yatmaya gider. Sabah uyandığında, evin kapısı hala kilitlidir, ancak evde bir başkasının ayak izleri vardır.","","","","","","",""],
    ["xxx","yyy","zzz"],
    [],
    [],
    []]
    
    let scenariosLabelColors : [[UIColor]] = [[.black, .black, .systemBackground],
    [.systemBackground, .systemBackground, .black],
    [],
    [],
    []]
    
    let scenarioTitleColor: [[UIColor]] = [[.black, .black, .systemBackground],
    [.systemBackground, .systemBackground, .black],
    [],
    [],
    []]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor.systemRed
        
        self.navigationController?.navigationBar.tintColor = UIColor.systemBackground // back butonu rengi
        appearance.titleTextAttributes = [
                .foregroundColor: UIColor.systemBackground, // navigation bar aşlık metninin rengi
                .font: UIFont.systemFont(ofSize: 20)    // navigation bar başlık yazı tipi ve boyutu
            ]
        
        let layout = UICollectionViewFlowLayout()
            
               layout.minimumInteritemSpacing = 0  // Yatay boşluk yok
               layout.minimumLineSpacing = 0      // Dikey boşluk yok
          //   layout.sectionInset = .zero        // Kenarlarda boşluk yok
          //   layout.scrollDirection = .vertical  // Dikey kaydırma
               
        collectionView.collectionViewLayout = layout
        
        if let sectionName = sectionName {
                self.navigationItem.title = sectionName
            }
        
        self.navigationItem.scrollEdgeAppearance = appearance
        self.navigationItem.standardAppearance = appearance // bunların neden altta olması gerekiyor, navigation kodlarının üstünde olunca çalışmıyor navigation kodları
    }
    
}

extension DetailsCollectionViewController: UICollectionViewDelegateFlowLayout  {
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return sectionTitles.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! DetailsCollectionViewCell
        
        cell.detailsLabel.text = sectionTitles[indexPath.row]
        cell.detailsImage.image = UIImage(named: sectionImages[indexPath.row])
        
        // Her label için farklı renk atama
        if indexPath.row < sectionTitleColors.count {
            cell.detailsLabel.textColor = sectionTitleColors[indexPath.row]
        } else {
            cell.detailsLabel.textColor = .systemBackground // sectionTitleColors değerleri olması gerekenden azsa, yani eksik değer varsa
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 201, height: 165)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedVisualName = visualImages[selectedSection][indexPath.row] // section bilgisi veriyoruz (kaçıncı section'dan gelicek bilgiler)
        let selectedImageName = scenarioImages[selectedSection][indexPath.row]
        let selectedTitleName = gameTitle[selectedSection][indexPath.row]
        let selectedGameScenario = gameScenarios[selectedSection][indexPath.row]
        let selectedLabelColor = scenariosLabelColors[selectedSection][indexPath.row]
        let selectedTitleColor = scenarioTitleColor[selectedSection][indexPath.row]
        performSegue(withIdentifier: "toScenarios", sender: (selectedImageName, selectedVisualName, selectedTitleName, selectedGameScenario, selectedLabelColor, selectedTitleColor))
        
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toScenarios",
           let destinationVC = segue.destination as? ScenariosViewController {
            
            if let scenariosImages = sender as? (String, String, String, String, UIColor, UIColor) {
                
                destinationVC.scenariosImages = scenariosImages.0
                destinationVC.visualImages = scenariosImages.1
                destinationVC.gameTitle = scenariosImages.2
                destinationVC.gameScenario = scenariosImages.3
                destinationVC.scenarioLabelColor = scenariosImages.4
                destinationVC.scenarioTitleColor = scenariosImages.5
            }
            
        }
        
    }
    
 
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
    
}
