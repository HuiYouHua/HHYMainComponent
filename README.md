# HHYMainComponent
组件化开发---主工程

简书教程传送门：[教你从零到一搭建组件化项目](https://www.jianshu.com/p/267fc922897d)

[主工程](https://github.com/HuiYouHua/HHYMainComponent)

[组件A](https://github.com/HuiYouHua/HHYComponentA)

[组件B](https://github.com/HuiYouHua/HHYComponentB)

[组件C](https://github.com/HuiYouHua/HHYComponentC)


[组件调度中心](https://github.com/HuiYouHua/HHYCTMediator)

[私有索引仓库HHYSpecs](https://github.com/HuiYouHua/HHYSpecs)


>组件化的目的就是为了在项目越做越大的时候，进行项目的解耦，在需要加入模块的时候直接pod，不需要是直接删除pod即可，方便快捷，使得项目模块清晰，更加可以自由复用。 
>
>前篇介绍了怎么用[Cococapods搭建私有仓库](https://www.jianshu.com/p/9975a364b476)，这里我们就用这种方式去搭建我们的组件化项目。

##一、概览
  搭建组件化项目我们首先需要一个组件的调度中心，这里我借用了casatwy的[CTMediator](https://github.com/casatwy/CTMediator)，同时也可以看看他对于组件化项目的讲解，[iOS应用架构谈 组件化方案](https://casatwy.com/iOS-Modulization.html "Permalink to iOS应用架构谈 组件化方案")]。
其次我建立一个主工程HHYMainComponent，还有三个组件模块：HHYComponentA、HHYComponentB、HHYComponentC。

关系如下：

![Snip20181203_1.png](https://upload-images.jianshu.io/upload_images/2202576-7edc76e37239d5f9.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

下面就开始搭建我们的项目。

##二、搭建项目
####1. 创建调度中心
这里我们用CTMediator作为我们的调度中心，创建一个文件夹放入核心代码，初始化podspec文件，并上传到github上。这里不太清楚podspec的可以先去看下前篇文章：[Cococapods搭建私有仓库](https://www.jianshu.com/p/9975a364b476)
####2.创建模块及主工程
这里每个模块及工程我们各建一个空工程，初始化pod及podspec。
到这里我们的项目工程都搭建出来了。下面我们开始分析模块化怎么搭建。
####3.搭建模块ABC
这里我们以我搭建的HHYComponentA项目为例来讲解。
首先我搭建的模块项目目录结构如下：

![Snip20181203_2.png](https://upload-images.jianshu.io/upload_images/2202576-be9af59ffbd7cda6.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

一级目录里我们有 podspec 以及 MIT 证书文件，另跟github上的项目关联了，其次二级目录里我们除了初始化的项目工程文件外我们还建了四个文件夹：Controller、CTMediaCategory、Model、Target。
这里关于Model文件是我用来做对象类型传值用的，没什么用，暂且不谈了，主要是另外几个文件。

- Controller：就是我们的模块化控制器
- CTMediaCategory：是我们的调度中心CTMediator的一个分类，它主要负责消息的转发及参数的传递。
- Target：它负责通过消息转发之后的消息处理，进行控制器对象的创建并返回。

这个就是我们创建好后的工程目录结构：

![Snip20181203_3.png](https://upload-images.jianshu.io/upload_images/2202576-e9d9cae77931931f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#####1）CTMediator+HHYComponentA
这里我们先看CTMediator+HHYComponentA文件
```
- (UIViewController *)HHYComponentA:(HHYUser *)user {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"user"] = user;
    return [self performTarget:@"HHYComponentA" action:@"HHYComponentA" params:params shouldCacheTarget:NO];
}
```
这里我们通过调用调度中心的**performTarget： action： params: shouldCacheTarget:**方法将参数传递进去，同时返回一个控制器。我们进入这个方法看一下。
```
- (id)performTarget:(NSString *)targetName action:(NSString *)actionName params:(NSDictionary *)params shouldCacheTarget:(BOOL)shouldCacheTarget
{
    NSString *swiftModuleName = params[kCTMediatorParamsKeySwiftTargetModuleName];
    
    // generate target
    NSString *targetClassString = nil;
    if (swiftModuleName.length > 0) {
        targetClassString = [NSString stringWithFormat:@"%@.Target_%@", swiftModuleName, targetName];
    } else {
        targetClassString = [NSString stringWithFormat:@"Target_%@", targetName];
    }
    NSObject *target = self.cachedTarget[targetClassString];
    if (target == nil) {
        Class targetClass = NSClassFromString(targetClassString);
        target = [[targetClass alloc] init];
    }

    // generate action
    NSString *actionString = [NSString stringWithFormat:@"Action_%@:", actionName];
    SEL action = NSSelectorFromString(actionString);
    
    if (target == nil) {
        // 这里是处理无响应请求的地方之一，这个demo做得比较简单，如果没有可以响应的target，就直接return了。实际开发过程中是可以事先给一个固定的target专门用于在这个时候顶上，然后处理这种请求的
        [self NoTargetActionResponseWithTargetString:targetClassString selectorString:actionString originParams:params];
        return nil;
    }
    
    if (shouldCacheTarget) {
        self.cachedTarget[targetClassString] = target;
    }

    if ([target respondsToSelector:action]) {
        return [self safePerformAction:action target:target params:params];
    } else {
        // 这里是处理无响应请求的地方，如果无响应，则尝试调用对应target的notFound方法统一处理
        SEL action = NSSelectorFromString(@"notFound:");
        if ([target respondsToSelector:action]) {
            return [self safePerformAction:action target:target params:params];
        } else {
            // 这里也是处理无响应请求的地方，在notFound都没有的时候，这个demo是直接return了。实际开发过程中，可以用前面提到的固定的target顶上的。
            [self NoTargetActionResponseWithTargetString:targetClassString selectorString:actionString originParams:params];
            [self.cachedTarget removeObjectForKey:targetClassString];
            return nil;
        }
    }
}
```
这里可以看到这个方法是对消息转发的一个操作，创建了一个Target_ targetName的对象，执行这个对象中的一个Action_actionName的一个方法，并对无target的一个保护操作。

#####2）Target_HHYComponentA
这个文件就是上面消息转发中对应Target_ targetName的对象，里面有一个对应的Action_actionName执行方法。
```
- (UIViewController *)Action_HHYComponentA:(NSDictionary *)params {
    HHYComponentAViewController *VC = [[HHYComponentAViewController alloc] init];
    VC.user = params[@"user"];
    return VC;
}
```
这里返回就是我们创建的模块控制器，通过NSDictionary我们可以传递复杂的参数类型和方法的回调。

#####3）HHYComponentAViewController
这里面我没写什么，就打印了下传递的参数。

这样，我们的模块组件A就搭建完成了

#####4）HHYComponentA.podspec
这里我们要说一下spec文件，我写的时候被这个文件搞的头大。
因为我们的调度中心是放在我们的私有仓库的，模块A引用了私有仓库的文件，而我们的模块又是要放在我们的私有仓库，所以就形成了**私有仓库调用私有仓库**
因此，我们调用的私有仓库要在spec文件中声明，同时在终端验证的时候也要声明其来源。这个我们在上一篇文章中没有提及
另外项目的**目录层级**结构也要注意一下，下面就是我建的spec文件
```

Pod::Spec.new do |s|

  # 项目名称
  s.name         = "HHYComponentA"
  # 项目版本号
  s.version      = "0.0.7"
  # 项目摘要
  s.summary      = "HHYComponentA"
  # 详细描述
  s.description  = "HHYComponentA远程仓库"
  # 仓库主页地址
  s.homepage     = "https://github.com/HuiYouHua/HHYComponentA"

  # 证书
  s.license      = { :type => "MIT", :file => "LICENSE" }

  # 作者名称邮箱地址
  s.author             = { "华惠友" => "793316968@qq.com" }

  # 平台版本号
  s.platform     = :ios, "8.0"

  # git源码地址
  s.source       = { :git => "https://github.com/HuiYouHua/HHYComponentA.git", :tag => "#{s.version}" }

	s.source_files  = "HHYComponentA/HHYComponentA.h"

	s.subspec 'Controller' do |c|
	 	c.source_files = 'HHYComponentA/Controller/**/*.{h,m}'
		c.dependency "HHYComponentA/Model"
	end

	s.subspec 'Target' do |t|
		t.source_files = 'HHYComponentA/Target/**/*.{h,m}'
		t.dependency "HHYComponentA/Controller"
	end
		
	s.subspec 'CTMediaCategory' do |ct|
	  ct.source_files = "HHYComponentA/CTMediaCategory/**/*.{h,m}"
	  ct.dependency "HHYComponentA/Model"
		end

	s.subspec 'Model' do |m|
	  m.source_files = "HHYComponentA/Model/**/*.{h,m}"
		end
      
   s.public_header_files = "HHYComponentA/HHYComponentA.h"

   # 对私有仓库引用的依赖说明
   s.dependency 'HHYCTMediator', '~> 0.0.3'
   s.requires_arc     = true


end

```
这里面声明的文件就是后面我们**pod install**下来的文件，不需要传的文件就不需要声明了。

下面进行配置文件的验证及上传命令
- **pod lib lint --sources=私有spec索引地址,git spec索引地址  --allow-warnings  --use-libraries**
- **pod repo push 本地spec索引名称 上传的spec文件 --sources=私有spec索引地址,git spec索引地址 --allow-warnings  --use-libraries**
eg：
```
pod lib lint --sources=https://github.com/HuiYouHua/HHYSpecs.git,https://github.com/CocoaPods/Specs.git  --allow-warnings  --use-libraries

pod repo push HHYSpecs HHYComponentA.podspec --sources=https://github.com/HuiYouHua/HHYSpecs.git,https://github.com/CocoaPods/Specs.git --allow-warnings  --use-libraries
```

同样，其他的三个模块搭建方式基本差不多，我这里只是做了不同参数的处理。到了这里，我们就可以在我们主工程里调用搭建的三个模块了。

##三、主工程进行调用
模块A:
```
- (IBAction)componentA:(id)sender {
    HHYUser *user = [HHYUser new];
    user.name = @"huayoyu";
    user.age = 18;
    UIViewController *vc = [[CTMediator sharedInstance] HHYComponentA:user];
    [self.navigationController pushViewController:vc animated:YES];
}
```

模块B：
```
- (IBAction)componentB:(id)sender {
    NSArray *array = @[@"1", @"2", @"3", @"4"];
    UIViewController *vc = [[CTMediator sharedInstance] HHYComponentB:array WithCallback:^(NSArray * _Nonnull dataArray) {
        NSLog(@"%@",dataArray);
    }];
    [self.navigationController pushViewController:vc animated:YES];
}
```
模块C:
```
- (IBAction)componentC:(id)sender {
    UIViewController *vc = [[CTMediator sharedInstance] HHYComponentCWithCallback:^(NSString * _Nonnull result) {
        NSLog(@"%@", result);
    }];
    [self.navigationController pushViewController:vc animated:YES];
}
```
这样，组件化项目大体就搭建完成了。如果要对模块的增删，只需要对podfile文件进行操作，对入口的增删即可。

当然，这个只是简单的组件化项目的搭建，真正的项目当然还设计到其他很多东西，比如网络层、数据库、公共视图层、分类、第三方、AOP。。。，这个就需要更深一步的了解了。

项目git传送门：
> [主工程](https://github.com/HuiYouHua/HHYMainComponent)
[组件A](https://github.com/HuiYouHua/HHYComponentA)
[组件B](https://github.com/HuiYouHua/HHYComponentB)
[组件C](https://github.com/HuiYouHua/HHYComponentC)
>
>[组件调度中心](https://github.com/HuiYouHua/HHYCTMediator)
[私有索引仓库HHYSpecs](https://github.com/HuiYouHua/HHYSpecs)
>喜欢的点个赞👍哦



