% PLGI port of progressbar_example.py in PyGObject-Tutorial.
% Copyright (C) GNU Free Documentation License 1.3
% This file is distributed under the same license as the Python GTK+ 3 Tutorial package.
% Keri Harris <keri.harris@gentoo.org>, 2015.



:- use_module(library(plgi)).

:- plgi_use_namespace('Gtk').

on_show_text_toggled(Button, ProgressBar) :-
	gtk_toggle_button_get_active(Button, IsActive),
	(   IsActive == true
	->  Text = 'some text'
	;   Text = {null}
	),
	gtk_progress_bar_set_text(ProgressBar, Text),
	gtk_progress_bar_set_show_text(ProgressBar, IsActive).

on_activity_mode_toggled(Button, ProgressBar) :-
	(   gtk_toggle_button_get_active(Button, true)
	->  gtk_progress_bar_set_pulse_step(ProgressBar, 0.01)
	;   gtk_progress_bar_set_pulse_step(ProgressBar, 0.0),
	    gtk_progress_bar_set_fraction(ProgressBar, 0.0)
	).

on_right_to_left_toggled(Button, ProgressBar) :-
	gtk_toggle_button_get_active(Button, IsActive),
	gtk_progress_bar_set_inverted(ProgressBar, IsActive).

update_progress_bar(ProgressBar, true) :-
	gtk_progress_bar_get_pulse_step(ProgressBar, PulseStep),
	(   PulseStep > 0.0
	->  gtk_progress_bar_pulse(ProgressBar)
	;   gtk_progress_bar_get_fraction(ProgressBar, Value),
	    NewValue0 is Value + 0.01,
	    (   NewValue0 > 1.0
	    ->  NewValue = 0.0
	    ;   NewValue = NewValue0
	    ),
	    gtk_progress_bar_set_fraction(ProgressBar, NewValue)
	).

main :-
	gtk_window_new('GTK_WINDOW_TOPLEVEL', Window),
	gtk_window_set_title(Window, 'ProgressBar Demo'),
	gtk_container_set_border_width(Window, 10),

	gtk_box_new('GTK_ORIENTATION_VERTICAL', 6, VBox),
	gtk_container_add(Window, VBox),

	gtk_progress_bar_new(ProgressBar),
	gtk_box_pack_start(VBox, ProgressBar, true, true, 0),

	gtk_check_button_new_with_label('Show text', Button1),
	g_signal_connect(Button1,
	                 'toggled',
	                 on_show_text_toggled/2,
	                 ProgressBar,
	                 _),
	gtk_box_pack_start(VBox, Button1, true, true, 0),

	gtk_check_button_new_with_label('Activity mode', Button2),
	g_signal_connect(Button2,
	                 'toggled',
	                 on_activity_mode_toggled/2,
	                 ProgressBar,
	                 _),
	gtk_box_pack_start(VBox, Button2, true, true, 0),

	gtk_check_button_new_with_label('Right to Left', Button3),
	g_signal_connect(Button3,
	                 'toggled',
	                 on_right_to_left_toggled/2,
	                 ProgressBar,
	                 _),
	gtk_box_pack_start(VBox, Button3, true, true, 0),

	g_timeout_add(50, update_progress_bar/2, ProgressBar, _),
	gtk_progress_bar_set_pulse_step(ProgressBar, 0.0),

	g_signal_connect(Window, 'destroy', gtk_main_quit/0, {null}, _),
	gtk_widget_show_all(Window),
	gtk_main,
	halt.

:- main.
