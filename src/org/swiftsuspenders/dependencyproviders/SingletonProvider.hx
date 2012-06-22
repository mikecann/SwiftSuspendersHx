/*
 * Copyright (c) 2011 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */
package org.swiftsuspenders.dependencyproviders;

import flash.utils.Dictionary;
import org.swiftsuspenders.Injector;

class SingletonProvider implements DependencyProvider {

	//----------------------       Private / Protected Properties       ----------------------//
	var _responseType : Class<Dynamic>;
	var _creatingInjector : Injector;
	var _response : Dynamic;
	//----------------------               Public Methods               ----------------------//
	
	/**
	 *
	 * @param responseType The class the provider returns the same, lazily created, instance
	 * of for each request
	 * @param creatingInjector The injector that was used to create the
	 * <code>InjectionMapping</code> this DependencyProvider is associated with
	 */	
	public function new(responseType : Class<Dynamic>, creatingInjector : Injector) 
	{
		_responseType = responseType;
		_creatingInjector = creatingInjector;
	}

	/**
	 * @inheritDoc
	 *
	 * @return The same, lazily created, instance of the class given to the SingletonProvider's
	 * constructor on each invocation
	 */	
	public function apply(targetType : Class<Dynamic>, activeInjector : Injector, injectParameters : Hash<String>) : Dynamic 
	{
		if (!_response) _response = createResponse(_creatingInjector);		
		return _response;
	}

	//----------------------         Private / Protected Methods        ----------------------//
	function createResponse(injector : Injector) : Dynamic 
	{
		return injector.instantiateUnmapped(_responseType);
	}

}

