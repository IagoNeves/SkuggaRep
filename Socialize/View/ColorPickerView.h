//
//  ColorPickerView.h
//  Socialize
//
//  Created by Iago Almeida Neves on 11/30/13.
//  Copyright (c) 2013 Iago Neves. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColorPickerView : UIView

// Angulo de posição do slider
@property (nonatomic,assign) NSInteger angle;

// Primeira cor de preenchimento do slider
@property (nonatomic,strong) UIColor *startColor;

// Segunda cor de preenchimento do slider
@property (nonatomic,strong) UIColor *endColor;

// Cor da bolinha do marcador de posição
@property (nonatomic,strong) UIColor *handleColor;

// Cor de fundo
@property (nonatomic,strong) UIColor *circleColor;

// Cor atual, de acordo com o ângulo
@property (nonatomic,strong) UIColor *currentColor;

// Color-defining index, same as in the GroupSettings
@property (strong, nonatomic) UIColor *groupColor;


@end
