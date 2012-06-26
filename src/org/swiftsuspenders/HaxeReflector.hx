package org.swiftsuspenders;
import haxe.rtti.Meta;
import org.swiftsuspenders.haxe.Error;
import org.swiftsuspenders.typedescriptions.ConstructorInjectionPoint;
import org.swiftsuspenders.typedescriptions.InjectionPoint;
import org.swiftsuspenders.typedescriptions.MethodInjectionPoint;
import org.swiftsuspenders.typedescriptions.NoParamsConstructorInjectionPoint;
import org.swiftsuspenders.typedescriptions.PostConstructInjectionPoint;
import org.swiftsuspenders.typedescriptions.PropertyInjectionPoint;
import org.swiftsuspenders.typedescriptions.TypeDescription;

/**
 * ...
 * @author Mike Cann
 */

class HaxeReflector extends ReflectorBase, implements Reflector
{
	public function typeImplements(type : Class<Dynamic>, superType : Class<Dynamic>) : Bool 
	{
		//if(type == superType)  {
			//return true;
		//}
		//var superClassName : String = Type.getClassName(superType);
		//var traits : Dynamic = _descriptor.getInstanceDescription(type).traits;
		//return (try cast(traits.bases, Array) catch(e:Dynamic) null).indexOf(superClassName) > -1 || (try cast(traits.interfaces, Array) catch(e:Dynamic) null).indexOf(superClassName) > -1;
		
		throw new Error("typeImplements NOT IMPLEMENTED");		
		return false;
	}

	public function describeInjections(type : Class<Dynamic>) : TypeDescription 
	{		
		var description = new TypeDescription(false);
		
		var typeMeta = Meta.getType(type);				
		var fieldsMeta = getFields(type);
				
		for (field in Reflect.fields(fieldsMeta))
		{
			var fieldMeta:Dynamic = Reflect.field(fieldsMeta, field);
			
			var hasInject = Reflect.hasField(fieldMeta, "Inject");
			var hasPostconstruct = Reflect.hasField(fieldMeta, "PostConstruct");
			var args = Reflect.field(fieldMeta, "args");
			
			if (field == "_") // constructor
			{
				if (args.length == 0)
				{
					description.ctor = new NoParamsConstructorInjectionPoint();
				}
				else
				{
					
					//var parameters : Array<Dynamic> = traits.constructor;
					//if(parameters == null)  {
						//description.ctor = traits.bases.length > (0) ? new NoParamsConstructorInjectionPoint() : null;
						//return;
					//}
					//var injectParameters : Dictionary = extractTagParameters("Inject", traits.metadata);
					//var parameterNames : Array<Dynamic> = (injectParameters && injectParameters.name || "").split(",");
					//var requiredParameters : Int = gatherMethodParameters(parameters, parameterNames, typeName);
					//description.ctor = new ConstructorInjectionPoint(parameters, requiredParameters, injectParameters);
					
					//var injectParameters : Dictionary = extractTagParameters("Inject", traits.metadata);
					//var parameterNames : Array<Dynamic> = (injectParameters && injectParameters.name || "").split(",");
					//var requiredParameters : Int = gatherMethodParameters(parameters, parameterNames, typeName);
					
					var parameters : Array<String> = [];
					var requiredParameters : Int = gatherMethodParameters(fieldMeta,parameters);
					description.ctor = new ConstructorInjectionPoint(parameters, requiredParameters, null);
				}				
			}
			else if (Reflect.hasField(fieldMeta, "args")) // method
			{
				if (hasInject) // injection
				{
					//var injectParameters : Dictionary = extractTagParameters("Inject", method.metadata);
					//var optional : Bool = injectParameters.optional == "true";
					
					//var parameterNames : Array<Dynamic> = (injectParameters.name || "").split(",");
					var parameters : Array<String> = [];
					var requiredParameters : Int = gatherMethodParameters(fieldMeta,parameters);
					
					var injectionPoint = new MethodInjectionPoint(fieldMeta.name[0], parameters, requiredParameters, false, null);
					description.addInjectionPoint(injectionPoint);
					
					
					//var injectionPoint = new MethodInjectionPoint(fieldMeta, this);
					//description.addInjectionPoint(injectionPoint);
				}
				else if (hasPostconstruct) // post construction
				{
					var parameters : Array<String> = [];
					var requiredParameters : Int = gatherMethodParameters(fieldMeta,parameters);
					
					var injectionPoint = new PostConstructInjectionPoint(fieldMeta.name[0], parameters, requiredParameters, 0);
					description.addInjectionPoint(injectionPoint);
				}
			}
			else if (type != null && hasInject) // property
			{				
				var type = fieldMeta.type;			
				var injectionPointName = fieldMeta.Inject!=null ? fieldMeta.Inject[0] : "";
				var injectionPoint = new PropertyInjectionPoint(fieldMeta.type + "|" + injectionPointName, field, false, null);
				description.addInjectionPoint(injectionPoint);
			}
			
			//var post = Reflect.hasField(fieldMeta, "post");
			//var type = Reflect.field(fieldMeta, "type");
			//var args = Reflect.field(fieldMeta, "args");	
		}	
				
		
		if(description.ctor==null && !Reflect.hasField(typeMeta, "interface")) description.ctor = new NoParamsConstructorInjectionPoint();
		
		//addCtorInjectionPoint(description, type);		
		//addFieldInjectionPoints(description, type);
		//addMethodInjectionPoints(description, traits.methods, typeName);
		//addPostConstructMethodPoints(description, traits.variables, typeName);
		//addPostConstructMethodPoints(description, traits.accessors, typeName);
		//addPostConstructMethodPoints(description, traits.methods, typeName);
		//addPreDestroyMethodPoints(description, traits.methods, typeName);				
			
		
		return description;
	}		
	
	function getFields(type:Class<Dynamic>)
	{
		var meta = {};

		while (type != null)
		{
			var typeMeta = Meta.getFields(type);
			for (field in Reflect.fields(typeMeta))
			{
				Reflect.setField(meta, field, Reflect.field(typeMeta, field));
			}

			type = Type.getSuperClass(type);
		}

		return meta;
	}

	//----------------------         Private / Protected Methods        ----------------------//
	function addCtorInjectionPoint(description : TypeDescription, traits : Dynamic, typeName : String) : Void 
	{
		//var parameters : Array<Dynamic> = traits.constructor;
		//if(parameters == null)  {
			//description.ctor = traits.bases.length > (0) ? new NoParamsConstructorInjectionPoint() : null;
			//return;
		//}
		//var injectParameters : Dictionary = extractTagParameters("Inject", traits.metadata);
		//var parameterNames : Array<Dynamic> = (injectParameters && injectParameters.name || "").split(",");
		//var requiredParameters : Int = gatherMethodParameters(parameters, parameterNames, typeName);
		//description.ctor = new ConstructorInjectionPoint(parameters, requiredParameters, injectParameters);
		
		throw new Error("addCtorInjectionPoint NOT IMPLEMENTED");
	}

	function addMethodInjectionPoints(description : TypeDescription, methods : Array<Dynamic>, typeName : String) : Void {
		//if(methods == null)  {
			//return;
		//}
		//var length : Int = methods.length;
		//var i : Int = 0;
		//while(i < length) {
			//var method : Dynamic = methods[i];
			//var injectParameters : Dictionary = extractTagParameters("Inject", method.metadata);
			//if(injectParameters == null)  {
				 //{
					//i++;
					//continue;
				//}
//
			//}
			//var optional : Bool = injectParameters.optional == "true";
			//var parameterNames : Array<Dynamic> = (injectParameters.name || "").split(",");
			//var parameters : Array<Dynamic> = method.parameters;
			//var requiredParameters : Int = gatherMethodParameters(parameters, parameterNames, typeName);
			//var injectionPoint : MethodInjectionPoint = new MethodInjectionPoint(method.name, parameters, requiredParameters, optional, injectParameters);
			//description.addInjectionPoint(injectionPoint);
			//i++;
		//}
		
		throw new Error("addMethodInjectionPoints NOT IMPLEMENTED");
	}

	function addPostConstructMethodPoints(description : TypeDescription, methods : Array<Dynamic>, typeName : String) : Void {
		//var injectionPoints : Array<Dynamic> = gatherOrderedInjectionPointsForTag(PostConstructInjectionPoint, "PostConstruct", methods, typeName);
		//var i : Int = 0;
		//var length : Int = injectionPoints.length;
		//while(i < length) {
			//description.addInjectionPoint(injectionPoints[i]);
			//i++;
		//}
		throw new Error("addPostConstructMethodPoints NOT IMPLEMENTED");
	}

	function addPreDestroyMethodPoints(description : TypeDescription, methods : Array<Dynamic>, typeName : String) : Void {
		//var injectionPoints : Array<Dynamic> = gatherOrderedInjectionPointsForTag(PreDestroyInjectionPoint, "PreDestroy", methods, typeName);
		//if(!injectionPoints.length)  {
			//return;
		//}
		//description.preDestroyMethods = injectionPoints[0];
		//description.preDestroyMethods.last = injectionPoints[0];
		//var i : Int = 1;
		//var length : Int = injectionPoints.length;
		//while(i < length) {
			//description.preDestroyMethods.last.next = injectionPoints[i];
			//description.preDestroyMethods.last = injectionPoints[i];
			//i++;
		//}
		
		throw new Error("addPreDestroyMethodPoints NOT IMPLEMENTED");
	}

	private function addFieldInjectionPoints(description : TypeDescription, type : Class<Dynamic>) : Void 
	{
		//var typeMeta = Meta.getType(type);		
		//if (typeMeta != null && Reflect.hasField(typeMeta, "interface"))
		//{
			//throw new InjectorError("Interfaces can't be used as instantiatable classes.");
		//}
		//var fieldsMeta = getFields(type);
				//
		//for (field in Reflect.fields(fieldsMeta))
		//{
			//var fieldMeta:Dynamic = Reflect.field(fieldsMeta, field);
//
			//if (Reflect.hasField(fieldMeta, "Inject"))
			//{			
				//var type = fieldMeta.type;			
				//var injectionPointName = fieldMeta.Inject!=null ? fieldMeta.Inject[0] : "";
				//var injectionPoint = new PropertyInjectionPoint(fieldMeta.type + "|" + injectionPointName, field, false, null);
				//description.addInjectionPoint(injectionPoint);
			//}
			//
			//var post = Reflect.hasField(fieldMeta, "post");
			//var type = Reflect.field(fieldMeta, "type");
			//var args = Reflect.field(fieldMeta, "args");
//
		//
		//}		
	}

	function gatherMethodParameters(meta:Dynamic, parameters:Array<String>):Int
	{
		var nameArgs = meta.Inject;
		var args:Array<Dynamic> = meta.args;
		var requiredParameters = 0;

		if (nameArgs == null) nameArgs = [];

		var i = 0;
		
		if (args != null)
		{
			for (arg in args)
			{
				var injectionName = "";

				if (i < nameArgs.length)
				{
					injectionName = nameArgs[i];
				}

				var parameterTypeName = arg.type;

				if (arg.opt)
				{
					if (parameterTypeName == "Dynamic")
					{
						//TODO: Find a way to trace name of affected class here
						throw new InjectorError('Error in method definition of injectee. Required parameters can\'t have non class type.');
					}
				}
				else
				{
					requiredParameters++;
				}
				
				parameters.push(parameterTypeName + "|" + injectionName); //_parameterInjectionConfigs.push(new ParameterInjectionConfig(parameterTypeName, injectionName));
				i++;
			}
		}
		
		return requiredParameters;
	}

	function gatherOrderedInjectionPointsForTag(injectionPointClass : Class<Dynamic>, tag : String, methods : Array<Dynamic>, typeName : String) : Array<Dynamic> 
	{
		//var injectionPoints : Array<Dynamic> = [];
		//if(methods == null)  {
			//return injectionPoints;
		//}
		//var length : Int = methods.length;
		//var i : Int = 0;
		//while(i < length) {
			//var method : Dynamic = methods[i];
			//var injectParameters : Dynamic = extractTagParameters(tag, method.metadata);
			//if(!injectParameters)  {
				 //{
					//i++;
					//continue;
				//}
//
			//}
			//var parameterNames : Array<Dynamic> = (injectParameters.name || "").split(",");
			//var parameters : Array<Dynamic> = method.parameters;
			//var requiredParameters : Int;
			//if(parameters != null)  {
				//requiredParameters = gatherMethodParameters(parameters, parameterNames, typeName);
			//}
//
			//else  {
				//parameters = [];
				//requiredParameters = 0;
			//}
//
			//var order : Int = parseInt(injectParameters.order, 10);
			//int can't be NaN, so we have to verify that parsing succeeded by comparison
			//if(order.toString(10) != injectParameters.order)  {
				//order = int.MAX_VALUE;
			//}
//;
			//injectionPoints.push(Type.createInstance(injectionPointClass, [method.name, parameters, requiredParameters, order]));
			//i++;
		//}
		//if(injectionPoints.length > 0)  {
			//injectionPoints.sortOn("order", Array.NUMERIC);
		//}
		//return injectionPoints;
		
		throw new Error("gatherOrderedInjectionPointsForTag NOT IMPLEMENTED");
		return null;
	}

	function extractTagParameters(tag : String, metadata : Array<Dynamic>) : Hash<String> 
	{
		//var length : Int = (metadata) ? metadata.length : 0;
		//var i : Int = 0;
		//while(i < length) {
			//var entry : Dynamic = metadata[i];
			//if(entry.name == tag)  {
				//var parametersList : Array<Dynamic> = entry.value;
				//var parametersMap : Dictionary = new Dictionary();
				//var parametersCount : Int = parametersList.length;
				//var j : Int = 0;
				//while(j < parametersCount) {
					//var parameter : Dynamic = parametersList[j];
					//parametersMap[parameter.key] = (parametersMap[parameter.key]) ? parametersMap[parameter.key] + "," + parameter.value : parameter.value;
					//j++;
				//}
				//return parametersMap;
			//}
			//i++;
		//}
		//return null;
		
		throw new Error("extractTagParameters NOT IMPLEMENTED");
		return null;
	}
	
}