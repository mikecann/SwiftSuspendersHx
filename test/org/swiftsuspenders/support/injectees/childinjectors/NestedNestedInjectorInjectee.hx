/*
 * Copyright (c) 2010 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */
package org.swiftsuspenders.support.injectees.childinjectors;

import org.swiftsuspenders.Injector;

class NestedNestedInjectorInjectee {

	@:meta(Inject())
	public var injector : Injector;

	public function new() {
	}
}

