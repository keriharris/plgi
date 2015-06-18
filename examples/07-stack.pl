% PLGI port of layout_stack_example.py in PyGObject-Tutorial.
% Copyright (C) GNU Free Documentation License 1.3
% This file is distributed under the same license as the Python GTK+ 3 Tutorial package.
% Keri Harris <keri.harris@gentoo.org>, 2015.



:- use_module(library(plgi)).

:- plgi_use_namespace('Gtk').

main :-
	gtk_window_new('GTK_WINDOW_TOPLEVEL', Window),
	gtk_window_set_title(Window, 'Stack Demo'),
	gtk_container_set_border_width(Window, 10),

	gtk_box_new('GTK_ORIENTATION_VERTICAL', 6, VBox),
	gtk_container_add(Window, VBox),

	gtk_stack_new(Stack),
	gtk_stack_set_transition_type(Stack,
	                              'GTK_STACK_TRANSITION_TYPE_SLIDE_LEFT_RIGHT'),
	gtk_stack_set_transition_duration(Stack, 1000),

	gtk_check_button_new_with_label('Click me!', CheckButton),
	gtk_stack_add_titled(Stack, CheckButton, 'check', 'Check Button'),

	gtk_label_new({null}, Label),
	gtk_label_set_markup(Label, '<big>A fancy label</big>'),
	gtk_stack_add_titled(Stack, Label, 'label', 'A label'),

	gtk_stack_switcher_new(StackSwitcher),
	gtk_stack_switcher_set_stack(StackSwitcher, Stack),
	gtk_box_pack_start(VBox, StackSwitcher, true, true, 0),
	gtk_box_pack_start(VBox, Stack, true, true, 0),

	g_signal_connect(Window, 'destroy', gtk_main_quit/0, {null}, _),
	gtk_widget_show_all(Window),
	gtk_main,
	halt.

:- main.
