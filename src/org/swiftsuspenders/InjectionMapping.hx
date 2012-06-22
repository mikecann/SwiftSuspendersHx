/*
 * Copyright (c) 2011 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */
package org.swiftsuspenders;

import org.swiftsuspenders.dependencyproviders.ClassProvider;
import org.swiftsuspenders.dependencyproviders.DependencyProvider;
import org.swiftsuspenders.dependencyproviders.ForwardingProvider;
import org.swiftsuspenders.dependencyproviders.InjectorUsingProvider;
import org.swiftsuspenders.dependencyproviders.LocalOnlyProvider;
import org.swiftsuspenders.dependencyproviders.SingletonProvider;
import org.swiftsuspenders.dependencyproviders.SoftDependencyProvider;
import org.swiftsuspenders.dependencyproviders.ValueProvider;

class InjectionMapping 
{	
	public var isSealed(getIsSealed, never) : Bool;

	//----------------------       Private / Protected Properties       ----------------------//
	
	var _type : Class<Dynamic>;
	var _name : String;
	var _mappingId : String;
	var _creatingInjector : Injector;
	var _defaultProviderSet : Bool;
	var _overridingInjector : Injector;
	var _soft : Bool;
	var _local : Bool;
	var _sealed : Bool;
	var _sealKey : Dynamic;
	
	//----------------------               Public Methods               ----------------------//		
	
	public function new(creatingInjector : Injector, type : Class<Dynamic>, name : String, mappingId : String) {
		_creatingInjector = creatingInjector;
		_type = type;
		_name = name;
		_mappingId = mappingId;
		_defaultProviderSet = true;
		mapProvider(new ClassProvider(type));
	}

	/**
	 * Makes the mapping return a lazily constructed singleton instance of the mapped type for
	 * each consecutive request.
	 *
	 * <p>Syntactic sugar method wholly equivalent to using <code>toSingleton(type)</code>.</p>
	 *
	 * @return The <code>InjectionMapping</code> the method is invoked on
	 *
	 * @throws org.swiftsuspenders.InjectorError Sealed mappings can't be changed in any way
	 *
	 * @see #toSingleton()
	 */	
	public function asSingleton() : InjectionMapping {
		toSingleton(_type);
		return this;
	}

	/**
	 * Makes the mapping return a newly created instance of the given <code>type</code> for
	 * each consecutive request.
	 *
	 * <p>Syntactic sugar method wholly equivalent to using
	 * <code>toProvider(new ClassProvider(type))</code>.</p>
	 *
	 * @param type The <code>class</code> to instantiate upon each request
	 *
	 * @return The <code>InjectionMapping</code> the method is invoked on
	 *
	 * @throws org.swiftsuspenders.InjectorError Sealed mappings can't be changed in any way
	 *
	 * @see #toProvider()
	 */	
	public function toType(type : Class<Dynamic>) : InjectionMapping {
		toProvider(new ClassProvider(type));
		return this;
	}

	/**
	 * Makes the mapping return a lazily constructed singleton instance of the mapped type for
	 * each consecutive request.
	 *
	 * <p>Syntactic sugar method wholly equivalent to using
	 * <code>toProvider(new SingletonProvider(type, injector))</code>, where
	 * <code>injector</code> denotes the Injector that should manage the singleton.</p>
	 *
	 * @param type The <code>class</code> to instantiate upon each request
	 *
	 * @return The <code>InjectionMapping</code> the method is invoked on
	 *
	 * @throws org.swiftsuspenders.InjectorError Sealed mappings can't be changed in any way
	 *
	 * @see #toProvider()
	 */	
	public function toSingleton(type : Class<Dynamic>) : InjectionMapping {
		toProvider(new SingletonProvider(type, _creatingInjector));
		return this;
	}

	/**
	 * Makes the mapping return the given value for each consecutive request.
	 *
	 * <p>Syntactic sugar method wholly equivalent to using
	 * <code>toProvider(new ValueProvider(value))</code>.</p>
	 *
	 * @param value The instance to return upon each request
	 *
	 * @return The <code>InjectionMapping</code> the method is invoked on
	 *
	 * @throws org.swiftsuspenders.InjectorError Sealed mappings can't be changed in any way
	 *
	 * @see #toProvider()
	 */	
	public function toValue(value : Dynamic) : InjectionMapping {
		toProvider(new ValueProvider(value));
		return this;
	}

	/**
	 * Makes the mapping apply the given <code>DependencyProvider</code> and return the
	 * resulting value for each consecutive request.
	 *
	 * @param provider The <code>DependencyProvider</code> to use for fulfilling requests
	 *
	 * @return The <code>InjectionMapping</code> the method is invoked on
	 *
	 * @throws org.swiftsuspenders.InjectorError Sealed mappings can't be changed in any way
	 */	
	public function toProvider(provider : DependencyProvider) : InjectionMapping 
	{
		if(_sealed) throwSealedError();
		if(hasProvider() && provider != null && !_defaultProviderSet)  {
			trace("Warning: Injector already has a mapping for " + _mappingId + ".\n " + "If you have overridden this mapping intentionally you can use " + "\"injector.unmap()\" prior to your replacement mapping in order to " + "avoid seeing this message.");
			_creatingInjector.hasEventListener(MappingEvent.MAPPING_OVERRIDE) && _creatingInjector.dispatchEvent(new MappingEvent(MappingEvent.MAPPING_OVERRIDE, _type, _name, this));
		}
		dispatchPreChangeEvent();
		_defaultProviderSet = false;
		mapProvider(provider);
		dispatchPostChangeEvent();
		return this;
	}

	/**
	 * Causes the Injector the mapping is defined in to look further up in its inheritance
	 * chain for other mappings for the requested dependency. The Injector will use the
	 * inner-most strong mapping if one exists or the outer-most soft mapping otherwise.
	 *
	 * <p>Soft mappings enable modules to be set up in such a way that some of their settings
	 * can optionally be configured from the outside without them failing to run in standalone
	 * mode.</p>
	 *
	 * @return The <code>InjectionMapping</code> the method is invoked on
	 *
	 * @throws org.swiftsuspenders.InjectorError Sealed mappings can't be changed in any way
	 *
	 * @see #strong()
	 */	
	//public function soft() : InjectionMapping {
		//_sealed && throwSealedError();
		//if(!_soft)  {
			//var provider : DependencyProvider = getProvider();
			//dispatchPreChangeEvent();
			//_soft = true;
			//mapProvider(provider);
			//dispatchPostChangeEvent();
		//}
		//return this;
	//}

	/**
	 * Reverts the effect of <code>soft()</code> and makes the Injector the mapping is defined
	 * in stop looking up its inheritance chain for the mapped request immediately.
	 *
	 * @return The <code>InjectionMapping</code> the method is invoked on
	 *
	 * @throws org.swiftsuspenders.InjectorError Sealed mappings can't be changed in any way
	 *
	 * @see #soft()
	 */	
	//public function strong() : InjectionMapping {
		//_sealed && throwSealedError();
		//if(_soft)  {
			//var provider : DependencyProvider = getProvider();
			//dispatchPreChangeEvent();
			//_soft = false;
			//mapProvider(provider);
			//dispatchPostChangeEvent();
		//}
		//return this;
	//}

	/**
	 * Disables sharing the mapping with child Injectors of the Injector it is defined in.
	 *
	 * @return The <code>InjectionMapping</code> the method is invoked on
	 *
	 * @throws org.swiftsuspenders.InjectorError Sealed mappings can't be changed in any way
	 *
	 * @see #shared()
	 */	
	//public function local() : InjectionMapping {
		//_sealed && throwSealedError();
		//if(_local)  {
			//return this;
		//}
		//var provider : DependencyProvider = getProvider();
		//dispatchPreChangeEvent();
		//_local = true;
		//mapProvider(provider);
		//dispatchPostChangeEvent();
		//return this;
	//}

	/**
	 * Reverts the effect of <code>local</code>, enables sharing the mapping with child
	 * Injectors of the Injector it is defined in.
	 *
	 * @return The <code>InjectionMapping</code> the method is invoked on
	 *
	 * @throws org.swiftsuspenders.InjectorError Sealed mappings can't be changed in any way
	 *
	 * @see #local()
	 */	
	//public function shared() : InjectionMapping {
		//_sealed && throwSealedError();
		//if(!_local)  {
			//return this;
		//}
		//var provider : DependencyProvider = getProvider();
		//dispatchPreChangeEvent();
		//_local = false;
		//mapProvider(provider);
		//dispatchPostChangeEvent();
		//return this;
	//}

	/**
	 * Prevents all subsequent changes to the mapping, including removal. Trying to change it
	 * in any way at all will throw an <code>InjectorError</code>.
	 *
	 * <p>To enable unsealing of the mapping at a later time, <code>seal</code> returns a
	 * unique object that can be used as the argument to <code>unseal</code>. As long as that
	 * key object is kept secret, there's no way to tamper with or remove the mapping.</p>
	 *
	 * @returns An internally created object that can be used as the key for unseal
	 *
	 * @throws org.swiftsuspenders.InjectorError Can't be invoked on a mapping that's already sealed
	 *
	 * @see #unseal()
	 */	
	public function seal() : Dynamic {
		if(_sealed)  {
			throw new InjectorError("Mapping is already sealed.");
		}
		_sealed = true;
		_sealKey = { };
		return _sealKey;
	}

	/**
	 * Reverts the effect of <code>seal</code>, makes the mapping changeable again.
	 *
	 * @param key The key to unseal the mapping. Has to be the instance returned by
	 * <code>seal()</code>
	 *
	 * @return The <code>InjectionMapping</code> the method is invoked on
	 *
	 * @throws org.swiftsuspenders.InjectorError Has to be invoked with the unique key object returned by an earlier call to <code>seal</code>
	 * @throws org.swiftsuspenders.InjectorError Can't unseal a mapping that's not sealed
	 *
	 * @see #seal()
	 */	
	public function unseal(key : Dynamic) : InjectionMapping {
		if(!_sealed)  {
			throw new InjectorError("Can\'t unseal a non-sealed mapping.");
		}
		if(key != _sealKey)  {
			throw new InjectorError("Can\'t unseal mapping without the correct key.");
		}
		_sealed = false;
		_sealKey = null;
		return this;
	}

	/**
	 * @return <code>true</code> if the mapping is sealed, <code>false</code> if not
	 */	
	public function getIsSealed() : Bool {
		return _sealed;
	}

	/**
	 * @return <code>true</code> if the mapping has a provider, <code>false</code> if not
	 */	
	public function hasProvider() : Bool {
		return _creatingInjector.providerMappings.exists(_mappingId);
	}

	/**
	 * @return The provider currently associated with the mapping
	 */	
	public function getProvider() : DependencyProvider {
		var provider : DependencyProvider = _creatingInjector.providerMappings.get(_mappingId);
		while(Std.is(provider, ForwardingProvider)) {
			provider = cast((provider), ForwardingProvider).provider;
		}

		return provider;
	}

	/**
	 * Sets the Injector to supply to the mapped DependencyProvider or to query for ancestor
	 * mappings.
	 *
	 * An Injector is always provided when calling apply, but if one is also set using
	 * setInjector, it takes precedence. This is used to implement forks in a dependency graph,
	 * allowing the use of a different Injector from a certain point in the constructed object
	 * graph on.
	 *
	 * @param injector - The Injector to use in the mapping. Set to null to reset.
	 *
	 * @return The <code>InjectionMapping</code> the method is invoked on
	 */	
	//public function setInjector(injector : Injector) : InjectionMapping {
		//_sealed && throwSealedError();
		//if(injector == _overridingInjector)  {
			//return this;
		//}
		//var provider : DependencyProvider = getProvider();
		//_overridingInjector = injector;
		//mapProvider(provider);
		//return this;
	//}

	//----------------------         Private / Protected Methods        ----------------------//
	function mapProvider(provider : DependencyProvider) : Void {
		if(_soft)  {
			provider = new SoftDependencyProvider(provider);
		}
		if(_local)  {
			provider = new LocalOnlyProvider(provider);
		}
		if(_overridingInjector != null)  {
			provider = new InjectorUsingProvider(_overridingInjector, provider);
		}
		_creatingInjector.providerMappings.set(_mappingId, provider); // _creatingInjector.providerMappings[_mappingId] = provider;
	}

	function throwSealedError() : Void {
		throw new InjectorError("Can\'t change a sealed mapping");
	}

	function dispatchPreChangeEvent() : Void {
		_creatingInjector.hasEventListener(MappingEvent.PRE_MAPPING_CHANGE) && _creatingInjector.dispatchEvent(new MappingEvent(MappingEvent.PRE_MAPPING_CHANGE, _type, _name, this));
	}

	function dispatchPostChangeEvent() : Void {
		_creatingInjector.hasEventListener(MappingEvent.POST_MAPPING_CHANGE) && _creatingInjector.dispatchEvent(new MappingEvent(MappingEvent.POST_MAPPING_CHANGE, _type, _name, this));
	}

}

