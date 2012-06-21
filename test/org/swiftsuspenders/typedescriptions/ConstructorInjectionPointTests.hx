/*
 * Copyright (c) 2011 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */
package org.swiftsuspenders.typedescriptions;

import org.flexunit.Assert;
import org.swiftsuspenders.Injector;
import org.swiftsuspenders.support.injectees.TwoOptionalParametersConstructorInjectee;
import org.swiftsuspenders.support.injectees.TwoParametersConstructorInjectee;
import org.swiftsuspenders.support.types.Clazz;
import org.swiftsuspenders.utils.SsInternal;

class ConstructorInjectionPointTests {

	static public inline var STRING_REFERENCE : String = "stringReference";
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
	public function injectionOfTwoUnnamedPropertiesIntoConstructor() : Void {
		injector.map(Clazz).toSingleton(Clazz);
		injector.map(String).toValue(STRING_REFERENCE);
		var parameters : Array<Dynamic> = ["org.swiftsuspenders.support.types::Clazz|", "String|"];
		var injectionPoint : ConstructorInjectionPoint = new ConstructorInjectionPoint(parameters, 2, null);
		var injectee : TwoParametersConstructorInjectee = try cast(injectionPoint.createInstance(TwoParametersConstructorInjectee, injector), TwoParametersConstructorInjectee) catch(e:Dynamic) null;
		Assert.assertTrue("dependency 1 should be Clazz instance", Std.is(injectee.getDependency(), Clazz));
		Assert.assertTrue("dependency 2 should be 'stringReference'", injectee.getDependency2() == STRING_REFERENCE);
	}

	@:meta(Test())
	public function injectionOfFirstOptionalPropertyIntoTwoOptionalParametersConstructor() : Void {
		injector.map(Clazz).toSingleton(Clazz);
		var parameters : Array<Dynamic> = ["org.swiftsuspenders.support.types::Clazz|", "String|"];
		var injectionPoint : ConstructorInjectionPoint = new ConstructorInjectionPoint(parameters, 0, null);
		var injectee : TwoOptionalParametersConstructorInjectee = try cast(injectionPoint.createInstance(TwoOptionalParametersConstructorInjectee, injector), TwoOptionalParametersConstructorInjectee) catch(e:Dynamic) null;
		Assert.assertTrue("dependency 1 should be Clazz instance", Std.is(injectee.getDependency(), Clazz));
		Assert.assertTrue("dependency 2 should be null", injectee.getDependency2() == null);
	}

	@:meta(Test())
	public function injectionOfSecondOptionalPropertyIntoTwoOptionalParametersConstructor() : Void {
		injector.map(String).toValue(STRING_REFERENCE);
		var parameters : Array<Dynamic> = ["org.swiftsuspenders.support.types::Clazz|", "String|"];
		var injectionPoint : ConstructorInjectionPoint = new ConstructorInjectionPoint(parameters, 0, null);
		var injectee : TwoOptionalParametersConstructorInjectee = try cast(injectionPoint.createInstance(TwoOptionalParametersConstructorInjectee, injector), TwoOptionalParametersConstructorInjectee) catch(e:Dynamic) null;
		Assert.assertTrue("dependency 1 should be Clazz null", injectee.getDependency() == null);
		Assert.assertTrue("dependency 2 should be null", injectee.getDependency2() == null);
	}


	public function new() {
	}
}

