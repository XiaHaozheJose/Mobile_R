//
//  GeneratorTool.m
//  Mobile_R
//
//  Created by JS_Coder on 10/8/18.
//  Copyright © 2018 JS_Coder. All rights reserved.
//

#import "GeneratorTool.h"
#import <CoreImage/CoreImage.h>

@implementation GeneratorTool



static GeneratorTool* instance = nil;


+(GeneratorTool *) getInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
    });
    return instance;
}

+(id)allocWithZone:(struct _NSZone*)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });    return instance;
}


//生成条形码的CIImage对象
- (CIImage *)generateBarCodeImageWithString:(NSString *)source
{
    // iOS 8.0以上的系统才支持条形码的生成，iOS8.0以下使用第三方控件生成
    //    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
    // 注意生成条形码的编码方式
    NSData *data = [source dataUsingEncoding: NSASCIIStringEncoding];
    CIFilter *filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    [filter setValue:data forKey:@"inputMessage"];
    // 设置生成的条形码的上，下，左，右的margins的值
    [filter setValue:[NSNumber numberWithInteger:5] forKey:@"inputQuietSpace"];
    return filter.outputImage;
    //    }else{
    //        return nil;
    //    }
}



/**
 *  调整生成的图片的大小
 *
 *  @param image CIImage对象
 *  @param size  需要的UIImage的大小
 *
 *  @return size大小的UIImage对象
 */


- (NSImage *)resizeCodeImage:(CIImage *)image withSize:(CGSize)size{
    if (image) {
        CGRect extent = CGRectIntegral(image.extent);
        CGFloat scaleWidth = size.width/CGRectGetWidth(extent);
        CGFloat scaleHeight = size.height/CGRectGetHeight(extent);
        size_t width = CGRectGetWidth(extent) * scaleWidth;
        size_t height = CGRectGetHeight(extent) * scaleHeight;
        CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceGray();
        CGContextRef contentRef = CGBitmapContextCreate(nil, width, height, 8, 0, colorSpaceRef, (CGBitmapInfo)kCGImageAlphaNone);
        CIContext *context = [CIContext contextWithOptions:nil];
        CGImageRef imageRef = [context createCGImage:image fromRect:extent];
        CGContextSetInterpolationQuality(contentRef, kCGInterpolationNone);
        CGContextScaleCTM(contentRef, scaleWidth, scaleHeight);
        CGContextDrawImage(contentRef, extent, imageRef);
        CGImageRef imageRefResized = CGBitmapContextCreateImage(contentRef);
        CGContextRelease(contentRef);
        CGImageRelease(imageRef);
        
        return [[NSImage alloc]initWithCGImage:imageRefResized size:size];
    }else{
        return nil;
    }
}
@end
