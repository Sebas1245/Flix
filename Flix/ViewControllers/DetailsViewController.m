//
//  DetailsViewController.m
//  Flix
//
//  Created by Sebastian Saldana Cardenas on 23/06/21.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TrailerViewController.h"
@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backdropView;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;


@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    
//    [self.posterView setImageWithURL:self.movie.hiResPosterUrl];
    [self requestPosters];

    
    [self.backdropView setImageWithURL:self.movie.backdropURL];

    self.titleLabel.text = self.movie.title;
    self.synopsisLabel.text = self.movie.synopsis;
    self.dateLabel.text = self.movie.releaseDate;

    [self.titleLabel sizeToFit];
    [self.synopsisLabel sizeToFit];
    [self.dateLabel sizeToFit];
    
}
- (IBAction)triggerModalView:(UITapGestureRecognizer *)sender {
    
    [self performSegueWithIdentifier:@"TrailerViewSegue" sender:nil];
    
}



-(void)requestPosters {
    NSURLRequest *requestSmall = [NSURLRequest requestWithURL:self.movie.lowResPosterUrl];
    NSURLRequest *requestLarge = [NSURLRequest requestWithURL:self.movie.hiResPosterUrl];
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
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    TrailerViewController *trailerViewController = [segue destinationViewController];
    trailerViewController.movieId = self.movie.movieId;
}


@end
