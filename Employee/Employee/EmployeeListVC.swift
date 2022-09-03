//
//  EmployeeListVC.swift
//  Employee


import UIKit
import CoreData

class EmployeeListVC: UIViewController, UITextFieldDelegate {
    
    // MARK: - Refference outlet and variables

    @IBOutlet weak var tbl_view: UITableView!
    @IBOutlet weak var txt_search: UITextField!
    
    var Emp1 = [Emp]()
    var Emp_search = [Emp]()
    var context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    // MARK: - DidLoad

    override func viewDidLoad() {
        super.viewDidLoad()

        txt_search.delegate = self

        if (UserDefaults.standard.object(forKey: "Apicall") != nil)
        {
            self.get()
            Emp_search = Emp1

        }
        else
        {
            self.API()
        }
    }

    // MARK: - Textsearch

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool
    {
        var searchText  = textField.text! + string
        if string  == "" {
            searchText = (searchText as String).substring(to: searchText.index(before: searchText.endIndex))
        }
        if searchText == "" || searchText == "\n"
        {
            if searchText == "\n"
            {
                textField.resignFirstResponder()
                return true

            }
            Emp1 = Emp_search
        }
        else{
            
            if  self.Emp_search.count > 0
            {
                Emp1 = Emp_search.filter({ user -> Bool in
                    return user.name!.lowercased().contains(searchText.lowercased()) || user.name!.lowercased().contains(searchText.uppercased()) || user.email!.lowercased().contains(searchText.uppercased()) || user.email!.lowercased().contains(searchText.lowercased())
                })

            }
        }
        self.tbl_view .reloadData()

        return true
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
       textField.resignFirstResponder()
       return true
    }

    // MARK: - Get

    
    func get()
    {
        var Emp = [Emp]()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Emp")
        
        
        do
        {
            Emp = try context?.fetch(fetchRequest) as! [Emp]
            Emp1 = Emp
            
           // print(Emp1[0].name ?? "")
        }
        catch
        {
            print("Data is not saved")
        }
        
        DispatchQueue.main.async{
            self.tbl_view.reloadData()
        }

    }

    // MARK: - API
        
    func API()
    {
        var request = URLRequest(url: URL(string: "http://www.mocky.io/v2/5d565297300000680030a986")!)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request, completionHandler: { [self] data, response, error -> Void in
            do {
                let jsonDecoder = JSONDecoder()
                let resultJson = try JSONSerialization.jsonObject(with: data!, options: []) as? [[String:AnyObject]]
                
                for i in 0...(resultJson!.count - 1 ?? 0) {
                   
                    let employee = NSEntityDescription.insertNewObject(forEntityName: "Emp", into: self.context!) as! Emp
                    employee.name = "\(resultJson![i]["name"]!)"
                    employee.companyname =  resultJson?[i]["company"]?["name"] as? String ?? ""
                    employee.catchPhrase =  resultJson?[i]["company"]?["catchPhrase"] as? String ?? ""
                    employee.bs =  resultJson?[i]["company"]?["bs"] as? String ?? ""
                    employee.email = "\(resultJson![i]["email"]!)"
                    employee.phone = "\(resultJson![i]["phone"]!)"
                    employee.profileimage = "\(resultJson![i]["profile_image"]!)"
                    employee.username = "\(resultJson![i]["username"]!)"
                    employee.website = "\(resultJson![i]["website"]!)"
                    employee.street =  resultJson?[i]["address"]?["street"] as? String ?? ""
                    employee.suite =  resultJson?[i]["address"]?["suite"] as? String ?? ""
                    employee.city =  resultJson?[i]["address"]?["city"] as? String ?? ""
                    employee.zipcode =  resultJson?[i]["address"]?["zipcode"] as? String ?? ""

                    do
                    {
                        try context?.save()
                        self.get()
                    }
                    catch
                    {
                        print("Data is not saved")
                    }
                }
                UserDefaults.standard.set(true, forKey: "Apicall")
                UserDefaults.standard.synchronize()
                
                
            } catch {
                print("JSON Serialization error")
            }
        }).resume()
        
    }
}
// MARK: - Tableview Delegate

extension EmployeeListVC: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return Emp1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tbl_view.dequeueReusableCell(withIdentifier: "list_cell", for: indexPath) as! list_cell
        cell.lbl_name.text = Emp1[indexPath.row].name ?? ""
        cell.lbl_companyname.text = Emp1[indexPath.row].companyname ?? ""
        
        let url = URL(string: Emp1[indexPath.row].profileimage as! String)
        if url != nil {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                DispatchQueue.main.async {
                    if data != nil {
                        cell.img_view.image = UIImage(data:data!)
                    }else{
                    }
                }
            }
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let nextvc = self.storyboard?.instantiateViewController(withIdentifier: "DetailVC") as! DetailVC
        nextvc.Name = Emp1[indexPath.row].name ?? ""
        nextvc.Email = Emp1[indexPath.row].email ?? ""
        nextvc.Phone = Emp1[indexPath.row].phone ?? ""
        nextvc.CompanyName = Emp1[indexPath.row].companyname ?? ""
        nextvc.Website = Emp1[indexPath.row].website ?? ""
        nextvc.UserName = Emp1[indexPath.row].username ?? ""
        nextvc.bs = Emp1[indexPath.row].bs ?? ""
        nextvc.catchPhrase = Emp1[indexPath.row].catchPhrase ?? ""
        nextvc.image = Emp1[indexPath.row].profileimage ?? ""
        nextvc.street = Emp1[indexPath.row].street ?? ""
        nextvc.suite = Emp1[indexPath.row].suite ?? ""
        nextvc.city = Emp1[indexPath.row].city ?? ""
        nextvc.zipcode = Emp1[indexPath.row].zipcode ?? ""

        self.navigationController?.pushViewController(nextvc, animated: true)

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80
    }
}

// MARK: - list_cell

class list_cell: UITableViewCell
{
    // MARK: - Refference outlet and variables
    
    @IBOutlet var img_view: UIImageView!
    @IBOutlet var lbl_name: UILabel!
    @IBOutlet var lbl_companyname: UILabel!
}

