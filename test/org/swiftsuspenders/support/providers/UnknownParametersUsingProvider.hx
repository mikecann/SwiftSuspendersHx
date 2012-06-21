/*
 * Copyright (c) 2011 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */
package org.swiftsuspenders.support.providers;

import flash.utils.Dictionary;
import org.swiftsuspenders.Injector;
import org.swiftsuspenders.dependencyproviders.DependencyProvider;
import org.swiftsuspenders.support.types.Clazz;

class UnknownParametersUsingProvider implements DependencyProvider {

	//----------------------              Public Properties             ----------------------//
		public var parameterValue : String;
	//----------------------               Public Methods               ----------------------//
		public function apply(targetType : Class<Dynamic>, activeInjector : Injector, injectParameters : Dictionary) : Dynamic {
		parameterValue = injectParameters.param;
		return new Clazz();
	}


	public function new() {
	}
}

