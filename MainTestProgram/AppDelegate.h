//
//  AppDelegate.h
//  MainTestProgram
//
//  Created by zjn on 2017/8/29.
//  Copyright © 2017年 zjn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

