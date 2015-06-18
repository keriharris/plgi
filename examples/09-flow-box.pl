% PLGI port of layout_flowbox_example.py in PyGObject-Tutorial.
% Copyright (C) GNU Free Documentation License 1.3
% This file is distributed under the same license as the Python GTK+ 3 Tutorial package.
% Keri Harris <keri.harris@gentoo.org>, 2015.



:- use_module(library(plgi)).

:- plgi_use_namespace('Gtk').

color_swatch_new(Color, Button) :-
	plgi_struct_new('GdkRGBA'( red=0.0 ), RGBA),
	gdk_rgba_parse(RGBA, Color, true),
	gtk_button_new(Button),
	gtk_drawing_area_new(DrawingArea),
	gtk_widget_set_size_request(DrawingArea, 24, 24),
	gtk_widget_override_background_color(DrawingArea,
	                                     ['GTK_STATE_FLAG_NORMAL'],
	                                     RGBA),
	gtk_container_add(Button, DrawingArea).

create_flowbox(FlowBox) :-
	Colors = ['AliceBlue',
	          'AntiqueWhite',
	          'AntiqueWhite1',
	          'AntiqueWhite2',
	          'AntiqueWhite3',
	          'AntiqueWhite4',
	          'aqua',
	          'aquamarine',
	          'aquamarine1',
	          'aquamarine2',
	          'aquamarine3',
	          'aquamarine4',
	          'azure',
	          'azure1',
	          'azure2',
	          'azure3',
	          'azure4',
	          'beige',
	          'bisque',
	          'bisque1',
	          'bisque2',
	          'bisque3',
	          'bisque4',
	          'black',
	          'BlanchedAlmond',
	          'blue',
	          'blue1',
	          'blue2',
	          'blue3',
	          'blue4',
	          'BlueViolet',
	          'brown',
	          'brown1',
	          'brown2',
	          'brown3',
	          'brown4',
	          'burlywood',
	          'burlywood1',
	          'burlywood2',
	          'burlywood3',
	          'burlywood4',
	          'CadetBlue',
	          'CadetBlue1',
	          'CadetBlue2',
	          'CadetBlue3',
	          'CadetBlue4',
	          'chartreuse',
	          'chartreuse1',
	          'chartreuse2',
	          'chartreuse3',
	          'chartreuse4',
	          'chocolate',
	          'chocolate1',
	          'chocolate2',
	          'chocolate3',
	          'chocolate4',
	          'coral',
	          'coral1',
	          'coral2',
	          'coral3',
	          'coral4'],

	forall(member(Color, Colors),
	       ( color_swatch_new(Color, Button),
	         gtk_container_add(FlowBox, Button)
	       )).

main :-
	gtk_window_new('GTK_WINDOW_TOPLEVEL', Window),
	gtk_container_set_border_width(Window, 10),
	gtk_window_set_default_size(Window, 300, 250),

	gtk_header_bar_new(HeaderBar),
	gtk_header_bar_set_title(HeaderBar, 'Flow Box'),
	gtk_header_bar_set_subtitle(HeaderBar, 'Sample FlowBox app'),
	gtk_header_bar_set_show_close_button(HeaderBar, true),

	gtk_window_set_titlebar(Window, HeaderBar),

	gtk_scrolled_window_new({null}, {null}, ScrolledWindow),
	gtk_scrolled_window_set_policy(ScrolledWindow, 'GTK_POLICY_NEVER',
	                               'GTK_POLICY_AUTOMATIC'),

	gtk_flow_box_new(FlowBox),
	gtk_widget_set_valign(FlowBox, 'GTK_ALIGN_START'),
	gtk_flow_box_set_max_children_per_line(FlowBox, 30),
	gtk_flow_box_set_selection_mode(FlowBox, 'GTK_SELECTION_NONE'),

	create_flowbox(FlowBox),

	gtk_container_add(ScrolledWindow, FlowBox),
	gtk_container_add(Window, ScrolledWindow),

	g_signal_connect(Window, 'destroy', gtk_main_quit/0, {null}, _),
	gtk_widget_show_all(Window),
	gtk_main,
	halt.

:- main.
