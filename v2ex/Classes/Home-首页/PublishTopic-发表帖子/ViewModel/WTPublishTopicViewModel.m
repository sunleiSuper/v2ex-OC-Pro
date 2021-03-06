//
//  PublishTopicViewModel.m
//  v2ex
//
//  Created by 无头骑士 GJ on 2017/4/9.
//  Copyright © 2017年 无头骑士 GJ. All rights reserved.
//

#import "WTPublishTopicViewModel.h"
#import "WTPublishTopicItem.h"

#import "WTNodeItem.h"

#import "TFHpple.h"
#import "WTHTMLExtension.h"
#import "WTURLConst.h"
#import "NetworkTool.h"

#import "MJExtension.h"


@implementation WTPublishTopicViewModel

/**
 发表帖子
 
 @param nodeItem 要发表的节点
 @param title 标题
 @param content 正文
 @param success 请求成功的回调
 @param failure 请求失败的回调
 */
+ (void)publishTopicWithNodeItem:(WTNodeItem *)nodeItem title:(NSString *)title content:(NSString *)content success:(void(^)(NSString *topicDetailUrl))success failure:(void(^)(NSError *error))failure
{
    void(^failureBlock)(NSError *) = ^(NSError *error){
        if (failure) failure(error);
    };
    
    NSString *urlString = [NSString stringWithFormat: @"%@/new/%@", WTHTTPBaseUrl, nodeItem.name];
    [[NetworkTool shareInstance] GETWithUrlString: urlString success:^(id data) {
        
        // 1、获取once
        NSString *html = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
        NSString *once = [WTHTMLExtension getOnceWithHtml: html];
        WTPublishTopicItem *item = [[WTPublishTopicItem alloc] initWithContent: content once: once title: title];
        
        [[NetworkTool shareInstance] requestWithMethod: HTTPMethodTypePOST url: urlString param: item.mj_keyValues success:^(id responseObject) {
            
            NSString *topicDetailUrl = [self topicDetailUrlWithParseData: responseObject];
            
            if (success) success(topicDetailUrl);
            
        } failure: failureBlock];
        
    } failure: failureBlock];
}


/**
 解析二进制获取详情URL

 @param data 二进制
 @return 详情URL
 */
+ (NSString *)topicDetailUrlWithParseData:(NSData *)data
{
    TFHpple *doc = [[TFHpple alloc] initWithHTMLData: data];
    return [[doc peekAtSearchWithXPathQuery: @"//meta[@property='og:url']"] objectForKey: @"content"];
}
@end
