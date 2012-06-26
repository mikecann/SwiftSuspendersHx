/*
* Copyright (c) 2009 the original author or authors
* 
* Permission is hereby granted to use, modify, and distribute this file 
* in accordance with the terms of the license agreement accompanying it.
*/
package org.swiftsuspenders.support.injectees.childinjectors;

class RobotBody {

	@Inject("leftLeg")
	public var leftLeg : RobotLeg;
	
	@Inject("rightLeg")
	public var rightLeg : RobotLeg;

	public function new() {
	}
}

