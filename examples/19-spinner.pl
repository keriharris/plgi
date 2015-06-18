% PLGI port of spinner_example.py in PyGObject-Tutorial.
% Copyright (C) GNU Free Documentation License 1.3
% This file is distributed under the same license as the Python GTK+ 3 Tutorial package.
% Keri Harris <keri.harris@gentoo.org>, 2015.



:- use_module(library(plgi)).

:- plgi_use_namespace('Gtk').

on_button_toggled(Button, Spinner) :-
	(   gtk_toggle_button_get_active(Button, true)
	->  gtk_spinner_start(Spinner),
	    gtk_button_set_label(Button, 'Stop Spinning')
	;   gtk_spinner_stop(Spinner),
	    gtk_button_set_label(Button, 'Start Spinning')
	).

main :-
	gtk_window_new('GTK_WINDOW_TOPLEVEL', Window),
	gtk_window_set_title(Window, 'Spinner Demo'),
	gtk_container_set_border_width(Window, 3),

	gtk_spinner_new(Spinner),

	gtk_toggle_button_new_with_label('Start Spinning', Button),
	g_signal_connect(Button, 'toggled', on_button_toggled/2, Spinner, _),

	gtk_grid_new(Grid),
	gtk_grid_set_row_homogeneous(Grid, true),
	gtk_grid_set_column_homogeneous(Grid, true),
	gtk_label_new('', Spacer),
	gtk_grid_attach(Grid, Button, 0, 0, 2, 1),
	gtk_grid_attach(Grid, Spacer, 0, 1, 2, 1),
	gtk_grid_attach(Grid, Spinner, 0, 2, 2, 1),
	gtk_container_add(Window, Grid),

	g_signal_connect(Window, 'destroy', gtk_main_quit/0, {null}, _),
	gtk_widget_show_all(Window),
	gtk_main,
	halt.

:- main.
