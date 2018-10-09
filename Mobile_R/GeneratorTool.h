//
//  GeneratorTool.h
//  Mobile_R
//
//  Created by JS_Coder on 10/8/18.
//  Copyright © 2018 JS_Coder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreImage/CoreImage.h>
#import <Cocoa/Cocoa.h>

@interface GeneratorTool : NSObject
+ (GeneratorTool *) getInstance;
- (CIImage *)generateBarCodeImageWithString:(NSString *)source;
- (NSImage *) resizeCodeImage:(CIImage *)image withSize:(CGSize)size;
@end
