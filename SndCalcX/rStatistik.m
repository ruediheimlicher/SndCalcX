#import "rStatistik.h"

/*
 Definiert in StatistikDS
 
 @implementation rGrafikCell
 - (id)init
 {
 self=[super init];
 
 return self;
 }
 
 - (void)setRahmen:(NSRect)derRahmen
 {
 GrafikRahmen=derRahmen;
 b=GrafikRahmen.size.width;
 h=GrafikRahmen.size.height;
 
 }
 
 - (NSRect)GrafikRahmen
 {
 return GrafikRahmen;
 }
 - (void)setGrafikDaten:(NSDictionary*)derGrafikDic
 {
 //NSLog(@"setGrafikDaten: %@",[derGrafikDic description]);
 art=[[derGrafikDic objectForKey:@"art"]intValue];
 anzAufgaben=[[derGrafikDic objectForKey:@"anzaufgaben"]intValue];
 anzRichtig=[[derGrafikDic objectForKey:@"anzrichtig"]intValue];
 anzFehler=[[derGrafikDic objectForKey:@"anzfehler"]intValue];
 zeit=[[derGrafikDic objectForKey:@"zeit"]intValue];
 maxzeit=[[derGrafikDic objectForKey:@"maxzeit"]intValue];
 }
 
 - (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
 {
	//NSLog(@"controlView: %@",[controlView description]);
	//NSLog(@"drawInteriorWithFrame GrafikRahmen: %f  %f",GrafikRahmen.size.height,GrafikRahmen.size.width);
	float Anzeigebreite=0.0;
	float Raster=0;
	GrafikRahmen=cellFrame;
	GrafikRahmen.origin.x+=2.5;
	GrafikRahmen.origin.y+=2.5;
	GrafikRahmen.size.height-=5.0;
	GrafikRahmen.size.width-=5.0;
	
	if (anzAufgaben==anzRichtig)//alle Aufgaben gelöst
	{
 Raster=(cellFrame.size.width)/ maxzeit;
 //NSLog(@"Breite: %f maxzeit: %d Raster: %d",cellFrame.size.width,maxzeit,Raster);
 Anzeigebreite=Raster*zeit;
 Anzeigebalken=GrafikRahmen;
 Anzeigebalken.size.width=Anzeigebreite;
 [[NSColor greenColor]set];
 [NSBezierPath fillRect:Anzeigebalken];
 [[NSColor lightGrayColor]set];
 [NSBezierPath strokeRect:GrafikRahmen];
 
	}
	else
	{
 Raster=(GrafikRahmen.size.width+1.0)/ anzAufgaben;
 //Balkenbreite=Raster*anzRichtig;
 NSRect Feld=GrafikRahmen;
 //NSLog(@"Breite: %f anzAufgaben: %d Raster: %d Feld.origin.x: %f",cellFrame.size.width,anzAufgaben,Raster,Feld.origin.x);
 
 //Feld.origin.x+=0.5;
 Feld.size.width=Raster-2.0;//Feld fuer eine Aufgabe
 int i;
 float originx=Feld.origin.x;
 for (i=0;i<anzAufgaben;i++)
 {
 Feld.origin.x=originx+i*Raster;
 //NSLog(@"i: %d origin.x: %f Feld.origin.y: %f",i,Feld.origin.x,Feld.origin.y);
 if (i<anzRichtig)
 {
 [[NSColor cyanColor]set];
 [NSBezierPath fillRect:Feld];
 }
 //else
 {
 NSBezierPath* bp=[NSBezierPath bezierPathWithRect:Feld];
 [[NSColor blackColor] set];
 [bp setLineWidth:0.5];
 [bp stroke];
 }
 //Feld.origin.x+=(Raster);
 }//for i
 
	}
 }
 
 @end
 */

@implementation rStatistikTable
- (id)initWithFrame:(NSRect)frame
{
   self=[super initWithFrame:frame];
   
   return self;
}

- (void)adjustPageHeightNew:(float *)newBottom top:(float)top bottom:(float)proposedBottom limit:(float)bottomLimit
{
   
   int	 cutoffRow = [self rowAtPoint:NSMakePoint(0, proposedBottom-100)];
   int zhh=	[self rectOfRow:0].size.height;
   NSLog(@"cutoffRow: %d	zhh: %d 	zh: %1.2f		z: %d	h: %d",cutoffRow,zhh,[self rowHeight],[self numberOfRows],[self numberOfRows]*(zhh));
   NSRect	 rowBounds;
   
   if (cutoffRow != -1)
   {
      rowBounds = [self rectOfRow:cutoffRow];
      NSLog(@"rowBounds	x: %1.3f		y: %1.3f		W: %1.3f	h: %1.3f",rowBounds.origin.x,rowBounds.origin.y, rowBounds.size.width,rowBounds.size.height);
      
      if (proposedBottom < NSMaxY(rowBounds))
      {
         *newBottom = NSMinY(rowBounds);
      }
      else
      {
         *newBottom = proposedBottom;
      }
   }
   else
   {
      *newBottom = proposedBottom;
   }
}

@end


@implementation rFehlerCell

- (id)init
{
   self=[super init];
   farbig=YES;
   return self;
}

- (void)setGrafikDaten:(NSDictionary*)derGrafikDic
{
   //NSLog(@"FehlerCell				setGrafikDaten: %@",[derGrafikDic objectForKey:@"allezeigen"]);
   //NSLog(@"FehlerCell				setGrafikDaten farbig: %@",[derGrafikDic objectForKey:@"farbig"]);
   art=[[derGrafikDic objectForKey:@"art"]intValue];
   anzAufgaben=[[derGrafikDic objectForKey:@"anzaufgaben"]intValue];
   anzRichtig=[[derGrafikDic objectForKey:@"anzrichtig"]intValue];
   anzFehler=[[derGrafikDic objectForKey:@"anzfehler"]intValue];
   zeit=[[derGrafikDic objectForKey:@"zeit"]intValue];
   maxzeit=[[derGrafikDic objectForKey:@"maxzeit"]intValue];
   if ([derGrafikDic objectForKey:@"allezeigen"])
   {
      AlleZeigen=[[derGrafikDic objectForKey:@"allezeigen"]boolValue];
   }
   else
   {
      AlleZeigen=NO;
   }
   if ([derGrafikDic objectForKey:@"farbig"])
   {
      farbig=[[derGrafikDic objectForKey:@"farbig"]boolValue];
   }
   else
   {
      farbig=YES;
   }
   FehlerBild=[NSImage imageNamed:@"FehlerImg"];
}

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
   //NSLog(@"controlView: %@",[controlView description]);
   //NSLog(@"FehlerCell drawInteriorWithFrame Fehler: %d",anzFehler);
   int Raster=0;
   GrafikRahmen=cellFrame;
   //GrafikRahmen.origin.x+=2;
   //GrafikRahmen.origin.y+=2;
   //GrafikRahmen.size.height-=4;
   //GrafikRahmen.size.width-=4;
   
   if (anzFehler)//Es hat Fehler
   {
      if (AlleZeigen)
      {
         Raster=4;
         //NSLog(@"Breite: %f anzFehler: %f Raster: %f",cellFrame.size.width,anzFehler,Raster);
         NSRect Feld=cellFrame;
         Feld.size.width=2;//Feld fuer einen Fehler
         Feld.size.height-=4;
         Feld.origin.y+=2;
         int i;
         for (i=0;i<anzFehler;i++)
         {
            if (farbig)
            {
               [[NSColor redColor]set];
            }
            else
            {
               [[NSColor grayColor]set];
            }
            
            
            //[NSBezierPath strokeRect:Feld];
            //				[[NSBezierPath bezierPathWithOvalInRect:Feld]stroke];
            //				[[NSBezierPath bezierPathWithOvalInRect:Feld]fill];
            [NSBezierPath fillRect:Feld];
            Feld.origin.x+=Raster;
         }//for i
         
      }
      else
      {
         //Raster=(cellFrame.size.width)/ anzFehler;
         Raster=6;
         //NSLog(@"Breite: %f anzFehler: %f Raster: %f",cellFrame.size.width,anzFehler,Raster);
         NSRect Feld=cellFrame;
         Feld.size.width=4;//Feld fuer einen Fehler
         Feld.size.height=4;
         Feld.origin.y+=cellFrame.size.height/2-2;
         Feld.origin.x+=Raster/2;
         if (farbig)
         {
            [[NSColor redColor]set];
         }
         else
         {
            [[NSColor grayColor]set];
         }
         
         int i;
         for (i=0;i<anzFehler;i++)
         {
            
            
            //[NSBezierPath strokeRect:Feld];
            [[NSBezierPath bezierPathWithOvalInRect:Feld]stroke];
            [[NSBezierPath bezierPathWithOvalInRect:Feld]fill];
            //[NSBezierPath fillRect:Feld];
            Feld.origin.x+=Raster;
         }//for i
      }
      
   }
}

@end


float Datumbreite=50.0;
float Namebreite=90.0;
float Zeitbreite=24.0;
float Grafikbreite=160.0;
float AnzFehlerbreite=20.0;
float Fehlerbreite=100.0;
float Mittelbreite=32.0;
float Notebreite=28.0;



@implementation rDruckView

- (id)initWithFrame:(NSRect) frame
{
   self=[super initWithFrame:frame];
   TabDic=[[NSDictionary alloc]init];
   NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
   [nc addObserver:self
          selector:@selector(drawTabelleAktion:)
              name:@"drawTabelle"
            object:nil];
   farbig=YES;
   
   return self;
}


- (void)drawTabelleAktion:(NSNotification*)note
{
   //NSLog(@"drawTabelleAktion: %@",[[note userInfo] description]);
   
   if ([note userInfo])
   {
      TabArray=[[note userInfo]objectForKey:@"tabarray"];
      SeitenArray=[[note userInfo]objectForKey:@"seitenarray"];
      
   }
}

- (void)setTabelleMitDic:(NSDictionary*)derTabDic mitFeld:(NSRect)dasFeld
{
   //NSLog(@"DruckView setTabelleMitDic");
   
   TabellenFeld=[self bounds];
   
   TabDic=derTabDic;
}

- (void)drawTabelle
{
   NSFontManager *fontManager = [NSFontManager sharedFontManager];
   
   NSFont* TabellenKopfFont=[NSFont fontWithName:@"Helvetica" size: 8];
   [NSBezierPath setDefaultLineWidth:1.0];
   [[NSColor grayColor]set];
   TabellenFeld.origin.x+=0.2;
   TabellenFeld.origin.y+=[[TabDic objectForKey:@"tabellenoffset1"]floatValue]+0.2;
   TabellenFeld.size.height-=[[TabDic objectForKey:@"tabellenoffset1"]floatValue];
   int AnzahlZeilen=[[TabDic objectForKey:@"anzahlzeilen"]intValue];
   int Zeilenhoehe=[[TabDic objectForKey:@"zeilenhoehe"]intValue];
   TabellenFeld.size.height=(AnzahlZeilen+1)*(Zeilenhoehe+2.0)+8.0;
   //	[NSBezierPath strokeRect:TabellenFeld];
   //[NSBezierPath strokeRect:[self bounds]];
   
   float Feldhoehe=TabellenFeld.size.height;
   float Feldbreite=TabellenFeld.size.width;
   float AbstandLinks=TabellenFeld.origin.x;
   float AbstandOben=TabellenFeld.origin.y;
   
   NSPoint l=TabellenFeld.origin;
   NSPoint r=TabellenFeld.origin;
   r.x+=Feldbreite;
   r.y+=Zeilenhoehe+2;
   l.y+=Zeilenhoehe+2;
   
   NSPoint o=TabellenFeld.origin;
   NSPoint u=TabellenFeld.origin;
   
   
   //NSLog(@"drawTabelle: TabArray: %@",[TabArray description]);
   //NSLog(@"drawTabelle: SeitenArray: %@",[SeitenArray description]);
   
   int i,k;
   
   for (i=0;i<[SeitenArray count];i++)//SeitenArray
   {
      if (i%2==0)// senkrechte Linien
      {
         NSPoint oben=NSMakePoint(TabellenFeld.origin.x,[[SeitenArray objectAtIndex:i]floatValue]);
         NSPoint links=oben;
         NSPoint rechts=oben;
         rechts.x+=TabellenFeld.size.width;
         [NSBezierPath strokeLineFromPoint:links toPoint:rechts];
         NSPoint Kopf=NSMakePoint(TabellenFeld.origin.x,[[SeitenArray objectAtIndex:i+1]floatValue]);
         NSPoint unten=NSMakePoint(TabellenFeld.origin.x,[[SeitenArray objectAtIndex:i+1]floatValue]);
         rechts.y=unten.y;
         links.y=unten.y;
         [NSBezierPath strokeLineFromPoint:oben toPoint:unten];
         
         oben.x+=Datumbreite;
         unten.x+=Datumbreite;
         [NSBezierPath strokeLineFromPoint:oben toPoint:unten];
         
         oben.x+=Namebreite;
         unten.x+=Namebreite;
         [NSBezierPath strokeLineFromPoint:oben toPoint:unten];
         
         oben.x+=Zeitbreite;
         unten.x+=Zeitbreite;
         [NSBezierPath strokeLineFromPoint:oben toPoint:unten];
         
         oben.x+=Grafikbreite;
         unten.x+=Grafikbreite;
         [NSBezierPath strokeLineFromPoint:oben toPoint:unten];
         
         oben.x+=Mittelbreite;
         unten.x+=Mittelbreite;
         [NSBezierPath strokeLineFromPoint:oben toPoint:unten];
         
         oben.x+=Fehlerbreite;
         unten.x+=Fehlerbreite;
         [NSBezierPath strokeLineFromPoint:oben toPoint:unten];
         
         oben.x+=Notebreite;
         unten.x+=Notebreite;
         [NSBezierPath strokeLineFromPoint:oben toPoint:unten];
         
      }//gerade
   }
   
   for (i=0;i<[TabArray count];i++)//SeitenArray
   {
      NSPoint links=NSMakePoint(TabellenFeld.origin.x,[[TabArray objectAtIndex:i]floatValue]);
      NSPoint rechts=links;
      rechts.x+=TabellenFeld.size.width;
      [NSBezierPath strokeLineFromPoint:links toPoint:rechts];
   }
   
   
}


- (void)drawRect:(NSRect) aRect
{
   //	NSLog(@"DruckView drawRect");
   
   [super drawRect:aRect];
   [self drawTabelle];
   
}

@end


@implementation rGrafikView
- (id)init
{
   self=[super init];
   farbig=YES;
   NSLog(@"GrafikView init farbig: %d",farbig);
   return self;
}

- (void)setGrafikDaten:(NSDictionary*)derGrafikDic
{
   //	NSLog(@"StatistikView setGrafikDaten: %@", [derGrafikDic objectForKey:@"farbig"]);
   art=[[derGrafikDic objectForKey:@"art"]intValue];
   anzAufgaben=[[derGrafikDic objectForKey:@"anzaufgaben"]intValue];
   anzRichtig=[[derGrafikDic objectForKey:@"anzrichtig"]intValue];
   anzFehler=[[derGrafikDic objectForKey:@"anzfehler"]intValue];
   zeit=[[derGrafikDic objectForKey:@"zeit"]intValue];
   maxzeit=[[derGrafikDic objectForKey:@"maxzeit"]intValue];
   if ([derGrafikDic objectForKey:@"grafiktext"])
   {
      GrafikTextString=[derGrafikDic objectForKey:@"grafiktext"];
   }
   else
   {
      GrafikTextString=@"";
   }
   if ([derGrafikDic objectForKey:@"farbig"])
   {
      farbig=[[derGrafikDic objectForKey:@"farbig"]boolValue];
   }
   else
   {
      farbig=YES;
   }
   
   //	NSLog(@"setGrafikDaten: GrafikTextString: %@",GrafikTextString);
   
   //NSLog(@"setGrafikDaten farbig: %d",farbig);
}

- (void)drawRect:(NSRect)dasFeld
{
   //NSLog(@"controlView: %@",[controlView description]);
   //NSLog(@"drawRect GrafikRahmen: %f  %f",dasFeld.size.height,dasFeld.size.width);
   float Anzeigebreite=0.0;
   float Raster=0;
   GrafikRahmen=dasFeld;
   //int anzFehler=[[derZeilenDic objectForKey:@"anzfehler"]intValue];
   switch (art)
   {
      case 4://TestNamen
      {
         //	NSLog(@"GrafikView    drawRect: Grafiktext: %@",GrafikTextString);
         NSDictionary* Attr=[NSDictionary dictionaryWithObjectsAndKeys:[NSColor blackColor], NSForegroundColorAttributeName,[NSFont systemFontOfSize:10], NSFontAttributeName,nil];
         [GrafikTextString drawInRect:dasFeld withAttributes:Attr];
      }break;
         
      case 1://Datenzeile
      case 2://Datenzeile
         
      {
         GrafikRahmen.origin.x+=8.5;
         GrafikRahmen.origin.y+=2.5;
         GrafikRahmen.size.height-=4.0;
         GrafikRahmen.size.width-=16.0;
         
         //NSLog(@"drawRect:	anzAufgaben: %d",anzAufgaben);
         if (anzAufgaben==0)
         {
            return;
         }
         if (anzAufgaben==anzRichtig)//alle Aufgaben gelöst
         {
            
            NSString* s=@"Grafik";
            
            if (farbig)
            {
               NSDictionary* Attr=[NSDictionary dictionaryWithObjectsAndKeys:[NSColor redColor], NSForegroundColorAttributeName,[NSFont systemFontOfSize:10], NSFontAttributeName,nil];
               
            }
            else
            {
               NSDictionary* Attr=[NSDictionary dictionaryWithObjectsAndKeys:[NSColor grayColor], NSForegroundColorAttributeName,[NSFont systemFontOfSize:10], NSFontAttributeName,nil];
               
            }
            
            
            
            
            //[s drawInRect:cellFrame withAttributes:Attr];
            //return;
            
            Raster=(GrafikRahmen.size.width)/ maxzeit;
            //NSLog(@"Breite: %f maxzeit: %d Raster: %d",cellFrame.size.width,maxzeit,Raster);
            Anzeigebreite=Raster*zeit;
            Anzeigebalken=GrafikRahmen;
            Anzeigebalken.size.width=Anzeigebreite;
            //NSLog(@"drawRect farbig: %d",farbig);
            if (farbig)
            {
               [[NSColor greenColor]set];
            }
            else
            {
               [[NSColor lightGrayColor]set];
            }
            
            
            [NSBezierPath fillRect:Anzeigebalken];
            [[NSColor grayColor]set];
            
            NSBezierPath* bp=[NSBezierPath bezierPathWithRect:GrafikRahmen];
            [[NSColor grayColor] set];
            [bp setLineWidth:0.5];
            [bp stroke];
            
            
            //			[NSBezierPath strokeRect:GrafikRahmen];
            
         }
         else
         {
            Raster=(GrafikRahmen.size.width+1.0)/ anzAufgaben;
            //Balkenbreite=Raster*anzRichtig;
            NSRect Feld=GrafikRahmen;
            //NSLog(@"Breite: %f anzAufgaben: %d Raster: %d Feld.origin.x: %f",cellFrame.size.width,anzAufgaben,Raster,Feld.origin.x);
            
            //Feld.origin.x+=0.5;
            Feld.size.width=Raster-2.0;//Feld fuer eine Aufgabe
            int i;
            NSColor* KastenFarbe=[NSColor colorWithDeviceRed:190.0/255 green:190.0/255 blue:190.0/255 alpha:1.0];
            
            float originx=Feld.origin.x;
            for (i=0;i<anzAufgaben;i++)
            {
               Feld.origin.x=originx+i*Raster;
               //NSLog(@"i: %d origin.x: %f Feld.origin.y: %f",i,Feld.origin.x,Feld.origin.y);
               if (i<anzRichtig)
               {
                  if (farbig)
                  {
                     [[NSColor cyanColor]set];
                  }
                  else
                  {
                     [KastenFarbe set];
                     
                     //[[NSColor lightGrayColor]set];
                  }
                  
                  
                  [NSBezierPath fillRect:Feld];
               }
               //else
               {
                  NSBezierPath* bp=[NSBezierPath bezierPathWithRect:Feld];
                  [[NSColor lightGrayColor] set];
                  [bp setLineWidth:0.55];
                  [bp stroke];
               }
               //Feld.origin.x+=(Raster);
            }//for i
            
         }
      }break;
         
      default:
      {
         [super drawRect:dasFeld];
      }
         
   }//switch art
}
@end

@implementation rFehlerView

- (id)init
{
   self=[super init];
   farbig=YES;
   
   return self;
}

- (void)setGrafikDaten:(NSDictionary*)derGrafikDic
{
   //NSLog(@"Fehler				setGrafikDaten: %@",[derGrafikDic objectForKey:@"farbig"]);
   art=[[derGrafikDic objectForKey:@"art"]intValue];
   anzAufgaben=[[derGrafikDic objectForKey:@"anzaufgaben"]intValue];
   anzRichtig=[[derGrafikDic objectForKey:@"anzrichtig"]intValue];
   anzFehler=[[derGrafikDic objectForKey:@"anzfehler"]intValue];
   zeit=[[derGrafikDic objectForKey:@"zeit"]intValue];
   maxzeit=[[derGrafikDic objectForKey:@"maxzeit"]intValue];
   FehlerBild=[NSImage imageNamed:@"FehlerImg"];
   if ([derGrafikDic objectForKey:@"farbig"])
   {
      farbig=[[derGrafikDic objectForKey:@"farbig"]boolValue];
   }
   else
   {
      farbig=YES;
   }
   
   
}

- (void)drawRect:(NSRect)dasFeld
{
   //NSLog(@"controlView: %@",[controlView description]);
   //NSLog(@"FehlerCell drawInteriorWithFrame Fehler: %d",anzFehler);
   int Raster=0;
   GrafikRahmen=dasFeld;
   GrafikRahmen.origin.x+=4;
   //GrafikRahmen.origin.y+=2;
   //GrafikRahmen.size.height-=4;
   GrafikRahmen.size.width-=4;
   
   if (anzFehler)//Es hat Fehler
   {
      Raster=(dasFeld.size.width)/ anzFehler;
      Raster=6;
      //NSLog(@"Breite: %f anzFehler: %f Raster: %f",cellFrame.size.width,anzFehler,Raster);
      NSRect Feld=dasFeld;
      Feld.size.width=4;//Feld fuer einen Fehler
      Feld.size.height=4;
      Feld.origin.y+=dasFeld.size.height/2-2;
      Feld.origin.x+=Raster/2;
      int i;
      for (i=0;i<anzFehler;i++)
      {
         if (farbig)
         {
            [[NSColor redColor]set];
         }
         else
         {
            [[NSColor grayColor]set];
         }
         //[NSBezierPath strokeRect:Feld];
         [[NSBezierPath bezierPathWithOvalInRect:Feld]stroke];
         [[NSBezierPath bezierPathWithOvalInRect:Feld]fill];
         //[NSBezierPath fillRect:Feld];
         Feld.origin.x+=Raster;
      }//for i
   }
}

@end





@implementation rStatistik

- (id)init
{
   self = [super initWithWindowNibName:@"SCStatistik"];
   TestDicArray=[[NSMutableArray alloc] initWithCapacity:0];
   StatistikDicArray=[[NSMutableArray alloc] initWithCapacity:0];
   AdminStatistikDicArray=[[NSMutableArray alloc] initWithCapacity:0];
   DatenQuelle=[[rStatistikDS alloc]init];
   NoteDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   NoteChangedDicArray=[[NSMutableArray alloc]initWithCapacity:0];//Dic von bearbeiteten Noten
   NSNotificationCenter * nc;
   nc=[NSNotificationCenter defaultCenter];
   [nc addObserver:self
          selector:@selector(DeleteKnopfAktion:)
              name:@"DeleteKnopf"
            object:nil];
   
   AusDiplomOK=0;//Wenn 1, dann muss NamenPop resettet werden
   SessionDatum=[[NSDate alloc]init];
   farbig=YES;
   return self;
}

- (void)awakeFromNib
{
   int Schriftgroesse=10;
   [StatistikTable setDelegate:self];
   [StatistikTable setDataSource:self];
   rGrafikCell* GrafikCell=[[rGrafikCell alloc]init];
   rFehlerCell* FehlerCell=[[rFehlerCell alloc]init];
   NSTextFieldCell* NoteCell=[[NSTextFieldCell alloc]init];
   //NSArray* NotenArray=[NSArray arrayWithObjects:@"6",@"5-6",@"5",@"4-5",@"4",@"3-4",@"3",@"2-3",nil];
   [NoteCell  setFont:[NSFont fontWithName:@"Helvetica" size:Schriftgroesse]];
   [NoteCell setAlignment:NSCenterTextAlignment];
   [NoteCell setEditable:YES];
   /*
    if (farbig)
    {
    NSColor* NoteColor=[NSColor colorWithDeviceRed:0.85 green:0.85 blue:0.85 alpha:1.0];
    [NoteCell setBackgroundColor:NoteColor];
    
    }
    else
    {
    [NoteCell setBackgroundColor:[NSColor grayColor]];
    }
    */
   
   
   //	[NoteCell setAction:@selector(NoteCellAktion:)];
   [[StatistikTable tableColumnWithIdentifier:@"grafik"]setDataCell:GrafikCell];
   [[StatistikTable tableColumnWithIdentifier:@"malpoints"]setDataCell:FehlerCell];
   //[[[StatistikTable tableColumnWithIdentifier:@"fehler"]dataCell]setAlignment:NSCenterTextAlignment];
   
   //[[StatistikTable tableColumnWithIdentifier:@"note"]setDataCell:NoteCell];
   //[[[self window]contentView]addSubview:StatistikTab];
   //[StatistikTab addSubview:StatistikTable];
   
   
   [TestTable setDelegate:DatenQuelle];
   [TestTable setDataSource:DatenQuelle];
   [[TestTable tableColumnWithIdentifier:@"grafik"]setDataCell:GrafikCell];
   [[TestTable tableColumnWithIdentifier:@"malpoints"]setDataCell:FehlerCell];
   [[TestTable tableColumnWithIdentifier:@"note"]setDataCell:NoteCell];
   
   [StatistikTab setDelegate:self];
   
   [IconFeld setImage:[NSImage imageNamed:@"duerergrau"]];
   
   [[self window]makeFirstResponder:SchliessenTaste];
   [SchliessenTaste setKeyEquivalent:@"\r"];
   
}

- (IBAction)reportCancel:(id)sender
{
   [TestDicArray removeAllObjects];
   [StatistikTable reloadData];
   [NSApp stopModalWithCode:0];
   [[self window]orderOut:NULL];
   
}

- (IBAction)reportClose:(id)sender
{
   if ([StatistikTimer isValid])
   {
      [StatistikTimer invalidate];
   }
   
   //Change von Noten sichern
   [TestTable deselectAll:NULL];
   [DeleteTestKnopf setEnabled:NO];
   int tabIndex=[StatistikTab indexOfTabViewItem:[StatistikTab selectedTabViewItem]];
   
   if (tabIndex==0)//Tests fuer Namen
   {
      //	NSLog(@"reportClose Name: %@ 	NoteString: %@",[NamenFeld stringValue],[NoteCombo stringValue]);
      NSMutableDictionary* tempUpdateDic=[[NSMutableDictionary alloc]initWithCapacity:0];
      [tempUpdateDic setObject:[NamenFeld stringValue] forKey:@"name"];
      if ([[NoteCombo stringValue]length])
      {
         [tempUpdateDic setObject:[NoteCombo stringValue] forKey:@"note"];
      }
      //NSLog(@"reportClose tempUpdateDic: %@",[tempUpdateDic description]);
      [self updateAdminStatistikDicArrayMitNoteChangedDic:tempUpdateDic];
      //[NoteCombo setStringValue:@""];
      
   }
   
   [self updateAdminStatistikDicArrayMitNoteChangedArray:[DatenQuelle NoteChangedDicArray]];
   NSMutableArray* UpdateDicArray=[[NSMutableArray alloc]initWithCapacity:0];
   NSEnumerator* UpdateEnum=[AdminStatistikDicArray objectEnumerator];
   id einDic;
   while (einDic=[UpdateEnum nextObject])
   {
      if ([einDic objectForKey:@"notechanged"])
      {
         if ([[einDic objectForKey:@"notechanged"]intValue]==1)//Note bearbeitet
         {
            if ([einDic objectForKey:@"note"])
            {
               NSMutableDictionary* tempUpdateDic=[[NSMutableDictionary alloc]initWithCapacity:0];
               [tempUpdateDic setObject:[einDic objectForKey:@"name"]forKey:@"name"];
               //[tempUpdateDic setObject:[einDic objectForKey:@"notechanged"]forKey:@"notechanged"];
               [tempUpdateDic setObject:[einDic objectForKey:@"note"]forKey:@"note"];
               [UpdateDicArray addObject:tempUpdateDic];
            }
         }
      }//if notechanged
   }//while
   if ([UpdateDicArray count])
   {
      NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
      [NotificationDic setObject:UpdateDicArray forKey:@"updatedicarray"];
      NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
      [nc postNotificationName:@"NotenUpdate" object:self userInfo:NotificationDic];
      
   }
   //NSLog(@"reportClose: UpdateDicArray: %@",[UpdateDicArray description]);
   [TestDicArray removeAllObjects];
   [StatistikTable reloadData];
   [NSApp stopModalWithCode:1];
   [[self window]orderOut:NULL];
   [self setAdminOK:NO];
}

- (void)setTestDicVon:(NSString*)derBenutzer
{
   
   NSMutableArray* DicArrayVonTest=[[NSMutableArray alloc] initWithCapacity:0];//Array fuer Dics des Users
   NSEnumerator* ErgebnisEnum=[StatistikDicArray objectEnumerator];
   id einDic;
   while (einDic=[ErgebnisEnum nextObject])
   {
      if ([[einDic objectForKey:@"testname"]isEqualToString:[TestNamenPopKnopf titleOfSelectedItem]])
      {
         
         [DicArrayVonTest addObject:einDic];
      }
   }//while
   
   //NSLog(@"setTestDicVon	DicArrayVonTest: %@",[DicArrayVonTest description]);
   NSSortDescriptor* Sorter=[[NSSortDescriptor alloc]initWithKey:@"datum" ascending:YES];
   NSArray* SorterArray=[NSArray arrayWithObjects:Sorter,nil];
   
   NSArray* tempErgebnisDicArray=[DicArrayVonTest sortedArrayUsingDescriptors:SorterArray];
   //NSLog(@"setTestDicVon	sortiert nach Datum: %@",[tempErgebnisDicArray description]);
   if ([tempErgebnisDicArray count])
   {
      NSEnumerator* ErgebnisEnum=[tempErgebnisDicArray objectEnumerator];
      id einDic;
      while (einDic=[ErgebnisEnum nextObject])
      {
         NSMutableDictionary* tempErgebnisDic=[[NSMutableDictionary alloc]initWithCapacity:0];
         [tempErgebnisDic setObject: [einDic objectForKey:@"abgelaufenezeit"] forKey:@"zeit"];
         NSCalendarDate* tempDate=[[NSCalendarDate alloc]initWithString:[[einDic objectForKey:@"datum"]description]];
         //NSLog(@"reportTestnamen	tempDate: %@",[tempDate description]);
         if (tempDate)
         {
            int tag=[tempDate dayOfMonth];
            int monat=[tempDate monthOfYear];
            int jahr=[tempDate yearOfCommonEra];
            NSString* Tag=[NSString stringWithFormat:@"%d.%d.%d",tag,monat,jahr];
            [tempErgebnisDic setObject:Tag forKey:@"datumtext"];
            [tempErgebnisDic setObject:[einDic objectForKey:@"datum"] forKey:@"datum"];
            //NSLog(@"setTestDicVon: %@  Tag: %@",tempDate,Tag);
         }
         
         [TestDicArray addObject:tempErgebnisDic];
      }//while
      //NSLog(@"setTestDicVon	TestDicArray: %@",[TestDicArray description]);
      [StatistikTable reloadData];
      
   }
   
   
   //
}


- (IBAction)reportTestNamen:(id)sender//im Tab 0
{
   if (AdminOK)
   {
      [TestTable deselectAll:NULL];
      [DeleteTestKnopf setEnabled:NO];
      //NSLog(@"reportAdminNamen Name: %@ 	NoteString: %@",[NamenFeld stringValue],NoteString);
      NSMutableDictionary* tempUpdateDic=[[NSMutableDictionary alloc]initWithCapacity:0];
      [tempUpdateDic setObject:[NamenFeld stringValue] forKey:@"name"];
      [tempUpdateDic setObject:[NoteCombo stringValue] forKey:@"note"];
      //NSLog(@"reportAdminNamen tempUpdateDic: %@",[tempUpdateDic description]);
      //NSLog(@"tempUpdateDic: retaincount: %d: ",[tempUpdateDic retainCount]);
      [self updateAdminStatistikDicArrayMitNoteChangedDic:tempUpdateDic];
      
      if ([sender indexOfSelectedItem]==[sender numberOfItems]-1)//alle
      {
         //			NSLog(@"lastItem: %@",[sender titleOfSelectedItem]);
         
         [self setTableForAllTestsForUser:[NamenPopMenu titleOfSelectedItem]];
      }
      else	//nur 1 Test
      {
         [self setTableVonTest:[sender titleOfSelectedItem] forUser:[NamenPopMenu titleOfSelectedItem]];
      }
   }
   else
   {
      [self setTableVonTest:[sender titleOfSelectedItem]];
   }
}


- (IBAction)reportAdminNamen:(id)sender
{
   [TestTable deselectAll:NULL];
   [DeleteTestKnopf setEnabled:NO];
   
   NSString* NoteString=[NoteCombo stringValue];
   
   //	NSLog(@"reportAdminNamen Name: %@ 	NoteString: %@",[NamenFeld stringValue],NoteString);
   if ([TestNamenPopKnopf indexOfSelectedItem]<[TestNamenPopKnopf numberOfItems]-1)//nicht:alle tests
   {
      NSMutableDictionary* tempUpdateDic=[[NSMutableDictionary alloc]initWithCapacity:0];
      [tempUpdateDic setObject:[NamenFeld stringValue] forKey:@"name"];
      [tempUpdateDic setObject:[NoteCombo stringValue] forKey:@"note"];
      
      NSLog(@"reportAdminNamen tempUpdateDic: %@",[tempUpdateDic description]);
      [self updateAdminStatistikDicArrayMitNoteChangedDic:tempUpdateDic];
      [NoteCombo setStringValue:@""];
      
      [self setTableVonTest:[TestNamenPopKnopf titleOfSelectedItem] forUser:[NamenPopMenu titleOfSelectedItem]];
      [NamenFeld setStringValue:[NamenPopMenu titleOfSelectedItem]];
   }
   else
   {
      [self setTableForAllTestsForUser:[NamenPopMenu titleOfSelectedItem]];
   }
   
}

- (IBAction)reportMittelwertOption:(id)sender
{
   int Zeile=[sender selectedRow];
   //NSLog(@"reportMittelwertOption	Zeile: %d",Zeile);
   [TestTable deselectAll:NULL];
   [DeleteTestKnopf setEnabled:NO];
   NSArray* tempChangedArray=[DatenQuelle NoteChangedDicArray];
   if ([tempChangedArray count])
   {
      NSLog(@"updateAdminStatistikDicArrayMitNoteChangedArray ausführen");
      [self updateAdminStatistikDicArrayMitNoteChangedArray:tempChangedArray];
   }
   NSLog(@"reportMittelwertOption Test: %@ ",[AdminTestNamenPopKnopf titleOfSelectedItem]);
   
   if ([AdminTestNamenPopKnopf indexOfSelectedItem]==[AdminTestNamenPopKnopf numberOfItems]-1)//alle]
   {
      [self setAdminTestTableForAllTests];
      
   }
   else
   {
      
      [self setAdminTestTableForTest:[AdminTestNamenPopKnopf titleOfSelectedItem]];
   }
   
   switch (Zeile)
   {
      case 0://Mittelwert von allen
      {
         NSLog(@"Mittelwert von allen");
         
      }break;
      case 1://Mittelwert nur von gezeigten
      {
         NSLog(@"Mittelwert von angezeigten");
         
      }break;
         
   }//switch
}

- (void)updateAdminStatistikDicArrayMitNoteChangedDic:(NSDictionary*)derNoteChangedDic
{
   //neue oder geänderte Note in AdminStatistikDicArray eintragen
   NSArray* tempNamenArray=[AdminStatistikDicArray valueForKey:@"name"];
   NSUInteger namenindex;
   //NSLog(@"updateAdminStatistikDicArrayMitNoteChangedDic: NoteChangedDic: %@",[derNoteChangedDic description]);
   
   NSString* tempName=[derNoteChangedDic objectForKey:@"name"];
   if (tempName)//Name ist da
   {
      namenindex=[tempNamenArray indexOfObject:tempName];
      if (!(namenindex==NSNotFound))
      {
         if ([derNoteChangedDic objectForKey:@"note"])//Note ist gesetzt
         {
            if ([[derNoteChangedDic objectForKey:@"note"] length])
            {
               //					NSLog(@"UpdateAdminStatisticMitNoteChangedDic");
               //NSBeep();
            }
            [[AdminStatistikDicArray objectAtIndex:namenindex]setObject:[NSNumber numberWithInt:1] forKey:@"notechanged"];
            [[AdminStatistikDicArray objectAtIndex:namenindex]setObject:[derNoteChangedDic objectForKey:@"note"] forKey:@"note"];
         }
         
      }
   }
   
   
}

- (void)updateAdminStatistikDicArrayMitNoteChangedArray:(NSArray*)derNoteArray
{
   //neue oder geänderte Noten in AdminStatistikDicArray eintragen
   //NSLog(@"updateAdminStatistikDicArrayMitNoteChangedArray: derNoteArray: %@",[derNoteArray description]);
   NSArray* tempNamenArray=[AdminStatistikDicArray valueForKey:@"name"];
   //NSLog(@"tempNamenArray: retaincount: %d: ",[tempNamenArray retainCount]);
   NSUInteger namenindex;
   NSEnumerator* NoteEnum=[derNoteArray objectEnumerator];
   id einDic;
   while (einDic=[NoteEnum nextObject])
   {
      NSString* tempName=[einDic objectForKey:@"nametext"];
      if (tempName)//Dic fuer Name ist da
      {
         namenindex=[tempNamenArray indexOfObject:tempName];
         if (!(namenindex==NSNotFound))
         {
            if ([einDic objectForKey:@"note"])//Note ist gesetzt
            {
               
               NSString* noteString=[einDic objectForKey:@"note"];
               //NSLog(@"updateAdminStatistikDicArrayMitNoteChangedArray: einDic: %@",[einDic description]);
               [[AdminStatistikDicArray objectAtIndex:namenindex]setObject:[NSNumber numberWithInt:1] forKey:@"notechanged"];
               [[AdminStatistikDicArray objectAtIndex:namenindex]setObject:[einDic objectForKey:@"note"] forKey:@"note"];
               //NSLog(@"\n\nupdateAdminStatistikDicArrayMitNoteChangedArray: [AdminStatistikDicArray objectAtIndex:namenindex]: %@",[[AdminStatistikDicArray objectAtIndex:namenindex] description]);
               
            }
            
         }
      }
      
   }//while
}

- (void)updateAdminStatistikDicArrayAktion:(NSDictionary*)note
{
   //neue oder geänderte Note in AdminStatistikDicArray eintragen
   if ([note objectForKey:@"name"])
   {
      NSArray* tempNamenArray=[AdminStatistikDicArray valueForKey:@"name"];
      NSUInteger namenindex;
      NSString* tempName=[note objectForKey:@"name"];
      if (tempName)//Dic fuer Name ist da
      {
         namenindex=[tempNamenArray indexOfObject:tempName];
         if (!(namenindex==NSNotFound))
         {
            if ([note  objectForKey:@"note"])//Note ist gesetzt
            {
               [[AdminStatistikDicArray objectAtIndex:namenindex]setObject:[note objectForKey:@"note"] forKey:@"note"];
            }
            
         }
      }
      
   }
}


- (IBAction)reportAdminTestNamen:(id)sender
{
   [TestTable deselectAll:NULL];
   [DeleteTestKnopf setEnabled:NO];
   //NSLog(@"reportAdminTestNamen: NoteChangedDicArray: %@",[[DatenQuelle NoteChangedDicArray ] description]);
   
   //NSLog(@"reportAdminTestNamen: DicOfSelectedRow: %@",[[DatenQuelle DicForRow:[TestTable selectedRow] ] description]);
   
   NSArray* tempChangedArray=[DatenQuelle NoteChangedDicArray];
   if ([tempChangedArray count])
   {
      [self updateAdminStatistikDicArrayMitNoteChangedArray:tempChangedArray];
   }
   int anzItems=[sender numberOfItems];
   if ([sender indexOfSelectedItem]==anzItems-1)//alle
   {
      [TestAnzahlFeld setEnabled:NO];
      [TestMaxZeitFeld setEnabled:NO];
      [self setAdminTestTableForAllTests];
   }
   else
   {
      [TestAnzahlFeld setEnabled:YES];
      [TestMaxZeitFeld setEnabled:YES];
      
      //	NSLog(@"reportAdminNamen: %@  User:%@",[sender titleOfSelectedItem],[NamenPopMenu titleOfSelectedItem]);
      [self setAdminTestTableForTest:[sender titleOfSelectedItem]];
   }
}

- (IBAction)reportAnzahlZeigen:(id)sender
{
   [TestTable deselectAll:NULL];
   [DeleteTestKnopf setEnabled:NO];
   NSArray* tempChangedArray=[DatenQuelle NoteChangedDicArray];
   if ([tempChangedArray count])
   {
      [self updateAdminStatistikDicArrayMitNoteChangedArray:tempChangedArray];
   }
   
   if ([AdminTestNamenPopKnopf indexOfSelectedItem]==[AdminTestNamenPopKnopf numberOfItems]-1)//alle
   {
      [self setAdminTestTableForAllTests];
   }
   else	//Nur von einem Test
   {
      
      //NSLog(@"reportAnzahlZeigen: Anzahl: %d",[[sender selectedItem]tag]);
      [self setAdminTestTableForTest:[AdminTestNamenPopKnopf titleOfSelectedItem]];
   }
}

- (void)DeleteKnopfAktion:(NSNotification*)note
{
   if ([[note userInfo]objectForKey:@"art"])
   {
      int art=[[[note userInfo]objectForKey:@"art"]intValue];
      [DeleteTestKnopf setEnabled:(art>0)];
   }
   
}

- (void)reportAnzahlForNameZeigen:(id)sender
{
   int anzZeigen=[[AnzahlForNameZeigenPopKnopf selectedItem]tag];
   //NSLog(@"setTableForUser: selectedItem: %@ anzZeigen: %d",[[AnzahlForNameZeigenPopKnopf selectedItem]description],anzZeigen);
   if ([TestNamenPopKnopf indexOfSelectedItem]==[TestNamenPopKnopf numberOfItems]-1)//alle Tests
   {
      [self setTableForAllTestsForUser:[NamenPopMenu titleOfSelectedItem]];
   }
   else//nur ein Test
   {
      [self setTableVonTest:[TestNamenPopKnopf titleOfSelectedItem] forUser:[NamenPopMenu titleOfSelectedItem]];
   }
}


- (IBAction)reportDeleteTest:(id)sender
{
   NSAlert* DeleteWarnung=[[NSAlert alloc]init];
   NSString* t=NSLocalizedString(@"Delete Test",@"Test löschen");
   NSString* i1=NSLocalizedString(@"Do you really want to delete this test?",@"Diesen Text wirklisch löschen?");
   NSString* b1=NSLocalizedString(@"Delete",@"Löschen");
   NSString* b2=NSLocalizedString(@"Cancel",@"Abbrechen");
   [DeleteWarnung addButtonWithTitle:b1];
   [DeleteWarnung addButtonWithTitle:b2];
   [DeleteWarnung setMessageText:t];
   [DeleteWarnung setInformativeText:i1];
   
   int modalAntwort=[DeleteWarnung runModal];
   //NSLog(@"modalAntwort: %d",modalAntwort);
   if (modalAntwort==1001)//Cancel
   {
      return;
   }
   NSUInteger deleteIndex=[TestTable selectedRow];
   
   NSMutableDictionary* deleteDic;//=(NSMutableDictionary*)[[TestTable dataSource]DicForRow:deleteIndex];
   
   NSLog(@"reportDeleteTest	deleteIndex: %d	:deleteDic: %@",deleteIndex,[deleteDic description]);
   if (deleteDic)
   {
      [deleteDic setObject:[NSNumber numberWithInt:-1] forKey:@"art"];
      NSString* deleteName=[deleteDic objectForKey:@"name"];
      NSString* deleteDatum=[deleteDic objectForKey:@"datum"];
      
      //Test in AdminStatistikDicArray suchen und entfernen
      NSArray* tempNamenArray=[AdminStatistikDicArray valueForKey:@"name"];
      NSUInteger namenIndex=[tempNamenArray indexOfObject:deleteName];
      if (namenIndex==NSNotFound){return;}
      
      NSMutableDictionary* AdminStatistikDic=[AdminStatistikDicArray objectAtIndex:namenIndex];
      if (AdminStatistikDic)
      {
         if ([AdminStatistikDic objectForKey:@"ergebnisdicarray"]&&[[AdminStatistikDic objectForKey:@"ergebnisdicarray"]count])
         {
            NSMutableArray* tempDicArray=[[NSMutableArray alloc]initWithArray:[AdminStatistikDic objectForKey:@"ergebnisdicarray"]];
            NSArray* tempDatumArray=[tempDicArray valueForKey:@"datum"];
            //NSLog(@"tempDatumArray: %@",[tempDatumArray description]);
            NSUInteger datumIndex=[tempDatumArray indexOfObject:deleteDatum];
            if (!(datumIndex==NSNotFound))
            {
               //NSLog(@"deleteName: %@	datumIndex: %d",deleteName,datumIndex);
               [tempDicArray removeObjectAtIndex:datumIndex];
               
            }
            [AdminStatistikDic setObject:tempDicArray forKey:@"ergebnisdicarray"];
            [self setAdminTestTableForTest:[AdminTestNamenPopKnopf titleOfSelectedItem]];
            
         }
         
      }//if AdminStatistikDic
      //NSLog(@"reportdeleteTest: AdminStatistikDic:	%@",[AdminStatistikDic description]);
      
      //Test in Userdaten entfernen
      NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
      [NotificationDic setObject:deleteName forKey:@"name"];
      [NotificationDic setObject:deleteName forKey:@"testname"];
      [NotificationDic setObject:deleteDatum forKey:@"datum"];
      NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
      [nc postNotificationName:@"DeleteTest" object:self userInfo:NotificationDic];
      
   }//if deleteDic
   //NSLog(@"reportdeleteTest: AdminStatistikDicArray:  %@",[AdminStatistikDicArray description]);
}

- (void)setFarbig:(BOOL)farbigDrucken
{
   farbig=farbigDrucken;
   [DatenQuelle setFarbig:farbig];
   //NSLog(@"Statistik setFarbig: %d",farbig);
}


- (void)setAdminTestTableForTest:(NSString*)derTest
{
   
   NSArray* tempDicArray=[self ErgebnisDicArrayForTest:derTest];
   //NSLog(@"setAdminTestTableForTest	Test: %@	 tempDicArray count: %d",derTest,[tempDicArray count]);
   if ([tempDicArray count])
   {
      //NSLog(@"setAdminTestTableForTest	Test: %@	 tempDicArray Object 0: %@",derTest,[[tempDicArray objectAtIndex:0] description]);
      NSString* tempAnzAufgabenString=[[tempDicArray objectAtIndex:0]objectForKey:@"anzaufgaben"];
      
      NSString* tempMaxZeitString=[[tempDicArray objectAtIndex:0]objectForKey:@"maxzeit"];
      [TestAnzahlFeld setStringValue:tempAnzAufgabenString];
      [TestMaxZeitFeld setStringValue:tempMaxZeitString];
      
   }
   //NSLog(@"setAdminTestTableForTest	Test: %@	 tempDicArray: %@",derTest,[tempDicArray description]);
   [AdminTestNamenPopKnopf selectItemWithTitle:derTest];
   
   [DatenQuelle setAdminStatistikDicArray:tempDicArray];
   
   [TestTable reloadData];
   [TestTable deselectAll:NULL];
}



- (void)setAdminTestTableForAllTests
{
   int anzTests=[AdminTestNamenPopKnopf numberOfItems];
   [AdminTestNamenPopKnopf selectItemAtIndex:anzTests-1];
   NSArray* tempDicArray=[self ErgebnisDicArrayForAllTests];
   //NSLog(@"setAdminTestTableForAllTests	 tempDicArray: %@",[tempDicArray description]);
   [TestAnzahlFeld setStringValue:@""];
   [TestMaxZeitFeld setStringValue:@""];
   
   [DatenQuelle setAdminStatistikDicArray:tempDicArray];
   
   [TestTable reloadData];
   [TestTable deselectAll:NULL];
}



- (void)setTableVonTest:(NSString*)derTest
{
   int anzTestForUser=0;
   float ZeitBedarf=0;
   int AnzahlRichtige=0;
   float note=0;
   
   //NSLog(@"setTableVonTest: Test: %@\n\n",derTest);
   //[TestNamenPopKnopf selectItemWithTitle:derTest];
   [NoteCombo setStringValue:@""];
   [TestDicArray removeAllObjects];
   NSMutableArray* DicArrayVonTest=[[NSMutableArray alloc] initWithCapacity:0];
   //[TestDicArray removeAllObjects];
   //NSLog(@"reportTestnamen	AdminStatistikDicArray: %@",[AdminStatistikDicArray description]);
   //NSLog(@"reportTestnamen	StatistikDicArray: %@",[StatistikDicArray description]);
   NSEnumerator* ErgebnisEnum=[StatistikDicArray objectEnumerator];
   id einDic;
   while (einDic=[ErgebnisEnum nextObject])
   {
      if ([[einDic objectForKey:@"testname"]isEqualToString:derTest])
      {
         [DicArrayVonTest addObject:einDic];
      }
   }//while
   if ([DicArrayVonTest count])
   {
      [TestNamenPopKnopf selectItemWithTitle:derTest];
      //NSLog(@"reportTestnamen	DicArrayVonTest: %@",[DicArrayVonTest description]);
      NSSortDescriptor* Sorter=[[NSSortDescriptor alloc]initWithKey:@"datum" ascending:NO];
      NSArray* SorterArray=[NSArray arrayWithObjects:Sorter,nil];
						
      ZeitBedarf=0.0;
      AnzahlRichtige=0;
      
      
      NSArray* tempErgebnisDicArray=[DicArrayVonTest sortedArrayUsingDescriptors:SorterArray];
      //NSLog(@"reportTestnamen	sortiert nach Datum: %@",[tempErgebnisDicArray description]);
      if ([tempErgebnisDicArray count])
      {
         
         int anzahlaufgaben=0;
         int maximalzeit=0;
         int abgelaufenezeit=0.0;
         int anzrichtig=0;
         
         NSEnumerator* ErgebnisEnum=[tempErgebnisDicArray objectEnumerator];
         
         id einDic;
         int index=0;
         while (einDic=[ErgebnisEnum nextObject])
         {
            if (index==0)
            {
               anzahlaufgaben=[[einDic objectForKey:@"anzahlaufgaben"]intValue];
               maximalzeit=[[einDic objectForKey:@"maximalzeit"]intValue];
               
               [AnzahlFeld setObjectValue:[einDic objectForKey:@"anzahlaufgaben"]];
               [MaxZeitFeld setObjectValue:[einDic objectForKey:@"maximalzeit"]];
               index++;
            }
            abgelaufenezeit=[[einDic objectForKey:@"abgelaufenezeit"]intValue];
            anzrichtig=[[einDic objectForKey:@"anzrichtig"]intValue];
            AnzahlRichtige+=anzrichtig;
            ZeitBedarf+=abgelaufenezeit;
            
            NSMutableDictionary* tempErgebnisDic=[[NSMutableDictionary alloc]initWithCapacity:0];
            [tempErgebnisDic setObject: [NSNumber numberWithInt:1] forKey:@"art"];
            
            [tempErgebnisDic setObject: [einDic objectForKey:@"abgelaufenezeit"] forKey:@"zeit"];
            
            NSCalendarDate* tempDate=[[NSCalendarDate alloc]initWithString:[[einDic objectForKey:@"datum"]description]];
            //NSLog(@"reportTestnamen	tempDate: %@",[tempDate description]);
            if (tempDate)
            {
               int test=[[NSCalendarDate calendarDate] dayOfMonth];
               //NSLog(@"Heute ganz: %@ test heute: %d",[NSCalendarDate calendarDate],test);
               int tag=[tempDate dayOfMonth];
               int monat=[tempDate monthOfYear];
               int jahr=[tempDate yearOfCommonEra];
               NSString* Tag=[NSString stringWithFormat:@"%d.%d.%d",tag,monat,jahr];
               [tempErgebnisDic setObject:Tag forKey:@"datumtext"];
               [tempErgebnisDic setObject:[einDic objectForKey:@"datum"] forKey:@"datum"];
               //NSLog(@"reportTestnamen: %@  Tag: %@",tempDate,Tag);
            }
            [tempErgebnisDic setObject: [einDic objectForKey:@"anzfehler"] forKey:@"anzfehler"];
            [tempErgebnisDic setObject: [einDic objectForKey:@"anzahlaufgaben"] forKey:@"anzaufgaben"];
            [tempErgebnisDic setObject: [einDic objectForKey:@"anzrichtig"] forKey:@"anzrichtig"];
            
            [tempErgebnisDic setObject: [einDic objectForKey:@"maximalzeit"] forKey:@"maxzeit"];
            [TestDicArray addObject:tempErgebnisDic];
         }//while
         NSString* ZeitString=[NSString stringWithFormat:@"%1.1f",(ZeitBedarf/AnzahlRichtige)];
         [ZeitProAufgabeFeld setStringValue:ZeitString];
         
         //NSLog(@"reportTestnamen	TestDicArray: %@",[TestDicArray description]);
         
         
         
         
      }
      [TestNamenPopKnopf selectItemWithTitle:derTest];
   }//if DicArray count
   
   [StatistikTable reloadData];
   
   if (!AdminOK)//Timer setzen
   {
      [self setStatistikTimerMitIntervall:15.0 mitInfo:@"User"];
      
   }
   
}

- (void)setAusDiplomOK:(int)derStatus
{
   AusDiplomOK=derStatus;
}

- (void)setStatistikTimerMitIntervall:(float)dasIntervall mitInfo:(NSString*)dieInfo
{
   if ([StatistikTimer isValid])
   {
      //NSLog(@"StatistikTimer invalidate");
      [StatistikTimer invalidate];
   }
   //NSLog(@"StatistikTimer is set");
   StatistikTimer=[NSTimer scheduledTimerWithTimeInterval:dasIntervall
                                                   target:self
                                                 selector:@selector(StatistikTimerFunktion:)
                                                 userInfo:dieInfo
                                                  repeats:NO];
   [[NSRunLoop currentRunLoop] addTimer: StatistikTimer forMode:NSModalPanelRunLoopMode];
   
}


- (void)StatistikTimerFunktion:(NSTimer*)derTimer
{
   //NSLog(@"StatistikTimerFunktion : info: %@",[derTimer userInfo]);
   if ([[derTimer userInfo]isEqualToString:@"Diplom"])
   {
      
      
      [NSApp stopModalWithCode:2];
      [[self window]orderOut:NULL];
      [NSApp abortModal];
      
   }
   else
   {
      [self setAdminOK:NO];
      [NSApp stopModalWithCode:1];
      [[self window]orderOut:NULL];
      [NSApp abortModal];
      
   }
}

- (void)setTableVonTest:(NSString*)derTest forUser:(NSString*)derName
{
   //NSLog(@"setTableVonTest forUser:%@ Test: %@\n\n",derName,derTest);
   //[TestNamenPopKnopf selectItemWithTitle:derTest];
   //[TestTab selectTabViewItemAtIndex:0];
   float ZeitDurchschnitt=0;
   int anzTestForUser=0;
   float ZeitBedarf=0;
   int AnzahlRichtige=0;
   
   [TestDicArray removeAllObjects];
   NSMutableArray* DicArrayVonTest=[[NSMutableArray alloc] initWithCapacity:0];
   [TestDicArray removeAllObjects];
   
   
   //NSLog(@"reportTestnamen	AdminStatistikDicArray: %@",[AdminStatistikDicArray description]);
   //NSLog(@"reportTestnamen	StatistikDicArray: %@",[StatistikDicArray description]);
   NSArray* tempUserNamenArray=[AdminStatistikDicArray valueForKey:@"name"];//Liste der User
   NSUInteger index=[tempUserNamenArray indexOfObject:derName];
   if (!(index==NSNotFound))//Der Name ist da
   {
      anzTestForUser=0;
      
      ZeitDurchschnitt=0;
      //AnzDurchschnitt=0;
      //BestMarke=120;
      
      ZeitBedarf=0.0;
      AnzahlRichtige=0;
      
      NSString* noteString=[[AdminStatistikDicArray objectAtIndex:index]objectForKey:@"note"];
      //NSLog(@"setTableVonTestForUser: %@	note: %@",derName,noteString);
      [NoteCombo setStringValue:@""];
      if (noteString)
      {
         //NSLog(@"TestDicArray for tempName: %@	: %@",tempName,[TestDicArray description]);
         [NoteCombo setStringValue:noteString];
      }
      NSArray* tempErgebnisDicArray=[[AdminStatistikDicArray objectAtIndex:index]objectForKey:@"ergebnisdicarray"];
      //NSLog(@"Index: %d	tempErgebnisDicArray: %@",index,[tempErgebnisDicArray description]);
      
      
      NSEnumerator* ErgebnisEnum=[tempErgebnisDicArray objectEnumerator];
      id einDic;
      while (einDic=[ErgebnisEnum nextObject])
      {
         
         
         if ([[einDic objectForKey:@"testname"]isEqualToString:derTest])
         {
            
            [DicArrayVonTest addObject:einDic];
         }
      }//while
      //NSLog(@"DicArrayVonTest: %@",[DicArrayVonTest description]);
      
      if ([DicArrayVonTest count])
      {
         
         //NSLog(@"reportTestnamen	DicArrayVonTest: %@",[DicArrayVonTest description]);
         NSSortDescriptor* Sorter=[[NSSortDescriptor alloc]initWithKey:@"datum" ascending:NO];
         NSArray* SorterArray=[NSArray arrayWithObjects:Sorter,nil];
         
         
         NSArray* tempErgebnisDicArray=[DicArrayVonTest sortedArrayUsingDescriptors:SorterArray];
         //NSLog(@"reportTestnamen	sortiert nach Datum: %@",[tempErgebnisDicArray description]);
         if ([tempErgebnisDicArray count])
         {
            int anzahlaufgaben=0;
            int maximalzeit=0;
            int abgelaufenezeit=0.0;
            int anzrichtig=0;
            NSEnumerator* ErgebnisEnum=[tempErgebnisDicArray objectEnumerator];
            id einDic;
            int index=0;
            int anzZeigen=[[AnzahlForNameZeigenPopKnopf selectedItem]tag];
            //NSLog(@"setTableForUser: selectedItem: %@ anzZeigen: %d",[[AnzahlForNameZeigenPopKnopf selectedItem]description],anzZeigen);
            while ((einDic=[ErgebnisEnum nextObject])&&(index<anzZeigen))
            {
               if (index==0)
               {
                  anzahlaufgaben=[[einDic objectForKey:@"anzahlaufgaben"]intValue];
                  maximalzeit=[[einDic objectForKey:@"maximalzeit"]intValue];
                  
                  [AnzahlFeld setObjectValue:[einDic objectForKey:@"anzahlaufgaben"]];
                  [MaxZeitFeld setObjectValue:[einDic objectForKey:@"maximalzeit"]];
                  
               }
               index++;
               abgelaufenezeit=[[einDic objectForKey:@"abgelaufenezeit"]intValue];
               anzrichtig=[[einDic objectForKey:@"anzrichtig"]intValue];
               AnzahlRichtige+=anzrichtig;
               ZeitBedarf+=abgelaufenezeit;
               
               NSMutableDictionary* tempErgebnisDic=[[NSMutableDictionary alloc]initWithCapacity:0];
               [tempErgebnisDic setObject: [NSNumber numberWithInt:1] forKey:@"art"];
               [tempErgebnisDic setObject: [einDic objectForKey:@"abgelaufenezeit"] forKey:@"zeit"];
               
               
               NSCalendarDate* tempDate=[[NSCalendarDate alloc]initWithString:[[einDic objectForKey:@"datum"]description]];
               //NSLog(@"reportTestnamen	tempDate: %@",[tempDate description]);
               if (tempDate)
               {
                  int test=[[NSCalendarDate calendarDate] dayOfMonth];
                  //NSLog(@"Heute ganz: %@ test heute: %d",[NSCalendarDate calendarDate],test);
                  int tag=[tempDate dayOfMonth];
                  int monat=[tempDate monthOfYear];
                  int jahr=[tempDate yearOfCommonEra];
                  NSString* JahrString=[[NSNumber numberWithInt:jahr]stringValue];
                  JahrString=[JahrString substringFromIndex:2];
                  NSString* Tag=[NSString stringWithFormat:@"%d.%d.%@",tag,monat,JahrString];
                  [tempErgebnisDic setObject:Tag forKey:@"datumtext"];
                  [tempErgebnisDic setObject:[einDic objectForKey:@"datum"] forKey:@"datum"];
                  //NSLog(@"reportTestnamen: %@  Tag: %@",tempDate,Tag);
               }
               [tempErgebnisDic setObject: [einDic objectForKey:@"anzfehler"] forKey:@"anzfehler"];
               [tempErgebnisDic setObject: [einDic objectForKey:@"anzahlaufgaben"] forKey:@"anzaufgaben"];
               [tempErgebnisDic setObject: [einDic objectForKey:@"anzrichtig"] forKey:@"anzrichtig"];
               [tempErgebnisDic setObject: [einDic objectForKey:@"maximalzeit"] forKey:@"maxzeit"];
               if (noteString)//der User hat eine Note
               {
                  [tempErgebnisDic setObject: noteString forKey:@"note"];
               }
               [TestDicArray addObject:tempErgebnisDic];
            }//while
            //NSLog(@"ZeitDurchschnitt: %d  anzTestForUser: %d	Mittel: %d",(int)ZeitDurchschnitt,anzTestForUser,(int)(ZeitDurchschnitt/anzTestForUser));
            //NSLog(@"AnzDurchschnitt: %d	  Mittel: %d",(int)AnzDurchschnitt,(int)(AnzDurchschnitt/anzTestForUser));
            //NSLog(@"SetTable	User: %@ Anzahl: %d	  Zeit: %f  Mittel: %f",derName,AnzahlRichtige,ZeitBedarf,(ZeitBedarf/AnzahlRichtige));
            NSString* ZeitString=[NSString stringWithFormat:@"%1.1f",(ZeitBedarf/AnzahlRichtige)];
            [ZeitProAufgabeFeld setStringValue:ZeitString];
            
            
            //NSLog(@"reportTestnamen	TestDicArray: %@",[TestDicArray description]);
            
            
            
            
         }
         [TestNamenPopKnopf selectItemWithTitle:derTest];
      }//if DicArray count
      else
      {
         [ZeitProAufgabeFeld setStringValue:@""];
         [AnzahlFeld setStringValue:@""];
         [MaxZeitFeld setStringValue:@""];
         
      }
      
      
   }//Name ist da
   
   
   [StatistikTable reloadData];
   
}

- (NSArray*)ErgebnisDicArrayForTest:(NSString*)derTest forUser:(NSString*)derUser
{
   float ZeitDurchschnitt=0;
   int anzTestForUser=0;
   float ZeitBedarf=0;
   int AnzahlRichtige=0;
   NSMutableArray* returnDicArrayVonTest=[[NSMutableArray alloc] initWithCapacity:0];
   
   NSMutableArray* DicArrayVonTest=[[NSMutableArray alloc] initWithCapacity:0];
   //[TestDicArray removeAllObjects];
   NSLog(@"ErgebnisDicArrayForTest: %@ forUser: %@",derTest, derUser);
   //NSLog(@"reportTestnamen	StatistikDicArray: %@",[StatistikDicArray description]);
   NSArray* tempUserNamenArray=[AdminStatistikDicArray valueForKey:@"name"];//Liste der User
   NSUInteger index=[tempUserNamenArray indexOfObject:derUser];
   if (!(index==NSNotFound))//Der Name ist da
   {
      anzTestForUser=0;
      
      ZeitDurchschnitt=0;
      ZeitBedarf=0.0;
      AnzahlRichtige=0;
      
      NSString* noteString=[[AdminStatistikDicArray objectAtIndex:index]objectForKey:@"note"];
      //NSLog(@"setTableVonTestForUser: %@	note: %@",derName,noteString);
      [NoteCombo setStringValue:@""];
      if (noteString)
      {
         //NSLog(@"TestDicArray for tempName: %@	: %@",tempName,[TestDicArray description]);
         //		[NoteCombo setStringValue:noteString];
      }
      NSArray* tempErgebnisDicArray=[[AdminStatistikDicArray objectAtIndex:index]objectForKey:@"ergebnisdicarray"];
      //NSLog(@"Index: %d	tempErgebnisDicArray: %@",index,[tempErgebnisDicArray description]);
      
      
      NSEnumerator* ErgebnisEnum=[tempErgebnisDicArray objectEnumerator];
      id einDic;
      while (einDic=[ErgebnisEnum nextObject])
      {
         
         
         if ([[einDic objectForKey:@"testname"]isEqualToString:derTest])
         {
            
            [DicArrayVonTest addObject:einDic];
         }
      }//while
      //NSLog(@"DicArrayVonTest: %@",[DicArrayVonTest description]);
      if ([DicArrayVonTest count])
      {
         
         //NSLog(@"reportTestnamen	DicArrayVonTest: %@",[DicArrayVonTest description]);
         NSSortDescriptor* Sorter=[[NSSortDescriptor alloc]initWithKey:@"datum" ascending:NO];
         NSArray* SorterArray=[NSArray arrayWithObjects:Sorter,nil];
         
         
         NSArray* tempErgebnisDicArray=[DicArrayVonTest sortedArrayUsingDescriptors:SorterArray];
         
         //			NSLog(@"ErgebnisDicArrayForTest	sortiert nach Datum: %@",[tempErgebnisDicArray description]);
         if ([tempErgebnisDicArray count])
         {
            int anzahlaufgaben=0;
            int maximalzeit=0;
            int abgelaufenezeit=0.0;
            int anzrichtig=0;
            NSEnumerator* ErgebnisEnum=[tempErgebnisDicArray objectEnumerator];
            id einDic;
            int index=0;
            while (einDic=[ErgebnisEnum nextObject])
            {
               if (index==0)
               {
                  anzahlaufgaben=[[einDic objectForKey:@"anzahlaufgaben"]intValue];
                  maximalzeit=[[einDic objectForKey:@"maximalzeit"]intValue];
                  
                  [AnzahlFeld setObjectValue:[einDic objectForKey:@"anzahlaufgaben"]];
                  [MaxZeitFeld setObjectValue:[einDic objectForKey:@"maximalzeit"]];
                  
               }
               
               abgelaufenezeit=[[einDic objectForKey:@"abgelaufenezeit"]intValue];
               anzrichtig=[[einDic objectForKey:@"anzrichtig"]intValue];
               AnzahlRichtige+=anzrichtig;
               ZeitBedarf+=abgelaufenezeit;
               
               NSMutableDictionary* tempErgebnisDic=[[NSMutableDictionary alloc]initWithCapacity:0];
               
               if (index==0)//erste Zeile
               {
                  [tempErgebnisDic setObject: [NSNumber numberWithInt:1] forKey:@"art"];
                  
                  [tempErgebnisDic setObject: [einDic objectForKey:@"testname"] forKey:@"nametext"];
                  
               }
               else
               {
                  [tempErgebnisDic setObject: [NSNumber numberWithInt:2] forKey:@"art"];
               }
               
               [tempErgebnisDic setObject: [einDic objectForKey:@"abgelaufenezeit"] forKey:@"zeit"];
               
               
               NSCalendarDate* tempDate=[[NSCalendarDate alloc]initWithString:[[einDic objectForKey:@"datum"]description]];
               //NSLog(@"reportTestnamen	tempDate: %@",[tempDate description]);
               if (tempDate)
               {
                  int test=[[NSCalendarDate calendarDate] dayOfMonth];
                  //NSLog(@"Heute ganz: %@ test heute: %d",[NSCalendarDate calendarDate],test);
                  int tag=[tempDate dayOfMonth];
                  int monat=[tempDate monthOfYear];
                  int jahr=[tempDate yearOfCommonEra];
                  NSString* JahrString=[[NSNumber numberWithInt:jahr]stringValue];
                  JahrString=[JahrString substringFromIndex:2];
                  NSString* Tag=[NSString stringWithFormat:@"%d.%d.%@",tag,monat,JahrString];
                  [tempErgebnisDic setObject:Tag forKey:@"datumtext"];
                  [tempErgebnisDic setObject:[einDic objectForKey:@"datum"] forKey:@"datum"];
                  //NSLog(@"reportTestnamen: %@  Tag: %@",tempDate,Tag);
               }
               [tempErgebnisDic setObject: [einDic objectForKey:@"anzfehler"] forKey:@"anzfehler"];
               [tempErgebnisDic setObject: [einDic objectForKey:@"anzahlaufgaben"] forKey:@"anzaufgaben"];
               [tempErgebnisDic setObject: [einDic objectForKey:@"anzrichtig"] forKey:@"anzrichtig"];
               [tempErgebnisDic setObject: [einDic objectForKey:@"maximalzeit"] forKey:@"maxzeit"];
               if (AnzahlRichtige)
               {
                  [tempErgebnisDic setObject: [NSNumber numberWithFloat:(ZeitBedarf/AnzahlRichtige)] forKey:@"mittel"];
               }
               else
               {
                  [tempErgebnisDic setObject: [NSNumber numberWithFloat:0.0] forKey:@"mittel"];
                  
               }
               if (noteString)//der User hat eine Note
               {
                  [tempErgebnisDic setObject: noteString forKey:@"note"];
               }
               [returnDicArrayVonTest addObject:tempErgebnisDic];
               index++;
            }//while
            //NSLog(@"ZeitDurchschnitt: %d  anzTestForUser: %d	Mittel: %d",(int)ZeitDurchschnitt,anzTestForUser,(int)(ZeitDurchschnitt/anzTestForUser));
            //NSLog(@"AnzDurchschnitt: %d	  Mittel: %d",(int)AnzDurchschnitt,(int)(AnzDurchschnitt/anzTestForUser));
            //NSLog(@"SetTable	User: %@ Anzahl: %d	  Zeit: %f  Mittel: %f",derName,AnzahlRichtige,ZeitBedarf,(ZeitBedarf/AnzahlRichtige));
            NSString* ZeitString=[NSString stringWithFormat:@"%1.1f",(ZeitBedarf/AnzahlRichtige)];
            //				[ZeitProAufgabeFeld setStringValue:ZeitString];
            
            
            //NSLog(@"reportTestnamen	TestDicArray: %@",[TestDicArray description]);
            
            
            
            
         }
         
      }//if DicArray count
      
      
   }//Name ist da
   
   return returnDicArrayVonTest;
}

- (void)setTableForAllTestsForUser:(NSString*)derName
{
   //	NSLog(@"setTableForAllTestsForUser: %@ ",derName);
   //[TestNamenPopKnopf selectItemWithTitle:derTest];
   //[TestTab selectTabViewItemAtIndex:0];
   float ZeitDurchschnitt=0;
   int anzTestForUser=0;
   float ZeitBedarf=0;
   int AnzahlRichtige=0;
   
   [TestDicArray removeAllObjects];//Datenquelle fuer TableView
   NSMutableArray* DicArrayVonTest=[[NSMutableArray alloc] initWithCapacity:0];
   //NSLog(@"reportTestnamen	AdminStatistikDicArray: %@",[AdminStatistikDicArray description]);
   //NSLog(@"reportTestnamen	StatistikDicArray: %@",[StatistikDicArray description]);
   NSArray* tempUserNamenArray=[AdminStatistikDicArray valueForKey:@"name"];//Liste der User
   NSUInteger index=[tempUserNamenArray indexOfObject:derName];
   if (index<NSNotFound)//Der Name ist da
   {
      
      [TestDicArray addObjectsFromArray:[self ErgebnisDicArrayForAllTestsForUser:derName]];
      
   }//Name ist da
   
   [ZeitProAufgabeFeld setStringValue:@""];
   [AnzahlFeld setStringValue:@""];
   [MaxZeitFeld setStringValue:@""];
   [StatistikTable reloadData];
   
}

- (NSArray*)ErgebnisDicArrayForAllTestsForUser: (NSString*)derUser
{
   float ZeitDurchschnitt=0;
   int anzTestForUser=0;
   float ZeitBedarf=0;
   int AnzahlRichtige=0;
   
   //	NSMutableArray* DicArrayVonTest=[[NSMutableArray alloc] initWithCapacity:0];//Array fuer Dics des Users
   
   //ReturnArray fuer Dics des Users
   NSMutableArray* returnErgebnisForTestDicArray=[[NSMutableArray alloc]initWithCapacity:0];
   
   
   anzTestForUser=0;
   ZeitDurchschnitt=0;
   ZeitBedarf=0.0;
   AnzahlRichtige=0;
   NSArray* tempUserNamenArray=[AdminStatistikDicArray valueForKey:@"name"];//Liste der User
   NSUInteger index=[tempUserNamenArray indexOfObject:derUser];
   if (index<NSNotFound)//Der Name ist da
   {
      NSString* noteString=[[AdminStatistikDicArray objectAtIndex:index]objectForKey:@"note"];
      //NSLog(@"setTableVonTestForUser: %@	note: %@",derName,noteString);
      [NoteCombo setStringValue:@""];
      if (noteString)
      {
         //NSLog(@"TestDicArray for tempName: %@	: %@",tempName,[TestDicArray description]);
         [NoteCombo setStringValue:noteString];
      }
      
      NSArray* tempErgebnisDicArray=[[AdminStatistikDicArray objectAtIndex:index]objectForKey:@"ergebnisdicarray"];
      
      
      NSSortDescriptor* Sorter=[[NSSortDescriptor alloc]initWithKey:@"datum" ascending:NO];
      NSArray* SorterArray=[NSArray arrayWithObjects:Sorter,nil];
      NSArray* tempsortedErgebnisDicArray=[tempErgebnisDicArray sortedArrayUsingDescriptors:SorterArray];
      
      
      
      
      //NSLog(@"Index: %d	tempErgebnisDicArray: %@",index,[tempErgebnisDicArray description]);
      if ([tempsortedErgebnisDicArray count])//es hat Ergebnisse
      {
         NSMutableArray* tempTestNamenarray=(NSMutableArray*)[TestNamenPopKnopf itemTitles];//Liste der vorhandenen Tests
         [tempTestNamenarray removeObjectAtIndex:[TestNamenPopKnopf numberOfItems]-1];
         //		NSLog(@"	tempTestNamenarray: %@",[tempTestNamenarray description]);
         NSEnumerator* TestNamenEnum=[tempTestNamenarray objectEnumerator];
         id einTestName;
         while (einTestName=[TestNamenEnum nextObject])
         {
            //Sammelarray fuer Test einTestName
            NSMutableArray* tempErgebnisForTestDicArray=[[NSMutableArray alloc]initWithCapacity:0];
            
            NSMutableDictionary* tempTestNameDic=[[NSMutableDictionary alloc]initWithCapacity:0];
            
            NSEnumerator* ErgebnisEnum=[tempsortedErgebnisDicArray objectEnumerator];
            id einErgebnisDic;
            
            while (einErgebnisDic=[ErgebnisEnum nextObject])//Ergebnisse fuer einTestName suchen und sortieren
            {
               
               if ([[einErgebnisDic objectForKey:@"testname"]isEqualToString:einTestName])
               {
                  [einErgebnisDic setObject:[NSNumber numberWithInt:1]forKey:@"art"];//Datenzeile
                  [tempErgebnisForTestDicArray addObject:einErgebnisDic];
                  
               }
               
               
            }//whileErgebnisEnum
            
            if ([tempErgebnisForTestDicArray count])//Es hat Ergebnisse für den Test einTestName
            {
               //
               //					NSLog(@"Ergebnisdicarray object 0: %@",[[tempErgebnisForTestDicArray objectAtIndex:0] description]);
               [tempTestNameDic setObject:@"Test:" forKey:@"datumtext"];
               [tempTestNameDic setObject:@"" forKey:@"zeit"];
               [tempTestNameDic setObject:[NSNumber numberWithInt:0] forKey:@"anzfehler"];
               [tempTestNameDic setObject:einTestName forKey:@"nametext"];
               
               
               [tempTestNameDic setObject:[NSNumber numberWithInt:4]forKey:@"art"];//TestNamenzeile
               NSString* AnzAufgabenString=[[tempErgebnisForTestDicArray objectAtIndex:0] objectForKey:@"anzahlaufgaben"];
               [tempTestNameDic setObject: [[tempErgebnisForTestDicArray objectAtIndex:0] objectForKey:@"anzahlaufgaben"] forKey:@"anzaufgaben"];
               NSString* MaxZeitString=[[tempErgebnisForTestDicArray objectAtIndex:0] objectForKey:@"maximalzeit"];
               //					NSLog(@"AnzAufgabenString: %@ MaxZeitString: %@",AnzAufgabenString,MaxZeitString);
               
               [tempTestNameDic setObject: [[tempErgebnisForTestDicArray objectAtIndex:0] objectForKey:@"maximalzeit"] forKey:@"maxzeit"];
               NSString* TestDatenString=[NSString stringWithFormat: @"%@       %@ Aufgaben    %@s",einTestName,AnzAufgabenString,MaxZeitString];
               //					NSLog(@"TestDatenString: %@",TestDatenString);
               [tempTestNameDic setObject:TestDatenString forKey:@"grafikdatentext"];
               
               if (noteString)//der User hat eine Note
               {
                  [tempTestNameDic setObject: noteString forKey:@"note"];
               }
               
               
               //Mittel berechnen
               int anzahlaufgaben=0;
               int maximalzeit=0;
               int abgelaufenezeit=0.0;
               int anzrichtig=0;
               
               
               NSMutableArray* tempTestDicArray=[[NSMutableArray alloc]initWithCapacity:0];
               
               
               NSEnumerator* MittelwertEnum=[tempErgebnisForTestDicArray objectEnumerator];
               id einDic;
               int index=0;
               int anzZeigen=[[AnzahlForNameZeigenPopKnopf selectedItem]tag];
               
               while ((einDic=[MittelwertEnum nextObject])&&(index<anzZeigen))
               {
                  //Dic fuer Daten des Tests
                  NSMutableDictionary* tempErgebnisDic=[[NSMutableDictionary alloc]initWithCapacity:0];
                  
                  if (index==0)//erste Zeile fuer Test einTestName
                  {
                     anzahlaufgaben=[[einDic objectForKey:@"anzahlaufgaben"]intValue];
                     maximalzeit=[[einDic objectForKey:@"maximalzeit"]intValue];
                     [tempErgebnisDic setObject: [NSNumber numberWithInt:1] forKey:@"art"];
                     //					[tempErgebnisDic setObject: einTestName forKey:@"nametext"];
                     
                  }
                  else
                  {
                     [tempErgebnisDic setObject: [NSNumber numberWithInt:2] forKey:@"art"];
                  }
                  abgelaufenezeit=[[einDic objectForKey:@"abgelaufenezeit"]intValue];
                  anzrichtig=[[einDic objectForKey:@"anzrichtig"]intValue];
                  AnzahlRichtige+=anzrichtig;
                  ZeitBedarf+=abgelaufenezeit;
                  
                  [tempErgebnisDic setObject: [einDic objectForKey:@"abgelaufenezeit"] forKey:@"zeit"];
                  NSCalendarDate* tempDate=[[NSCalendarDate alloc]initWithString:[[einDic objectForKey:@"datum"]description]];
                  //NSLog(@"reportTestnamen	tempDate: %@",[tempDate description]);
                  if (tempDate)
                  {
                     int test=[[NSCalendarDate calendarDate] dayOfMonth];
                     //NSLog(@"Heute ganz: %@ test heute: %d",[NSCalendarDate calendarDate],test);
                     int tag=[tempDate dayOfMonth];
                     int monat=[tempDate monthOfYear];
                     int jahr=[tempDate yearOfCommonEra];
                     NSString* JahrString=[[NSNumber numberWithInt:jahr]stringValue];
                     JahrString=[JahrString substringFromIndex:2];
                     NSString* Tag=[NSString stringWithFormat:@"%d.%d.%@",tag,monat,JahrString];
                     [tempErgebnisDic setObject:Tag forKey:@"datumtext"];
                     [tempErgebnisDic setObject:[einDic objectForKey:@"datum"] forKey:@"datum"];
                     //NSLog(@"reportTestnamen: %@  Tag: %@",tempDate,Tag);
                  }
                  [tempErgebnisDic setObject: [einDic objectForKey:@"anzfehler"] forKey:@"anzfehler"];
                  [tempErgebnisDic setObject: [einDic objectForKey:@"anzahlaufgaben"] forKey:@"anzaufgaben"];
                  [tempErgebnisDic setObject: [einDic objectForKey:@"anzrichtig"] forKey:@"anzrichtig"];
                  [tempErgebnisDic setObject: [einDic objectForKey:@"maximalzeit"] forKey:@"maxzeit"];
                  [tempTestDicArray addObject:tempErgebnisDic];
                  //					NSLog(@"ErgebnisDicArrayForAllTestsForUser: index: %d	tempErgebnisDic: %@",index,[tempErgebnisDic description]);
                  index++;
               }//while
               //					NSLog(@"ErgebnisDicArrayForAllTestsForUser: 	tempTestDicArray: %@",[tempTestDicArray description]);
               
               //NSLog(@"ZeitDurchschnitt: %d  anzTestForUser: %d	Mittel: %d",(int)ZeitDurchschnitt,anzTestForUser,(int)(ZeitDurchschnitt/anzTestForUser));
               //NSLog(@"AnzDurchschnitt: %d	  Mittel: %d",(int)AnzDurchschnitt,(int)(AnzDurchschnitt/anzTestForUser));
               //NSLog(@"SetTable	User: %@ Anzahl: %d	  Zeit: %f  Mittel: %f",derName,AnzahlRichtige,ZeitBedarf,(ZeitBedarf/AnzahlRichtige));
               
               
               if(AnzahlRichtige)
               {
                  NSString* ZeitString=[NSString stringWithFormat:@"%1.1f",(ZeitBedarf/AnzahlRichtige)];
                  [tempTestNameDic setObject:ZeitString forKey:@"mittel"];
                  
               }
               //End Mittel berechnen
               //				NSString* TestTitel=[NSString stringWithFormat:@"%@		Mittel: %@",einTestName,ZeitString];
               NSString* TestTitel=[NSString stringWithFormat:@"%@	",einTestName];
               
               [tempTestNameDic setObject:TestTitel forKey:@"grafiktext"];
               //				NSLog(@"All: TestTitel: %@",TestTitel);
               [returnErgebnisForTestDicArray addObject:tempTestNameDic];
               
               //	7.11.				NSSortDescriptor* Sorter=[[NSSortDescriptor alloc]initWithKey:@"datum" ascending:NO];
               //					NSArray* SorterArray=[NSArray arrayWithObjects:Sorter,nil];
               //					NSArray* tempsortedErgebnisDicArray=[tempTestDicArray sortedArrayUsingDescriptors:SorterArray];
               
               // 7.11.			[returnErgebnisForTestDicArray addObjectsFromArray:tempsortedErgebnisDicArray];
               [returnErgebnisForTestDicArray addObjectsFromArray:tempTestDicArray];
               
               NSMutableDictionary* tempAbstandDic=[[NSMutableDictionary alloc]initWithCapacity:0];
               [tempAbstandDic setObject:[NSNumber numberWithInt:0]forKey:@"art"];
               [tempAbstandDic setObject:@"" forKey:@"datumtext"];
               [tempAbstandDic setObject:@"" forKey:@"zeit"];
               [tempAbstandDic setObject:[NSNumber numberWithInt:0] forKey:@"anzfehler"];
               
               [returnErgebnisForTestDicArray addObject:tempAbstandDic];
               
            }//tempErgebnisForTestDicArray count
         }//while TestNamenEnum
         
         
         
         //			NSLog(@"SetTableForAllTestsForUser Ende:     returnErgebnisForTestDicArray: %@",[returnErgebnisForTestDicArray description]);
         
      }//if DicArray count
   }//if index
   return returnErgebnisForTestDicArray;
}

- (NSString*)TestNamen
{
   return [TestNamenPopKnopf titleOfSelectedItem];
}

- (void)setBenutzerPop:(NSArray*)derBenutzerArray
{
   [NamenPopMenu setHidden:NO];
   [NamenFeld setHidden:YES];
   [NamenPopMenu removeAllItems];
   [NamenPopMenu addItemsWithTitles:derBenutzerArray];
}

- (void)setBenutzer:(NSString*)derBenutzer
{
   [NamenPopMenu setHidden:YES];
   [NamenFeld setHidden:NO];
   [NamenFeld setStringValue:derBenutzer];
}

- (void)selectBenutzer:(NSString*)derBenutzer
{
   [NamenPopMenu selectItemWithTitle:derBenutzer];
}

- (void)setAdminOK:(BOOL)derStatus
{
   AdminOK=derStatus;
   [AnzahlForNameZeigenPopKnopf setEnabled:derStatus];
   if (derStatus)
   {
      [StatistikTab selectTabViewItemAtIndex:1];
   }
   else
   {
      [StatistikTab selectTabViewItemAtIndex:0];
   }
}

- (BOOL)AdminOK
{
   return AdminOK;
}

- (void)setAdminTestNamenPop:(NSArray*)derTestArray
{
   AdminOK=YES;
   [TestNamenPopKnopf removeAllItems];
   [AdminTestNamenPopKnopf removeAllItems];
   //NSLog(@"setAdminTestNamenPop: %@",[derTestArray description]);
   //NSLog(@"AdminStatistikDicArray: %@",[AdminStatistikDicArray description]);
   
   [AdminTestNamenPopKnopf addItemsWithTitles:derTestArray];
   //[AdminTestNamenPopKnopf removeItemWithTitle:@"Training"];
   if ([AdminStatistikDicArray count])
   {
      //NSLog(@"vor BenutzerTestArray");
      NSArray* BenutzerTestArray=[AdminStatistikDicArray valueForKey:@"testname"];
      
      if ([BenutzerTestArray count])
      {
         
         NSEnumerator* ItemEnum=[derTestArray objectEnumerator];
         id einItem;
         while (einItem=[ItemEnum nextObject])
         {
            //NSLog(@"setTestPop: einItem: %@",einItem );
            //if (!([einItem isEqualToString:@"Training"]))
            {
               //					if ([BenutzerTestArray containsObject:einItem])//Der Benutzer hat Ergebnisse zu diesem Test
               {
                  [TestNamenPopKnopf addItemWithTitle:einItem];
                  [AdminTestNamenPopKnopf addItemWithTitle:einItem];
                  
               }
            }
         }//while
         
         if ([AdminTestNamenPopKnopf numberOfItems]>1)
         {
            //			NSLog(@"setAdminTestNamenPop: mehr als ein Item: anz: %d",[AdminTestNamenPopKnopf numberOfItems]);
            [AdminTestNamenPopKnopf addItemWithTitle:@"Alle"];
            [TestNamenPopKnopf addItemWithTitle:@"Alle"];
            
         }
         
      }//if BenutzerTestArray count
      else
      {
         NSLog(@"Kein Testname");
         [AdminTestNamenPopKnopf addItemWithTitle:@"Keine Ergebnisse"];
         
      }
      //NSLog(@"setAdminTestNamenPop:3");
      NSArray* tempDicArray=[self ErgebnisDicArrayForTest:[[AdminTestNamenPopKnopf itemAtIndex:0]title]];
      //NSLog(@"Statistik	setAdminTestNamenPop Test: %@  tempDicArray: %@",[[AdminTestNamenPopKnopf itemAtIndex:0]title],[tempDicArray description]);
      
      //NSLog(@"setAdminTestNamenPop:4");
      [DatenQuelle setAdminStatistikDicArray:tempDicArray];
      //NSLog(@"setAdminTestNamenPop:5");
   }//if StatistikDicArray count
   //NSLog(@"setAdminTestNamenPop:6");
   
}


- (void)setTestPopMitStringArray:(NSArray*)derTestStringArray
{
   [TestNamenPopKnopf removeAllItems];
   //NSLog(@"setTestPopMitStringArray: %@",[derTestStringArray description]);
   if ([StatistikDicArray count])
   {
      NSArray* BenutzerTestArray=[StatistikDicArray valueForKey:@"testname"];
      //NSLog(@"setTestPopMitStringArray	BenutzerTestArray: %@",[BenutzerTestArray description]);
      if ([BenutzerTestArray count])
      {
         
         NSEnumerator* ItemEnum=[derTestStringArray objectEnumerator];
         id einItem;
         while (einItem=[ItemEnum nextObject])
         {
            //NSLog(@"setTestPop: einItem: %@",einItem);
            if (!([einItem isEqualToString:@"Training"]))
            {
               if ([BenutzerTestArray containsObject:einItem ])//Der Benutzer hat Ergebnisse zu diesem Test
               {
                  //NSLog(@"setTestPop: einItem da: %@",einItem);
                  
                  [TestNamenPopKnopf addItemWithTitle:einItem ];
               }
            }
         }//while
         
         //			NSLog(@"setTestPopMitStringArray	TestNamenPopKnopf itemArray: %@",[[TestNamenPopKnopf itemArray]description]);
         if ([TestNamenPopKnopf numberOfItems])
         {
            if (AdminOK)
            {
               [TestNamenPopKnopf addItemWithTitle:@"alle" ];
            }
            //NSLog(@"setTestPopMitStringArray: setTableVonTest: %@",[[TestNamenPopKnopf itemAtIndex:0]title]);
            [self setTableVonTest:[[TestNamenPopKnopf itemAtIndex:0]title]];
            
         }
         //NSLog(@"setTestPop Schluss");
         
      }//if BenutzerTestArray count
      else
      {
         [TestNamenPopKnopf addItemWithTitle:@"Keine Ergebnisse"];
         
      }
      
   }//if StatistikDicArray count
   
}

- (void)setTestPopForAdminMitStringArray:(NSArray*)derTestStringArray
{
   [TestNamenPopKnopf removeAllItems];
   //NSLog(@"setTestPopMitStringArray: %@",[derTestStringArray description]);
   if ([AdminStatistikDicArray count])
   {
      NSArray* BenutzerTestArray=[AdminStatistikDicArray valueForKey:@"testname"];
      if ([BenutzerTestArray count])
      {
         
         NSEnumerator* ItemEnum=[derTestStringArray objectEnumerator];
         id einItem;
         while (einItem=[ItemEnum nextObject])
         {
            //NSLog(@"setTestPop: einItem: %@",einItem);
            if (!([einItem isEqualToString:@"Training"]))
            {
               if ([BenutzerTestArray containsObject:einItem ])//Der Benutzer hat Ergebnisse zu diesem Test
               {
                  [TestNamenPopKnopf addItemWithTitle:einItem ];
               }
            }
         }//while
         if ([TestNamenPopKnopf numberOfItems])
         {
            
            //NSLog(@"setTestPopForAdminMitStringArray 1");
            [self setTableVonTest:[[TestNamenPopKnopf itemAtIndex:0]title]];
            //NSLog(@"setTestPopForAdminMitStringArray 2");
         }
         
         if ([TestNamenPopKnopf numberOfItems]>1)
         {
            //NSLog(@"setTestPopForAdminMitStringArray: mehr als ein Item: anz: %d",[TestNamenPopKnopf numberOfItems]);
            [TestNamenPopKnopf addItemWithTitle:@"Alle"];
         }
         //[TestNamenPopKnopf addItemsWithTitles:[derTestArray copy]];
         //NSLog(@"setTestPop Schluss");
      }//if BenutzerTestArray count
      else
      {
         [TestNamenPopKnopf addItemWithTitle:@"Keine Ergebnisse"];
         
      }
   }//if StatistikDicArray count
   
}

- (void)setStatistikDicArray:(NSArray*)derDicArray
{
   //[StatistikDicArray removeAllObjects];
   if (AdminOK)
   {
      [TestTab selectTabViewItemAtIndex:1];
   }
   else
   {
      
      [TestTab selectTabViewItemAtIndex:0];
   }
   [NoteLabel setHidden:YES];
   [NoteCombo setHidden:YES];
   StatistikDicArray=(NSMutableArray*)derDicArray;
   //AdminStatistikDicArray=(NSMutableArray*)derDicArray;
   [TestTable reloadData];
   //NSLog(@"setStatistikDicArray: %@",[StatistikDicArray description]);
   [PrintTaste setEnabled:AdminOK];
   [mitNoteCheck setEnabled:NO];
}


- (void)setAdminStatistikDicArray:(NSArray*)derAdminStatistikDicArray mitSessionDatum:(NSDate*)dasDatum
{
   
   SessionDatum=dasDatum;
   //NSLog(@"\n\nsetAdminStatistikDicArray");
   //NSLog(@"Statistik	setAdminStatistikDicArray SessionDatum: %@",SessionDatum);
   
   
   AdminStatistikDicArray=derAdminStatistikDicArray;
   //NSLog(@"Statistik	setAdminStatistikDicArray: Count: %d",[derAdminStatistikDicArray count]);
   [PrintTaste setEnabled:YES];
   [mitNoteCheck setEnabled:YES];
   
}

- (NSArray*)ErgebnisDicArrayForAllTests
{
   NSMutableArray* tempTestListe=(NSMutableArray*)[AdminTestNamenPopKnopf itemTitles];
   [tempTestListe removeObject:@"alle"];
   //NSLog(@"ErgebnisDicArrayForAllTests tempTestListe: %@",[tempTestListe description]);
   NSMutableArray* tempReturnArray=[[NSMutableArray alloc]initWithCapacity:0];
   NSEnumerator* TestListeEnum=[tempTestListe objectEnumerator];
   id einTest;
   while (einTest=[TestListeEnum nextObject])
   {
      NSArray* tempTestArray=[self ErgebnisDicArrayForTest:einTest];
      if ([tempTestArray count])
      {
         NSMutableDictionary* TestTitelDic=[[NSMutableDictionary alloc]initWithCapacity:0];
         [TestTitelDic setObject:[NSNumber numberWithInt:4] forKey:@"art"];//TestTitelzeile
         [TestTitelDic setObject:einTest forKey:@"name"];
         [TestTitelDic setObject:einTest forKey:@"nametext"];
         [TestTitelDic setObject:@"" forKey:@"zeit"];
         [TestTitelDic setObject:@"" forKey:@"anzfehler"];
         [TestTitelDic setObject:@"" forKey:@"grafik"];
         [TestTitelDic setObject:@"" forKey:@"note"];
         [TestTitelDic setObject:@"" forKey:@"anzrichtig"];
         [TestTitelDic setObject:@"" forKey:@"anzaufgaben"];
         [TestTitelDic setObject:@"" forKey:@"modus"];
         [TestTitelDic setObject:@"" forKey:@"testname"];
         [TestTitelDic setObject:@"" forKey:@"maxzeit"];
         [TestTitelDic setObject:@"Test:" forKey:@"datum"];
         [TestTitelDic setObject:@"Test:" forKey:@"datumtext"];
         
         //		NSLog(@"ErgebnisDicArrayForAllTests         [tempTestArray objectAtIndex:0]: %@ \n",[[tempTestArray objectAtIndex:0] description]);
         NSString* AnzAufgabenString=[[tempTestArray objectAtIndex:0] objectForKey:@"anzaufgaben"];
         
         NSString* MaxZeitString=[[tempTestArray objectAtIndex:0] objectForKey:@"maxzeit"];
         //		NSLog(@"AnzAufgabenString: %@ MaxZeitString: %@",AnzAufgabenString,MaxZeitString);
         
         NSString* TestDatenString=[NSString stringWithFormat: @"%@ Aufgaben     %@s",AnzAufgabenString,MaxZeitString];
         //		NSLog(@"ErgebnisDicArrayForAllTests TestDatenString: %@",TestDatenString);
         [TestTitelDic setObject:TestDatenString forKey:@"grafikdatentext"];
         [TestTitelDic setObject:TestDatenString forKey:@"grafiktext"];
         
         //		NSLog(@"ErgebnisDicArrayForAllTests         TestTitelDic: %@ \n",[TestTitelDic description]);
         [tempReturnArray addObject:TestTitelDic];
         [tempReturnArray addObjectsFromArray:tempTestArray];
      }
      
   }//while
   //	NSLog(@"tempReturnArray: %@ ",[tempReturnArray description]);
   
   return tempReturnArray;
}


- (NSArray*)ErgebnisDicArrayForTest:(NSString*)derTest
{
   NSEnumerator* DicEnum=[AdminStatistikDicArray objectEnumerator];
   id einDic;
   NSMutableArray* returnErgebnisDicArray=[[NSMutableArray alloc]initWithCapacity:0];
   float ZeitDurchschnitt=0;
   float ZeitVonAllenDurchschnitt=0;
   float AnzDurchschnitt=0;
   float AnzVonAllenDurchschnitt=0;
   float BestMarke=120;
   float GesamtBestMarke=120;
   int anzTestForUser=0;
   int AnzTest=0;
   int GesamtAnzTest=0;
   float ZeitBedarf=0;
   float ZeitBedarfVonAllen=0;
   int AnzahlRichtige=0;
   int AnzahlvonAllenRichtige=0;
   NSString* note=@"";
   
   
   NSMutableDictionary* HeaderDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   
   [HeaderDic setObject:@"Name" forKey:@"name"];
   [HeaderDic setObject:@"Name" forKey:@"nametext"];
   [HeaderDic setObject:@"Zeit" forKey:@"zeit"];
   [HeaderDic setObject:@"Fehler" forKey:@"anzfehler"];
   [HeaderDic setObject:@"Grafik" forKey:@"grafik"];
   [HeaderDic setObject:@"Note" forKey:@"note"];
   [HeaderDic setObject:@"" forKey:@"anzrichtig"];
   [HeaderDic setObject:@"" forKey:@"anzaufgaben"];
   [HeaderDic setObject:@"" forKey:@"modus"];
   [HeaderDic setObject:@"" forKey:@"testname"];
   [HeaderDic setObject:@"" forKey:@"maxzeit"];
   [HeaderDic setObject:@"Datum" forKey:@"datum"];
   //NSLog(@"HeaderDic: einDic: %@ ",[HeaderDic description]);
   //[returnErgebnisDicArray addObject:HeaderDic];
   
   while (einDic=[DicEnum nextObject])
   {
      BOOL sessionOK=NO;
      NSString* tempUserName=[einDic objectForKey:@"name"];
      //NSLog(@"User: %@	ErgebnisDicArrayVonTest: derTest: %@",tempUserName, derTest);
      //		NSLog(@"User: %@	ErgebnisDicArrayVonTest: einDic: %@ derTest: %@",tempUserName,[einDic description], derTest);
      NSArray* tempErgebnisDicArray=[einDic objectForKey:@"ergebnisdicarray"];
      NSMutableArray* tempReturnErgebnisDicArray=[[NSMutableArray alloc]initWithCapacity:0];
      NSString* tempName=[NSString string];
      if (tempErgebnisDicArray)
      {
         if ([tempErgebnisDicArray count])//es hat Ergebnisse für den Namen
         {
            if ([einDic objectForKey:@"note"])
            {
               //NSLog(@"ErgebnisDicArraqyVonTest A	Name: %@	note: %@",[einDic objectForKey:@"name"],[einDic objectForKey:@"note"]);
               note=[einDic objectForKey:@"note"];
            }
            else
            {
               note=@"";
            }
            
            if ([einDic objectForKey:@"lastdate"])
            {
               //NSLog(@"Name: %@		lastdate: %@",tempUserName,[einDic objectForKey:@"lastdate"]);
               NSDate* tempDatum=[einDic objectForKey:@"lastdate"];
               if ([tempDatum compare:SessionDatum]== NSOrderedDescending)//lastDate ist nach SessionDatum
               {
                  sessionOK=YES;
               }
               else
               {
                  sessionOK=NO;
                  
               }
               
            }
            
            NSSortDescriptor* Sorter=[[NSSortDescriptor alloc]initWithKey:@"datum" ascending:NO];
            NSArray* SorterArray=[NSArray arrayWithObjects:Sorter,nil];
            
            tempErgebnisDicArray=[tempErgebnisDicArray sortedArrayUsingDescriptors:SorterArray];
            
            int AnzTest=[tempErgebnisDicArray count];
            //NSLog(@"ErgebnisDicArrayVonTest: AnzTest: %d",AnzTest);
            NSEnumerator* TestEnum=[tempErgebnisDicArray objectEnumerator];
            id einTestDic;
            anzTestForUser=0;
            
            ZeitDurchschnitt=0;
            ZeitVonAllenDurchschnitt=0;
            AnzDurchschnitt=0;
            AnzVonAllenDurchschnitt=0;
            BestMarke=120;
            GesamtBestMarke=120;
            
            ZeitBedarf=0.0;
            ZeitBedarfVonAllen=0.0;
            AnzahlRichtige=0;
            AnzahlvonAllenRichtige=0;
            
            /*
             2006-04-06 17:01:04.029 SndCalcII[992] ErgebnisDicArrayVonTest einTestDic: {
             abgelaufenezeit = 120;
             anzahlaufgaben = 12;
             anzfehler = 2;
             anzrichtig = 3;
             datum = 2006-04-03 14:40:28 +0200;
             maximalzeit = 120;
             modus = 1;
             testname = "3/6/9 12A/120s";
             */
            
            while (einTestDic=[TestEnum nextObject])
            {
               //					NSLog(@"einTestDic: %@",[einTestDic description]);
               BOOL TestAktiv=YES;
               NSMutableDictionary* tempErgebnisDic=[[NSMutableDictionary alloc]initWithCapacity:0];
               [tempErgebnisDic setObject:[NSNumber numberWithInt:0] forKey:@"art"];//Leerzeile
               int anzahlaufgaben=[[einTestDic objectForKey:@"anzahlaufgaben"]intValue];
               int maximalzeit=[[einTestDic objectForKey:@"maximalzeit"]intValue];
               
               int abgelaufenezeit=[[einTestDic objectForKey:@"abgelaufenezeit"]intValue];
               int anzrichtig=[[einTestDic objectForKey:@"anzrichtig"]intValue];
               AnzahlvonAllenRichtige+=anzrichtig;
               ZeitBedarfVonAllen+=abgelaufenezeit;
               if (anzrichtig)
               {
                  ZeitVonAllenDurchschnitt+=(abgelaufenezeit/anzrichtig*anzahlaufgaben);
                  AnzVonAllenDurchschnitt+=anzrichtig/anzrichtig*anzahlaufgaben;
               }
               
               
               GesamtAnzTest++;
               if (abgelaufenezeit<GesamtBestMarke)
               {
                  GesamtBestMarke=abgelaufenezeit;
               }
               
               if([einDic objectForKey:@"aktiv"])
               {
                  TestAktiv=[[einDic objectForKey:@"aktiv"]boolValue];
               }
               if ([[einTestDic objectForKey:@"testname"] isEqualToString:derTest]&&TestAktiv)//der Test hat Ergebnisse
               {
                  
                  if (anzTestForUser==0)//erste Zeile
                  {
                     
                     if ([note length])//Note in erste Zeile setzen
                     {
                        //NSLog(@"if ([note length]) Einsetzen: Name: %@	note: %@",[einDic objectForKey:@"name"],[einDic objectForKey:@"note"]);
                        [tempErgebnisDic setObject:note forKey:@"note"];
                     }
                     else
                     {
                        [tempErgebnisDic setObject:@"" forKey:@"note"];
                     }
                  }
                  
                  if ([MittelwertOptionRadio selectedRow]==0)//Mittel von allen Tests
                  {
                     ZeitDurchschnitt+=abgelaufenezeit;
                     AnzDurchschnitt+=anzrichtig;
                     AnzahlRichtige+=anzrichtig;
                     ZeitBedarf+=abgelaufenezeit;
                     
                  }
                  else
                  {
                     if ((anzTestForUser<[[AnzahlZeigenPopKnopf selectedItem]tag])||([[AnzahlZeigenPopKnopf selectedItem]tag]==0))//
                     {
                        //Anzahl zu berücksichtigende Tests ist noch nicht erreicht ODER es sollen nur Tests derSession gezählt werden
                        ZeitDurchschnitt+=abgelaufenezeit;
                        AnzDurchschnitt+=anzrichtig;
                        AnzahlRichtige+=anzrichtig;
                        ZeitBedarf+=abgelaufenezeit;
                     }
                     
                     
                  }
                  
                  NSDate* TestDatum=[einTestDic objectForKey:@"datum"];
                  
                  
                  BOOL TestSessionOK=([TestDatum compare:SessionDatum]== NSOrderedDescending);//testdatum ist nach SessionDatum
                  
                  //NSLog(@"Name: %@	Testdatum: %@	sessionOK: %d	TestSessionOK: %d",tempUserName,TestDatum,sessionOK,TestSessionOK);
                  
                  if ((sessionOK && TestSessionOK && ([[AnzahlZeigenPopKnopf selectedItem]tag]==0))//Datum des Tests in Session
                      || (anzTestForUser<[[AnzahlZeigenPopKnopf selectedItem]tag]))
                  {
                     //(Test ist nach dem SessionDatum datiert  UND Session anzeigen) ODER anztest kleiner als eingestellte Anzahl
                     //NSLog(@"ErgebnisDicArrayVonTest einTestDic: %@",[einTestDic description]);
                     //NSMutableDictionary* tempErgebnisDic=[[[NSMutableDictionary alloc]initWithCapacity:0];
                     //NSLog(@"Name einsetzen: %@",[einDic objectForKey:@"name"]);
                     if (anzTestForUser==0)//erste Zeile
                     {
                        [tempErgebnisDic setObject:[NSNumber numberWithInt:1] forKey:@"art"];//NamenZeile
                     }
                     else
                     {
                        [tempErgebnisDic setObject:[NSNumber numberWithInt:2] forKey:@"art"];//DatenZeile
                     }
                     //NSLog(@"Ergebnisdicarrayfortest:4");
                     [tempErgebnisDic setObject:[einDic objectForKey:@"name"] forKey:@"name"];
                     //NSLog(@"ErgebnisDicArray			vor	Nametext eingesetzt");
                     
                     
                     if ([[einDic objectForKey:@"name"]length]&&[[einDic objectForKey:@"name"]isEqualToString:tempName])//Name kam schon einmal vor
                     {
                        [tempErgebnisDic setObject:@" " forKey:@"nametext"];
                     }
                     else
                     {
                        [tempErgebnisDic setObject:[einDic objectForKey:@"name"] forKey:@"nametext"];//Namen einsetzen
                        tempName=[einDic objectForKey:@"name"];
                     }
                     
                     
                     //[tempErgebnisDic setObject:[einDic objectForKey:@"nametext"] forKey:@"nametext"];
                     //NSLog(@"Ergebnisdicarrayfortest:5");
                     
                     [tempErgebnisDic setObject:[einTestDic objectForKey:@"abgelaufenezeit"] forKey:@"zeit"];
                     [tempErgebnisDic setObject:[einTestDic objectForKey:@"anzfehler"] forKey:@"anzfehler"];
                     [tempErgebnisDic setObject:[einTestDic objectForKey:@"maximalzeit"] forKey:@"maxzeit"];
                     
                     [tempErgebnisDic setObject:[einTestDic objectForKey:@"anzrichtig"] forKey:@"anzrichtig"];
                     [tempErgebnisDic setObject:[einTestDic objectForKey:@"anzahlaufgaben"] forKey:@"anzaufgaben"];
                     [tempErgebnisDic setObject:[einTestDic objectForKey:@"modus"] forKey:@"modus"];
                     [tempErgebnisDic setObject:[einTestDic objectForKey:@"testname"] forKey:@"testname"];
                     [tempErgebnisDic setObject:[einTestDic objectForKey:@"datum"] forKey:@"datum"];
                     if ([einTestDic objectForKey:@"datumtext"])
                     {
                        [tempErgebnisDic setObject:[einTestDic objectForKey:@"datumtext"] forKey:@"datumtext"];
                     }
                     [tempErgebnisDic setObject:[NSNumber numberWithBool:AdminOK] forKey:@"allezeigen"];
                     
                     //[tempErgebnisDic addEntriesFromDictionary:einTestDic];//Daten für den Test einsetzen
                     //Dic einsetzen
                     //NSLog(@"Dic einsetzen");
                     //							NSLog(@"ErgebnisDicArrayVonTest tempErgebnisDic: %@\n\n",[tempErgebnisDic description]);
                     
                     [tempReturnErgebnisDicArray addObject:tempErgebnisDic];
                     anzTestForUser++;
                  }
                  else
                  {
                     //						NSLog(@"Sessionkontrolle negativ");
                  }
                  
               }//if
               
               
            }//while einTestDic
            
            if (anzTestForUser>0) //weitere Zeilen
            {
               //NSLog(@"ZeitDurchschnitt: %d  anzTestForUser: %d	Mittel: %d",(int)ZeitDurchschnitt,anzTestForUser,(int)(ZeitDurchschnitt/anzTestForUser));
               //NSLog(@"AnzDurchschnitt: %d	  Mittel: %d",(int)AnzDurchschnitt,(int)(AnzDurchschnitt/anzTestForUser));
               //NSLog(@"ErgebnisDic	User: %@ Anzahl: %d	  Zeit: %f  Mittel: %f\n",tempUserName,AnzahlRichtige,ZeitBedarf,(ZeitBedarf/AnzahlRichtige));
               [ZeitProAufgabeFeld setFloatValue:(ZeitBedarf/AnzahlRichtige)];
               //Mittelwert in erste Zeile des Array
               [[tempReturnErgebnisDicArray objectAtIndex:0]setObject:[NSNumber numberWithFloat:(ZeitBedarf/AnzahlRichtige)] forKey:@"mittel"];
               //Anzahl Tests in erste Zeile
               [[tempReturnErgebnisDicArray objectAtIndex:0]setObject:[NSNumber numberWithInt:anzTestForUser] forKey:@"anztestforuser"];
               
            }
            
            //Leerzeile einfügen
            if ((anzTestForUser>0)&&([[AnzahlZeigenPopKnopf selectedItem]tag]>1))
            {
               
               NSMutableDictionary* tempAbstandDic=[[NSMutableDictionary alloc]initWithCapacity:0];
               //leerstellen einsetzen
               [tempAbstandDic setObject:[NSNumber numberWithInt:0] forKey:@"art"];//Abstandzeile
               [tempAbstandDic setObject:@"" forKey:@"name"];
               [tempAbstandDic setObject:@"" forKey:@"nametext"];
               [tempAbstandDic setObject:@"" forKey:@"zeit"];
               [tempAbstandDic setObject:@"" forKey:@"anzfehler"];
               [tempAbstandDic setObject:@"" forKey:@"maxzeit"];
               
               [tempAbstandDic setObject:@"" forKey:@"anzrichtig"];
               [tempAbstandDic setObject:@"" forKey:@"anzaufgaben"];
               [tempAbstandDic setObject:@"" forKey:@"modus"];
               [tempAbstandDic setObject:@"" forKey:@"testname"];
               [tempAbstandDic setObject:@"" forKey:@"datum"];
               //[tempAbstandDic setObject:@"" forKey:@"mittel"];
               //Dic einsetzen
               //NSLog(@"ErgebnisDicArrayVonTest tempAbstandDic: %@\n\n",[tempAbstandDic description]);
               
               //					[returnErgebnisDicArray addObject:tempAbstandDic];
               [tempReturnErgebnisDicArray addObject:tempAbstandDic];
            }
            
         }//if ([tempErgebnisDicArray count])
         if ([tempReturnErgebnisDicArray count])//Für den User hat es Dics
         {
            //NSLog(@"tempReturnErgebnisDicArray : %@\n\n",[tempReturnErgebnisDicArray description]);
            [returnErgebnisDicArray addObjectsFromArray:tempReturnErgebnisDicArray];
         }
         
         
      }//if tempErgebnisdicArray
      //		[ErgebnisDicArray addObject:tempergebnisDic];
   }//while
   //NSLog(@"end");
   return returnErgebnisDicArray;
}

- (void)keyDown:(NSEvent *)theEvent
{
   NSString* c=[theEvent characters];
   NSLog(@"Statistik keyDown: c: %@  code: %d modifier: %d ",c,[theEvent keyCode],[theEvent modifierFlags]);
}

- (void)reportPrint:(id)sender
{
   int index=[[[StatistikTab selectedTabViewItem]identifier]intValue];
   //NSLog(@"reportPrint: index: %d",index);
   [TestTable deselectAll:NULL];
   [DeleteTestKnopf setEnabled:NO];
   NSArray* tempChangedArray=[DatenQuelle NoteChangedDicArray];
   if ([tempChangedArray count])
   {
      [self updateAdminStatistikDicArrayMitNoteChangedArray:tempChangedArray];
   }
   
   switch (index)
   {
      case 1: //nach Namen
      {
         NSString* tempName=[NamenPopMenu titleOfSelectedItem];
         NSArray* tempTestNamenArray=[TestNamenPopKnopf itemTitles];
         //		NSLog(@"Statistik reportPrint nach Namen: %@ ItemTitles: %@ anz: %d index: %d",tempName,[tempTestNamenArray description],[tempTestNamenArray count],[AdminTestNamenPopKnopf indexOfSelectedItem]);
         
         if ([TestNamenPopKnopf indexOfSelectedItem]==[tempTestNamenArray count]-1)//alle
         {
            //		NSLog(@"Statistik reportPrint: alle drucken: %d",[tempTestNamenArray count]);
            NSArray* tempErgebnisDicArrayForAllTestsForUser=[self ErgebnisDicArrayForAllTestsForUser:tempName];
            [self printDicArrayForAllTests:tempErgebnisDicArrayForAllTestsForUser forUser:tempName];
            
         }
         else	//Nur von einem Test
         {
            
            NSArray* tempErgebnisDicArray=[self ErgebnisDicArrayForTest:[AdminTestNamenPopKnopf titleOfSelectedItem] forUser:tempName];
            
            [self printDicArray:tempErgebnisDicArray forTest:[AdminTestNamenPopKnopf titleOfSelectedItem] forUser:tempName];
         }
         
         
      }break;
         
      case 2://Nach Test
      {
         NSArray* tempTestNamenArray=[AdminTestNamenPopKnopf itemTitles];
         //	NSLog(@"Statistik reportPrint: ItemTitles nach Test: %@ anz: %d index: %d",[tempTestNamenArray description],[tempTestNamenArray count],[AdminTestNamenPopKnopf indexOfSelectedItem]);
         
         if ([AdminTestNamenPopKnopf indexOfSelectedItem]==[tempTestNamenArray count]-1)//alle
         {
            //		NSLog(@"Statistik reportPrint: alle drucken: %d",[tempTestNamenArray count]);
            NSArray* tempErgebnisDicArrayForAllTests=[self ErgebnisDicArrayForAllTests];
            [self printDicArray:tempErgebnisDicArrayForAllTests forTest:[AdminTestNamenPopKnopf titleOfSelectedItem]];
            
         }
         else	//Nur von einem Test
         {
            
            NSArray* tempErgebnisDicArray=[self ErgebnisDicArrayForTest:[AdminTestNamenPopKnopf titleOfSelectedItem]];
            
            [self printDicArray:tempErgebnisDicArray forTest:[AdminTestNamenPopKnopf titleOfSelectedItem]];
         }
      }break;//case 2
   }//switch index
}


- (void)printDicArray:(NSArray*)derDicArray forTest:(NSString*)derTest
{
   
   //NSTextView* DruckView=[[[NSTextView alloc]init]autorelease];
   //NSLog (@"Kommentar: printDicArray DicArray: %@",[derDicArray description]);
   NSPrintInfo* PrintInfo=[NSPrintInfo sharedPrintInfo];
   [PrintInfo setOrientation:NSPortraitOrientation];
   
   [PrintInfo setVerticalPagination: NSAutoPagination];
   
   [PrintInfo setHorizontallyCentered:NO];
   [PrintInfo setVerticallyCentered:NO];
   NSRect PageBounds=[PrintInfo imageablePageBounds];
   
   int x=PageBounds.origin.x;int y=PageBounds.origin.y;int h=PageBounds.size.height;int w=PageBounds.size.width;
   //NSLog(@"PageBounds 1 x: %d y: %d  h: %d  w: %d",x,y,h,w);
   //NSLog(@"PrintInfo leftMargin: %1.1f		topMargin: %1.2f",[PrintInfo leftMargin],[PrintInfo topMargin]);
   
   NSSize Papiergroesse=[PrintInfo paperSize];
   //NSLog(@"PrintInfo Papiergroesse w: %1.2f	h: %1.2f",Papiergroesse.width,Papiergroesse.height);
   int RandLinks=60;
   int RandOben=30;
   
   [PrintInfo setTopMargin:RandOben];
   [PrintInfo setLeftMargin:RandLinks];
   [PrintInfo setRightMargin:50];
   [PrintInfo setBottomMargin:50];
   
   int deltaLinks=0;
   int deltaOben=0;
   
   int leftRand=[PrintInfo leftMargin]+deltaLinks;//ev. groesser
   int topRand=[PrintInfo topMargin]+deltaOben;///ev. groesser
   int rightRand=[PrintInfo rightMargin];
   int bottomRand=[PrintInfo bottomMargin];
   
   //NSLog(@"PrintInfo leftMargin: %1.1f		topMargin: %1.2f",[PrintInfo leftMargin],[PrintInfo topMargin]);
   //NSLog(@"PrintInfo rightMargin: %1.1f		bottomMargin: %1.2f",[PrintInfo rightMargin],[PrintInfo bottomMargin]);
   
   int Papierbreite=(int)Papiergroesse.width;
   int Papierhoehe=(int)Papiergroesse.height;
   
   int DruckbereichH=Papiergroesse.width-(rightRand+leftRand);
   int DruckbereichV=Papiergroesse.height-(bottomRand+topRand);
   
   NSRect DruckFeld=NSMakeRect(leftRand, topRand, DruckbereichH, DruckbereichV);
   //Druckbereich mit linkem Rand + deltaLinks, oberem Rand + deltaOben
   //NSLog(@"Printinfo DruckFeld:	linkerRand: %d  obererRand: %d  Breite: %d Hoehe: %d",leftRand,rightRand, DruckbereichH,DruckbereichV);
   
   rDruckView* DruckView=[[rDruckView alloc]initWithFrame:DruckFeld];
   
   DruckView =[self setDruckViewMitDicArray:derDicArray forTest:derTest mitFeld:DruckFeld];
   
   
   
   //	[DruckView setBackgroundColor:[NSColor grayColor]];
   //	[DruckView setDrawsBackground:YES];
   NSPrintOperation* DruckOperation;
   DruckOperation=[NSPrintOperation printOperationWithView: DruckView
                                                 printInfo:PrintInfo];
   
   [DruckOperation setShowsPrintPanel:YES];
   [DruckOperation runOperation];
}

- (void)printDicArrayForAllTests:(NSArray*)derDicArray
{
   
   //NSTextView* DruckView=[[[NSTextView alloc]init]autorelease];
   //NSLog (@"Kommentar: printDicArray DicArray: %@",[derDicArray description]);
   NSPrintInfo* PrintInfo=[NSPrintInfo sharedPrintInfo];
   [PrintInfo setOrientation:NSPortraitOrientation];
   
   [PrintInfo setVerticalPagination: NSAutoPagination];
   
   [PrintInfo setHorizontallyCentered:NO];
   [PrintInfo setVerticallyCentered:NO];
   NSRect PageBounds=[PrintInfo imageablePageBounds];
   
   int x=PageBounds.origin.x;int y=PageBounds.origin.y;int h=PageBounds.size.height;int w=PageBounds.size.width;
   //NSLog(@"PageBounds 1 x: %d y: %d  h: %d  w: %d",x,y,h,w);
   //NSLog(@"PrintInfo leftMargin: %1.1f		topMargin: %1.2f",[PrintInfo leftMargin],[PrintInfo topMargin]);
   
   NSSize Papiergroesse=[PrintInfo paperSize];
   //NSLog(@"PrintInfo Papiergroesse w: %1.2f	h: %1.2f",Papiergroesse.width,Papiergroesse.height);
   int RandLinks=60;
   int RandOben=30;
   
   [PrintInfo setTopMargin:RandOben];
   [PrintInfo setLeftMargin:RandLinks];
   [PrintInfo setRightMargin:50];
   [PrintInfo setBottomMargin:50];
   
   int deltaLinks=0;
   int deltaOben=0;
   
   int leftRand=[PrintInfo leftMargin]+deltaLinks;//ev. groesser
   int topRand=[PrintInfo topMargin]+deltaOben;///ev. groesser
   int rightRand=[PrintInfo rightMargin];
   int bottomRand=[PrintInfo bottomMargin];
   
   //NSLog(@"PrintInfo leftMargin: %1.1f		topMargin: %1.2f",[PrintInfo leftMargin],[PrintInfo topMargin]);
   //NSLog(@"PrintInfo rightMargin: %1.1f		bottomMargin: %1.2f",[PrintInfo rightMargin],[PrintInfo bottomMargin]);
   
   int Papierbreite=(int)Papiergroesse.width;
   int Papierhoehe=(int)Papiergroesse.height;
   
   int DruckbereichH=Papiergroesse.width-(rightRand+leftRand);
   int DruckbereichV=Papiergroesse.height-(bottomRand+topRand);
   
   NSRect DruckFeld=NSMakeRect(leftRand, topRand, DruckbereichH, DruckbereichV);
   //Druckbereich mit linkem Rand + deltaLinks, oberem Rand + deltaOben
   //NSLog(@"Printinfo DruckFeld:	linkerRand: %d  obererRand: %d  Breite: %d Hoehe: %d",leftRand,rightRand, DruckbereichH,DruckbereichV);
   
   rDruckView* DruckView=[[rDruckView alloc]initWithFrame:DruckFeld];
   
   DruckView =[self setDruckViewMitDicArray:derDicArray mitFeld:DruckFeld];
   
   
   
   //	[DruckView setBackgroundColor:[NSColor grayColor]];
   //	[DruckView setDrawsBackground:YES];
   NSPrintOperation* DruckOperation;
   DruckOperation=[NSPrintOperation printOperationWithView: DruckView
                                                 printInfo:PrintInfo];
   
   [DruckOperation setShowsPrintPanel:YES];
   [DruckOperation runOperation];
}

- (void)printDicArray:(NSArray*)derDicArray forTest:(NSString*)derTest forUser:(NSString*)derUser
{
   
   //NSTextView* DruckView=[[[NSTextView alloc]init]autorelease];
   //	NSLog (@"Statistik: printDicArray DicArray: %@ forUser: %@",[derDicArray description],derUser);
   NSPrintInfo* PrintInfo=[NSPrintInfo sharedPrintInfo];
   [PrintInfo setOrientation:NSPortraitOrientation];
   
   [PrintInfo setVerticalPagination: NSAutoPagination];
   
   [PrintInfo setHorizontallyCentered:NO];
   [PrintInfo setVerticallyCentered:NO];
   NSRect PageBounds=[PrintInfo imageablePageBounds];
   
   int x=PageBounds.origin.x;int y=PageBounds.origin.y;int h=PageBounds.size.height;int w=PageBounds.size.width;
   //NSLog(@"PageBounds 1 x: %d y: %d  h: %d  w: %d",x,y,h,w);
   //NSLog(@"PrintInfo leftMargin: %1.1f		topMargin: %1.2f",[PrintInfo leftMargin],[PrintInfo topMargin]);
   
   NSSize Papiergroesse=[PrintInfo paperSize];
   //NSLog(@"PrintInfo Papiergroesse w: %1.2f	h: %1.2f",Papiergroesse.width,Papiergroesse.height);
   int RandLinks=60;
   int RandOben=30;
   
   [PrintInfo setTopMargin:RandOben];
   [PrintInfo setLeftMargin:RandLinks];
   [PrintInfo setRightMargin:50];
   [PrintInfo setBottomMargin:50];
   
   int deltaLinks=0;
   int deltaOben=0;
   
   int leftRand=[PrintInfo leftMargin]+deltaLinks;//ev. groesser
   int topRand=[PrintInfo topMargin]+deltaOben;///ev. groesser
   int rightRand=[PrintInfo rightMargin];
   int bottomRand=[PrintInfo bottomMargin];
   
   //NSLog(@"PrintInfo leftMargin: %1.1f		topMargin: %1.2f",[PrintInfo leftMargin],[PrintInfo topMargin]);
   //NSLog(@"PrintInfo rightMargin: %1.1f		bottomMargin: %1.2f",[PrintInfo rightMargin],[PrintInfo bottomMargin]);
   
   int Papierbreite=(int)Papiergroesse.width;
   int Papierhoehe=(int)Papiergroesse.height;
   
   int DruckbereichH=Papiergroesse.width-(rightRand+leftRand);
   int DruckbereichV=Papiergroesse.height-(bottomRand+topRand);
   
   NSRect DruckFeld=NSMakeRect(leftRand, topRand, DruckbereichH, DruckbereichV);
   //Druckbereich mit linkem Rand + deltaLinks, oberem Rand + deltaOben
   //NSLog(@"Printinfo DruckFeld:	linkerRand: %d  obererRand: %d  Breite: %d Hoehe: %d",leftRand,rightRand, DruckbereichH,DruckbereichV);
   
   rDruckView* DruckView=[[rDruckView alloc]initWithFrame:DruckFeld];
   
   
   DruckView =[self setDruckViewMitDicArray:derDicArray forTest:derTest forUser:derUser mitFeld:DruckFeld];
   
   
   
   //	[DruckView setBackgroundColor:[NSColor grayColor]];
   //	[DruckView setDrawsBackground:YES];
   NSPrintOperation* DruckOperation;
   DruckOperation=[NSPrintOperation printOperationWithView: DruckView
                                                 printInfo:PrintInfo];
   
   [DruckOperation setShowsPrintPanel:YES];
   [DruckOperation runOperation];
}

- (void)printDicArrayForAllTests:(NSArray*)derDicArray forUser:(NSString*)derUser
{
   
   //NSTextView* DruckView=[[[NSTextView alloc]init]autorelease];
   //NSLog (@"Kommentar: printDicArray DicArray: %@",[derDicArray description]);
   NSPrintInfo* PrintInfo=[NSPrintInfo sharedPrintInfo];
   [PrintInfo setOrientation:NSPortraitOrientation];
   
   [PrintInfo setVerticalPagination: NSAutoPagination];
   
   [PrintInfo setHorizontallyCentered:NO];
   [PrintInfo setVerticallyCentered:NO];
   NSRect PageBounds=[PrintInfo imageablePageBounds];
   
   int x=PageBounds.origin.x;int y=PageBounds.origin.y;int h=PageBounds.size.height;int w=PageBounds.size.width;
   //NSLog(@"PageBounds 1 x: %d y: %d  h: %d  w: %d",x,y,h,w);
   //NSLog(@"PrintInfo leftMargin: %1.1f		topMargin: %1.2f",[PrintInfo leftMargin],[PrintInfo topMargin]);
   
   NSSize Papiergroesse=[PrintInfo paperSize];
   //NSLog(@"PrintInfo Papiergroesse w: %1.2f	h: %1.2f",Papiergroesse.width,Papiergroesse.height);
   int RandLinks=60;
   int RandOben=30;
   
   [PrintInfo setTopMargin:RandOben];
   [PrintInfo setLeftMargin:RandLinks];
   [PrintInfo setRightMargin:50];
   [PrintInfo setBottomMargin:50];
   
   int deltaLinks=0;
   int deltaOben=0;
   
   int leftRand=[PrintInfo leftMargin]+deltaLinks;//ev. groesser
   int topRand=[PrintInfo topMargin]+deltaOben;///ev. groesser
   int rightRand=[PrintInfo rightMargin];
   int bottomRand=[PrintInfo bottomMargin];
   
   //NSLog(@"PrintInfo leftMargin: %1.1f		topMargin: %1.2f",[PrintInfo leftMargin],[PrintInfo topMargin]);
   //NSLog(@"PrintInfo rightMargin: %1.1f		bottomMargin: %1.2f",[PrintInfo rightMargin],[PrintInfo bottomMargin]);
   
   int Papierbreite=(int)Papiergroesse.width;
   int Papierhoehe=(int)Papiergroesse.height;
   
   int DruckbereichH=Papiergroesse.width-(rightRand+leftRand);
   int DruckbereichV=Papiergroesse.height-(bottomRand+topRand);
   
   NSRect DruckFeld=NSMakeRect(leftRand, topRand, DruckbereichH, DruckbereichV);
   //Druckbereich mit linkem Rand + deltaLinks, oberem Rand + deltaOben
   //NSLog(@"Printinfo DruckFeld:	linkerRand: %d  obererRand: %d  Breite: %d Hoehe: %d",leftRand,rightRand, DruckbereichH,DruckbereichV);
   
   rDruckView* DruckView=[[rDruckView alloc]initWithFrame:DruckFeld];
   
   DruckView =[self setDruckViewMitDicArray:derDicArray forUser:derUser mitFeld:DruckFeld];
   
   
   
   //	[DruckView setBackgroundColor:[NSColor grayColor]];
   //	[DruckView setDrawsBackground:YES];
   NSPrintOperation* DruckOperation;
   DruckOperation=[NSPrintOperation printOperationWithView: DruckView
                                                 printInfo:PrintInfo];
   
   [DruckOperation setShowsPrintPanel:YES];
   [DruckOperation runOperation];
}

- (rStatistikTable*)ErgebnisTableMitFeld:(NSRect)dasFeld
                               mitZeilen:(int)anzZeilen
                          mitZeilenhoehe:(int)dieZeilenhoehe
{
   rStatistikTable* returnErgebnisTable=[[rStatistikTable alloc]initWithFrame:dasFeld];
   
   NSRect TableHeaderViewRect= NSMakeRect( 0.0,  0.0, NSWidth(dasFeld), dieZeilenhoehe);
   NSTableHeaderView * Kopf=[[NSTableHeaderView alloc]initWithFrame:TableHeaderViewRect];
   [returnErgebnisTable setHeaderView:Kopf];
   [returnErgebnisTable tile];
   //	[ErgebnisTable addSubview:Kopf];
   
   [returnErgebnisTable setRowHeight:dieZeilenhoehe];
   
   [returnErgebnisTable setDelegate:DatenQuelle];
   [returnErgebnisTable setDataSource:DatenQuelle];
   [returnErgebnisTable setGridStyleMask:NSTableViewSolidVerticalGridLineMask];
   [returnErgebnisTable reloadData];
   //NSTableHeaderView    *origTableHeaderView = [ErgebnisTable headerView];
   //NSTableHeaderView    *Kopf = [[NSTableHeaderView alloc] init];
   
   //[Kopf setFrame:[origTableHeaderView frame]];
   //[Kopf setBounds:[origTableHeaderView bounds]];
   
   
   /*
    float Feldhoehe=[returnErgebnisTable rectOfRow:0].size.height+13;
    NSRect TableRect=[returnErgebnisTable frame];
    float hAlt=TableRect.size.height;
    float hNeu=(AnzDruckzeilen+1)*Feldhoehe;
    TableRect.size.height=hNeu;
    [returnErgebnisTable setFrame:TableRect];
    [returnErgebnisTable setNeedsDisplay:YES];
    NSLog(@"AnzDruckzeilen: %d	Feldhoehe: %1.2f	hAlt: %1.2f	hNeu:	%1.2f",AnzDruckzeilen,	Feldhoehe,	hAlt,	hNeu);
    */
   
   int Schriftgroesse=8;
   int Zeilenhoehe=13;
   NSTableHeaderCell* DatumKopfZelle=[[NSTableHeaderCell alloc]init];
   [DatumKopfZelle  setFont:[NSFont fontWithName:@"Helvetica" size:Schriftgroesse]];
   
   NSTableColumn* DatumKolonne=[[NSTableColumn alloc]initWithIdentifier:@"datumtext"];
   [DatumKolonne setWidth:Datumbreite];
   [DatumKolonne setHeaderCell:DatumKopfZelle];
   [[DatumKolonne dataCell] setFont:[NSFont fontWithName:@"Helvetica" size:Schriftgroesse]];
   //[DatumKolonne setHeaderCell:[[NSTableHeaderCell alloc] initTextCell:@"Datum"]];
   [[DatumKolonne headerCell]setStringValue:@"Datum"];
   [returnErgebnisTable addTableColumn:DatumKolonne];
   
   [[DatumKolonne headerCell]setStringValue:@"Datum"];
   NSTableColumn* NameKolonne=[[NSTableColumn alloc]initWithIdentifier:@"nametext"];
   
   NSTableHeaderCell* NameKopfZelle=[[NSTableHeaderCell alloc]init];
   [NameKopfZelle  setFont:[NSFont fontWithName:@"Helvetica" size:Schriftgroesse]];
   [NameKolonne setHeaderCell:NameKopfZelle];
   [[NameKolonne headerCell]setStringValue:@"Name"];
   
   [[NameKolonne dataCell] setFont:[NSFont fontWithName:@"Helvetica" size:Schriftgroesse]];
   [NameKolonne setWidth:Namebreite];
   [returnErgebnisTable addTableColumn:NameKolonne];
   
   NSTableColumn* ZeitKolonne=[[NSTableColumn alloc]initWithIdentifier:@"zeit"];
   NSTableHeaderCell* ZeitKopfZelle=[[NSTableHeaderCell alloc]init];
   [ZeitKopfZelle  setFont:[NSFont fontWithName:@"Helvetica" size:Schriftgroesse]];
   [ZeitKopfZelle setStringValue:@"Zeit"];
   [ZeitKopfZelle setAlignment:NSRightTextAlignment];
   [ZeitKolonne setHeaderCell:ZeitKopfZelle];
   
   [[ZeitKolonne dataCell] setFont:[NSFont fontWithName:@"Helvetica" size:Schriftgroesse]];
   [[ZeitKolonne dataCell] setAlignment:NSRightTextAlignment];
   [ZeitKolonne setWidth:Zeitbreite];
   [returnErgebnisTable addTableColumn:ZeitKolonne];
   
   
   NSTableColumn* GrafikKolonne=[[NSTableColumn alloc]initWithIdentifier:@"grafik"];
   [GrafikKolonne setHeaderCell:[[NSTableHeaderCell alloc] initTextCell:@"Grafik"]];
   [[GrafikKolonne headerCell]setFont:[NSFont fontWithName:@"Helvetica" size:Schriftgroesse]];
   [[GrafikKolonne headerCell] setAlignment:NSCenterTextAlignment];
   
   [[GrafikKolonne dataCell] setFont:[NSFont fontWithName:@"Helvetica" size:Schriftgroesse]];
   [GrafikKolonne setWidth:Grafikbreite];
   rGrafikCell* GrafikCell=[[rGrafikCell alloc]init];
   [GrafikKolonne setDataCell:GrafikCell];
   [returnErgebnisTable addTableColumn:GrafikKolonne];
   
   
   NSTableColumn* AnzFehlerKolonne=[[NSTableColumn alloc]initWithIdentifier:@"fehler"];
   [[AnzFehlerKolonne dataCell] setFont:[NSFont fontWithName:@"Helvetica" size:Schriftgroesse]];
   [[AnzFehlerKolonne dataCell] setAlignment:NSRightTextAlignment];
   [AnzFehlerKolonne setWidth:AnzFehlerbreite];
   //	[ErgebnisTable addTableColumn:AnzFehlerKolonne];
   
   NSTableColumn* MittelKolonne=[[NSTableColumn alloc]initWithIdentifier:@"mittel"];
   [MittelKolonne setHeaderCell:[[NSTableHeaderCell alloc] initTextCell:@"Mittel"]];
   [[MittelKolonne headerCell]setFont:[NSFont fontWithName:@"Helvetica" size:Schriftgroesse]];
   [[MittelKolonne dataCell] setFont:[NSFont fontWithName:@"Helvetica" size:Schriftgroesse]];
   [MittelKolonne setWidth:Mittelbreite];
   [[MittelKolonne dataCell] setAlignment:NSRightTextAlignment];
   [returnErgebnisTable addTableColumn:MittelKolonne];
   //[returnErgebnisTable setAutoresizesAllColumnsToFit:YES];
   
   NSTableColumn* FehlerKolonne=[[NSTableColumn alloc]initWithIdentifier:@"malpoints"];
   [FehlerKolonne setHeaderCell:[[NSTableHeaderCell alloc] initTextCell:@"Fehler"]];
   [[FehlerKolonne headerCell]setFont:[NSFont fontWithName:@"Helvetica" size:Schriftgroesse]];
   [[FehlerKolonne dataCell] setFont:[NSFont fontWithName:@"Helvetica" size:Schriftgroesse]];
   [FehlerKolonne setWidth:Fehlerbreite];
   rFehlerCell* FehlerCell=[[rFehlerCell alloc]init];
   [FehlerKolonne setDataCell:FehlerCell];
   [returnErgebnisTable addTableColumn:FehlerKolonne];
   
   NSTableColumn* NoteKolonne=[[NSTableColumn alloc]initWithIdentifier:@"note"];
   [NoteKolonne setHeaderCell:[[NSTableHeaderCell alloc] initTextCell:@"Note"]];
   [[NoteKolonne headerCell]setFont:[NSFont fontWithName:@"Helvetica" size:Schriftgroesse]];
   
   [[NoteKolonne dataCell] setFont:[NSFont fontWithName:@"Helvetica" size:Schriftgroesse]];
   [[NoteKolonne dataCell] setAlignment:NSCenterTextAlignment];
   [NoteKolonne setWidth:Notebreite];
   [returnErgebnisTable addTableColumn:NoteKolonne];
   
   [returnErgebnisTable reloadData];
   return returnErgebnisTable;
}

- (rDruckView*)setDruckViewMitDicArray:(NSArray*)derDicArray	//mehrere Tests
                               mitFeld:(NSRect)dasFeld
{
   NSRect DruckRect=dasFeld;
   int obererRand=DruckRect.origin.y;
   int linkerRand=DruckRect.origin.x;
   
   int DruckbereichH=DruckRect.size.width;
   int DruckbereichV=DruckRect.size.height;
   //	NSLog(@"setDruckViewMitDicArray DruckRect:	linkerRand: %d  obererRand: %d  Breite: %d Hoehe: %d",linkerRand,obererRand, DruckbereichH,DruckbereichV);
   
   
   float Feldhoehe=DruckRect.size.height;
   float Feldbreite=DruckRect.size.width;
   float AbstandLinks=DruckRect.origin.x;
   float AbstandOben=DruckRect.origin.y;
   
   int TabellenOffset1=70;
   int TabellenOffset2=0;
   int Schriftgroesse=8;
   int TabSchriftgroesse=Schriftgroesse;
   int Zeilenhoehe=11;
   int Reihenhoehe=Zeilenhoehe+2;
   long AnzDruckzeilen=[derDicArray count];
   int AnzZeilen1=(DruckRect.size.height-TabellenOffset1)/Reihenhoehe;
   int AnzZeilen2=(DruckRect.size.height-TabellenOffset2)/Reihenhoehe;
   int Seiten=1;
   if ((AnzDruckzeilen+1)>AnzZeilen1) //Mehr als eine Seite
   {
      Seiten+=(AnzDruckzeilen-AnzZeilen1)/AnzZeilen2;
      if ((AnzDruckzeilen-AnzZeilen1)%AnzZeilen2)//Rest von Zeilen
      {
         Seiten++;
      }
   }
   
   DruckRect.size.height+=(Seiten-1)*Feldhoehe;//Mindestens eine Seite
   
   //	NSLog(@"Druckbereich: %1.2f	AnzZeilen1: %d	AnzZeilen2: %d	Seiten: %d",DruckRect.size.height,AnzZeilen1,AnzZeilen2,	Seiten);
   
   rDruckView* DruckView=[[rDruckView alloc]initWithFrame:DruckRect];
   if ([derDicArray count]==0)
   {
      NSLog(@"setDruckViewDicArray: kein DicArray");
      return NULL;
   }
   
   
   NSFontManager *fontManager = [NSFontManager sharedFontManager];
   //NSLog(@"*Statistik  setDruckViewMitDicArray* %@",[[derDicArray valueForKey:@"name"]description]);
   
   NSCalendarDate* heute=[NSCalendarDate date];
   [heute setCalendarFormat:@"%d.%m.%Y    Zeit: %H:%M"];
   
   NSString* TitelString=NSLocalizedString(@"Results from ",@"Ergebnisse vom ");
   NSString* KopfString=[NSString stringWithFormat:@"%@  %@%@",TitelString,[heute description],@"\r\r"];
   
   //Font für Titelzeile
   NSFont* TitelFont;
   TitelFont=[NSFont fontWithName:@"Helvetica" size: 14];
   
   [[DruckView textStorage]beginEditing];
   
   //Stil für Titelzeile
   NSMutableParagraphStyle* TitelStil=[[NSMutableParagraphStyle alloc]init];
   [TitelStil setTabStops:[NSArray array]];//default weg
   NSTextTab* TitelTab1=[[NSTextTab alloc]initWithType:NSLeftTabStopType location:90];
   
   //Stil für Abstand12
   NSMutableParagraphStyle* Abstand12Stil=[[NSMutableParagraphStyle alloc]init];
   NSFont* Abstand12Font=[NSFont fontWithName:@"Helvetica" size: 12];
   NSMutableAttributedString* attrAbstand12String=[[NSMutableAttributedString alloc] initWithString:@" \r"];
   [attrAbstand12String addAttribute:NSParagraphStyleAttributeName value:Abstand12Stil range:NSMakeRange(0,1)];
   [attrAbstand12String addAttribute:NSFontAttributeName value:Abstand12Font range:NSMakeRange(0,1)];
   //Abstandzeile einsetzen
   
   [TitelStil addTabStop:TitelTab1];
   
   //Attr-String für Titelzeile zusammensetzen
   NSMutableAttributedString* attrTitelString=[[NSMutableAttributedString alloc] initWithString:KopfString];
   [attrTitelString addAttribute:NSParagraphStyleAttributeName value:TitelStil range:NSMakeRange(0,[KopfString length])];
   [attrTitelString addAttribute:NSFontAttributeName value:TitelFont range:NSMakeRange(0,[KopfString length])];
   
   //titelzeile einsetzen
   [[DruckView textStorage]setAttributedString:attrTitelString];
   
   //Stil für Abstand1
   NSMutableParagraphStyle* Abstand1Stil=[[NSMutableParagraphStyle alloc]init];
   NSFont* Abstand1Font=[NSFont fontWithName:@"Helvetica" size: 6];
   NSMutableAttributedString* attrAbstand1String=[[NSMutableAttributedString alloc] initWithString:@" \r"];
   [attrAbstand1String addAttribute:NSParagraphStyleAttributeName value:Abstand1Stil range:NSMakeRange(0,1)];
   [attrAbstand1String addAttribute:NSFontAttributeName value:Abstand1Font range:NSMakeRange(0,1)];
   //Abstandzeile einsetzen
   //[[DruckView textStorage]appendAttributedString:attrAbstand1String];
   
   //Stil für FormFeed
   NSMutableParagraphStyle* FormFeedStil=[[NSMutableParagraphStyle alloc]init];
   NSMutableAttributedString* attrFormFeedString=[[NSMutableAttributedString alloc] initWithString:[[NSNumber numberWithInt:0xc] stringValue]];
   [attrFormFeedString addAttribute:NSParagraphStyleAttributeName value:FormFeedStil range:NSMakeRange(0,1)];
   [attrFormFeedString addAttribute:NSFontAttributeName value:Abstand1Font range:NSMakeRange(0,1)];
   
   //FormFeedzeile einsetzen
   //[[DruckView textStorage]appendAttributedString:attrFormFeedString];
   
   //Stil für Untertitel
   NSMutableParagraphStyle* UntertitelStil=[[NSMutableParagraphStyle alloc]init];
   NSFont* UntertitelFont=[NSFont fontWithName:@"Helvetica" size: 12];
   NSString* UntertitelString=@"Ergebnisse für alle Tests" ;
   NSMutableAttributedString* attrUntertitelString=[[NSMutableAttributedString alloc] initWithString:UntertitelString];
   [attrUntertitelString addAttribute:NSParagraphStyleAttributeName value:UntertitelStil range:NSMakeRange(0,[UntertitelString length])];
   [attrUntertitelString addAttribute:NSFontAttributeName value:UntertitelFont range:NSMakeRange(0,[UntertitelString length])];
   
   [[DruckView textStorage]appendAttributedString:attrUntertitelString];
   [[DruckView textStorage]endEditing];
   NSFont* TabellenKopfFont=[NSFont fontWithName:@"Helvetica" size: 8];
   NSFont* TabellenFont=[NSFont fontWithName:@"Helvetica" size: 8];
   
   //Tabulatoren aufaddieren
   
   
   float NameTab=Datumbreite;
   float ZeitTab=NameTab+Namebreite;
   float GrafikTab=ZeitTab+Zeitbreite;
   float AnzFehlerTab=GrafikTab+Grafikbreite;
   float FehlerTab=AnzFehlerTab+AnzFehlerbreite;
   float MittelTab=FehlerTab+Fehlerbreite;
   float NoteTab=FehlerTab+Fehlerbreite;
   
   NSMutableDictionary* TabDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   [TabDic setObject:[NSNumber numberWithFloat:Datumbreite]forKey:@"datumbreite"];
   [TabDic setObject:[NSNumber numberWithFloat:Zeitbreite]forKey:@"zeitbreite"];
   [TabDic setObject:[NSNumber numberWithFloat:Grafikbreite]forKey:@"grafikbreite"];
   [TabDic setObject:[NSNumber numberWithFloat:AnzFehlerbreite]forKey:@"anzfehlerbreite"];
   [TabDic setObject:[NSNumber numberWithFloat:Fehlerbreite]forKey:@"fehlerbreite"];
   [TabDic setObject:[NSNumber numberWithFloat:Mittelbreite]forKey:@"mittelbreite"];
   [TabDic setObject:[NSNumber numberWithFloat:Notebreite]forKey:@"notebreite"];
   [TabDic setObject:[NSNumber numberWithInt:TabellenOffset1]forKey:@"tabellenoffset1"];
   [TabDic setObject:[NSNumber numberWithInt:TabellenOffset2]forKey:@"tabellenoffset2"];
   [TabDic setObject:[NSNumber numberWithInt:Zeilenhoehe]forKey:@"zeilenhoehe"];
   [TabDic setObject:[NSNumber numberWithInt:[derDicArray count]]forKey:@"anzahlzeilen"];
   
   NSArray* TabKopfStringArray=[NSArray arrayWithObjects:@"Datum",@"Name",@"Zeit",@"Grafik",@"Fehler",@"",@"Note",nil];
   NSString* TabellenkopfString=[TabKopfStringArray componentsJoinedByString:@"\t"];
   [TabDic setObject:TabKopfStringArray forKey:@"tabkopfstringarray"];
   
   
   
   //	NSPoint Ecke=NSMakePoint(0,TabellenOffset0);
   //	[ErgebnisTable setFrameOrigin:Ecke];
   
   //	NSLog(@" ErgebnisTable description: %@\n",[[ErgebnisTable headerView]description]);
   [DruckView setTabelleMitDic:TabDic  mitFeld:DruckRect];
   NSMutableDictionary* HeaderDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   [HeaderDic setObject:[NSNumber numberWithInt:3] forKey:@"art"];
   [HeaderDic setObject:@"Name" forKey:@"nametext"];
   [HeaderDic setObject:@"Zeit" forKey:@"zeit"];
   [HeaderDic setObject:@"Fehler" forKey:@"anzfehler"];
   [HeaderDic setObject:@"Grafik" forKey:@"grafik"];
   [HeaderDic setObject:@"Note" forKey:@"note"];
   [HeaderDic setObject:@"" forKey:@"anzrichtig"];
   [HeaderDic setObject:@"" forKey:@"anzaufgaben"];
   [HeaderDic setObject:@"" forKey:@"modus"];
   [HeaderDic setObject:@"" forKey:@"testname"];
   [HeaderDic setObject:@"" forKey:@"maxzeit"];
   [HeaderDic setObject:@"Mittel" forKey:@"mittel"];
   [HeaderDic setObject:@"Datum" forKey:@"datumtext"];
   //NSLog(@"HeaderDic: einDic: %@ ",[HeaderDic description]);
   //[returnErgebnisDicArray addObject:HeaderDic];
   
   NSMutableArray* TabArray=[[NSMutableArray alloc]initWithCapacity:0];
   NSMutableArray* SeitenArray=[[NSMutableArray alloc]initWithCapacity:0];
   
   int index=0;
   NSEnumerator* DicEnum=[derDicArray objectEnumerator];
   NSMutableDictionary*  einDic;
   NSRect ZeilenFeld=DruckRect;
   ZeilenFeld.origin=NSMakePoint(0,TabellenOffset1+1);
   [TabArray addObject:[NSNumber numberWithFloat:ZeilenFeld.origin.y]];
   [SeitenArray addObject:[NSNumber numberWithFloat:ZeilenFeld.origin.y]];
   ZeilenFeld.size.height=Zeilenhoehe;
   ZeilenFeld.size.width-=2;
   
   
   NSView* HeaderView=[self ZeilenViewMitDic:HeaderDic inFeld:ZeilenFeld mitSchnitt:TabSchriftgroesse mitFormatDic:NULL farbig:farbig];
   [DruckView addSubview:HeaderView];
   ZeilenFeld.origin.y+=Reihenhoehe;
   [TabArray addObject:[NSNumber numberWithFloat:ZeilenFeld.origin.y]];
   ZeilenFeld.origin.y+=4;
   int Seite=1;
   while (einDic=(NSMutableDictionary*)[DicEnum nextObject])
   {
      //NSLog(@"index: %d	ZeilenFeld:x  %1.2f		y: %1.2f	w: %1.2f	h: %1.2f",index,ZeilenFeld.origin.x,ZeilenFeld.origin.y,ZeilenFeld.size.width,ZeilenFeld.size.height);
      //[[NSColor redColor]set];
      //[NSBezierPath strokeRect:ZeilenFeld];
      //NSLog(@"ZeilenView	einDic: %@",[einDic description]);
      
      //NSLog(@"index: %d	ZeilenFeld:y  %1.2f",index,ZeilenFeld.origin.y);
      //		NSView* ZeilenView=[self ZeilenViewMitDic:einDic inFeld:ZeilenFeld mitSchnitt:TabSchriftgroesse mitFormatDic:NULL];
      //		[DruckView addSubview:ZeilenView];
      [einDic setObject:[NSNumber numberWithBool:farbig]forKey:@"farbig"];
      float rest=Seite*Feldhoehe-ZeilenFeld.origin.y;
      int anzTest=0;
      float Bedarf=0.0;
      if ([[einDic objectForKey:@"art"]intValue]==1)//eine Namenzeile
      {
         anzTest=[[einDic objectForKey:@"anztestforuser"]intValue];
         
         if (rest>((anzTest+1)*Reihenhoehe))//noch platz für ein Paket
         {
            NSView* ZeilenView=[self ZeilenViewMitDic:einDic inFeld:ZeilenFeld mitSchnitt:TabSchriftgroesse mitFormatDic:NULL farbig:farbig];
            [DruckView addSubview:ZeilenView];
            
            ZeilenFeld.origin.y+=Reihenhoehe;
         }
         else
         {
            [SeitenArray addObject:[NSNumber numberWithFloat:ZeilenFeld.origin.y]];
            [TabArray addObject:[NSNumber numberWithFloat:ZeilenFeld.origin.y]];
            
            //NSLog(@"					ZeilenView	einDic: %@",[einDic description]);
            ZeilenFeld.origin.y+=rest+1;
            Seite++;
            Bedarf=(anzTest+1)*Reihenhoehe;
            //				NSLog(@"Unteres Ende index: %d	Feldhoehe; %1.2f	rest: %1.2f		Bedarf: %1.2f	y : %1.2f",index,Feldhoehe,rest,Bedarf,ZeilenFeld.origin.y);
            NSRect KopfRect=ZeilenFeld;
            KopfRect.size.width+=2;
            KopfRect.size.height=20;
            NSTextField* KopfFeld=[[NSTextField alloc]initWithFrame:KopfRect];
            [KopfFeld setBordered:NO];
            NSFont* KopfFont;
            KopfFont=[NSFont fontWithName:@"Helvetica" size: 12];
            [KopfFeld setFont: KopfFont];
            //				NSString* KopfString=[@"Test: " stringByAppendingString:derTest];
            NSString* KopfString=@"Test: ";
            [KopfFeld setStringValue:KopfString];
            [DruckView addSubview:KopfFeld];
            ZeilenFeld.origin.y+=22;
            [TabArray addObject:[NSNumber numberWithFloat:ZeilenFeld.origin.y]];
            [SeitenArray addObject:[NSNumber numberWithFloat:ZeilenFeld.origin.y]];
            
            NSView* HeaderView=[self ZeilenViewMitDic:HeaderDic inFeld:ZeilenFeld mitSchnitt:TabSchriftgroesse mitFormatDic:NULL farbig:farbig];
            //[HeaderView setBordered:YES];
            [DruckView addSubview:HeaderView];
            ZeilenFeld.origin.y+=Reihenhoehe;
            [TabArray addObject:[NSNumber numberWithFloat:ZeilenFeld.origin.y]];
            ZeilenFeld.origin.y+=4;
            
            
            NSView* ZeilenView=[self ZeilenViewMitDic:einDic inFeld:ZeilenFeld mitSchnitt:TabSchriftgroesse mitFormatDic:NULL farbig:farbig];
            [DruckView addSubview:ZeilenView];
            ZeilenFeld.origin.y+=Reihenhoehe;
         }
         
      }
      else
      {
         NSView* ZeilenView=[self ZeilenViewMitDic:einDic inFeld:ZeilenFeld mitSchnitt:TabSchriftgroesse mitFormatDic:NULL farbig:farbig];
         [DruckView addSubview:ZeilenView];
         
         ZeilenFeld.origin.y+=Reihenhoehe;
      }
      //		[TabArray addObject:[NSNumber numberWithFloat:ZeilenFeld.origin.y]];
      
      index++;
   }//while einDic
   [TabArray addObject:[NSNumber numberWithFloat:ZeilenFeld.origin.y]];
   [SeitenArray addObject:[NSNumber numberWithFloat:ZeilenFeld.origin.y]];
   
   //NSLog(@"setDruckView: TabArray: %@",[TabArray description]);
   //	NSLog(@"setDruckView: SeitenArray: %@",[SeitenArray description]);
   
   NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   [NotificationDic setObject:[TabArray copy]forKey:@"tabarray"];
   [NotificationDic setObject:SeitenArray forKey:@"seitenarray"];
   NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
   [nc postNotificationName:@"drawTabelle" object:self userInfo:NotificationDic];
   
   
   [TestTable reloadData];
   
   //NSLog(@"Schluss: maxNamenbreite: %d  maxTitelbreite: %d",maxNamenbreite, maxTitelbreite);
   
   //NSLog(@"setKommentarMit Komm.DicArray: nach while");
   return DruckView;
}

- (rDruckView*)setDruckViewMitDicArray:(NSArray*)derDicArray	//nur ein Test
                               forTest:(NSString*)derTest
                               mitFeld:(NSRect)dasFeld
{
   NSRect DruckRect=dasFeld;
   int obererRand=DruckRect.origin.y;
   int linkerRand=DruckRect.origin.x;
   
   int DruckbereichH=DruckRect.size.width;
   int DruckbereichV=DruckRect.size.height;
   //	NSLog(@"setDruckViewMitDicArray DruckRect:	linkerRand: %d  obererRand: %d  Breite: %d Hoehe: %d",linkerRand,obererRand, DruckbereichH,DruckbereichV);
   
   
   float Feldhoehe=DruckRect.size.height;
   float Feldbreite=DruckRect.size.width;
   float AbstandLinks=DruckRect.origin.x;
   float AbstandOben=DruckRect.origin.y;
   
   int TabellenOffset1=70;
   int TabellenOffset2=0;
   int Schriftgroesse=8;
   int TabSchriftgroesse=Schriftgroesse;
   int Zeilenhoehe=11;
   int Reihenhoehe=Zeilenhoehe+2;
   int AnzDruckzeilen=[derDicArray count];
   int AnzZeilen1=(DruckRect.size.height-TabellenOffset1)/Reihenhoehe;
   int AnzZeilen2=(DruckRect.size.height-TabellenOffset2)/Reihenhoehe;
   int Seiten=1;
   if ((AnzDruckzeilen+1)>AnzZeilen1) //Mehr als eine Seite
   {
      Seiten+=(AnzDruckzeilen-AnzZeilen1)/AnzZeilen2;
      if ((AnzDruckzeilen-AnzZeilen1)%AnzZeilen2)//Rest von Zeilen
      {
         Seiten++;
      }
   }
   
   DruckRect.size.height+=(Seiten-1)*Feldhoehe;//Mindestens eine Seite
   
   //	NSLog(@"Druckbereich: %1.2f	AnzZeilen1: %d	AnzZeilen2: %d	Seiten: %d",DruckRect.size.height,AnzZeilen1,AnzZeilen2,	Seiten);
   
   rDruckView* DruckView=[[rDruckView alloc]initWithFrame:DruckRect];
   if ([derDicArray count]==0)
   {
      NSLog(@"setDruckViewDicArray forTest : kein DicArray");
      return NULL;
   }
   
   
   NSFontManager *fontManager = [NSFontManager sharedFontManager];
   //NSLog(@"*Statistik  setDruckViewMitDicArray* %@",[[derDicArray valueForKey:@"name"]description]);
   
   NSCalendarDate* heute=[NSCalendarDate date];
   [heute setCalendarFormat:@"%d.%m.%Y    Zeit: %H:%M"];
   
   NSString* TitelString=NSLocalizedString(@"Results from ",@"Ergebnisse vom ");
   NSString* KopfString=[NSString stringWithFormat:@"%@  %@%@",TitelString,[heute description],@"\r\r"];
   
   //Font für Titelzeile
   NSFont* TitelFont;
   TitelFont=[NSFont fontWithName:@"Helvetica" size: 14];
   
   [[DruckView textStorage]beginEditing];
   
   //Stil für Titelzeile
   NSMutableParagraphStyle* TitelStil=[[NSMutableParagraphStyle alloc]init];
   [TitelStil setTabStops:[NSArray array]];//default weg
   NSTextTab* TitelTab1=[[NSTextTab alloc]initWithType:NSLeftTabStopType location:90];
   
   //Stil für Abstand12
   NSMutableParagraphStyle* Abstand12Stil=[[NSMutableParagraphStyle alloc]init];
   NSFont* Abstand12Font=[NSFont fontWithName:@"Helvetica" size: 12];
   NSMutableAttributedString* attrAbstand12String=[[NSMutableAttributedString alloc] initWithString:@" \r"];
   [attrAbstand12String addAttribute:NSParagraphStyleAttributeName value:Abstand12Stil range:NSMakeRange(0,1)];
   [attrAbstand12String addAttribute:NSFontAttributeName value:Abstand12Font range:NSMakeRange(0,1)];
   //Abstandzeile einsetzen
   
   [TitelStil addTabStop:TitelTab1];
   
   //Attr-String für Titelzeile zusammensetzen
   NSMutableAttributedString* attrTitelString=[[NSMutableAttributedString alloc] initWithString:KopfString];
   [attrTitelString addAttribute:NSParagraphStyleAttributeName value:TitelStil range:NSMakeRange(0,[KopfString length])];
   [attrTitelString addAttribute:NSFontAttributeName value:TitelFont range:NSMakeRange(0,[KopfString length])];
   
   //titelzeile einsetzen
   [[DruckView textStorage]setAttributedString:attrTitelString];
   
   //Stil für Abstand1
   NSMutableParagraphStyle* Abstand1Stil=[[NSMutableParagraphStyle alloc]init];
   NSFont* Abstand1Font=[NSFont fontWithName:@"Helvetica" size: 6];
   NSMutableAttributedString* attrAbstand1String=[[NSMutableAttributedString alloc] initWithString:@" \r"];
   [attrAbstand1String addAttribute:NSParagraphStyleAttributeName value:Abstand1Stil range:NSMakeRange(0,1)];
   [attrAbstand1String addAttribute:NSFontAttributeName value:Abstand1Font range:NSMakeRange(0,1)];
   //Abstandzeile einsetzen
   //[[DruckView textStorage]appendAttributedString:attrAbstand1String];
   
   //Stil für FormFeed
   NSMutableParagraphStyle* FormFeedStil=[[NSMutableParagraphStyle alloc]init];
   NSMutableAttributedString* attrFormFeedString=[[NSMutableAttributedString alloc] initWithString:[[NSNumber numberWithInt:0xc] stringValue]];
   [attrFormFeedString addAttribute:NSParagraphStyleAttributeName value:FormFeedStil range:NSMakeRange(0,1)];
   [attrFormFeedString addAttribute:NSFontAttributeName value:Abstand1Font range:NSMakeRange(0,1)];
   
   //FormFeedzeile einsetzen
   //[[DruckView textStorage]appendAttributedString:attrFormFeedString];
   
   //Stil für Testnamezeile
   NSMutableParagraphStyle* TestnameStil=[[NSMutableParagraphStyle alloc]init];
   NSFont* TestnameFont=[NSFont fontWithName:@"Helvetica" size: 12];
   NSString* MaxZeitString=[[derDicArray objectAtIndex:0] objectForKey:@"maxzeit"];
   NSString* AnzAufgabenString=[[derDicArray objectAtIndex:0] objectForKey:@"anzaufgaben"];
   NSString* TestNameString=[NSString stringWithFormat:@"Test: %@			%@ Aufgaben		%@s", derTest,AnzAufgabenString,MaxZeitString];
   
   //	NSString* TestNameString=[@"Test: " stringByAppendingString:derTest];
   NSMutableAttributedString* attrTestnameString=[[NSMutableAttributedString alloc] initWithString:TestNameString];
   [attrTestnameString addAttribute:NSParagraphStyleAttributeName value:TestnameStil range:NSMakeRange(0,[TestNameString length])];
   [attrTestnameString addAttribute:NSFontAttributeName value:TestnameFont range:NSMakeRange(0,[TestNameString length])];
   
   [[DruckView textStorage]appendAttributedString:attrTestnameString];
   [[DruckView textStorage]endEditing];
   NSFont* TabellenKopfFont=[NSFont fontWithName:@"Helvetica" size: 8];
   NSFont* TabellenFont=[NSFont fontWithName:@"Helvetica" size: 8];
   
   //Tabulatoren aufaddieren
   
   
   float NameTab=Datumbreite;
   float ZeitTab=NameTab+Namebreite;
   float GrafikTab=ZeitTab+Zeitbreite;
   float AnzFehlerTab=GrafikTab+Grafikbreite;
   float FehlerTab=AnzFehlerTab+AnzFehlerbreite;
   float MittelTab=FehlerTab+Fehlerbreite;
   float NoteTab=FehlerTab+Fehlerbreite;
   
   NSMutableDictionary* TabDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   [TabDic setObject:[NSNumber numberWithFloat:Datumbreite]forKey:@"datumbreite"];
   [TabDic setObject:[NSNumber numberWithFloat:Zeitbreite]forKey:@"zeitbreite"];
   [TabDic setObject:[NSNumber numberWithFloat:Grafikbreite]forKey:@"grafikbreite"];
   [TabDic setObject:[NSNumber numberWithFloat:AnzFehlerbreite]forKey:@"anzfehlerbreite"];
   [TabDic setObject:[NSNumber numberWithFloat:Fehlerbreite]forKey:@"fehlerbreite"];
   [TabDic setObject:[NSNumber numberWithFloat:Mittelbreite]forKey:@"mittelbreite"];
   [TabDic setObject:[NSNumber numberWithFloat:Notebreite]forKey:@"notebreite"];
   [TabDic setObject:[NSNumber numberWithInt:TabellenOffset1]forKey:@"tabellenoffset1"];
   [TabDic setObject:[NSNumber numberWithInt:TabellenOffset2]forKey:@"tabellenoffset2"];
   [TabDic setObject:[NSNumber numberWithInt:Zeilenhoehe]forKey:@"zeilenhoehe"];
   [TabDic setObject:[NSNumber numberWithInt:[derDicArray count]]forKey:@"anzahlzeilen"];
   
   NSArray* TabKopfStringArray=[NSArray arrayWithObjects:@"Datum",@"Name",@"Zeit",@"Grafik",@"Fehler",@"",@"Note",nil];
   NSString* TabellenkopfString=[TabKopfStringArray componentsJoinedByString:@"\t"];
   [TabDic setObject:TabKopfStringArray forKey:@"tabkopfstringarray"];
   
   
   
   //	NSPoint Ecke=NSMakePoint(0,TabellenOffset0);
   //	[ErgebnisTable setFrameOrigin:Ecke];
   
   //	NSLog(@" ErgebnisTable description: %@\n",[[ErgebnisTable headerView]description]);
   [DruckView setTabelleMitDic:TabDic  mitFeld:DruckRect];
   NSMutableDictionary* HeaderDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   [HeaderDic setObject:[NSNumber numberWithInt:3] forKey:@"art"];
   [HeaderDic setObject:@"Name" forKey:@"nametext"];
   [HeaderDic setObject:@"Zeit" forKey:@"zeit"];
   [HeaderDic setObject:@"Fehler" forKey:@"anzfehler"];
   [HeaderDic setObject:@"Grafik" forKey:@"grafik"];
   [HeaderDic setObject:@"Note" forKey:@"note"];
   [HeaderDic setObject:@"" forKey:@"anzrichtig"];
   [HeaderDic setObject:@"" forKey:@"anzaufgaben"];
   [HeaderDic setObject:@"" forKey:@"modus"];
   [HeaderDic setObject:@"" forKey:@"testname"];
   [HeaderDic setObject:@"" forKey:@"maxzeit"];
   [HeaderDic setObject:@"Mittel" forKey:@"mittel"];
   [HeaderDic setObject:@"Datum" forKey:@"datumtext"];
   //NSLog(@"HeaderDic: einDic: %@ ",[HeaderDic description]);
   //[returnErgebnisDicArray addObject:HeaderDic];
   
   NSMutableArray* TabArray=[[NSMutableArray alloc]initWithCapacity:0];
   NSMutableArray* SeitenArray=[[NSMutableArray alloc]initWithCapacity:0];
   
   int index=0;
   NSEnumerator* DicEnum=[derDicArray objectEnumerator];
   NSMutableDictionary* einDic;
   NSRect ZeilenFeld=DruckRect;
   ZeilenFeld.origin=NSMakePoint(0,TabellenOffset1+1);
   [TabArray addObject:[NSNumber numberWithFloat:ZeilenFeld.origin.y]];
   [SeitenArray addObject:[NSNumber numberWithFloat:ZeilenFeld.origin.y]];
   ZeilenFeld.size.height=Zeilenhoehe;
   ZeilenFeld.size.width-=2;
   
   
   NSView* HeaderView=[self ZeilenViewMitDic:HeaderDic inFeld:ZeilenFeld mitSchnitt:TabSchriftgroesse mitFormatDic:NULL farbig:farbig];
   [DruckView addSubview:HeaderView];
   ZeilenFeld.origin.y+=Reihenhoehe;
   [TabArray addObject:[NSNumber numberWithFloat:ZeilenFeld.origin.y]];
   ZeilenFeld.origin.y+=4;
   int Seite=1;
   while (einDic=(NSMutableDictionary*)[DicEnum nextObject])
   {
      //NSLog(@"index: %d	ZeilenFeld:x  %1.2f		y: %1.2f	w: %1.2f	h: %1.2f",index,ZeilenFeld.origin.x,ZeilenFeld.origin.y,ZeilenFeld.size.width,ZeilenFeld.size.height);
      //[[NSColor redColor]set];
      //[NSBezierPath strokeRect:ZeilenFeld];
      //NSLog(@"ZeilenView	einDic: %@",[einDic description]);
      
      //NSLog(@"index: %d	ZeilenFeld:y  %1.2f",index,ZeilenFeld.origin.y);
      //		NSView* ZeilenView=[self ZeilenViewMitDic:einDic inFeld:ZeilenFeld mitSchnitt:TabSchriftgroesse mitFormatDic:NULL];
      //		[DruckView addSubview:ZeilenView];
      [einDic setObject:[NSNumber numberWithBool:farbig]forKey:@"farbig"];
      float rest=Seite*Feldhoehe-ZeilenFeld.origin.y;
      int anzTest=0;
      float Bedarf=0.0;
      if ([[einDic objectForKey:@"art"]intValue]==1)//eine Namenzeile
      {
         anzTest=[[einDic objectForKey:@"anztestforuser"]intValue];
         
         if (rest>((anzTest+1)*Reihenhoehe))//noch platz für ein Paket
         {
            NSView* ZeilenView=[self ZeilenViewMitDic:einDic inFeld:ZeilenFeld mitSchnitt:TabSchriftgroesse mitFormatDic:NULL farbig:farbig];
            [DruckView addSubview:ZeilenView];
            
            ZeilenFeld.origin.y+=Reihenhoehe;
         }
         else
         {
            [SeitenArray addObject:[NSNumber numberWithFloat:ZeilenFeld.origin.y]];
            [TabArray addObject:[NSNumber numberWithFloat:ZeilenFeld.origin.y]];
            
            //NSLog(@"					ZeilenView	einDic: %@",[einDic description]);
            ZeilenFeld.origin.y+=rest+1;
            Seite++;
            Bedarf=(anzTest+1)*Reihenhoehe;
            //				NSLog(@"Unteres Ende index: %d	Feldhoehe; %1.2f	rest: %1.2f		Bedarf: %1.2f	y : %1.2f",index,Feldhoehe,rest,Bedarf,ZeilenFeld.origin.y);
            NSRect KopfRect=ZeilenFeld;
            KopfRect.size.width+=2;
            KopfRect.size.height=20;
            NSTextField* KopfFeld=[[NSTextField alloc]initWithFrame:KopfRect];
            [KopfFeld setBordered:NO];
            NSFont* KopfFont;
            KopfFont=[NSFont fontWithName:@"Helvetica" size: 12];
            [KopfFeld setFont: KopfFont];
            NSString* KopfString=[@"Test: " stringByAppendingString:derTest];
            [KopfFeld setStringValue:KopfString];
            [DruckView addSubview:KopfFeld];
            ZeilenFeld.origin.y+=22;
            [TabArray addObject:[NSNumber numberWithFloat:ZeilenFeld.origin.y]];
            [SeitenArray addObject:[NSNumber numberWithFloat:ZeilenFeld.origin.y]];
            
            NSView* HeaderView=[self ZeilenViewMitDic:HeaderDic inFeld:ZeilenFeld mitSchnitt:TabSchriftgroesse mitFormatDic:NULL farbig:farbig];
            //[HeaderView setBordered:YES];
            [DruckView addSubview:HeaderView];
            ZeilenFeld.origin.y+=Reihenhoehe;
            [TabArray addObject:[NSNumber numberWithFloat:ZeilenFeld.origin.y]];
            ZeilenFeld.origin.y+=4;
            
            
            NSView* ZeilenView=[self ZeilenViewMitDic:einDic inFeld:ZeilenFeld mitSchnitt:TabSchriftgroesse mitFormatDic:NULL farbig:farbig];
            [DruckView addSubview:ZeilenView];
            ZeilenFeld.origin.y+=Reihenhoehe;
         }
         
      }
      else
      {
         NSView* ZeilenView=[self ZeilenViewMitDic:einDic inFeld:ZeilenFeld mitSchnitt:TabSchriftgroesse mitFormatDic:NULL farbig:farbig];
         [DruckView addSubview:ZeilenView];
         
         ZeilenFeld.origin.y+=Reihenhoehe;
      }
      //		[TabArray addObject:[NSNumber numberWithFloat:ZeilenFeld.origin.y]];
      
      index++;
   }//while einDic
   [TabArray addObject:[NSNumber numberWithFloat:ZeilenFeld.origin.y]];
   [SeitenArray addObject:[NSNumber numberWithFloat:ZeilenFeld.origin.y]];
   
   //NSLog(@"setDruckView: TabArray: %@",[TabArray description]);
   //	NSLog(@"setDruckView: SeitenArray: %@",[SeitenArray description]);
   
   NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   [NotificationDic setObject:[TabArray copy]forKey:@"tabarray"];
   [NotificationDic setObject:SeitenArray forKey:@"seitenarray"];
   NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
   [nc postNotificationName:@"drawTabelle" object:self userInfo:NotificationDic];
   
   
   [TestTable reloadData];
   
   //NSLog(@"Schluss: maxNamenbreite: %d  maxTitelbreite: %d",maxNamenbreite, maxTitelbreite);
   
   //NSLog(@"setKommentarMit Komm.DicArray: nach while");
   return DruckView;
}


- (rDruckView*)setDruckViewMitDicArray:(NSArray*)derDicArray	//nur ein Test
                               forTest:(NSString*)derTest
                               forUser:(NSString*)derUser
                               mitFeld:(NSRect)dasFeld
{
   NSRect DruckRect=dasFeld;
   int obererRand=DruckRect.origin.y;
   int linkerRand=DruckRect.origin.x;
   
   int DruckbereichH=DruckRect.size.width;
   int DruckbereichV=DruckRect.size.height;
   //	NSLog(@"setDruckViewMitDicArray: %@",derUser);
   //	NSLog(@"setDruckViewMitDicArray DruckRect:	linkerRand: %d  obererRand: %d  Breite: %d Hoehe: %d",linkerRand,obererRand, DruckbereichH,DruckbereichV);
   
   
   float Feldhoehe=DruckRect.size.height;
   float Feldbreite=DruckRect.size.width;
   float AbstandLinks=DruckRect.origin.x;
   float AbstandOben=DruckRect.origin.y;
   
   int TabellenOffset1=70;
   int TabellenOffset2=0;
   int Schriftgroesse=8;
   int TabSchriftgroesse=Schriftgroesse;
   int Zeilenhoehe=11;
   int Reihenhoehe=Zeilenhoehe+2;
   int AnzDruckzeilen=[derDicArray count];
   int AnzZeilen1=(DruckRect.size.height-TabellenOffset1)/Reihenhoehe;
   int AnzZeilen2=(DruckRect.size.height-TabellenOffset2)/Reihenhoehe;
   int Seiten=1;
   if ((AnzDruckzeilen+1)>AnzZeilen1) //Mehr als eine Seite
   {
      Seiten+=(AnzDruckzeilen-AnzZeilen1)/AnzZeilen2;
      if ((AnzDruckzeilen-AnzZeilen1)%AnzZeilen2)//Rest von Zeilen
      {
         Seiten++;
      }
   }
   
   DruckRect.size.height+=(Seiten-1)*Feldhoehe;//Mindestens eine Seite
   
   //	NSLog(@"Druckbereich: %1.2f	AnzZeilen1: %d	AnzZeilen2: %d	Seiten: %d",DruckRect.size.height,AnzZeilen1,AnzZeilen2,	Seiten);
   
   rDruckView* DruckView=[[rDruckView alloc]initWithFrame:DruckRect];
   if ([derDicArray count]==0)
   {
      NSLog(@"setDruckViewDicArray forTest forUser: kein DicArray");
      return NULL;
   }
   
   
   NSFontManager *fontManager = [NSFontManager sharedFontManager];
   //NSLog(@"*Statistik  setDruckViewMitDicArray* %@",[[derDicArray valueForKey:@"name"]description]);
   
   NSCalendarDate* heute=[NSCalendarDate date];
   [heute setCalendarFormat:@"%d.%m.%Y    Zeit: %H:%M"];
   
   NSString* TitelString=NSLocalizedString(@"Results from ",@"Ergebnisse vom ");
   NSString* KopfString=[NSString stringWithFormat:@"%@  %@%@",TitelString,[heute description],@"\r"];
   
   NSString* NameString=NSLocalizedString(@"Name: ",@"Name: ");
   NSString* UserString=[NSString stringWithFormat:@"%@  %@ %@",NameString,derUser,@"\r"];
   
   //Font für Titelzeile
   NSFont* TitelFont;
   TitelFont=[NSFont fontWithName:@"Helvetica" size: 14];
   //Font für Userzeile
   NSFont* UserFont;
   UserFont=[NSFont fontWithName:@"Helvetica" size: 12];
   
   [[DruckView textStorage]beginEditing];
   
   //Stil für Titelzeile
   NSMutableParagraphStyle* TitelStil=[[NSMutableParagraphStyle alloc]init];
   [TitelStil setTabStops:[NSArray array]];//default weg
   NSTextTab* TitelTab1=[[NSTextTab alloc]initWithType:NSLeftTabStopType location:90];
   
   //Stil für Abstand12
   NSMutableParagraphStyle* Abstand12Stil=[[NSMutableParagraphStyle alloc]init];
   NSFont* Abstand12Font=[NSFont fontWithName:@"Helvetica" size: 12];
   NSMutableAttributedString* attrAbstand12String=[[NSMutableAttributedString alloc] initWithString:@" \r"];
   [attrAbstand12String addAttribute:NSParagraphStyleAttributeName value:Abstand12Stil range:NSMakeRange(0,1)];
   [attrAbstand12String addAttribute:NSFontAttributeName value:Abstand12Font range:NSMakeRange(0,1)];
   //Abstandzeile einsetzen
   
   [TitelStil addTabStop:TitelTab1];
   
   //Attr-String für Titelzeile zusammensetzen
   NSMutableAttributedString* attrTitelString=[[NSMutableAttributedString alloc] initWithString:KopfString];
   //	NSLog(@"attrTitelString: %@",attrTitelString);
   [attrTitelString addAttribute:NSParagraphStyleAttributeName value:TitelStil range:NSMakeRange(0,[KopfString length])];
   [attrTitelString addAttribute:NSFontAttributeName value:TitelFont range:NSMakeRange(0,[KopfString length])];
   
   //titelzeile einsetzen
   [[DruckView textStorage]setAttributedString:attrTitelString];
   
   //Stil für Abstand1
   NSMutableParagraphStyle* Abstand1Stil=[[NSMutableParagraphStyle alloc]init];
   NSFont* Abstand1Font=[NSFont fontWithName:@"Helvetica" size: 6];
   NSMutableAttributedString* attrAbstand1String=[[NSMutableAttributedString alloc] initWithString:@" \r"];
   [attrAbstand1String addAttribute:NSParagraphStyleAttributeName value:Abstand1Stil range:NSMakeRange(0,1)];
   [attrAbstand1String addAttribute:NSFontAttributeName value:Abstand1Font range:NSMakeRange(0,1)];
   
   //Abstandzeile einsetzen
   [[DruckView textStorage]appendAttributedString:attrAbstand1String];
   
   //Stil für Userzeile
   NSMutableParagraphStyle* UserStil=[[NSMutableParagraphStyle alloc]init];
   
   //Attr-String für Userzeile zusammensetzen
   NSMutableAttributedString* attrUserString=[[NSMutableAttributedString alloc] initWithString:UserString];
   //	NSLog(@"attrUserString: %@",attrUserString);
   
   [attrUserString addAttribute:NSParagraphStyleAttributeName value:UserStil range:NSMakeRange(0,[UserString length])];
   [attrUserString addAttribute:NSFontAttributeName value:UserFont range:NSMakeRange(0,[UserString length])];
   
   //Userzeile einsetzen
   [[DruckView textStorage]appendAttributedString:attrUserString];
   
   /*
    //Stil für Abstand1
    NSMutableParagraphStyle* Abstand1Stil=[[[NSMutableParagraphStyle alloc]init]autorelease];
    NSFont* Abstand1Font=[NSFont fontWithName:@"Helvetica" size: 6];
    NSMutableAttributedString* attrAbstand1String=[[NSMutableAttributedString alloc] initWithString:@" \r"];
    [attrAbstand1String addAttribute:NSParagraphStyleAttributeName value:Abstand1Stil range:NSMakeRange(0,1)];
    [attrAbstand1String addAttribute:NSFontAttributeName value:Abstand1Font range:NSMakeRange(0,1)];
    */
   
   //Abstandzeile einsetzen
   [[DruckView textStorage]appendAttributedString:attrAbstand1String];
   
   //Stil für FormFeed
   NSMutableParagraphStyle* FormFeedStil=[[NSMutableParagraphStyle alloc]init];
   NSMutableAttributedString* attrFormFeedString=[[NSMutableAttributedString alloc] initWithString:[[NSNumber numberWithInt:0xc] stringValue]];
   [attrFormFeedString addAttribute:NSParagraphStyleAttributeName value:FormFeedStil range:NSMakeRange(0,1)];
   [attrFormFeedString addAttribute:NSFontAttributeName value:Abstand1Font range:NSMakeRange(0,1)];
   
   //FormFeedzeile einsetzen
   //[[DruckView textStorage]appendAttributedString:attrFormFeedString];
   
   
   //Stil für Testnamezeile
   NSMutableParagraphStyle* TestnameStil=[[NSMutableParagraphStyle alloc]init];
   NSFont* TestnameFont=[NSFont fontWithName:@"Helvetica" size: 12];
   NSLog(@"SetDruckViewMitDicArray forTest: Erste Zeile: %@",[[derDicArray objectAtIndex:0] description]);
   NSString* MaxZeitString=[[derDicArray objectAtIndex:0] objectForKey:@"maxzeit"];
   NSString* AnzAufgabenString=[[derDicArray objectAtIndex:0] objectForKey:@"anzaufgaben"];
   NSString* TestNameString=[NSString stringWithFormat:@"Test: %@			%@ Aufgaben		%@s", derTest,AnzAufgabenString,MaxZeitString];
   
   //	NSString* TestNameString=[@"Test: " stringByAppendingString:derTest];
   
   NSMutableAttributedString* attrTestnameString=[[NSMutableAttributedString alloc] initWithString:TestNameString];
   [attrTestnameString addAttribute:NSParagraphStyleAttributeName value:TestnameStil range:NSMakeRange(0,[TestNameString length])];
   [attrTestnameString addAttribute:NSFontAttributeName value:TestnameFont range:NSMakeRange(0,[TestNameString length])];
   
   [[DruckView textStorage]appendAttributedString:attrTestnameString];
   
   [[DruckView textStorage]endEditing];
   NSFont* TabellenKopfFont=[NSFont fontWithName:@"Helvetica" size: 8];
   NSFont* TabellenFont=[NSFont fontWithName:@"Helvetica" size: 8];
   
   //Tabulatoren aufaddieren
   
   
   float NameTab=Datumbreite;
   float ZeitTab=NameTab+Namebreite;
   float GrafikTab=ZeitTab+Zeitbreite;
   float AnzFehlerTab=GrafikTab+Grafikbreite;
   float FehlerTab=AnzFehlerTab+AnzFehlerbreite;
   float MittelTab=FehlerTab+Fehlerbreite;
   float NoteTab=FehlerTab+Fehlerbreite;
   
   NSMutableDictionary* TabDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   [TabDic setObject:[NSNumber numberWithFloat:Datumbreite]forKey:@"datumbreite"];
   [TabDic setObject:[NSNumber numberWithFloat:Zeitbreite]forKey:@"zeitbreite"];
   [TabDic setObject:[NSNumber numberWithFloat:Grafikbreite]forKey:@"grafikbreite"];
   [TabDic setObject:[NSNumber numberWithFloat:AnzFehlerbreite]forKey:@"anzfehlerbreite"];
   [TabDic setObject:[NSNumber numberWithFloat:Fehlerbreite]forKey:@"fehlerbreite"];
   [TabDic setObject:[NSNumber numberWithFloat:Mittelbreite]forKey:@"mittelbreite"];
   [TabDic setObject:[NSNumber numberWithFloat:Notebreite]forKey:@"notebreite"];
   [TabDic setObject:[NSNumber numberWithInt:TabellenOffset1]forKey:@"tabellenoffset1"];
   [TabDic setObject:[NSNumber numberWithInt:TabellenOffset2]forKey:@"tabellenoffset2"];
   [TabDic setObject:[NSNumber numberWithInt:Zeilenhoehe]forKey:@"zeilenhoehe"];
   [TabDic setObject:[NSNumber numberWithInt:[derDicArray count]]forKey:@"anzahlzeilen"];
   
   NSArray* TabKopfStringArray=[NSArray arrayWithObjects:@"Datum",@"Name",@"Zeit",@"Grafik",@"Fehler",@"",@"Note",nil];
   NSString* TabellenkopfString=[TabKopfStringArray componentsJoinedByString:@"\t"];
   [TabDic setObject:TabKopfStringArray forKey:@"tabkopfstringarray"];
   
   
   
   //	NSPoint Ecke=NSMakePoint(0,TabellenOffset0);
   //	[ErgebnisTable setFrameOrigin:Ecke];
   
   //	NSLog(@" ErgebnisTable description: %@\n",[[ErgebnisTable headerView]description]);
   [DruckView setTabelleMitDic:TabDic  mitFeld:DruckRect];
   NSMutableDictionary* HeaderDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   [HeaderDic setObject:[NSNumber numberWithInt:3] forKey:@"art"];
   [HeaderDic setObject:@"Test" forKey:@"nametext"];
   [HeaderDic setObject:@"Zeit" forKey:@"zeit"];
   [HeaderDic setObject:@"Fehler" forKey:@"anzfehler"];
   [HeaderDic setObject:@"Grafik" forKey:@"grafik"];
   [HeaderDic setObject:@"Note" forKey:@"note"];
   [HeaderDic setObject:@"" forKey:@"anzrichtig"];
   [HeaderDic setObject:@"" forKey:@"anzaufgaben"];
   [HeaderDic setObject:@"" forKey:@"modus"];
   [HeaderDic setObject:@"" forKey:@"testname"];
   [HeaderDic setObject:@"" forKey:@"maxzeit"];
   [HeaderDic setObject:@"Mittel" forKey:@"mittel"];
   [HeaderDic setObject:@"Datum" forKey:@"datumtext"];
   //NSLog(@"HeaderDic: einDic: %@ ",[HeaderDic description]);
   //[returnErgebnisDicArray addObject:HeaderDic];
   
   NSMutableArray* TabArray=[[NSMutableArray alloc]initWithCapacity:0];
   NSMutableArray* SeitenArray=[[NSMutableArray alloc]initWithCapacity:0];
   
   int index=0;
   NSEnumerator* DicEnum=[derDicArray objectEnumerator];
   NSMutableDictionary* einDic;
   NSRect ZeilenFeld=DruckRect;
   ZeilenFeld.origin=NSMakePoint(0,TabellenOffset1+1);
   [TabArray addObject:[NSNumber numberWithFloat:ZeilenFeld.origin.y]];
   [SeitenArray addObject:[NSNumber numberWithFloat:ZeilenFeld.origin.y]];
   ZeilenFeld.size.height=Zeilenhoehe;
   ZeilenFeld.size.width-=2;
   
   
   NSView* HeaderView=[self ZeilenViewMitDic:HeaderDic inFeld:ZeilenFeld mitSchnitt:TabSchriftgroesse mitFormatDic:NULL farbig:farbig];
   [DruckView addSubview:HeaderView];
   ZeilenFeld.origin.y+=Reihenhoehe;
   [TabArray addObject:[NSNumber numberWithFloat:ZeilenFeld.origin.y]];
   ZeilenFeld.origin.y+=4;
   int Seite=1;
   while (einDic=(NSMutableDictionary*)[DicEnum nextObject])
   {
      //NSLog(@"index: %d	ZeilenFeld:x  %1.2f		y: %1.2f	w: %1.2f	h: %1.2f",index,ZeilenFeld.origin.x,ZeilenFeld.origin.y,ZeilenFeld.size.width,ZeilenFeld.size.height);
      //[[NSColor redColor]set];
      //[NSBezierPath strokeRect:ZeilenFeld];
      //NSLog(@"ZeilenView	einDic: %@",[einDic description]);
      
      //NSLog(@"index: %d	ZeilenFeld:y  %1.2f",index,ZeilenFeld.origin.y);
      //		NSView* ZeilenView=[self ZeilenViewMitDic:einDic inFeld:ZeilenFeld mitSchnitt:TabSchriftgroesse mitFormatDic:NULL];
      //		[DruckView addSubview:ZeilenView];
      [einDic setObject:[NSNumber numberWithBool:farbig]forKey:@"farbig"];
      //		NSLog(@"setDruckView: einDic: %@",[einDic description]);
      float rest=Seite*Feldhoehe-ZeilenFeld.origin.y;
      int anzTest=0;
      float Bedarf=0.0;
      if ([[einDic objectForKey:@"art"]intValue]==1)//eine Namenzeile
      {
         anzTest=[[einDic objectForKey:@"anztestforuser"]intValue];
         
         if (rest>((anzTest+1)*Reihenhoehe))//noch platz für ein Paket
         {
            NSView* ZeilenView=[self ZeilenViewMitDic:einDic inFeld:ZeilenFeld mitSchnitt:TabSchriftgroesse mitFormatDic:NULL farbig:farbig];
            [DruckView addSubview:ZeilenView];
            
            ZeilenFeld.origin.y+=Reihenhoehe;
         }
         else
         {
            [SeitenArray addObject:[NSNumber numberWithFloat:ZeilenFeld.origin.y]];
            [TabArray addObject:[NSNumber numberWithFloat:ZeilenFeld.origin.y]];
            
            //NSLog(@"					ZeilenView	einDic: %@",[einDic description]);
            ZeilenFeld.origin.y+=rest+1;
            Seite++;
            Bedarf=(anzTest+1)*Reihenhoehe;
            //				NSLog(@"Unteres Ende index: %d	Feldhoehe; %1.2f	rest: %1.2f		Bedarf: %1.2f	y : %1.2f",index,Feldhoehe,rest,Bedarf,ZeilenFeld.origin.y);
            NSRect KopfRect=ZeilenFeld;
            KopfRect.size.width+=2;
            KopfRect.size.height=20;
            NSTextField* KopfFeld=[[NSTextField alloc]initWithFrame:KopfRect];
            [KopfFeld setBordered:NO];
            NSFont* KopfFont;
            KopfFont=[NSFont fontWithName:@"Helvetica" size: 12];
            [KopfFeld setFont: KopfFont];
            NSString* KopfString=[@"Name: " stringByAppendingString:derUser];
            [KopfFeld setStringValue:KopfString];
            [DruckView addSubview:KopfFeld];
            ZeilenFeld.origin.y+=22;
            [TabArray addObject:[NSNumber numberWithFloat:ZeilenFeld.origin.y]];
            [SeitenArray addObject:[NSNumber numberWithFloat:ZeilenFeld.origin.y]];
            
            NSView* HeaderView=[self ZeilenViewMitDic:HeaderDic inFeld:ZeilenFeld mitSchnitt:TabSchriftgroesse mitFormatDic:NULL farbig:farbig];
            //[HeaderView setBordered:YES];
            [DruckView addSubview:HeaderView];
            ZeilenFeld.origin.y+=Reihenhoehe;
            [TabArray addObject:[NSNumber numberWithFloat:ZeilenFeld.origin.y]];
            ZeilenFeld.origin.y+=4;
            
            
            NSView* ZeilenView=[self ZeilenViewMitDic:einDic inFeld:ZeilenFeld mitSchnitt:TabSchriftgroesse mitFormatDic:NULL farbig:farbig];
            [DruckView addSubview:ZeilenView];
            ZeilenFeld.origin.y+=Reihenhoehe;
         }
         
      }
      else
      {
         NSView* ZeilenView=[self ZeilenViewMitDic:einDic inFeld:ZeilenFeld mitSchnitt:TabSchriftgroesse mitFormatDic:NULL farbig:farbig];
         [DruckView addSubview:ZeilenView];
         
         ZeilenFeld.origin.y+=Reihenhoehe;
      }
      //		[TabArray addObject:[NSNumber numberWithFloat:ZeilenFeld.origin.y]];
      
      index++;
   }//while einDic
   [TabArray addObject:[NSNumber numberWithFloat:ZeilenFeld.origin.y]];
   [SeitenArray addObject:[NSNumber numberWithFloat:ZeilenFeld.origin.y]];
   
   //NSLog(@"setDruckView: TabArray: %@",[TabArray description]);
   //	NSLog(@"setDruckView: SeitenArray: %@",[SeitenArray description]);
   
   NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   [NotificationDic setObject:[TabArray copy]forKey:@"tabarray"];
   [NotificationDic setObject:SeitenArray forKey:@"seitenarray"];
   NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
   [nc postNotificationName:@"drawTabelle" object:self userInfo:NotificationDic];
   
   
   //	[TestTable reloadData];
   
   //NSLog(@"Schluss: maxNamenbreite: %d  maxTitelbreite: %d",maxNamenbreite, maxTitelbreite);
   
   //NSLog(@"setKommentarMit Komm.DicArray: nach while");
   return DruckView;
}

- (rDruckView*)setDruckViewMitDicArray:(NSArray*)derDicArray	//mehrere Tests
                               forUser:(NSString*)derUser
                               mitFeld:(NSRect)dasFeld
{
   NSRect DruckRect=dasFeld;
   int obererRand=DruckRect.origin.y;
   int linkerRand=DruckRect.origin.x;
   
   int DruckbereichH=DruckRect.size.width;
   int DruckbereichV=DruckRect.size.height;
   //	NSLog(@"setDruckViewMitDicArray: %@",derUser);
   //	NSLog(@"setDruckViewMitDicArray DruckRect:	linkerRand: %d  obererRand: %d  Breite: %d Hoehe: %d",linkerRand,obererRand, DruckbereichH,DruckbereichV);
   
   
   float Feldhoehe=DruckRect.size.height;
   float Feldbreite=DruckRect.size.width;
   float AbstandLinks=DruckRect.origin.x;
   float AbstandOben=DruckRect.origin.y;
   
   int TabellenOffset1=70;
   int TabellenOffset2=0;
   int Schriftgroesse=8;
   int TabSchriftgroesse=Schriftgroesse;
   int Zeilenhoehe=11;
   int Reihenhoehe=Zeilenhoehe+2;
   int AnzDruckzeilen=[derDicArray count];
   int AnzZeilen1=(DruckRect.size.height-TabellenOffset1)/Reihenhoehe;
   int AnzZeilen2=(DruckRect.size.height-TabellenOffset2)/Reihenhoehe;
   int Seiten=1;
   if ((AnzDruckzeilen+1)>AnzZeilen1) //Mehr als eine Seite
   {
      Seiten+=(AnzDruckzeilen-AnzZeilen1)/AnzZeilen2;
      if ((AnzDruckzeilen-AnzZeilen1)%AnzZeilen2)//Rest von Zeilen
      {
         Seiten++;
      }
   }
   
   DruckRect.size.height+=(Seiten-1)*Feldhoehe;//Mindestens eine Seite
   
   //	NSLog(@"Druckbereich: %1.2f	AnzZeilen1: %d	AnzZeilen2: %d	Seiten: %d",DruckRect.size.height,AnzZeilen1,AnzZeilen2,	Seiten);
   
   rDruckView* DruckView=[[rDruckView alloc]initWithFrame:DruckRect];
   if ([derDicArray count]==0)
   {
      NSLog(@"setDruckViewDicArray forUser: kein DicArray");
      return NULL;
   }
   
   
   NSFontManager *fontManager = [NSFontManager sharedFontManager];
   //NSLog(@"*Statistik  setDruckViewMitDicArray* %@",[[derDicArray valueForKey:@"name"]description]);
   
   NSCalendarDate* heute=[NSCalendarDate date];
   [heute setCalendarFormat:@"%d.%m.%Y    Zeit: %H:%M"];
   
   NSString* TitelString=NSLocalizedString(@"Results from ",@"Ergebnisse vom ");
   NSString* KopfString=[NSString stringWithFormat:@"%@  %@%@",TitelString,[heute description],@"\r"];
   
   NSString* NameString=NSLocalizedString(@"Name: ",@"Name: ");
   NSString* UserString=[NSString stringWithFormat:@"%@  %@ %@",NameString,derUser,@"\r"];
   
   //Font für Titelzeile
   NSFont* TitelFont;
   TitelFont=[NSFont fontWithName:@"Helvetica" size: 14];
   //Font für Userzeile
   NSFont* UserFont;
   UserFont=[NSFont fontWithName:@"Helvetica" size: 12];
   
   [[DruckView textStorage]beginEditing];
   
   //Stil für Titelzeile
   NSMutableParagraphStyle* TitelStil=[[NSMutableParagraphStyle alloc]init];
   [TitelStil setTabStops:[NSArray array]];//default weg
   NSTextTab* TitelTab1=[[NSTextTab alloc]initWithType:NSLeftTabStopType location:90];
   
   //Stil für Abstand12
   NSMutableParagraphStyle* Abstand12Stil=[[NSMutableParagraphStyle alloc]init];
   NSFont* Abstand12Font=[NSFont fontWithName:@"Helvetica" size: 12];
   NSMutableAttributedString* attrAbstand12String=[[NSMutableAttributedString alloc] initWithString:@" \r"];
   [attrAbstand12String addAttribute:NSParagraphStyleAttributeName value:Abstand12Stil range:NSMakeRange(0,1)];
   [attrAbstand12String addAttribute:NSFontAttributeName value:Abstand12Font range:NSMakeRange(0,1)];
   //Abstandzeile einsetzen
   
   [TitelStil addTabStop:TitelTab1];
   
   //Attr-String für Titelzeile zusammensetzen
   NSMutableAttributedString* attrTitelString=[[NSMutableAttributedString alloc] initWithString:KopfString];
   //	NSLog(@"attrTitelString: %@",attrTitelString);
   [attrTitelString addAttribute:NSParagraphStyleAttributeName value:TitelStil range:NSMakeRange(0,[KopfString length])];
   [attrTitelString addAttribute:NSFontAttributeName value:TitelFont range:NSMakeRange(0,[KopfString length])];
   
   //titelzeile einsetzen
   [[DruckView textStorage]setAttributedString:attrTitelString];
   
   //Stil für Abstand1
   NSMutableParagraphStyle* Abstand1Stil=[[NSMutableParagraphStyle alloc]init];
   NSFont* Abstand1Font=[NSFont fontWithName:@"Helvetica" size: 6];
   NSMutableAttributedString* attrAbstand1String=[[NSMutableAttributedString alloc] initWithString:@" \r"];
   [attrAbstand1String addAttribute:NSParagraphStyleAttributeName value:Abstand1Stil range:NSMakeRange(0,1)];
   [attrAbstand1String addAttribute:NSFontAttributeName value:Abstand1Font range:NSMakeRange(0,1)];
   
   //Abstandzeile einsetzen
   [[DruckView textStorage]appendAttributedString:attrAbstand1String];
   
   //Stil für Userzeile
   NSMutableParagraphStyle* UserStil=[[NSMutableParagraphStyle alloc]init];
   
   //Attr-String für Userzeile zusammensetzen
   NSMutableAttributedString* attrUserString=[[NSMutableAttributedString alloc] initWithString:UserString];
   //	NSLog(@"attrUserString: %@",attrUserString);
   
   [attrUserString addAttribute:NSParagraphStyleAttributeName value:UserStil range:NSMakeRange(0,[UserString length])];
   [attrUserString addAttribute:NSFontAttributeName value:UserFont range:NSMakeRange(0,[UserString length])];
   
   //Userzeile einsetzen
   [[DruckView textStorage]appendAttributedString:attrUserString];
   
   /*
    //Stil für Abstand1
    NSMutableParagraphStyle* Abstand1Stil=[[[NSMutableParagraphStyle alloc]init]autorelease];
    NSFont* Abstand1Font=[NSFont fontWithName:@"Helvetica" size: 6];
    NSMutableAttributedString* attrAbstand1String=[[NSMutableAttributedString alloc] initWithString:@" \r"];
    [attrAbstand1String addAttribute:NSParagraphStyleAttributeName value:Abstand1Stil range:NSMakeRange(0,1)];
    [attrAbstand1String addAttribute:NSFontAttributeName value:Abstand1Font range:NSMakeRange(0,1)];
    */
   
   //Abstandzeile einsetzen
   [[DruckView textStorage]appendAttributedString:attrAbstand1String];
   
   //Stil für FormFeed
   NSMutableParagraphStyle* FormFeedStil=[[NSMutableParagraphStyle alloc]init];
   NSMutableAttributedString* attrFormFeedString=[[NSMutableAttributedString alloc] initWithString:[[NSNumber numberWithInt:0xc] stringValue]];
   [attrFormFeedString addAttribute:NSParagraphStyleAttributeName value:FormFeedStil range:NSMakeRange(0,1)];
   [attrFormFeedString addAttribute:NSFontAttributeName value:Abstand1Font range:NSMakeRange(0,1)];
   
   //FormFeedzeile einsetzen
   //[[DruckView textStorage]appendAttributedString:attrFormFeedString];
   
   
   //Stil für Testnamezeile
   NSMutableParagraphStyle* TestnameStil=[[NSMutableParagraphStyle alloc]init];
   NSFont* TestnameFont=[NSFont fontWithName:@"Helvetica" size: 12];
   NSString* TestNameString=[@"Test: " stringByAppendingString:@"Alle Tests"];
   NSMutableAttributedString* attrTestnameString=[[NSMutableAttributedString alloc] initWithString:TestNameString];
   [attrTestnameString addAttribute:NSParagraphStyleAttributeName value:TestnameStil range:NSMakeRange(0,[TestNameString length])];
   [attrTestnameString addAttribute:NSFontAttributeName value:TestnameFont range:NSMakeRange(0,[TestNameString length])];
   
   [[DruckView textStorage]appendAttributedString:attrTestnameString];
   
   [[DruckView textStorage]endEditing];
   NSFont* TabellenKopfFont=[NSFont fontWithName:@"Helvetica" size: 8];
   NSFont* TabellenFont=[NSFont fontWithName:@"Helvetica" size: 8];
   
   //Tabulatoren aufaddieren
   
   
   float NameTab=Datumbreite;
   float ZeitTab=NameTab+Namebreite;
   float GrafikTab=ZeitTab+Zeitbreite;
   float AnzFehlerTab=GrafikTab+Grafikbreite;
   float FehlerTab=AnzFehlerTab+AnzFehlerbreite;
   float MittelTab=FehlerTab+Fehlerbreite;
   float NoteTab=FehlerTab+Fehlerbreite;
   
   NSMutableDictionary* TabDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   [TabDic setObject:[NSNumber numberWithFloat:Datumbreite]forKey:@"datumbreite"];
   [TabDic setObject:[NSNumber numberWithFloat:Zeitbreite]forKey:@"zeitbreite"];
   [TabDic setObject:[NSNumber numberWithFloat:Grafikbreite]forKey:@"grafikbreite"];
   [TabDic setObject:[NSNumber numberWithFloat:AnzFehlerbreite]forKey:@"anzfehlerbreite"];
   [TabDic setObject:[NSNumber numberWithFloat:Fehlerbreite]forKey:@"fehlerbreite"];
   [TabDic setObject:[NSNumber numberWithFloat:Mittelbreite]forKey:@"mittelbreite"];
   [TabDic setObject:[NSNumber numberWithFloat:Notebreite]forKey:@"notebreite"];
   [TabDic setObject:[NSNumber numberWithInt:TabellenOffset1]forKey:@"tabellenoffset1"];
   [TabDic setObject:[NSNumber numberWithInt:TabellenOffset2]forKey:@"tabellenoffset2"];
   [TabDic setObject:[NSNumber numberWithInt:Zeilenhoehe]forKey:@"zeilenhoehe"];
   [TabDic setObject:[NSNumber numberWithInt:[derDicArray count]]forKey:@"anzahlzeilen"];
   
   NSArray* TabKopfStringArray=[NSArray arrayWithObjects:@"Datum",@"Name",@"Zeit",@"Grafik",@"Fehler",@"",@"Note",nil];
   NSString* TabellenkopfString=[TabKopfStringArray componentsJoinedByString:@"\t"];
   [TabDic setObject:TabKopfStringArray forKey:@"tabkopfstringarray"];
   
   
   
   //	NSPoint Ecke=NSMakePoint(0,TabellenOffset0);
   //	[ErgebnisTable setFrameOrigin:Ecke];
   
   //	NSLog(@" ErgebnisTable description: %@\n",[[ErgebnisTable headerView]description]);
   [DruckView setTabelleMitDic:TabDic  mitFeld:DruckRect];
   NSMutableDictionary* HeaderDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   [HeaderDic setObject:[NSNumber numberWithInt:3] forKey:@"art"];
   [HeaderDic setObject:@"Test" forKey:@"nametext"];
   [HeaderDic setObject:@"Zeit" forKey:@"zeit"];
   [HeaderDic setObject:@"Fehler" forKey:@"anzfehler"];
   [HeaderDic setObject:@"Grafik" forKey:@"grafik"];
   [HeaderDic setObject:@"Note" forKey:@"note"];
   [HeaderDic setObject:@"" forKey:@"anzrichtig"];
   [HeaderDic setObject:@"" forKey:@"anzaufgaben"];
   [HeaderDic setObject:@"" forKey:@"modus"];
   [HeaderDic setObject:@"" forKey:@"testname"];
   [HeaderDic setObject:@"" forKey:@"maxzeit"];
   [HeaderDic setObject:@"Mittel" forKey:@"mittel"];
   [HeaderDic setObject:@"Datum" forKey:@"datumtext"];
   //NSLog(@"HeaderDic: einDic: %@ ",[HeaderDic description]);
   //[returnErgebnisDicArray addObject:HeaderDic];
   
   NSMutableArray* TabArray=[[NSMutableArray alloc]initWithCapacity:0];
   NSMutableArray* SeitenArray=[[NSMutableArray alloc]initWithCapacity:0];
   
   int index=0;
   NSEnumerator* DicEnum=[derDicArray objectEnumerator];
   NSMutableDictionary* einDic;
   NSRect ZeilenFeld=DruckRect;
   ZeilenFeld.origin=NSMakePoint(0,TabellenOffset1+1);
   [TabArray addObject:[NSNumber numberWithFloat:ZeilenFeld.origin.y]];
   [SeitenArray addObject:[NSNumber numberWithFloat:ZeilenFeld.origin.y]];
   ZeilenFeld.size.height=Zeilenhoehe;
   ZeilenFeld.size.width-=2;
   
   
   NSView* HeaderView=[self ZeilenViewMitDic:HeaderDic inFeld:ZeilenFeld mitSchnitt:TabSchriftgroesse mitFormatDic:NULL farbig:farbig];
   [DruckView addSubview:HeaderView];
   ZeilenFeld.origin.y+=Reihenhoehe;
   [TabArray addObject:[NSNumber numberWithFloat:ZeilenFeld.origin.y]];
   ZeilenFeld.origin.y+=4;
   int Seite=1;
   while (einDic=(NSMutableDictionary*)[DicEnum nextObject])
   {
      //NSLog(@"index: %d	ZeilenFeld:x  %1.2f		y: %1.2f	w: %1.2f	h: %1.2f",index,ZeilenFeld.origin.x,ZeilenFeld.origin.y,ZeilenFeld.size.width,ZeilenFeld.size.height);
      //[[NSColor redColor]set];
      //[NSBezierPath strokeRect:ZeilenFeld];
      //NSLog(@"ZeilenView	einDic: %@",[einDic description]);
      
      //NSLog(@"index: %d	ZeilenFeld:y  %1.2f",index,ZeilenFeld.origin.y);
      //		NSView* ZeilenView=[self ZeilenViewMitDic:einDic inFeld:ZeilenFeld mitSchnitt:TabSchriftgroesse mitFormatDic:NULL];
      //		[DruckView addSubview:ZeilenView];
      [einDic setObject:[NSNumber numberWithBool:farbig]forKey:@"farbig"];
      float rest=Seite*Feldhoehe-ZeilenFeld.origin.y;
      int anzTest=0;
      float Bedarf=0.0;
      if ([[einDic objectForKey:@"art"]intValue]==1)//eine Namenzeile
      {
         anzTest=[[einDic objectForKey:@"anztestforuser"]intValue];
         
         if (rest>((anzTest+1)*Reihenhoehe))//noch platz für ein Paket
         {
            NSView* ZeilenView=[self ZeilenViewMitDic:einDic inFeld:ZeilenFeld mitSchnitt:TabSchriftgroesse mitFormatDic:NULL farbig:farbig];
            [DruckView addSubview:ZeilenView];
            
            ZeilenFeld.origin.y+=Reihenhoehe;
         }
         else
         {
            [SeitenArray addObject:[NSNumber numberWithFloat:ZeilenFeld.origin.y]];
            [TabArray addObject:[NSNumber numberWithFloat:ZeilenFeld.origin.y]];
            
            //NSLog(@"					ZeilenView	einDic: %@",[einDic description]);
            ZeilenFeld.origin.y+=rest+1;
            Seite++;
            Bedarf=(anzTest+1)*Reihenhoehe;
            //				NSLog(@"Unteres Ende index: %d	Feldhoehe; %1.2f	rest: %1.2f		Bedarf: %1.2f	y : %1.2f",index,Feldhoehe,rest,Bedarf,ZeilenFeld.origin.y);
            NSRect KopfRect=ZeilenFeld;
            KopfRect.size.width+=2;
            KopfRect.size.height=20;
            NSTextField* KopfFeld=[[NSTextField alloc]initWithFrame:KopfRect];
            [KopfFeld setBordered:NO];
            NSFont* KopfFont;
            KopfFont=[NSFont fontWithName:@"Helvetica" size: 12];
            [KopfFeld setFont: KopfFont];
            NSString* KopfString=[@"Name: " stringByAppendingString:derUser];
            [KopfFeld setStringValue:KopfString];
            [DruckView addSubview:KopfFeld];
            ZeilenFeld.origin.y+=22;
            [TabArray addObject:[NSNumber numberWithFloat:ZeilenFeld.origin.y]];
            [SeitenArray addObject:[NSNumber numberWithFloat:ZeilenFeld.origin.y]];
            
            NSView* HeaderView=[self ZeilenViewMitDic:HeaderDic inFeld:ZeilenFeld mitSchnitt:TabSchriftgroesse mitFormatDic:NULL farbig:farbig];
            //[HeaderView setBordered:YES];
            [DruckView addSubview:HeaderView];
            ZeilenFeld.origin.y+=Reihenhoehe;
            [TabArray addObject:[NSNumber numberWithFloat:ZeilenFeld.origin.y]];
            ZeilenFeld.origin.y+=4;
            
            
            NSView* ZeilenView=[self ZeilenViewMitDic:einDic inFeld:ZeilenFeld mitSchnitt:TabSchriftgroesse mitFormatDic:NULL farbig:farbig];
            [DruckView addSubview:ZeilenView];
            ZeilenFeld.origin.y+=Reihenhoehe;
         }
         
      }
      else
      {
         NSView* ZeilenView=[self ZeilenViewMitDic:einDic inFeld:ZeilenFeld mitSchnitt:TabSchriftgroesse mitFormatDic:NULL farbig:farbig];
         [DruckView addSubview:ZeilenView];
         
         ZeilenFeld.origin.y+=Reihenhoehe;
      }
      //		[TabArray addObject:[NSNumber numberWithFloat:ZeilenFeld.origin.y]];
      
      index++;
   }//while einDic
   [TabArray addObject:[NSNumber numberWithFloat:ZeilenFeld.origin.y]];
   [SeitenArray addObject:[NSNumber numberWithFloat:ZeilenFeld.origin.y]];
   
   //NSLog(@"setDruckView: TabArray: %@",[TabArray description]);
   //	NSLog(@"setDruckView: SeitenArray: %@",[SeitenArray description]);
   
   NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   [NotificationDic setObject:[TabArray copy]forKey:@"tabarray"];
   [NotificationDic setObject:SeitenArray forKey:@"seitenarray"];
   NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
   [nc postNotificationName:@"drawTabelle" object:self userInfo:NotificationDic];
   
   
   //	[TestTable reloadData];
   
   //NSLog(@"Schluss: maxNamenbreite: %d  maxTitelbreite: %d",maxNamenbreite, maxTitelbreite);
   
   //NSLog(@"setKommentarMit Komm.DicArray: nach while");
   return DruckView;
}

- (NSView*)ZeilenViewMitDic:(NSDictionary*)derZeilenDic
                     inFeld:(NSRect)dasFeld
                 mitSchnitt:(int)dieSchriftgroesse
               mitFormatDic:(NSDictionary*)derFormatDic
                     farbig:(BOOL)mitFarbe
{
   NSRect DruckFeld=dasFeld;
   DruckFeld.size.width-+5;
   NSView* ZeilenView=[[NSView alloc]initWithFrame:DruckFeld];
   NSPoint DruckPoint=NSMakePoint(0,0);
   float h=dasFeld.size.height;
   //	NSLog(@"ZeilenViewMitDic:        derZeilenDic: %@",[derZeilenDic description]);
   
   int ZeilenArt=[[derZeilenDic objectForKey:@"art"]intValue];
   switch (ZeilenArt)
   {
      case 1://Namenzeile
      case 2://Datenzeile
      {
         int anzAufgaben=0;
         int anzRichtig=0;
         int anzFehler=0;
         int Zeit=0;
         int maxZeit=120;
         if ([derZeilenDic objectForKey:@"anzaufgaben"])
         {
            anzAufgaben=[[derZeilenDic objectForKey:@"anzaufgaben"]intValue];
         }
         if ([derZeilenDic objectForKey:@"anzrichtig"])
         {
            anzRichtig=[[derZeilenDic objectForKey:@"anzaufgaben"]intValue];
         }
         if ([derZeilenDic objectForKey:@"anzrichtig"])
         {
            anzRichtig=[[derZeilenDic objectForKey:@"anzrichtig"]intValue];
         }
         if ([derZeilenDic objectForKey:@"anzfehler"])
         {
            anzFehler=[[derZeilenDic objectForKey:@"anzfehler"]intValue];
         }
         if ([derZeilenDic objectForKey:@"zeit"])
         {
            Zeit=[[derZeilenDic objectForKey:@"zeit"]intValue];
         }
         if ([derZeilenDic objectForKey:@"maxzeit"])
         {
            maxZeit=[[derZeilenDic objectForKey:@"maxzeit"]intValue];
         }
         
         NSFont* TabellenFont=[NSFont fontWithName:@"Helvetica" size: 8];
         
         
         DruckFeld.origin=DruckPoint;
         
         if ([derZeilenDic objectForKey:@"datum"])
         {
            DruckFeld.size.width=Datumbreite-10;
            DruckFeld.origin.x+=2;
            NSTextField* DatumFeld=[[NSTextField alloc]initWithFrame:DruckFeld];;
            [DatumFeld setAlignment:NSRightTextAlignment];
            [DatumFeld setFont:TabellenFont];
            [DatumFeld setBordered:NO];
            
            NSCalendarDate* tempDate=[[NSCalendarDate alloc]initWithString:[[derZeilenDic objectForKey:@"datum"]description]];
            if (tempDate)
            {
               //int test=[[NSCalendarDate calendarDate] dayOfMonth];
               //NSLog(@"Heute ganz: %@ test heute: %d",[NSCalendarDate calendarDate],test);
               int tag=[tempDate dayOfMonth];
               int monat=[tempDate monthOfYear];
               int jahr=[tempDate yearOfCommonEra];
               NSString* TagString=[NSString stringWithFormat:@"%d.%d.%d",tag,monat,jahr];
               //[TagString drawAtPoint:DruckPoint withAttributes:TabellenAttrDic];
               [DatumFeld setStringValue:TagString];
            }
            [ZeilenView addSubview:DatumFeld];
         }
         DruckPoint.x+=Datumbreite;
         
         if ((ZeilenArt==1)&&[derZeilenDic objectForKey:@"nametext"])
         {
            //NSDictionary* tempFormatDic=[derFormatDic objectForKey:@"datenzeilenformat"];
            DruckFeld.origin=DruckPoint;
            DruckFeld.origin.x+=4;
            DruckFeld.size.width=Namebreite-6;
            NSTextField* NameFeld=[[NSTextField alloc]initWithFrame:DruckFeld];;
            [NameFeld setAlignment:NSLeftTextAlignment];
            [NameFeld setFont:TabellenFont];
            [NameFeld setBordered:NO];
            [NameFeld setStringValue:[derZeilenDic objectForKey:@"nametext"]];
            [ZeilenView addSubview:NameFeld];
         }
         DruckPoint.x+=Namebreite;
         
         if ([derZeilenDic objectForKey:@"zeit"])
         {
            
            //NSDictionary* tempFormatDic=[derFormatDic objectForKey:@"datenzeilenformat"];
            DruckFeld.origin=DruckPoint;
            DruckFeld.size.width=Zeitbreite-4;
            DruckFeld.origin.x+=2;
            NSTextField* ZeitFeld=[[NSTextField alloc]initWithFrame:DruckFeld];;
            [ZeitFeld setAlignment:NSRightTextAlignment];
            [ZeitFeld setFont:TabellenFont];
            [ZeitFeld setBordered:NO];
            [ZeitFeld setStringValue:[[derZeilenDic objectForKey:@"zeit"]stringValue]];
            [ZeilenView addSubview:ZeitFeld];
            //[[[derZeilenDic objectForKey:@"zeit"]stringValue]drawAtPoint:DruckPoint withAttributes:Attr];
         }
         DruckPoint.x+=Zeitbreite;
         //NSLog(@"Grafik: %@",[derZeilenDic description]);
         
         if (anzAufgaben)
         {
            //NSLog(@"Grafik: %@",[derZeilenDic description]);
            NSRect GrafikRahmen=NSMakeRect(DruckPoint.x,DruckPoint.y,Grafikbreite,h);
            
            rGrafikView* GrafikFeld=[[rGrafikView alloc]initWithFrame:GrafikRahmen];
            [GrafikFeld setGrafikDaten:derZeilenDic];
            [ZeilenView addSubview:GrafikFeld];
            
         }//anzAufgaben
         DruckPoint.x+=Grafikbreite;
         
         if ([derZeilenDic objectForKey:@"mittel"])
         {
            
            //NSDictionary* tempFormatDic=[derFormatDic objectForKey:@"datenzeilenformat"];
            DruckFeld.origin=DruckPoint;
            DruckFeld.size.width=Mittelbreite-8;
            DruckFeld.origin.x+=2;
            NSTextField* MittelFeld=[[NSTextField alloc]initWithFrame:DruckFeld];;
            [MittelFeld setAlignment:NSRightTextAlignment];
            [MittelFeld setFont:TabellenFont];
            [MittelFeld setBordered:NO];
            NSString* MittelString=[NSString stringWithFormat:@"%2.1f",[[derZeilenDic objectForKey:@"mittel"]floatValue]];
            
            [MittelFeld setStringValue:MittelString];
            [ZeilenView addSubview:MittelFeld];
            //[[[derZeilenDic objectForKey:@"zeit"]stringValue]drawAtPoint:DruckPoint withAttributes:Attr];
         }
         DruckPoint.x+=Mittelbreite;
         
         
         if (anzFehler)
         {
            NSRect GrafikRahmen=NSMakeRect(DruckPoint.x+2,DruckPoint.y,Fehlerbreite-3,h);
            
            rFehlerView* FehlerFeld=[[rFehlerView alloc]initWithFrame:GrafikRahmen];
            [FehlerFeld setGrafikDaten:derZeilenDic];
            [ZeilenView addSubview:FehlerFeld];
            
         }//anzAufgaben
         DruckPoint.x+=Fehlerbreite;
         
         if ([derZeilenDic objectForKey:@"note"])
         {	
            DruckFeld.origin=DruckPoint;
            DruckFeld.origin.x+=2;
            DruckFeld.size.width=Notebreite-8;
            if ([mitNoteCheck state])
            {
               NSTextField* NoteFeld=[[NSTextField alloc]initWithFrame:DruckFeld];;
               [NoteFeld setAlignment:NSRightTextAlignment];
               [NoteFeld setFont:TabellenFont];
               [NoteFeld setBordered:NO];
               [NoteFeld setStringValue:[derZeilenDic objectForKey:@"note"]];
               [ZeilenView addSubview:NoteFeld];
            }
         }
         
         
      }break;
         
      case 3://Headerzeile
      {
         //NSLog(@"Header");
         
         NSFont* TabellenFont=[NSFont fontWithName:@"Helvetica" size: 8];
         DruckFeld.origin=DruckPoint;
         //NSLog(@"Header: derZeilenDic: %@",[derZeilenDic description]);
         if ([derZeilenDic objectForKey:@"datumtext"])
         {			
            DruckFeld.size.width=Datumbreite-10;
            DruckFeld.origin.x+=2;
            NSTextField* DatumFeld=[[NSTextField alloc]initWithFrame:DruckFeld];
            [DatumFeld setAlignment:NSCenterTextAlignment];
            [DatumFeld setFont:TabellenFont];
            [DatumFeld setBordered:NO];
            [DatumFeld setStringValue:[derZeilenDic objectForKey:@"datumtext"]];
            [ZeilenView addSubview:DatumFeld];
         }
         DruckPoint.x+=Datumbreite;
         if ([derZeilenDic objectForKey:@"nametext"])
         {	
            //NSDictionary* tempFormatDic=[derFormatDic objectForKey:@"datenzeilenformat"];
            DruckFeld.origin=DruckPoint;
            DruckFeld.origin.x+=4;
            DruckFeld.size.width=Namebreite-6;
            NSTextField* NameFeld=[[NSTextField alloc]initWithFrame:DruckFeld];
            [NameFeld setAlignment:NSLeftTextAlignment];
            [NameFeld setFont:TabellenFont];
            [NameFeld setBordered:NO];
            [NameFeld setStringValue:[derZeilenDic objectForKey:@"nametext"]];
            [ZeilenView addSubview:NameFeld];
         }
         DruckPoint.x+=Namebreite;
         if ([derZeilenDic objectForKey:@"zeit"])
         {
            //NSDictionary* tempFormatDic=[derFormatDic objectForKey:@"datenzeilenformat"];
            DruckFeld.origin=DruckPoint;
            DruckFeld.size.width=Zeitbreite-2;
            DruckFeld.origin.x+=1;
            NSTextField* ZeitFeld=[[NSTextField alloc]initWithFrame:DruckFeld];;
            [ZeitFeld setAlignment:NSCenterTextAlignment];
            [ZeitFeld setFont:TabellenFont];
            [ZeitFeld setBordered:NO];
            [ZeitFeld setStringValue:[derZeilenDic objectForKey:@"zeit"]];
            [ZeilenView addSubview:ZeitFeld];
         }
         DruckPoint.x+=Zeitbreite;
         //NSLog(@"Grafik: %@",[derZeilenDic description]);
         if ([derZeilenDic objectForKey:@"grafik"])
         {
            //NSDictionary* tempFormatDic=[derFormatDic objectForKey:@"datenzeilenformat"];
            DruckFeld.origin=DruckPoint;
            DruckFeld.size.width=Grafikbreite-4;
            DruckFeld.origin.x+=2;
            NSTextField* GrafikFeld=[[NSTextField alloc]initWithFrame:DruckFeld];;
            [GrafikFeld setAlignment:NSCenterTextAlignment];
            [GrafikFeld setFont:TabellenFont];
            [GrafikFeld setBordered:NO];
            [GrafikFeld setStringValue:[derZeilenDic objectForKey:@"grafik"]];
            [ZeilenView addSubview:GrafikFeld];
         }
         DruckPoint.x+=Grafikbreite;
         if ([derZeilenDic objectForKey:@"mittel"])
         {
            
            //NSDictionary* tempFormatDic=[derFormatDic objectForKey:@"datenzeilenformat"];
            DruckFeld.origin=DruckPoint;
            DruckFeld.size.width=Mittelbreite-2;
            DruckFeld.origin.x+=1;
            NSTextField* MittelFeld=[[NSTextField alloc]initWithFrame:DruckFeld];;
            [MittelFeld setAlignment:NSCenterTextAlignment];
            [MittelFeld setFont:TabellenFont];
            [MittelFeld setBordered:NO];
            [MittelFeld setStringValue:[derZeilenDic objectForKey:@"mittel"]];
            [ZeilenView addSubview:MittelFeld];
            //[[[derZeilenDic objectForKey:@"zeit"]stringValue]drawAtPoint:DruckPoint withAttributes:Attr];
         }
         DruckPoint.x+=Mittelbreite;
         
         if ([derZeilenDic objectForKey:@"anzfehler"])
         {
            //NSDictionary* tempFormatDic=[derFormatDic objectForKey:@"datenzeilenformat"];
            DruckFeld.origin=DruckPoint;
            DruckFeld.size.width=Fehlerbreite-4;
            DruckFeld.origin.x+=2;
            NSTextField* FehlerFeld=[[NSTextField alloc]initWithFrame:DruckFeld];;
            [FehlerFeld setAlignment:NSCenterTextAlignment];
            [FehlerFeld setFont:TabellenFont];
            [FehlerFeld setBordered:NO];
            [FehlerFeld setStringValue:[derZeilenDic objectForKey:@"anzfehler"]];
            [ZeilenView addSubview:FehlerFeld];
         }
         DruckPoint.x+=Fehlerbreite;
         
         if ([derZeilenDic objectForKey:@"note"])
         {
            //NSDictionary* tempFormatDic=[derFormatDic objectForKey:@"datenzeilenformat"];
            DruckFeld.origin=DruckPoint;
            DruckFeld.size.width=Notebreite-2;
            DruckFeld.origin.x+=1;
            NSTextField* NoteFeld=[[NSTextField alloc]initWithFrame:DruckFeld];;
            [NoteFeld setAlignment:NSCenterTextAlignment];
            [NoteFeld setFont:TabellenFont];
            [NoteFeld setBordered:NO];
            
            [NoteFeld setStringValue:[derZeilenDic objectForKey:@"note"]];
            if ([[derZeilenDic objectForKey:@"note"]length])
            {
               //NSBeep();
            }
            [ZeilenView addSubview:NoteFeld];
         }
         
         //NSLog(@"Header end");
      }break;
         
      case 4://TestnamenZeile
      {
         //		NSLog(@"TestnamenZeile start");
         //NSLog(@"Header");
         NSFont* TestTitelFont=[NSFont fontWithName:@"Helvetica-Bold" size: 8];
         
         NSFont* TabellenFont=[NSFont fontWithName:@"Helvetica" size: 8];
         DruckFeld.origin=DruckPoint;
         //		NSLog(@"TestTitel: derZeilenDic: %@",[derZeilenDic description]);
         
         if ([derZeilenDic objectForKey:@"datumtext"])
         {			
            DruckFeld.size.width=Datumbreite-10;
            DruckFeld.origin.x+=2;
            NSTextField* DatumFeld=[[NSTextField alloc]initWithFrame:DruckFeld];
            [DatumFeld setAlignment:NSRightTextAlignment];
            [DatumFeld setFont:TestTitelFont];
            [DatumFeld setBordered:NO];
            [DatumFeld setStringValue:[derZeilenDic objectForKey:@"datumtext"]];
            [ZeilenView addSubview:DatumFeld];
         }
         
         DruckPoint.x+=Datumbreite;
         
         if ([derZeilenDic objectForKey:@"nametext"])
         {	
            //NSDictionary* tempFormatDic=[derFormatDic objectForKey:@"datenzeilenformat"];
            DruckFeld.origin=DruckPoint;
            DruckFeld.origin.x+=4;
            DruckFeld.size.width=Namebreite-6;
            NSTextField* NameFeld=[[NSTextField alloc]initWithFrame:DruckFeld];
            [NameFeld setAlignment:NSLeftTextAlignment];
            [NameFeld setFont:TestTitelFont];
            [NameFeld setBordered:NO];
            [NameFeld setStringValue:[derZeilenDic objectForKey:@"nametext"]];
            [ZeilenView addSubview:NameFeld];
         }
         
         DruckPoint.x+=Namebreite;
         /*
          if ([derZeilenDic objectForKey:@"zeit"])
          {
          //NSDictionary* tempFormatDic=[derFormatDic objectForKey:@"datenzeilenformat"];
          DruckFeld.origin=DruckPoint;
          DruckFeld.size.width=Zeitbreite-2;
          DruckFeld.origin.x+=1;
          NSTextField* ZeitFeld=[[[NSTextField alloc]initWithFrame:DruckFeld]autorelease];;
          [ZeitFeld setAlignment:NSCenterTextAlignment];
          [ZeitFeld setFont:TabellenFont];
          [ZeitFeld setBordered:NO];
          [ZeitFeld setStringValue:[derZeilenDic objectForKey:@"zeit"]];
          [ZeilenView addSubview:ZeitFeld];
          }
          */
         DruckPoint.x+=Zeitbreite;
         //		NSLog(@"Zeilenviewmitdic Grafik: %@",[derZeilenDic description]);
         if ([derZeilenDic objectForKey:@"grafikdatentext"])
         {
            //NSDictionary* tempFormatDic=[derFormatDic objectForKey:@"datenzeilenformat"];
            DruckFeld.origin=DruckPoint;
            DruckFeld.size.width=Grafikbreite-4;
            DruckFeld.origin.x+=2;
            NSTextField* GrafikFeld=[[NSTextField alloc]initWithFrame:DruckFeld];;
            [GrafikFeld setAlignment:NSLeftTextAlignment];
            [GrafikFeld setFont:TabellenFont];
            [GrafikFeld setBordered:NO];
            [GrafikFeld setStringValue:[derZeilenDic objectForKey:@"grafikdatentext"]];
            [ZeilenView addSubview:GrafikFeld];
         }
         DruckPoint.x+=Grafikbreite;
         
         if ([derZeilenDic objectForKey:@"mittel"])
         {
            
            //NSDictionary* tempFormatDic=[derFormatDic objectForKey:@"datenzeilenformat"];
            DruckFeld.origin=DruckPoint;
            DruckFeld.size.width=Mittelbreite-2;
            DruckFeld.origin.x+=1;
            NSTextField* MittelFeld=[[NSTextField alloc]initWithFrame:DruckFeld];;
            [MittelFeld setAlignment:NSCenterTextAlignment];
            [MittelFeld setFont:TabellenFont];
            [MittelFeld setBordered:NO];
            [MittelFeld setStringValue:[derZeilenDic objectForKey:@"mittel"]];
            [ZeilenView addSubview:MittelFeld];
            //[[[derZeilenDic objectForKey:@"zeit"]stringValue]drawAtPoint:DruckPoint withAttributes:Attr];
         }
         
         DruckPoint.x+=Mittelbreite;
         /*
          if ([derZeilenDic objectForKey:@"anzfehler"])
          {
          //NSDictionary* tempFormatDic=[derFormatDic objectForKey:@"datenzeilenformat"];
          DruckFeld.origin=DruckPoint;
          DruckFeld.size.width=Fehlerbreite-4;
          DruckFeld.origin.x+=2;
          NSTextField* FehlerFeld=[[[NSTextField alloc]initWithFrame:DruckFeld]autorelease];;
          [FehlerFeld setAlignment:NSCenterTextAlignment];
          [FehlerFeld setFont:TabellenFont];
          [FehlerFeld setBordered:NO];
          [FehlerFeld setStringValue:[derZeilenDic objectForKey:@"anzfehler"]];
          [ZeilenView addSubview:FehlerFeld];
          }
          */
         DruckPoint.x+=Fehlerbreite;
         /*
          if ([derZeilenDic objectForKey:@"note"])
          {
          //NSDictionary* tempFormatDic=[derFormatDic objectForKey:@"datenzeilenformat"];
          DruckFeld.origin=DruckPoint;
          DruckFeld.size.width=Notebreite-2;
          DruckFeld.origin.x+=1;
          NSTextField* NoteFeld=[[[NSTextField alloc]initWithFrame:DruckFeld]autorelease];;
          [NoteFeld setAlignment:NSCenterTextAlignment];
          [NoteFeld setFont:TabellenFont];
          [NoteFeld setBordered:NO];
          
          [NoteFeld setStringValue:[derZeilenDic objectForKey:@"note"]];
          if ([[derZeilenDic objectForKey:@"note"]length])
          {
          //NSBeep();
          }
          [ZeilenView addSubview:NoteFeld];
          }
          */
         
         
         //		NSLog(@"TestnamenZeile end");
      }break;
   }//switch
   return ZeilenView;
}

- (void)NoteCellAktion:(id)sender
{
   int zeile=[TestTable selectedRow];
   NSDictionary* tempDic=[DatenQuelle DicForRow:zeile];
   //[NoteDic setDictionary:[DatenQuelle DicForRow:zeile]];
   //NSLog(@"NoteCellAktion: %@	tempDic: %@",[sender stringValue],[tempDic description]);
   //	[DatenQuelle markNoteChangedForRow:[TestTable selectedRow]];
}

- (IBAction)reportDeleteNoten:(id)sender
{
   NSLog(@"reportDeleteNoten");
   NSAlert *Warnung = [[NSAlert alloc] init];
   [Warnung addButtonWithTitle:NSLocalizedString(@"Delete All Grades",@"Alle Noten löschen")];
   [Warnung addButtonWithTitle:NSLocalizedString(@"Cancel",@"Abbrechen")];			
   [Warnung setMessageText:NSLocalizedString(@"Delete All Grades",@"Alle Noten löschen")];
   //NSString* I1=NSLocalizedString(@"Do you really want do delete the name %@?",@"Namen %@wiklich entfernen?");
   NSString* I1=NSLocalizedString(@"Do you really want do delete all quotes?",@"Noten wirklich löschen?");
   [Warnung setInformativeText:[NSString stringWithFormat:I1]];
   int antwort=[Warnung runModal];
   switch (antwort)
	  {
        case NSAlertFirstButtonReturn://Loeschen
        { 
           NSLog(@"FirstButtonReturn");
           NSArray* tempChangedArray=[DatenQuelle ClearNoteDicArray];
           if ([tempChangedArray count])
           {
              [self updateAdminStatistikDicArrayMitNoteChangedArray:tempChangedArray];
           }
           [TestTable deselectAll:NULL];
           [TestTable reloadData];
           
        }break;
           
        case NSAlertSecondButtonReturn://Cancel
        {
           NSLog(@"SecondButtonReturn");
           
        }break;
        case NSAlertThirdButtonReturn://		
        {
           NSLog(@"ThirdButtonReturn");
           NSLog(@"cancel");
           [NSApp stopModalWithCode:0];
           [[self window] orderOut:NULL];
           
        }break;
           
     }//switch
}

#pragma mark -
#pragma mark StatistikTable delegate:

#pragma mark -
#pragma mark StatistikTable Data Source:

- (long)numberOfRowsInTableView:(NSTableView *)aTableView
{
   return [TestDicArray count];
}


- (id)tableView:(NSTableView *)aTableView
objectValueForTableColumn:(NSTableColumn *)aTableColumn 
            row:(long)rowIndex
{
   //NSLog(@"objectValueForTableColumn");
   NSDictionary *einStatistikDic;
   if (rowIndex<[TestDicArray count])
   {
      einStatistikDic = [TestDicArray objectAtIndex: rowIndex];
      
   }
   //NSLog(@"einStatistikDic: aktiv: %d   Testname: %@",[[einStatistikDic objectForKey:@"aktiv"]intValue],[einStatistikDic objectForKey:@"name"]);
   
   return [einStatistikDic objectForKey:[aTableColumn identifier]];
   
}

- (void)tableView:(NSTableView *)aTableView 
   setObjectValue:(id)anObject 
   forTableColumn:(NSTableColumn *)aTableColumn 
              row:(long)rowIndex
{
   NSLog(@"setObjectValueForTableColumn");
   
   NSMutableDictionary* einStatistikDic;
   if (rowIndex<[TestDicArray count])
   {
      einStatistikDic=[TestDicArray objectAtIndex:rowIndex];
      [einStatistikDic setObject:anObject forKey:[aTableColumn identifier]];
   }
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(long)row
{
   //  NSLog(@"shouldSelectRow");  
   return YES;
}

- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(long)row
{
   //Ergebnisse nach Namen
   NSMutableDictionary* tempZeilenDic=(NSMutableDictionary*)[TestDicArray objectAtIndex:row];
   //	[tempZeilenDic setObject:[NSNumber numberWithBool:farbig]forKey:@"farbig"];
   //	[tempZeilenDic setObject:[NSNumber numberWithBool:NO]forKey:@"farbig"];
   //	NSLog(@"Statistik           willDisplayCell:  tempZeilenDic: %@",[tempZeilenDic description]);
   
   switch ([[tempZeilenDic objectForKey:@"art"]intValue])
   {
      case 0:
      case 1://NamenZeile
      case 2://DatenZeile
      {
         
         if ([[tableColumn identifier]isEqualToString:@"datumtext"])
         {
            NSFont* TabellenFont=[NSFont fontWithName:@"Helvetica" size: 12];
            [cell setFont:TabellenFont];
         }
         
         
         //NSLog(@"art=1: tempZeilenDic: %@",[tempZeilenDic description]);
         if ([[tableColumn identifier]isEqualToString:@"zeit"])
         {
            if ([[tempZeilenDic objectForKey:@"maxzeit"]intValue] ==[[tempZeilenDic objectForKey:@"zeit"]intValue])
            {
               //
               [cell setTextColor:[NSColor redColor]];
            }
            else
            {
               [cell setTextColor:[NSColor blackColor]];
            }
         }
         
         if ([[tableColumn identifier]isEqualToString:@"grafik"])
         {
            //NSLog(@" StatistikTable willDisplayCell Zeile: %d, ", row );
            //NSLog(@"willDisplayCell GrafikRahmen: %f  %f",[cell GrafikRahmen].size.height,[cell GrafikRahmen].size.width);
            
            if (tempZeilenDic)
            {
               //			NSLog(@"Grafik art = 1    abgelaufene Zeit: %@",[tempZeilenDic objectForKey:@"abgelaufenezeit"]);
               [cell setGrafikDaten:tempZeilenDic];
               //[[NSColor cyanColor]set];
            }
         }
         
         if ([[tableColumn identifier]isEqualToString:@"malpoints"])
         {
            if (tempZeilenDic)
            {
               [cell setGrafikDaten:tempZeilenDic];		
            }
         }
      }break;
      case 4://TestNamenzeile
      {
         //	NSLog(@"art = 4: tempZeilenDic: %@",[tempZeilenDic description]);
         
         if ([[tableColumn identifier]isEqualToString:@"datumtext"])
         {
            
            //		NSLog(@"setGrafikDaten:   tempZeilenDic: %@",[tempZeilenDic description]);
            NSFont* TestTitelFont=[NSFont fontWithName:@"Helvetica-Bold" size: 12];
            
            [cell setFont:TestTitelFont];
         }
         else
         {
            NSFont* TabellenFont=[NSFont fontWithName:@"Helvetica" size: 12];
            [cell setFont:TabellenFont];
         }
         
         
         
         if ([[tableColumn identifier]isEqualToString:@"grafik"])
         {
            //		NSLog(@"setGrafikDaten:   tempZeilenDic: %@",[tempZeilenDic description]);
            
            [cell setGrafikDaten:tempZeilenDic];
         }
         
         if ([[tableColumn identifier]isEqualToString:@"malpoints"])
         {
            if (tempZeilenDic)
            {
               [cell setGrafikDaten:tempZeilenDic];		
            }
         }
         
      }break;
         
   }//switch
   
}//willDisplayCell

#pragma mark -
#pragma mark TabView delegate:
- (BOOL)tabView:(NSTabView *)tabView shouldSelectTabViewItem:(NSTabViewItem *)tabViewItem
{
   //	NSLog(@"shouldSelectTabViewItem: %d",[[tabViewItem identifier]intValue]);
   
   //NSLog(@"shouldSelectTabViewItem");
   [PrintTaste setEnabled:AdminOK];
   [mitNoteCheck setEnabled:AdminOK];
   [[self window]makeFirstResponder:[self window]];
   switch([[tabViewItem identifier]intValue] )
   {
      case 2:
      {
         [TestTable reloadData];
         if (AdminOK)
         {
            //NSLog(@"shouldSelectTabViewItem Name: %@ 	Note: %@",[NamenFeld stringValue],[NoteCombo stringValue]);
            NSMutableDictionary* tempUpdateDic=[[NSMutableDictionary alloc]initWithCapacity:0];
            [tempUpdateDic setObject:[NamenFeld stringValue] forKey:@"name"];
            
            [tempUpdateDic setObject:[NoteCombo stringValue] forKey:@"note"];
            //NSLog(@"reportAdminNamen tempUpdateDic: %@ retain: %d",[tempUpdateDic description],[tempUpdateDic retainCount]);
            [self updateAdminStatistikDicArrayMitNoteChangedDic:tempUpdateDic];
            [NoteCombo setStringValue:@""];
            
            if ([TestNamenPopKnopf indexOfSelectedItem]<[TestNamenPopKnopf numberOfItems]-1)//nicht Alle
            {
               [AdminTestNamenPopKnopf selectItemWithTitle:[TestNamenPopKnopf titleOfSelectedItem]];
               [self setAdminTestTableForTest:[TestNamenPopKnopf titleOfSelectedItem]];
            }
            else
            {
               [AdminTestNamenPopKnopf selectItemWithTitle:[TestNamenPopKnopf titleOfSelectedItem]];
               [self setAdminTestTableForAllTests];
               //[AdminTestNamenPopKnopf selectItemAtIndex:0];
               //[self setAdminTestTableForTest:[AdminTestNamenPopKnopf titleOfSelectedItem]];
               
            }
         }
         [DeleteTestKnopf setEnabled:NO];
         return AdminOK;
      }break;
         
      case 1:
      {
         if (AdminOK)
         {
            
            //Change von Noten sichern
            [TestTable deselectAll:NULL];
            [DeleteTestKnopf setEnabled:NO];
            NSArray* tempChangedArray=[DatenQuelle NoteChangedDicArray];
            if ([tempChangedArray count])
            {
               [self updateAdminStatistikDicArrayMitNoteChangedArray:tempChangedArray];
            }
            
            if ([AdminTestNamenPopKnopf indexOfSelectedItem]<[AdminTestNamenPopKnopf numberOfItems]-1)//nicht Alle
            {
               [TestNamenPopKnopf selectItemWithTitle:[AdminTestNamenPopKnopf titleOfSelectedItem]];
               //NSString* tempName=[NamenPopMenu titleOfSelectedItem];
               [self setTableVonTest:[AdminTestNamenPopKnopf titleOfSelectedItem] forUser:[NamenPopMenu titleOfSelectedItem]];
            }
            else
            {
               [TestNamenPopKnopf selectItemWithTitle:[AdminTestNamenPopKnopf titleOfSelectedItem]];
               [self setTableForAllTestsForUser:[NamenPopMenu titleOfSelectedItem]];
            }
            [NamenFeld setStringValue:[NamenPopMenu titleOfSelectedItem]];
            
            [NoteCombo setHidden:NO];
            [NoteLabel setHidden:NO];
            
            //[NoteCombo setStringValue:@""];
            //NSLog(@"TestDicArray for tempName: %@	: %@",tempName,[TestDicArray description]);
            if ([TestDicArray count])//Es hat Dics fuer den User
            {
               
               NSDictionary* tempDic=[TestDicArray objectAtIndex:0];
               //NSLog(@"tempDic: %@",[tempDic description]);
               if ([tempDic objectForKey:@"note"])
               {
                  [NoteCombo setStringValue:[tempDic objectForKey:@"note"]];
               }
               else
               {
                  [NoteCombo setStringValue:@""];
               }
               
            }
            [StatistikTable reloadData];
            return YES;
         }
      }break;
   }//switch
   return YES;
}
#pragma mark -




@end
