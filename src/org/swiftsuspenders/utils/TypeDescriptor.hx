/*
 * Copyright (c) 2012 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */
package org.swiftsuspenders.utils;

import org.swiftsuspenders.InjectionMapping;
import org.swiftsuspenders.Reflector;
import org.swiftsuspenders.typedescriptions.TypeDescription;

class TypeDescriptor 
{

	//----------------------       Private / Protected Properties       ----------------------//
	public var _descriptionsCache : Hash<TypeDescription>;
	private var _reflector : Reflector;
	//----------------------               Public Methods               ----------------------//
	
	public function new(reflector : Reflector, descriptionsCache : Hash<TypeDescription>) {
		_descriptionsCache = descriptionsCache;
		_reflector = reflector;
	}

	public function getDescription(type : Class<Dynamic>) : TypeDescription {
		var f = _descriptionsCache.get(Std.string(type));
		if (f==null) { f = _reflector.describeInjections(type); _descriptionsCache.set(Std.string(type), f); }
		return f;
	}

	public function addDescription(type : Class<Dynamic>, description : TypeDescription) : Void 
	{
		_descriptionsCache.set(Std.string(type), description);
	}

}

