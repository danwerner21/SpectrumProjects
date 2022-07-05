
/*//////////////////////////////////////////////////////////////////
              -    FB Aka Heartman/Hearty 2016     -                   
              -   http://heartygfx.blogspot.com    -                  
              -       OpenScad Parametric Box      -                     
              -         CC BY-NC 3.0 License       -                      
////////////////////////////////////////////////////////////////////                                                                                                             
12/02/2016 - Fixed minor bug 
28/02/2016 - Added holes ventilation option                    
09/03/2016 - Added PCB feet support, fixed the shell artefact on export mode. 

*/////////////////////////// - Info - //////////////////////////////

// All coordinates are starting as integrated circuit pins.
// From the top view :

//   CoordD           <---       CoordC
//                                 ^
//                                 ^
//                                 ^
//   CoordA           --->       CoordB


////////////////////////////////////////////////////////////////////


////////// - Paramètres de la boite - Box parameters - /////////////

/* [Box dimensions] */
// - Longueur - Length  
  Length        = 180;       
// - Largeur - Width
  Width         = 305;                     
// - Hauteur - Height  
  TopHeight        = 10;  
  BottomHeight     = 25;  
  SlopeHeight      = 20;
// - Epaisseur - Wall thickness  
  Thick         = 3;//[2:5]  


  
/* [Box options] */
// Pieds PCB - PCB feet (x4) 
  PCBFeet       = 1;// [0:No, 1:Yes]
// - Decorations to ventilation holes
  Vent          = 1;// [0:No, 1:Yes]
// - Decoration-Holes width (in mm)
  Vent_width    = 1.5;   



// - Diamètre Coin arrondi - Filet diameter  
  Filet         = 9;//[0.1:12] 
// - lissage de l'arrondi - Filet smoothness  
  Resolution    = 50;//[1:100] 
// - Tolérance - Tolerance (Panel/rails gap)
  m             = 0.9;
  
/* [PCB_Feet--the_board_will_not_be_exported) ] */
//All dimensions are from the center foot axis
// - Coin bas gauche - Low left corner X position
PCBPosX         = -5;
// - Coin bas gauche - Low left corner Y position
PCBPosY         = 10;
// - Longueur PCB - PCB Length
PCBLength       = 130;
// - Largeur PCB - PCB Width
PCBWidth        = 213;
// - Heuteur pied - Feet height
FootHeight      = 9;
// - Diamètre pied - Foot diameter
FootDia         = 8;
// - Diamètre trou - Hole diameter
FootHole        = 3;  
  

/* [STL element to export] */
//Top shell
  TShell        = 0;// [0:No, 1:Yes]
//Bottom shell
  BShell        = 1;// [0:No, 1:Yes]
  
  RLogo         = 0;// Logo
  
  Spacer         = 0;// keyboard Spacer


  
/* [Hidden] */
// - Couleur coque - Shell color  
Couleur1        = "Orange";       
// - Couleur panneaux - Panels color    
Couleur2        = "OrangeRed";    
// Thick X 2 - making decorations thicker if it is a vent to make sure they go through shell
Dec_Thick       = Vent ? Thick*2 : Thick; 
// - Depth decoration
Dec_size        = Vent ? Thick*2 : 0.8;

PCBL=PCBLength;
PCBW=PCBWidth;



   
module SlopeRoundBox($a=Length, $b=Width, $c=TopHeight+BottomHeight){
                    $fn=Resolution;     
                         
                        translate([Filet,-Filet/2,Filet])
                        {  
                    minkowski ()
                    {  
              
                    translate([0,($b/2)+1,TopHeight])
                       rotate(a=[0,-90,90])
                          linear_extrude(height =(($b/2)-Filet/2)+1, center = false, convexity = 0, twist = 0)
                              polygon(points=[[0,0],[(SlopeHeight+TopHeight)*-1,0],[(SlopeHeight+TopHeight)*-1,-30],  [TopHeight*-1,($a-Filet*2)*-1],[0,($a-Filet*2)*-1]], paths=[[3,2,1,0]]);                      
                        
                     rotate([270,0,0]){    
                        cylinder(r=Filet,h=Width/2+1, center = false);
                            } 
                        }
                    }
                }// End of RoundBox Module                


module RoundBox($a=Length, $b=Width, $c=TopHeight+BottomHeight){
                    $fn=Resolution;            
                    translate([0,Filet,Filet]){  
                    minkowski (){                                              
                        cube ([$a-(Length/2),$b-(2*Filet),$c-(2*Filet)], center = false);
                        rotate([0,90,0]){    
                        cylinder(r=Filet,h=Length/2, center = false);
                            } 
                        }
                    }
                }// End of RoundBox Module

      


module TopShell(){
    Thick = Thick*2;  
    difference(){    
        difference(){
            union(){    
                     difference() {
                      
                        difference(){
                            union() {
                                        KeyboardCutoutReinforcement();

                            difference(){
                                SlopeRoundBox();
                                translate([Thick/2,Thick/2,Thick/2]){     
                                        SlopeRoundBox($a=Length-Thick*2, $b=Width-Thick*2, $c=TopHeight+BottomHeight-Thick);
                                        }
                                        }
                                    }
                               translate([-Thick,-Thick,TopHeight]){// Cube à soustraire
                                   cube ([Length+100, Width+100, TopHeight+BottomHeight], center=false);
                                            }                                            
                                      }
                                }                                          

                difference(){
                    union(){
                        translate([3*Thick +5,Thick,TopHeight]){
                            rotate([90,0,0]){
                                    $fn=6;
                                    cylinder(d=16,Thick/2);
                                    }   
                            }
                            
                       translate([Length-((3*Thick)+5),Thick,TopHeight]){
                            rotate([90,0,0]){
                                    $fn=6;
                                    cylinder(d=16,Thick/2);
                                    }   
                            }

                    translate([3*Thick +5,Width-Thick/2-2.4,TopHeight]){
                            rotate([90,0,0]){
                                    $fn=6;
                                    cylinder(d=16,Thick/2);
                                    }   
                            }
                            
                       translate([Length-((3*Thick)+5),Width-Thick/2-2.4,TopHeight]){
                            rotate([90,0,0]){
                                    $fn=6;
                                    cylinder(d=16,Thick/2);
                                    }   
                            }


                        }
                            
                    } //Fin fixation box legs
                    
                    
            }

       }//fin difference decoration


///Put Difference Keyboard Cutout Here

            union(){ //sides holes
                $fn=50;
                translate([3*Thick+5,20,TopHeight+4]){
                    rotate([90,0,0]){
                    cylinder(d=2,20);
                    }
                }
                translate([Length-((3*Thick)+5),20,TopHeight+4]){
                    rotate([90,0,0]){
                    cylinder(d=2,20);
                    }
                }
                translate([3*Thick+5,Width+5,TopHeight+4]){
                    rotate([90,0,0]){
                    cylinder(d=2,20);
                    }
                }
                translate([Length-((3*Thick)+5),Width+5,TopHeight+4]){
                    rotate([90,0,0]){
                    cylinder(d=2,20);
                    }
                }
            }//fin de sides holes

       

        KeyboardCutout();

        }//fin de difference holes
        KeyboardFeet();
        

        
        

}// fin coque 





module BottomShell(){
    Thick = Thick*2;  
    translate([0,2,0]){
    
    difference(){    
        difference(){
            //Main Box
            union(){    
                     difference() {
                      
                        difference(){
                            union() {
                            difference(){
                                RoundBox($a=Length, $b=Width-2, $c=TopHeight+BottomHeight);
                                translate([Thick/2,Thick/2,Thick/2]){     
                                        RoundBox($a=Length-Thick, $b=Width-Thick-2, $c=TopHeight+BottomHeight-Thick);
                                        }
                                        }

                                    }
                               translate([-Thick,-Thick,BottomHeight]){// Cube à soustraire
                                   cube ([Length+100, Width+100, TopHeight+BottomHeight], center=false);
                                            }                                            
                                      }
                                }                                          


              
            }

       
            // vent holes
            union(){           
            for(i=[0:Thick:Length/4]){
                    translate([10+i,-Dec_Thick+Dec_size,1]){
                    cube([Vent_width,Dec_Thick,BottomHeight/2]);
                    }
                    translate([(Length-10) - i,-Dec_Thick+Dec_size,1]){
                    cube([Vent_width,Dec_Thick,BottomHeight/2]);
                    }
               
                  }
                }
                
        
            // VIdeo Opening    
            translate([-1,(Thick)+15,Thick+4]){
              cube([12,35,BottomHeight-11]);
            }   

            // Cassette Opening    
            translate([-1,(Thick)+60,Thick+4]){
              cube([12,27,BottomHeight-11]);
            }   

            // Expansion Opening    
            translate([-1,(Thick)+120,Thick-3]){
              cube([12,85,BottomHeight-8]);
            }   


            // Power Opening    
            translate([-1,(Thick)+207,Thick+4]){
              cube([12,17,BottomHeight-11]);
            }   
            
            // S-Video Opening    
            translate([-1,(Thick)+247,Thick+4]){
              cube([12,17,BottomHeight-11]);
            }   

    
            // Glamour Line
            translate([Length-1,0,BottomHeight-1.25]){
             cube([20,Width,20]);
                }               
            translate([0,0,BottomHeight-1.25]){
             cube([1,Width,20]);
                }
             translate([0,0,BottomHeight-1.25]){    
              cube([Length,1,5]);
            }  
             translate([0,Width-3,BottomHeight-1.25]){    
              cube([Length,20,5]);
            }  
           
                
            }//fin difference decoration


            union(){ //sides holes
                $fn=50;
                translate([3*Thick+5,20,BottomHeight-4]){
                    rotate([90,0,0]){
                    cylinder(d=2,20);
                    }
                }
                translate([Length-((3*Thick)+5),20,BottomHeight-4]){
                    rotate([90,0,0]){
                    cylinder(d=2,20);
                    }
                }
                translate([3*Thick+5,Width+5,BottomHeight-4]){
                    rotate([90,0,0]){
                    cylinder(d=2,20);
                    }
                }
                translate([Length-((3*Thick)+5),Width+5,BottomHeight-4]){
                   rotate([90,0,0]){
                    cylinder(d=2,20);
                    }
                }
            }//fin de sides holes
        }
        }//fin de difference holes
}



module foot(FootDia,FootHole,FootHeight){
    Filet=2;
    color("Orange")   
    translate([0,0,Filet-1.5])
    difference(){
    
    difference(){
            //translate ([0,0,-Thick]){
                cylinder(d=FootDia+Filet,FootHeight-Thick, $fn=100);
                        //}
                    rotate_extrude($fn=100){
                            translate([(FootDia+Filet*2)/2,Filet,0]){
                                    minkowski(){
                                            square(10);
                                            circle(Filet, $fn=100);
                                        }
                                 }
                           }
                   }
            cylinder(d=FootHole,FootHeight+1, $fn=100);
               }          
}


module KeyboardCutout()
{
      color("OrangeRed"){
        translate([50,Width-20,-20])
          {
                       rotate(a=[9,0,270])
           { 
                          linear_extrude(height =12, center = false, convexity = 0, twist = 0)              
                                polygon(points=[[25,15.7],[219,15.7],[219,33],[228.6,33],[228.6,51.8],[257.3,51.8],[257.3,95],[205,95],[203,95],[203,114],[80,114],[80,95],[6,95],[6,51.8],[34,51.8],[34,38],[25,38]], paths=[[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]]);        
               }
                            
            
               //LED OPENING
                 rotate(a=[0,0,270])
                            linear_extrude(height =12, center = false, convexity = 0, twist = 0)              
                                polygon(points=[[7,-30],[17.1,-30],[17.1,-32.1],[7,-32.1]], paths=[[0,1,2,3]]);  
               }              
        }
    }

module KeyboardCutoutReinforcement()
{
      color("OrangeRed"){
        translate([50,Width-20,-18])
          {
                       rotate(a=[9,0,270])
           { 
               
                                         linear_extrude(height =5, center = false, convexity = 0, twist = 0)              
                                polygon(points=[[23,12],[221,12],[221,31],[230.6,31],[230.6,49.8],[259.3,49.8],[259.3,97],[205,97],[205,116],[78,116],[78,97],[4,97],[4,49.8],[32,49.8],[32,41],[23,41]], paths=[[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]]);        

                         
           }
               
                            }              
        }
    }


module KeyboardFeet()
{
     color("OrangeRed"){
        translate([50,Width-20,-18])
          {
                       rotate(a=[9,0,270])
           { 
               
               translate([3*Thick-1.671,Thick+4.5,Thick/2]){foot(FootDia,FootHole,FootHeight);}
               translate([3*Thick+122,Thick+4.5,Thick/2]){foot(FootDia,FootHole,FootHeight);}
               translate([3*Thick+253.6,Thick+4.5,Thick/2]){foot(FootDia,FootHole,FootHeight);}
               translate([3*Thick-1.671,Thick+103,Thick/2]){foot(FootDia,FootHole,FootHeight);}
               translate([3*Thick+253.6,Thick+103,Thick/2]){foot(FootDia,FootHole,FootHeight);}
               translate([3*Thick+200.667,Thick+103,Thick/2]){foot(FootDia,FootHole,FootHeight);}
               }
                            }              
        }
    }


  
module BottomFeet(){     
//////////////////// - PCB only visible in the preview mode - /////////////////////    
    translate([3*Thick+2,Thick+5,FootHeight+(Thick/2)-0.5]){
    
    %square ([PCBL+10,PCBW+10]);
       translate([PCBL/2,PCBW/2,0.5]){ 
        color("Olive")
        %text("PCB", halign="center", valign="center", font="Arial black");
       }
    } // Fin PCB 
////////////////////////////// - 4 Feet - //////////////////////////////////////////     




//top 

    translate([(3*Thick)+2+5,(Thick)+5+4 ,Thick/2]){
        foot(FootDia,FootHole,FootHeight+0.2);
        }        

    translate([3*Thick+2+5,(Thick)+5+106,Thick/2]){
        foot(FootDia,FootHole,FootHeight+0.2);
            }
    translate([3*Thick+2+5,(Thick)+5+195,Thick/2]){
        foot(FootDia,FootHole,FootHeight+0.2);
        }

    // Middle 
    translate([(3*Thick)+2+44,(Thick)+5+4,Thick/2]){
        foot(FootDia,FootHole,FootHeight+0.2);
        }        
    translate([(3*Thick)+2+44,(Thick)+5+209,Thick/2]){
        foot(FootDia,FootHole,FootHeight+0.2);
        }        

    //bottom 
    translate([(3*Thick)+2+125,(Thick)+5+4,Thick/2]){
        foot(FootDia,FootHole,FootHeight+0.2);
        }        
    translate([(3*Thick)+2+125,(Thick)+5+209,Thick/2]){
        foot(FootDia,FootHole,FootHeight+0.2);
        }        
}

module Logo()
{
    
    
difference() {
translate([-10,-55,0])
     cube([20,110,3]);
scale([.50,.50, .50])
translate([0,0,1])
rotate([0,0,90])
    linear_extrude(height =10, center = false, convexity = 0, twist = 0)
               import(file = "N:/Projects/SinclairCase/sinclair.svg", center = true);    

}
    
}






///////////////////////////////////// - Main - ///////////////////////////////////////



if(BShell==1)
{
    color(Couleur1){ 
        BottomShell();
    }
    if (PCBFeet==1)
    // Feet
    translate([PCBPosX,PCBPosY,0]){ 
    BottomFeet();
    }
}



if(TShell==1)
{
    color( Couleur1,1){
        translate([0,Width,TopHeight+BottomHeight+0.2]){
            rotate([0,180,180]){
                TopShell();
            }
        }
    }
 
}

if(RLogo==1)
{
    color( Couleur2,1){
        translate([-30,-30,0]){
            Logo();
        }
    }
} 

if(Spacer==1)
{    
    
    color( Couleur2,1){
        translate([-60,-50,0]){
                              linear_extrude(height =25, center = false, convexity = 0, twist = 0)
                              polygon(points=[[0,0],[10,0],[10,10],[0,10]], paths=[[3,2,1,0]]);         
        }
}    
}



