/*
 * Copyright (c) 2012 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */
package org.swiftsuspenders;

import flash.utils.Proxy;

class ReflectorBase {

	//----------------------              Public Properties             ----------------------//
		//----------------------       Private / Protected Properties       ----------------------//
		//----------------------               Public Methods               ----------------------//
		public function new() {
	}

	public function getClass(value : Dynamic) : Class<Dynamic> {
		/*
		 There are several types for which the 'constructor' property doesn't work:
		 - instances of Proxy, XML and XMLList throw exceptions when trying to access 'constructor'
		 - int and uint return Number as their constructor
		 For these, we have to fall back to more verbose ways of getting the constructor.

		 Additionally, Vector instances always return Vector.<*> when queried for their constructor.
		 Ideally, that would also be resolved, but then Swiftsuspenders wouldn't be compatible
		 with Flash Player < 10, anymore.
		 *///TODO: enable Vector type checking, we don't support FP 9, anymore
		//if(Std.is(value, Proxy || Std.is(value, Float || Std.is(value, FastXML || Std.is(value, FastXMLList)))))  {
			//return cast((Type.resolveClass(Type.getClassName(value))), Class);
		//}

		return value.constructor;
	}

	public function getFQCN(value : Dynamic, replaceColons : Bool = false) : String {
		var fqcn : String;
		if(Std.is(value, String))  {
			fqcn = value;
			// Add colons if missing and desired.
			if(!replaceColons && fqcn.indexOf("::") == -1)  {
				var lastDotIndex : Int = fqcn.lastIndexOf(".");
				if(lastDotIndex == -1)  {
					return fqcn;
				}
				return fqcn.substr(0, lastDotIndex) + "::" + fqcn.substr(lastDotIndex + 1);
			}
		}

		else  {
			fqcn = Type.getClassName(value);
		}

		return (replaceColons) ? fqcn.split("::").join(".") : fqcn;
	}

	//----------------------         Private / Protected Methods        ----------------------//
	}

