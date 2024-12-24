//
//  DetailsCollectionViewCell.swift
//  literalThinking
//
//  Created by Dilan Öztürk on 29.10.2024.
//

import UIKit

class DetailsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var detailsImage: UIImageView!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var detailsCheckmarkButton: UIButton!
    @IBOutlet weak var detailsFavoriteButton: UIButton!
    
    var selectedIndexPathRow: Int?
    var selectedSection: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
      //  self.layer.cornerRadius = 30 // Yuvarlatma miktarı
      //  self.layer.masksToBounds = true // Alt view'leri kesmek için
      //  self.layer.borderWidth = 1
      //  self.layer.borderColor = UIColor.black.cgColor
        
        detailsCheckmarkButton.isHidden = true // Başlangıçta gizle
        
        // Her hücre için UserDefaults'tan durumları kontrol edin
        if let row = selectedIndexPathRow { // cell bilgisi
            let key = "isSolved_Section\(selectedSection)_Row\(row)"
            let isSolved = UserDefaults.standard.bool(forKey: key) // seçilen section ve cell e ve section a göre solutionsviewcontrollerdaki markAsSolvedButton unun güncellenme bilgisine göre değişecek olan scenariosCheckmarkButton butonunun güncellenmiş bilgisini kaydet
            detailsCheckmarkButton.isHidden = !isSolved
        }
        
        // Bildirimleri dinle
        NotificationCenter.default.addObserver(self, selector: #selector(handleMarkAsSolvedNotification(_:)), name: NSNotification.Name("MarkAsSolvedNotification"), object: nil)
    }
    
    @objc func handleMarkAsSolvedNotification(_ notification: Notification) {
        
        if let userInfo = notification.object as? [String: Any],
           let section = userInfo["section"] as? Int, // hangi sectiondan geldiği bilgisi
           let row = userInfo["row"] as? Int, // hangi cell den geldiği bilgisi
           let isSolved = userInfo["isSolved"] as? Bool, // solutionsviewcontroller daki markAsSolvedButton butonuna tıklanıp tıklanmadığı bilgisi
            
            section == selectedSection, // Sadece ilgili section
            row == selectedIndexPathRow { // Sadece ilgili row
            
            // Butonun durumunu UserDefaults'tan kontrol ederek güncelle
            let key = "isSolved_Section\(section)_Row\(row)"
            UserDefaults.standard.set(isSolved, forKey: key) // solutionsviewcontrollerdaki markAsSolvedButton butonuna tıklanıp tıklanmadığı ilgili section ve celle bakarak kontrol et
            
            // Eğer solutionviewcontrollerdaki markAsSolvedButton işaretlenmişse, scenariosCheckmarkButton ı görünür yap
            detailsCheckmarkButton.isHidden = !isSolved
        }
    }
        
        deinit {
            // Notification dinleyicisini kaldır. solutionviewcontrollerdaki markAsSolvedButton a ikinci kez tıklandığında (tikleme kaldırıldığında) scenariosCheckmarkButton ı gizle
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name("MarkAsSolvedNotification"), object: nil)
        }
        
    

}
