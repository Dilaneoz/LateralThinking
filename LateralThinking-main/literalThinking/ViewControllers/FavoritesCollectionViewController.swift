//
//  FavoritesCollectionViewController.swift
//  literalThinking
//
//  Created by Dilan Öztürk on 14.12.2024.
//

import UIKit

private let reuseIdentifier = "FavoriteCell"

class FavoritesCollectionViewController: UICollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor.systemRed
        
        let layout = UICollectionViewFlowLayout()
            
        layout.minimumInteritemSpacing = 0  // Yatay boşluk yok
        layout.minimumLineSpacing = 0      // Dikey boşluk yok
               
        collectionView.collectionViewLayout = layout
        
        self.navigationItem.scrollEdgeAppearance = appearance
        self.navigationItem.standardAppearance = appearance // bunların altta olması gerekiyor, navigation kodlarının üstünde olunca çalışmıyor navigation kodları. bunun sebebi self.navigationItem'ın tam olarak yüklenmesi ve konfigüre edilmesinden sonra appearance yapılandırmalarının uygulanması gerekmesi
    
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DetailsCollectionViewController.loadFavoritesFromUserDefaults()
        
        collectionView.reloadData()
    }

    
    @IBAction func favoriteButtonClicked(_ sender: UIButton) {
        
        // Butonun ait olduğu cell'i bul
        guard let cell = sender.superview?.superview as? FavoritesCollectionViewCell,
            let indexPath = collectionView.indexPath(for: cell) else { return }

        // İlgili item'ı FavoritesCollectionViewController'dan kaldır
        DetailsCollectionViewController.favoritesList.remove(at: indexPath.row)

        sender.setImage(UIImage(systemName: "star"), for: .normal) // Butonun resmini "star" (içi boş yıldız) yap. bunu NotificationCenter ile DetailsCollectionViewController bildiricez ve DetailsCollectionViewController'daki favori butonu star.fill'den star a dönüşecek
        
        DetailsCollectionViewController.saveFavoritesToUserDefaults() // Değişiklikleri kaydet
        
        collectionView.deleteItems(at: [indexPath]) // Favori butonuna tıklayıp ilgili cell i kaldırdığımızda, cell'i controllerdan hemen silmek için
        
        // Burada, DetailsCollectionViewController'daki butonu da güncellemek -yani oradaki image'ı 'star' a dönüştürmek- için bildirim yapıyoruz
        NotificationCenter.default.post(name: Notification.Name("FavoriteStatusChanged"), object: nil)
        
    }
    
}


extension FavoritesCollectionViewController: UICollectionViewDelegateFlowLayout  {
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {

        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return DetailsCollectionViewController.favoritesList.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
   
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FavoritesCollectionViewCell
            
        let detailsItem = DetailsCollectionViewController.favoritesList[indexPath.row]
            cell.favoritesImageView.image = UIImage(named: detailsItem.detailsItem.imageName)
            cell.favoritesLabel.text = detailsItem.detailsItem.title
            cell.favoritesLabel.textColor = detailsItem.detailsItem.titleColor.color // label renklerini detailsviewcontrollerda olduğu gibi aktarıyoruz

        
        cell.favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal) // Butonun default halini "star.fill" (dolu yıldız) olarak ayarlıyoruz
        cell.favoriteButton.tintColor = .systemIndigo
        
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
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) { // ScenariosViewController'a aktarılma
    
        let selectedFavorite = DetailsCollectionViewController.favoritesList[indexPath.row] // Favori itemini al
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil) // Storyboard'dan ScenariosViewController'ı oluştur
        if let scenariosVC = storyboard.instantiateViewController(withIdentifier: "ScenariosViewController") as? ScenariosViewController {
            
            // İlgili verileri aktar
            scenariosVC.selectedSection = selectedFavorite.section
            scenariosVC.selectedIndexPathRow = selectedFavorite.row
            scenariosVC.scenariosImages = selectedFavorite.detailsItem.imageName
            scenariosVC.gameTitle = selectedFavorite.detailsItem.title
            scenariosVC.gameScenario = selectedFavorite.scenarioDetails.gameScenario 
            scenariosVC.scenariosImages = selectedFavorite.scenarioDetails.backImage
            scenariosVC.visualImages = selectedFavorite.scenarioDetails.frontImage
           
            navigationController?.pushViewController(scenariosVC, animated: true) // Geçiş yap
            }
    
    }

    // MARK: UICollectionViewDelegate

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
