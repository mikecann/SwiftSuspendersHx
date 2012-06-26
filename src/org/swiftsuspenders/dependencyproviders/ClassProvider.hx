/*
 * Copyright (c) 2011 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */
package org.swiftsuspenders.dependencyproviders;

import org.swiftsuspenders.Injector;

class ClassProvider implements DependencyProvider 
{

	//----------------------       Private / Protected Properties       ----------------------//
	var _responseType : Class<Dynamic>;
	//----------------------               Public Methods               ----------------------//
	
	public function new(responseType : Class<Dynamic>) 
	{
		_responseType = responseType;
	}

	/**
	 * @inheritDoc
	 *
	 * @return A new instance of the class given to the ClassProvider's constructor,
	 * constructed using the <code>usingInjector</code>
	 */	
	public function apply(targetType : Class<Dynamic>, activeInjector : Injector, injectParameters : Hash<String>) : Dynamic 
	{
		return activeInjector.instantiateUnmapped(_responseType);
	}

}

