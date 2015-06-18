% PLGI port of switch_example.py in PyGObject-Tutorial.
% Copyright (C) GNU Free Documentation License 1.3
% This file is distributed under the same license as the Python GTK+ 3 Tutorial package.
% Keri Harris <keri.harris@gentoo.org>, 2015.



:- use_module(library(plgi)).

:- plgi_use_namespace('Gtk').

on_switch_activated(Button, _GParam, _UserData) :-
	(   gtk_switch_get_active(Button, true)
	->  State = 'on'
	;   State = 'off'
	),
	format('Switch was turned ~w~n', [State]).

main :-
	gtk_window_new('GTK_WINDOW_TOPLEVEL', Window),
	gtk_window_set_title(Window, 'ToggleButton Demo'),
	gtk_container_set_border_width(Window, 10),

	gtk_box_new('GTK_ORIENTATION_HORIZONTAL', 6, HBox),
	gtk_container_add(Window, HBox),

	gtk_switch_new(Switch1),
	g_signal_connect(Switch1,
	                 'notify::active',
	                 on_switch_activated/3,
	                 {null},
	                 _),
	gtk_switch_set_active(Switch1, false),
	gtk_box_pack_start(HBox, Switch1, true, true, 0),

	gtk_switch_new(Switch2),
	g_signal_connect(Switch2,
	                 'notify::active',
	                 on_switch_activated/3,
	                 {null},
	                 _),
	gtk_switch_set_active(Switch2, true),
	gtk_box_pack_start(HBox, Switch2, true, true, 0),

	g_signal_connect(Window, 'destroy', gtk_main_quit/0, {null}, _),
	gtk_widget_show_all(Window),
	gtk_main,
	halt.

:- main.
