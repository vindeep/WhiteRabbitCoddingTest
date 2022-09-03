//
//  DetailVC.swift
//  Employee
//

import UIKit

class DetailVC: UIViewController {

    // MARK: - Refference outlet and variables

    var Name = String()
    var Email = String()
    var CompanyName = String()
    var catchPhrase = String()
    var bs = String()
    var UserName = String()
    var Phone = String()
    var Website = String()
    var image = String()
    var street = String()
    var suite = String()
    var city = String()
    var zipcode = String()

    @IBOutlet weak var img_view: UIImageView!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_Comname: UILabel!
    @IBOutlet weak var lbl_phone: UILabel!
    @IBOutlet weak var lbl_email: UILabel!
    @IBOutlet weak var lbl_username: UILabel!
    @IBOutlet weak var lbl_website: UILabel!
    @IBOutlet weak var lbl_address: UILabel!
    
    // MARK: - DidLoad

    override func viewDidLoad() {
        super.viewDidLoad()

        self.lbl_name.text = Name
        self.lbl_Comname.text = "\(CompanyName)\n\(catchPhrase)\n\(bs)"
        self.lbl_phone.text = Phone
        self.lbl_email.text = Email
        self.lbl_username.text = UserName
        self.lbl_website.text = Website
        self.lbl_address.text = "\(street)\n\(suite)\n\(city)\n\(zipcode)"

        
        let url = URL(string: image as! String)
        if url != nil {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                DispatchQueue.main.async {
                    if data != nil {
                        self.img_view.image = UIImage(data:data!)
                    }else{
                    }
                }
            }
        }
    }
    
    // MARK: - IBAction

    @IBAction func back_click(_ sender: Any)
    {
        navigationController?.popViewController(animated: true)
    }
}
