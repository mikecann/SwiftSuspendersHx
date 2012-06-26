/*
 * Copyright (c) 2011 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */
package org.swiftsuspenders.typedescriptions;

import org.swiftsuspenders.Injector;
import org.swiftsuspenders.InjectorError;
import org.swiftsuspenders.dependencyproviders.DependencyProvider;

class PropertyInjectionPoint extends InjectionPoint 
{

	//----------------------       Private / Protected Properties       ----------------------//
	var _propertyName : String;
	var _mappingId : String;
	var _optional : Bool;
	//----------------------               Public Methods               ----------------------//
	
	public function new(mappingId : String, propertyName : String, optional : Bool, injectParameters : Hash<String>) {
		_propertyName = propertyName;
		_mappingId = mappingId;
		_optional = optional;
		this.injectParameters = injectParameters;
		super();
	}

	override public function applyInjection(target : Dynamic, targetType : Class<Dynamic>, injector : Injector) : Void {
		var provider : DependencyProvider = injector.getProvider(_mappingId);
		if(provider == null)  {
			if(_optional)  {
				return;
			}
			throw (new InjectorError("Injector is missing a mapping to handle injection into property \"" + _propertyName + "\" of object \"" + target + "\" with type \"" + targetType + "\". Target dependency: \"" + _mappingId + "\""));
		}
		Reflect.setField(target, _propertyName, provider.apply(targetType, injector, injectParameters));
	}

}

