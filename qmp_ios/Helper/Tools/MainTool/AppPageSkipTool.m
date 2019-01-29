//
//  AppPageSkipTool.m
//  CommonLibrary
//
//  Created by QMP on 2018/11/7.
//  Copyright © 2018年 WSS. All rights reserved.
//

#import "AppPageSkipTool.h"
#import "PersonDetailsController.h"
#import "UnauthPeresonPageController.h"
#import "ProductDetailsController.h"
#import "OrganizeDetailViewController.h"
#import "ChatViewController.h"
#import "BecomeOfficialPersonVC.h"
#import "ConversationListController.h"
#import "PostActivityViewController.h"
#import "MainSearchController.h"
#import "RegisterInfoViewController.h"
#import "QMPActivityCategoryViewController.h"
#import "ActivityDetailViewController.h"
#import "QMPCommunityController.h"
#import "QMPCommunityController.h"

@interface AppPageSkipTool()<AppPageSkipProtocol>

@end

@implementation AppPageSkipTool

+ (instancetype)shared{
    static AppPageSkipTool *tool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[AppPageSkipTool alloc]init];
    });
    return tool;
}


-(void)appPageSkipToPersonDetail:(NSString *)personId{
    PersonDetailsController *vc = [[PersonDetailsController alloc] init];
    vc.persionId = personId;
    [[PublicTool topViewController].navigationController pushViewController:vc animated:YES];
}

-(void)appPageSkipToPersonDetail:(NSString *)personId nameLabBgColor:(UIColor*)nameLabColor{
    PersonDetailsController *vc = [[PersonDetailsController alloc] init];
    vc.persionId = personId;
    vc.nameLabColor = nameLabColor;
    [[PublicTool topViewController].navigationController pushViewController:vc animated:YES];
}

-(void)appPageSkipToUserDetail:(NSString *)unionid{
    UnauthPeresonPageController *vc = [[UnauthPeresonPageController alloc]init];
    vc.unionid = unionid;
    [[PublicTool topViewController].navigationController pushViewController:vc animated:YES];
}

-(void)appPageSkipToPersonDetail:(NSString *)personId fromClaimReq:(BOOL)fromClaim{
    PersonDetailsController *vc = [[PersonDetailsController alloc] init];
    vc.persionId = personId;
    vc.fromClaimReq = fromClaim;
    [[PublicTool topViewController].navigationController pushViewController:vc animated:YES];
}

- (void)appPageSkipToClaimPage{
    BecomeOfficialPersonVC *becomePersonVC = [[BecomeOfficialPersonVC alloc]init];
    [[PublicTool topViewController].navigationController pushViewController:becomePersonVC animated:YES];
}


#pragma mark ---项目相关
- (void)appPageSkipToDetail:(NSString*)urlStr{
    
    NSDictionary *urlDict = [PublicTool toGetDictFromStr:urlStr];
    if ([PublicTool isNull:urlDict[@"ticket"]] || [PublicTool isNull:urlDict[@"id"]]) {
        return;
    }
    if([urlStr containsString:@"detailcom"]){
        
        //如果是公司
        ProductDetailsController *companyDetailVC = [[ProductDetailsController alloc]init];
        companyDetailVC.urlDict = urlDict;
        [[PublicTool topViewController].navigationController pushViewController:companyDetailVC animated:YES];
        
    }else if([urlStr containsString:@"detailorg"]){
        //如果是机构
        OrganizeDetailViewController *jigouDetailVC = [[OrganizeDetailViewController alloc]init];
        jigouDetailVC.urlDict = urlDict;
        [[PublicTool topViewController].navigationController pushViewController:jigouDetailVC animated:YES];
        
    }
}
- (void)appPageSkipToProductDetail:(NSDictionary*)productParam{
    if ([PublicTool isNull:productParam[@"ticket"]] || [PublicTool isNull:productParam[@"id"]]) {
        return;
    }
    NSString *ticket = productParam[@"ticket"];
    if([PublicTool checkIsChinese:ticket]){
        [self appPageSkipToRegisterDetail:productParam];
        return;
    }
    
    ProductDetailsController *detailVC = [[ProductDetailsController alloc]init];
    detailVC.urlDict = productParam;//传过去url参数
    [[PublicTool topViewController].navigationController pushViewController:detailVC animated:YES];
    
}

- (void)appPageSkipToRegisterDetail:(NSDictionary*)registerDic{
    RegisterInfoViewController *registerDetailVC = [[RegisterInfoViewController alloc] init];
    registerDetailVC.urlDict = registerDic;
    [[PublicTool topViewController].navigationController pushViewController:registerDetailVC animated:YES];
}
#pragma mark ---机构相关
- (void)appPageSkipToJigouDetail:(NSDictionary*)jigouParam{
    if ([PublicTool isNull:jigouParam[@"ticket"]] || [PublicTool isNull:jigouParam[@"id"]]) {
        return;
    }
    OrganizeDetailViewController *detailVC = [[OrganizeDetailViewController alloc]init];
    detailVC.urlDict = jigouParam;//传过去url参数
    [[PublicTool topViewController].navigationController pushViewController:detailVC animated:YES];
}


#pragma mark --聊天
- (void)appPageSkipToChatView:(NSString *)userCode verifyUserClaim:(BOOL)verifyUser{
    if (![ToLogin canEnterDeep]) {
        [ToLogin accessEnterDeep];
        return;
    }
    if ([PublicTool isNull:userCode]) {
        return;
    }
    if (!verifyUser) {
        [[AppPageSkipTool shared] appPageSkipToChatView:[NSString stringWithFormat:@"%@",userCode]];
        return;
    }
    if(![PublicTool userisCliamed]){
        return;
    }
    
    [[AppPageSkipTool shared] appPageSkipToChatView:[NSString stringWithFormat:@"%@",userCode]];

}
- (void)appPageSkipToChatView:(NSString *)userCode {
    if (![ToLogin canEnterDeep]) {
        [ToLogin accessEnterDeep];
        return;
    }
    ChatViewController *chatVC = [[ChatViewController alloc]initWithConversationChatter:userCode conversationType:EMConversationTypeChat];
    FriendModel *friend1 = [[FriendModel alloc]init];
    friend1.usercode = userCode;
    chatVC.chatFriendM = friend1;
    [[PublicTool topViewController].navigationController pushViewController:chatVC animated:YES];
}
- (void)appPageSkipToConversationList {
    
    if (![ToLogin canEnterDeep]) {
        [ToLogin accessEnterDeep];
        return;
    }
    ConversationListController *vc = [[ConversationListController alloc] init];
    [[PublicTool topViewController].navigationController pushViewController:vc animated:YES];
}

#pragma mark --动态相关
- (void)appPageSkipToActivityPost {
    if (![PublicTool userisCliamed]) {
        return;
    }
    PostActivityViewController *vc = [[PostActivityViewController alloc] init];
    [[PublicTool topViewController].navigationController pushViewController:vc animated:YES];
}

- (void)appPageSkipToActivityPostNeedGo:(BOOL)go linkUrl:(NSString*)linkUrl{
    if (![PublicTool userisCliamed]) {
        return;
    }

    PostActivityViewController *vc = [[PostActivityViewController alloc] init];
    vc.needGo = go;
    vc.link_url = linkUrl;
    [[PublicTool topViewController].navigationController pushViewController:vc animated:YES];
}

- (void)appPageSkipToActivityDetail:(NSString*)activityID{
    if (![ToLogin canEnterDeep]) {
        [ToLogin accessEnterDeep];
        return;
    }
    ActivityDetailViewController *activityDetail = [[ActivityDetailViewController alloc]init];
    
}

- (void)appPageSkipToActivityCommunity:(NSString*)communityName activityID:(NSString*)activityID{
    UIViewController *vc = KEYWindow.rootViewController;
    if ([vc isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tVc = (UITabBarController *)vc;
        UIViewController *vcf = [PublicTool topViewController];
        [tVc setSelectedIndex:2];
        [vcf.navigationController popToRootViewControllerAnimated:NO];
        UIViewController *vc1 = [PublicTool topViewController];
        
        if ([vc1 isKindOfClass:[QMPCommunityController class]]) {
            QMPCommunityController *vc2 = (QMPCommunityController *)vc1;
            [vc2 showToTag:communityName activityID:activityID];
        }
    }
}


- (void)appPageSkipToMainSearch {
    if (![ToLogin canEnterDeep]) {
        [ToLogin accessEnterDeep];
        return;
    }
    MainSearchController *vc = [[MainSearchController alloc] init];
    [[PublicTool topViewController].navigationController pushViewController:vc animated:YES];
}
@end