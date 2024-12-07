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
    
    var scenariosImages: String?
    var visualImages: String?
    var gameTitle: String?
    var gameScenario: String?
    var scenarioLabelColor: UIColor?
    var scenarioTitleColor: UIColor?
    
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
        
    }
    
    


}
