/*
 * Copyright (c) 2011 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */
package org.swiftsuspenders.dependencyproviders;

class LocalOnlyProvider extends ForwardingProvider {

	public function new(provider : DependencyProvider) {
		super(provider);
	}

}
