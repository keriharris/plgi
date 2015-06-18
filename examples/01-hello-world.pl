% PLGI port of extended_example.py in PyGObject-Tutorial.
% Copyright (C) GNU Free Documentation License 1.3
% This file is distributed under the same license as the Python GTK+ 3 Tutorial package.
% Keri Harris <keri.harris@gentoo.org>, 2015.



:- use_module(library(plgi)).

:- plgi_use_namespace('Gtk').

on_button_clicked(_Button, _UserData) :-
	writeln('Hello World').

main :-
	gtk_window_new('GTK_WINDOW_TOPLEVEL', Window),
	gtk_window_set_title(Window, 'Hello World'),
	gtk_window_set_default_size(Window, 200, 200),

	gtk_button_box_new('GTK_ORIENTATION_HORIZONTAL', ButtonBox),
	gtk_container_add(Window, ButtonBox),

	gtk_button_new_with_label('Click Here', Button),
	g_signal_connect(Button, 'clicked', on_button_clicked/2, {null}, _),
	gtk_container_add(ButtonBox, Button),

	g_signal_connect(Window, 'destroy', gtk_main_quit/0, {null}, _),
	gtk_widget_show_all(Window),
	gtk_main,
	halt.

:- main.
