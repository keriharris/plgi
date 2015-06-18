% PLGI port of label_example.py in PyGObject-Tutorial.
% Copyright (C) GNU Free Documentation License 1.3
% This file is distributed under the same license as the Python GTK+ 3 Tutorial package.
% Keri Harris <keri.harris@gentoo.org>, 2015.



:- use_module(library(plgi)).

:- plgi_use_namespace('Gtk').

main :-
	gtk_window_new('GTK_WINDOW_TOPLEVEL', Window),
	gtk_window_set_title(Window, 'Label Example'),
	gtk_container_set_border_width(Window, 10),
	gtk_window_set_default_size(Window, 200, 200),

	gtk_box_new('GTK_ORIENTATION_HORIZONTAL', 10, HBox),
	gtk_box_set_homogeneous(HBox, false),
	gtk_box_new('GTK_ORIENTATION_VERTICAL', 10, VBoxLeft),
	gtk_box_set_homogeneous(VBoxLeft, false),
	gtk_box_new('GTK_ORIENTATION_VERTICAL', 10, VBoxRight),
	gtk_box_set_homogeneous(VBoxRight, false),

	gtk_box_pack_start(HBox, VBoxLeft, true, true, 0),
	gtk_box_pack_start(HBox, VBoxRight, true, true, 0),

	gtk_label_new('This is a normal label', Label1),
	gtk_box_pack_start(VBoxLeft, Label1, true, true, 0),

	Label2Text = 'This is a left-justified label.\nWith multiple lines.',
	gtk_label_new({null}, Label2),
	gtk_label_set_text(Label2, Label2Text),
	gtk_label_set_justify(Label2, 'GTK_JUSTIFY_LEFT'),
	gtk_box_pack_start(VBoxLeft, Label2, true, true, 0),

	Label3Text = 'This is a right-justified label.\n\c
                      With multiple lines.',
	gtk_label_new(Label3Text, Label3),
	gtk_label_set_justify(Label3, 'GTK_JUSTIFY_RIGHT'),
	gtk_box_pack_start(VBoxLeft, Label3, true, true, 0),

	Label4Text = 'This is an example of a line-wrapped label.  It \c
	              should not be taking up the entire             \c
	              width allocated to it, but automatically \c
	              wraps the words to fit.\n    \c
	              It supports multiple paragraphs correctly, \c
	              and  correctly   adds \c
	              many          extra  spaces. ',
	gtk_label_new(Label4Text, Label4),
	gtk_label_set_line_wrap(Label4, true),
	gtk_box_pack_start(VBoxRight, Label4, true, true, 0),

	Label5Text = 'This is an example of a line-wrapped, filled label. \c
	              It should be taking \c
	              up the entire              width allocated to it.  \c
	              Here is a sentence to prove \c
	              my point.  Here is another sentence. \c
	              Here comes the sun, do de do de do.\n    \c
	              This is a new paragraph.\n    \c
	              This is another newer, longer, better \c
	              paragraph.  It is coming to an end, \c
	              unfortunately.',
	gtk_label_new(Label5Text, Label5),
	gtk_label_set_line_wrap(Label5, true),
	gtk_label_set_justify(Label5, 'GTK_JUSTIFY_FILL'),
	gtk_box_pack_start(VBoxRight, Label5, true, true, 0),

	Label6Text = 'Text can be <small>small</small>, <big>big</big>, \c
	              <b>bold</b>, <i>italic</i> and even point to \c
	              somewhere in the <a href=\"http://www.gtk.org\" \c
	              title=\"Click to find out more\">internets</a>.',
	gtk_label_new({null}, Label6),
	gtk_label_set_markup(Label6, Label6Text),
	gtk_label_set_line_wrap(Label6, true),
	gtk_box_pack_start(VBoxLeft, Label6, true, true, 0),

	Label7Text = '_Press Alt + P to select button to the right',
	gtk_label_new_with_mnemonic(Label7Text, Label7),
	gtk_box_pack_start(VBoxLeft, Label7, true, true, 0),
	gtk_label_set_selectable(Label7, true),

	gtk_button_new_with_label('A Button', Button),
	gtk_label_set_mnemonic_widget(Label7, Button),
	gtk_box_pack_start(VBoxRight, Button, true, true, 0),

	gtk_container_add(Window, HBox),

	g_signal_connect(Window, 'destroy', gtk_main_quit/0, {null}, _),
	gtk_widget_show_all(Window),
	gtk_main,
	halt.

:- main.
