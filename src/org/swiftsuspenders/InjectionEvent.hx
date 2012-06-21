package org.swiftsuspenders;

import flash.events.Event;

class InjectionEvent extends Event {

	//----------------------              Public Properties             ----------------------//
		/**
	 * @eventType postInstantiate
	 */	static public inline var POST_INSTANTIATE : String = "postInstantiate";
	/**
	 * @eventType preConstruct
	 */	static public inline var PRE_CONSTRUCT : String = "preConstruct";
	/**
	 * @eventType postConstruct
	 */	static public inline var POST_CONSTRUCT : String = "postConstruct";
	public var instance : Dynamic;
	public var instanceType : Class<Dynamic>;
	//----------------------               Public Methods               ----------------------//
		public function new(type : String, instance : Dynamic, instanceType : Class<Dynamic>) {
		super(type);
		this.instance = instance;
		this.instanceType = instanceType;
	}

	override public function clone() : Event {
		return new InjectionEvent(type, instance, instanceType);
	}

}

