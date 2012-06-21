/*
 * Copyright (c) 2011 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */
package org.swiftsuspenders;

import flexunit.framework.Assert;
import org.swiftsuspenders.dependencyproviders.ClassProvider;
import org.swiftsuspenders.dependencyproviders.OtherMappingProvider;
import org.swiftsuspenders.dependencyproviders.SingletonProvider;
import org.swiftsuspenders.dependencyproviders.ValueProvider;
import org.swiftsuspenders.support.injectees.ClassInjectee;
import org.swiftsuspenders.support.providers.ClassNameStoringProvider;
import org.swiftsuspenders.support.types.Clazz;
import org.swiftsuspenders.support.types.ClazzExtension;
import org.swiftsuspenders.utils.SsInternal;

class DependencyProviderTests {

	var injector : Injector;
	@:meta(Before())
	public function setup() : Void {
		injector = new Injector();
	}

	@:meta(After())
	public function teardown() : Void {
		Injector.SsInternal::purgeInjectionPointsCache();
		injector = null;
	}

	@:meta(Test())
	public function valueProviderReturnsSetValue() : Void {
		var response : Clazz = new Clazz();
		var provider : ValueProvider = new ValueProvider(response);
		var returnedResponse : Dynamic = provider.apply(null, injector, null);
		Assert.assertStrictlyEquals(response, returnedResponse);
	}

	@:meta(Test())
	public function classProviderReturnsClassInstance() : Void {
		var classProvider : ClassProvider = new ClassProvider(Clazz);
		var returnedResponse : Dynamic = classProvider.apply(null, injector, null);
		Assert.assertTrue(Std.is(returnedResponse, Clazz));
	}

	@:meta(Test())
	public function classProviderReturnsDifferentInstancesOnEachApply() : Void {
		var classProvider : ClassProvider = new ClassProvider(Clazz);
		var firstResponse : Dynamic = classProvider.apply(null, injector, null);
		var secondResponse : Dynamic = classProvider.apply(null, injector, null);
		Assert.assertFalse(firstResponse == secondResponse);
	}

	@:meta(Test())
	public function singletonProviderReturnsInstance() : Void {
		var singletonProvider : SingletonProvider = new SingletonProvider(Clazz, injector);
		var returnedResponse : Dynamic = singletonProvider.apply(null, injector, null);
		Assert.assertTrue(Std.is(returnedResponse, Clazz));
	}

	@:meta(Test())
	public function sameSingletonIsReturnedOnSecondResponse() : Void {
		var singletonProvider : SingletonProvider = new SingletonProvider(Clazz, injector);
		var returnedResponse : Dynamic = singletonProvider.apply(null, injector, null);
		var secondResponse : Dynamic = singletonProvider.apply(null, injector, null);
		Assert.assertStrictlyEquals(returnedResponse, secondResponse);
	}

	@:meta(Test())
	public function injectionTypeOtherMappingReturnsOtherMappingsResponse() : Void {
		var otherConfig : InjectionMapping = new InjectionMapping(injector, ClazzExtension, "", "");
		otherConfig.toProvider(new ClassProvider(ClazzExtension));
		var otherMappingProvider : OtherMappingProvider = new OtherMappingProvider(otherConfig);
		var returnedResponse : Dynamic = otherMappingProvider.apply(null, injector, null);
		Assert.assertTrue(Std.is(returnedResponse, Clazz));
		Assert.assertTrue(Std.is(returnedResponse, ClazzExtension));
	}

	@:meta(Test())
	public function dependencyProviderHasAccessToTargetType() : Void {
		var provider : ClassNameStoringProvider = new ClassNameStoringProvider();
		injector.map(Clazz).toProvider(provider);
		injector.getInstance(ClassInjectee);
		Assert.assertEquals("className stored in provider is fqn of ClassInjectee", Type.getClassName(ClassInjectee), provider.lastTargetClassName);
	}


	public function new() {
	}
}

