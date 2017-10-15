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
            gtk_list_store_new/2,
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

gtk_builder_signal_connect_marshaller(_Builder, Object, SignalName, HandlerName, _ConnectObject, Flags, UserData) :-
	(   current_predicate(HandlerName/Arity)
	->  SignalHandler = HandlerName/Arity,
	    g_signal_connect_data(Object, SignalName, SignalHandler, UserData, Flags, _)
	).



/* GtkListStore */
gtk_list_store_new(Types, ListStore) :-
	gtk_list_store_newv(Types, ListStore).



/* GtkTreeStore */
gtk_tree_store_new(Types, ListStore) :-
	gtk_tree_store_newv(Types, ListStore).



:- 'Gtk':gtk_init_check([], _, _).
