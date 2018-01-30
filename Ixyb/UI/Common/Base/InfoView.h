//
//  InfoView.h
//  Ixyb
//
//  Created by dengjian on 11/20/15.
//  Copyright © 2015 xyb. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InfoView;

@protocol InfoViewDelegate <NSObject>

- (void)infoView:(InfoView *)infoView didSelectLinkWithURL:(NSURL *)url;

@end

@interface InfoView : UIView

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *info;

@property (nonatomic, weak) id<InfoViewDelegate> delegate;

@end
