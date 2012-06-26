/*
 * Copyright (c) 2011 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */
package org.swiftsuspenders.support.injectees.childinjectors;

import org.swiftsuspenders.Injector;
import org.swiftsuspenders.dependencyproviders.DependencyProvider;

class ChildInjectorCreatingProvider implements DependencyProvider {

	public function apply(targetType : Class<Dynamic>, activeInjector : Injector, injectParameters : Hash<String>) : Dynamic {
		return activeInjector.createChildInjector();
	}
	
	public function new() {
	}
}

