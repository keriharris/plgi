% PLGI port of button_example.py in PyGObject-Tutorial.
% Copyright (C) GNU Free Documentation License 1.3
% This file is distributed under the same license as the Python GTK+ 3 Tutorial package.
% Keri Harris <keri.harris@gentoo.org>, 2015.



:- use_module(library(plgi)).

:- plgi_use_namespace('Gtk').

on_click_me_clicked(_Button, _UserData) :-
	writeln('"Click Me" button was clicked').

on_open_clicked(_Button, _UserData) :-
	writeln('"Open" button was clicked').

on_close_clicked(_Button, _UserData) :-
	writeln('Closing application'),
	gtk_main_quit.

main :-
	gtk_window_new('GTK_WINDOW_TOPLEVEL', Window),
	gtk_window_set_title(Window, 'Button Demo'),
	gtk_container_set_border_width(Window, 10),

	gtk_box_new('GTK_ORIENTATION_HORIZONTAL', 6, HBox),
	gtk_container_add(Window, HBox),

	gtk_button_new_with_label('Click Me', ClickMeButton),
	g_signal_connect(ClickMeButton,
	                 'clicked',
	                 on_click_me_clicked/2,
	                 {null},
	                 _),
	gtk_box_pack_start(HBox, ClickMeButton, true, true, 0),

	gtk_button_new_from_stock('gtk-open', OpenButton),
	g_signal_connect(OpenButton,
	                 'clicked',
	                 on_open_clicked/2,
	                 {null},
	                 _),
	gtk_box_pack_start(HBox, OpenButton, true, true, 0),

	gtk_button_new_with_label('_Close', CloseButton),
	gtk_button_set_use_underline(CloseButton, true),
	g_signal_connect(CloseButton,
	                 'clicked',
	                 on_close_clicked/2,
	                 {null},
	                 _),
	gtk_box_pack_start(HBox, CloseButton, true, true, 0),

	g_signal_connect(Window, 'destroy', gtk_main_quit/0, {null}, _),
	gtk_widget_show_all(Window),
	gtk_main,
	halt.

:- main.
