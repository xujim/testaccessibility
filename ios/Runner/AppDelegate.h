#import <Flutter/Flutter.h>
#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder<FlutterPlugin, UIApplicationDelegate>
@property (nonatomic,strong) FlutterMethodChannel *methodChannel;
@property (nonatomic,strong) FlutterEngine *flutterEngine;
@property (strong, nonatomic) UIWindow* window;
@end
