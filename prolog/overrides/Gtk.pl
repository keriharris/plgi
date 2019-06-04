/*  This file is part of PLGI.

    Copyright (C) 2015 Keri Harris <keri@gentoo.org>

    PLGI is free software: you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License as
    published by the Free Software Foundation, either version 2.1
    of the License, or (at your option) any later version.

    PLGI is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with PLGI.  If not, see <http://www.gnu.org/licenses/>.
*/

:- module('Gtk_overrides',
          [
            gtk_builder_add_from_string/3,
            gtk_builder_add_objects_from_string/4,
            gtk_builder_connect_signals/2,
            gtk_dialog_new_with_buttons/5,
            gtk_file_chooser_dialog_new/5,
            gtk_list_store_new/2,
            gtk_message_dialog_format_secondary_markup/2,
            gtk_message_dialog_format_secondary_text/2,
            gtk_message_dialog_new/6,
            gtk_tree_store_new/2
          ]).



/* GtkBuilder */

gtk_builder_add_from_string(Builder, String, Length0) :-
	( Length0 == -1
	->  atom_length(String, Length1)
	;   Length1 = Length0
	),
	'Gtk':gtk_builder_add_from_string(Builder, String, Length1).

gtk_builder_add_objects_from_string(Builder, String, Length0, ObjectIds) :-
	( Length0 == -1
	->  atom_length(String, Length1)
	;   Length1 = Length0
	),
	'Gtk':gtk_builder_add_objects_from_string(Builder, String, Length1, ObjectIds).

gtk_builder_connect_signals(Builder, UserData) :-
	Marshaller = 'Gtk_overrides':gtk_builder_signal_connect_marshaller/7,
	gtk_builder_connect_signals_full(Builder, Marshaller, UserData).

gtk_builder_signal_connect_marshaller(_Builder, Object, SignalName, HandlerName, ConnectObject, Flags, UserData) :-
	term_to_atom(HandlerTerm, HandlerName),
	(   HandlerTerm = _:_/_
	->  SignalHandler = HandlerTerm
	;   HandlerTerm = _/_
	->  SignalHandler = HandlerTerm
	;   SignalHandler = HandlerTerm/_
	),
	(   ConnectObject \== {null}
	->  Data = ConnectObject
	;   Data = UserData
	),
	(   current_predicate(SignalHandler)
	->  g_signal_connect_data(Object, SignalName, SignalHandler, Data, Flags, _)
	).



/* GtkDialog */
gtk_dialog_new_with_buttons(Title, Parent, Flags, Buttons, Dialog) :-
	gtk_dialog_new(Dialog),
	(   Title \== {null}
	->  gtk_window_set_title(Dialog, Title)
	;   true
	),
	(   Parent \== {null}
	->  gtk_window_set_transient_for(Dialog, Parent)
	;   true
	),
	(   memberchk('GTK_DIALOG_USE_HEADER_BAR', Flags)
	->  g_object_set_property(Dialog, 'use-header-bar', 1)
	;   true
	),
	(   memberchk('GTK_DIALOG_MODAL', Flags)
	->  gtk_window_set_modal(Dialog, true)
	;   true
	),
	(   memberchk('GTK_DIALOG_DESTROY_WITH_PARENT', Flags)
	->  gtk_window_set_destroy_with_parent(Dialog, true)
	;   true
	),
	forall(member(Text-ResponseId, Buttons),
	       gtk_dialog_add_button(Dialog, Text, ResponseId, _)).



/* GtkFileChooserDialog */
gtk_file_chooser_dialog_new(Title, Parent, Action, Buttons, Dialog) :-
	g_object_new('GtkFileChooserDialog',
	             ['title'=Title,
	              'action'=Action],
	             Dialog),
	g_object_ref(Dialog, _), % Refbump to offset eventual gtk_widget_destroy/1
	(   Parent \== {null}
	->  gtk_window_set_transient_for(Dialog, Parent)
	;   true
	),
	forall(member(Text-ResponseId, Buttons),
	       gtk_dialog_add_button(Dialog, Text, ResponseId, _)).



/* GtkListStore */
gtk_list_store_new(Types, ListStore) :-
	gtk_list_store_newv(Types, ListStore).



/* GtkMessageDialog */
gtk_message_dialog_new(Parent, Flags, MessageType, Buttons, Message, Dialog) :-
	g_object_new('GtkMessageDialog',
	             ['use-header-bar'=0,
	              'message-type'=MessageType,
	              'buttons'=Buttons],
	             Dialog),
	g_object_ref(Dialog, _), % Refbump to offset eventual gtk_widget_destroy/1
	(   Message \== {null}
	->  g_object_set_property(Dialog, 'text', Message)
	;   true
	),
	(   Parent \== {null}
	->  gtk_window_set_transient_for(Dialog, Parent)
	;   true
	),
	(   memberchk('GTK_DIALOG_MODAL', Flags)
	->  gtk_window_set_modal(Dialog, true)
	;   true
	),
	(   memberchk('GTK_DIALOG_DESTROY_WITH_PARENT', Flags)
	->  gtk_window_set_destroy_with_parent(Dialog, true)
	;   true
	).

gtk_message_dialog_format_secondary_text(Dialog, Text) :-
	g_object_set_property(Dialog, 'secondary-text', Text),
	g_object_set_property(Dialog, 'secondary-use-markup', false).

gtk_message_dialog_format_secondary_markup(Dialog, Markup) :-
	g_object_set_property(Dialog, 'secondary-text', Markup),
	g_object_set_property(Dialog, 'secondary-use-markup', true).



/* GtkTreeStore */
gtk_tree_store_new(Types, ListStore) :-
	gtk_tree_store_newv(Types, ListStore).



:- 'Gtk':gtk_init_check([], _, _).
