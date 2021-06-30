//
//  MovieCell.m
//  Flix
//
//  Created by Sebastian Saldana Cardenas on 23/06/21.
//

#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"

@implementation MovieCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setMovie:(Movie *)movie {
    // Since we're replacing the default setter, we have to set the underlying private storage _movie ourselves.
    // _movie was an automatically declared variable with the @propery declaration.
    // You need to do this any time you create a custom setter.
    _movie = movie;

    self.titleLabel.text = self.movie.title;
    self.sinopsisLabel.text = self.movie.synopsis;
    
    

    NSURLRequest *requestSmall = [NSURLRequest requestWithURL:self.movie.lowResPosterUrl];
    NSURLRequest *requestLarge = [NSURLRequest requestWithURL:self.movie.hiResPosterUrl];
    
    self.posterView.image = nil;
    [self.posterView setImageWithURLRequest:requestSmall placeholderImage:nil
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *smallImage) {

            // smallImageResponse will be nil if the smallImage is already available
            // in cache (might want to do something smarter in that case).

            if(response){
                self.posterView.alpha = 0.0;
                self.posterView.image = smallImage;

                [UIView animateWithDuration:0.2
                            animations:^{

                                self.posterView.alpha = 1.0;

                            } completion:^(BOOL finished) {
                                // The AFNetworking ImageView Category only allows one request to be sent at a time
                                // per ImageView. This code must be in the completion block.
                                [self.posterView setImageWithURLRequest:requestLarge
                                                      placeholderImage:smallImage
                                                               success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage * largeImage) {
                                                                    self.posterView.image = largeImage;
                                                                }
                                                               failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                   // do something for the failure condition of the large image request
                                                                   // possibly setting the ImageView's image to a default image
                                                               }];
                            }];
            }
            else {
                self.posterView.image = smallImage;
            }
        }
       failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
           // do something for the failure condition
           // possibly try to get the large image
       }
    ];
}
@end
