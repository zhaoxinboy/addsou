//
//  SJContextMenuHelper.m
//  addsou
//
//  Created by 杨兆欣 on 2017/3/27.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import "SJContextMenuHelper.h"


@interface SJContextMenuHelper ()<UIGestureRecognizerDelegate, WKScriptMessageHandler>

@end

@implementation SJContextMenuHelper{
    SJWebViewController *_webVC;      // 持有若引用网页
}

// 获取自定义js代码
- (NSString *)jsString{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"sjtool.js" withExtension:nil];
    return [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:NULL];
}

- (instancetype)initWithWebViewController:(SJWebViewController *)webVC
{
    self = [super init];
    if (self) {
        _webVC = webVC;
        NSString *soure = [self jsString];
        WKUserScript *userScript = [[WKUserScript alloc] initWithSource:soure injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:NO];
        [_webVC.sjWebView.webView.configuration.userContentController addUserScript:userScript];
        [_webVC.sjWebView.webView.configuration.userContentController addScriptMessageHandler:self name:@"contextMenuMessageHandler"];
        self.gestureRecongnizer = [[UILongPressGestureRecognizer alloc] init];
        self.gestureRecongnizer.delegate = self;
        [_webVC.sjWebView.webView addGestureRecognizer:self.gestureRecongnizer];
        
    }
    return self;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return true;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    id otherDelegate = otherGestureRecognizer.delegate;
    if ([[otherDelegate description] containsString:@"_UIKeyboardBasedNonEditableTextSelectionGestureController"]) {
        self.selectionGestureRecognizer = otherGestureRecognizer;
    }
    
    return YES;
}

- (NSString *)name{
    return @"SJContextMenuHelper";
}

- (NSString *)scriptMessageHandlerName{
    return @"contextMenuMessageHandler";
}


#pragma mark - OC在JS调用方法做的处理
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    
    NSMutableDictionary *data = (NSMutableDictionary *)message.body;
    
    
    self.selectionGestureRecognizer.enabled = (NSString *)[data objectForKey:@"handled"];
    NSURL *linkURL = nil;
    if ([data objectForKey:@"link"]) {
        linkURL = [NSURL URLWithString:[(NSString *)[data objectForKey:@"link"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    }
    NSURL *imageURL = nil;
    if ([data objectForKey:@"image"]) {
        imageURL = [NSURL URLWithString:[(NSString *)[data objectForKey:@"image"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    }
    
    
    
    
    if ([data objectForKey:@"link"] || [data objectForKey:@"image"]) {
        Elements *elements = [Elements new];
        elements.link = linkURL;
        elements.image = imageURL;
        elements.strid = [data objectForKey:@"divid"];
        if (self.contextMenuHelpserDelegate && [self.contextMenuHelpserDelegate respondsToSelector:@selector(contextMenuHelper:didLongPressElements:gestureRecognizer:)]) {
            [self.contextMenuHelpserDelegate contextMenuHelper:self didLongPressElements:elements gestureRecognizer:self.gestureRecongnizer];
        }
    }
    
    
}

@end
