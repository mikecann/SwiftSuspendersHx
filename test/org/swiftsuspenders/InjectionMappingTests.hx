/*
 * Copyright (c) 2011 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */
package org.swiftsuspenders;

import flexunit.framework.Assert;
import org.hamcrest.AssertThat;
import org.hamcrest.core.IsA;
import org.hamcrest.object.EqualTo;
import org.hamcrest.object.HasProperties;
import org.hamcrest.object.IsTrue;
import org.hamcrest.object.NotNullValue;
import org.swiftsuspenders.dependencyproviders.ClassProvider;
import org.swiftsuspenders.dependencyproviders.SingletonProvider;
import org.swiftsuspenders.support.types.Clazz;
import org.swiftsuspenders.support.types.Interface;
import org.swiftsuspenders.utils.SsInternal;

class InjectionMappingTests {

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
	public function configIsInstantiated() : Void {
		var config : InjectionMapping = new InjectionMapping(injector, Clazz, "", "");
		Assert.assertTrue(Std.is(config, InjectionMapping));
	}

	@:meta(Test())
	public function mappingWithoutProviderEverSetUsesClassProvider() : Void {
		var config : InjectionMapping = new InjectionMapping(injector, Clazz, "", "");
		assertThat(config.getProvider(), isA(ClassProvider));
	}

	@:meta(Test())
	public function injectionMappingAsSingletonMethodCreatesSingletonProvider() : Void {
		var config : InjectionMapping = new InjectionMapping(injector, Clazz, "", "");
		config.asSingleton();
		assertThat(config.getProvider(), isA(SingletonProvider));
	}

	@:meta(Test())
	public function sameNamedSingletonIsReturnedOnSecondResponse() : Void {
		var provider : SingletonProvider = new SingletonProvider(Clazz, injector);
		var returnedResponse : Dynamic = provider.apply(null, injector, null);
		var secondResponse : Dynamic = provider.apply(null, injector, null);
		Assert.assertStrictlyEquals(returnedResponse, secondResponse);
	}

	@:meta(Test())
	public function setProviderChangesTheProvider() : Void {
		var provider1 : SingletonProvider = new SingletonProvider(Clazz, injector);
		var provider2 : ClassProvider = new ClassProvider(Clazz);
		var config : InjectionMapping = new InjectionMapping(injector, Clazz, "", "");
		config.toProvider(provider1);
		assertThat(config.getProvider(), equalTo(provider1));
		config.toProvider(null);
		config.toProvider(provider2);
		assertThat(config.getProvider(), equalTo(provider2));
	}

	@:meta(Test())
	public function sealingAMappingMakesItSealed() : Void {
		var config : InjectionMapping = new InjectionMapping(injector, Interface, "", "");
		config.seal();
		assertThat(config.isSealed, isTrue());
	}

	@:meta(Test())
	public function sealingAMappingMakesItUnchangable() : Void {
		var config : InjectionMapping = new InjectionMapping(injector, Interface, "", "");
		config.seal();
		var methods : Array<Dynamic> = [{
			method : "asSingleton",
			args : [],

		}, {
			method : "toSingleton",
			args : [Clazz],

		}, {
			method : "toType",
			args : [Clazz],

		}, {
			method : "toValue",
			args : [Clazz],

		}, {
			method : "toProvider",
			args : [null],

		}, {
			method : "local",
			args : [],

		}, {
			method : "shared",
			args : [],

		}, {
			method : "soft",
			args : [],

		}, {
			method : "strong",
			args : [],

		}];
		var testedMethods : Array<Dynamic> = [];
		for(method in methods/* AS3HX WARNING could not determine type for var: method exp: EIdent(methods) type: Array<Dynamic>*/) {
			try {
				config[method.method].apply(config, method.args);
			}
			catch(error : InjectorError) {
				testedMethods.push(method);
			}

		}

		assertThat(testedMethods, hasProperties(methods));
	}

	@:meta(Test(expects="org.swiftsuspenders.InjectorError"))
	public function unmappingASealedMappingThrows() : Void {
		injector.map(Interface).seal();
		injector.unmap(Interface);
	}

	@:meta(Test(expects="org.swiftsuspenders.InjectorError"))
	public function doubleSealingAMappingThrows() : Void {
		injector.map(Interface).seal();
		injector.map(Interface).seal();
	}

	@:meta(Test())
	public function sealReturnsAnUnsealingKeyObject() : Void {
		var config : InjectionMapping = new InjectionMapping(injector, Interface, "", "");
		assertThat(config.seal(), notNullValue());
	}

	@:meta(Test(expects="org.swiftsuspenders.InjectorError"))
	public function unsealingAMappingWithoutKeyThrows() : Void {
		injector.map(Interface).seal();
		injector.map(Interface).unseal(null);
	}

	@:meta(Test(expects="org.swiftsuspenders.InjectorError"))
	public function unsealingAMappingWithWrongKeyThrows() : Void {
		injector.map(Interface).seal();
		injector.map(Interface).unseal({ });
	}

	@:meta(Test())
	public function unsealingAMappingWithRightKeyMakesItChangable() : Void {
		var key : Dynamic = injector.map(Interface).seal();
		injector.map(Interface).unseal(key);
		injector.map(Interface).local();
	}

	@:meta(Test())
	public function valueMappingSupportsNullValue() : Void {
		injector.map(Interface).toValue(null);
		injector.getInstance(Interface);
	}


	public function new() {
	}
}

