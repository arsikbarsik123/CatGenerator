//
//  SecondViewController.swift
//  CatGenerator
//
//  Created by Ширапов Арсалан on 02.11.2024.
//

import UIKit

struct SecondVCInput{
    let imageData: Data
}

final class SecondViewController: UIViewController {
    @IBOutlet weak var catImageView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    
    private var input: SecondVCInput?
    func setInput(with input:SecondVCInput){
        self.input = input
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let input = input{
            catImageView.image = UIImage(data: input.imageData)
        }
    }
    
}
