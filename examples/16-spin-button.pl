% PLGI port of spinbutton_example.py in PyGObject-Tutorial.
% Copyright (C) GNU Free Documentation License 1.3
% This file is distributed under the same license as the Python GTK+ 3 Tutorial package.
% Keri Harris <keri.harris@gentoo.org>, 2015.



:- use_module(library(plgi)).

:- plgi_use_namespace('Gtk').

on_numeric_toggled(Button, _UserData) :-
	gtk_toggle_button_get_active(Button, IsActive),
	gtk_spin_button_set_numeric(Button, IsActive).

on_ifvalid_toggled(Button, _UserData) :-
	(   gtk_toggle_button_get_active(Button, true)
	->  Policy = 'GTK_UPDATE_IF_VALID'
	;   Policy = 'GTK_UPDATE_ALWAYS'
	),
	gtk_spin_button_set_update_policy(Button, Policy).

main :-
	gtk_window_new('GTK_WINDOW_TOPLEVEL', Window),
	gtk_window_set_title(Window, 'SpinButton Demo'),
	gtk_container_set_border_width(Window, 10),

	gtk_box_new('GTK_ORIENTATION_HORIZONTAL', 6, HBox),
	gtk_container_add(Window, HBox),

	gtk_adjustment_new(0, 0, 100, 1, 10, 0, Adjustment),
	gtk_spin_button_new(Adjustment, 0, 0, SpinButton),
	gtk_box_pack_start(HBox, SpinButton, false, false, 0),

	gtk_check_button_new_with_label('Numeric', NumericButton),
	g_signal_connect(NumericButton,
	                 'toggled',
	                 on_numeric_toggled/2,
	                 {null},
	                 _),
	gtk_box_pack_start(HBox, NumericButton, false, false, 0),

	gtk_check_button_new_with_label('If Valid', IfValidButton),
	g_signal_connect(IfValidButton,
	                 'toggled',
	                 on_ifvalid_toggled/2,
	                 {null},
	                 _),
	gtk_box_pack_start(HBox, IfValidButton, false, false, 0),

	g_signal_connect(Window, 'destroy', gtk_main_quit/0, {null}, _),
	gtk_widget_show_all(Window),
	gtk_main,
	halt.

:- main.
