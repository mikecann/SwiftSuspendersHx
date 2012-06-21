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

class PropertyInjectionPointTests {

	var injector : Injector;
	@:meta(Before())
	public function runBeforeEachTest() : Void {
		injector = new Injector();
	}

	@:meta(After())
	public function teardown() : Void {
		Injector.SsInternal::purgeInjectionPointsCache();
		injector = null;
	}

	@:meta(Test())
	public function injectionOfSinglePropertyIsApplied() : Void {
		injector.map(Clazz).toSingleton(Clazz);
		var injectee : ClassInjectee = new ClassInjectee();
		var injectionPoint : PropertyInjectionPoint = new PropertyInjectionPoint("org.swiftsuspenders.support.types::Clazz|", "property", false, null);
		injectionPoint.applyInjection(injectee, ClassInjectee, injector);
		Assert.assertTrue("injectee should contain Clazz instance", Std.is(injectee.property, Clazz));
	}

	@:meta(Test())
	public function injectionAttemptWithUnmappedOptionalPropertyDoesntThrow() : Void {
		var injectee : ClassInjectee = new ClassInjectee();
		var injectionPoint : PropertyInjectionPoint = new PropertyInjectionPoint("org.swiftsuspenders.support.types::Clazz|", "property", true, null);
		injectionPoint.applyInjection(injectee, ClassInjectee, injector);
		Assert.assertNull("injectee mustn\'t contain Clazz instance", injectee.property);
	}


	public function new() {
	}
}

