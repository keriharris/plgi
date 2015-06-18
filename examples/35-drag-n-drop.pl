% PLGI port of drag_and_drop_example.py in PyGObject-Tutorial.
% Copyright (C) GNU Free Documentation License 1.3
% This file is distributed under the same license as the Python GTK+ 3 Tutorial package.
% Keri Harris <keri.harris@gentoo.org>, 2015.



:- use_module(library(plgi)).

:- plgi_use_namespace('Gtk').

target_entry_id('TEXT',   0).
target_entry_id('PIXBUF', 1).

add_image_targets(Button, UserData) :-
	gtk_toggle_button_get_active(Button, true),
	UserData = dnd(IconView, Label),

	target_entry_id('PIXBUF', ID),
	gtk_target_list_new([], Targets),
	gtk_target_list_add_image_targets(Targets, ID, true),

	gtk_drag_dest_set_target_list(Label, Targets),
	gtk_drag_source_set_target_list(IconView, Targets).

add_text_targets(Button, UserData) :-
	gtk_toggle_button_get_active(Button, true),
	UserData = dnd(IconView, Label),

	gtk_drag_dest_set_target_list(Label, {null}),
	gtk_drag_source_set_target_list(IconView, {null}),

	gtk_drag_dest_add_text_targets(Label),
	gtk_drag_source_add_text_targets(IconView).

on_drag_data_get(IconView, _DragContext, Data, Info, _Time, _UserData) :-
	gtk_icon_view_get_selected_items(IconView, Items),
	Items = [SelectedPath|_],
	gtk_icon_view_get_model(IconView, Model),
	gtk_tree_model_get_iter(Model, Iter, SelectedPath, _),
	gtk_tree_model_get_value(Model, Iter, Info, Value),

	(   target_entry_id('TEXT', Info)
	->  g_value_get_string(Value, Text),
	    gtk_selection_data_set_text(Data, Text, -1, true)
	;   target_entry_id('PIXBUF', Info)
	->  g_value_get_object(Value, Pixbuf),
	    gtk_selection_data_set_pixbuf(Data, Pixbuf, true)
	;   true
	).

on_drag_data_received(_Widget,
                      _DragContext,
                      _X,
                      _Y,
                      Data,
                      Info,
                      _Time,
                      _UserData) :-
	(   target_entry_id('TEXT', Info)
	->  gtk_selection_data_get_text(Data, Text),
	    format('Received text: ~w~n', [Text])
	;   target_entry_id('PIXBUF', Info)
	->  gtk_selection_data_get_pixbuf(Data, Pixbuf),
	    gdk_pixbuf_get_width(Pixbuf, Width),
	    gdk_pixbuf_get_height(Pixbuf, Height),
	    format('Received pixbuf with width ~wpx and height ~wpx~n',
	           [Width, Height])
	;   true
	).

drag_and_drop_item('Item 1', 'image').
drag_and_drop_item('Item 2', 'gtk-about').
drag_and_drop_item('Item 3', 'edit-copy').

main :-
	gtk_window_new('GTK_WINDOW_TOPLEVEL', Window),
	gtk_window_set_title(Window, 'Drag and Drop Demo'),
	gtk_window_set_default_size(Window, 200, 200),

	gtk_box_new('GTK_ORIENTATION_VERTICAL', 6, VBox),
	gtk_container_add(Window, VBox),

	gtk_box_new('GTK_ORIENTATION_HORIZONTAL', 12, HBox),
	gtk_box_pack_start(VBox, HBox, true, true, 0),

	gtk_icon_view_new(IconView),
	gtk_icon_view_set_text_column(IconView, 0),
	gtk_icon_view_set_pixbuf_column(IconView, 1),

	gtk_list_store_new(['gchararray', 'GdkPixbuf'], Model),
	gtk_icon_view_set_model(IconView, Model),
	gtk_icon_theme_get_default(IconTheme),

	forall(drag_and_drop_item(Text, StockId),
	       ( gtk_icon_theme_load_icon(IconTheme,
	                                  StockId,
	                                  16,
	                                  [],
	                                  Pixbuf),
	         gtk_list_store_append(Model, Iter),
	         g_value_init('gchararray', TextValue),
	         g_value_set_string(TextValue, Text),
	         gtk_list_store_set_value(Model, Iter, 0, TextValue),
	         g_value_init('GdkPixbuf', PixbufValue),
	         g_value_set_object(PixbufValue, Pixbuf),
	         gtk_list_store_set_value(Model, Iter, 1, PixbufValue)
	       )),

	gtk_icon_view_enable_model_drag_source(IconView,
	                                       ['GDK_BUTTON1_MASK'],
	                                       [],
	                                       ['GDK_ACTION_COPY']),
	g_signal_connect(IconView,
	                 'drag-data-get',
	                 on_drag_data_get/6,
	                 {null},
	                 _),

	gtk_label_new('Drop something on me!', Label),
	gtk_drag_dest_set(Label,
	                  ['GTK_DEST_DEFAULT_ALL'],
	                  [],
	                  ['GDK_ACTION_COPY']),
	g_signal_connect(Label,
	                 'drag-data-received',
	                 on_drag_data_received/8,
	                 {null},
	                 _),

	gtk_box_pack_start(HBox, IconView, true, true, 0),
	gtk_box_pack_start(HBox, Label, true, true, 0),

	gtk_box_new('GTK_ORIENTATION_HORIZONTAL', 6, ButtonBox),
	gtk_box_pack_start(VBox, ButtonBox, true, false, 0),

	gtk_radio_button_new_with_label_from_widget({null},
	                                            'Images',
	                                            ImageButton),
	g_signal_connect(ImageButton,
	                 'toggled',
	                 add_image_targets/2,
	                 dnd(IconView, Label),
	                 _),
	gtk_box_pack_start(ButtonBox, ImageButton, true, false, 0),

	gtk_radio_button_new_with_label_from_widget(ImageButton,
	                                            'Text',
	                                            TextButton),
	g_signal_connect(TextButton,
	                 'toggled',
	                 add_text_targets/2,
	                 dnd(IconView, Label),
	                 _),
	gtk_box_pack_start(ButtonBox, TextButton, true, false, 0),

	add_image_targets(ImageButton, dnd(IconView, Label)),

	g_signal_connect(Window, 'destroy', gtk_main_quit/0, {null}, _),
	gtk_widget_show_all(Window),
	gtk_main,
	halt.

:- main.
