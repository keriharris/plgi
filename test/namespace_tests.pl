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

:- begin_tests(plgi_namespace).

test(namespace_load) :-
	plgi_use_namespace_from_dir('NamespaceTests', '.').

test(namespace_registered_function) :-
	assertion(current_predicate(namespace_tests_function/0)).

test(namespace_registered_object) :-
	assertion(plgi_registered_object('NamespaceTestsObject')).

test(namespace_registered_struct) :-
	assertion(plgi_registered_struct('NamespaceTestsStruct')).

test(namespace_registered_union) :-
	assertion(plgi_registered_union('NamespaceTestsUnion')).

test(namespace_registered_enum) :-
	assertion(plgi_registered_enum('NamespaceTestsEnum')).

test(namespace_registered_flags) :-
	assertion(plgi_registered_enum('NamespaceTestsFlags')).

test(namespace_registered_callback) :-
	assertion(plgi_registered_callback('NamespaceTestsCallback')).

test(namespace_reload) :-
	plgi_use_namespace_from_dir('NamespaceTests', '.').

/* error conditions */
test(namespace_instantiation_error, [throws(error(instantiation_error, _))]) :-
	plgi_use_namespace(_).

test(namespace_type_error, [throws(error(type_error('atom', _), _))]) :-
	plgi_use_namespace(0).

test(namespace_not_found, [throws(error(plgi_error('Typelib file for namespace \'UnknownNamespace\' (any version) not found'), _))]) :-
	plgi_use_namespace('UnknownNamespace').

test(namespace_dir_instantiation_error, [throws(error(instantiation_error, _))]) :-
	plgi_use_namespace_from_dir('NamespaceTests', _).

test(namespace_dir_type_error, [throws(error(type_error('atom', _), _))]) :-
	plgi_use_namespace_from_dir('NamespaceTests', 0).

test(namespace_from_dir_not_found, [throws(error(plgi_error('Typelib file for namespace \'UnknownNamespace\' (any version) not found'), _))]) :-
	plgi_use_namespace_from_dir('UnknownNamespace', '.').

:- end_tests(plgi_namespace).
