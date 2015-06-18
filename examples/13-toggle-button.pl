% PLGI port of togglebutton_example.py in PyGObject-Tutorial.
% Copyright (C) GNU Free Documentation License 1.3
% This file is distributed under the same license as the Python GTK+ 3 Tutorial package.
% Keri Harris <keri.harris@gentoo.org>, 2015.



:- use_module(library(plgi)).

:- plgi_use_namespace('Gtk').

on_button_toggled(Button, Name) :-
	(   gtk_toggle_button_get_active(Button, true)
	->  State = 'on'
	;   State = 'off'
	),
	format('Button ~w was turned ~w~n', [Name, State]).

main :-
	gtk_window_new('GTK_WINDOW_TOPLEVEL', Window),
	gtk_window_set_title(Window, 'ToggleButton Demo'),
	gtk_container_set_border_width(Window, 10),

	gtk_box_new('GTK_ORIENTATION_HORIZONTAL', 6, HBox),
	gtk_container_add(Window, HBox),

	gtk_toggle_button_new_with_label('Button 1', Button1),
	g_signal_connect(Button1, 'toggled', on_button_toggled/2, '1', _),
	gtk_box_pack_start(HBox, Button1, true, true, 0),

	gtk_toggle_button_new_with_label('B_utton 2', Button2),
	gtk_button_set_use_underline(Button2, true),
	gtk_toggle_button_set_active(Button2, true),
	g_signal_connect(Button2, 'toggled', on_button_toggled/2, '2', _),
	gtk_box_pack_start(HBox, Button2, true, true, 0),

	g_signal_connect(Window, 'destroy', gtk_main_quit/0, {null}, _),
	gtk_widget_show_all(Window),
	gtk_main,
	halt.

:- main.
