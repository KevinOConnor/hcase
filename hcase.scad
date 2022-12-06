// Case for a Haasoscope
//
// Copyright (C) 2022  Kevin O'Connor <kevin@koconnor.net>
//
// This file may be distributed under the terms of the GNU GPLv3 license.

board_length = 98;
board_width = 79;
board_height = 1.6;
board_height_components_bottom = 2;
board_height_components_top = 16.5;
coax_diameter = 9.7;
board_height_offset_coax = 3.4;
board_coax_width_separation = 21;
dupont_length = 20.9;
dupont_width = 9;
dupont_height = 2.5;
board_length_offset_dupont = 30;
double_switch_length = 19;
double_switch_length_left = 20;
double_switch_width = 3.6;
double_switch_height = 3.2;
board_length_offset_double_switch_outer = 16;
board_length_offset_double_switch_inner = 10;
board_width_offset_double_switch_outer = 3;
board_width_offset_double_switch_inner = (board_width-double_switch_width-10)/2;
topdupont_width = 5;
board_width_offset_topdupont_left = 13;
board_width_offset_topdupont_right = 11;
usb_width = 7.8;
usb_height = 2.8;
board_width_offset_usb = 6.7;
usbhi_length = 13.5;
usbhi_height = 7;
board_length_offset_usbhi = 7.5;
board_height_offset_usbhi = 8.25;
jtag_length = 20.25;
jtag_width = 9;
board_width_offset_jtag = 1.5;
board_length_offset_jtag = 4.5;
board_length_offset_hole = 12;

wall_size = 1.5;
post_size = 5;
corner_fillet = 2;

slack = 1;
CUT = 0.02;
$fs = 0.5;

// Full case
board_x = wall_size + slack;
board_y = wall_size + dupont_width;
board_z = wall_size + slack + board_height_components_bottom;
coax_center_z = board_z + board_height + board_height_offset_coax;
case_length = board_x + board_length + wall_size + slack;
case_width = board_y + board_width + dupont_width + wall_size;
case_height = board_z + board_height + board_height_components_top + wall_size;
post_y_offset = 3.5;
post_min_y = [board_y - post_y_offset,
               board_y + board_width + post_y_offset - post_size];
post_center_y = (case_width - post_size) / 2;
post_max_y = [post_center_y - board_coax_width_separation, post_center_y,
              post_center_y + board_coax_width_separation];
bottom_height = coax_center_z - slack/4;
module case() {
    module base_box() {
        module fillet_box(length, width, height) {
            hull() {
                x1 = corner_fillet;
                x2 = length - corner_fillet;
                y1 = corner_fillet;
                y2 = width - corner_fillet;
                for (x=[x1, x2])
                    for (y=[y1, y2])
                        translate([x, y, 0])
                            cylinder(r=corner_fillet, h=height);
            }
        }
        difference() {
            fillet_box(case_length, case_width, case_height);
            translate([wall_size, wall_size, wall_size])
                fillet_box(case_length-2*wall_size, case_width-2*wall_size,
                           case_height-2*wall_size);
        }
    }
    module coax_holes() {
        coax_adj_dia = coax_diameter + 2*slack;
        module coax_hole() {
            rotate([0, 90, 0])
                cylinder(d=coax_adj_dia, h=wall_size+2*CUT);
        }
        center_y = case_width / 2;
        sep = board_coax_width_separation;
        translate([case_length-wall_size-CUT, 0, coax_center_z]) {
            for (m=[-0.5, -1.5, 0.5, 1.5])
                translate([0, center_y - m*sep, 0])
                    coax_hole();
        }
    }
    module dupont_holes() {
        dupont_x = board_x + board_length_offset_dupont - slack;
        dupont_z = board_z + board_height - slack;
        module dupont_hole() {
            translate([dupont_x, -CUT, dupont_z])
                cube(size=[dupont_length+2*slack, wall_size+2*CUT,
                           dupont_height+2*slack]);
        }
        dupont_hole();
        translate([0, case_width - wall_size, 0])
            dupont_hole();
    }
    module usb_hole() {
        usb_adj_width = usb_width + 2*slack;
        usb_y = (board_y + board_width
                 - board_width_offset_usb - usb_adj_width - slack);
        usb_z = board_z + board_height - slack;
        translate([-CUT, usb_y, usb_z]) {
            cube([wall_size+2*CUT, usb_adj_width, usb_height + 2*slack]);
        }
    }
    module usbhi_hole() {
        usbhi_adj_length = usbhi_length + 2*slack;
        usbhi_x = board_x + board_length_offset_usbhi - slack;
        usbhi_z = board_z + board_height + board_height_offset_usbhi - slack;
        translate([usbhi_x, case_width-wall_size-CUT, usbhi_z]) {
            cube([usbhi_adj_length, wall_size+2*CUT, usbhi_height + 2*slack]);
        }
    }
    module top_holes() {
        board_max_x = board_x + board_length;
        board_max_y = board_y + board_width;
        dsor_x = (board_max_x - board_length_offset_double_switch_outer
                  - double_switch_length);
        dsol_x = (board_max_x - board_length_offset_double_switch_outer
                  - double_switch_length_left);
        dsi_x = (board_max_x - board_length_offset_double_switch_inner
                 - double_switch_length_left);
        dsor_y = (board_max_y - board_width_offset_double_switch_outer
                  - double_switch_width);
        dsir_y = (board_max_y - board_width_offset_double_switch_inner
                  - double_switch_width);
        dsol_y = board_y + board_width_offset_double_switch_outer;
        dsil_y = board_y + board_width_offset_double_switch_inner;
        dsw = double_switch_width;
        dsl = double_switch_length;
        td_x = board_x + board_length_offset_dupont;
        tdl_y = board_y + board_width_offset_topdupont_left;
        tdr_y = (board_max_y - board_width_offset_topdupont_right
                 - topdupont_width);
        jtag_x = board_x + board_length_offset_jtag - slack;
        jtag_y = board_y + board_width_offset_jtag - slack;
        tholes = [[dsol_x, dsol_y, dsl, dsw], [dsi_x, dsil_y, dsl, dsw],
                  [dsi_x, dsir_y, dsl, dsw], [dsor_x, dsor_y, dsl, dsw],
                  [td_x, tdl_y, dupont_length, topdupont_width],
                  [td_x, tdr_y, dupont_length, topdupont_width],
                  [jtag_x, jtag_y, jtag_length+2*slack, jtag_width+2*slack],
                 ];
        module top_hole(x, y, length, width) {
            translate([x, y, case_height-wall_size-CUT])
                cube([length, width, wall_size+2*CUT]);
        }
        for (thole=tholes)
            top_hole(thole[0], thole[1], thole[2], thole[3]);
    }
    module box_with_holes() {
        difference() {
            base_box();
            coax_holes();
            dupont_holes();
            usb_hole();
            usbhi_hole();
            top_holes();
        }
    }
    module board_posts() {
        post_height = board_z + board_height - slack/2;
        module post(x, y) {
            translate([x, y, 0])
                cube([post_size, post_size, post_height]);
        }
        module posts() {
            px1 = wall_size-CUT;
            px2 = case_length - wall_size - post_size + CUT;
            for (py=post_min_y)
                post(px1, py);
            for (py=post_max_y)
                post(px2, py);
        }
        module board_cut() {
            translate([board_x - slack/4, board_y - slack/4, board_z])
                cube([board_length + slack/2, board_width + slack/2,
                      board_height + CUT]);
        }
        difference() {
            posts();
            board_cut();
        }
    }
    module notches() {
        module notch(x, y) {
            notch_radius = wall_size;
            translate([x, y, bottom_height - notch_radius])
                rotate([-90, 0, 0])
                    cylinder(h=post_size, r=notch_radius);
        }
        for (py=post_min_y)
            notch(wall_size, py);
        for (py=post_max_y)
            notch(case_length-wall_size, py);
    }
    box_with_holes();
    board_posts();
    notches();
}

// Just the bottom of the case
module case_bottom() {
    intersection() {
        case();
        translate([-CUT, -CUT, -CUT])
            cube([case_length+2*CUT, case_width+2*CUT, bottom_height+CUT]);
    }
}

// The top of the case
module case_top() {
    top_post_width_extra = 1.5;
    top_post_width = post_size + 2*top_post_width_extra;
    top_post_z = board_z + board_height + slack/2;
    module board_posts() {
        top_post_height = case_height - top_post_z;
        module post(x, y) {
            translate([x, y-top_post_width_extra, top_post_z])
                cube([post_size, top_post_width, top_post_height]);
        }
        module posts() {
            px1 = wall_size - CUT;
            px2 = case_length - wall_size - post_size + CUT;
            for (py=post_min_y)
                post(px1, py);
            for (py=post_max_y)
                post(px2, py);
        }
        posts();
    }
    module notches() {
        module notch(x, y) {
            notch_radius = wall_size;
            translate([x, y, bottom_height - notch_radius])
                rotate([-90, 0, 0])
                    cylinder(h=post_size, r=notch_radius);
        }
        for (py=post_min_y)
            notch(wall_size, py);
        for (py=post_max_y)
            notch(case_length-wall_size, py);
    }
    topbot_slack = slack/4;
    top_height = case_height - bottom_height - topbot_slack;
    module only_top() {
        intersection() {
            case();
            translate([-CUT, -CUT, bottom_height + topbot_slack])
                cube([case_length+2*CUT, case_width+2*CUT, top_height+CUT]);
        }
        difference() {
            board_posts();
            notches();
        }
    }
    only_top();
}

// Both top and bottom (view for debugging)
module case_both() {
    case_top();
    case_bottom();
}

// The top of the case rotated for 3d printing
module case_rotated_top() {
    rotate([180, 0, 0])
        case_top();
}

// Object selection
case_bottom();
//case_rotated_top();
