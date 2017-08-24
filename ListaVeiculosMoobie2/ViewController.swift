//
//  ViewController.swift
//  ListaVeiculosMoobie2
//
//  Created by Joel Sene on 24/08/17.
//  Copyright © 2017 Vinicius Santos Ricci. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import NVActivityIndicatorView
import  SystemConfiguration
class ViewController: UIViewController, NVActivityIndicatorViewable, UITextFieldDelegate {

    
    @IBOutlet weak var emailTextfield : UITextField!
    @IBOutlet weak var senhaTextfield : UITextField!
    @IBOutlet weak var botaoLogar : UIButton!
    @IBOutlet weak var botaoCadastrar : UIButton!
    @IBOutlet weak var viewFundo = UIView()
    @IBOutlet weak var scroll = UIScrollView()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        navigationItem.title = "Autenticar"
        emailTextfield.text = "vinicius.ricci2@gmail.com"
        senhaTextfield.text = "123456"

        botaoCadastrar.addTarget(self, action: #selector(cadastrar), for: .touchUpInside)
        botaoLogar.addTarget(self, action: #selector(logar), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
      //  setGradientBackground()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //Presses return key
    @IBAction func textFieldShouldReturn(_ textField: UITextField)  {
        textField.resignFirstResponder()
        
    }
    
    
    func setGradientBackground() {
        let colorTop =  UIColor(red: 9.0/255.0, green: 151.0/255.0, blue: 199.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 14.0/255.0, green: 192.0/255.0, blue: 174.0/255.0, alpha: 1.0).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [ colorTop, colorBottom]
        gradientLayer.locations = [ 0.0, 1.0]
        gradientLayer.frame = self.view.bounds
        
        self.view.layer.addSublayer(gradientLayer)
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func logar() {
        
        
        if verificaSeTemInternet() == true {
            
            guard let email = emailTextfield.text, let senha = senhaTextfield.text
                
                else{
                    print("Form is not valid")
                    return
            }
            
            
            print("teste")
            if emailTextfield.text == "" && senhaTextfield.text == "" {
                
                let ok = UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                    
                    self.emailTextfield.text = ""
                    self.senhaTextfield.text = ""
                    self.emailTextfield.becomeFirstResponder()
                })
                
                let alertVC = UIAlertController(title: "Dados Imcompletos", message: "Verfique seus dados para logar com sucesso", preferredStyle: .alert)
                alertVC.addAction(ok)
                
                self.present(alertVC, animated: true, completion: nil)
                
                
            }
                
            else {
                
                
                
                
                
                FIRAuth.auth()?.signIn(withEmail: email, password: senha, completion: { (user, error) in
                    
                    
                    if error != nil{
                        print(error)
                        
                        let tentarNovamente = UIAlertAction(title: "ok", style: .default, handler: { (UIAlertAction) in
                            
                            self.emailTextfield.text = ""
                            self.senhaTextfield.text = ""
                            
                            self.emailTextfield.becomeFirstResponder()
                        })
                        
                        
                        
                        let alertVC = UIAlertController(title: "Dados Incorretos", message: "Digite novamente", preferredStyle: .alert)
                        alertVC.addAction(tentarNovamente)
                        
                        self.present(alertVC, animated: true, completion: nil)
                        return
                    }
                    
                    self.startAnimating()
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
                        
                        NVActivityIndicatorType.ballScale
                        NVActivityIndicatorPresenter.sharedInstance.setMessage("Efetuano Login...")
                        
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0, execute: {
                            
                            
                            self.stopAnimating()
                            
                            self.performSegue(withIdentifier: "carroSalvoController", sender: nil)
                            
                        })
                        
                    })
                    
                    
                    
                    
                    
                    
                })
            }
            
        }
        else {
            
            let tentarNovamente = UIAlertAction(title: "Tentar Novamente", style: .default, handler: { (UIAlertAction) in
                
                self.logar()
            })
            
            let cancelar = UIAlertAction(title: "Cancelar", style: .default, handler: { (UIAlertAction) in
                
                self.dismiss(animated: true, completion: nil)
                
            })
            
            let alertVC = UIAlertController(title: "sem conexão", message: "Não há conexão com a internet", preferredStyle: .alert)
            alertVC.addAction(tentarNovamente)
            alertVC.addAction(cancelar)
            self.present(alertVC, animated: true, completion: nil)
            
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "carroSalvoController" {
            
            let nav = segue.destination as! UINavigationController
            nav.topViewController as! CarrosSalvosTableViewController
        }
    }
    
    func cadastrar() {
        
        let cadastroVC = UIStoryboard(name: "Cadastro", bundle: nil).instantiateViewController(withIdentifier: "cadastroController") as! CadastroViewController
        
        self.navigationController?.pushViewController(cadastroVC, animated: true)
        
    }
    
    func verificaSeTemInternet() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }



}

