/*
 * Copyright (c) 2011 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */
package org.swiftsuspenders.typedescriptions;

import flash.utils.Dictionary;
import org.swiftsuspenders.Injector;
import org.swiftsuspenders.InjectorError;
import org.swiftsuspenders.dependencyproviders.DependencyProvider;

class MethodInjectionPoint extends InjectionPoint {

	//----------------------       Private / Protected Properties       ----------------------//
	static inline var _parameterValues : Array<Dynamic> = [];
	var _parameterMappingIDs : Array<Dynamic>;
	var _requiredParameters : Int;
	var _isOptional : Bool;
	var _methodName : String;
	//----------------------               Public Methods               ----------------------//
	
	public function new(methodName : String, parameters : Array<Dynamic>, requiredParameters : Int, isOptional : Bool, injectParameters : Hash<String>) {
		_methodName = methodName;
		_parameterMappingIDs = parameters;
		_requiredParameters = requiredParameters;
		_isOptional = isOptional;
		this.injectParameters = injectParameters;
		super();
	}

	override public function applyInjection(target : Dynamic, targetType : Class<Dynamic>, injector : Injector) : Void 
	{
		//var p : Array<Dynamic> = gatherParameterValues(target, targetType, injector);
		//if(p.length >= _requiredParameters)  {
			//(try cast(Reflect.field(target, _methodName), Function) catch(e:Dynamic) null).apply(target, p);
		//}
		//p.length = 0;
		
		var parameters: Array<Dynamic> = gatherParameterValues(target, targetType, injector);
		var method: Dynamic = Reflect.field(target, _methodName);
		Reflect.callMethod(target, method, parameters);
	}

	//----------------------         Private / Protected Methods        ----------------------//
	//function gatherParameterValues(target : Dynamic, targetType : Class<Dynamic>, injector : Injector) : Array<Dynamic> 
	//{
		//var length : Int = _parameterMappingIDs.length;
		//var parameters : Array<Dynamic> = _parameterValues;
		//parameters.length = length;
		//var i : Int = 0;
		//while(i < length) {
			//var parameterMappingId : String = _parameterMappingIDs[i];
			//var provider : DependencyProvider = injector.getProvider(parameterMappingId);
			//if(provider == null)  {
				//if(i >= _requiredParameters || _isOptional)  {
					//break;
				//}
				//throw (new InjectorError("Injector is missing a mapping to handle injection into target \"" + target + "\" of type \"" + Type.getClassName(targetType) + "\" Target dependency: " + parameterMappingId + ", method: " + _methodName + ", parameter: " + (i + 1)));
			//}
			//parameters[i] = provider.apply(targetType, injector, injectParameters);
			//i++;
		//}
		//return parameters;
		//return null;
	//}
	
	function gatherParameterValues(target : Dynamic, targetType : Class<Dynamic>, injector : Injector):Array<Dynamic>
	{
		var parameters: Array<Dynamic> = [];
		var length: Int = _parameterMappingIDs.length;

		for (i in 0...length)
		{
			var parameterMappingId = _parameterMappingIDs[i];
			
			var provider = injector.getProvider(parameterMappingId);
			//var config = injector.getMapping(Type.resolveClass(parameterConfig.typeName), parameterConfig.injectionName);

			//var injection:Dynamic = config.getResponse(injector);
			if (provider == null)
			{
				if(i >= _requiredParameters || _isOptional)  {
					break;
				}

				throw(new InjectorError('Injector is missing a rule to handle injection into target ' + Type.getClassName(target) + '. Target dependency: ' + Type.getClassName(targetType) + "\" Target dependency: " + parameterMappingId + ", method: " + _methodName + ", parameter: " + (i + 1)));
			}

			parameters[i] = provider.apply(targetType, injector, injectParameters);
		}

		return parameters;
	}

}

