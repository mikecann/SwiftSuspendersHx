/*
 * Copyright (c) 2011 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */
package org.swiftsuspenders.dependencyproviders;

import flash.utils.Dictionary;
import org.swiftsuspenders.Injector;

class ValueProvider implements DependencyProvider {

	//----------------------       Private / Protected Properties       ----------------------//
		var _value : Dynamic;
	//----------------------               Public Methods               ----------------------//
		public function new(value : Dynamic) {
		_value = value;
	}

	/**
	 * @inheritDoc
	 *
	 * @return The value provided to this provider's constructor
	 */	public function apply(targetType : Class<Dynamic>, activeInjector : Injector, injectParameters : Hash<String>) : Dynamic {
		return _value;
	}

}

