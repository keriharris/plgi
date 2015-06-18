% PLGI port of builder_example.py in PyGObject-Tutorial.
% Copyright (C) GNU Free Documentation License 1.3
% This file is distributed under the same license as the Python GTK+ 3 Tutorial package.
% Keri Harris <keri.harris@gentoo.org>, 2015.



:- use_module(library(plgi)).

:- plgi_use_namespace('Gtk').

on_button_pressed(_Button, _UserData) :-
	writeln('Hello World!').

on_delete_window(_Widget, _Event, _UserData, true) :-
	gtk_main_quit.

main :-
	predicate_property(user:main, file(File)),
	file_directory_name(File, Directory),
	format(atom(GladeFile), '~w/36-builder.glade', [Directory]),

	gtk_builder_new(Builder),
	gtk_builder_add_from_file(Builder, GladeFile, _),
	gtk_builder_connect_signals(Builder, {null}),

	gtk_builder_get_object(Builder, 'window1', Window),
	gtk_widget_show_all(Window),
	gtk_main,
	halt.

:- main.
