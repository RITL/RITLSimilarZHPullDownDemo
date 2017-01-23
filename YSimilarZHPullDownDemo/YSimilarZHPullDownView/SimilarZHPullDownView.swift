//
//  SimilarZHPullDownView.swift
//  YSimilarZHPullDownDemo
//
//  Created by YueWen on 16/3/8.
//  Copyright © 2016年 YueWen. All rights reserved.
//

import UIKit


/// 滑动响应的方式
///
/// - pullTypeUp    上翻页
/// - pullTypeDown  下翻页
enum PullType
{
    case up
    case down
}

/// 下拉的类型
///
/// - middle: 默认中间
/// - header: 第一页
/// - footer: 最后一页
enum SimilarZHPullDownType
{
    case middle
    case header
    case footer
}


protocol SimilarZHPullDownViewDelegate : NSObjectProtocol
{

    /// 需要翻页进行的回调
    ///
    /// - Parameters:
    ///   - similarZHPullDownView: 进行回调的SimilarZHPullDownView
    ///   - pullType: 翻页类型
    func similarZHPullDownView(_ similarZHPullDownView : SimilarZHPullDownView , pullType:PullType)

}


/// 类知乎的下拉换页
class SimilarZHPullDownView: UIView
{

    /// 响应的高度，就是滑动响应的最小幅度
    final let responseHeight = CGFloat(60)
    
    
    /// 懒加载底层的滚动视图
    lazy var bottomScrollView : UIScrollView  =
    {
        //当前视图的宽度
        let width = self.bounds.size.width
        
        //初始化滚动视图
        var scrollView:UIScrollView = UIScrollView(frame:CGRect(x: 0, y: 0, width: width, height: self.bounds.size.height))
        
        scrollView.addSubview(self.customView!)
        
        //自定义视图的的高度
        var height = self.customView?.bounds.size.height
        
        //头页
        scrollView.addSubview(self.createLable(CGRect(x: 0,y: -1 * self.responseHeight,width: width,height: 30), title: self.headerTitle))
        
        //尾页
        scrollView.addSubview(self.createLable(CGRect(x: 0,y: height!,width: width,height: self.responseHeight), title:self.footerTitle))
        
        //设置ContentSize的高度，保证不小于视图的高度
        height = (height! > self.bounds.size.height ? height : self.bounds.size.height)
        
        scrollView.contentSize = CGSize(width: self.bounds.size.width, height: height!)
        scrollView.delegate = self;

        
        return scrollView
    }()
    
    
    /// 中间位置的自定义视图
    var customView:UIView?
    
    /// 代理
    weak var delegate : SimilarZHPullDownViewDelegate?
    
    /// 标签上写的Title
    var headerTitle = "上一篇"
    var footerTitle = "下一篇"
    var title = "Title"
    
    /// 类型
    var type : SimilarZHPullDownType = .middle
    

    //MARK: - FUNCTION
    override init(frame: CGRect) {
        
        super.init(frame: frame)
    }
    
    
    /**
     *  便利构造方法
     */
    convenience init(frame: CGRect ,custom:UIView)
    {
        self.init(frame:frame)
        
        customView = custom
    }
    
    /**
     *  便利构造方法
     */
    convenience init(custom:UIView)
    {
        self.init(frame:CGRect.null,custom:custom)
    }
    
    /**
     *  便利构造方法
     */
    convenience init(custom:UIView,title:String)
    {
        self.init(custom:custom)
        self.title = title
        
    }
    
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder:aDecoder)
    }

    override func awakeFromNib() {
        
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        addSubview(bottomScrollView)
    }


    /// 创建标签
    ///
    /// - Parameters:
    ///   - frame:
    ///   - title: 标签显示的title
    /// - Returns:
    func createLable(_ frame:CGRect,title:String) -> UILabel
    {
        let label:UILabel = UILabel(frame: frame)
        label.text = title
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }
    

}

extension SimilarZHPullDownView : UIScrollViewDelegate
{

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        //获得偏移量
        let contentOffsetY = scrollView.contentOffset.y
        
        //当前响应的高度，因为下拉，所以响应距离为负数
        let beforeHeight = self.responseHeight * (-1)
        
        if(contentOffsetY < beforeHeight)
        {
            print("我是DownView,上一页!")
            //表示上一页
            self.delegate?.similarZHPullDownView(self, pullType: .up)
        }
            
            //偏移量是视图左上角，所以垂直坐标需要-滚动视图的高度
        else if(contentOffsetY > (scrollView.contentSize.height - scrollView.bounds.size.height + self.responseHeight))
        {
            print("我是DownView,下一页!")
            //表示下一页
            self.delegate?.similarZHPullDownView(self, pullType: .down)
        }
    }
}
