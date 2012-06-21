/*
 * Copyright (c) 2009 - 2011 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */
package org.swiftsuspenders;

class DescribeTypeReflectorTests extends ReflectorTests {

	@:meta(Before())
	public function setup() : Void {
		reflector = new DescribeTypeReflector();
		injector = new Injector();
	}


	public function new() {
	}
}

