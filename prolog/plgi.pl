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

:- module(plgi, [
                 plgi_use_namespace/1,
                 plgi_use_namespace_from_dir/2,
                 plgi_current_namespace/1,

                 plgi_registered_namespace/1,
                 plgi_registered_callback/1,
                 plgi_registered_enum/1,
                 plgi_registered_object/1,
                 plgi_registered_struct/1,
                 plgi_registered_union/1,

                 plgi_struct_new/2,
                 plgi_struct_get_field/3,
                 plgi_struct_set_field/3,
                 plgi_struct_term/2,

                 plgi_union_new/2,
                 plgi_union_get_field/3,
                 plgi_union_set_field/3,

                 plgi_enum_value/2,

                 plgi_version/1,

                 plgi_debug/1
                ]).

:- use_foreign_library(foreign(plgi), install_plgi).

:- dynamic   user:file_search_path/2.
:- multifile user:file_search_path/2.

user:file_search_path(plgi, library(plgi)).



plgi_use_namespace(Namespace) :-
	plgi_load_namespace(Namespace),
	plgi_import_namespace(Namespace),
	plgi_namespace_deps(Namespace, Dependencies),
	forall(member(Dependency, Dependencies),
	       plgi_use_namespace(Dependency)
	      ).

plgi_use_namespace_from_dir(Namespace, Directory) :-
	plgi_load_namespace_from_dir(Namespace, Directory),
	plgi_import_namespace(Namespace).

plgi_import_namespace(Namespace) :-
	(   plgi_overrides_module(Namespace, OverridesModule)
	->  use_module(plgi(Namespace)),
	    forall(( current_predicate(OverridesModule:Name/Arity),
	             functor(Head, Name, Arity),
	             predicate_property(OverridesModule:Head, exported)
	           ),
	           ( user:import(OverridesModule:Name/Arity)
	           )
	          )
	;   true
	),
	forall(( current_predicate(Namespace:Predicate),
                 \+ current_predicate(user:Predicate)
               ),
	       ( Namespace:export(Predicate),
	         user:import(Namespace:Predicate)
	       )
	      ).


:- multifile
	prolog:message/3.

prolog:error_message(plgi_error(Message)) -->
	[ 'PLGI Error: ~w'-[Message] ].

prolog:error_message(glib_error(Domain, Code, Message)) -->
	[ 'GLib Error: [~w:~w] ~w'-[Domain, Code, Message] ].

prolog:message(plgi_warning(Message)) -->
	[ 'PLGI Warning: ~w'-[Message] ].


plgi_overrides_module('GLib',    'GLib_overrides').
plgi_overrides_module('GObject', 'GObject_overrides').
plgi_overrides_module('Gtk',     'Gtk_overrides').
