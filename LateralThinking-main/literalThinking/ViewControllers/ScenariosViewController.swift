//
//  ScenariosViewController.swift
//  literalThinking
//
//  Created by Dilan Öztürk on 2.12.2024.
//

import UIKit

class ScenariosViewController: UIViewController {

    @IBOutlet weak var scenariosImageView: UIImageView!
    @IBOutlet weak var visualsImageView: UIImageView!
    @IBOutlet weak var scenariosTitleLabel: UILabel!
    @IBOutlet weak var scenariosLabel: UILabel!
    @IBOutlet weak var solutionButton: UIButton!
    @IBOutlet weak var scenariosCheckmarkButton: UIButton!
    
    var scenariosImages: String?
    var visualImages: String?
    var gameTitle: String?
    var gameScenario: String?
    var scenarioLabelColor: UIColor?
    var scenarioTitleColor: UIColor?
    var solutionButtonColor: UIColor?
    var solutionButtonFrameColor: UIColor?
    var selectedSection: Int = 0 // hangi section ın seçildiği bilgisi
    var selectedIndexPathRow: Int? // Hangi cell in seçildiği bilgisi
    var scenarioCheckmarkButton: UIColor?
    
    let solutionImageView: [[String]] = [["hotelRoom2","missingWoman2","lockedHouse2","lastRecord2","bankVault2","target2","silentPrisoner2","theWitness2","drawnLine2","corpseInDesert2"],
        ["corpseInDesert2","lockedHouse2","lastRecord2","","",""],
        ["lockedHouse2","lastRecord2","","","",""],
        ["","",""],
        ["","",""],
        ["","",""]]
    
    var solutionName: [[String]] = [["Adam bir otel kat görevlisi ya da biri tarafından öldürülmüştür, ancak katil odadan çıkarken kapıyı zincirle kapatmış ve kapıyı hafifçe aralayarak odanın dışından bir tel kullanarak zinciri yerleştirmiştir. Olay cinayet gibi görünmemesi için düzenlenmiştir.","Kadın, adamın sevgilisi değil, ona şantaj yapan bir ajandı. Kadın, adamın hatırlayamayacağı bir ilaç verdi ve uyku sırasında kendisini yaralı gibi gösteren sahte bir olay planladı. Adam uyandığında kanlı bir yastık buldu, ancak kadın çoktan kaybolmuştu. Kadın, adamdan büyük miktarda para talep etmek için bu senaryoyu oluşturmuştu.","Eve giren kişi, evde yaşayan birinin (örneğin bir partner ya da aile üyesinin) anahtarını kullanmıştır. Kadın bunu fark etmemiştir, çünkü ayak izleri ona tanıdık gelmemiştir. Eve giren kişi ev sahibinin haberi olmadan eve girmiştir."],
    ["Gazeteci, bir mafya grubuyla ilgili bilgi topluyordu. Mafya, gazeteciyi tehdit etmek için odasına geldi. Gazeteci, kendisini öldürmek üzere olduklarını anladığında kamerayı gizlice çalıştırdı ve ölüm anını kaydetti. Video kaydını bulan dedektif mafyanın kimliğini belirledi.","Adam, soyguncuydu ve kasaya girmeye çalışıyordu. Ancak içeride güvenlik sistemi devreye girdi ve kasa otomatik olarak kilitlendi. Kimsenin içeride olduğunu fark etmemesi nedeniyle adam susuzluktan öldü.","","","","","","",""],
    ["","",""],
    [],
    []]
    
    let solutionTitleColor: [[UIColor]] = [[.black, .black, .systemBackground],
    [.systemBackground, .systemBackground, .black],
    [.systemBackground, .systemBackground, .black],
    [],
    []]
    
    let solutionLabelColor: [[UIColor]] = [[.black, .black, .systemBackground],
    [.systemBackground, .systemBackground, .black],
    [.systemBackground, .systemBackground, .black],
    [],
    []]
    
    let shareButtonColor: [[UIColor]] = [[.black, .black, .systemBackground],
    [.systemBackground, .systemBackground, .black],
    [.systemBackground, .systemBackground, .black],
    [],
    []]
    
    let markAsSolved: [[UIColor]] = [[.black, .black, .systemBackground],
    [.systemBackground, .systemBackground, .black],
    [.systemBackground, .systemBackground, .black],
    [],
    []]

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let scenariosImages = scenariosImages {
            scenariosImageView.image = UIImage(named: scenariosImages)
        }
        
        if let visualImages = visualImages {
            visualsImageView.image = UIImage(named: visualImages)
        }
        
        if let gameTitles = gameTitle {
            scenariosTitleLabel.text = gameTitles
        }
        
        if let gameScenario = gameScenario {
            scenariosLabel.text = gameScenario
        }
        
        scenariosLabel.textColor = scenarioLabelColor ?? .black // nil gelirse siyah yap
        scenariosTitleLabel.textColor = scenarioTitleColor ?? .black
        solutionButton.tintColor = solutionButtonColor ?? .black
        solutionButton.layer.borderWidth = 2.5
        solutionButton.layer.borderColor = solutionButtonFrameColor?.cgColor ?? UIColor.black.cgColor
        scenariosCheckmarkButton.tintColor = scenarioCheckmarkButton ?? .black
        
        scenariosCheckmarkButton.isHidden = true
        
        // Her hücre için UserDefaults'tan durumları kontrol edin
        if let row = selectedIndexPathRow { // cell bilgisi
            let key = "isSolved_Section\(selectedSection)_Row\(row)"
            let isSolved = UserDefaults.standard.bool(forKey: key) // seçilen section ve cell e ve section a göre solutionsviewcontrollerdaki markAsSolvedButton unun güncellenme bilgisine göre değişecek olan scenariosCheckmarkButton butonunun güncellenmiş bilgisini kaydet
            scenariosCheckmarkButton.isHidden = !isSolved
        }
        
        // Bildirimleri dinle
        NotificationCenter.default.addObserver(self, selector: #selector(handleMarkAsSolvedNotification(_:)), name: NSNotification.Name("MarkAsSolvedNotification"), object: nil)
        
        // FavoritesCollectionViewController'daki cell'den ScenariosViewController'a aktarılma
        if let scenariosImages = scenariosImages {
            scenariosImageView.image = UIImage(named: scenariosImages)
        }
        if let gameTitles = gameTitle {
            scenariosTitleLabel.text = gameTitles
        }
        if let row = selectedIndexPathRow { // Eğer başka detaylı senaryolarınız varsa `selectedSection` ve `selectedIndexPathRow` ile işleyin
            print("Section: \(selectedSection), Row: \(row)")
            // Gerekirse verilerinizi burada işleyin
        }
        
        
        
    }
    
    
    @IBAction func solutionButtonClicked(_ sender: Any) {
        
        if let row = selectedIndexPathRow {
            let selectedSolutionImageView = solutionImageView[selectedSection][row]
            let selectedSolutionName = solutionName[selectedSection][row]
            let selectedSolutionTitleColor = solutionTitleColor[selectedSection][row]
            let selectedSolutionLabelColor = solutionLabelColor[selectedSection][row]
            let selectedShareButtonColor = shareButtonColor[selectedSection][row]
            let selectedMarkAsSolved = markAsSolved[selectedSection][row]
          
            
            performSegue(withIdentifier: "toSolutions", sender: (selectedSolutionImageView, selectedSolutionName, selectedSolutionTitleColor, selectedSolutionLabelColor, selectedShareButtonColor, selectedMarkAsSolved))
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toSolutions",
           let destinationVC = segue.destination as? SolutionsViewController {
            
            if let solutionsDatas = sender as? (String, String, UIColor, UIColor, UIColor, UIColor) {
                
                destinationVC.solutionImageView = solutionsDatas.0
                destinationVC.solutionLabel = solutionsDatas.1
                destinationVC.solutionTitleColor = solutionsDatas.2
                destinationVC.solutionLabelColor = solutionsDatas.3
                destinationVC.shareButtonColor = solutionsDatas.4
                destinationVC.markAsSolved = solutionsDatas.5
                
                destinationVC.selectedIndexPathRow = selectedIndexPathRow // solutionsviewcontroller daki mark as solved butonuna seçili indexpath i göndermek için
                destinationVC.selectedSection = selectedSection
            }
        }
    }
    

    @objc func handleMarkAsSolvedNotification(_ notification: Notification) {
      
        if let userInfo = notification.object as? [String: Any],
            let section = userInfo["section"] as? Int, // hangi sectiondan geldiği bilgisi
            let row = userInfo["row"] as? Int, // hangi cell den geldiği bilgisi
            let isSolved = userInfo["isSolved"] as? Bool { // solutionsviewcontroller daki markAsSolvedButton butonuna tıklanıp tıklanmadığı bilgisi
            
            // Butonun durumunu UserDefaults'tan kontrol ederek güncelle
            let key = "isSolved_Section\(section)_Row\(row)"
            UserDefaults.standard.set(isSolved, forKey: key) // solutionsviewcontrollerdaki markAsSolvedButton butonuna tıklanıp tıklanmadığı ilgili section ve celle bakarak kontrol et
            
            // Eğer solutionviewcontrollerdaki markAsSolvedButton işaretlenmişse, scenariosCheckmarkButton ı görünür yap
            scenariosCheckmarkButton.isHidden = !isSolved
        }
    }
    
    deinit {
        // Notification dinleyicisini kaldır. solutionviewcontrollerdaki markAsSolvedButton a ikinci kez tıklandığında (tikleme kaldırıldığında) scenariosCheckmarkButton ı gizle
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("MarkAsSolvedNotification"), object: nil)
    }
    
    
}
