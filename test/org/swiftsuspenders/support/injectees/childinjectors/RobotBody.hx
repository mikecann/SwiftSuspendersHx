/*
* Copyright (c) 2009 the original author or authors
* 
* Permission is hereby granted to use, modify, and distribute this file 
* in accordance with the terms of the license agreement accompanying it.
*/
package org.swiftsuspenders.support.injectees.childinjectors;

class RobotBody {

	@:meta(Inject(name="leftLeg"))
	public var leftLeg : RobotLeg;
	@:meta(Inject(name="rightLeg"))
	public var rightLeg : RobotLeg;

	public function new() {
	}
}

