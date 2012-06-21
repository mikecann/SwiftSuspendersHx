/*
 * Copyright (c) 2012 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */
package org.swiftsuspenders;

import org.swiftsuspenders.typedescriptions.TypeDescription;

interface Reflector {

	function getClass(value : Dynamic) : Class<Dynamic>;
	function getFQCN(value : Dynamic, replaceColons : Bool = false) : String;
	function typeImplements(type : Class<Dynamic>, superType : Class<Dynamic>) : Bool;
	function describeInjections(type : Class<Dynamic>) : TypeDescription;
}

