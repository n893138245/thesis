#import "MOBFImageObserver.h"
#import "MOBFImageServiceTypeDef.h"
#import <Foundation/Foundation.h>
@class MOBFImageCachePolicy;
@interface MOBFImageGetter : NSObject
+ (instancetype _Nullable )sharedInstance;
- (instancetype _Nullable )initWithCachePolicy:(MOBFImageCachePolicy *_Nullable)cachePolicy;
- (BOOL)existsImageCacheWithURL:(NSURL *_Nullable)url;
- (MOBFImageObserver *_Nonnull)getImageWithURL:(NSURL *_Nullable)url
                                        result:(MOBFImageGetterResultHandler _Nullable )resultHandler;
- (MOBFImageObserver *_Nullable)getImageWithURL:(NSURL * _Nullable)url
                        allowReadCache:(BOOL)allowReadCache
                                result:(MOBFImageGetterResultHandler _Nullable )resultHandler;
- (MOBFImageObserver *_Nullable)getImageDataWithURL:(NSURL * _Nullable)url
                                    result:(MOBFImageDataGetterResultHandler _Nullable)resultHandler;
- (MOBFImageObserver *_Nullable)getImageDataWithURL:(NSURL * _Nullable)url
                            allowReadCache:(BOOL)allowReadCache
                                    result:(MOBFImageDataGetterResultHandler _Nullable)resultHandler;
- (void)removeImageObserver:(MOBFImageObserver * _Nullable)imageObserver;
- (void)removeImageForURL:(nullable NSURL *)url;
- (void)clearDisk;
@end