//
//  YSimilarZHPullDownMainView.swift
//  YSimilarZHPullDownDemo
//
//  Created by YueWen on 16/3/14.
//  Copyright © 2016年 YueWen. All rights reserved.
//

import UIKit

class YSimilarZHPullDownMainView: UIScrollView ,SimilarZHPullDownViewDelegate{

    
    /***  第一篇上划以及最后一篇下滑显示的默认字样，可修改 ***/
    var headerTitle:String = "已是第一篇"
    var footerTitle:String = "最后一篇"
    
    
    
    /// 存放预览视图的数组,默认为空数组,为存储属性，设置KVO
    var pullViews:[SimilarZHPullDownView] = []
    {
        willSet
        {
            self.pullViews = newValue
            
            //开始做处理
            self.pullViews.first?.headerTitle = self.headerTitle
            self.pullViews.first?.type = .Header


            self.pullViews.last?.footerTitle = self.footerTitle
            self.pullViews.last?.type = .Footer
        }
    }
    
    
    /// 存放滚动页的主滚动页
    lazy var scrollView:UIScrollView = {
        
        var scrollView:UIScrollView = UIScrollView(frame: CGRectMake(0,self.titleLabel.bounds.size.height,self.bounds.size.width,self.bounds.size.height - 50 - 64))
        
        scrollView.pagingEnabled = true//分页显示
        scrollView.showsVerticalScrollIndicator = false //不显示垂直滚条
        scrollView.scrollEnabled = false //不能滚动
        
        return scrollView
        
    }()
    
    
    /// 显示标题的标题
    lazy var titleLabel:UILabel = {
        
        var label:UILabel = UILabel(frame: CGRectMake(0,0,self.bounds.size.width,50))
        label.textAlignment = .Center
        return label
        
    }()
    
    
    //MARK: - FUNCTION
    
    //MARK: - 构造方法
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.addSubview(self.titleLabel)
        self.addSubview(self.scrollView)
    }

    /**
     *  便利构造方法
     */
    @available(iOS 8.0,*)
    required convenience init(frame: CGRect,pullViews:[SimilarZHPullDownView])
    {
        self.init(frame:frame)
        self.pullViews = pullViews
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        
    }
    
    override func layoutSubviews() {
        
        //设置自身的contentSize
        self.scrollView.contentSize = CGSize(width: self.bounds.size.width, height: CGFloat(self.pullViews.count) * self.bounds.size.height)
        
        self.addChildView()
    }
    
    
    
    
    //MARK: - 功能方法

    /**
    *  添加子视图
    */
    @available(iOS 8.0,*)
    func addChildView()
    {
        //获取当前视图的高度和宽度
        let height = self.bounds.size.height
        let width = self.bounds.size.width
        
//        for(var i:Int = 0 ; i < self.pullViews.count; i += 1)
//        {
//            
        for i in 0..<pullViews.count
        {
            //获取存储的SimilarZHPullDownView对象
            let pullDownView = self.pullViews[i]
            
            pullDownView.frame = CGRectMake(0, CGFloat(i) * height, width, height - 64 - 50)
            
            //设置代理
            pullDownView.delegate = self
            
            //添加视图
            self.scrollView.addSubview(pullDownView)
        }
        
        self.titleLabel.text = self.pullViews.first?.title
    }


    
    
    // MARK: - SimilarZHPullDownView Delegate
    func similarZHPullDownView(similarZHPullDownView: SimilarZHPullDownView, pullType: PullType)
    {
        //修复pullViews.count == 1 ,the program is terminated
        if pullViews.count == 1 {
            
            return;
        }

        //获得当前的偏移量
        let contentOffset = self.scrollView.contentOffset
        
        //获得索引数
        let index = self.pullViews.indexOf(similarZHPullDownView)
        
        var paramNumber = CGFloat(1)
        
        switch pullType
        {
            case .PullTypeUp: //上翻页
                guard similarZHPullDownView.type == .Header else{
                    
                    paramNumber = CGFloat(-1)
                    self.pullDone(paramNumber, contentOffset: contentOffset, index: index!)
                    break
            }
            
            case .PullTypeDown://下翻页
                guard similarZHPullDownView.type == .Footer else{
                    paramNumber = CGFloat(1)
                    self.pullDone(paramNumber, contentOffset: contentOffset, index: index!)
                    break
            }
        }
    }
    
    
    
    /**
     *  滚动操作
     */
    @available(iOS 8.0,*)
    func pullDone(paramNumber:CGFloat, contentOffset:CGPoint, index:Int)
    {
        var contentOffset = contentOffset
        
        contentOffset.y += (paramNumber * self.bounds.size.height)
        self.scrollView.setContentOffset(contentOffset, animated: true)
        
        //显示即将出现的similarZHPullDownView对象的title
        self.titleLabel.text = self.pullViews[index + Int(paramNumber)].title
    }
    
}
