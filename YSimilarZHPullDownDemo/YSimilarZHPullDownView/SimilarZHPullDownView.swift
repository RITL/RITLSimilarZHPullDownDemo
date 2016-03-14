//
//  SimilarZHPullDownView.swift
//  YSimilarZHPullDownDemo
//
//  Created by YueWen on 16/3/8.
//  Copyright © 2016年 YueWen. All rights reserved.
//

import UIKit


//滑动响应的方式
enum PullType
{
    case PullTypeUp//上翻页
    case PullTypeDown//下翻页
}



enum SimilarZHPullDownType
{
    case Default    //默认中间页
    case Header     //第一页
    case Footer     //尾页
}


protocol SimilarZHPullDownViewDelegate : class
{
    
    /**
     *  需要翻页进行的回调
     */
    @available(iOS 8.0,*)
    func similarZHPullDownView(similarZHPullDownView : SimilarZHPullDownView , pullType:PullType)
    
    
}


/// 类知乎的下拉换页
class SimilarZHPullDownView: UIView,UIScrollViewDelegate{

    /// 响应的高度，就是滑动响应的最小幅度
    final let responseHeight = CGFloat(60)
    
    
    /// 懒加载底层的滚动视图
    lazy var bottomScrollView : UIScrollView  =
    {
        //当前视图的宽度
        let width = self.bounds.size.width
        
        //初始化滚动视图
        var scrollView:UIScrollView = UIScrollView(frame:CGRectMake(0, 0, width, self.bounds.size.height))
        
        //添加自定义视图
        scrollView.addSubview(self.customView!)
        
        //自定义视图的的高度
        var height = self.customView?.bounds.size.height
        
        //头页
        scrollView.addSubview(self.createLable(CGRectMake(0,-1 * self.responseHeight,width,30), title: self.headerTitle))
        
        //尾页
        scrollView.addSubview(self.createLable(CGRectMake(0,height!,width,self.responseHeight), title:self.footerTitle))
        
        //设置ContentSize的高度，保证不小于视图的高度
        height = height > self.bounds.size.height ? height : self.bounds.size.height
        
        scrollView.contentSize = CGSize(width: self.bounds.size.width, height: height!)
        scrollView.delegate = self;
        
        return scrollView
    }()
    
    /// 中间位置的自定义视图
    var customView:UIView?
    
    /// 代理
    weak var delegate:SimilarZHPullDownViewDelegate?
    
    /// 标签上写的Title
    var headerTitle = "上一篇"
    var footerTitle = "下一篇"
    var title = "Title"
    
    /// 类型
    var type:SimilarZHPullDownType = .Default
    
    
    
    
    
    //MARK: - FUNCTION
    override init(frame: CGRect) {
        
        super.init(frame: frame)
    }
    
    
    /**
     *  便利构造方法
     */
    @available(iOS 8.0,*)
    convenience init(frame: CGRect ,custom:UIView)
    {
        self.init(frame:frame)
        self.customView = custom
    }
    
    /**
     *  便利构造方法
     */
    @available(iOS 8.0,*)
    convenience init(custom:UIView)
    {
        self.init(frame:CGRectNull,custom:custom)
    }
    
    /**
     *  便利构造方法
     */
    @available(iOS 8.0,*)
    convenience init(custom:UIView,title:String)
    {
        self.init(custom:custom)
        self.title = title
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        
    }
    
    override func layoutSubviews(){
        self.addSubview(self.bottomScrollView)
    }
    
    
    //MARK: -提示标签构造方法
    
    /**
    *  创建标签
    */
    @available(iOS 8.0,*)
    func createLable(frame:CGRect,title:String) -> UILabel
    {
        let label:UILabel = UILabel(frame: frame)
        label.text = title
        label.textAlignment = .Center
        label.font = UIFont.systemFontOfSize(12)
        return label
    }
    
    
    //MARK: -UIScrollView Delegate

    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        //获得偏移量
        let contentOffsetY = scrollView.contentOffset.y
        
        //当前响应的高度，因为下拉，所以响应距离为负数
        let beforeHeight = self.responseHeight * (-1)
        if(contentOffsetY < beforeHeight)
        {
            print("我是DownView,上一页!")
            //表示上一页
            self.delegate?.similarZHPullDownView(self, pullType: .PullTypeUp)
        }
            
        //偏移量是视图左上角，所以垂直坐标需要-滚动视图的高度
        else if(contentOffsetY > (scrollView.contentSize.height - scrollView.bounds.size.height + self.responseHeight))
        {
            print("我是DownView,下一页!")
            //表示下一页
            self.delegate?.similarZHPullDownView(self, pullType: .PullTypeDown)
        }
        
    }
}
