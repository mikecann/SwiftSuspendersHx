/*
* Copyright (c) 2009 the original author or authors
* 
* Permission is hereby granted to use, modify, and distribute this file 
* in accordance with the terms of the license agreement accompanying it.
*/
package org.swiftsuspenders;
import org.swiftsuspenders.haxe.Error;

class InjectorError extends Error {

	public function new(message : String="", id : String="") {
		super(message, id);
	}

}

