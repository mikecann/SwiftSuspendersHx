/*
* Copyright (c) 2009 the original author or authors
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/
package org.swiftsuspenders;

import flash.display.Loader;
import flash.events.Event;
import flash.events.TimerEvent;
import flash.net.URLRequest;
import flash.system.ApplicationDomain;
import flash.system.LoaderContext;
import flash.system.System;
import flash.utils.ByteArray;
import flash.utils.Dictionary;
import flash.utils.Timer;
import flexunit.framework.Assert;
import org.flexunit.async.Async;
import org.swiftsuspenders.support.injectees.ClassInjectee;
import org.swiftsuspenders.support.types.Clazz;
import org.swiftsuspenders.utils.SsInternal;

/**
 * Note: All tests in this class require an up-to-date version of the file
 * "build/support/app-domain-test-files/app-domain-support.swf
 */class ApplicationDomainTests {

	var injector : Injector;
	var _loader : Loader;
	var _loaderDomain : ApplicationDomain;
	var _weaklyKeyedDomainHolder : Dictionary;
	var _timer : Timer;
	var _supportSWFLoadingCallback : Function;
	@:meta(Before())
	public function runBeforeEachTest() : Void {
		injector = new Injector();
	}

	@:meta(After())
	public function runAfterEachTest() : Void {
		Injector.SsInternal::purgeInjectionPointsCache();
		injector = null;
		_weaklyKeyedDomainHolder = null;
		_supportSWFLoadingCallback = null;
		if(_timer != null)  {
			_timer.reset();
			_timer = null;
		}
		if(_loader != null)  {
			_loaderDomain = null;
			_loader.unloadAndStop(true);
			_loader = null;
		}
		System.gc();
	}

	//[Test(async, timeout=5000)]
		public function injectorWorksForTypesInChildAppDomains() : Void {
		loadSupportSWFIntoDomainWithCallback(new ApplicationDomain(), function() : Void {
			var className : String = Type.getClassName(ClassInjectee);
			var injecteeType : Class<Dynamic> = cast((_loaderDomain.getDefinition(className)), Class);
			var injectee : Dynamic = Type.createInstance(injecteeType, []);
			injector.map(Clazz).toType(cast((_loaderDomain.getDefinition(Type.getClassName(Clazz))), Class));
			injector.injectInto(injectee);
			Assert.assertNotNull("Injection into instance of class from child domain child domain succeeds", injectee.property);
		}
);
		Async.handleEvent(this, _timer, TimerEvent.TIMER, injectorWorksForTypesInChildAppDomains_result, 5000);
	}

	function injectorWorksForTypesInChildAppDomains_result() : Void {
	}

	/**
	 * disabled for now because I can't find a way to force the player to perform both the
	 * mark and the sweep parts of GC in a reliable way inside the test harness, resulting in
	 * false negatives.
	 *///		[Test(async, timeout=5000)]
	//		public function mappingsInReleasedChildInjectorDontKeepChildAppDomainAlive() : void
	//		{
	//			loadSupportSWFIntoDomainWithCallback(new ApplicationDomain(), function() : void
	//			{
	//				var childInjector : Injector = injector.createChildInjector(_loaderDomain);
	//				childInjector.mapClass(Clazz,
	//						Class(_loaderDomain.getDefinition(getQualifiedClassName(Clazz))));
	//			});
	//			Async.handleEvent(this, _timer, TimerEvent.TIMER,
	//					mappingsInReleasedChildInjectorDontKeepChildAppDomainAlive_result, 5000);
	//		}
	//		private function mappingsInReleasedChildInjectorDontKeepChildAppDomainAlive_result(
	//				...args) : void
	//		{
	//			Assert.assertTrue('Mapping a class from a child ApplicationDomain doesn\'t prevent ' +
	//					'it from being collected', weaklyKeyedDictionaryIsEmpty());
	//		}
	@:meta(Embed(source="/../build/support/app-domain-test-files/app-domain-support.swf"))
	var supportSWF : Class<Dynamic>;
	function loadSupportSWFIntoDomainWithCallback(domain : ApplicationDomain, callback : Function) : Void {
		_supportSWFLoadingCallback = callback;
		_timer = new Timer(0, 1);
		_loader = new Loader();
		_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, supportSWFLoading_complete);
		var context : LoaderContext = new LoaderContext(false, domain);
		var bytes : ByteArray = cast(((Type.createInstance(supportSWF, []))["movieClipData"]), ByteArray);
		_loader.loadBytes(bytes, context);
	}

	function supportSWFLoading_complete(event : Event) : Void {
		_loaderDomain = _loader.contentLoaderInfo.applicationDomain;
		_weaklyKeyedDomainHolder = new Dictionary(true);
		Reflect.setField(_weaklyKeyedDomainHolder, Std.string(_loaderDomain), true);
		_supportSWFLoadingCallback.call(this);
		_loaderDomain = null;
		_loader = null;
		System.gc();
		_timer.start();
	}

	function weaklyKeyedDictionaryIsEmpty() : Bool {
		for(item in Reflect.fields(_weaklyKeyedDomainHolder)) {
			return false;
		}

		return true;
	}


	public function new() {
	}
}

