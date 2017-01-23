//
//  ViewController.swift
//  YSimilarZHPullDownDemo
//
//  Created by YueWen on 16/3/8.
//  Copyright © 2016年 YueWen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    var demoMainView : YSimilarZHPullDownMainView?

    override func viewDidLoad()
    {
        super.viewDidLoad()

        navigationItem.title = "Yue"

        //创建DemoMainView对象
        demoMainView = YSimilarZHPullDownMainView(frame:CGRect(x: 0,y: 0,width: view.bounds.width,height: view.bounds.height))
        
        //赋值
        /*** 设置表头与表位文字需要设置数据源之前 ***/
        demoMainView!.headerTitle = "啦啦啦,我已经是第一篇了"
        demoMainView!.footerTitle = "哈哈哈,我是最后一篇啦"
        demoMainView!.pullViews = createPullDownViews()
        
        //添加视图
        view.addSubview(demoMainView!)

    }
    

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    /**
     *  创建测试PullDown视图
     */
    func createPullDownViews() -> [SimilarZHPullDownView]
    {
        var views :[SimilarZHPullDownView] = []

        for i in 0 ..< 4{
           
            let similarPullDownView = SimilarZHPullDownView(frame: view.bounds, custom: createCustomView())
            
            similarPullDownView.title = "测试\(i + 1)"
            
            views.append(similarPullDownView)
        }
        
        return views
    }

    
    //随机创建UIView的对象
    func createCustomView() -> UIView
    {
        //初始化视图
        let view = UIImageView()
        
        //获得随机数
        let count = arc4random() % 3 + 1
//        let count = 1
        
        view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height * CGFloat(count))
        view.image = UIImage(named: "testImage.jpg")
        view.contentMode = .scaleToFill
        
        return view
    }

}

