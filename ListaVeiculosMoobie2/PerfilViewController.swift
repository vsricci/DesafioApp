//
//  PerfilViewController.swift
//  ListaVeiculosMoobie2
//
//  Created by Joel Sene on 24/08/17.
//  Copyright © 2017 Vinicius Santos Ricci. All rights reserved.
//

import UIKit
import Firebase
import SystemConfiguration
import NVActivityIndicatorView

class PerfilViewController: UIViewController, NVActivityIndicatorViewable {
    
    @IBOutlet weak var imagemUsuario = UIImageView()
    @IBOutlet weak var nome = UILabel()
    
    @IBOutlet weak var email = UILabel()
    @IBOutlet weak var telefone = UILabel()
    @IBOutlet weak var idade = UILabel()
   @IBOutlet weak var sexo = UILabel()
   
    
    var usuarioDados = [Usuario]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        
        imagemUsuario?.isHidden = true
        nome?.isHidden = true
        
        email?.isHidden = true
        telefone?.isHidden = true
        idade?.isHidden = true
        sexo?.isHidden = true
       
        
        
        buscarDadosUsuario()
        navigationItem.title = "Perfil"
        
        let seletorVoltar : Selector = #selector(voltar)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "imageVoltar"), landscapeImagePhone: nil, style: .plain, target: self, action: seletorVoltar)
    }
    
    func buscarDadosUsuario() {
        
        if FIRAuth.auth()?.currentUser?.uid == nil{
            
        }
        else {
            
            self.startAnimating()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
                
                NVActivityIndicatorType.ballZigZag
                NVActivityIndicatorPresenter.sharedInstance.setMessage("Buscando dados do Usuario")
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0, execute: { 
                    
                    
                    self.stopAnimating()
                    
                    
                    self.imagemUsuario?.isHidden = false
                    self.nome?.isHidden = false
                    
                    self.email?.isHidden = false
                    self.telefone?.isHidden = false
                    self.idade?.isHidden = false
                    self.sexo?.isHidden = false
                    
                    let userF = FIRAuth.auth()?.currentUser
                    let uid = FIRAuth.auth()?.currentUser?.uid
                    
                    FIRDatabase.database().reference().child("usuarios2").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                        
                        if let dictionary = snapshot.value as? [String: AnyObject] {
                            
                            let dadosUsuario = Usuario()
                            
                            dadosUsuario.setValuesForKeys(dictionary)
                            self.usuarioDados.append(dadosUsuario)
                            
                            if let imagemUrl = dadosUsuario.imagemPerfil {
                                
                                self.imagemUsuario?.loadImageUsingCacheWithString(urlString: imagemUrl)
                            }
                            
                            
                            self.nome?.text = dadosUsuario.nome + " " + dadosUsuario.sobrenome
                            
                            self.email?.text = dadosUsuario.email
                            self.telefone?.text = dadosUsuario.telefone
                            self.idade?.text = dadosUsuario.idade
                            self.sexo?.text = dadosUsuario.sexo
                         
                            
                            
                            
                        }
                    })
                    
                })
            })
                
            
        }
    }
    
    func voltar(){
        
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
