//
//  Extensions.swift
//  velocity
//
//  Created by Nimit on 2020-04-11.
//  Copyright © 2020 Nimit. All rights reserved.
//

import Foundation
import UIKit
import MapKit


extension UIView{
    
    
    //container for UIimage and textfield
    
    func myContainers(img:UIImage , text: UITextField? = nil , segmentedControl : UISegmentedControl? = nil) -> UIView {
   
                let view = UIView()
        
                let imageview = UIImageView()
                imageview.image = img
                imageview.alpha = 0.87
                view.addSubview(imageview)
              
        
        if let text = text{
            imageview.centerY(inView: view)
                          imageview.myanchor(left:view.leftAnchor, paddingLeft: 8 ,width: 32,height: 32)
            view.addSubview(text)
                    text.centerY(inView: view)
                    text.myanchor(left:imageview.rightAnchor,bottom: view.bottomAnchor,right: view.rightAnchor, paddingLeft: 8,paddingRight: 8)
            
        }
        
        if let segmentedControl = segmentedControl{
//            
            imageview.myanchor(top:view.topAnchor, left:view.leftAnchor, paddingLeft: 8 ,width: 32,height: 32)
//
            
            view.addSubview(segmentedControl)
          
            segmentedControl.myanchor(left: view.leftAnchor,right: view.rightAnchor , paddingLeft: 50 , paddingRight: 8)
            
            segmentedControl.centerY(inView: view)
        }
        
        
        
        
        
        
                let separatorView = UIView()
                separatorView.backgroundColor = .red
                view.addSubview(separatorView)
                separatorView.myanchor(left:view.leftAnchor,bottom:view.bottomAnchor,right:view.rightAnchor,paddingLeft: 8,height:  0.75)
        return view
    }
    
    
    //to give contrain in all app

       func myanchor(top: NSLayoutYAxisAnchor? = nil,
                left: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil,
                paddingTop: CGFloat = 0,
                paddingLeft: CGFloat = 0,
                paddingBottom: CGFloat = 0,
                paddingRight: CGFloat = 0,
                width: CGFloat? = nil,
                height: CGFloat? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }

        
        
    
    
    func centerX(inView view :UIView) {
         translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
     
    
    func centerY(inView view: UIView, leftAnchor: NSLayoutXAxisAnchor? = nil,
                 paddingLeft: CGFloat = 0, constant: CGFloat = 0) {
        
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant).isActive = true
        
        if let left = leftAnchor {
            myanchor(left: left, paddingLeft: paddingLeft)
        }
    }
    
    func setDimensions(height:CGFloat ,width :CGFloat){
        translatesAutoresizingMaskIntoConstraints = false
        
        heightAnchor.constraint(equalToConstant: height).isActive = true
        widthAnchor.constraint(equalToConstant: width).isActive = true
     
        
       
    }
    
    
    
    //shadow effect
    
    func addshadow(){
               
               layer.shadowColor =  .init(srgbRed: 15, green: 0, blue: 0, alpha:1)
                  layer.shadowOpacity = 0.50
                  layer.shadowOffset = CGSize(width: 10, height: 10)
                  layer.masksToBounds = false
               
           }
    
}
extension UITextField{
    
    
    func textField(placeholder:String,isSecureTextEntry:Bool)->UITextField{
        
        
            let tf = UITextField()
                     tf.borderStyle = .none
                     tf.textColor = .white
                     tf.keyboardAppearance = .dark
                      tf.isSecureTextEntry = isSecureTextEntry
                     tf.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor :UIColor.lightGray])
                     return tf
    }
  
}



extension UIColor {
      
      
  }

extension MKPlacemark{
    
    var address : String?{
       
        get{
            guard let locality = locality else {return nil}
            guard let adminArea = administrativeArea else {return nil}
            guard let  thoroughfare =  thoroughfare else {return "no"}
            guard let  subthoroughfare =  subThoroughfare else {return "no"}
            return "\(thoroughfare),\(locality),\(adminArea),\(subthoroughfare)"
        }
    
      
    
    }
    
    
    
}

extension MKMapView {
    
    func zoomToFit(annotation: [MKAnnotation]){
        
        var zoomRect = MKMapRect.null
        
        annotation.forEach{(annotation) in
            
            
            let annonationPoint = MKMapPoint(annotation.coordinate)
        
            let pointRect = MKMapRect(x: annonationPoint.x, y: annonationPoint.y, width: 0.01, height: 0.01)
            
            zoomRect = zoomRect.union(pointRect)
        }
    let insects = UIEdgeInsets(top: 100, left: 100, bottom: 300, right: 100)
   setVisibleMapRect(zoomRect, edgePadding: insects, animated: true)
        
    }
    
    
    
    
}



extension UIViewController{
    
    
    
    func presentAlertController(withMessage message : String , withTitle title : String  ){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
    func shouldPresnetLoadingView(_ present :Bool , message :String? = nil){
        
        
        if present{
            
            let loadingview = UIView()
            loadingview.frame = self.view.frame
            loadingview.backgroundColor = .black
            loadingview.alpha = 0
            loadingview.tag = 1

            
            
            let indicator = UIActivityIndicatorView()
            indicator.style = .whiteLarge
            indicator.center = view.center
            
            let label = UILabel()
            label.text = message
            label.font = UIFont.systemFont(ofSize: 24)
            label.textColor = .white
            
            
            
           view.addSubview(loadingview)
            loadingview.addSubview(indicator)
            loadingview.addSubview(label)
            label.centerX(inView: view)
            label.myanchor(top: indicator.bottomAnchor ,paddingTop: 32)
            indicator.startAnimating()
            
            
            UIView.animate(withDuration: 0.3) {
                loadingview.alpha = 0.7
            }
            
            
        }else {
            
            view.subviews.forEach{ (subview) in
                if subview.tag == 1 {

                    UIView.animate(withDuration: 0.6,animations: {
                        subview.alpha = 0
                    }) {_ in
                        
                        subview.removeFromSuperview()
                    }
                    
                }
            }
            
        }
        
    }
    
    
}
