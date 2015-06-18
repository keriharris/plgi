% PLGI port of layout_grid_example.py in PyGObject-Tutorial.
% Copyright (C) GNU Free Documentation License 1.3
% This file is distributed under the same license as the Python GTK+ 3 Tutorial package.
% Keri Harris <keri.harris@gentoo.org>, 2015.



:- use_module(library(plgi)).

:- plgi_use_namespace('Gtk').

main :-
	gtk_window_new('GTK_WINDOW_TOPLEVEL', Window),
	gtk_window_set_title(Window, 'Grid Example'),

	gtk_grid_new(Grid),
	gtk_container_add(Window, Grid),

	gtk_button_new_with_label('Button 1', Button1),
	gtk_button_new_with_label('Button 2', Button2),
	gtk_button_new_with_label('Button 3', Button3),
	gtk_button_new_with_label('Button 4', Button4),
	gtk_button_new_with_label('Button 5', Button5),
	gtk_button_new_with_label('Button 6', Button6),

	gtk_container_add(Grid, Button1),
	gtk_grid_attach(Grid, Button2, 1, 0, 2, 1),
	gtk_grid_attach_next_to(Grid,
	                        Button3,
	                        Button1,
	                        'GTK_POS_BOTTOM',
	                        1,
	                        2),
	gtk_grid_attach_next_to(Grid,
	                        Button4,
	                        Button3,
	                        'GTK_POS_RIGHT',
	                        2,
	                        1),
	gtk_grid_attach(Grid, Button5, 1, 2, 1, 1),
	gtk_grid_attach_next_to(Grid,
	                        Button6,
	                        Button5,
	                        'GTK_POS_RIGHT',
	                        1,
	                        1),

	g_signal_connect(Window, 'destroy', gtk_main_quit/0, {null}, _),
	gtk_widget_show_all(Window),
	gtk_main,
	halt.

:- main.
