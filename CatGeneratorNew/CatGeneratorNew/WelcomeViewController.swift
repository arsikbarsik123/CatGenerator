//
//  WelcomeViewController.swift
//  CatGenerator
//
//  Created by Ширапов Арсалан on 02.11.2024.
//

import UIKit

final class WelcomeViewController: UIViewController {
    private var imageContent: Data?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var catImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.isHidden = true
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func didTapView() {
        view.endEditing(true)
    }
    
    @IBAction func didTapCatGeneratorButton(_ sender: Any) {
        prepareUIBeforeDownload()
        downlodCat()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "showRandomCatSegue" {
            guard
                let viewController: GeneratedCatViewController = segue.destination as? GeneratedCatViewController,
                let imageContent = imageContent
            else { return }
            viewController.setInput(with: SecondVCInput(imageData: imageContent))
        }
    }
}

private extension WelcomeViewController {
    func prepareUIBeforeDownload() {
        button.isEnabled = false
        activityIndicator.startAnimating()
        button.titleLabel?.isEnabled = true
        activityIndicator.isHidden = false
    }
}

// MARK: - downloadCat

private extension WelcomeViewController {
    func downlodCat() {
        guard let url = URL(string: "https://cataas.com/cat") else { return }
        let task = URLSession.shared.dataTask(with: url){ [weak self] data, _, _ in
            guard let data = data else { return }
            DispatchQueue.main.async{ [weak self] in
                self?.imageContent = data
                self?.button.isEnabled = true
                self?.activityIndicator.stopAnimating()
                self?.performSegue(withIdentifier: "showRandomCatSegue", sender: self)
                self?.activityIndicator.isHidden = true
            }
        }
        task.resume()
    }
}
