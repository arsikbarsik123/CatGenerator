//
//  ThirdViewController.swift
//  CatGenerator
//
//  Created by Ширапов Арсалан on 08.11.2024.
//

import UIKit

struct ThirdVCInput{
    let imageData: Data
}

final class ThirdViewController: UIViewController {
    
    @IBOutlet weak var catImage: UIImageView!
    private var input: ThirdVCInput?
    func setInput(with input:ThirdVCInput){
        self.input = input
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let input{
            catImage.image = UIImage(data: input.imageData)
        }
    }
    

    
}
