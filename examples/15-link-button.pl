% PLGI port of linkbutton_example.py in PyGObject-Tutorial.
% Copyright (C) GNU Free Documentation License 1.3
% This file is distributed under the same license as the Python GTK+ 3 Tutorial package.
% Keri Harris <keri.harris@gentoo.org>, 2015.



:- use_module(library(plgi)).

:- plgi_use_namespace('Gtk').

main :-
	gtk_window_new('GTK_WINDOW_TOPLEVEL', Window),
	gtk_window_set_title(Window, 'LinkButton Demo'),
	gtk_container_set_border_width(Window, 10),

	gtk_link_button_new_with_label('http://www.swi-prolog.org',
	                               'Visit SWI-Prolog Homepage', Button),
	gtk_container_add(Window, Button),

	g_signal_connect(Window, 'destroy', gtk_main_quit/0, {null}, _),
	gtk_widget_show_all(Window),
	gtk_main,
	halt.

:- main.
