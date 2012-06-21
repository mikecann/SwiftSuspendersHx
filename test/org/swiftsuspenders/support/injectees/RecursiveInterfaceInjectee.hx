package org.swiftsuspenders.support.injectees;

import org.swiftsuspenders.support.types.Interface;

class RecursiveInterfaceInjectee implements Interface {

	@:meta(Inject())
	public var interfaceInjectee : InterfaceInjectee;
	public function new() {
	}

}

