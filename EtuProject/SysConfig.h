//
//  SysConfig.h
//  ZhiKu
//
//  Created by 王家兴 on 15/8/3.
//  Copyright (c) 2015年 王家兴. All rights reserved.
//

#define debug_mode
// #define test_mode
// #define release_mode

#ifdef debug_mode
	// 开发环境后台服务链接
  #define kBASE_URL @"http://test.etuchina.com/index.php?m=api"
#endif

#ifdef test_mode
	// 测试环境后台服务链接
  #define kBASE_URL @"http://test.etuchina.com/index.php?m=api"
#endif

#ifdef release_mode
	// 运营环境后台服务链接
  #define kBASE_URL @"http://www.zhikusport.com/index.php?m=api"
#endif

#define kRequestUrl(cmd,opt)\
[NSString stringWithFormat:@"%@&c=%@&a=%@",kBASE_URL,cmd,opt]

#define SHARE_CONTENT APP_DELEGATE.shareContent

//同时更换info.plist中的url
#define weixinKey @""

#define umengKey @""
