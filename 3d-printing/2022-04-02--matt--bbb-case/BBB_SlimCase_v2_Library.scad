// ******************************************
// Beaglebone Black Slim Case Library
// Functions and Constants
// By Isaac Hayes
// Copyright 2014
// http://scuttlebots.com
//
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License along
// with this program; if not, write to the Free Software Foundation, Inc.,
// 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
// ******************************************

// ************************************
// Dimensions and Locations Math(s)
// ************************************

// -All dimensions in millimeters
// -Origin at bottom left corner of PCB
// -Ethernet and power jack face left closest to origin
// -X and Y refer to position of lower left corner of compoenent from origin
// -Z refers to distance from top of component to the PCB
// -L and W are Lenght(X) and Width(Y) to specify component size

//Board Dimensions
BB_L = 86.36;
BB_W = 54.61;
BB_Z = 1.65;
BB_SmCurve_R = 6.35;
BB_LgCurve_R = 12.70;

//Mounting Hole Locations (Clockwise from Bottom)
BB_Hole1X = 14.61;
BB_Hole1Y = 3.18;

BB_Hole2X = 14.61;
BB_Hole2Y = BB_Hole1Y + 48.39;

BB_Hole3X = BB_Hole1X + 66.10;
BB_Hole3Y = 6.35 + 41.91;

BB_Hole4X = BB_Hole1X + 66.10;
BB_Hole4Y = 6.35;

BB_Hole_ID = 2.75;
BB_Hole_OD = 4.45;

//Pin Headers
BB_P9_X = 18.415;
BB_P9_Y = 0.635;
BB_P9_Z = 8.60;
BB_P9_L = 58.42;
BB_P9_W = 5.08;

BB_P8_X = 18.415;
BB_P8_Y = 48.895;
BB_P8_Z = 8.60;
BB_P8_L = 58.42;
BB_P8_W = 5.08;

//Capacitor
BB_Cap_X = 65.00;
BB_Cap_Y = 8.00;
BB_Cap_Z = 11.00;
BB_Cap_L = 6.00;
BB_Cap_W = 6.00;

//Power jack
BB_PJack_X = -2.54;
BB_PJack_Y = 5.461;
BB_PJack_Z = 10.75;
BB_PJack_L = 14.15;
BB_PJack_W = 9.00;

//Ethernet jack
BB_Eth_X = -2.54;
BB_Eth_Y = 21.717;
BB_Eth_Z = 13.33;
BB_Eth_L = 21.00;
BB_Eth_W = 16.10;

//Usb Host Port
BB_USBH_X = BB_L - 14.05;
BB_USBH_Y = 10.287 - 0.5;
BB_USBH_Z = 6.95;
BB_USBH_L = 14.05;
BB_USBH_W = 14.45 - 1.50;

//USB Mini Device Port
BB_USBD_X = -0.635;
BB_USBD_Y = 40.005 + 0.60;
BB_USBD_Z = 4.00;
BB_USBD_L = 6.91;
BB_USBD_W = 7.747;

//Micro HDMI port
BB_HDMI_X = BB_L + 0.635 - 7.50;
BB_HDMI_Y = 21.59 + 0.1;
BB_HDMI_Z = 2.90;
BB_HDMI_L = 7.50;
BB_HDMI_W = 6.55;

//MicroSD Card Port (Slot only)
BB_SD_X = BB_L - 14.90;
BB_SD_Y = 30.607 + 0.5;
BB_SD_Z = 1.75 - 0.5;
BB_SD_L = 14.90;
BB_SD_W = 11.05;

//CASE DIMENSIONS
//Outer Shell
Case_Thickness = 1.50 +.7;     //Wall Thickness
Case_Gap = 0.25;  //Gap between case walls and board
Case_L = BB_L + Case_Thickness*2 + Case_Gap*2;
Case_W = BB_W + Case_Thickness*2 + Case_Gap*2;
Case_SmCurve_R = BB_SmCurve_R + Case_Thickness + Case_Gap;
Case_LgCurve_R = BB_LgCurve_R + Case_Thickness + Case_Gap;
Case_PCB_Z = BB_USBD_Z + 1.00;      //Height PCB is suspended above case floor
Case_Z = Case_Thickness + Case_PCB_Z + BB_Z + BB_P9_Z;      //Total height of case
Cmp_Gap = 0.25;      //Gap around components
Cmp_Gap2 = Cmp_Gap*2;   //Gap around components times two

//Shell hollow inside dimensions
CutOut_L = BB_L + Case_Gap*2;
CutOut_W = BB_W + Case_Gap*2;
CutOut_SmCurve_R = BB_SmCurve_R + Case_Gap;
CutOut_LgCurve_R = BB_LgCurve_R + Case_Gap;
CutOut_Z = Case_Z - Case_Thickness;

//Lid Dimensions
Lid_Thickness = 2.00;
Lid_Grip_Thickness = 2.00;
Lid_Grip_Z = 3.00;
Lid_Grip_SmR = Case_SmCurve_R - Case_Thickness;
Lid_Grip_LgR = Case_LgCurve_R - Case_Thickness;

//Dev Station Rail Dimensions
DSR_L = Case_L - Case_LgCurve_R - Case_SmCurve_R;
DSR_W = 2.0;
DSR_H = 3.0;
DSRH_W = 4.0;

// ************************************
// cornerRoundedCube Module - See source below
// ************************************

// http://codeviewer.org/view/code:1b36 
// Copyright (C) 2011 Sergio Vilches
// This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
// This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details. You should have received a copy of the GNU General Public License along with this program. If not, see <http://www.gnu.org/licenses/>.
// Contact: s.vilches.e@gmail.com


//     ----------------------------------------------------------- 
//                  Round Corners Cube (Extruded)                
//       roundCornersCube(x,y,z,r) Where:                        
//          - x = Xdir width                                     
//          - y = Ydir width                                     
//          - z = Height of the cube                             
//          - r = Rounding radious                               
                                                              
//       Example: roundCornerCube(10,10,2,1);                    
//      *Some times it's needed to use F6 to see good results!   
//  	 ----------------------------------------------------------- 

// Code was modified to not use centered cubes - Isaac


module createMeniscus(h,radius) // This module creates the shape that needs to be substracted from a cube to make its corners rounded.
difference(){        //This shape is basicly the difference between a quarter of cylinder and a cube
   translate([radius/2+0.1,radius/2+0.1,0]){
      cube([radius+0.2,radius+0.1,h+0.2],center=true);         // All that 0.x numbers are to avoid "ghost boundaries" when substracting
   }

   cylinder(h=h+0.2,r=radius,$fn = 50,center=true);
}


module roundCornersCube(x,y,z,r)  // Now we just substract the shape we have created in the four corners
difference(){
   cube([x,y,z], center=false);

   translate([x-r,y-r,z/2]){  // We move to the first corner (x,y)
      rotate(0){  
         createMeniscus(z,r); // And substract the meniscus
      }
   }
   translate([r,y-r,z/2]){ // To the second corner (-x,y)
      rotate(90){
         createMeniscus(z,r); // But this time we have to rotate the meniscus 90 deg
      }
   }
   translate([r,r,z/2]){ // ... 
      rotate(180){
         createMeniscus(z,r);
      }
   }
   translate([x-r,r,z/2]){
      rotate(270){
         createMeniscus(z,r);
      }
   }
}





