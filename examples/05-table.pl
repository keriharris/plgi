% PLGI port of layout_table_example.py in PyGObject-Tutorial.
% Copyright (C) GNU Free Documentation License 1.3
% This file is distributed under the same license as the Python GTK+ 3 Tutorial package.
% Keri Harris <keri.harris@gentoo.org>, 2015.



:- use_module(library(plgi)).

:- plgi_use_namespace('Gtk').

main :-
	gtk_window_new('GTK_WINDOW_TOPLEVEL', Window),
	gtk_window_set_title(Window, 'Table Example'),

	gtk_table_new(3, 3, true, Table),
	gtk_container_add(Window, Table),

	gtk_button_new_with_label('Button 1', Button1),
	gtk_button_new_with_label('Button 2', Button2),
	gtk_button_new_with_label('Button 3', Button3),
	gtk_button_new_with_label('Button 4', Button4),
	gtk_button_new_with_label('Button 5', Button5),
	gtk_button_new_with_label('Button 6', Button6),

	gtk_table_attach(Table,
	                 Button1,
	                 0, 1, 0, 1,
	                 ['GTK_EXPAND', 'GTK_FILL'],
	                 ['GTK_EXPAND', 'GTK_FILL'],
                         0, 0),

	gtk_table_attach(Table,
	                 Button2,
	                 1, 3, 0, 1,
	                 ['GTK_EXPAND', 'GTK_FILL'],
	                 ['GTK_EXPAND', 'GTK_FILL'],
	                 0, 0),

	gtk_table_attach(Table,
	                 Button3,
	                 0, 1, 1, 3,
	                 ['GTK_EXPAND', 'GTK_FILL'],
	                 ['GTK_EXPAND', 'GTK_FILL'],
	                 0, 0),

	gtk_table_attach(Table,
	                 Button4,
	                 1, 3, 1, 2,
	                 ['GTK_EXPAND', 'GTK_FILL'],
	                 ['GTK_EXPAND', 'GTK_FILL'],
	                 0, 0),

	gtk_table_attach(Table,
	                 Button5,
	                 1, 2, 2, 3,
	                 ['GTK_EXPAND', 'GTK_FILL'],
	                 ['GTK_EXPAND', 'GTK_FILL'],
	                 0, 0),

	gtk_table_attach(Table,
	                 Button6,
	                 2, 3, 2, 3,
	                 ['GTK_EXPAND', 'GTK_FILL'],
	                 ['GTK_EXPAND', 'GTK_FILL'],
	                 0, 0),

	g_signal_connect(Window, 'destroy', gtk_main_quit/0, {null}, _),
	gtk_widget_show_all(Window),
	gtk_main,
	halt.

:- main.
