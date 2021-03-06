/*
 * Copyright (c) 2011 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */
package org.swiftsuspenders.typedescriptions;

class PreDestroyInjectionPoint extends OrderedInjectionPoint {

	//----------------------               Public Methods               ----------------------//
		public function new(methodName : String, parameters : Array<Dynamic>, requiredParameters : Int, order : Int) {
		super(methodName, parameters, requiredParameters, order);
	}

}

