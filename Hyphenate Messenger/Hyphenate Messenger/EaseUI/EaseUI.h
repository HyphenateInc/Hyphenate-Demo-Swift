/************************************************************
 *  * Hyphenate 
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */
#ifndef EaseUI_h
#define EaseUI_h

#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE

#import "EaseConversationListViewController.h"
#import "EaseMessageViewController.h"
#import "EaseUsersListViewController.h"
#import "EaseViewController.h"

#import "IModelCell.h"
#import "IModelChatCell.h"
#import "EaseMessageCell.h"
#import "EaseBaseMessageCell.h"
#import "EaseBubbleView.h"
#import "EaseUserCell.h"

#import "EaseChineseToPinyin.h"
#import "EaseEmoji.h"
#import "EaseEmotionEscape.h"
#import "EaseEmotionManager.h"
#import "EaseSDKHelper.h"
#import "EMCDDeviceManager.h"
#import "EaseConvertToCommonEmoticonsHelper.h"

#import "NSDate+Category.h"
#import "UIColor+EaseUI.h"
#import "NSString+Valid.h"
#import "UIImageView+EMWebCache.h"
#import "UIViewController+HUD.h"
#import "UIViewController+DismissKeyboard.h"
#import "EaseLocalDefine.h"

// Constants
#define kNotification_conversationUpdated @"kNotification_conversationUpdated"
#define kNotification_unreadMessageCountUpdated @"kNotification_unreadMessageCountUpdated"
#define kNotification_didReceiveCmdMessages @"kNotification_didReceiveCmdMessages"
#define kNotification_didReceiveMessages @"didReceiveMessages"

#endif

#endif