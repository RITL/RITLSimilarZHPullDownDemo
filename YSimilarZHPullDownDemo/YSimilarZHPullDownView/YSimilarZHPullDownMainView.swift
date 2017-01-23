//
//  YSimilarZHPullDownMainView.swift
//  YSimilarZHPullDownDemo
//
//  Created by YueWen on 16/3/14.
//  Copyright © 2016年 YueWen. All rights reserved.
//

import UIKit

class YSimilarZHPullDownMainView: UIScrollView ,SimilarZHPullDownViewDelegate{

    
    /// 是否添加子视图
    var shouldLayoutAddSubViews = true
    
    /***  第一篇上划以及最后一篇下滑显示的默认字样，可修改 ***/
    var headerTitle:String = "已是第一篇"
    var footerTitle:String = "最后一篇"
    
    
    
    /// 存放预览视图的数组,默认为空数组,为存储属性，设置KVO
    var pullViews : [SimilarZHPullDownView]? {
        
        willSet{
           
            //进行newValue的转换
            newValue!.first?.headerTitle = headerTitle
            newValue!.first?.type = .header
            
            newValue!.last?.footerTitle = footerTitle
            newValue!.last?.type = .footer
            
            self.ritl_pullViews = newValue!
        }
    }
    
    
    /// 真正用于显示的视图数组
    fileprivate var ritl_pullViews : [SimilarZHPullDownView] = [SimilarZHPullDownView]()
    
    
    /// 存放滚动页的主滚动页
    lazy var scrollView:UIScrollView = {
        
        let scrollView : UIScrollView = UIScrollView(frame: CGRect(x: 0,y: self.titleLabel.bounds.height,width: self.bounds.width,height: self.bounds.height - 50 - 64))
        
        scrollView.isPagingEnabled = true//分页显示
        scrollView.showsVerticalScrollIndicator = false //不显示垂直滚条
        scrollView.isScrollEnabled = false //不能滚动
        
        return scrollView
        
    }()
    
    
    /// 显示标题的标题
    lazy var titleLabel:UILabel = {
        
        let label:UILabel = UILabel(frame: CGRect(x: 0,y: 0,width: self.bounds.width,height: 50))
        
        label.textAlignment = .center
        
        return label
        
    }()
    
    
    //MARK: - FUNCTION
    
    //MARK: - 构造方法
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        addSubview(scrollView)
    }


    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    

    
    override func layoutSubviews() {
        
        if shouldLayoutAddSubViews {
            
            addChildView()
            shouldLayoutAddSubViews = false
        }

        //设置自身的contentSize
        scrollView.contentSize = CGSize(width: bounds.width, height: CGFloat(ritl_pullViews.count) * bounds.height)

    }
    
    
    
    
    //MARK: - 功能方法

    /**
    *  添加子视图
    */
    func addChildView()
    {
        //获取当前视图的高度和宽度
        let height = self.bounds.height
        let width = self.bounds.width
        

        for i in 0 ..< ritl_pullViews.count
        {
            //获取存储的SimilarZHPullDownView对象
            let pullDownView = self.ritl_pullViews[i]
            
            pullDownView.frame = CGRect(x: 0, y: CGFloat(i) * height, width: width, height: height - 64 - 50)
            
            //设置代理
            pullDownView.delegate = self
            
            //添加视图
            scrollView.addSubview(pullDownView)
        }
        
        titleLabel.text = ritl_pullViews.first?.title
    }


    
    
    // MARK: - SimilarZHPullDownView Delegate
    func similarZHPullDownView(_ similarZHPullDownView: SimilarZHPullDownView, pullType: PullType)
    {
        //修复pullViews.count == 1 ,the program is terminated
        guard ritl_pullViews.count > 1 else {
            
            return
        }

        //获得当前的偏移量
        let contentOffset = scrollView.contentOffset
        
        //获得索引数
        let index = ritl_pullViews.index(of: similarZHPullDownView)
        
        switch pullType
        {
            case .up: //上翻页
                
                if similarZHPullDownView.type != .header {
                    
                    pullDone(CGFloat(-1), contentOffset: contentOffset, index: index!)
                }
            
            case .down://下翻页
                
                if similarZHPullDownView.type != .footer {
                    
                    pullDone(CGFloat(1), contentOffset: contentOffset, index: index!)
                }
        }
    }
    
    
    
    /**
     *  滚动操作
     */
    func pullDone(_ paramNumber:CGFloat, contentOffset:CGPoint, index:Int)
    {
        var contentOffset = contentOffset
        
        contentOffset.y += (paramNumber * bounds.size.height)
        
        scrollView.setContentOffset(contentOffset, animated: true)
        
        //显示即将出现的similarZHPullDownView对象的title
        titleLabel.text = ritl_pullViews[index + Int(paramNumber)].title
    }
    
}
