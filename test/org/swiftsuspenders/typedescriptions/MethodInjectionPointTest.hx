/*
 * Copyright (c) 2011 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */
package org.swiftsuspenders.typedescriptions;

import org.flexunit.Assert;
import org.swiftsuspenders.Injector;
import org.swiftsuspenders.support.injectees.OneRequiredOneOptionalPropertyMethodInjectee;
import org.swiftsuspenders.support.injectees.OptionalOneRequiredParameterMethodInjectee;
import org.swiftsuspenders.support.injectees.TwoParametersMethodInjectee;
import org.swiftsuspenders.support.types.Clazz;
import org.swiftsuspenders.support.types.Interface;
import org.swiftsuspenders.utils.SsInternal;

class MethodInjectionPointTest {

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
	public function injectionOfTwoUnnamedPropertiesIntoMethod() : Void {
		var injectee : TwoParametersMethodInjectee = new TwoParametersMethodInjectee();
		injector.map(Clazz).toSingleton(Clazz);
		injector.map(Interface).toSingleton(Clazz);
		var parameters : Array<Dynamic> = ["org.swiftsuspenders.support.types::Clazz|", "org.swiftsuspenders.support.types::Interface|"];
		var injectionPoint : MethodInjectionPoint = new MethodInjectionPoint("setDependencies", parameters, 2, false, null);
		injectionPoint.applyInjection(injectee, TwoParametersMethodInjectee, injector);
		Assert.assertTrue("dependency 1 should be Clazz instance", Std.is(injectee.getDependency(), Clazz));
		Assert.assertTrue("dependency 2 should be Interface", Std.is(injectee.getDependency2(), Interface));
	}

	@:meta(Test())
	public function injectionOfOneRequiredOneOptionalPropertyIntoMethod() : Void {
		var injectee : OneRequiredOneOptionalPropertyMethodInjectee = new OneRequiredOneOptionalPropertyMethodInjectee();
		injector.map(Clazz).toSingleton(Clazz);
		var parameters : Array<Dynamic> = ["org.swiftsuspenders.support.types::Clazz|", "org.swiftsuspenders.support.types::Interface|"];
		var injectionPoint : MethodInjectionPoint = new MethodInjectionPoint("setDependencies", parameters, 1, false, null);
		injectionPoint.applyInjection(injectee, OneRequiredOneOptionalPropertyMethodInjectee, injector);
		Assert.assertTrue("dependency 1 should be Clazz instance", Std.is(injectee.getDependency(), Clazz));
		Assert.assertTrue("dependency 2 should be null", injectee.getDependency2() == null);
	}

	@:meta(Test())
	public function injectionAttemptWithUnmappedOptionalMethodInjectionDoesntThrow() : Void {
		var injectee : OptionalOneRequiredParameterMethodInjectee = new OptionalOneRequiredParameterMethodInjectee();
		var parameters : Array<Dynamic> = ["org.swiftsuspenders.support.types::Clazz|"];
		var injectionPoint : MethodInjectionPoint = new MethodInjectionPoint("setDependency", parameters, 1, true, null);
		injectionPoint.applyInjection(injectee, OptionalOneRequiredParameterMethodInjectee, injector);
		Assert.assertNull("dependency must be null", injectee.getDependency());
	}


	public function new() {
	}
}

