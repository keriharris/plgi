% PLGI port of clipboard_example.py in PyGObject-Tutorial.
% Copyright (C) GNU Free Documentation License 1.3
% This file is distributed under the same license as the Python GTK+ 3 Tutorial package.
% Keri Harris <keri.harris@gentoo.org>, 2015.



:- use_module(library(plgi)).

:- plgi_use_namespace('Gtk').

copy_text(_Button, Entry) :-
	gtk_entry_get_text(Entry, Text),
	gdk_atom_intern('CLIPBOARD', true, ClipboardAtom),
	gtk_clipboard_get(ClipboardAtom, Clipboard),
	gtk_clipboard_set_text(Clipboard, Text, -1).

paste_text(_Button, Entry) :-
	gdk_atom_intern('CLIPBOARD', true, ClipboardAtom),
	gtk_clipboard_get(ClipboardAtom, Clipboard),
	gtk_clipboard_wait_for_text(Clipboard, Text),
	(   Text \== {null}
	->  gtk_entry_set_text(Entry, Text)
	;   writeln('No text on the clipboard')
	).

copy_image(_Button, Image) :-
	gdk_atom_intern('CLIPBOARD', true, ClipboardAtom),
	gtk_clipboard_get(ClipboardAtom, Clipboard),
	(   gtk_image_get_storage_type(Image, 'GTK_IMAGE_PIXBUF')
	->  gtk_image_get_pixbuf(Image, Pixbuf),
	    gtk_clipboard_set_image(Clipboard, Pixbuf)
	;   writeln('No image has been pasted yet')
	).

paste_image(_Button, Image) :-
	gdk_atom_intern('CLIPBOARD', true, ClipboardAtom),
	gtk_clipboard_get(ClipboardAtom, Clipboard),
	gtk_clipboard_wait_for_image(Clipboard, Pixbuf),
	(   Pixbuf \== {null}
	->  gtk_image_set_from_pixbuf(Image, Pixbuf)
	;   writeln('No image on the clipboard')
	).

main :-
	gtk_window_new('GTK_WINDOW_TOPLEVEL', Window),
	gtk_window_set_title(Window, 'Clipboard Example'),
	gtk_container_set_border_width(Window, 3),

	gtk_grid_new(Grid),
	gtk_grid_set_row_homogeneous(Grid, true),
	gtk_grid_set_column_homogeneous(Grid, true),

	gtk_entry_new(Entry),
	gtk_image_new_from_stock('gtk-stop', 'GTK_ICON_SIZE_MENU', Image),

	gtk_button_new_with_label('Copy Text', ButtonCopyText),
	gtk_button_new_with_label('Paste Text', ButtonPasteText),
	gtk_button_new_with_label('Copy Image', ButtonCopyImage),
	gtk_button_new_with_label('Paste Image', ButtonPasteImage),

	gtk_grid_attach(Grid, Entry, 0, 0, 1, 1),
	gtk_grid_attach(Grid, Image, 0, 1, 1, 1),
	gtk_grid_attach(Grid, ButtonCopyText, 1, 0, 1, 1),
	gtk_grid_attach(Grid, ButtonPasteText, 2, 0, 1, 1),
	gtk_grid_attach(Grid, ButtonCopyImage, 1, 1, 1, 1),
	gtk_grid_attach(Grid, ButtonPasteImage, 2, 1, 1, 1),

	g_signal_connect(ButtonCopyText,
	                 'clicked',
	                 copy_text/2,
	                 Entry,
	                 _),
	g_signal_connect(ButtonPasteText,
	                 'clicked',
	                 paste_text/2,
	                 Entry,
	                 _),
	g_signal_connect(ButtonCopyImage,
	                 'clicked',
	                 copy_image/2,
	                 Image,
	                 _),
	g_signal_connect(ButtonPasteImage,
	                 'clicked',
	                 paste_image/2,
	                 Image,
	                 _),

	gtk_container_add(Window, Grid),

	g_signal_connect(Window, 'destroy', gtk_main_quit/0, {null}, _),
	gtk_widget_show_all(Window),
	gtk_main,
	halt.

:- main.
