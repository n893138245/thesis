#ifndef MOBFoundation_MOBFImageServiceTypeDef_h
#define MOBFoundation_MOBFImageServiceTypeDef_h
#import <UIKit/UIKit.h>
typedef NSData* (^MOBFImageGetterCacheHandler)(NSData *imageData);
typedef void (^MOBFImageGetterResultHandler)(UIImage *image, NSError *error);
typedef void (^MOBFImageDataGetterResultHandler)(NSData *imageData, NSError *error);
#endif