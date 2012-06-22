/*
 * Copyright (c) 2011 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */
package org.swiftsuspenders.typedescriptions;

import flash.utils.Dictionary;
import haxe.Int32;
import org.swiftsuspenders.InjectorError;

class TypeDescription 
{
	public static inline var MAX_INT : Int = 999999999;

	//----------------------              Public Properties             ----------------------//
	public var ctor : ConstructorInjectionPoint;
	public var injectionPoints : InjectionPoint;
	public var preDestroyMethods : PreDestroyInjectionPoint;	
	//----------------------       Private / Protected Properties       ----------------------//
	var _postConstructAdded : Bool;
	//----------------------               Public Methods               ----------------------//
	
	public function new(useDefaultConstructor : Bool = true) {
		if(useDefaultConstructor)  {
			ctor = new NoParamsConstructorInjectionPoint();
		}
	}

	public function setConstructor(parameterTypes : Array<Class<Dynamic>>, parameterNames : Array<String> = null, requiredParameters : Int = MAX_INT, metadata : Hash<String> = null) : TypeDescription {
		if (parameterNames == null) parameterNames = [];
		ctor = new ConstructorInjectionPoint(createParameterMappings(parameterTypes, parameterNames), requiredParameters, metadata);
		return this;
	}

	public function addFieldInjection(fieldName : String, type : Class<Dynamic>, injectionName : String = "", optional : Bool = false, metadata : Hash<String> = null) : TypeDescription {
		if(_postConstructAdded)  {
			throw new InjectorError("Can\'t add injection point after post construct method");
		}
		addInjectionPoint(new PropertyInjectionPoint(Type.getClassName(type) + "|" + injectionName, fieldName, optional, metadata));
		return this;
	}

	public function addMethodInjection(methodName : String, parameterTypes : Array<Class<Dynamic>>, parameterNames : Array<String> = null, requiredParameters : Int = MAX_INT, optional : Bool = false, metadata : Hash<String> = null) : TypeDescription {
		if(_postConstructAdded)  {
			throw new InjectorError("Can\'t add injection point after post construct method");
		}
		if (parameterNames == null) parameterNames = [];
		addInjectionPoint(new MethodInjectionPoint(methodName, createParameterMappings(parameterTypes, parameterNames), Std.int(Math.min(requiredParameters, parameterTypes.length)), optional, metadata));
		return this;
	}

	public function addPostConstructMethod(methodName : String, parameterTypes : Array<Class<Dynamic>>, parameterNames : Array<String> = null, requiredParameters : Int = MAX_INT) : TypeDescription {
		_postConstructAdded = true;
		if (parameterNames == null) parameterNames = [];
		addInjectionPoint(new PostConstructInjectionPoint(methodName, createParameterMappings(parameterTypes, parameterNames), Std.int(Math.min(requiredParameters, parameterTypes.length)), 0));
		return this;
	}

	public function addPreDestroyMethod(methodName : String, parameterTypes : Array<Class<Dynamic>>, parameterNames : Array<String> = null, requiredParameters : Int = MAX_INT) : TypeDescription {
		if (parameterNames == null) parameterNames = [];
		var method : PreDestroyInjectionPoint = new PreDestroyInjectionPoint(methodName, createParameterMappings(parameterTypes, parameterNames), Std.int(Math.min(requiredParameters, parameterTypes.length)), 0);
		if(preDestroyMethods != null)  {
			preDestroyMethods.last.next = method;
			preDestroyMethods.last = method;
		}

		else  {
			preDestroyMethods = method;
			preDestroyMethods.last = method;
		}

		return this;
	}

	public function addInjectionPoint(injectionPoint : InjectionPoint) : Void {
		if(injectionPoints != null)  {
			injectionPoints.last.next = injectionPoint;
			injectionPoints.last = injectionPoint;
		}

		else  {
			injectionPoints = injectionPoint;
			injectionPoints.last = injectionPoint;
		}

	}

	//----------------------         Private / Protected Methods        ----------------------//
	function createParameterMappings(parameterTypes : Array<Class<Dynamic>>, parameterNames : Array<String>) : Array<Dynamic> 
	{
		var parameters : Array<Dynamic> = new Array<Dynamic>();
		var i : Int = parameters.length;
		while (i-- != 0) {
			var n = "";
			if (parameterNames[i] != null) n = parameterNames[i];
			parameters[i] = Type.getClassName(parameterTypes[i]) + "|" + n;
		}
		return parameters;
	}

}

