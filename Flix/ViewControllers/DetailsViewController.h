//
//  DetailsViewController.h
//  Flix
//
//  Created by Sebastian Saldana Cardenas on 23/06/21.
//

#import <UIKit/UIKit.h>
#include "Movie.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController

@property (nonatomic,strong) Movie *movie;

@end

NS_ASSUME_NONNULL_END
