//
//  SolutionsViewController.swift
//  literalThinking
//
//  Created by Dilan Öztürk on 7.12.2024.
//

import UIKit

class SolutionsViewController: UIViewController {

    @IBOutlet weak var solutionsImageView: UIImageView!
    @IBOutlet weak var solutionsTitleLabel: UILabel!
    @IBOutlet weak var solutionsLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var markAsSolvedButton: UIButton!
    
    var solutionImageView: String?
    var solutionLabel: String?
    var solutionTitleColor: UIColor?
    var solutionLabelColor: UIColor?
    var shareButtonColor: UIColor?
    var markAsSolved: UIColor?
    var selectedIndexPathRow: Int? // hangi cell in seçildiği bilgisi (detailsviewcontroller daki)
    var selectedSection: Int = 0 // hangi section ın seçildiği bilgisi (mainviewcontroller daki)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let solutionImageView = solutionImageView {
            solutionsImageView.image = UIImage(named: solutionImageView)
        }
        
        if let solutionLabel = solutionLabel {
            solutionsLabel.text = solutionLabel
        }
        
        solutionsTitleLabel.textColor = solutionTitleColor ?? .black
        solutionsLabel.textColor = solutionLabelColor ?? .black
        shareButton.tintColor = shareButtonColor ?? .black
        markAsSolvedButton.tintColor = markAsSolved ?? .black
        
        let key = "isSolved_Section\(selectedSection)_Row\(selectedIndexPathRow ?? -1)" // buradaki -1 bir değer atanmadığını (veya geçersiz olduğunu) belirtir. yazılımda genelde bu ifade kullanılır
        let isSolved = UserDefaults.standard.bool(forKey: key)
        let newImageName = isSolved ? "checkmark.square" : "square"
        markAsSolvedButton.setImage(UIImage(systemName: newImageName), for: .normal)
        markAsSolvedButton.setTitle(" Mark As Solved", for: .normal)
        
    }
    
    
    @IBAction func markAsSolvedButtonClicked(_ sender: Any) {
        
        // Butonun mevcut durumu
        let isSolved = markAsSolvedButton.currentImage == UIImage(systemName: "square")
            
        // Görselleri ve yazıyı güncelle
        let newImageName = isSolved ? "checkmark.square" : "square"
        markAsSolvedButton.setImage(UIImage(systemName: newImageName), for: .normal)
        markAsSolvedButton.setTitle(" Mark As Solved", for: .normal)
        
        // diğer viewcontroller larla iletişim kurarak markAsSolvedButton daki güncellenmiş bilgiyi paylaşıcaz
        if let selectedIndexPathRow = selectedIndexPathRow {
            NotificationCenter.default.post(name: NSNotification.Name("MarkAsSolvedNotification"), object: ["section": selectedSection, "row": selectedIndexPathRow, "isSolved": isSolved])
        }
        
        let key = "isSolved_Section\(selectedSection)_Row\(selectedIndexPathRow ?? -1)"
        UserDefaults.standard.set(isSolved, forKey: key) // Durumu UserDefaults'a kaydet
    
}
    

    @IBAction func sharedButtonClicked(_ sender: Any) {
        
    // App Store URL'si ve paylaşım mesajı
        let appStoreLink = "https://apps.apple.com/app/idYOUR_APP_ID" // Buraya uygulamanızın gerçek App Store bağlantısını koy
        let shareText = """
        🚀 Can you solve this mystery? 
        Download and explore: \(appStoreLink)
        """
    
    // Paylaşılacak görüntüyü almak
        guard let image = UIImage(named: "lockedHouse") else {
            print("Image not found!")
            return
        }
        
    // Paylaşım ekranını başlat
        let activityViewController = UIActivityViewController(activityItems: [image, shareText], applicationActivities: nil)
        
    // iPad uyumluluğu için popover ayarı
        if let popoverController = activityViewController.popoverPresentationController,
            let button = sender as? UIButton {
            popoverController.sourceView = button
            popoverController.sourceRect = button.bounds
        }
        
        present(activityViewController, animated: true)
        
    }
    
    
}
