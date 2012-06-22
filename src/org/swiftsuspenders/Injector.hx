/*
 * Copyright (c) 2012 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */
package org.swiftsuspenders;

import flash.events.EventDispatcher;
import flash.system.ApplicationDomain;
import flash.utils.Dictionary;
import org.swiftsuspenders.dependencyproviders.ClassProvider;
import org.swiftsuspenders.dependencyproviders.DependencyProvider;
import org.swiftsuspenders.dependencyproviders.LocalOnlyProvider;
import org.swiftsuspenders.dependencyproviders.SoftDependencyProvider;
import org.swiftsuspenders.haxe.Error;
import org.swiftsuspenders.typedescriptions.InjectionPoint;
import org.swiftsuspenders.typedescriptions.TypeDescription;
import org.swiftsuspenders.utils.TypeDescriptor;

/**
 * This event is dispatched each time the injector instantiated a class
 *
 * <p>At the point where the event is dispatched none of the injection points have been processed.</p>
 *
 * <p>The only difference to the <code>PRE_CONSTRUCT</code> event is that
 * <code>POST_INSTANTIATE</code> is only dispatched for instances that are created in the
 * injector, whereas <code>PRE_CONSTRUCT</code> is also dispatched for instances the injector
 * only injects into.</p>
 *
 * <p>This event is only dispatched if there are one or more relevant listeners attached to
 * the dispatching injector.</p>
 *
 * @eventType org.swiftsuspenders.InjectionEvent.POST_INSTANTIATE
 */@:meta(Event(name="postInstantiate",type="org.swiftsuspenders.InjectionEvent"))
/**
 * This event is dispatched each time the injector is about to inject into a class
 *
 * <p>At the point where the event is dispatched none of the injection points have been processed.</p>
 *
 * <p>The only difference to the <code>POST_INSTANTIATE</code> event is that
 * <code>PRE_CONSTRUCT</code> is only dispatched for instances that are created in the
 * injector, whereas <code>POST_INSTANTIATE</code> is also dispatched for instances the
 * injector only injects into.</p>
 *
 * <p>This event is only dispatched if there are one or more relevant listeners attached to
 * the dispatching injector.</p>
 *
 * @eventType org.swiftsuspenders.InjectionEvent.PRE_CONSTRUCT
 */@:meta(Event(name="preConstruct",type="org.swiftsuspenders.InjectionEvent"))
/**
 * This event is dispatched each time the injector created and fully initialized a new instance
 *
 * <p>At the point where the event is dispatched all dependencies for the newly created instance
 * have already been injected. That means that creation-events for leaf nodes of the created
 * object graph will be dispatched before the creation-events for the branches they are
 * injected into.</p>
 *
 * <p>The newly created instance's [PostConstruct]-annotated methods will also have run already.</p>
 *
 * <p>This event is only dispatched if there are one or more relevant listeners attached to
 * the dispatching injector.</p>
 *
 * @eventType org.swiftsuspenders.InjectionEvent.POST_CONSTRUCT
 */@:meta(Event(name="postConstruct",type="org.swiftsuspenders.InjectionEvent"))
/**
 * This event is dispatched each time the injector creates a new mapping for a type/ name
 * combination, right before the mapping is created
 *
 * <p>At the point where the event is dispatched the mapping hasn't yet been created. Thus, the
 * respective field in the event is null.</p>
 *
 * <p>This event is only dispatched if there are one or more relevant listeners attached to
 * the dispatching injector.</p>
 *
 * @eventType org.swiftsuspenders.MappingEvent.PRE_MAPPING_CREATE
 */@:meta(Event(name="preMappingCreate",type="org.swiftsuspenders.MappingEvent"))
/**
 * This event is dispatched each time the injector creates a new mapping for a type/ name
 * combination, right after the mapping was created
 *
 * <p>At the point where the event is dispatched the mapping has already been created and stored
 * in the injector's lookup table.</p>
 *
 * <p>This event is only dispatched if there are one or more relevant listeners attached to
 * the dispatching injector.</p>
 *
 * @eventType org.swiftsuspenders.MappingEvent.POST_MAPPING_CREATE
 */@:meta(Event(name="postMappingCreate",type="org.swiftsuspenders.MappingEvent"))
/**
 * This event is dispatched each time an injector mapping is changed in any way, right before
 * the change is applied.
 *
 * <p>At the point where the event is dispatched the changes haven't yet been applied, meaning the
 * mapping stored in the event can be queried for its pre-change state.</p>
 *
 * <p>This event is only dispatched if there are one or more relevant listeners attached to 
 * the dispatching injector.</p>
 *
 * @eventType org.swiftsuspenders.MappingEvent.PRE_MAPPING_CHANGE
 */@:meta(Event(name="preMappingChange",type="org.swiftsuspenders.MappingEvent"))
/**
 * This event is dispatched each time an injector mapping is changed in any way, right after
 * the change is applied.
 *
 * <p>At the point where the event is dispatched the changes have already been applied, meaning
 * the mapping stored in the event can be queried for its post-change state</p>
 *
 * <p>This event is only dispatched if there are one or more relevant listeners attached to 
 * the dispatching injector.</p>
 *
 * @eventType org.swiftsuspenders.MappingEvent.POST_MAPPING_CHANGE
 */@:meta(Event(name="postMappingChange",type="org.swiftsuspenders.MappingEvent"))
/**
 * This event is dispatched each time an injector mapping is removed, right after
 * the mapping is deleted from the configuration.
 *
 * <p>At the point where the event is dispatched the changes have already been applied, meaning
 * the mapping is lost to the injector and can't be queried anymore.</p>
 *
 * <p>This event is only dispatched if there are one or more relevant listeners attached to 
 * the dispatching injector.</p>
 *
 * @eventType org.swiftsuspenders.MappingEvent.POST_MAPPING_REMOVE
 */@:meta(Event(name="postMappingRemove",type="org.swiftsuspenders.MappingEvent"))
/**
 * This event is dispatched if an existing mapping is overridden without first unmapping it.
 *
 * <p>The reason for dispatching an event (and tracing a warning) is that in most cases,
 * overriding existing mappings is a sign of bugs in the application. Deliberate mapping
 * changes should be done by first removing the existing mapping.</p>
 *
 * <p>This event is only dispatched if there are one or more relevant listeners attached to 
 * the dispatching injector.</p>
 *
 * @eventType org.swiftsuspenders.MappingEvent.POST_MAPPING_REMOVE
 */@:meta(Event(name="mappingOverride",type="org.swiftsuspenders.MappingEvent"))

 /**
 * The <code>Injector</code> manages the mappings and acts as the central hub from which all
 * injections are started.
 */
 class Injector extends EventDispatcher 
 {
	public var parentInjector(getParentInjector, setParentInjector) : Injector;
	//public var applicationDomain(getApplicationDomain, setApplicationDomain) : ApplicationDomain;

	//----------------------       Private / Protected Properties       ----------------------//
	static var INJECTION_POINTS_CACHE = new Hash<TypeDescription>();
	private var _parentInjector : Injector;
	//var _applicationDomain : ApplicationDomain;
	var _classDescriptor : TypeDescriptor;
	private var _mappings : Hash<InjectionMapping>;
	private var _defaultProviders : Hash<DependencyProvider>;
	private var _mappingsInProcess : Hash<Bool>;
	private var _reflector : Reflector;
	//----------------------            Internal Properties             ----------------------//
	public var providerMappings : Hash<DependencyProvider>;
	//----------------------               Public Methods               ----------------------//
		public function new() {
		providerMappings = new Hash<DependencyProvider>();
		_defaultProviders = new Hash<DependencyProvider>();
		_mappings = new Hash<InjectionMapping>();
		_mappingsInProcess = new Hash<Bool>();
		try {
			//_reflector = (DescribeTypeJSON.available) ? new DescribeTypeJSONReflector() : new DescribeTypeReflector();
			_reflector = new HaxeReflector();
		}
		catch(e : Error) {
			_reflector = new HaxeReflector();
		}

		_classDescriptor = new TypeDescriptor(_reflector, INJECTION_POINTS_CACHE);
		//_applicationDomain = ApplicationDomain.currentDomain;
		super();
	}

	/**
	 * Maps a request description, consisting of the <code>type</code> and, optionally, the
	 * <code>name</code>.
	 *
	 * <p>The returned mapping is created if it didn't exist yet or simply returned otherwise.</p>
	 *
	 * <p>Named mappings should be used as sparingly as possible as they increase the likelyhood
	 * of typing errors to cause hard to debug errors at runtime.</p>
	 *
	 * @param type The <code>class</code> describing the mapping
	 * @param name The name, as a case-sensitive string, to further describe the mapping
	 *
	 * @return The <code>InjectionMapping</code> for the given request description
	 *
	 * @see #unmap()
	 * @see InjectionMapping
	 */	
	public function map(type : Class<Dynamic>, name : String = "") : InjectionMapping 
	{
		var mappingId : String = Type.getClassName(type) + "|" + name;
		var map = _mappings.get(mappingId);
		if (map==null) _mappings.set(mappingId, map = createMapping(type, name, mappingId));
		return map;
	}

	/**
	 *  Removes the mapping described by the given <code>type</code> and <code>name</code>.
	 *
	 * @param type The <code>class</code> describing the mapping
	 * @param name The name, as a case-sensitive string, to further describe the mapping
	 *
	 * @throws org.swiftsuspenders.InjectorError Descriptions that are not mapped can't be unmapped
	 * @throws org.swiftsuspenders.InjectorError Sealed mappings have to be unsealed before unmapping them
	 *
	 * @see #map()
	 * @see InjectionMapping
	 * @see InjectionMapping#unseal()
	 */	
	public function unmap(type : Class<Dynamic>, name : String = "") : Void {
		var mappingId : String = Type.getClassName(type) + "|" + name;
		var mapping : InjectionMapping = _mappings.get(mappingId);
		if(mapping != null && mapping.isSealed)  {
			throw new InjectorError("Can\'t unmap a sealed mapping");
		}
		if(mapping == null)  {
			throw new InjectorError("Error while removing an injector mapping: " + "No mapping defined for dependency " + mappingId);
		}

		_mappings.remove(mappingId);
		providerMappings.remove(mappingId);

		hasEventListener(MappingEvent.POST_MAPPING_REMOVE) && dispatchEvent(new MappingEvent(MappingEvent.POST_MAPPING_REMOVE, type, name, null));
	}

	/**
	 * Indicates whether the injector can supply a response for the specified dependency either
	 * by using a mapping of its own or by querying one of its ancestor injectors.
	 *
	 * @param type The dependency under query
	 *
	 * @return <code>true</code> if the dependency can be satisfied, <code>false</code> if not
	 */	
	public function satisfies(type : Class<Dynamic>, name : String = "") : Bool {
		return getProvider(Type.getClassName(type) + "|" + name) != null;
	}

	/**
	 * Indicates whether the injector can directly supply a response for the specified
	 * dependency.
	 *
	 * <p>In contrast to <code>#satisfies()</code>, <code>satisfiesDirectly</code> only informs
	 * about mappings on this injector itself, without querying its ancestor injectors.</p>
	 *
	 * @param type The dependency under query
	 *
	 * @return <code>true</code> if the dependency can be satisfied, <code>false</code> if not
	 */	
	//public function satisfiesDirectly(type : Class<Dynamic>, name : String = "") : Bool {
		//return providerMappings[Type.getClassName(type) + "|" + name] != null;
	//}

	/**
	 * Returns the mapping for the specified dependency class
	 *
	 * <p>Note that getMapping will only return mappings in exactly this injector, not ones
	 * mapped in an ancestor injector. To get mappings from ancestor injectors, query them 
	 * using <code>parentInjector</code>.
	 * This restriction is in place to prevent accidential changing of mappings in ancestor
	 * injectors where only the child's response is meant to be altered.</p>
	 * 
	 * @param type The dependency to return the mapping for
	 * 
	 * @return The mapping for the specified dependency class
	 * 
	 * @throws InjectorError When no mapping was found for the specified dependency
	 */	
	//public function getMapping(type : Class<Dynamic>, name : String = "") : InjectionMapping {
		//var mappingId : String = Type.getClassName(type) + "|" + name;
		//var mapping : InjectionMapping = Reflect.field(_mappings, mappingId);
		//if(mapping == null)  {
			//throw new InjectorError("Error while retrieving an injector mapping: " + "No mapping defined for dependency " + mappingId);
		//}
		//return mapping;
	//}

	/**
	 * Inspects the given object and injects into all injection points configured for its class.
	 *
	 * @param target The instance to inject into
	 *
	 * @throws org.swiftsuspenders.InjectorError The <code>Injector</code> must have mappings for all injection points
	 *
	 * @see #map()
	 */	
	public function injectInto(target : Dynamic) : Void 
	{
		var type : Class<Dynamic> = _reflector.getClass(target);	
		var description = _classDescriptor.getDescription(type);
		applyInjectionPoints(target, type, description.injectionPoints);
	}

	/**
	 * Instantiates the class identified by the given <code>type</code> and <code>name</code>.
	 *
	 * <p>If no <code>InjectionMapping</code> is found for the given <code>type</code> and no
	 * <code>name</code> is given, the class is simply instantiated and then injected into.</p>
	 *
	 * <p>The parameter <code>targetType</code> is only useful if the
	 * <code>InjectionMapping</code> used to satisfy the request might vary its result based on
	 * that <code>targetType</code>. An Example of that would be a provider returning a logger
	 * instance pre-configured for the instance it is used in.</p>
	 *
	 * @param type The <code>class</code> describing the mapping
	 * @param name The name, as a case-sensitive string, to use for mapping resolution
	 * @param targetType The type of the instance that is dependent on the returned value
	 *
	 * @return The created instance
	 */	
	public function getInstance(type : Class<Dynamic>, name : String = "", targetType : Class<Dynamic> = null) : Dynamic {
		var mappingId : String = Type.getClassName(type) + "|" + name;
		var provider : DependencyProvider = getProvider(mappingId);
		if(provider != null)  {
			var ctor = _classDescriptor.getDescription(type).ctor;
			return provider.apply(targetType, this, ctor!=null ? ctor.injectParameters : null);
		}
		if(name != null)  {
			throw new InjectorError("No mapping found for request " + mappingId + ". getInstance only creates an unmapped instance if no name is given.");
		}
		return instantiateUnmapped(type);
	}

	/**
	 * Creates a new <code>Injector</code> and sets itself as that new <code>Injector</code>'s
	 * <code>parentInjector</code>.
	 *
	 * @param applicationDomain The optional domain to use in the new Injector.
	 * If not given, the creating injector's domain is set on the new Injector as well.
	 * @return The newly created <code>Injector</code> instance
	 *
	 * @see #parentInjector
	 */	
	//public function createChildInjector(applicationDomain : ApplicationDomain = null) : Injector {
		//var injector : Injector = new Injector();
		//injector.applicationDomain = applicationDomain || this.applicationDomain;
		//injector.parentInjector = this;
		//return injector;
	//}

	/**
	 * Sets the <code>Injector</code> to ask in case the current <code>Injector</code> doesn't
	 * have a mapping for a dependency.
	 *
	 * <p>Parent Injectors can be nested in arbitrary depths with very little overhead,
	 * enabling very modular setups for the managed object graphs.</p>
	 *
	 * @param parentInjector The <code>Injector</code> to use for dependencies the current
	 * <code>Injector</code> can't supply
	 */	
	public function setParentInjector(parentInjector : Injector) : Injector {
		_parentInjector = parentInjector;
		return parentInjector;
	}

	/**
	 * Returns the <code>Injector</code> used for dependencies the current
	 * <code>Injector</code> can't supply
	 */	
	public function getParentInjector() : Injector {
		return _parentInjector;
	}

	//public function setApplicationDomain(applicationDomain : ApplicationDomain) : ApplicationDomain {
		//_applicationDomain = applicationDomain || ApplicationDomain.currentDomain;
		//return applicationDomain;
	//}
//
	//public function getApplicationDomain() : ApplicationDomain {
		//return _applicationDomain;
	//}
//
	//public function addTypeDescription(type : Class<Dynamic>, description : TypeDescription) : Void {
		//_classDescriptor.addDescription(type, description);
	//}

	//----------------------             Internal Methods               ----------------------//
		
	public static function purgeInjectionPointsCache() : Void {
		//INJECTION_POINTS_CACHE = new Dictionary(true);
	}

	public function instantiateUnmapped(type : Class<Dynamic>) : Dynamic {
		var description = _classDescriptor.getDescription(type);
		if(description.ctor==null)  {
			throw new InjectorError("Can't instantiate interface " + Type.getClassName(type));
		}
		var instance = description.ctor.createInstance(type, this);
		hasEventListener(InjectionEvent.POST_INSTANTIATE) && dispatchEvent(new InjectionEvent(InjectionEvent.POST_INSTANTIATE, instance, type));
		applyInjectionPoints(instance, type, description.injectionPoints);
		return instance;
		return null;
	}

	public function getProvider(mappingId : String, fallbackToDefault : Bool = true) : DependencyProvider 
	{
		var softProvider : DependencyProvider=null;
		var injector : Injector = this;
		while(injector!=null) {
			var provider : DependencyProvider = injector.providerMappings.get(mappingId);
			if(provider != null)  {
				if(Std.is(provider, SoftDependencyProvider))  {
					softProvider = provider;
					injector = injector.parentInjector;
					continue;
				}
				if(Std.is(provider, LocalOnlyProvider) && injector != this)  {
					injector = injector.parentInjector;
					continue;
				}
				return provider;
			}
			injector = injector.parentInjector;
		}
		
		if (softProvider!=null)
		{
			return softProvider;
		}
		
		return fallbackToDefault ? getDefaultProvider(mappingId) : null;		
	}
	
	private function getDefaultProvider(mappingId : String) : DependencyProvider
	{
		//No meaningful way to automatically create Strings
		if (mappingId == 'String|')
		{
			return null;
		}
		var parts = mappingId.split('|');
		var name = parts.pop();
		if (name.length != 0)
		{
			return null;
		}
		var typeName = parts.pop();
		var definition : Class<Dynamic> = null;
		try
		{
			
			definition = Type.resolveClass(typeName);
			
			//var definition = _applicationDomain.hasDefinition(typeName)
				//? _applicationDomain.getDefinition(typeName)
				//: getDefinitionByName(typeName);
		}
		catch (e : Error)
		{
			return null;
		}
		
		if (definition==null || !Std.is(definition, Class)) // !Std.is(definition, Class<Dynamic>) 
		{
			return null;
		}
		var type = definition;
		var description = _classDescriptor.getDescription(type);
		if (description.ctor == null)
		{
			return null;
		}

		if (_defaultProviders.get(Type.getClassName(type)) != null) return _defaultProviders.get(Type.getClassName(type));
		var c = new ClassProvider(type);
		_defaultProviders.set(Type.getClassName(type), c);
		return c;
	}

	//----------------------         Private / Protected Methods        ----------------------//
		
	public function createMapping(type : Class<Dynamic>, name : String, mappingId : String) : InjectionMapping 
	{		
		if(Reflect.field(_mappingsInProcess, mappingId))  {
			throw new InjectorError("Can\'t change a mapping from inside a listener to it\'s creation event");
		}
		_mappingsInProcess.set(mappingId, true);

		hasEventListener(MappingEvent.PRE_MAPPING_CREATE) && dispatchEvent(new MappingEvent(MappingEvent.PRE_MAPPING_CREATE, type, name, null));
		var mapping = new InjectionMapping(this, type, name, mappingId);		
		_mappings.set(mappingId, mapping);

		var sealKey : Dynamic = mapping.seal();
		hasEventListener(MappingEvent.POST_MAPPING_CREATE) && dispatchEvent(new MappingEvent(MappingEvent.POST_MAPPING_CREATE, type, name, mapping));
		
		_mappingsInProcess.remove(mappingId);	
		mapping.unseal(sealKey);
		return mapping;
	}	

	public function applyInjectionPoints(target : Dynamic, targetType : Class<Dynamic>, injectionPoint : InjectionPoint) : Void {
		hasEventListener(InjectionEvent.PRE_CONSTRUCT) && dispatchEvent(new InjectionEvent(InjectionEvent.PRE_CONSTRUCT, target, targetType));
		while(injectionPoint!=null) {
			injectionPoint.applyInjection(target, targetType, this);
			injectionPoint = injectionPoint.next;
		}

		hasEventListener(InjectionEvent.POST_CONSTRUCT) && dispatchEvent(new InjectionEvent(InjectionEvent.POST_CONSTRUCT, target, targetType));
	}

}

