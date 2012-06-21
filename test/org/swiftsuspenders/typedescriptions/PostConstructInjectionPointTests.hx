/*
 * Copyright (c) 2011 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */
package org.swiftsuspenders.typedescriptions;

import org.flexunit.Assert;
import org.swiftsuspenders.Injector;
import org.swiftsuspenders.support.injectees.ClassInjectee;
import org.swiftsuspenders.support.types.Clazz;
import org.swiftsuspenders.utils.SsInternal;

class PostConstructInjectionPointTests {

	@:meta(After())
	public function teardown() : Void {
		Injector.SsInternal::purgeInjectionPointsCache();
	}

	@:meta(Test())
	public function invokeXMLConfiguredPostConstructMethod() : Void {
		var injectee : ClassInjectee = new ClassInjectee();
		var injector : Injector = new Injector();
		injector.map(Clazz);
		injector.injectInto(injectee);
		Assert.assertTrue(injectee.someProperty);
	}


	public function new() {
	}
}

