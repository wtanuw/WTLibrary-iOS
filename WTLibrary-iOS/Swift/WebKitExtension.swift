//
//  WebKitExtension.swift
//  Pods
//
//  Created by imac on 6/29/18.
//
//

import Foundation

func webviewToImage(webView:WKWebView) -> UIImage
{
    let currentWebViewHeight = webView.scrollView.contentSize.height
    var scrollByY = webView.frame.size.height
    
    webView.scrollView.setContentOffset(CGPoint(x:0, y:0), animated: false)
    
    var images:[UIImage] = []
    
    var screenRect = webView.frame;
    
    var pages:Int = Int(currentWebViewHeight/scrollByY);
    if (currentWebViewHeight.truncatingRemainder(dividingBy: scrollByY) > 0) {
        pages = pages+1
    }
    
    for i in 0..<pages
    {
        if (i == pages-1) {
            if pages>1 {
                screenRect.size.height = currentWebViewHeight - scrollByY
            }
        }
        
        //        if (IS_RETINA)
        UIGraphicsBeginImageContextWithOptions(screenRect.size, false, 0);
        //        else
        //        UIGraphicsBeginImageContext( screenRect.size );
        //        if (webView.layer.respondsToSelector(@selector(setContentsScale:))) {
        //            webView.layer.contentsScale = [[UIScreen mainScreen] scale];
        //        }
        //UIGraphicsBeginImageContext(screenRect.size);
        let ctx = UIGraphicsGetCurrentContext()!
        UIColor.black.set()
        ctx.fill(screenRect)
        
        webView.layer.render(in: ctx)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if (i == 0)
        {
            scrollByY = webView.frame.size.height
        }
        else
        {
            scrollByY += webView.frame.size.height
        }
        webView.scrollView.setContentOffset(CGPoint(x:0, y:scrollByY), animated: false)
        images.append(newImage!)
        FileManager.default.createFile(atPath: "/Users/imac/Desktop/tmp\(i).png", contents: UIImagePNGRepresentation(newImage!), attributes: nil)
        
    }
    
    webView.scrollView.setContentOffset(CGPoint(x:0, y:0), animated: false)
    
    var resultImage:UIImage
    
    if(images.count > 1) {
        //join all images together..
        var size :CGSize = CGSize(width:0, height:0)
        for i in 0..<images.count {
            
            size.width = max(size.width, images[i].size.width)
            size.height += images[i].size.height
        }
        
        //        if (IS_RETINA)
        UIGraphicsBeginImageContextWithOptions(size, false, 0);
        //        else
        //        UIGraphicsBeginImageContext(size);
        //        if ([webView.layer respondsToSelector:@selector(setContentsScale:)]) {
        //            webView.layer.contentsScale = [[UIScreen mainScreen] scale];
        //        }
        //        CGContextRef ctx = UIGraphicsGetCurrentContext();
        //        [[UIColor blackColor] set];
        //        CGContextFillRect(ctx, screenRect);
        //
        var y=CGFloat(0);
        for i in 0..<images.count {
            
            let img = images[i]
            img.draw(at: CGPoint(x:0, y:y))
            y += img.size.height;
        }
        
        resultImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
    } else {
        resultImage = images[0]
    }
    images.removeAll()
    return resultImage
}

extension WKWebView{
    func snapshotForCompletePage() -> UIImage {
        // tempframe to reset view size after image was created
        let tmpFrame: CGRect = self.frame
        // set full size Frame
        var fullSizeFrame: CGRect = self.frame
        fullSizeFrame.size.height = self.scrollView.contentSize.height
        self.frame = fullSizeFrame
        self.layoutSubviews()
        
        // here the image magic begins
        UIGraphicsBeginImageContextWithOptions(fullSizeFrame.size, false, UIScreen.main.scale)
        let resizedContext: CGContext = UIGraphicsGetCurrentContext()!
        self.layer.render(in: resizedContext)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        // reset Frame of view to origin
        self.frame = tmpFrame
        return image
    }
}
