/*
 * Copyright (c) 2011 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */
package org.swiftsuspenders.support.injectees;

import org.swiftsuspenders.support.types.Clazz;

class NamedClassInjectee {

	static public inline var NAME : String = "Name";
	@:meta(Inject(name="Name"))
	public var property : Clazz;

	public function new() {
	}
}

