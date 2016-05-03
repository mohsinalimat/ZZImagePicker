//
//  ZZPhotoPreviewCellCollectionViewCell.swift
//  ZZImagePicker
//
//  Created by duzhe on 16/5/3.
//  Copyright © 2016年 dz. All rights reserved.
//

import UIKit

extension CGSize{
    /** 按比例缩放 */
    func ratioSize(ratio: CGFloat) -> CGSize{
        return CGSizeMake(self.width / ratio, self.height / ratio)
    }
}

func decisionShowSize(imgSize: CGSize) ->CGSize{
    let heightRatio = imgSize.height / zz_sh
    let widthRatio = imgSize.width / zz_sw
    if heightRatio > 1 && widthRatio>1 {return imgSize.ratioSize(max(heightRatio, widthRatio))}
    if heightRatio > 1 && widthRatio <= 1 {return imgSize.ratioSize(heightRatio)}
    if heightRatio <= 1 && widthRatio > 1 {return imgSize.ratioSize(widthRatio)}
    if heightRatio <= 1 && widthRatio < 1 {return imgSize.ratioSize(max(widthRatio,heightRatio))}
    return imgSize
}
class ZZPhotoPreviewCell: UICollectionViewCell {
    
    var scrollView:UIScrollView!
    var imageView:UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        scrollView = UIScrollView(frame: self.contentView.bounds)
        self.contentView.addSubview(scrollView)
        scrollView.delegate = self
        
        imageView = UIImageView()
        imageView.frame = scrollView.bounds
        scrollView.addSubview(imageView)
        scrollView.maximumZoomScale = 3.0
        scrollView.minimumZoomScale = 1.0
        
        imageView.contentMode = .ScaleAspectFit
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(ZZPhotoPreviewCell.doubleTapImg))
        doubleTap.numberOfTouchesRequired = 1
        doubleTap.numberOfTapsRequired = 2
        self.imageView.addGestureRecognizer(doubleTap)
        self.imageView.userInteractionEnabled = true
        
    }
    
    func calSize(){
        scrollView.zoomScale = 1.0
        guard let image = self.imageView.image else {return }
        let size = image.size
        let mbSize = decisionShowSize(size)
        print(mbSize)
        imageView.frame.size = mbSize
//        imageView.frame.origin.y = ( self.contentView.frame.height - mbSize.height) / 2
        imageView.center = scrollView.center
        
    }
    
    func doubleTapImg(){
        if scrollView.zoomScale == 1.0 {
            UIView.animateWithDuration(0.5, animations: {
                self.scrollView.zoomScale = 3.0
            })
            
        }else{
            UIView.animateWithDuration(0.5, animations: {
                self.scrollView.zoomScale = 1.0
            })
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
}

extension ZZPhotoPreviewCell:UIScrollViewDelegate{

    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        var xcenter = scrollView.center.x
        var ycenter = scrollView.center.y
        xcenter = scrollView.contentSize.width > scrollView.frame.size.width ? scrollView.contentSize.width/2:xcenter
        ycenter = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height/2:ycenter
        imageView.center = CGPointMake(xcenter, ycenter)
    }
}