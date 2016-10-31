//
//  ItemdetailsVC.swift
//  DreamLister
//
//  Created by Darshan Gowda on 31/10/16.
//  Copyright © 2016 Darshan Gowda. All rights reserved.
//

import UIKit
import CoreData

class ItemdetailsVC: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,
                        UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var detailsField: UITextField!
    @IBOutlet weak var storePicker: UIPickerView!
   
    @IBOutlet weak var imageView: UIImageView!
    var stores  = [Store]()
    
    var itemToEdit : Item?
    
    var imagePicker : UIImagePickerController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        storePicker.dataSource = self
        storePicker.delegate = self
        
        if let topItem = self.navigationController?.navigationBar.topItem{
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        
//        generateData()
        getStores()
        
        if itemToEdit != nil{
            loadItemData()
        }
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let store = stores[row]
        return store.name
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stores.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //
        
        
    }
   
    func generateData(){
        
        let store = Store(context: context)
        store.name = "Best Buy"
        
        let store2 = Store(context: context)
        store2.name = "Amazon"
        
        let store3 = Store(context: context)
        store3.name = "Flipkart"
        
        let store4 = Store(context: context)
        store4.name = "Snap deal"
        
        let store5 = Store(context: context)
        store5.name = "Cliq"
        
        let store6 = Store(context: context)
        store6.name = "Myntra"
        
        ad.saveContext()
    }
    
    func getStores(){
    
        let fetchRequest : NSFetchRequest<Store> = Store.fetchRequest()
        
        do{
        
            self.stores = try context.fetch(fetchRequest)
            self.storePicker.reloadAllComponents()
            
        }catch{
        
            //
        }
        
    }
    
    @IBAction func buttonPressed(_ sender: AnyObject) {
        
        var item : Item!
        
        let picture = Image(context: context)
        picture.image = imageView.image
        
        
        
        if itemToEdit == nil {
            item = Item(context: context)
        }else{
            item = itemToEdit
        }
        
        item.toImage = picture
        
        if let title = titleField.text{
            item.title  = title
        }
        
        if let price = priceField.text {
            item.price = (price as NSString).doubleValue
        }
        
        if let details = detailsField.text{
            item.details = details
        }
        
        item.toStore = stores[storePicker.selectedRow(inComponent: 0)]
        
        ad.saveContext()
        
       _ = navigationController?.popViewController(animated: true)
        
    }
    
    func loadItemData(){
        if let item = itemToEdit{
        
            titleField.text = item.title
            priceField.text = "\(item.price)"
            detailsField.text = item.details
            
            imageView.image = item.toImage?.image as? UIImage
            
            if let store = item.toStore{
            
                var index = 0
                repeat{
                
                    let s = stores[index]
                    if s.name == store.name{
                        storePicker.selectRow(index, inComponent: 0, animated: true)
                        break
                    }
                    index += 1
                
                }while index < stores.count
            }
            
        }
        
    }
    @IBAction func deletePressed(_ sender: AnyObject) {
        
        if itemToEdit != nil {
            context.delete(itemToEdit!)
            ad.saveContext()
        }
        
        _ = navigationController?.popViewController(animated: true)
        
        
    }
    
    @IBAction func imagePickerButtonPressed(_ sender: AnyObject) {
        
        present(imagePicker, animated: true, completion: nil)
        
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image  = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imageView.image = image
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
}
