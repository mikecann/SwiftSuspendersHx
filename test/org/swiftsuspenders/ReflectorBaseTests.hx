/*
 * Copyright (c) 2012 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */
package org.swiftsuspenders;
import haxe.unit.TestCase;

class ReflectorBaseTests extends TestCase
{

	var _reflector : ReflectorBase;
	
	override public function setup() 
	{ 
		_reflector = new ReflectorBase();
	}

	override public function tearDown() 
	{ 
		_reflector = null;
	}

	public function testGetClassReturnsConstructorForObject() : Void 
	{
		var object : Dynamic = { };
		var objectClass : Class<Dynamic> = _reflector.getClass(object);
		assertTrue(Std.is(objectClass,Dynamic)); // object\'s constructor is Object
	}

	//@:meta(Test())
	//public function getClassReturnsConstructorForArray() : Void {
		//var array : Array<Dynamic> = [];
		//var objectClass : Class<Dynamic> = _reflector.getClass(array);
		//Assert.assertEquals("object\'s constructor is Object", objectClass, Array);
	//}
//
	//@:meta(Test())
	//public function getClassReturnsConstructorForBoolean() : Void {
		//var object : Bool = true;
		//var objectClass : Class<Dynamic> = _reflector.getClass(object);
		//Assert.assertEquals("object\'s constructor is Object", objectClass, Boolean);
	//}
//
	//@:meta(Test())
	//public function getClassReturnsConstructorForNumber() : Void {
		//var object : Float = 10.1;
		//var objectClass : Class<Dynamic> = _reflector.getClass(object);
		//Assert.assertEquals("object\'s constructor is Object", objectClass, Number);
	//}
//
	//@:meta(Test())
	//public function getClassReturnsConstructorForInt() : Void {
		//var object : Int = 10;
		//var objectClass : Class<Dynamic> = _reflector.getClass(object);
		//Assert.assertEquals("object\'s constructor is Object", objectClass, int);
	//}
//
	//@:meta(Test())
	//public function getClassReturnsConstructorForUint() : Void {
		//var object : Int = 10;
		//var objectClass : Class<Dynamic> = _reflector.getClass(object);
		//Assert.assertEquals("object\'s constructor is Object", objectClass, int);
	//}
//
	//@:meta(Test())
	//public function getClassReturnsConstructorForString() : Void {
		//var object : String = "string";
		//var objectClass : Class<Dynamic> = _reflector.getClass(object);
		//Assert.assertEquals("object\'s constructor is Object", objectClass, String);
	//}
//
	//@:meta(Test())
	//public function getClassReturnsConstructorForXML() : Void {
		//var object : FastXML = new FastXML();
		//var objectClass : Class<Dynamic> = _reflector.getClass(object);
		//Assert.assertEquals("object\'s constructor is Object", objectClass, XML);
	//}
//
	//@:meta(Test())
	//public function getClassReturnsConstructorForXMLList() : Void {
		//var object : FastXMLList = new FastXMLList();
		//var objectClass : Class<Dynamic> = _reflector.getClass(object);
		//Assert.assertEquals("object\'s constructor is Object", objectClass, XMLList);
	//}
//
	//@:meta(Test())
	//public function getClassReturnsConstructorForFunction() : Void {
		//var object : Function = function() : Void {
		//}
//;
		//var objectClass : Class<Dynamic> = _reflector.getClass(object);
		//Assert.assertEquals("object\'s constructor is Object", objectClass, Function);
	//}
//
	//@:meta(Test())
	//public function getClassReturnsConstructorForRegExp() : Void {
		//var object : RegExp = new EReg('.', "");
		//var objectClass : Class<Dynamic> = _reflector.getClass(object);
		//Assert.assertEquals("object\'s constructor is Object", objectClass, RegExp);
	//}
//
	//@:meta(Test())
	//public function getClassReturnsConstructorForDate() : Void {
		//var object : Date = new Date();
		//var objectClass : Class<Dynamic> = _reflector.getClass(object);
		//Assert.assertEquals("object\'s constructor is Object", objectClass, Date);
	//}
//
	//@:meta(Test())
	//public function getClassReturnsConstructorForError() : Void {
		//var object : Error = new Error();
		//var objectClass : Class<Dynamic> = _reflector.getClass(object);
		//Assert.assertEquals("object\'s constructor is Object", objectClass, Error);
	//}
//
	//@:meta(Test())
	//public function getClassReturnsConstructorForQName() : Void {
		//var object : QName = new QName();
		//var objectClass : Class<Dynamic> = _reflector.getClass(object);
		//Assert.assertEquals("object\'s constructor is Object", objectClass, QName);
	//}
//
	//@:meta(Test())
	//public function getClassReturnsConstructorForVector() : Void {
		//var object : Array<String> = new Array<String>();
		//var objectClass : Class<Dynamic> = _reflector.getClass(object);
		//See comment in getClass for why Vector.<*> is expected.
		//Assert.assertEquals("object\'s constructor is Object", objectClass, Dynamic);
	//}
}

