//
//  ViewController.swift
//  YSimilarZHPullDownDemo
//
//  Created by YueWen on 16/3/8.
//  Copyright © 2016年 YueWen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Yue"

        
        //创建DemoMainView对象
        let demoMainView = YSimilarZHPullDownMainView(frame:CGRectMake(0,0,self.view.bounds.size.width,self.view.bounds.size.height))
        //赋值
        /*** 设置表头与表位文字需要设置数据源之前 ***/
        demoMainView.headerTitle = "啦啦啦,我已经是第一篇了"
        demoMainView.footerTitle = "哈哈哈,我是最后一篇啦"
        demoMainView.pullViews = self.createPullDownViews()

        //添加视图
        self.view.addSubview(demoMainView)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    /**
     *  创建测试PullDown视图
     */
    @available(iOS 8.0,*)
    func createPullDownViews() -> [SimilarZHPullDownView]
    {
        var views :[SimilarZHPullDownView] = []
        
        for(var i:Int = 0 ; i < 3; i++)
        {
            let similarPullDownView = SimilarZHPullDownView(custom:self.createCustomView(),title:"测试\(i)")
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
    //        let count:UInt32 = arc4random_uniform(3) + UInt32(1)
        
        let count = 1
        view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height * CGFloat(count))
        view.image = UIImage(named: "testImage.jpg")
        view.contentMode = .ScaleToFill
        
        return view
    }

}

