% PLGI port of extended_example.py in PyGObject-Tutorial.
% Copyright (C) GNU Free Documentation License 1.3
% This file is distributed under the same license as the Python GTK+ 3 Tutorial package.
% Keri Harris <keri.harris@gentoo.org>, 2015.



:- use_module(library(plgi)).

:- plgi_use_namespace('Gtk').

activate(App, _UserData) :-
	gtk_application_window_new(App, Window),
	gtk_window_set_title(Window, 'Window'),
	gtk_window_set_default_size(Window, 200, 200),
	gtk_button_box_new('GTK_ORIENTATION_HORIZONTAL', ButtonBox),
	gtk_container_add(Window, ButtonBox),

	gtk_button_new_with_label('Hello World', Button),
	g_signal_connect(Button, 'clicked', print_hello/2, {null}, _),
	g_signal_connect_swapped(Button,
	                         'clicked',
	                         gtk_widget_destroy/1,
	                         Window,
	                         _),
	gtk_container_add(ButtonBox, Button),

	gtk_widget_show_all(Window).

print_hello(_Button, _UserData) :-
	writeln('Hello World').

main :-
	gtk_application_new('org.swi-prolog.gtk',
	                    ['G_APPLICATION_FLAGS_NONE'],
	                    App),
	g_signal_connect(App, 'activate', activate/2, {null}, _),
	g_application_run(App, [], Result),
	halt(Result).

:- main.
