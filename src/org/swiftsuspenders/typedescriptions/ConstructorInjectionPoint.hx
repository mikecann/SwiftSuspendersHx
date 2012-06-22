/*
 * Copyright (c) 2011 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */
package org.swiftsuspenders.typedescriptions;

import flash.utils.Dictionary;
import org.swiftsuspenders.Injector;

class ConstructorInjectionPoint extends MethodInjectionPoint {

	//----------------------               Public Methods               ----------------------//
		public function new(parameters : Array<Dynamic>, requiredParameters : Int, injectParameters : Hash<String>) {
		super("ctor", parameters, requiredParameters, false, injectParameters);
	}

	public function createInstance(type : Class<Dynamic>, injector : Injector) : Dynamic {
		var p : Array<Dynamic> = gatherParameterValues(type, type, injector);
		var result : Dynamic=null;
		//the only way to implement ctor injections, really!
		var _sw0_ = (p.length);
		switch(_sw0_) {
		case 1:
			result = Type.createInstance(type, [p[0]]);
		case 2:
			result = Type.createInstance(type, [p[0], p[1]]);
		case 3:
			result = Type.createInstance(type, [p[0], p[1], p[2]]);
		case 4:
			result = Type.createInstance(type, [p[0], p[1], p[2], p[3]]);
		case 5:
			result = Type.createInstance(type, [p[0], p[1], p[2], p[3], p[4]]);
		case 6:
			result = Type.createInstance(type, [p[0], p[1], p[2], p[3], p[4], p[5]]);
		case 7:
			result = Type.createInstance(type, [p[0], p[1], p[2], p[3], p[4], p[5], p[6]]);
		case 8:
			result = Type.createInstance(type, [p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7]]);
		case 9:
			result = Type.createInstance(type, [p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8]]);
		case 10:
			result = Type.createInstance(type, [p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9]]);
		};
		//p.length = 0;
		return result;
	}

}

