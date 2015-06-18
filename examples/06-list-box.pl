% PLGI port of layout_listbox_example.py in PyGObject-Tutorial.
% Copyright (C) GNU Free Documentation License 1.3
% This file is distributed under the same license as the Python GTK+ 3 Tutorial package.
% Keri Harris <keri.harris@gentoo.org>, 2015.



:- use_module(library(plgi)).

:- plgi_use_namespace('Gtk').

main :-
	gtk_window_new('GTK_WINDOW_TOPLEVEL', Window),
	gtk_window_set_title(Window, 'ListBox Demo'),
	gtk_container_set_border_width(Window, 10),

	gtk_box_new('GTK_ORIENTATION_HORIZONTAL', 6, HBox1),
	gtk_container_add(Window, HBox1),

	gtk_list_box_new(ListBox),
	gtk_list_box_set_selection_mode(ListBox, 'GTK_SELECTION_NONE'),
	gtk_box_pack_start(HBox1, ListBox, true, true, 0),

	gtk_list_box_row_new(Row1),
	gtk_box_new('GTK_ORIENTATION_HORIZONTAL', 50, HBox2),
	gtk_container_add(Row1, HBox2),
	gtk_box_new('GTK_ORIENTATION_VERTICAL', 0, VBox1),
	gtk_box_pack_start(HBox2, VBox1, true, true, 0),

	gtk_label_new('Automatic Date & Time', Label1),
	g_object_set_property(Label1, 'xalign', 0.0),
	gtk_label_new('Requires internet access', Label2),
	g_object_set_property(Label2, 'xalign', 0.0),
	gtk_box_pack_start(VBox1, Label1, true, true, 0),
	gtk_box_pack_start(VBox1, Label2, true, true, 0),

	gtk_switch_new(Switch),
	gtk_box_pack_start(HBox2, Switch, false, false, 0),

	gtk_container_add(ListBox, Row1),

	gtk_list_box_row_new(Row2),
	gtk_box_new('GTK_ORIENTATION_HORIZONTAL', 50, HBox3),
	gtk_container_add(Row2, HBox3),
	gtk_label_new('Enable Automatic Update', Label3),
	g_object_set_property(Label3, 'xalign', 0.0),
	gtk_check_button_new(CheckButton),
	gtk_box_pack_start(HBox3, Label3, true, true, 0),
	gtk_box_pack_start(HBox3, CheckButton, false, true, 0),

	gtk_container_add(ListBox, Row2),

	gtk_list_box_row_new(Row3),
	gtk_box_new('GTK_ORIENTATION_HORIZONTAL', 50, HBox4),
	gtk_container_add(Row3, HBox4),
	gtk_label_new('Date Format', Label4),
	g_object_set_property(Label4, 'xalign', 0.0),	
	gtk_combo_box_text_new(ComboBox),
	gtk_combo_box_text_insert(ComboBox, 0, '0', '24-hour'),
	gtk_combo_box_text_insert(ComboBox, 1, '1', 'AM/PM'),
	gtk_box_pack_start(HBox4, Label4, true, true, 0),
	gtk_box_pack_start(HBox4, ComboBox, false, true, 0),

	gtk_container_add(ListBox, Row3),

	g_signal_connect(Window, 'destroy', gtk_main_quit/0, {null}, _),
	gtk_widget_show_all(Window),
	gtk_main,
	halt.

:- main.
