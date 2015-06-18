% PLGI port of iconview_example.py in PyGObject-Tutorial.
% Copyright (C) GNU Free Documentation License 1.3
% This file is distributed under the same license as the Python GTK+ 3 Tutorial package.
% Keri Harris <keri.harris@gentoo.org>, 2015.



:- use_module(library(plgi)).

:- plgi_use_namespace('Gtk').

row_spec('New',  'gtk-new').
row_spec('Open', 'gtk-open').
row_spec('Save', 'gtk-save').

main :-
	gtk_window_new('GTK_WINDOW_TOPLEVEL', Window),
	gtk_window_set_title(Window, 'IconView Example'),
	gtk_window_set_default_size(Window, 200, 200),

	gtk_list_store_new(['GdkPixbuf', 'gchararray'], ListStore),
	gtk_icon_view_new(IconView),
	gtk_icon_view_set_model(IconView, ListStore),
	gtk_icon_view_set_pixbuf_column(IconView, 0),
	gtk_icon_view_set_text_column(IconView, 1),

	Icons = ['gtk-cut', 'gtk-paste', 'gtk-copy'],

	gtk_icon_theme_get_default(IconTheme),
	forall(member(Icon, Icons),
	       ( gtk_icon_theme_load_icon(IconTheme, Icon, 64, [], Pixbuf),
	         gtk_list_store_append(ListStore, Iter),
	         g_value_init('GdkPixbuf', PixbufValue),
	         g_value_set_object(PixbufValue, Pixbuf),
	         gtk_list_store_set_value(ListStore, Iter, 0, PixbufValue),
	         g_value_init('gchararray', LabelValue),
	         g_value_set_string(LabelValue, 'label'),
	         gtk_list_store_set_value(ListStore, Iter, 1, LabelValue)
	       )),

	gtk_container_add(Window, IconView),

	g_signal_connect(Window, 'destroy', gtk_main_quit/0, {null}, _),
	gtk_widget_show_all(Window),
	gtk_main,
	halt.

:- main.
