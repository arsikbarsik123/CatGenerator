//
//  TextedCatViewController.swift
//  CatGenerator
//
//  Created by Ширапов Арсалан on 06.11.2024.
//

import UIKit

final class TextedCatViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var catImage: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        button.isEnabled = false
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
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
    @objc func textFieldDidChange(_ textField: UITextField) {
        // Проверяем, не пусто ли поле ввода
        button.isEnabled = !textField.text!.isEmpty
    }
    @IBAction func didTapCatGeneratorButton(_ sender: Any) {
        downlodCat(with: textField.text ?? "Enter message")
    }
    private func downlodCat(with text:String){
        button.isEnabled = false
        activityIndicator.startAnimating()
        textField.isEnabled = false
        button.titleLabel?.isEnabled = true
        activityIndicator.isHidden = false
        
        guard let url = URL(string: "https://cataas.com/cat/says/\(text)?fontSize=50&fontColor=white") else{
            return
        }
        let task = URLSession.shared.dataTask(with: url){ [weak self] data, response, error in
            guard let data = data else{
                return
            }
            DispatchQueue.main.async{ [weak self] in
                self?.imgData = data
                self?.performSegue(withIdentifier: "showRandomTextedCatSegue", sender: self)
                self?.button.isEnabled = true
                self?.activityIndicator.stopAnimating()
                self?.textField.isEnabled = true
                self?.button.titleLabel?.isEnabled = false
                self?.activityIndicator.isHidden = true
            }
            
        }
        task.resume()
    }
    private var imgData:Data?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "showRandomTextedCatSegue"{
            guard
                let viewController: ThirdViewController = segue.destination as? ThirdViewController,
                let imgData = imgData
            else{
                return
            }
            viewController.setInput(with: ThirdVCInput(imageData: imgData))
        }
        
    }
}
