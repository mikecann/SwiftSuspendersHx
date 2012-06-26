/*
 * Copyright (c) 2009 - 2011 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */
package org.swiftsuspenders.support.injectees;

class OrderedPostConstructInjectee {

	public var loadOrder : Array<Dynamic>;
	
	//@PostConstruct(order=2)
	public function methodTwo() : Void {
		loadOrder.push(2);
	}

	@PostConstruct()
	public function methodFour() : Void {
		loadOrder.push(4);
	}

	//@PostConstruct(order=3)
	public function methodThree() : Void {
		loadOrder.push(3);
	}

	//@PostConstruct(order=1)
	public function methodOne() : Void {
		loadOrder.push(1);
	}

	public function new() {
		loadOrder = [];
	}
}

