% PLGI port of dialog_example.py in PyGObject-Tutorial.
% Copyright (C) GNU Free Documentation License 1.3
% This file is distributed under the same license as the Python GTK+ 3 Tutorial package.
% Keri Harris <keri.harris@gentoo.org>, 2015.



:- use_module(library(plgi)).

:- plgi_use_namespace('Gtk').

on_button_clicked(_Button, Window) :-
	gtk_dialog_new(Dialog),
	gtk_window_set_title(Dialog, 'My Dialog'),
	gtk_window_set_transient_for(Dialog, Window),
	gtk_dialog_add_button(Dialog,
	                      'gtk-cancel',
	                      'GTK_RESPONSE_CANCEL',
	                      _),
	gtk_dialog_add_button(Dialog,
	                      'gtk-ok',
	                      'GTK_RESPONSE_OK',
	                      _),

	gtk_window_set_default_size(Dialog, 150, 100),

	gtk_label_new('This is a dialog to display additional information',
	              Label),

	gtk_dialog_get_content_area(Dialog, Box),
	gtk_container_add(Box, Label),
	gtk_widget_show_all(Dialog),

	gtk_dialog_run(Dialog, ResponseId),
	plgi_enum_value('GTK_RESPONSE_OK', OkId),
	plgi_enum_value('GTK_RESPONSE_CANCEL', CancelId),
	(   ResponseId == OkId
	->  writeln('The OK button was clicked')
	;   ResponseId == CancelId
	->  writeln('The Cancel button was clicked')
	;   true
	),

	gtk_widget_destroy(Dialog).

main :-
	gtk_window_new('GTK_WINDOW_TOPLEVEL', Window),
	gtk_window_set_title(Window, 'Dialog Example'),
	gtk_container_set_border_width(Window, 6),

	gtk_button_new_with_label('Open dialog', Button),
	g_signal_connect(Button, 'clicked', on_button_clicked/2, Window, _),

	gtk_container_add(Window, Button),

	g_signal_connect(Window, 'destroy', gtk_main_quit/0, {null}, _),
	gtk_widget_show_all(Window),
	gtk_main,
	halt.

:- main.
