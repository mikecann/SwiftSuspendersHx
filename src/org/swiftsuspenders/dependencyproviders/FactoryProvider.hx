/*
 * Copyright (c) 2011 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */
package org.swiftsuspenders.dependencyproviders;

import flash.utils.Dictionary;
import org.swiftsuspenders.Injector;

class FactoryProvider implements DependencyProvider {

	//----------------------       Private / Protected Properties       ----------------------//
		var _factoryClass : Class<Dynamic>;
	//----------------------               Public Methods               ----------------------//
		public function new(factoryClass : Class<Dynamic>) {
		_factoryClass = factoryClass;
	}

	public function apply(targetType : Class<Dynamic>, activeInjector : Injector, injectParameters : Dictionary) : Dynamic {
		return cast((activeInjector.getInstance(_factoryClass)), DependencyProvider).apply(targetType, activeInjector, injectParameters);
	}

}

