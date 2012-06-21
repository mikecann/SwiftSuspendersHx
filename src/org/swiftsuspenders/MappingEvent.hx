/*
 * Copyright (c) 2011 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */
package org.swiftsuspenders;

import flash.events.Event;

class MappingEvent extends Event {

	//----------------------              Public Properties             ----------------------//
		/**
	 * @eventType preMappingCreate
	 */	static public inline var PRE_MAPPING_CREATE : String = "preMappingCreate";
	/**
	 * @eventType postMappingCreate
	 */	static public inline var POST_MAPPING_CREATE : String = "postMappingCreate";
	/**
	 * @eventType preMappingChange
	 */	static public inline var PRE_MAPPING_CHANGE : String = "preMappingChange";
	/**
	 * @eventType postMappingChange
	 */	static public inline var POST_MAPPING_CHANGE : String = "postMappingChange";
	/**
	 * @eventType postMappingRemove
	 */	static public inline var POST_MAPPING_REMOVE : String = "postMappingRemove";
	/**
	 * @eventType mappingOverride
	 */	static public inline var MAPPING_OVERRIDE : String = "mappingOverride";
	public var mappedType : Class<Dynamic>;
	public var mappedName : String;
	public var mapping : InjectionMapping;
	//----------------------               Public Methods               ----------------------//
		public function new(type : String, mappedType : Class<Dynamic>, mappedName : String, mapping : InjectionMapping) {
		super(type);
		this.mappedType = mappedType;
		this.mappedName = mappedName;
		this.mapping = mapping;
	}

	override public function clone() : Event {
		return new MappingEvent(type, mappedType, mappedName, mapping);
	}

}

