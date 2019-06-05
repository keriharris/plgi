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

:- asserta(file_search_path(library, '.')).
:- asserta(file_search_path(foreign, '.')).
:- asserta(file_search_path(foreign, '../src')).
:- asserta(file_search_path(library, '../prolog')).
:- asserta(file_search_path(plgi, '../prolog/overrides')).

:- multifile prolog:message/3.
prolog:message(plgi_warning(_Message)) --> [].

:- use_module(library(plgi)).
:- use_module(library(plunit)).

:- load_files([
               namespace_tests,
               parameter_tests,
               marshaller_tests,
               callback_tests,
               signal_tests,
               regress_tests
              ], [encoding(utf8)]).
