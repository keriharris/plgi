% PLGI port of entry_example.py in PyGObject-Tutorial.
% Copyright (C) GNU Free Documentation License 1.3
% This file is distributed under the same license as the Python GTK+ 3 Tutorial package.
% Keri Harris <keri.harris@gentoo.org>, 2015.



:- use_module(library(plgi)).

:- plgi_use_namespace('Gtk').

on_editable_toggled(Button, Entry) :-
	gtk_toggle_button_get_active(Button, IsActive),
	gtk_editable_set_editable(Entry, IsActive).

on_visible_toggled(Button, Entry) :-
	gtk_toggle_button_get_active(Button, IsActive),
	gtk_entry_set_visibility(Entry, IsActive).

on_pulse_toggled(Button, Entry) :-
	(   gtk_toggle_button_get_active(Button, true)
	->  gtk_entry_set_progress_pulse_step(Entry, 0.2),
	    g_timeout_add(100, do_pulse/2, Entry, _)
	;   gtk_entry_set_progress_pulse_step(Entry, 0.0)
	).

on_icon_toggled(Button, Entry) :-
	(   gtk_toggle_button_get_active(Button, true)
	->  StockId = 'gtk-find'
	;   StockId = {null}
	),
	gtk_entry_set_icon_from_stock(Entry,
	                              'GTK_ENTRY_ICON_PRIMARY',
	                              StockId).

do_pulse(Entry, ContinuePulse) :-
	gtk_entry_get_progress_pulse_step(Entry, PulseStep),
	(   PulseStep > 0.0
	->  gtk_entry_progress_pulse(Entry),
	    ContinuePulse = true
	;   ContinuePulse = false
	).

main :-
	gtk_window_new('GTK_WINDOW_TOPLEVEL', Window),
	gtk_window_set_title(Window, 'Entry Demo'),
	gtk_window_set_default_size(Window, 200, 100),

	gtk_box_new('GTK_ORIENTATION_VERTICAL', 6, VBox),
	gtk_container_add(Window, VBox),

	gtk_entry_new(Entry),
	gtk_entry_set_text(Entry, 'Hello World'),
	gtk_box_pack_start(VBox, Entry, true, true, 0),

	gtk_box_new('GTK_ORIENTATION_HORIZONTAL', 6, HBox),
	gtk_box_pack_start(VBox, HBox, true, true, 0),

	gtk_check_button_new_with_label('Editable', CheckEditable),
	g_signal_connect(CheckEditable,
	                 'toggled',
	                 on_editable_toggled/2,
	                 Entry,
	                 _),
	gtk_toggle_button_set_active(CheckEditable, true),
	gtk_box_pack_start(HBox, CheckEditable, true, true, 0),

	gtk_check_button_new_with_label('Visible', CheckVisible),
	g_signal_connect(CheckVisible,
	                 'toggled',
	                 on_visible_toggled/2,
	                 Entry,
	                 _),
	gtk_toggle_button_set_active(CheckVisible, true),
	gtk_box_pack_start(HBox, CheckVisible, true, true, 0),

	gtk_check_button_new_with_label('Pulse', CheckPulse),
	g_signal_connect(CheckPulse,
	                 'toggled',
	                 on_pulse_toggled/2,
	                 Entry,
	                 _),
	gtk_toggle_button_set_active(CheckPulse, false),
	gtk_box_pack_start(HBox, CheckPulse, true, true, 0),

	gtk_check_button_new_with_label('Icon', CheckIcon),
	g_signal_connect(CheckIcon,
	                 'toggled',
	                 on_icon_toggled/2,
	                 Entry,
	                 _),
	gtk_toggle_button_set_active(CheckIcon, false),
	gtk_box_pack_start(HBox, CheckIcon, true, true, 0),

	g_signal_connect(Window, 'destroy', gtk_main_quit/0, {null}, _),
	gtk_widget_show_all(Window),
	gtk_main,
	halt.

:- main.
