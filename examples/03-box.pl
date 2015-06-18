% PLGI port of layout_box_example.py in PyGObject-Tutorial.
% Copyright (C) GNU Free Documentation License 1.3
% This file is distributed under the same license as the Python GTK+ 3 Tutorial package.
% Keri Harris <keri.harris@gentoo.org>, 2015.



:- use_module(library(plgi)).

:- plgi_use_namespace('Gtk').

on_button1_clicked(_Button, _UserData) :-
	writeln('Hello').

on_button2_clicked(_Button, _UserData) :-
	writeln('Goodbye').

main :-
	gtk_window_new('GTK_WINDOW_TOPLEVEL', Window),
	gtk_window_set_title(Window, 'Hello World'),
	gtk_container_set_border_width(Window, 10),

	gtk_box_new('GTK_ORIENTATION_HORIZONTAL', 6, HBox),
	gtk_container_add(Window, HBox),

	gtk_button_new_with_label('Hello', Button1),
	g_signal_connect(Button1,
	                 'clicked',
	                 on_button1_clicked/2,
	                 {null},
	                 _),
	gtk_box_pack_start(HBox, Button1, true, true, 0),

	gtk_button_new_with_label('Goodbye', Button2),
	g_signal_connect(Button2,
	                 'clicked',
	                 on_button2_clicked/2,
	                 {null},
	                 _),
	gtk_box_pack_start(HBox, Button2, true, true, 0),

	g_signal_connect(Window, 'destroy', gtk_main_quit/0, {null}, _),
	gtk_widget_show_all(Window),
	gtk_main,
	halt.

:- main.
