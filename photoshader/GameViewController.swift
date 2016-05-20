//
//  GameViewController.swift
//  photoshader
//
//  Created by taiki.ogasawara on 2016/05/19.
//  Copyright (c) 2016年 TAIKI OGASAWARA. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!

    var scene : GameScene?;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scene = GameScene(fileNamed:"GameScene");
        if let s = scene {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            s.scaleMode = .AspectFill
            
            skView.presentScene(s)
        }
    }
    
    @IBAction func cameraSelect(sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Please select.", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet);
        //Cancel 一つだけしか指定できない
        let cancelAction:UIAlertAction = UIAlertAction(title: "やめる",
                                                       style: UIAlertActionStyle.Cancel,
                                                       handler:{
                                                        (action:UIAlertAction!) -> Void in
        })
        
        let selectAction:UIAlertAction = UIAlertAction(title: "カメラロールから選択",
                                                        style: UIAlertActionStyle.Default,
                                                        handler:{
                                                            (action:UIAlertAction!) -> Void in
                                                            
                                                            self.cameraButton.enabled = false;
                                                            
                                                            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
                                                                let controller = UIImagePickerController()
                                                                controller.delegate = self
                                                                controller.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
                                                                self.presentViewController(controller, animated: true, completion: nil)
                                                            }

        });
        
        let cameraAction:UIAlertAction = UIAlertAction(title: "写真撮影",
                                                            style: UIAlertActionStyle.Destructive,
                                                            handler:{
                                                                (action:UIAlertAction!) -> Void in

                                                            self.cameraButton.enabled = false;

                                                            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
                                                                let controller = UIImagePickerController()
                                                                controller.delegate = self
                                                                controller.sourceType = UIImagePickerControllerSourceType.Camera
                                                                self.presentViewController(controller, animated: true, completion: nil);
                                                            }
        });
        
        alert.addAction(cancelAction);
        alert.addAction(cameraAction);
        alert.addAction(selectAction);
        presentViewController(alert, animated: true, completion: nil);
    }
    
    //　撮影が完了時した時に呼ばれる
    func imagePickerController(imagePicker: UIImagePickerController
        , didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            scene?.setImage(SKTexture(CGImage: pickedImage.CGImage!));
        }
        
        //閉じる処理
        imagePicker.dismissViewControllerAnimated(true, completion: nil);
        
        cameraButton.enabled = true;
    }
    
    // 撮影がキャンセルされた時に呼ばれる
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)

        //閉じる処理
        picker.dismissViewControllerAnimated(true, completion: nil);

        cameraButton.enabled = true;
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
