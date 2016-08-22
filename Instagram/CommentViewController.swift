//
//  CommentViewController.swift
//  Instagram
//
//  Created by 佐藤まりの on H28/08/18.
//  Copyright © 平成28年 mycompany. All rights reserved.
//


import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import SVProgressHUD

class CommentViewController: UIViewController, UITableViewDelegate, UITextFieldDelegate  {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var commentTextView: UITextView!
    
    var postData:PostData!

        /*コメントボタンのメソッド*/
    @IBAction func commentButton(sender: AnyObject) {
        if let name:String = nameTextField.text, let comment:String = commentTextView.text {
            
            /*名前かコメントが未入力の時はもう一度入力*/
            if name.characters.isEmpty || comment.characters.isEmpty {
                SVProgressHUD.showErrorWithStatus("必要項目を入力して下さい")
                return
            }else{
                postData!.comments.append("\(name):\(comment)")
                SVProgressHUD.showSuccessWithStatus("投稿しました")
            }
        }
        updateFirebase()
        
            // 処理中を表示
            SVProgressHUD.show()
        
        
            // HUDを消す
            SVProgressHUD.dismiss()
                    
            // 画面を閉じる
        self.dismissViewControllerAnimated(true, completion: nil)
            }
    
    
            
        /*戻るボタンのメソッド*/
    @IBAction func backButton(sender: AnyObject) {
        // 画面を閉じる
        self.dismissViewControllerAnimated(true, completion: nil)

    }
    
    
    


    override func viewDidLoad() {
    super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
        }
    
    
        /*tableViewのセルの数のカウント*/
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postData!.comments.count + 1
    }
    
        /*tableViewのセルの設定*/
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        /*cellの順番*/
        if indexPath.row == 0 {
            /*captionの表示*/
            cell.textLabel?.text = "\(postData!.name!):\(postData!.caption!)"
        } else {
            /*commentの表示*/
            cell.textLabel?.text = postData!.comments[indexPath.row - 1]
        }
        return cell
    }
    
        /*tableViewのセルの選択時には何もしない*/
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    
        /*Firebase更新メソッド*/
    func updateFirebase() {
        /* Firebaseに格納*/
        let imageString = postData!.imageString
        let caption = postData!.caption
        let name = postData!.name
        let time = (postData!.date?.timeIntervalSinceReferenceDate)! as NSTimeInterval
        let likes = postData!.likes
        let comments = postData!.comments
        let post = ["caption": caption!, "image": imageString!, "name": name!, "time": time, "likes": likes, "comments": comments]
        
        let postRef = FIRDatabase.database().reference().child(CommonConst.PostPATH)
        postRef.child(postData!.id!).setValue(post)
    }

}


 



