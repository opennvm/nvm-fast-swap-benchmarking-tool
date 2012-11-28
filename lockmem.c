/*
 *
 * Copyright (C) 2012 Fusion-io, Inc.
 * 
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the Free
 * Software Foundation; under version 2 of the License.
 * 
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License version
 * 2 for more details.
 *
 * You should have received a copy of the GNU General Public License Version 2
 * along with this program; if not see <http://www.gnu.org/licenses/>
 */

#include <sys/mman.h>

void __attribute__ ((constructor)) init(void)
{
	mlockall(MCL_CURRENT|MCL_FUTURE);
}

void __attribute__ ((destructor)) fini(void)
{
	munlockall();
}
