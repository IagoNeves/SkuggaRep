//
//  MainMapViewController.m
//  Socialize
//
//  Created by Lucas Mageste on 10/21/13.
//  Copyright (c) 2013 Lucas Mageste. All rights reserved.
//

//por algum motivo o circulo esta vindo cinza se !self.isSpecificGroup e colorido (correto) se for SpecificGroup

#import "MainMapViewController.h"
#import "SocializeGroup.h"
#import "GroupInfoViewController.h"
#import <Parse/Parse.h>
#import "DAOParse.h"


#define METERS_PER_MILE 1609.344

@interface MainMapViewController () <DAOParseDelegate>

{
    NSUInteger radiusOfSearch;
    NSMutableArray* usersAlreadyDrawn;
}

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (nonatomic, strong) UIAlertView* alert;
@property (nonatomic, strong) FacebookManager *facebookManager;
@property (nonatomic, strong) UIColor* currentColor;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
- (IBAction)back:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *infoButton;
@property (weak, nonatomic) SocializeGroup* currentUserAnnotationGroup;

@property ( nonatomic) SocializeGroup *thisGroup;





@end

//pra fazer: gravar o zoom do mapa para quando o cara for para outra tela e voltar, o zoom continuar no mesmo lugar
//do jeito que esta, se view do tap bar eh ok, se vier do
//modal no GroupsViewController, entao nao grava o zoom- "Iago"

@implementation MainMapViewController

- (IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion: nil]; //isso volta para o ultimo view, pode ser modal
    //[self.navigationController popViewControllerAnimated:YES]; //nao funciona para modal, funciona automaticamente para push
}
- (void) updateMapAndZoomRegion: (bool) calledByViewDidAppear
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView removeOverlays:self.mapView.overlays];
    
    //raio da cena deve mudar pra poder abrigar todos caras do grupo na mesma cena e com o usuario no centro
    
    if(!calledByViewDidAppear) //por alguma condicao para que o zoom nao se altere toda vez q muda de pagina
    {
        radiusOfSearch=500;
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([Singleton singleton].userCoordinate, radiusOfSearch*3, radiusOfSearch*3);
        [self.mapView setRegion:region animated: YES];
    }
    
    [usersAlreadyDrawn removeAllObjects];
    
    if(!self.isSpecificMap)
    {
        for(SocializeGroup* everyGroup in [Singleton singleton].groupsToBeShowOnMap)
        {
            radiusOfSearch = everyGroup.groupWarningRadius;
            for(SocializeUser* everyUser in everyGroup.usersInTheGroup)
            {
                everyUser.mostPreciseDrawableGroup = everyGroup;
                bool drawIt=true;
                
                for(SocializeUser* everyUserAlreadyDrawn in usersAlreadyDrawn)
                {
                    if([everyUserAlreadyDrawn.identificator isEqualToString:everyUser.identificator])
                    {
                        drawIt=false;
                        break;
                    }
                }
                
                if(drawIt)
                {
                    if(everyUser.isAnUpdateToCoordinateAvailable==true)
                    {
                        //depois por aqui o codigo pra pegar uma nova coordenada
                        
                        everyUser.isAnUpdateToCoordinateAvailable=false;
                        
                        double latError = (double) (arc4random()%1000) / 10000;
                        double lonError = (double) (arc4random()%1000) / 10000;
                        
                        int isItNegativeForLatitude=0;
                        int isItNegativeForLongitude=0;
                        
                        while(isItNegativeForLatitude==0)
                        {
                            isItNegativeForLatitude = arc4random()%3-1;
                        }
                        
                        while(isItNegativeForLongitude==0)
                        {
                            isItNegativeForLongitude = arc4random()%3-1;
                        }
                        
                        [everyUser updateCoordinate:CLLocationCoordinate2DMake([Singleton singleton].userCoordinate.latitude + latError*isItNegativeForLatitude, [Singleton singleton].userCoordinate.longitude + lonError*isItNegativeForLongitude) andCoordinateDate:[NSDate date]];
                    }
                    
                    [self initializeAndDrawEachFriendInTheMap:everyUser];
                    [usersAlreadyDrawn addObject:everyUser];
                }
            }
        }
        
    }
    
    //if it's coming from the GroupsViewController
    else
    {
        //SocializeGroup* thisGroup = [[Singleton singleton].allGroups objectAtIndex:self.specificGroupArrayIndex];
        //SocializeGroupSpecific* thisGroupSpecific = [[Singleton singleton].allGroupsSpecific objectAtIndex:self.specificGroupArrayIndex];
        
        
        
        radiusOfSearch = self.thisGroup.groupWarningRadius;
        
        for(SocializeUser* everyUser in self.thisGroup.usersInTheGroup)
        {
            everyUser.mostPreciseDrawableGroup = self.thisGroup;
           // everyUser.mostPreciseDrawableGroupSpecific = thisGroupSpecific;
            
            bool drawIt=true;
            
            for(SocializeUser* everyUserAlreadyDrawn in usersAlreadyDrawn)
            {
                if([everyUserAlreadyDrawn.identificator isEqualToString:everyUser.identificator])
                {
                    drawIt=false;
                    break;
                }
            }
            
            if(drawIt)
            {
                if(everyUser.isAnUpdateToCoordinateAvailable==true)
                {
                    everyUser.isAnUpdateToCoordinateAvailable=false;
                    
                    double latError = (double) (arc4random()%1000) / 10000;
                    double lonError = (double) (arc4random()%1000) / 10000;
                    
                    int isItNegativeForLatitude=0;
                    int isItNegativeForLongitude=0;
                    
                    while(isItNegativeForLatitude==0)
                    {
                        isItNegativeForLatitude = arc4random()%3-1;
                    }
                    
                    while(isItNegativeForLongitude==0)
                    {
                        isItNegativeForLongitude = arc4random()%3-1;
                    }
                    
                    [everyUser updateCoordinate:CLLocationCoordinate2DMake([Singleton singleton].userCoordinate.latitude + latError*isItNegativeForLatitude, [Singleton singleton].userCoordinate.longitude + lonError*isItNegativeForLongitude) andCoordinateDate:[NSDate date]];
                }
                
                [self initializeAndDrawEachFriendInTheMap:everyUser];
                [usersAlreadyDrawn addObject:everyUser];
            }
        }
        
    }
    
}


-(void) mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    [Singleton singleton].userCoordinate = userLocation.location.coordinate;
    [self updateMapAndZoomRegion:false];
}

- (void) initializeAndDrawEachFriendInTheMap: (SocializeUser*) thisFriend //fromGroup: () depois que criar o grupo
{
    MainMapViewAnnotation* annotation = [[MainMapViewAnnotation alloc] initWithCorrespondingUser:thisFriend];
    
    if(MKMetersBetweenMapPoints(MKMapPointForCoordinate([Singleton singleton].userCoordinate), MKMapPointForCoordinate(annotation.correspondingUser.coordinate)) < radiusOfSearch)
    {
        if(annotation.inRange == false)
        {
            //alterar pra ter um cancel
            NSString* messageToBeShown = [NSString stringWithFormat:@"Press OK to see the location of %@", annotation.correspondingUser.name];
            self.alert = [[UIAlertView alloc] initWithTitle: @"A friend is close to you!"
                                                    message: messageToBeShown
                                                   delegate: self
                                          cancelButtonTitle: @"Cancel"
                                          otherButtonTitles: @"OK", nil];
            [self.alert show];
        }
        annotation.inRange=true;
    }
    else
        annotation.inRange=false;
    
    [self.mapView addAnnotation:annotation];
    
    return;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString *identifier = @"MyLocation";
    
    if ([annotation isKindOfClass:[MainMapViewAnnotation class]]) {
        
        MKAnnotationView *annotationView = (MKAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil)
        {
            //annotation making
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            
        }
        //setting properties
        
        //circle making
        MainMapViewAnnotation* currentAnnotation = annotation;
        
        MKCircle *currentAnnotationCircleOfPrecision = [MKCircle circleWithCenterCoordinate:currentAnnotation.correspondingUser.coordinate radius: currentAnnotation.correspondingUser.mostPreciseDrawableGroup.groupPrecisionRadius];
        currentAnnotationCircleOfPrecision.title = currentAnnotation.correspondingUser.mostPreciseDrawableGroup.groupName;
        
        self.currentColor = currentAnnotation.correspondingUser.mostPreciseDrawableGroupSpecific.groupColor;
        [self.mapView addOverlay:currentAnnotationCircleOfPrecision];
        
        //marker making
        if(currentAnnotation.inRange==false)//caso esteja em range a bolinha pisca, sei la
            annotationView.image = [UIImage imageNamed:@"circle-grey.png"];//muda conforme o grupo
        else
            annotationView.image = [UIImage imageNamed:@"circle-grey.png"];//muda conforme o grupo
        
        annotationView.image = [CustomUIImage changeIcon: (UIImage*) annotationView.image toColor: (UIColor*) currentAnnotation.correspondingUser.mostPreciseDrawableGroupSpecific.groupColor];
        
        NSURL * imageURL = [NSURL URLWithString: currentAnnotation.correspondingUser.photo];
        NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
        UIImage * image = [UIImage imageWithData:imageData];
        
        UIImageView* friendPhoto = [[UIImageView alloc] initWithImage: image];
        [friendPhoto setFrame:CGRectMake(0, 0, 30, 30)];
        
        annotationView.leftCalloutAccessoryView = friendPhoto;
        
        return annotationView;
    }
    
    return nil;
}

-(MKOverlayRenderer*)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKCircle class]])
    {
        MKCircleRenderer *circleRenderer = [[MKCircleRenderer alloc] initWithCircle:overlay];
        
        //fazer um for que checa o nome de todos os grupos e desenha de acordo. Ideia: uma apropriedade do grupo pode ser a cor que o representa pra ficar mais fácil.
        
        if([overlay.title isEqualToString:@"User"])
        {
            UIColor* whichColor = [[UIColor alloc ] initWithRed:0.5 green: 1 blue: 1 alpha: 0.3];
            circleRenderer.fillColor = whichColor;
        }
        
        else
        {
            circleRenderer.fillColor = [self.currentColor colorWithAlphaComponent:0.3];
        }
        
        circleRenderer.lineWidth = 5;  // <-- controls thickness of ring
        circleRenderer.strokeColor = [circleRenderer.fillColor colorWithAlphaComponent:0.6];
        return circleRenderer;
    }
    return nil;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.delegate = self;
    self.mapView.showsUserLocation=YES;
    self.goToGroupView = NO;
    
    self.facebookManager = [FacebookManagerStored sharedInstance];
    //[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(performLogin) userInfo:nil repeats:NO];
    
    usersAlreadyDrawn = [NSMutableArray array];
    
    if (self.isSpecificMap)
    {
        DAOParse *daoParse;
        daoParse = [[DAOParse alloc]init];
        daoParse.delegate = self;
        //[daoParse fetchGroupWithName:self.groupName];
    }
   
}

-(void)hasCompletedGroupDataFetch:(SocializeGroup *)group
{
    self.thisGroup = group;
}

- (void)viewWillAppear:(BOOL)animated
{
    if(self.goToGroupView){
        self.goToGroupView = NO;
        
        [self dismissViewControllerAnimated:NO completion:Nil];
        
    }else{
        if(self.mapView.region.span.longitudeDelta>1 && self.mapView.region.span.latitudeDelta>1)
            [self updateMapAndZoomRegion:false];
        else
            [self updateMapAndZoomRegion:true];
        
        if (self.isSpecificMap==YES)
        {
            self.navigationItem.title=[NSString stringWithFormat: @"%@", self.thisGroup.groupName];
            //[self.navigationItem setHidesBackButton:NO animated:YES];
            UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
            self.navigationItem.leftBarButtonItem = backButton;
        }
        else
        {
            self.navigationItem.leftBarButtonItem = nil;
            //[self.navigationItem setHidesBackButton:YES animated:YES];
            self.navigationItem.title=@"Main Map";
        }
    }
}


// Received memory warning
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)info:(id)sender
{
    if(!self.isSpecificMap)
        [self performSegueWithIdentifier:@"MainMapinfoViewControllerSegue" sender:self];
    else
        [self performSegueWithIdentifier:@"GroupInfoViewControllerSegue" sender:self];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //implementar diferença de comportamento entre o botão cancel e OK
    
    //[self dismissViewControllerAnimated:YES completion: nil];
}

@end