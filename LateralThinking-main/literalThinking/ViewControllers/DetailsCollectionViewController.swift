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
 //   var detailsCheckmarkButton: [UIColor] = []
 //   var detailsFavoriteButton: [UIColor] = []
    
    static var favoritesList: [FavoriteItem] = [] // Favori bilgilerini tutacak statik liste
    
    let scenarioImages: [[String]] = [["hotelRoom2","missingWoman2","lockedHouse2","lastRecord2","bankVault2","target2","silentPrisoner2","theWitness2","drawnLine2","corpseInDesert2"],
    ["corpseInDesert2","lockedHouse2","lastRecord2","","","","","","",""],
    ["lockedHouse2","lastRecord2","","","","","","","","","","",""],
    ["","","","","","","","","",""],
    ["","","","","","","","","",""],
    ["","","","","","","","","",""]]
    
    let visualImages: [[String]] = [["hotelRoom","missingWoman","lockedHouse","lastRecord","bankVault","target","silentPrisoner","theWitness","drawnLine","corpseInDesert"],
    ["corpseInDesert","lockedHouse","","","","","","","",""],
    ["","","","","","","","","",""],
    ["","","","","","",""],
    ["","","","","","",""]]
    
    let gameTitle: [[String]] = [["Indoor Hotel Room","The Missing Woman","Locked House","Last Record","The Corpse in the Locked Safe","Name on Target","The Silent Prisoner","The Witness","The Drawn Line","A Corpse in the Middle of the Desert"],
    ["xyz", "zyx", "xxx","","","","","","",""],
    ["","","","","","","","","","","","","",""],
    ["","","","","","","","","","","","","",""],
    ["","","","","","","","","","","","","",""]]
    
    let gameScenarios: [[String]] = [["Bir adam bir otel odasında, odanın kapısı içeriden zincirle kapatılmış şekilde ölü bulunur. Odanın camları içeriden kilitlidir ve kırılmamıştır.","Bir kadın gece evde yalnızken kapıyı kilitler ve yatmaya gider. Sabah uyandığında, evin kapısı hala kilitlidir, ancak evde bir başkasının ayak izleri vardır.","Bir kadın gece evde yalnızken kapıyı kilitler ve yatmaya gider. Sabah uyandığında, evin kapısı hala kilitlidir, ancak evde bir başkasının ayak izleri vardır.","","","","","","",""],
    ["xxx","yyy","zzz","","","","","","",""],
    ["","","","","","","","","","","","","",""],
    ["","","","","","","","","","","","","",""],
    ["","","","","","","","","","","","","",""]]
    
    let scenariosLabelColors : [[UIColor]] = [[.black, .black, .systemBackground, .black, .black],
    [.systemBackground, .systemBackground, .black, .systemBackground, .systemBackground, .black],
    [.systemBackground, .systemBackground, .black, .systemBackground, .systemBackground, .black],
    [.systemBackground, .systemBackground, .black, .systemBackground, .systemBackground, .black],
    [.systemBackground, .systemBackground, .black, .systemBackground, .systemBackground, .black]]
    
    let scenarioTitleColor: [[UIColor]] = [[.black, .black, .systemBackground, .black, .black],
    [.systemBackground, .systemBackground, .black],
    [.systemBackground, .systemBackground, .black],
    [],
    []]
    
    let solutionButtonColor: [[UIColor]] = [[.black, .black, .systemBackground, .black, .black],
    [.systemBackground, .systemBackground, .black],
    [.systemBackground, .systemBackground, .black],
    [],
    []]
    
    let solutionButtonFrameColor: [[UIColor]] = [[.black, .black, .systemBackground, .black, .black],
    [.systemBackground, .systemBackground, .black],
    [.systemBackground, .systemBackground, .black],
    [],
    []]
    
    let checkmarkButton: [[UIColor]] = [[.black, .black, .systemBackground, .black, .black],
    [.systemBackground, .systemBackground, .black],
    [.systemBackground, .systemBackground, .black],
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
        
        // FavoritesCollectionViewController'daki favori butonuna tıklandığında DetailsCollectionViewController'a haber verip buradaki butonun image'ını 'star' a dönüştürmek için:
        NotificationCenter.default.addObserver(self, selector: #selector(favoriteStatusChanged), name: Notification.Name("FavoriteStatusChanged"), object: nil)
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Favori listesini UserDefaults'tan yükle
        DetailsCollectionViewController.loadFavoritesFromUserDefaults()
        
        // Koleksiyon görünümünü yenile
        collectionView.reloadData()
    }

    // FavoritesCollectionViewController'daki favori butonuna tıklandığında DetailsCollectionViewController'a haber verip buradaki butonun image'ını 'star' a dönüştürmek için:
    @objc func favoriteStatusChanged() {
        // Bu fonksiyon, favori butonundaki değişiklikleri takip eder ve ilgili hücreyi günceller
        collectionView.reloadData()  // Favori durumunu yansıtmak için tüm collection view'ı yeniden yükleyin
    }
    deinit {
        // Bildirim dinleyicisini kaldır
        NotificationCenter.default.removeObserver(self, name: Notification.Name("FavoriteStatusChanged"), object: nil)
    }
    
    @IBAction func favoriteButtonClicked(_ sender: UIButton) {
        
        guard let cell = sender.superview?.superview as? DetailsCollectionViewCell,  // sender'ı UIButton olarak cast ediyoruz
            // UIButton'ın üst görünümlerinden hücreyi buluyoruz
                let indexPath = collectionView.indexPath(for: cell) else { return }
        
        
        let selectedDetailsItem = DetailsItem( // İlgili `DetailsItem`'i veri kaynağından al. bu kısımda favoritesviewcontroller'da gözüken dataları aktarıyoruz
            imageName: sectionImages[indexPath.row],
            title: sectionTitles[indexPath.row],
            titleColor: ColorWrapper(color: sectionTitleColors[indexPath.row])

            )
        let selectedGameScenario = ScenariosItem( // bu kısımda favoritesviewcontroller'daki cell e tıklandığında scenariosviewcontroller geçilirkenki aktarımları yapıyoruz
            gameScenario: gameScenarios[selectedSection][indexPath.row], // `gameScenario`yu `gameScenarios` dizisinden al
            backImage: scenarioImages[selectedSection][indexPath.row],
            frontImage: visualImages[selectedSection][indexPath.row]
        )
        let favoriteItem = FavoriteItem( // Bu kısımda da favoritesviewcontroller ve sonrasondaki scenariosviewcontroller'da gözükecek dataların section ve row bilgisi aktarılıyor
                section: selectedSection,
                row: indexPath.row,
                detailsItem: selectedDetailsItem,
                scenarioDetails: selectedGameScenario
            )
            
        // Eğer item zaten favorilerdeyse kaldır
        if let index = DetailsCollectionViewController.favoritesList.firstIndex(where: { $0.detailsItem.title == favoriteItem.detailsItem.title }) {
            DetailsCollectionViewController.favoritesList.remove(at: index)
            sender.setImage(UIImage(systemName: "star"), for: .normal) // İçi boş yıldız
                print("Favori kaldırıldı")
            } else {
                DetailsCollectionViewController.favoritesList.append(favoriteItem) // yoksa ekle
                sender.setImage(UIImage(systemName: "star.fill"), for: .normal) // İçi dolu yıldız
                print("Favori eklendi")
            }
        
        DetailsCollectionViewController.saveFavoritesToUserDefaults()

    }
    
}

extension DetailsCollectionViewController: UICollectionViewDelegateFlowLayout  {
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toScenarios",
           let destinationVC = segue.destination as? ScenariosViewController {
            
            if let scenariosDatas = sender as? (String, String, String, String, UIColor, UIColor, UIColor, UIColor, Int, UIColor) {
                
                destinationVC.scenariosImages = scenariosDatas.0
                destinationVC.visualImages = scenariosDatas.1
                destinationVC.gameTitle = scenariosDatas.2
                destinationVC.gameScenario = scenariosDatas.3
                destinationVC.scenarioLabelColor = scenariosDatas.4
                destinationVC.scenarioTitleColor = scenariosDatas.5
                destinationVC.solutionButtonColor = scenariosDatas.6
                destinationVC.solutionButtonFrameColor = scenariosDatas.7
                destinationVC.selectedSection = selectedSection
                destinationVC.selectedIndexPathRow = scenariosDatas.8
                destinationVC.scenarioCheckmarkButton = scenariosDatas.9
            }
        }
    }
    
    
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
        cell.detailsCheckmarkButton.tintColor = .systemIndigo
        cell.detailsFavoriteButton.tintColor = .systemIndigo
        /*
        if indexPath.row < detailsCheckmarkButton.count {
            cell.detailsCheckmarkButton.tintColor = detailsCheckmarkButton[indexPath.row]
        } else {
            cell.detailsCheckmarkButton.tintColor = .black
        }
        
        if indexPath.row < detailsFavoriteButton.count {
            cell.detailsFavoriteButton.tintColor = detailsFavoriteButton[indexPath.row]
        } else {
            cell.detailsFavoriteButton.tintColor = .black
        }
        */
        cell.selectedIndexPathRow = indexPath.row // detailscollectionviewcell deki rowindex değerini detailscollectionviewcontroller daki indexpath e set et
        cell.selectedSection = selectedSection
        
        // UserDefaults'tan durumları kontrol ederek buton görünürlüğünü ayarla
        let key = "isSolved_Section\(selectedSection)_Row\(indexPath.row)"
        let isSolved = UserDefaults.standard.bool(forKey: key)
        cell.detailsCheckmarkButton.isHidden = !isSolved
        
        // favori butonuna tıklandığında değişen buton image ındaki değişikliği uygulama kapanıp açıldığında kaydetmek için:
        let isFavorite = DetailsCollectionViewController.favoritesList.contains(where: { $0.section == selectedSection && $0.row == indexPath.row })
        if isFavorite {
            cell.detailsFavoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal) // İçi dolu yıldız
        } else {
            cell.detailsFavoriteButton.setImage(UIImage(systemName: "star"), for: .normal) // İçi boş yıldız
        }
        
        return cell
    }
    
    // cell ler arasındaki boşluk olmaması için
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
            let totalSpacing = 0 // (minimumInteritemSpacing + sectionInset toplamı)
            let numberOfItemsPerRow: CGFloat = 2 // Kaç sütun istediğiniz
            let width = (collectionView.frame.width - CGFloat(totalSpacing) ) / numberOfItemsPerRow
        
            return CGSize(width: floor(width), height: 160)
    }
    // cell ler arasındaki boşluk olmaması için
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0 // Satır boşlukları
    }
    // cell ler arasındaki boşluk olmaması için
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0 // Hücreler arası boşluk
    }
    // cell ler arasındaki boşluk olmaması için
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) // Kenar boşlukları
    }

    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedVisualName = visualImages[selectedSection][indexPath.row] // selectedSection ile section bilgisi veriyoruz (kaçıncı section'dan gelicek bilgiler)
        let selectedImageName = scenarioImages[selectedSection][indexPath.row]
        let selectedTitleName = gameTitle[selectedSection][indexPath.row]
        let selectedGameScenario = gameScenarios[selectedSection][indexPath.row]
        let selectedLabelColor = scenariosLabelColors[selectedSection][indexPath.row]
        let selectedTitleColor = scenarioTitleColor[selectedSection][indexPath.row]
        let selectedSolutionButtonColor = solutionButtonColor[selectedSection][indexPath.row]
        let selectedSolutionButtonFrameColor = solutionButtonFrameColor[selectedSection][indexPath.row]
        let selectedCheckmark = checkmarkButton[selectedSection][indexPath.row]
        performSegue(withIdentifier: "toScenarios", sender: (selectedImageName, selectedVisualName, selectedTitleName, selectedGameScenario, selectedLabelColor, selectedTitleColor,selectedSolutionButtonColor, selectedSolutionButtonFrameColor, indexPath.row, selectedCheckmark)) // buradaki indexPath.row hangi cell e tıklandığı bilgisini diğer viewcontroller lara göndermek için oluşturuldu
        
       
    }
    
    // user defaults'a kaydetme (favoritesviewcontroller'da da bu fonksiyonu çağırıyoruz). viewdidload'lara yazmadık çünkü aynı kod favoritesviewcontroller'da da kullanılıyor
    static func saveFavoritesToUserDefaults() {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(favoritesList) {
                UserDefaults.standard.set(encoded, forKey: "favoritesList")
                UserDefaults.standard.synchronize() // Verileri hemen kaydeder. kaydedilen son cell uygulama kapanıp açıldığında kayboluyordu. bu kodla kaybolmuyor
            }
        }
        
    static func loadFavoritesFromUserDefaults() {
        let decoder = JSONDecoder()
        if let data = UserDefaults.standard.data(forKey: "favoritesList"),
            let decoded = try? decoder.decode([FavoriteItem].self, from: data) {
            favoritesList = decoded
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
