//
//  CatViewController.swift
//  CatGenerator
//
//  Created by Ширапов Арсалан on 02.11.2024.
//

import UIKit

final class CatViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var catImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        view.addGestureRecognizer(gestureRecognizer)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification , object:nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification , object:nil)
    }
    @objc func keyboardWillShow(notification: NSNotification) {
       let keyboardHeight = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
       print(keyboardHeight)
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
    }

    @objc func keyboardWillHide(notification: NSNotification) {
       let keyboardHeight = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
       print(keyboardHeight)
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

    }
    
    @objc
    private func didTapView(){
        view.endEditing(true)
    }
    @IBAction func didTapCatGeneratorButton(_ sender: Any) {
        downlodCat()
    }
    private func downlodCat(){
        button.isEnabled = false
        activityIndicator.startAnimating()
        button.titleLabel?.isEnabled = true
        activityIndicator.isHidden = false
        guard let url = URL(string: "https://cataas.com/cat") else{
            return
        }
        let task = URLSession.shared.dataTask(with: url){ [weak self] data, response, error in
            guard let data = data else{
                return
            }
            DispatchQueue.main.async{ [weak self] in
                self?.imgData = data
                self?.button.isEnabled = true
                self?.activityIndicator.stopAnimating()
                self?.performSegue(withIdentifier: "showRandomCatSegue", sender: self)
                self?.activityIndicator.isHidden = true
            }
            
        }
        task.resume()
    }
    private var imgData:Data?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        print(segue.identifier)
        if segue.identifier == "showRandomCatSegue"{
            guard
                let viewController: SecondViewController = segue.destination as? SecondViewController,
                let imgData = imgData
            else{
                return
            }
            viewController.setInput(with: SecondVCInput(imageData: imgData))
        }
        
    }
}
