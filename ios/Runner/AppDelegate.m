#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface UINavigationController (FixCrash)
@end
@implementation UINavigationController (FixCrash)

+ (void)load {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    [self instanceSwizzle:@selector(popViewControllerAnimated:)
              newSelector:@selector(thrio_popViewControllerAnimated:)];
  });
}

- (UIViewController * _Nullable)thrio_popViewControllerAnimated:(BOOL)animated {
  if (self.viewControllers.count > 1) {
      FlutterViewController *vc = self.viewControllers[self.viewControllers.count - 2];
      AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

      appDelegate.flutterEngine.viewController = vc;
      [self thrio_popViewControllerAnimated:YES];
  }
  return nil;
}

+ (void)instanceSwizzle:(SEL)oldSelector newSelector:(SEL)newSelector {
  Class cls = [self class];
  Method oldMethod = class_getInstanceMethod(cls, oldSelector);
  Method newMethod = class_getInstanceMethod(cls, newSelector);

  if (class_addMethod(cls, oldSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))) {
    class_replaceMethod(cls, newSelector, method_getImplementation(oldMethod), method_getTypeEncoding(oldMethod));
  } else {
    method_exchangeImplementations(oldMethod, newMethod);
  }
}
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame: [UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    
    NSString *str = @"Xl54W7uxUTMDACzIW3tmy0+w";
    int hit = [str hash]%10;
    NSLog(@"[XDEBUG]---%d",hit);
    
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
