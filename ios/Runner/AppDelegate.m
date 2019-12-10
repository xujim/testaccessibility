#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame: [UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    
    UIButton *nativeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nativeButton.frame = CGRectMake(self.window.frame.size.width * 0.5 - 75, 200, 150, 45);
    nativeButton.backgroundColor = [UIColor redColor];
    [nativeButton setTitle:@"Push Flutter VC" forState:UIControlStateNormal];
    [nativeButton addTarget:self action:@selector(pushNative) forControlEvents:UIControlEventTouchUpInside];
    
    self.flutterEngine = [[FlutterEngine alloc] initWithName:@"io.flutter" project:nil];
    [self.flutterEngine runWithEntrypoint:nil];
    [self.class registerWithRegistrar:[self.flutterEngine registrarForPlugin:@"testaccessibility"]];
    [GeneratedPluginRegistrant registerWithRegistry:self.flutterEngine];
  // Override point for customization after application launch.
    
//    UIViewController *vc = [[UIViewController alloc]init];
//    vc.view.backgroundColor = [UIColor whiteColor];
//    [vc.view addSubview:nativeButton];
    FlutterViewController *vc = [[FlutterViewController alloc]initWithEngine:self.flutterEngine nibName:nil bundle:nil];
    UINavigationController *rvc = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = rvc;
  return YES;
}

- (void)pushNative {
    UINavigationController *nvc = (id)self.window.rootViewController;
    FlutterViewController *vc = [[FlutterViewController alloc]initWithEngine:self.flutterEngine nibName:nil bundle:nil];
    [nvc pushViewController:vc animated:YES];
}

#pragma FlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"test_channel"
                                     binaryMessenger:[registrar messenger]];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.methodChannel = channel;
    [registrar addMethodCallDelegate:appDelegate channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if([@"closePage" isEqualToString:call.method]){
        UINavigationController *nav = [UIApplication sharedApplication].keyWindow.rootViewController.navigationController;
        [nav popViewControllerAnimated:YES];
    }else if([@"openPage" isEqualToString:call.method]){
//        FlutterViewController *oldVC = (FlutterViewController *)self.flutterEngine.viewController;
//        ((void(*)(id, SEL, BOOL))objc_msgSend)(oldVC, NSSelectorFromString(@"surfaceUpdated:"), NO);
        FlutterViewController *vc = [[FlutterViewController alloc]initWithEngine:self.flutterEngine nibName:nil bundle:nil];
        UINavigationController *nav = (id)self.window.rootViewController;
        [nav pushViewController:vc animated:YES];
    }else{
        result(FlutterMethodNotImplemented);
    }
}
@end
