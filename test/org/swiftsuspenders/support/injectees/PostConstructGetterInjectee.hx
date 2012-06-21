/*
 * Copyright (c) 2011 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */
package org.swiftsuspenders.support.injectees;

import org.swiftsuspenders.support.types.Clazz;

class PostConstructGetterInjectee {
	public var postConstruct(getPostConstruct, never) : Function;

	public var property : Clazz;
	@:meta(PostConstruct())
	public function getPostConstruct() : Function {
		return function() : Void {
			property = new Clazz();
		}
;
	}


	public function new() {
	}
}

