/*
 * Copyright (c) 2011 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */
package org.swiftsuspenders.typedescriptions;

import org.flexunit.Assert;

class NoParamsConstructorInjectionPointTests {

	@:meta(Test())
	public function noParamsConstructorInjectionPointIsConstructed() : Void {
		var injectionPoint : NoParamsConstructorInjectionPoint = new NoParamsConstructorInjectionPoint();
		Assert.assertTrue("Class doesn't do anything except get constructed", Std.is(injectionPoint, NoParamsConstructorInjectionPoint));
	}


	public function new() {
	}
}

