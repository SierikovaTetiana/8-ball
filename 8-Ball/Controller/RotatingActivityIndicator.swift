//
//  RotatingActivityIndicator.swift
//  8-Ball
//
//  Created by Tetiana Sierikova on 16.03.2022.
//

import UIKit

class RotatingActivityIndicator: UIView {
    
    let planet1 = UIImageView(frame: CGRect(x: 20, y: 20, width: 60, height: 60))
    let planet2 = UIImageView(frame: CGRect(x: 120, y: 20, width: 60, height: 60))
    
    private let position: [CGRect] = [CGRect(x: 30, y: 20, width: 60, height: 60), CGRect(x: 60, y: 15, width: 70, height: 70), CGRect(x: 110, y: 20, width: 60, height: 60), CGRect(x: 60, y: 25, width: 50, height: 50)]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        planet1.image = UIImage(named: "planet1")
        planet1.layer.zPosition = 2
        
        planet2.image = UIImage(named: "planet2")
        planet2.layer.zPosition = 1
        
        addSubview(planet1)
        addSubview(planet2)
    }
    
    func animate(_ planet: UIView, counter: Int) {
        var counter = counter
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: {
            planet.frame = self.position[counter]
            
            switch counter {
            case 1:
                if planet == self.planet1 {
                    self.planet1.layer.zPosition = 2
                }
            case 3:
                if planet == self.planet1 {
                    self.planet1.layer.zPosition = 0
                }
            default:
                print()
            }
        }) { (completed) in
            switch counter {
            case 0...2:
               counter += 1
            case 3:
                counter = 0
            default:
                print("Default counter")
            }
            self.animate(planet, counter: counter)
        }
    }
}
