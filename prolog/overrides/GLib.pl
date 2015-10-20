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

:- module('GLib_overrides',
          [
            g_idle_add/2,
            g_timeout_add/4,
            g_timeout_add_seconds/4
          ]).



g_idle_add(Predicate, UserData) :-
	plgi:plgi_g_idle_add(Predicate, UserData).

g_timeout_add(Interval, Predicate, UserData, EventSourceId) :-
	g_timeout_add_full(0, Interval, Predicate, UserData, EventSourceId).

g_timeout_add_seconds(Interval, Predicate, UserData, EventSourceId) :-
	g_timeout_add_seconds_full(0, Interval, Predicate, UserData, EventSourceId).
