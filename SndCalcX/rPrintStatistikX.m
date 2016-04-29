#import "rPrintStatistikX.h"

@implementation rPrintStatistik


- (id)init
{
   NSLog(@"rPrintStatistik init");
   self = [super initWithWindowNibName:@"SCPrintStatistik"];
   TestDicArray=[[NSMutableArray alloc] initWithCapacity:0];
   DatenQuelle=[[rStatistikDS alloc]init];
   
   NSNotificationCenter * nc;
   nc=[NSNotificationCenter defaultCenter];
   [nc addObserver:self
          selector:@selector(DruckenAktion:)
              name:@"Drucken"
            object:nil];
   
   return self;
}

- (void)awakeFromNib
{
   [StatistikTable setDelegate:self];
   [StatistikTable setDataSource:self];
   rGrafikCell* GrafikCell=[[rGrafikCell alloc]init];
   rFehlerCell* FehlerCell=[[rFehlerCell alloc]init];
   
   [[StatistikTable tableColumnWithIdentifier:@"grafik"]setDataCell:GrafikCell];
   [[StatistikTable tableColumnWithIdentifier:@"malpoints"]setDataCell:FehlerCell];
   //[[[self window]contentView]addSubview:StatistikTab];
   //[StatistikTab addSubview:StatistikTable];
   
   
   [TestTable setDelegate:DatenQuelle];
   [TestTable setDataSource:DatenQuelle];
   [[TestTable tableColumnWithIdentifier:@"grafik"]setDataCell:GrafikCell];
   [[TestTable tableColumnWithIdentifier:@"malpoints"]setDataCell:FehlerCell];
   
   [StatistikTab setDelegate:self];
   
   [IconFeld setImage:[NSImage imageNamed:@"duerergrau"]];
   
   [[self window]makeFirstResponder:SchliessenTaste];
   [SchliessenTaste setKeyEquivalent:@"\r"];
   
}


- (void)DruckenAktion:(NSNotification*)note
{
   NSLog(@"DruckenAktion: note: %@",[[note userInfo]description]);
}


- (void)printDicArray:(NSArray*)derDicArray
{
   
   NSTextView* DruckView=[[NSTextView alloc]init];
   //NSLog (@"Kommentar: printDicArray DicArray: %@",[derDicArray description]);
   NSPrintInfo* PrintInfo=[NSPrintInfo sharedPrintInfo];
   [PrintInfo setOrientation:NSPortraitOrientation];
   
   
   [PrintInfo setVerticalPagination: NSAutoPagination];
   
   [PrintInfo setHorizontallyCentered:NO];
   [PrintInfo setVerticallyCentered:NO];
   NSRect bounds=[PrintInfo imageablePageBounds];
   
   int x=bounds.origin.x;int y=bounds.origin.y;int h=bounds.size.height;int w=bounds.size.width;
   //NSLog(@"Bounds 1 x: %d y: %d  h: %d  w: %d",x,y,h,w);
   NSSize Papiergroesse=[PrintInfo paperSize];
   int leftRand=(Papiergroesse.width-bounds.size.width)/2;
   int topRand=(Papiergroesse.height-bounds.size.height)/2;
   int platzH=(Papiergroesse.width-bounds.size.width);
   
   int freiLinks=60;
   int freiOben=30;
   //int DruckbereichH=bounds.size.width-freiLinks+platzH*0.5;
   int DruckbereichH=Papiergroesse.width-freiLinks-leftRand;
   
   int DruckbereichV=bounds.size.height-freiOben;
   
   int platzV=(Papiergroesse.height-bounds.size.height);
   
   //NSLog(@"platzH: %d  platzV %d",platzH,platzV);
   
   int botRand=(Papiergroesse.height-topRand-bounds.size.height-1);
   
   [PrintInfo setLeftMargin:freiLinks];
   [PrintInfo setRightMargin:leftRand];
   [PrintInfo setTopMargin:freiOben];
   [PrintInfo setBottomMargin:botRand];
   
   
   int Papierbreite=(int)Papiergroesse.width;
   int Papierhoehe=(int)Papiergroesse.height;
   int obererRand=[PrintInfo topMargin];
   int linkerRand=(int)[PrintInfo leftMargin];
   int rechterRand=[PrintInfo rightMargin];
   
   //NSLog(@"linkerRand: %d  rechterRand: %d  Breite: %d Hoehe: %d",linkerRand,rechterRand, DruckbereichH,DruckbereichV);
   NSRect DruckFeld=NSMakeRect(linkerRand, obererRand, DruckbereichH, DruckbereichV);
   
   
   
   DruckView=TestTable;//[self setDruckViewMitFeld:DruckFeld mitKommentarDicArray:derProjektDicArray];
   
   
   
   
   
   //[DruckView setBackgroundColor:[NSColor grayColor]];
   //[DruckView setDrawsBackground:YES];
   NSPrintOperation* DruckOperation;
   DruckOperation=[NSPrintOperation printOperationWithView: DruckView
                                                 printInfo:PrintInfo];
   [DruckOperation setShowsPrintPanel:YES];
   [DruckOperation runOperation];
   
}

- (NSTextView*)setDruckViewMitDicArray:(NSArray*)derDicArray
                               mitFeld:(NSRect)dasFeld
{
   NSTableView* ErgebnisTable;
   //NSLog(@"setDruckKommentarMitKommentarDicArray: KommentarDicArray: %@",[derDicArray description]);
   NSTextView* DruckView=[[NSTextView alloc]initWithFrame:dasFeld];
   //[DruckView retain];
   if ([derDicArray count]==0)
   {
      NSLog(@"setDruckViewDicArray: kein DicArray");
      return NULL;
   }
   
   NSFontManager *fontManager = [NSFontManager sharedFontManager];
   NSLog(@"*Statistik  setDruckViewMitDicArray* %@",[[derDicArray valueForKey:@"name"]description]);
   
   NSCalendarDate* heute=[NSCalendarDate date];
   [heute setCalendarFormat:@"%d.%m.%Y    Zeit: %H:%M"];
   
   NSString* TitelString=NSLocalizedString(@"Results from ",@"Ergebnisse vom ");
   NSString* KopfString=[NSString stringWithFormat:@"%@  %@%@",TitelString,[heute description],@"\r\r"];
   
   //Font für Titelzeile
   NSFont* TitelFont;
   TitelFont=[NSFont fontWithName:@"Helvetica" size: 14];
   
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
   
   
   //Breite von variablen Feldern
   int maxNamenbreite=12;
   int maxTitelbreite=12;
   int Textschnitt=10;
   
   NSEnumerator* TabEnum=[derDicArray objectEnumerator];
   id einTabDic;
   NSLog(@"setDruckKommentarMit Komm.DicArray: vor while   Anz. Dics: %d",[derDicArray count]);
   
   
   
   
   NSEnumerator* DicArrayEnum=[derDicArray objectEnumerator];
   id einDic;
   while (einDic=[DicArrayEnum nextObject])//Tabulatoren setzen und Tabelle aufbauen
   {
      //NSLog(@"											setErgebnisse Mit Komm.DicArray: Beginn while 2. Runde");
      NSString* ProjektTitel;
      
      if ([einDic objectForKey:@"projekt"])
      {
         ProjektTitel=[einDic objectForKey:@"projekt"];
         //NSLog(@"ProjektTitel: %@",ProjektTitel);
      }
      else //Kein Projekt angegeben
      {
         ProjektTitel=@"Kein Projekt";
      }
      
      
      //Font für Projektzeile
      NSFont* ProjektFont;
      ProjektFont=[NSFont fontWithName:@"Helvetica" size: 12];
      
      NSString* ProjektString=NSLocalizedString(@"Project: ",@"Projekt: ");
      NSString* ProjektKopfString=[NSString stringWithFormat:@"%@    %@%@",ProjektString,ProjektTitel,@"\r"];
      
      //Stil für Projektzeile
      NSMutableParagraphStyle* ProjektStil=[[NSMutableParagraphStyle alloc]init];
      [ProjektStil setTabStops:[NSArray array]];//default weg
      NSTextTab* ProjektTab1=[[NSTextTab alloc]initWithType:NSLeftTabStopType location:150];
      [ProjektStil addTabStop:ProjektTab1];
      
      //Attr-String für Projektzeile zusammensetzen
      NSMutableAttributedString* attrProjektString=[[NSMutableAttributedString alloc] initWithString:ProjektKopfString];
      [attrProjektString addAttribute:NSParagraphStyleAttributeName value:ProjektStil range:NSMakeRange(0,[ProjektKopfString length])];
      [attrProjektString addAttribute:NSFontAttributeName value:ProjektFont range:NSMakeRange(0,[ProjektKopfString length])];
      
      //Projektzeile einsetzen
      [[DruckView textStorage]appendAttributedString:attrProjektString];
      
      //Stil für Abstand1
      NSMutableParagraphStyle* Abstand1Stil=[[NSMutableParagraphStyle alloc]init];
      NSFont* Abstand1Font=[NSFont fontWithName:@"Helvetica" size: 6];
      NSMutableAttributedString* attrAbstand1String=[[NSMutableAttributedString alloc] initWithString:@" \r"];
      [attrAbstand1String addAttribute:NSParagraphStyleAttributeName value:Abstand1Stil range:NSMakeRange(0,1)];
      [attrAbstand1String addAttribute:NSFontAttributeName value:Abstand1Font range:NSMakeRange(0,1)];
      //Abstandzeile einsetzen
      [[DruckView textStorage]appendAttributedString:attrAbstand1String];
      
      NSMutableString* TextString;
      if ([einDic objectForKey:@"kommentarstring"])
      {
         TextString=[[einDic objectForKey:@"kommentarstring"]mutableCopy];
      }
      else //Keine Kommentare in diesem Projekt
      {
         TextString=[NSLocalizedString(@"No comments for this Project",@"Keine Kommentare für dieses Projekt") mutableCopy];
      }
      
      
      int pos=[TextString length]-1;
      BOOL letzteZeileWeg=NO;
      if ([TextString characterAtIndex:pos]=='\r')
      {
         //NSLog(@"last Char ist r");
         //[TextString deleteCharactersInRange:NSMakeRange(pos-1,1)];
         letzteZeileWeg=YES;
         pos--;
      }
      
      if([TextString characterAtIndex:pos]=='\n')
      {
         NSLog(@"last Char ist n");
      }
      
      
      //NSLog(@"Ende setKommentar: TitelStil retainCount: %d",[TitelStil retainCount]);
      //NSLog(@"Ende setKommentar: attrTitelString retainCount: %d",[attrTitelString retainCount]);
      //NSLog(@"Ende setKommentar: TitelTab1 retainCount: %d",[TitelTab1 retainCount]);
      //[TitelTab1 release];
      //NSLog(@"Ende setKommentar%@",@"\r***\r\r\r");//: attrTitelString retainCount: %d",[attrTitelString retainCount]);
      //NSLog(@"setKommentarMit Komm.DicArray: Ende while");
      [[DruckView textStorage]appendAttributedString:attrAbstand12String];//Abstand zu nächstem Projekt 
      [[DruckView textStorage]appendAttributedString:attrAbstand12String];
      
   }//while Enum
   //NSLog(@"Schluss: maxNamenbreite: %d  maxTitelbreite: %d",maxNamenbreite, maxTitelbreite);
   
   //NSLog(@"setKommentarMit Komm.DicArray: nach while");
   //[KommentarView retain];
   return DruckView;
}
@end
