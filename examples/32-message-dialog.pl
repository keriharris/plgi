% PLGI port of messagedialog_example.py in PyGObject-Tutorial.
% Copyright (C) GNU Free Documentation License 1.3
% This file is distributed under the same license as the Python GTK+ 3 Tutorial package.
% Keri Harris <keri.harris@gentoo.org>, 2015.



:- use_module(library(plgi)).

:- plgi_use_namespace('Gtk').

dialog_type('INFO',     'GTK_MESSAGE_INFO',     'GTK_BUTTONS_OK').
dialog_type('ERROR',    'GTK_MESSAGE_ERROR',    'GTK_BUTTONS_CANCEL').
dialog_type('WARNING',  'GTK_MESSAGE_WARNING',  'GTK_BUTTONS_OK_CANCEL').
dialog_type('QUESTION', 'GTK_MESSAGE_QUESTION', 'GTK_BUTTONS_YES_NO').

create_message_dialog(DialogType, Parent, Dialog) :-
	dialog_type(DialogType, MessageType, ButtonsType), !,

	format(atom(Text), 'This is a ~w MessageDialog', [DialogType]),
	SecondaryText = 'And this is the secondary text that explains \c
                         things.', 

	gtk_message_dialog_new(Parent,
	                       ['GTK_DIALOG_DESTROY_WITH_PARENT'],
	                       MessageType,
	                       ButtonsType,
	                       Text,
	                       Dialog),
	gtk_message_dialog_format_secondary_text(Dialog, SecondaryText).

on_info_clicked(_Button, Window) :-
	create_message_dialog('INFO', Window, Dialog),
	gtk_dialog_run(Dialog, _),
	writeln('INFO dialog closed'),

	gtk_widget_destroy(Dialog).

on_error_clicked(_Button, Window) :-
	create_message_dialog('ERROR', Window, Dialog),
	gtk_dialog_run(Dialog, _),
	writeln('ERROR dialog closed'),

	gtk_widget_destroy(Dialog).

on_warning_clicked(_Button, Window) :-
	create_message_dialog('WARNING', Window, Dialog),
	gtk_dialog_run(Dialog, ResponseId),
	plgi_enum_value('GTK_RESPONSE_OK', OkId),
	plgi_enum_value('GTK_RESPONSE_CANCEL', CancelId),

	(   ResponseId == OkId
	->  writeln('WARNING dialog closed by clicking OK button')
	;   ResponseId == CancelId
	->  writeln('WARNING dialog closed by clicking CANCEL button')
	;   true
	),

	gtk_widget_destroy(Dialog).

on_question_clicked(_Button, Window) :-
	create_message_dialog('QUESTION', Window, Dialog),
	gtk_dialog_run(Dialog, ResponseId),
	plgi_enum_value('GTK_RESPONSE_YES', YesId),
	plgi_enum_value('GTK_RESPONSE_NO', NoId),

	(   ResponseId == YesId
	->  writeln('QUESTION dialog closed by clicking YES button')
	;   ResponseId == NoId
	->  writeln('QUESTION dialog closed by clicking NO button')
	;   true
	),

	gtk_widget_destroy(Dialog).

main :-
	gtk_window_new('GTK_WINDOW_TOPLEVEL', Window),
	gtk_window_set_title(Window, 'MessageDialog Example'),
	gtk_container_set_border_width(Window, 10),

	gtk_box_new('GTK_ORIENTATION_HORIZONTAL', 6, HBox),
	gtk_container_add(Window, HBox),

	gtk_button_new_with_label('Information', Button1),
	g_signal_connect(Button1,
	                 'clicked',
	                 on_info_clicked/2,
	                 Window,
	                 _),
	gtk_container_add(HBox, Button1),

	gtk_button_new_with_label('Error', Button2),
	g_signal_connect(Button2,
	                 'clicked',
	                 on_error_clicked/2,
	                 Window,
	                 _),
	gtk_container_add(HBox, Button2),

	gtk_button_new_with_label('Warning', Button3),
	g_signal_connect(Button3,
	                 'clicked',
	                 on_warning_clicked/2,
	                 Window,
	                 _),
	gtk_container_add(HBox, Button3),

	gtk_button_new_with_label('Question', Button4),
	g_signal_connect(Button4,
	                 'clicked',
	                 on_question_clicked/2,
	                 Window,
	                 _),
	gtk_container_add(HBox, Button4),

	g_signal_connect(Window, 'destroy', gtk_main_quit/0, {null}, _),
	gtk_widget_show_all(Window),
	gtk_main,
	halt.

:- main.
