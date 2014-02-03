//
//  ContactsController.m
//  MyFirstApp
//
//  Created by Helder Lima da Rocha on 10/28/13.
//  Copyright (c) 2013 BEPiD. All rights reserved.
//

#import "ContactsTableViewController.h"
#import "ContactCell.h"
#import <QuartzCore/QuartzCore.h>


//make multipleselection or something
//round images
@interface ContactsTableViewController ()

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, strong) FacebookManager *facebookManager;

@property (weak, nonatomic) IBOutlet UISearchBar *contactsSearchBar;

@property (strong, nonatomic) NSMutableArray *filteredContacts;

@property (strong, nonatomic) NSMutableArray *friendList;

@property (strong, nonatomic) NSMutableArray *allContactsPhotosURLStringsSectioned;

@property (strong, nonatomic) NSMutableArray *allContactsNamesSectioned;

@property (strong, nonatomic) NSMutableArray *allContactsIDsSectioned;

@property (strong, nonatomic) NSMutableArray *arrayWithFirstLetters;

@property (strong, nonatomic) UIImage *placeholder;

//this is comment code

@property (strong, nonatomic) NSMutableArray *commentArray;

@property (strong, nonatomic) NSMutableArray *friendListWithoutAccentuation;

@property (nonatomic) BOOL isSearching;

@property (nonatomic) BOOL didEnterViewDidLoad;

@property (strong, nonatomic) NSOperationQueue *secondaryQueue;
@property (strong, nonatomic) NSMutableDictionary *photoCacheToRenderers;
@property (strong, nonatomic) NSMutableDictionary *photoCancellingToRenderingOperations;

@end

@implementation ContactsTableViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    // aqui é uma otimização que cancela todas as possíveis opereções de renderização das células
    // caso o usuário toque no botão de back antes de todas as operações se concluírem
    // isso poupa processamento desnecessário (melhora consumo de bateria)
    self.didEnterViewDidLoad = NO;
    
    [self.secondaryQueue cancelAllOperations];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //10 lines of stupid code for git test here!
    self.commentArray = [[NSMutableArray alloc]init];
    self.commentArray = [[NSMutableArray alloc]init];
    self.commentArray = [[NSMutableArray alloc]init];
    self.commentArray = [[NSMutableArray alloc]init];
    self.commentArray = [[NSMutableArray alloc]init];
    self.commentArray = [[NSMutableArray alloc]init];
    self.commentArray = [[NSMutableArray alloc]init];
    self.commentArray = [[NSMutableArray alloc]init];
    self.commentArray = [[NSMutableArray alloc]init];
    self.commentArray = [[NSMutableArray alloc]init];
    
    self.didEnterViewDidLoad = YES;
    
    //[self.contactsSearchBar setShowsScopeBar:NO];
    //[self.contactsSearchBar sizeToFit];
    
    self.allContactsNamesSectioned = [[NSMutableArray alloc]init];
    self.allContactsPhotosURLStringsSectioned = [[NSMutableArray alloc]init];
    self.allContactsIDsSectioned = [[NSMutableArray alloc]init];
    self.arrayWithFirstLetters = [[NSMutableArray alloc]init];
    
    self.secondaryQueue = [[NSOperationQueue alloc] init];
    self.photoCacheToRenderers = [[NSMutableDictionary alloc] init];
    self.photoCancellingToRenderingOperations = [[NSMutableDictionary alloc] init];
    
    self.friendList = [[NSMutableArray alloc]init];
    self.friendListWithoutAccentuation = [[NSMutableArray alloc]init];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.contactsSearchBar.delegate = self;
    self.tableView.allowsMultipleSelection = NO;
    self.placeholder = [UIImage imageNamed:@"placeholder.png"];
    
	// Do any additional setup after loading the view.
    self.facebookManager = [FacebookManagerStored sharedInstance];
    
    if (!self.facebookManager.friends)
    {
        [self.spinner startAnimating];
        
        [self.facebookManager fetchFriends:^
         {
             
             [self.spinner stopAnimating];
             [self getArrayWithFirstLetters];
             for (int i=0; i < [self.arrayWithFirstLetters count]; i++)
             {
                 self.allContactsNamesSectioned[i] = [[NSMutableArray alloc]init];
                 self.allContactsPhotosURLStringsSectioned[i] = [[NSMutableArray alloc]init];
                 self.allContactsIDsSectioned[i] = [[NSMutableArray alloc]init];
             }
             [self.tableView reloadData];
         }
         ];
    }
    
    
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getArrayWithFirstLetters];
    
    
    if (self.didEnterViewDidLoad)
    {
        for (int i=0; i < [self.arrayWithFirstLetters count]; i++)
        {
            self.allContactsNamesSectioned[i] = [[NSMutableArray alloc]init];
            self.allContactsPhotosURLStringsSectioned[i] = [[NSMutableArray alloc]init];
            self.allContactsIDsSectioned[i] = [[NSMutableArray alloc]init];
        }
    }
    
    //[self setSearchBarEnabled: self.didFinishLoadingData];
}

-(void) setSearchBarEnabled:(BOOL) toEnable
{
    self.contactsSearchBar.userInteractionEnabled = toEnable;
    if(toEnable) self.contactsSearchBar.alpha = 1;
    else self.contactsSearchBar.alpha = 0.25f;
}

#pragma mark - Alert Methods

//- (void)noFriendsSelectedAlert
//{
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Opa!" message:@"Nenhum amigo selecionado." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
//    [alertView show];
//}

#pragma mark - tableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (!self.isSearching)
    {
        return [self.arrayWithFirstLetters count];
    }
    else
    {
        return 1;
    }
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.isSearching)
    {
        NSString *letter = self.arrayWithFirstLetters[section];
        return [[self allNamesBeginningWithLetter:letter] count];
    }
    else
    {
        return [self.filteredContacts count];
    }
}

#pragma mark - tableViewDelegate

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //cache muito grande?
    //zoneamento (ultimo) com imagem do primeiro

    
    ContactCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactCell"];
    
    //code to make the image round
    //just change the UIImageView in storyboard to make it smaller
    CALayer *imageLayer = cell.contactPhoto.layer;
    [imageLayer setCornerRadius: cell.contactPhoto.frame.size.width/2];
    [imageLayer setBorderWidth:0];
    [imageLayer setMasksToBounds:YES];
    
    //here either put a placeholder or set the cell image to null
    [cell.contactPhoto setImage: self.placeholder];
    
    if (!self.isSearching)
    {
        NSURL *contactPhotoURL = [NSURL URLWithString: self.allContactsPhotosURLStringsSectioned[indexPath.section][indexPath.row]];
        NSString *contactName = self.allContactsNamesSectioned[indexPath.section][indexPath.row];
        NSString *contactID = self.allContactsIDsSectioned[indexPath.section][indexPath.row];
        cell.contactName.text = contactName;
        
        // Tenta recuperar o renderer desta célula no dicionário que está funcionando como um Cache de renderers
        NSURL *renderer = nil;
        UIImage *renderedContactPhoto = [self.photoCacheToRenderers objectForKey:contactID];
        
        // caso este renderer já tenha renderizado esta célula
        if (renderedContactPhoto)
        {
            // reaproveita a imagem já renderizada
            cell.contactPhoto.image = renderedContactPhoto;
        }
        // se ainda não temos renderer para esta Cell
        else
        {
            // criamos o rendered para esta Cell passando a stock
            renderer = contactPhotoURL;
            
            // operacao para ser executada fora da main queue
            NSBlockOperation *secondaryOperation = [NSBlockOperation blockOperationWithBlock:
            ^{
                // Aqui recuperamos a imagem do renderer, este processamento é pesado
                //esta havendo a situacao de contactPhotoData ser nil e contactPhotoURL nao ser nil
                //acho que se scrollar muito rapido nao da tempo de downloadar a imagem
                NSData *contactPhotoData = [NSData dataWithContentsOfURL:contactPhotoURL];
                //put here in the future a different placeholder: the standard facebook one
                UIImage *renderedContactPhoto = self.placeholder;
                if (contactPhotoData)
                {
                    renderedContactPhoto = [UIImage imageWithData:contactPhotoData];
                }
                // colocamos esse renderer no dicionário de cache
                [self.photoCacheToRenderers setObject:renderedContactPhoto forKey:contactID];
                
                // Novamente apos termos a imagem para fazer o update da User Interface (UI)
                // precisamos executar na Main Queue
                [[NSOperationQueue mainQueue] addOperationWithBlock:
                 ^{
                     //super important code to avoid placing several images in the same cell
                     //before the correct image is set
                     ContactCell *cell = (ContactCell *)[tableView cellForRowAtIndexPath:indexPath];

                     // atualiza a image da Cell com a imagem renderizada
                     cell.contactPhoto.image = renderedContactPhoto;
                 }];
            }];
            // adiciona a operacao na nossa fila para execução
            [self.secondaryQueue addOperation:secondaryOperation];
            
            // guarda esta operation em um dicionário para um possível cancelamento
            [self.photoCancellingToRenderingOperations setObject:secondaryOperation forKey:contactID];
            
            // antes que a célula seja renderizada de fato coloca uma imagem default de placeholder
            // com precessamento bem mais rápido
            //[[cell imageView] setImage: [renderer placeholderImageOfSize:ROW_IMAGE_SIZE]];
            
            cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
            [cell setNeedsLayout];
        }

        
//        else
//        {
//            // criamos o rendered para esta Cell passando a stock
//            renderer = contactPhotoURL;
//            
//            // colocamos esse renderer no dicionário de cache
//            [self.photoCacheToRenderers setObject:renderer forKey:contactID];
//            
//            // operacao para ser executada fora da main queue
//            NSBlockOperation *secondaryOperation = [NSBlockOperation blockOperationWithBlock:
//                                                    ^{
//                                                        // Aqui recuperamos a imagem do renderer, este processamento é pesado
//                                                        NSData *contactPhotoData = [NSData dataWithContentsOfURL:renderer];
//                                                        UIImage *renderedContactPhoto = [UIImage imageWithData:contactPhotoData];
//                                                        
//                                                        // Novamente apos termos a imagem para fazer o update da User Interface (UI)
//                                                        // precisamos executar na Main Queue
//                                                        [[NSOperationQueue mainQueue] addOperationWithBlock:
//                                                         ^{
//                                                             // atualiza a image da Cell com a imagem renderizada
//                                                             cell.contactPhoto.image = renderedContactPhoto;
//                                                         }];
//                                                    }];
//            // adiciona a operacao na nossa fila para execução
//            [self.secondaryQueue addOperation:secondaryOperation];
//            
//            // guarda esta operation em um dicionário para um possível cancelamento
//            [self.photoCancellingToRenderingOperations setObject:secondaryOperation forKey:contactID];
//            
//            // antes que a célula seja renderizada de fato coloca uma imagem default de placeholder
//            // com precessamento bem mais rápido
//            //[[cell imageView] setImage: [renderer placeholderImageOfSize:ROW_IMAGE_SIZE]];
//            
//            cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
//            [cell setNeedsLayout];
//        }
//        
//        
        
    }
    else
    {
        dispatch_queue_t downloadQueue = dispatch_queue_create("image downloader", NULL);
        dispatch_async(downloadQueue, ^{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.filteredContacts[indexPath.row][@"picture"][@"data"][@"url"]]];
            UIImage * image = [UIImage imageWithData:data];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.imageView.image = image;
                cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
                [cell setNeedsLayout];
            });
        });
        
        cell.textLabel.text = self.filteredContacts[indexPath.row][@"name"];
    }
    
//    if (self.isSelectingUsers)
//    {
//        cell.contactName.text = [NSString stringWithFormat:@"\u2714 %@",cell.contactName.text];
//    }
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Este metodo é executado para uma Cell caso ela tenha saído da área visível, em geral devido ao scroll do usuário
    // Aqui vamos otimizar e cancelar as operações que não fazem mais sentido executar
    
    // pegamos o nome da stock que representa esta célula
    NSString *contactID = self.allContactsIDsSectioned[indexPath.section][indexPath.row];
    
    // tentamos recuperar se a operação dela se encontra no nosso dicionário
    NSOperation *operation = [self.photoCancellingToRenderingOperations objectForKey:contactID];
    
    // caso exista
    if(operation)
    {
        // como esta Cell já saiu da tela não faz mais sentido realizar a operação de renderização dela
        // assim cancelamos a operação
        [operation cancel];
        
        // e removemos a operação do dicionário
        [self.photoCancellingToRenderingOperations removeObjectForKey:contactID];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(3_0);
{
    if(self.isSelectingUsers)
    {
        ContactCell *cell = (ContactCell*)[tableView cellForRowAtIndexPath:indexPath];
        if ([[cell.contactName.text substringToIndex:1] isEqualToString:@"\u2714"])
        {
            cell.contactName.text = [cell.contactName.text substringFromIndex:1];
        }
        else
        {
            cell.contactName.text = [NSString stringWithFormat:@"\u2714 %@",cell.contactName.text];
        }
        self.allContactsNamesSectioned[indexPath.section][indexPath.row] = cell.contactName.text;
        
        self.groupMember.isAnUpdateToCoordinateAvailable = true;
        if (!self.isSearching)
        {
            self.groupMember.name =  self.allContactsNamesSectioned[indexPath.section][indexPath.row];
            self.groupMember.photo =  self.allContactsPhotosURLStringsSectioned[indexPath.section][indexPath.row];
            self.groupMember.identificator = self.allContactsIDsSectioned[indexPath.section][indexPath.row];
        }
        if (self.isSearching)
        {
            self.groupMember.name = self.filteredContacts[indexPath.row][@"name"];
            self.groupMember.photo = self.filteredContacts[indexPath.row][@"picture"][@"data"][@"url"];
            self.groupMember.identificator = self.filteredContacts[indexPath.row][@"id"];
        }
        self.groupMember.groupsInWhichParticipates = [[NSMutableArray alloc] init];
        self.groupMember.lastUpdateDate = [NSDate date];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (![searchText isEqual:@""])
    {
        self.isSearching = YES;
    }
    else
    {
        self.isSearching = NO;
    }
    [self updateFilteredDataArray:searchText];
    
    [self.tableView reloadData];
    
}

-(void) updateFilteredDataArray:(NSString*) filterText {
    
    // NSMutableArray* validData = [[NSMutableArray alloc] init];
    //    [self.filteredToOriginalMap removeAllObjects];
    //    [self.originalToFilterdMap removeAllObjects];
    self.filteredContacts = [[NSMutableArray alloc]init];
    
    for(int i = 0; i < self.facebookManager.friends.count;i++)
    {
        NSDictionary* userData = self.facebookManager.friends[i];
        NSString* name = userData[@"name"];
        NSRange range = [name rangeOfString:filterText options:NSCaseInsensitiveSearch];
        if (filterText.length == 0 || range.length > 0)
        {
            //            [self.originalToFilterdMap addObject:[NSNumber numberWithInteger:self.filteredToOriginalMap.count]];
            //            [self.filteredToOriginalMap addObject:[NSNumber numberWithInteger:i]];
            [self.filteredContacts addObject:userData];
            
        }
        else
        {
            //  [self.originalToFilterdMap addObject:[NSNumber numberWithInteger:-1]];
        }
    }
    
    // self.filteredDataArray = validData;
}




//this method takes the first letter of every friend and puts them into an array
//for instance, if you have the friends "Aaron" and "Michael", this method
//returns an array with the letters "A" and "M"
- (void)getArrayWithFirstLetters
{
    NSMutableArray *arrayWithFirstLetters = [[NSMutableArray alloc] init];
    
    //this takes the friends from facebook ands puts them in 2 arrays
    //one with accentuation, the other without
    for (int i=0;i<[self.facebookManager.friends count];i++)
    {
        //little bit of code here in order to remove accentuation
        NSData *data = [self.facebookManager.friends[i][@"name"] dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *friendNameWithoutAccentuation = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        
        self.friendListWithoutAccentuation[i] = friendNameWithoutAccentuation;
        self.friendList[i] = self.facebookManager.friends[i][@"name"];
    }
    
    for (NSString *name in self.friendListWithoutAccentuation)
    {
        NSString *firstLetterInName = [name substringToIndex:1];
        BOOL found = NO;
        
        for (NSString *letter in arrayWithFirstLetters)
        {
            
            if ([letter isEqualToString:firstLetterInName])
            {
                found = YES;
            }
        }
        
        if (!found)
        {
            [arrayWithFirstLetters addObject:firstLetterInName];
        }
    }

    self.arrayWithFirstLetters = [NSMutableArray arrayWithArray:[arrayWithFirstLetters sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]];
}

     
//this method return all names that begin with a certain letter received as parameter
- (NSArray *)allNamesBeginningWithLetter:(NSString *)letter
{
    //the c and d within the brackets indicate case and diacritic insensitivity, respectively (diacritic refers to letters with accentuation)
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"description beginswith[cd] %@",  letter];
    NSArray *allNamesBeginningWithLetter;
    
    allNamesBeginningWithLetter = [self.friendList filteredArrayUsingPredicate:predicate];
    
    int indexOfLetter = [self.arrayWithFirstLetters indexOfObject: [NSString stringWithFormat:@"%@",letter]];
    
//    self.allContactsNamesSectioned[indexOfLetter] = [[NSMutableArray alloc]init];
//    self.allContactsPhotosURLsSectioned[indexOfLetter] = [[NSMutableArray alloc]init];
    
    int i=0;
    int numberOfPreviousContacts=0;
    for (int j=0; j < indexOfLetter; j++)
    {
        numberOfPreviousContacts += [self.allContactsNamesSectioned[j] count];
    }
    for (NSString *name in allNamesBeginningWithLetter)
    {
        self.allContactsNamesSectioned[indexOfLetter][i] = name;
        
        self.allContactsPhotosURLStringsSectioned[indexOfLetter][i] = self.facebookManager.friends[numberOfPreviousContacts + i][@"picture"][@"data"][@"url"];
        self.allContactsIDsSectioned[indexOfLetter][i] = self.facebookManager.friends[numberOfPreviousContacts + i][@"id"];
        i++;
    }
    if (indexOfLetter == [self.allContactsNamesSectioned count]-2)
    {
        //for (NSString *name in self.allContactsNamesSectioned[indexOfLetter])
        {
            self.allContactsPhotosURLStringsSectioned[indexOfLetter + 1][i] = self.facebookManager.friends[numberOfPreviousContacts + i][@"picture"][@"data"][@"url"];
            self.allContactsIDsSectioned[indexOfLetter + 1][i] = self.facebookManager.friends[numberOfPreviousContacts + i][@"id"];
        }
    }
    //i must still solve the problem that the first section is the last, which means z is the first letter
    //and therefore the contacts beginning with z get the images from the letter a
    return allNamesBeginningWithLetter;
}


//This method sets the array to be shown as the index, in the right border of the tableview
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (!self.isSearching)
    {
        return self.arrayWithFirstLetters;
    }
    else
    {
        return NULL;
    }
}

//This method returns the letter of an specific section of the arrayWithFirstLetters, such as the letter "M", for example
- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)section
{
    if (!self.isSearching)
    {
        return [self.arrayWithFirstLetters objectAtIndex:section];
    }
    else
    {
        return NULL;
    }
}
@end
