/*
* Copyright (c) 2009 the original author or authors
* 
* Permission is hereby granted to use, modify, and distribute this file 
* in accordance with the terms of the license agreement accompanying it.
*/
package org.swiftsuspenders.support.injectees.childinjectors;

class LeftRobotFoot extends RobotFoot {

	@Inject
	public function new(toes : RobotToes = null) {
		super(toes);
	}

}

