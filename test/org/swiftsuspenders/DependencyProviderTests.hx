/*
 * Copyright (c) 2011 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */
package org.swiftsuspenders;

import haxe.unit.TestCase;
import org.swiftsuspenders.dependencyproviders.ClassProvider;
import org.swiftsuspenders.dependencyproviders.OtherMappingProvider;
import org.swiftsuspenders.dependencyproviders.SingletonProvider;
import org.swiftsuspenders.dependencyproviders.ValueProvider;
import org.swiftsuspenders.support.injectees.ClassInjectee;
import org.swiftsuspenders.support.providers.ClassNameStoringProvider;
import org.swiftsuspenders.support.types.Clazz;
import org.swiftsuspenders.support.types.ClazzExtension;

class DependencyProviderTests extends TestCase
{

	var injector : Injector;
	
	override public function setup() 
	{ 
		injector = new Injector();
	}

	override public function tearDown() 
	{     
		Injector.purgeInjectionPointsCache();
		injector = null;
	}

	public function testValueProviderReturnsSetValue() : Void {
		var response = new Clazz();
		var provider = new ValueProvider(response);
		var returnedResponse : Dynamic = provider.apply(null, injector, null);
		assertTrue(response==returnedResponse);
	}

	public function testClassProviderReturnsClassInstance() : Void {
		var classProvider = new ClassProvider(Clazz);
		var returnedResponse : Dynamic = classProvider.apply(null, injector, null);
		assertTrue(Std.is(returnedResponse, Clazz));
	}

	public function testClassProviderReturnsDifferentInstancesOnEachApply() : Void {
		var classProvider = new ClassProvider(Clazz);
		var firstResponse = classProvider.apply(null, injector, null);
		var secondResponse = classProvider.apply(null, injector, null);
		assertFalse(firstResponse == secondResponse);
	}

	public function testSingletonProviderReturnsInstance() : Void {
		var singletonProvider : SingletonProvider = new SingletonProvider(Clazz, injector);
		var returnedResponse : Dynamic = singletonProvider.apply(null, injector, null);
		assertTrue(Std.is(returnedResponse, Clazz));
	}

	public function testSameSingletonIsReturnedOnSecondResponse() : Void {
		var singletonProvider = new SingletonProvider(Clazz, injector);
		var returnedResponse = singletonProvider.apply(null, injector, null);
		var secondResponse = singletonProvider.apply(null, injector, null);
		assertTrue(returnedResponse==secondResponse);
	}

	public function testInjectionTypeOtherMappingReturnsOtherMappingsResponse() : Void {
		var otherConfig = new InjectionMapping(injector, ClazzExtension, "", "");
		otherConfig.toProvider(new ClassProvider(ClazzExtension));
		var otherMappingProvider : OtherMappingProvider = new OtherMappingProvider(otherConfig);
		var returnedResponse = otherMappingProvider.apply(null, injector, null);
		assertTrue(Std.is(returnedResponse, Clazz));
		assertTrue(Std.is(returnedResponse, ClazzExtension));
	}

	public function testDependencyProviderHasAccessToTargetType() : Void {
		var provider = new ClassNameStoringProvider();
		injector.map(Clazz).toProvider(provider);
		injector.getInstance(ClassInjectee);
		assertTrue(Type.getClassName(ClassInjectee)==provider.lastTargetClassName); // className stored in provider is fqn of ClassInjectee
	}	
}

