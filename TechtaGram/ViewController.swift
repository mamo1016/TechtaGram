//
//  ViewController.swift
//  TechtaGram
//
//  Created by 上田　護 on 2017/10/22.
//  Copyright © 2017年 上田　護. All rights reserved.
//

import UIKit
import Accounts

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    var test: Float = 0.5
    
    @IBOutlet var cameraImageView: UIImageView!
    
    //画像加工するための元になる画像
    var originalImage: UIImage!

    //画像加工するフィルターの宣言
    var filter: CIFilter!
    
    var filterNum: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    

    

    
    @IBAction func useCamera() {
        //カメラが使えるかの確認
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            //カメラ起動
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            picker.allowsEditing = true
        
            present(picker, animated: true, completion: nil)
    } else {
            //カメラを使えない時はエラーがコンソールに出ます
            print("error")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        cameraImageView.image = info[UIImagePickerControllerEditedImage] as? UIImage
        
        originalImage = cameraImageView.image
        
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func applyFilter() {
        let filterImage: CIImage = CIImage(image: originalImage)!
        
        //フィルターの設定
        filter = CIFilter(name: "CIColorControls")!
        filter.setValue(filterImage, forKey: kCIInputImageKey)

        //彩度の調整
        filter.setValue(1.0, forKey: "inputSaturation")
        //明度の調整
        filter.setValue(0.5, forKey: "inputBrightness")
        //コントラストの調整
        filter.setValue(2.5, forKey: "inputContrast")
     
        let ctx = CIContext(options: nil)
        let cgImage = ctx.createCGImage(filter.outputImage!, from: filter.outputImage!.extent)
        cameraImageView.image = UIImage(cgImage: cgImage!)
    }
    
    func change (){
        print(test)
        let filterImage: CIImage = CIImage(image: originalImage)!
//
//        //フィルターの設定
//        filter = CIFilter(name: "CIColorControls")!
//        filter.setValue(filterImage, forKey: kCIInputImageKey)
//
//            //彩度の調整
//            filter.setValue(1.0, forKey: "inputSaturation")
//            //明度の調整
//            filter.setValue(0.5, forKey: "inputBrightness")
//            //コントラストの調整
//            filter.setValue(2.5, forKey: "inputContrast")
//        let ctx = CIContext(options: nil)
//        let cgImage = ctx.createCGImage(filter.outputImage!, from: filter.outputImage!.extent)
//        cameraImageView.image = UIImage(cgImage: cgImage!)
//
    }
    @IBAction func testSlider(sender: UISlider){
        test = sender.value
//        print(test)
        
        change()
    }
    
    @IBAction func save() {
        UIImageWriteToSavedPhotosAlbum(cameraImageView.image!, nil, nil, nil)
        
    }
    
    @IBAction func openAlbum() {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            
            picker.allowsEditing = true
            
            present(picker, animated: true, completion: nil)
        }
    }
    
    @IBAction func shere() {
        //投稿するときに一緒に載せるコメント
        let shareText = "写真加工できた！"
        
        //投稿する画像の選択
        let shareImage = cameraImageView.image!
        
        //投稿するコメントと画像の準備
        let activityItems: [Any] = [shareText, shareImage]
        
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        let excludedActivityTypes = [UIActivityType.postToWeibo, .saveToCameraRoll, .print]
    
        activityViewController.excludedActivityTypes = excludedActivityTypes
        
        present(activityViewController, animated: true, completion: nil)
    }

}
