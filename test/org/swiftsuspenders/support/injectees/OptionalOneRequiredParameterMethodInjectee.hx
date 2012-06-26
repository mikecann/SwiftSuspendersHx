/*
 * Copyright (c) 2011 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */
package org.swiftsuspenders.support.injectees;

import org.swiftsuspenders.support.types.Clazz;

class OptionalOneRequiredParameterMethodInjectee {

	var m_dependency : Clazz;
	
	@OptionalInject
	public function setDependency(dependency : Clazz) : Void {
		m_dependency = dependency;
	}

	public function getDependency() : Clazz {
		return m_dependency;
	}

	public function new() {
	}

}

