/*
 * Copyright (c) 2011 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */
package org.swiftsuspenders.dependencyproviders;

import flash.utils.Dictionary;
import org.swiftsuspenders.InjectionMapping;
import org.swiftsuspenders.Injector;

class OtherMappingProvider implements DependencyProvider {

	//----------------------       Private / Protected Properties       ----------------------//
		var _mapping : InjectionMapping;
	//----------------------               Public Methods               ----------------------//
		public function new(mapping : InjectionMapping) {
		_mapping = mapping;
	}

	/**
	 * @inheritDoc
	 *
	 * @return The result of invoking <code>apply</code> on the <code>InjectionMapping</code>
	 * provided to this provider's constructor
	 */	public function apply(targetType : Class<Dynamic>, activeInjector : Injector, injectParameters : Dictionary) : Dynamic {
		return _mapping.getProvider().apply(targetType, activeInjector, injectParameters);
	}

}

