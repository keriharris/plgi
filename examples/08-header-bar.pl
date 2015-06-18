% PLGI port of layout_headerbar_example.py in PyGObject-Tutorial.
% Copyright (C) GNU Free Documentation License 1.3
% This file is distributed under the same license as the Python GTK+ 3 Tutorial package.
% Keri Harris <keri.harris@gentoo.org>, 2015.



:- use_module(library(plgi)).

:- plgi_use_namespace('Gtk').

main :-
	gtk_window_new('GTK_WINDOW_TOPLEVEL', Window),
	gtk_container_set_border_width(Window, 10),
	gtk_window_set_default_size(Window, 400, 200),

	gtk_header_bar_new(HeaderBar),
	gtk_header_bar_set_show_close_button(HeaderBar, true),
	gtk_header_bar_set_title(HeaderBar, 'HeaderBar example'),
	gtk_window_set_titlebar(Window, HeaderBar),

	gtk_button_new(Button1),
	g_themed_icon_new('mail-send-receive-symbolic', Icon),
	gtk_image_new_from_gicon(Icon, 'GTK_ICON_SIZE_BUTTON', Image),
	gtk_container_add(Button1, Image),
	gtk_header_bar_pack_end(HeaderBar, Button1),

	gtk_box_new('GTK_ORIENTATION_HORIZONTAL', 0, HBox),
	gtk_widget_get_style_context(HBox, StyleContext),
	gtk_style_context_add_class(StyleContext, 'linked'),

	gtk_button_new(Button2),
	gtk_arrow_new('GTK_ARROW_LEFT', 'GTK_SHADOW_NONE', Arrow1),
	gtk_container_add(Button2, Arrow1),
	gtk_container_add(HBox, Button2),

	gtk_button_new(Button3),
	gtk_arrow_new('GTK_ARROW_RIGHT', 'GTK_SHADOW_NONE', Arrow2),
	gtk_container_add(Button3, Arrow2),
	gtk_container_add(HBox, Button3),

	gtk_header_bar_pack_start(HeaderBar, HBox),

	gtk_text_view_new(TextView),
	gtk_container_add(Window, TextView),

	g_signal_connect(Window, 'destroy', gtk_main_quit/0, {null}, _),
	gtk_widget_show_all(Window),
	gtk_main,
	halt.

:- main.
