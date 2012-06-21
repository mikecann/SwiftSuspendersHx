/*
 * Copyright (c) 2011 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */
package org.swiftsuspenders;

import avmplus.DescribeTypeJSON;
import flash.utils.Dictionary;
import org.swiftsuspenders.typedescriptions.ConstructorInjectionPoint;
import org.swiftsuspenders.typedescriptions.MethodInjectionPoint;
import org.swiftsuspenders.typedescriptions.NoParamsConstructorInjectionPoint;
import org.swiftsuspenders.typedescriptions.PostConstructInjectionPoint;
import org.swiftsuspenders.typedescriptions.PreDestroyInjectionPoint;
import org.swiftsuspenders.typedescriptions.PropertyInjectionPoint;
import org.swiftsuspenders.typedescriptions.TypeDescription;

class DescribeTypeJSONReflector extends ReflectorBase, implements Reflector {

	//----------------------       Private / Protected Properties       ----------------------//
		var _descriptor : DescribeTypeJSON;
	//----------------------               Public Methods               ----------------------//
		public function typeImplements(type : Class<Dynamic>, superType : Class<Dynamic>) : Bool {
		if(type == superType)  {
			return true;
		}
		var superClassName : String = Type.getClassName(superType);
		var traits : Dynamic = _descriptor.getInstanceDescription(type).traits;
		return (try cast(traits.bases, Array) catch(e:Dynamic) null).indexOf(superClassName) > -1 || (try cast(traits.interfaces, Array) catch(e:Dynamic) null).indexOf(superClassName) > -1;
	}

	public function describeInjections(type : Class<Dynamic>) : TypeDescription {
		var rawDescription : Dynamic = _descriptor.getInstanceDescription(type);
		var traits : Dynamic = rawDescription.traits;
		var typeName : String = rawDescription.name;
		var description : TypeDescription = new TypeDescription(false);
		addCtorInjectionPoint(description, traits, typeName);
		addFieldInjectionPoints(description, traits.variables);
		addFieldInjectionPoints(description, traits.accessors);
		addMethodInjectionPoints(description, traits.methods, typeName);
		addPostConstructMethodPoints(description, traits.variables, typeName);
		addPostConstructMethodPoints(description, traits.accessors, typeName);
		addPostConstructMethodPoints(description, traits.methods, typeName);
		addPreDestroyMethodPoints(description, traits.methods, typeName);
		return description;
	}

	//----------------------         Private / Protected Methods        ----------------------//
		function addCtorInjectionPoint(description : TypeDescription, traits : Dynamic, typeName : String) : Void {
		var parameters : Array<Dynamic> = traits.constructor;
		if(parameters == null)  {
			description.ctor = traits.bases.length > (0) ? new NoParamsConstructorInjectionPoint() : null;
			return;
		}
		var injectParameters : Dictionary = extractTagParameters("Inject", traits.metadata);
		var parameterNames : Array<Dynamic> = (injectParameters && injectParameters.name || "").split(",");
		var requiredParameters : Int = gatherMethodParameters(parameters, parameterNames, typeName);
		description.ctor = new ConstructorInjectionPoint(parameters, requiredParameters, injectParameters);
	}

	function addMethodInjectionPoints(description : TypeDescription, methods : Array<Dynamic>, typeName : String) : Void {
		if(methods == null)  {
			return;
		}
		var length : Int = methods.length;
		var i : Int = 0;
		while(i < length) {
			var method : Dynamic = methods[i];
			var injectParameters : Dictionary = extractTagParameters("Inject", method.metadata);
			if(injectParameters == null)  {
				 {
					i++;
					continue;
				}

			}
			var optional : Bool = injectParameters.optional == "true";
			var parameterNames : Array<Dynamic> = (injectParameters.name || "").split(",");
			var parameters : Array<Dynamic> = method.parameters;
			var requiredParameters : Int = gatherMethodParameters(parameters, parameterNames, typeName);
			var injectionPoint : MethodInjectionPoint = new MethodInjectionPoint(method.name, parameters, requiredParameters, optional, injectParameters);
			description.addInjectionPoint(injectionPoint);
			i++;
		}
	}

	function addPostConstructMethodPoints(description : TypeDescription, methods : Array<Dynamic>, typeName : String) : Void {
		var injectionPoints : Array<Dynamic> = gatherOrderedInjectionPointsForTag(PostConstructInjectionPoint, "PostConstruct", methods, typeName);
		var i : Int = 0;
		var length : Int = injectionPoints.length;
		while(i < length) {
			description.addInjectionPoint(injectionPoints[i]);
			i++;
		}
	}

	function addPreDestroyMethodPoints(description : TypeDescription, methods : Array<Dynamic>, typeName : String) : Void {
		var injectionPoints : Array<Dynamic> = gatherOrderedInjectionPointsForTag(PreDestroyInjectionPoint, "PreDestroy", methods, typeName);
		if(!injectionPoints.length)  {
			return;
		}
		description.preDestroyMethods = injectionPoints[0];
		description.preDestroyMethods.last = injectionPoints[0];
		var i : Int = 1;
		var length : Int = injectionPoints.length;
		while(i < length) {
			description.preDestroyMethods.last.next = injectionPoints[i];
			description.preDestroyMethods.last = injectionPoints[i];
			i++;
		}
	}

	function addFieldInjectionPoints(description : TypeDescription, fields : Array<Dynamic>) : Void {
		if(fields == null)  {
			return;
		}
		var length : Int = fields.length;
		var i : Int = 0;
		while(i < length) {
			var field : Dynamic = fields[i];
			var injectParameters : Dictionary = extractTagParameters("Inject", field.metadata);
			if(injectParameters == null)  {
				 {
					i++;
					continue;
				}

			}
			var mappingName : String = injectParameters.name || "";
			var optional : Bool = injectParameters.optional == "true";
			var injectionPoint : PropertyInjectionPoint = new PropertyInjectionPoint(field.type + "|" + mappingName, field.name, optional, injectParameters);
			description.addInjectionPoint(injectionPoint);
			i++;
		}
	}

	function gatherMethodParameters(parameters : Array<Dynamic>, parameterNames : Array<Dynamic>, typeName : String) : Int {
		var requiredLength : Int = 0;
		var length : Int = parameters.length;
		var i : Int = 0;
		while(i < length) {
			var parameter : Dynamic = parameters[i];
			var injectionName : String = parameterNames[i] || "";
			var parameterTypeName : String = parameter.type;
			if(parameterTypeName == "*")  {
				if(!parameter.optional)  {
					throw new InjectorError("Error in method definition of injectee \"" + typeName + ". Required parameters can\'t have type \"*\".");
				}

				else  {
					parameterTypeName = null;
				}

			}
			if(!parameter.optional)  {
				requiredLength++;
			}
			parameters[i] = parameterTypeName + "|" + injectionName;
			i++;
		}
		return requiredLength;
	}

	function gatherOrderedInjectionPointsForTag(injectionPointClass : Class<Dynamic>, tag : String, methods : Array<Dynamic>, typeName : String) : Array<Dynamic> {
		var injectionPoints : Array<Dynamic> = [];
		if(methods == null)  {
			return injectionPoints;
		}
		var length : Int = methods.length;
		var i : Int = 0;
		while(i < length) {
			var method : Dynamic = methods[i];
			var injectParameters : Dynamic = extractTagParameters(tag, method.metadata);
			if(!injectParameters)  {
				 {
					i++;
					continue;
				}

			}
			var parameterNames : Array<Dynamic> = (injectParameters.name || "").split(",");
			var parameters : Array<Dynamic> = method.parameters;
			var requiredParameters : Int;
			if(parameters != null)  {
				requiredParameters = gatherMethodParameters(parameters, parameterNames, typeName);
			}

			else  {
				parameters = [];
				requiredParameters = 0;
			}

			var order : Int = parseInt(injectParameters.order, 10);
			//int can't be NaN, so we have to verify that parsing succeeded by comparison
			if(order.toString(10) != injectParameters.order)  {
				order = int.MAX_VALUE;
			}
;
			injectionPoints.push(Type.createInstance(injectionPointClass, [method.name, parameters, requiredParameters, order]));
			i++;
		}
		if(injectionPoints.length > 0)  {
			injectionPoints.sortOn("order", Array.NUMERIC);
		}
		return injectionPoints;
	}

	function extractTagParameters(tag : String, metadata : Array<Dynamic>) : Dictionary {
		var length : Int = (metadata) ? metadata.length : 0;
		var i : Int = 0;
		while(i < length) {
			var entry : Dynamic = metadata[i];
			if(entry.name == tag)  {
				var parametersList : Array<Dynamic> = entry.value;
				var parametersMap : Dictionary = new Dictionary();
				var parametersCount : Int = parametersList.length;
				var j : Int = 0;
				while(j < parametersCount) {
					var parameter : Dynamic = parametersList[j];
					parametersMap[parameter.key] = (parametersMap[parameter.key]) ? parametersMap[parameter.key] + "," + parameter.value : parameter.value;
					j++;
				}
				return parametersMap;
			}
			i++;
		}
		return null;
	}


	public function new() {
		_descriptor = new DescribeTypeJSON();
	}
}

