% PLGI port of filechooserdialog_example.py in PyGObject-Tutorial.
% Copyright (C) GNU Free Documentation License 1.3
% This file is distributed under the same license as the Python GTK+ 3 Tutorial package.
% Keri Harris <keri.harris@gentoo.org>, 2015.



:- use_module(library(plgi)).

:- plgi_use_namespace('Gtk').

add_filters(Dialog) :-
	gtk_file_filter_new(FilterText),
	gtk_file_filter_set_name(FilterText, 'Text files'),
	gtk_file_filter_add_mime_type(FilterText, 'text/plain'),
	gtk_file_chooser_add_filter(Dialog, FilterText),

	gtk_file_filter_new(FilterC),
	gtk_file_filter_set_name(FilterC, 'Prolog files'),
	gtk_file_filter_add_pattern(FilterC, '*.pl'),
	gtk_file_chooser_add_filter(Dialog, FilterC),

	gtk_file_filter_new(FilterAny),
	gtk_file_filter_set_name(FilterAny, 'Any files'),
	gtk_file_filter_add_pattern(FilterAny, '*'),
	gtk_file_chooser_add_filter(Dialog, FilterAny).

on_file_clicked(_Button, Parent) :-
	g_object_new('GtkFileChooserDialog', [], Dialog),

	gtk_window_set_title(Dialog, 'Please choose a file'),
	gtk_file_chooser_set_action(Dialog, 'GTK_FILE_CHOOSER_ACTION_OPEN'),
	gtk_window_set_transient_for(Dialog, Parent),

	gtk_dialog_add_button(Dialog,
	                      'gtk-cancel',
	                      'GTK_RESPONSE_CANCEL',
	                      _),
	gtk_dialog_add_button(Dialog,
	                      'gtk-open',
	                      'GTK_RESPONSE_OK',
	                      _),

	add_filters(Dialog),

	gtk_dialog_run(Dialog, ResponseId),
	plgi_enum_value('GTK_RESPONSE_OK', OkId),
	plgi_enum_value('GTK_RESPONSE_CANCEL', CancelId),

	(   ResponseId == OkId
	->  writeln('Open clicked'),
	    gtk_file_chooser_get_filename(Dialog, Filename),
	    format('File selected: ~w~n', [Filename])
	;   ResponseId == CancelId
	->  writeln('Cancel clicked')
	;   true
	),

	gtk_widget_destroy(Dialog).

on_folder_clicked(_Button, Parent) :-
	g_object_new('GtkFileChooserDialog', [], Dialog),

	gtk_window_set_title(Dialog, 'Please choose a folder'),
	gtk_file_chooser_set_action(Dialog,
	                            'GTK_FILE_CHOOSER_ACTION_SELECT_FOLDER'),
	gtk_window_set_transient_for(Dialog, Parent),

	gtk_dialog_add_button(Dialog,
	                      'gtk-cancel',
	                      'GTK_RESPONSE_CANCEL',
	                      _),
	gtk_dialog_add_button(Dialog,
	                      'Select',
	                      'GTK_RESPONSE_OK',
	                      _),

	gtk_window_set_default_size(Dialog, 800, 400),

	gtk_dialog_run(Dialog, ResponseId),
	plgi_enum_value('GTK_RESPONSE_OK', OkId),
	plgi_enum_value('GTK_RESPONSE_CANCEL', CancelId),

	(   ResponseId == OkId
	->  writeln('Select clicked'),
	    gtk_file_chooser_get_filename(Dialog, Filename),
	    format('Folder selected: ~w~n', [Filename])
	;   ResponseId == CancelId
	->  writeln('Cancel clicked')
	;   true
	),

	gtk_widget_destroy(Dialog).

main :-
	gtk_window_new('GTK_WINDOW_TOPLEVEL', Window),
	gtk_window_set_title(Window, 'FileChooserDialog Example'),
	gtk_container_set_border_width(Window, 10),

	gtk_box_new('GTK_ORIENTATION_HORIZONTAL', 6, HBox),
	gtk_container_add(Window, HBox),

	gtk_button_new_with_label('Choose File', Button1),
	g_signal_connect(Button1, 'clicked', on_file_clicked/2, Window, _),
	gtk_container_add(HBox, Button1),

	gtk_button_new_with_label('Choose Folder', Button2),
	g_signal_connect(Button2, 'clicked', on_folder_clicked/2, Window, _),
	gtk_container_add(HBox, Button2),

	g_signal_connect(Window, 'destroy', gtk_main_quit/0, {null}, _),
	gtk_widget_show_all(Window),
	gtk_main,
	halt.

:- main.
