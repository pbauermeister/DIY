/* Enclosure for servo actuating up/down shutter switch
 */

CHAMFER   = 3.5;
ATOM      = 0.01;
TOLERANCE = .5;

SWITCHBOX_SIDE_BACK                    = 73;
SWITCHBOX_SIDE_FRONT                   = 70;
SWITCHBOX_DEPTH                        = 52;
SWITCHBOX_BUTTONS_TRAVEL               =  8;

CABLE_CANAL_WIDTH                      = 35;
CABLE_CANAL_THICKNESS                  = 22;

SERVO_BODY_WIDTH                       = 19.6 + TOLERANCE;
SERVO_BODY_LENGTH                      = 40.4 + TOLERANCE;
SERVO_BODY_HEIGHT                      = 37 + TOLERANCE;
SERVO_AXIS_FROM_EDGE                   = 10.5;
SERVO_TABS_THICKNESS                   =  2.4;
SERVO_TABS_LENGTH                      =  7.6 + TOLERANCE;
SERVO_TABS_ELEVATION                   = 26;
SERVO_SCREWS_XDIST                     = 10;
SERVO_SCREWS_YDIST                     = 48.5;
SERVO_SCREW_DIAMETER                   =  1.8;

SERVO_AXIS_DIAMETER                    =  9;
SERVO_ARM_SPAN                         = 43;
SERVO_ARM_WIDTH                        = 10;
SERVO_ARM_THICKNESS                    =  3;
SERVO_ARM_ELEVATION                    = 42.7;
SERVO_ARM_ROTATION                     = 90;

SERVO_CABLE_CLEARANCE_WIDTH            =  5;

SERVO_POS_SINK                         = 24-ATOM +2;
MARGIN                                 =  5;

SERVO_HEIGHT                           = SERVO_ARM_ELEVATION + SERVO_ARM_THICKNESS;
SERVO_LENGTH                           = SERVO_BODY_LENGTH + 2*SERVO_TABS_LENGTH;

THICKNESS = 15;

ENCLOSURE_EXTRA                        = SERVO_HEIGHT;
ENCLOSURE_WIDTH                        = SWITCHBOX_SIDE_BACK + THICKNESS*2;
ENCLOSURE_LENGTH                       = ENCLOSURE_WIDTH + ENCLOSURE_EXTRA;
ENCLOSURE_HEIGHT                       = SWITCHBOX_DEPTH;

BINDING_DIAMETER                       = 20;
BINDING_HEIGHT                         = 15;
BINDING_SCREW_DIAMETER                 = 5;
BINDING_SCREW_HEAD_DIAMETER            = 9;

BOARD_LENGTH                           = 54;
BOARD_WIDTH                            = 21 +1;
BOARD_THICKNESS                        =  4 + 5;
BOARD_SCREW_FROM_EDGE                  =  2.5 + 1.2;
BOARD_SCREW_DIAMETER                   =  1.5;
BOARD_SCREW_SPACING                    = 12;
BOARD_SCREW_DEPTH                      =  5;

BUTTON_CASE_SIDE                       = 12;
BUTTON_CASE_HEIGHT                     =  4-1;
BUTTON_KNOB_THICKNESS                  =  0.5;
BUTTON_KNOB_DIAMETER                   =  6.5;
BUTTON_CONTACT_EXCESS                  =  1;

BUTTONS_SPACING                        = 3;
BUTTONS_NB                             = 3;

BUTTONS_PROTOBOARD_THICKNESS           = 4;
BUTTONS_PROTOBOARD_THICKNESS_CLEARANCE = 12;
BUTTONS_PROTOBOARD_MARGIN_L            = 5;
BUTTONS_PROTOBOARD_MARGIN_W            = 15;
BUTTONS_PROTOBOARD_LENGTH              = BUTTON_CASE_SIDE*BUTTONS_NB 
                                         + BUTTONS_SPACING*(BUTTONS_NB-1)
                                         + BUTTONS_PROTOBOARD_MARGIN_L*2;
BUTTONS_PROTOBOARD_WIDTH               = BUTTON_CASE_SIDE + BUTTONS_PROTOBOARD_MARGIN_W*2;

PROTOBOARD_BLOCKER_THICKNESS           = 3;
PROTOBOARD_BLOCKER_MARGIN              = 12;
