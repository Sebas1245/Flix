//
//  MovieViewController.m
//  Flix
//
//  Created by Sebastian Saldana Cardenas on 23/06/21.
//

#import "MovieViewController.h"
#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"

@interface MovieViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *movies;
@property (strong, nonatomic) NSArray *filteredMovies;
@property(nonatomic,strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;


@end

@implementation MovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.searchBar.delegate = self;
    
    [self fetchMovies];
    
    
    self.refreshControl = [[UIRefreshControl alloc] init]; // initialize refresh control
    [self.refreshControl addTarget:self action:@selector(fetchMovies) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl]; // place refresh control into table view
}

-(void)fetchMovies {
    [self.activityIndicator startAnimating];

    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
               [self showAlert];
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               
               self.movies = dataDictionary[@"results"];
               self.filteredMovies = self.movies;

               [self.tableView reloadData];
               

               // TODO: Get the array of movies
               // TODO: Store the movies in a property to use elsewhere
               // TODO: Reload your table view data
           }
        [self.refreshControl endRefreshing];
        [self.activityIndicator stopAnimating];
       }];
    [task resume];
}

// functions that returns how many rows we want in a table view
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredMovies.count;
}

// returns what we want inside of each table section, the amount of sections is defined in the previous function
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    
    NSDictionary *movie = self.filteredMovies[indexPath.row];
    cell.titleLabel.text = movie[@"title"];
    cell.sinopsisLabel.text = movie[@"overview"];
    
    
    NSString *lowResURLString = @"https://image.tmdb.org/t/p/w45";
    NSString *highResURLString = @"https://image.tmdb.org/t/p/original";
    NSString *posterURLString = movie[@"poster_path"];
    
    NSString *fullLowResPosterURLString = [lowResURLString stringByAppendingString:posterURLString];
    NSString *fullHighResPosterURLString = [highResURLString stringByAppendingString:posterURLString];

    
    NSURL *urlSmall = [NSURL URLWithString:fullLowResPosterURLString];
    NSURL *urlLarge = [NSURL URLWithString:fullHighResPosterURLString];

    NSURLRequest *requestSmall = [NSURLRequest requestWithURL:urlSmall];
    NSURLRequest *requestLarge = [NSURLRequest requestWithURL:urlLarge];
    
    cell.posterView.image = nil;
    [cell.posterView setImageWithURLRequest:requestSmall
                          placeholderImage:nil
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *smallImage) {

                                        // smallImageResponse will be nil if the smallImage is already available
                                        // in cache (might want to do something smarter in that case).

                                        if(response){
                                            cell.posterView.alpha = 0.0;
                                            cell.posterView.image = smallImage;

                                            [UIView animateWithDuration:0.2
                                                        animations:^{

                                                            cell.posterView.alpha = 1.0;

                                                        } completion:^(BOOL finished) {
                                                            // The AFNetworking ImageView Category only allows one request to be sent at a time
                                                            // per ImageView. This code must be in the completion block.
                                                            [cell.posterView setImageWithURLRequest:requestLarge
                                                                                  placeholderImage:smallImage
                                                                                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage * largeImage) {
                                                                                                cell.posterView.image = largeImage;
                                                                                            }
                                                                                           failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                               // do something for the failure condition of the large image request
                                                                                               // possibly setting the ImageView's image to a default image
                                                                                           }];
                                                        }];
                                        }
                                        else {
                                            cell.posterView.image = smallImage;
                                        }
                                    }
                                   failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                       // do something for the failure condition
                                       // possibly try to get the large image
                                   }
                                   ];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)showAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cannot Get Movies"
                                                                               message:@"The internet connection appears to be offline."
                                                                        preferredStyle:(UIAlertControllerStyleAlert)];

    // create an OK action
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Try again"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                             // handle response here.
                                                            [self fetchMovies];
                                                     }];
    // add the OK action to the alert controller
    [alert addAction:okAction];
    // present the alert
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (searchText.length != 0) {
        
//        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *evaluatedObject, NSDictionary *bindings) {
//            return [evaluatedObject[@"original_title"] containsString:searchText];
//        }];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(title CONTAINS[cd] %@)", searchText]; // RESEARCH HOW THIS WORKS
        
        self.filteredMovies = [self.movies filteredArrayUsingPredicate:predicate];
                        
    }
    else {
        self.filteredMovies = self.movies;
        // make keyboard dissapear
        [self.view endEditing:true];
    }
    
    [self.tableView reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = NO;
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UITableViewCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
    NSDictionary *movie = self.filteredMovies[indexPath.row];
    
    DetailsViewController *detailViewController = [segue destinationViewController];
    detailViewController.movie = movie;
}

@end
