/*
 * Copyright (c) 2011 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */
package org.swiftsuspenders.support.injectees;

import org.swiftsuspenders.support.types.Clazz;

class ClassInjectee {

	@Inject
	public var property : Clazz;
	public var someProperty : Bool;
	
	public function new() {
		someProperty = false;
	}

	@PostConstruct
	public function doSomeStuff() : Void {
		someProperty = true;
	}

}

