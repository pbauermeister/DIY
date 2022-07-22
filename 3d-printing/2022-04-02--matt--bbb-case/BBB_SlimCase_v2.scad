// ******************************************
// Beaglebone Black Slim Case
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
// Render Options
// ************************************

// RENDER OPTIONS
// Set this variable to output the piece you want
// 0 - No Render
// 1 - Visual Only render
// 2 - Base for STL Export
// 3 - Lid for STL Export

   Render_Options = 2;

// LID OPTIONS
// Set this to select various lid Options
// 0 = Solid
// 1 = Pin Header Cut Outs

   Lid_Options = 1;

// DEV STATION OPTIONS
// Set this to add bottom rails for attachment to the BBB Dev Station Sled accessory
// 0 = Case Only
// 1 = Include rails

	DevRails_Options = 0;

// ************************************
// Include External Libraries
// ************************************

// 
include <BBB_SlimCase_v2_Library.scad>

// ************************************
// Dimensions and Locations Math(s)
// ************************************

// -All dimensions in millimeters
// -Origin at bottom left corner of PCB
// -Ethernet and power jack face left closest to origin
// -X and Y refer to position of lower left corner of compoenent from origin
// -Z refers to distance from top of component to the PCB
// -L and W are Lenght(X) and Width(Y) to specify component size


// ************************************
// Components
// ************************************

module Base()
{
	union() {
	difference() {
		//Outer Shell of Case (Join two cubes together with different corner radii to achieve different size corners on each end)
		translate([-Case_Thickness-Case_Gap, -Case_Thickness-Case_Gap, -Case_Thickness]) {
		union() {
			roundCornersCube(Case_L-Case_LgCurve_R, Case_W, Case_Z, Case_SmCurve_R);
			translate ([Case_SmCurve_R,0,0]) roundCornersCube(Case_L-Case_SmCurve_R, Case_W, Case_Z, Case_LgCurve_R);
		}}
		
		//Hollow Out Inside of Case
		translate([-Case_Gap,-Case_Gap,0]) {
		union() {
			roundCornersCube(CutOut_L-CutOut_LgCurve_R, CutOut_W, CutOut_Z, CutOut_SmCurve_R);
			translate ([CutOut_SmCurve_R,0,0]) roundCornersCube(CutOut_L-CutOut_SmCurve_R, CutOut_W, CutOut_Z, CutOut_LgCurve_R);
		}}
		
		//Components Cutouts

		//Ethernet Jack
		translate([BB_Eth_X-Cmp_Gap-Case_Thickness+0.5, BB_Eth_Y-Cmp_Gap, Case_PCB_Z+BB_Z]) cube([BB_Eth_L+Cmp_Gap2+Case_Thickness+0.5, BB_Eth_W+Cmp_Gap2, BB_Eth_Z+Cmp_Gap]);
		//Power Jack
		translate([BB_PJack_X-Cmp_Gap-Case_Thickness+0.5, BB_PJack_Y-Cmp_Gap, Case_PCB_Z+BB_Z]) cube([BB_PJack_L+Cmp_Gap2+Case_Thickness+0.5, BB_PJack_W+Cmp_Gap2, BB_PJack_Z+Cmp_Gap]);
		//USB Device Port
		translate([BB_USBD_X-Cmp_Gap-Case_Thickness+0.5, BB_USBD_Y-Cmp_Gap, 0.75]) cube([BB_USBD_L+Cmp_Gap2+Case_Thickness+0.5, BB_USBD_W+Cmp_Gap2, BB_USBD_Z+Cmp_Gap]);
		//USB Host
		translate([BB_USBH_X-Cmp_Gap, BB_USBH_Y-Cmp_Gap, Case_PCB_Z+BB_Z]) cube([BB_USBH_L+Cmp_Gap2+Case_Thickness+0.5, BB_USBH_W+Cmp_Gap2, CutOut_Z]);//BB_USBH_Z+Cmp_Gap]);
		//SD Card
		translate([BB_SD_X-Cmp_Gap, BB_SD_Y-Cmp_Gap, Case_PCB_Z-BB_SD_Z]) cube([BB_SD_L+Cmp_Gap2+Case_Thickness+0.5, BB_SD_W+Cmp_Gap2, BB_SD_Z+Cmp_Gap2]);
		//HDMI
		translate([BB_HDMI_X-Cmp_Gap, BB_HDMI_Y-Cmp_Gap, Case_PCB_Z-BB_HDMI_Z]) cube([BB_HDMI_L+Cmp_Gap2+Case_Thickness+0.5, BB_HDMI_W+Cmp_Gap2, BB_HDMI_Z+Cmp_Gap2]);
	}
		//Mounting pegs
		translate([BB_Hole1X,BB_Hole1Y,0]) MountingPeg();
		translate([BB_Hole2X,BB_Hole2Y,0]) MountingPeg();
		translate([BB_Hole3X,BB_Hole3Y,0]) MountingPeg();
		translate([BB_Hole4X,BB_Hole4Y,0]) MountingPeg();

		//Dev Station rails
		if (DevRails_Options == 1) {
			translate([Case_SmCurve_R-Case_Thickness-Case_Gap,Case_W-Case_Thickness-Case_Gap,-Case_Thickness]) DevRail(DSR_L, DSR_W, DSR_H);
			translate([DSR_L+Case_SmCurve_R-Case_Thickness-Case_Gap,-Case_Thickness-Case_Gap,-Case_Thickness]) rotate([0,0,180]) {
				DevRail(DSR_L, DSR_W, DSR_H);
			}
		}

	}
}

module Lid()
{
	difference() {	
		translate([-Case_Thickness-Case_Gap, -Case_Thickness-Case_Gap, -Case_Thickness]) {
		union() {
			//
			translate([0,0,Case_Z]) roundCornersCube(Case_L-Case_LgCurve_R, Case_W, Lid_Thickness, Case_SmCurve_R);
			translate ([Case_SmCurve_R,0,Case_Z]) roundCornersCube(Case_L-Case_SmCurve_R, Case_W, Lid_Thickness, Case_LgCurve_R);

			//Lid Grips
			translate([Case_Thickness,Case_Thickness,Case_Z-Lid_Grip_Z]) CornerGrip(Lid_Grip_SmR,Lid_Grip_Thickness,Lid_Grip_Z,0,0);
			translate([Case_L-Case_Thickness,Case_Thickness,Case_Z-Lid_Grip_Z]) CornerGrip(Lid_Grip_LgR,Lid_Grip_Thickness,Lid_Grip_Z,90,4);
			translate([Case_L-Case_Thickness,Case_W-Case_Thickness,Case_Z-Lid_Grip_Z]) CornerGrip(Lid_Grip_LgR,Lid_Grip_Thickness,Lid_Grip_Z,180,4);
			translate([Case_Thickness,Case_W-Case_Thickness,Case_Z-Lid_Grip_Z]) CornerGrip(Lid_Grip_SmR,Lid_Grip_Thickness,Lid_Grip_Z,270,0);
			translate([Case_Thickness,BB_PJack_Y+Case_Thickness+Case_Gap,Case_Z-Lid_Grip_Z]) cube([Lid_Grip_Thickness, BB_Eth_Y-BB_PJack_Y, Lid_Grip_Z]);
		}}

		//Component Cutouts
		
		//Ethernet Jack
		translate([BB_Eth_X-Cmp_Gap-1.25, BB_Eth_Y-Cmp_Gap, Case_PCB_Z+BB_Z]) cube([BB_Eth_L+Cmp_Gap2+1.25, BB_Eth_W+Cmp_Gap2, BB_Eth_Z+Cmp_Gap]);
		//Power Jack
		translate([BB_PJack_X-Cmp_Gap-1.25, BB_PJack_Y-Cmp_Gap, Case_PCB_Z+BB_Z]) cube([BB_PJack_L+Cmp_Gap2+1.25, BB_PJack_W+Cmp_Gap2, BB_PJack_Z+Cmp_Gap]);
		//Pin Headers
		if (Lid_Options == 1) {
			translate([BB_P8_X-Cmp_Gap, BB_P8_Y-Cmp_Gap, 0]) cube([BB_P8_L+Cmp_Gap2, BB_P8_W +Cmp_Gap2, 75]);
			translate([BB_P9_X-Cmp_Gap, BB_P9_Y-Cmp_Gap, 0]) cube([BB_P9_L+Cmp_Gap2, BB_P9_W +Cmp_Gap2, 75]);
		}
		//Capacitor
		translate([BB_Cap_X, BB_Cap_Y, Case_PCB_Z+BB_Z]) cube([BB_Cap_L, BB_Cap_W, BB_Cap_Z]);

		
	}
}

module MountingPeg()
{
	union() {
		cylinder(h=Case_PCB_Z, d=BB_Hole_OD, $fn=25);
		cylinder(h=Case_PCB_Z/2, d1=BB_Hole_OD*1.5, d2=BB_Hole_OD, $fn=25);
		translate([0,0,Case_PCB_Z-0.1]) cylinder(h=BB_Z/2+0.1,d=BB_Hole_ID, $fn=25);
		translate([0,0,Case_PCB_Z+BB_Z/2-0.1]) cylinder(h=BB_Z/2+0.1,d1=BB_Hole_ID, d2=BB_Hole_ID/2, $fn=25);
	}
}

module CornerGrip(R,T,Z,D,CutOff)
{
	rotate([0,0,D]) {
		difference() {
			translate([R,R,0]) cylinder(r=R, h=Z, $fn=50);
			translate([R,R,0]) cylinder(r=R-T, h=Z, $fn=50);
			translate([R-CutOff,0,0]) cube([R*2+CutOff,R*2+CutOff,Z]);
			translate([0,R-CutOff,0]) cube([R*2+CutOff,R*2+CutOff,Z]);
		}
	}
}

module DevRail(X, Y, Z)
{
	SZ = Z * cos(45);
	union() {
		cube([X,Y,Z]);
		translate([0,Y,0]) rotate([45,0,0]) cube([X,SZ,SZ]);
	}
}

// ************************************
// Output Renders
// ************************************

rotate([180, 0, 0])
color("Green"){
	render(convexity=4) {
		if (Render_Options == 1) {
			Base();
			translate([0,0,2]) Lid();
		}
		if (Render_Options == 2) {
			Base();
		}
		if (Render_Options == 3) {
			rotate([180,0,0]) translate([-Case_L/2,-Case_W/2,-Case_Z-Case_Thickness]) Lid();
		}
	}
}