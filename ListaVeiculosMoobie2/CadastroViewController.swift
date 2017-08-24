//
//  CadastroViewController.swift
//  ListaVeiculosMoobie2
//
//  Created by Joel Sene on 24/08/17.
//  Copyright © 2017 Vinicius Santos Ricci. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import MediaPlayer
import MobileCoreServices
import SystemConfiguration
import NVActivityIndicatorView

class CadastroViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, NVActivityIndicatorViewable{
    
    @IBOutlet weak var imagemUsuario : UIImageView!
    @IBOutlet weak var botaoCamera = UIButton()
    @IBOutlet weak var botaoGaleria = UIButton()
    @IBOutlet weak var botaoCadastrar = UIButton()
    @IBOutlet weak var nome : UITextField!
    @IBOutlet weak var sobrenome : UITextField!
    @IBOutlet weak var email : UITextField!
    @IBOutlet weak var telefone : UITextField!
    @IBOutlet weak var idade : UITextField!
    @IBOutlet weak var sexo = UITextField()
    var sexoPicker = UIPickerView()
    @IBOutlet weak var senha : UITextField!
    var usuario = Usuario()
     var listaSexo : [String] = ["Masculino", "Feminino"]
    let notificatonCenter = NotificationCenter.default
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //Presses return key
   @IBAction func textFieldShouldReturn(_ textField: UITextField)  {
        textField.resignFirstResponder()
    
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return listaSexo.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        
        
        return  listaSexo[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        sexo?.text = listaSexo[row]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sexoPicker.dataSource = self
        sexoPicker.delegate = self
        sexo?.inputView = sexoPicker
        
        botaoGaleria?.addTarget(self, action: #selector(selecionarGaleria), for: .touchUpInside)
        botaoCamera?.addTarget(self, action: #selector(tirarFoto), for: .touchUpInside)
        
        botaoCadastrar?.addTarget(self, action: #selector(cadastrar), for: .touchUpInside)
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.blue
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: "donePicker")
        
        
        toolBar.setItems([ doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        // modeloTextfield?.inputAccessoryView = toolBar
        sexo?.inputAccessoryView = toolBar

        // Do any additional setup after loading the view.
    }
    
    func donePicker() {
        
        sexo?.resignFirstResponder()
    }
    
    
    func enviandoDadosUsuario(uid: String, values: [String : AnyObject]){
        
        let ref =  FIRDatabase.database().reference(fromURL: "https://ricci-boutique-xamarin.firebaseio.com/")
        
        let userReference = ref.child("usuarios2").child(uid)
        
        // values = ["nome": name, "sobrenome": email, "profileImageUrl": metadata.downloadUrl()]
        userReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if err != nil{
                print(err)
                return
            }
            
            self.dismiss(animated: true, completion: nil)
            
            
            
            // print("Save user successfully into Firebase db")
        })
        
        
    }
    
    
    func getMediaUIImagePickerControllerSourceType(sourceType: UIImagePickerControllerSourceType) -> Void{
        
        let myMediaPicker: NSArray = UIImagePickerController.availableMediaTypes(for: sourceType)! as NSArray
        
        
        // caso seja diferente de zero significa que existe algum tipo de elemento mediapicker
        if myMediaPicker.count != 0 && UIImagePickerController.isSourceTypeAvailable(sourceType)
        {
            
            // passa o controle da aplicacao para esse tipo de elemento, sendo camera ou biblioteca
            let myPickerController : UIImagePickerController = UIImagePickerController()
            myPickerController.sourceType = sourceType
            
            // permitir que o usuario edite o arquivo que ele selecionar da biblioteca ou a foto que foi tirada
            myPickerController.allowsEditing = true
            myPickerController.mediaTypes = myMediaPicker as! [String]
            
            // aqui faz o retorno pra nossa propria classe que tera os metodos que irao trabalhar no arquivo retornado
            myPickerController.delegate = self
            // apresenta a nova tela
            self.present(myPickerController, animated: true, completion: nil)
        }
        else{
            
            let  myAlert : UIAlertView = UIAlertView()
            myAlert.title = " Não possui camera"
            myAlert.message = " Esta funcionalidade não pode ser ativada, pois seu dispositivo não possui camera"
            myAlert.addButton(withTitle: "OK")
            myAlert.show()
        }
        
        
    }
    
    func habilitarButtonCamera()
    {
        
        // verifica se o dispositivo possui camera
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) == false
        {
            //propriedade hidden para setar como visivel ou invisivel, se for true esta invisivel
            // myButton.hidden = true
            let  myAlert : UIAlertView = UIAlertView()
            myAlert.title = " Não possui camera"
            myAlert.message = " Esta funcionalidade não pode ser ativada, pois seu dispositivo não possui camera"
            myAlert.addButton(withTitle: "OK")
            myAlert.show()
            
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            
            selectedImageFromPicker = editedImage
            
        }
            
        else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            
            // print((originalImage as AnyObject).size)
            
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker{
            
            imagemUsuario.image = selectedImageFromPicker
        }
        
        
        
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagemUsuario.image = UIImage(named: "img_perfil_app_ios")
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func tirarFoto() {
        
        self.getMediaUIImagePickerControllerSourceType(sourceType: UIImagePickerControllerSourceType.camera)
    }
    
    
    func selecionarGaleria() {
        
        self.getMediaUIImagePickerControllerSourceType(sourceType: UIImagePickerControllerSourceType.photoLibrary)
    }

    
    
    func cadastrar(){
        
        if verificaSeTemInternet() == true {
            
            
            if  nome.text! == "" && sobrenome.text! == "" && email.text! == "" && telefone.text! == "" && idade.text! == "" && sexo?.text! == "" {
                
                var alert : UIAlertView = UIAlertView()
                alert.title = "Dados incompletos"
                alert.message = "Por favor, preeencha todos os dados!!!"
                alert.addButton(withTitle: "OK")
                alert.show()
            }
            else{
                
                
                
                
                
                guard let nome = nome.text, let sobrenome = sobrenome.text, let email = email.text, let telefone = telefone.text, let idade = idade.text, let sexo = sexo?.text, let senha = senha.text
                    
                    
                    else{
                        print("Form is not valid")
                        return
                }
                
                
                //autenticando user no firebase
                
                FIRAuth.auth()?.createUser(withEmail: email, password: senha, completion: { (user, error) in
                    
                    if error != nil{
                        
                        var alert = UIAlertView()
                        alert.title = "Erro ao cadastrar!!!"
                        alert.message = "IHHHH voce ja se cadastrou, este  email ja esta em nosso banco, voce talvez tenha se cadastrado pelo facebook ou google e esta usando o mesmo email, tente logar por uma dessas contas ou utilize ou email hehe :)"
                        alert.addButton(withTitle: "OK")
                        alert.show()
                        print(error)
                        return
                    }
                    
                    
                    
                    guard let uid = user?.uid else {
                        return
                    }
                    
                    let imageName = NSUUID().uuidString
                    
                    let storageRef = FIRStorage.storage().reference().child("imagem_usuario2").child("\(imageName).png")
                    
                    if let uploadData = UIImagePNGRepresentation((self.imagemUsuario.image)!){
                        
                        let newData = UIImageJPEGRepresentation(UIImage(data: uploadData)!, 1)
                        
                        
                        storageRef.put(newData!, metadata: nil, completion: { (metadata, error) in
                            if error != nil{
                                print(error)
                                return
                            }
                            
                            if let imagemPerfil = metadata?.downloadURL()?.absoluteString{
                                
                                
                                
                                
                                let values = ["nome": nome, "sobrenome": sobrenome, "email": email, "telefone": telefone, "idade": idade, "sexo": sexo, "imagemPerfil": imagemPerfil, "senha": senha]
                                
                                
                                self.startAnimating()
                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
                                    
                                    
                                    NVActivityIndicatorType.ballBeat
                                    NVActivityIndicatorPresenter.sharedInstance.setMessage("Efetuando Cadastro")
                                    
                                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3.0, execute: {
                                        
                                        
                                        self.stopAnimating()
                                        self.enviandoDadosUsuario(uid: uid, values: values as [String : AnyObject])
                                        
                                        
                                        self.navigationController?.popViewController(animated: true)
                                        
                                        
                                    })
                                    
                                    
                                })
                                
                                
                                
                                
                                
                                
                            }
                            
                        })
                        
                    }
                    
                })
                
                
                
            }
        }
            
        else {
            
            
            
            let tentarNovamente = UIAlertAction(title: "Tentar Novamente", style: .default, handler: { (UIAlertAction) in
                
                self.cadastrar()
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
