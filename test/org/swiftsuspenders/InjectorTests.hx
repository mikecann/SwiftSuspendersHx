/*
 * Copyright (c) 2012 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */
package org.swiftsuspenders;
import haxe.unit.TestCase;
import org.swiftsuspenders.haxe.Error;
import org.swiftsuspenders.support.injectees.ClassInjectee;
import org.swiftsuspenders.support.injectees.StringInjectee;
import org.swiftsuspenders.support.types.Clazz;

class InjectorTests extends TestCase
{	
	var injector : Injector;
	var receivedInjectorEvents : Array<Dynamic>;
	
	override public function setup() 
	{      
		injector = new Injector();
		receivedInjectorEvents = [];
    }
	
	override public function tearDown() 
	{     
		Injector.purgeInjectionPointsCache();
		injector = null;
		receivedInjectorEvents = null;
    }

	public function testUnbind() : Void 
	{
		var injectee = new ClassInjectee();
		var value = new Clazz();
		injector.map(Clazz).toValue(value);
		injector.unmap(Clazz);
		try { injector.injectInto(injectee); }
		catch (e : Error) { };
		assertTrue(injectee.property == null);
	}


	public function testInjectorInjectsBoundValueIntoAllInjectees() : Void 
	{
		var injectee : ClassInjectee = new ClassInjectee();
		var injectee2 : ClassInjectee = new ClassInjectee();
		var value : Clazz = new Clazz();
		injector.map(Clazz).toValue(value);
		injector.injectInto(injectee);
		
		assertEquals(value, injectee.property);
		injector.injectInto(injectee2);
		assertEquals(injectee.property, injectee2.property);
	}

	//public function testBindValueByInterface() : Void 
	//{
		//var injectee : InterfaceInjectee = new InterfaceInjectee();
		//var value : Interface = new Clazz();
		//injector.map(Interface).toValue(value);
		//injector.injectInto(injectee);
		//Assert.assertStrictlyEquals("Value should have been injected", value, injectee.property);
	//}
//
	//public function testBindNamedValue() : Void 
	//{
		//var injectee : NamedClassInjectee = new NamedClassInjectee();
		//var value : Clazz = new Clazz();
		//injector.map(Clazz, NamedClassInjectee.NAME).toValue(value);
		//injector.injectInto(injectee);
		//Assert.assertStrictlyEquals("Named value should have been injected", value, injectee.property);
	//}
//
	//public function testBindNamedValueByInterface() : Void
	//{
		//var injectee : NamedInterfaceInjectee = new NamedInterfaceInjectee();
		//var value : Interface = new Clazz();
		//injector.map(Interface, NamedClassInjectee.NAME).toValue(value);
		//injector.injectInto(injectee);
		//Assert.assertStrictlyEquals("Named value should have been injected", value, injectee.property);
	//}
//
	//public function testBindFalsyValue() : Void 
	//{
		//var injectee = new StringInjectee();
		//var value : String = "";
		//injector.map(String).toValue(value);
		//injector.injectInto(injectee);
		//assertEquals(value, injectee.property);
	//}

	//public function testBoundValueIsNotInjectedInto() : Void 
	//{
		//var injectee : RecursiveInterfaceInjectee = new RecursiveInterfaceInjectee();
		//var value : InterfaceInjectee = new InterfaceInjectee();
		//injector.map(InterfaceInjectee).toValue(value);
		//injector.injectInto(injectee);
		//Assert.assertNull("value shouldn\'t have been injected into", value.property);
	//}
//
	//public function testBindMultipleInterfacesToOneSingletonClass() : Void 
	//{
		//var injectee : MultipleSingletonsOfSameClassInjectee = new MultipleSingletonsOfSameClassInjectee();
		//injector.map(Interface).toSingleton(Clazz);
		//injector.map(Interface2).toSingleton(Clazz);
		//injector.injectInto(injectee);
		//Assert.assertNotNull("Singleton Value for 'property1' should have been injected", injectee.property1);
		//Assert.assertNotNull("Singleton Value for 'property2' should have been injected", injectee.property2);
		//Assert.assertFalse("Singleton Values 'property1' and 'property2' should not be identical", injectee.property1 == injectee.property2);
	//}
//
	//public function testBindClass() : Void 
	//{
		//var injectee : ClassInjectee = new ClassInjectee();
		//var injectee2 : ClassInjectee = new ClassInjectee();
		//injector.map(Clazz).toType(Clazz);
		//injector.injectInto(injectee);
		//Assert.assertNotNull("Instance of Class should have been injected", injectee.property);
		//injector.injectInto(injectee2);
		//Assert.assertFalse("Injected values should be different", injectee.property == injectee2.property);
	//}
//
	//public function testBoundClassIsInjectedInto() : Void 
	//{
		//var injectee : ComplexClassInjectee = new ComplexClassInjectee();
		//var value : Clazz = new Clazz();
		//injector.map(Clazz).toValue(value);
		//injector.map(ComplexClazz).toType(ComplexClazz);
		//injector.injectInto(injectee);
		//Assert.assertNotNull("Complex Value should have been injected", injectee.property);
		//Assert.assertStrictlyEquals("Nested value should have been injected", value, injectee.property.value);
	//}
//
	//public function testBindClassByInterface() : Void 
	//{
		//var injectee : InterfaceInjectee = new InterfaceInjectee();
		//injector.map(Interface).toType(Clazz);
		//injector.injectInto(injectee);
		//Assert.assertNotNull("Instance of Class should have been injected", injectee.property);
	//}
//
	//public function testBindNamedClass() : Void 
	//{
		//var injectee : NamedClassInjectee = new NamedClassInjectee();
		//injector.map(Clazz, NamedClassInjectee.NAME).toType(Clazz);
		//injector.injectInto(injectee);
		//Assert.assertNotNull("Instance of named Class should have been injected", injectee.property);
	//}
//
	//public function testBindNamedClassByInterface() : Void 
	//{
		//var injectee : NamedInterfaceInjectee = new NamedInterfaceInjectee();
		//injector.map(Interface, NamedClassInjectee.NAME).toType(Clazz);
		//injector.injectInto(injectee);
		//Assert.assertNotNull("Instance of named Class should have been injected", injectee.property);
	//}

	//public function testBindSingleton() : Void 
	//{
		//var injectee : ClassInjectee = new ClassInjectee();
		//var injectee2 : ClassInjectee = new ClassInjectee();
		//injector.map(Clazz).toSingleton(Clazz);
		//injector.injectInto(injectee);
		//Assert.assertNotNull("Instance of Class should have been injected", injectee.property);
		//injector.injectInto(injectee2);
		//Assert.assertStrictlyEquals("Injected values should be equal", injectee.property, injectee2.property);
	//}

	//public function testBindSingletonOf() : Void 
	//{
		//var injectee : InterfaceInjectee = new InterfaceInjectee();
		//var injectee2 : InterfaceInjectee = new InterfaceInjectee();
		//injector.map(Interface).toSingleton(Clazz);
		//injector.injectInto(injectee);
		//Assert.assertNotNull("Instance of Class should have been injected", injectee.property);
		//injector.injectInto(injectee2);
		//Assert.assertStrictlyEquals("Injected values should be equal", injectee.property, injectee2.property);
	//}
//
	//public function testBindDifferentlyNamedSingletonsBySameInterface() : Void 
	//{
		//var injectee : TwoNamedInterfaceFieldsInjectee = new TwoNamedInterfaceFieldsInjectee();
		//injector.map(Interface, "Name1").toSingleton(Clazz);
		//injector.map(Interface, "Name2").toSingleton(Clazz2);
		//injector.injectInto(injectee);
		//Assert.assertTrue("Property \"property1\" should be of type \"Clazz\"", Std.is(injectee.property1, Clazz));
		//Assert.assertTrue("Property \"property2\" should be of type \"Clazz2\"", Std.is(injectee.property2, Clazz2));
		//Assert.assertFalse("Properties \"property1\" and \"property2\" should have received different singletons", injectee.property1 == injectee.property2);
	//}
//
	//public function testPerformSetterInjection() : Void 
	//{
		//var injectee : SetterInjectee = new SetterInjectee();
		//var injectee2 : SetterInjectee = new SetterInjectee();
		//injector.map(Clazz).toType(Clazz);
		//injector.injectInto(injectee);
		//Assert.assertNotNull("Instance of Class should have been injected", injectee.property);
		//injector.injectInto(injectee2);
		//Assert.assertFalse("Injected values should be different", injectee.property == injectee2.property);
	//}
//
	//public function testPerformMethodInjectionWithOneParameter() : Void
	//{
		//var injectee : OneParameterMethodInjectee = new OneParameterMethodInjectee();
		//var injectee2 : OneParameterMethodInjectee = new OneParameterMethodInjectee();
		//injector.map(Clazz).toType(Clazz);
		//injector.injectInto(injectee);
		//Assert.assertNotNull("Instance of Class should have been injected", injectee.getDependency());
		//injector.injectInto(injectee2);
		//Assert.assertFalse("Injected values should be different", injectee.getDependency() == injectee2.getDependency());
	//}
//
	//public function testPerformMethodInjectionWithOneNamedParameter() : Void 
	//{
		//var injectee : OneNamedParameterMethodInjectee = new OneNamedParameterMethodInjectee();
		//var injectee2 : OneNamedParameterMethodInjectee = new OneNamedParameterMethodInjectee();
		//injector.map(Clazz, "namedDep").toType(Clazz);
		//injector.injectInto(injectee);
		//Assert.assertNotNull("Instance of Class should have been injected for named Clazz parameter", injectee.getDependency());
		//injector.injectInto(injectee2);
		//Assert.assertFalse("Injected values should be different", injectee.getDependency() == injectee2.getDependency());
	//}
//
	//public function testPerformMethodInjectionWithTwoParameters() : Void 
	//{
		//var injectee : TwoParametersMethodInjectee = new TwoParametersMethodInjectee();
		//var injectee2 : TwoParametersMethodInjectee = new TwoParametersMethodInjectee();
		//injector.map(Clazz).toType(Clazz);
		//injector.map(Interface).toType(Clazz);
		//injector.injectInto(injectee);
		//Assert.assertNotNull("Instance of Class should have been injected for unnamed Clazz parameter", injectee.getDependency());
		//Assert.assertNotNull("Instance of Class should have been injected for unnamed Interface parameter", injectee.getDependency2());
		//injector.injectInto(injectee2);
		//Assert.assertFalse("Injected values should be different", injectee.getDependency() == injectee2.getDependency());
		//Assert.assertFalse("Injected values for Interface should be different", injectee.getDependency2() == injectee2.getDependency2());
	//}
//
	//public function testPerformMethodInjectionWithTwoNamedParameters() : Void 
	//{
		//var injectee : TwoNamedParametersMethodInjectee = new TwoNamedParametersMethodInjectee();
		//var injectee2 : TwoNamedParametersMethodInjectee = new TwoNamedParametersMethodInjectee();
		//injector.map(Clazz, "namedDep").toType(Clazz);
		//injector.map(Interface, "namedDep2").toType(Clazz);
		//injector.injectInto(injectee);
		//Assert.assertNotNull("Instance of Class should have been injected for named Clazz parameter", injectee.getDependency());
		//Assert.assertNotNull("Instance of Class should have been injected for named Interface parameter", injectee.getDependency2());
		//injector.injectInto(injectee2);
		//Assert.assertFalse("Injected values should be different", injectee.getDependency() == injectee2.getDependency());
		//Assert.assertFalse("Injected values for Interface should be different", injectee.getDependency2() == injectee2.getDependency2());
	//}
//
	//public function testPerformMethodInjectionWithMixedParameters() : Void 
	//{
		//var injectee : MixedParametersMethodInjectee = new MixedParametersMethodInjectee();
		//var injectee2 : MixedParametersMethodInjectee = new MixedParametersMethodInjectee();
		//injector.map(Clazz, "namedDep").toType(Clazz);
		//injector.map(Clazz).toType(Clazz);
		//injector.map(Interface, "namedDep2").toType(Clazz);
		//injector.injectInto(injectee);
		//Assert.assertNotNull("Instance of Class should have been injected for named Clazz parameter", injectee.getDependency());
		//Assert.assertNotNull("Instance of Class should have been injected for unnamed Clazz parameter", injectee.getDependency2());
		//Assert.assertNotNull("Instance of Class should have been injected for Interface", injectee.getDependency3());
		//injector.injectInto(injectee2);
		//Assert.assertFalse("Injected values for named Clazz should be different", injectee.getDependency() == injectee2.getDependency());
		//Assert.assertFalse("Injected values for unnamed Clazz should be different", injectee.getDependency2() == injectee2.getDependency2());
		//Assert.assertFalse("Injected values for named Interface should be different", injectee.getDependency3() == injectee2.getDependency3());
	//}
//
	//public function testPerformConstructorInjectionWithOneParameter() : Void 
	//{
		//injector.map(Clazz);
		//var injectee : OneParameterConstructorInjectee = injector.getInstance(OneParameterConstructorInjectee);
		//Assert.assertNotNull("Instance of Class should have been injected for Clazz parameter", injectee.getDependency());
	//}
//
	//public function testPerformConstructorInjectionWithTwoParameters() : Void 
	//{
		//injector.map(Clazz);
		//injector.map(String).toValue("stringDependency");
		//var injectee : TwoParametersConstructorInjectee = injector.getInstance(TwoParametersConstructorInjectee);
		//Assert.assertNotNull("Instance of Class should have been injected for named Clazz parameter", injectee.getDependency());
		//Assert.assertEquals("The String 'stringDependency' should have been injected for String parameter", injectee.getDependency2(), "stringDependency");
	//}
//
	//public function testPerformConstructorInjectionWithOneNamedParameter() : Void 
	//{
		//injector.map(Clazz, "namedDependency").toType(Clazz);
		//var injectee : OneNamedParameterConstructorInjectee = injector.getInstance(OneNamedParameterConstructorInjectee);
		//Assert.assertNotNull("Instance of Class should have been injected for named Clazz parameter", injectee.getDependency());
	//}
//
	//public function testPerformXMLConfiguredConstructorInjectionWithOneNamedParameter() : Void 
	//{
		//injector = new Injector();
		//injector.map(Clazz, "namedDependency").toType(Clazz);
		//var injectee : OneNamedParameterConstructorInjectee = injector.getInstance(OneNamedParameterConstructorInjectee);
		//Assert.assertNotNull("Instance of Class should have been injected for named Clazz parameter", injectee.getDependency());
	//}
//
	//public function testPerformConstructorInjectionWithTwoNamedParameter() : Void 
	//{
		//injector.map(Clazz, "namedDependency").toType(Clazz);
		//injector.map(String, "namedDependency2").toValue("stringDependency");
		//var injectee : TwoNamedParametersConstructorInjectee = injector.getInstance(TwoNamedParametersConstructorInjectee);
		//Assert.assertNotNull("Instance of Class should have been injected for named Clazz parameter", injectee.getDependency());
		//Assert.assertEquals("The String 'stringDependency' should have been injected for named String parameter", injectee.getDependency2(), "stringDependency");
	//}
//
	//public function testPerformConstructorInjectionWithMixedParameters() : Void 
	//{
		//injector.map(Clazz, "namedDep").toType(Clazz);
		//injector.map(Clazz).toType(Clazz);
		//injector.map(Interface, "namedDep2").toType(Clazz);
		//var injectee : MixedParametersConstructorInjectee = injector.getInstance(MixedParametersConstructorInjectee);
		//Assert.assertNotNull("Instance of Class should have been injected for named Clazz parameter", injectee.getDependency());
		//Assert.assertNotNull("Instance of Class should have been injected for unnamed Clazz parameter", injectee.getDependency2());
		//Assert.assertNotNull("Instance of Class should have been injected for Interface", injectee.getDependency3());
	//}
//
	//public function testPerformNamedArrayInjection() : Void 
	//{
		//var ac : ArrayCollection = new ArrayCollection();
		//injector.map(ArrayCollection, "namedCollection").toValue(ac);
		//var injectee : NamedArrayCollectionInjectee = injector.getInstance(NamedArrayCollectionInjectee);
		//Assert.assertNotNull("Instance 'ac' should have been injected for named ArrayCollection parameter", injectee.ac);
		//Assert.assertEquals("Instance field 'ac' should be identical to local variable 'ac'", ac, injectee.ac);
	//}
//
	//public function testPerformMappedMappingInjection() : Void 
	//{
		//var mapping : InjectionMapping = injector.map(Interface);
		//mapping.toSingleton(Clazz);
		//injector.map(Interface2).toProvider(new OtherMappingProvider(mapping));
		//var injectee : MultipleSingletonsOfSameClassInjectee = injector.getInstance(MultipleSingletonsOfSameClassInjectee);
		//Assert.assertEquals("Instance field 'property1' should be identical to Instance field 'property2'", injectee.property1, injectee.property2);
	//}
//
	//public function testPerformMappedNamedMappingInjection() : Void 
	//{
		//var mapping : InjectionMapping = injector.map(Interface);
		//mapping.toSingleton(Clazz);
		//injector.map(Interface2).toProvider(new OtherMappingProvider(mapping));
		//injector.map(Interface, "name1").toProvider(new OtherMappingProvider(mapping));
		//injector.map(Interface2, "name2").toProvider(new OtherMappingProvider(mapping));
		//var injectee : MultipleNamedSingletonsOfSameClassInjectee = injector.getInstance(MultipleNamedSingletonsOfSameClassInjectee);
		//Assert.assertEquals("Instance field 'property1' should be identical to Instance field 'property2'", injectee.property1, injectee.property2);
		//Assert.assertEquals("Instance field 'property1' should be identical to Instance field 'namedProperty1'", injectee.property1, injectee.namedProperty1);
		//Assert.assertEquals("Instance field 'property1' should be identical to Instance field 'namedProperty2'", injectee.property1, injectee.namedProperty2);
	//}
//
	//public function testPerformInjectionIntoValueWithRecursiveSingeltonDependency() : Void
	//{
		//var valueInjectee : InterfaceInjectee = new InterfaceInjectee();
		//injector.map(InterfaceInjectee).toValue(valueInjectee);
		//injector.map(Interface).toSingleton(RecursiveInterfaceInjectee);
		//injector.injectInto(valueInjectee);
	//}
//
	//public function testInjectXMLValue() : Void 
	//{
		//var injectee : XMLInjectee = new XMLInjectee();
		//var value : FastXML = FastXML.parse("<test/>");
		//injector.map(XML).toValue(value);
		//injector.injectInto(injectee);
		//Assert.assertEquals("injected value should be indentical to mapped value", injectee.property, value);
	//}
//
	//@:meta(Test(expects="org.swiftsuspenders.InjectorError"))
	//public function testHaltOnMissingDependency() : Void {
		//var injectee : InterfaceInjectee = new InterfaceInjectee();
		//injector.injectInto(injectee);
	//}
//
	//@:meta(Test(expects="org.swiftsuspenders.InjectorError"))
	//public function testHaltOnMissingNamedDependency() : Void {
		//var injectee : NamedClassInjectee = new NamedClassInjectee();
		//injector.injectInto(injectee);
	//}
//
	//public function testPostConstructIsCalled() : Void 
	//{
		//var injectee : ClassInjectee = new ClassInjectee();
		//var value : Clazz = new Clazz();
		//injector.map(Clazz).toValue(value);
		//injector.injectInto(injectee);
		//Assert.assertTrue(injectee.someProperty);
	//}
//
	//public function testPostConstructWithArgIsCalledCorrectly() : Void 
	//{
		//injector.map(Clazz);
		//var injectee : PostConstructWithArgInjectee = injector.getInstance(PostConstructWithArgInjectee);
		//assertThat(injectee.property, isA(Clazz));
	//}
//
	//public function testPostConstructMethodsCalledAsOrdered() : Void
	//{
		//var injectee : OrderedPostConstructInjectee = new OrderedPostConstructInjectee();
		//injector.injectInto(injectee);
		//assertThat(injectee.loadOrder, array(1, 2, 3, 4));
	//}
//
	//public function testHasMappingFailsForUnmappedUnnamedClass() : Void 
	//{
		//Assert.assertFalse(injector.satisfies(Clazz));
	//}
//
	//public function testHasMappingFailsForUnmappedNamedClass() : Void 
	//{
		//Assert.assertFalse(injector.satisfies(Clazz, "namedClass"));
	//}
//
	//public function testHasMappingSucceedsForMappedUnnamedClass() : Void 
	//{
		//injector.map(Clazz).toType(Clazz);
		//Assert.assertTrue(injector.satisfies(Clazz));
	//}
//
	//public function testHasMappingSucceedsForMappedNamedClass() : Void 
	//{
		//injector.map(Clazz, "namedClass").toType(Clazz);
		//Assert.assertTrue(injector.satisfies(Clazz, "namedClass"));
	//}
//
	//@:meta(Test(expects="org.swiftsuspenders.InjectorError"))
	//public function testGetMappingResponseFailsForUnmappedNamedClass() : Void 
	//{
		//Assert.assertNull(injector.getInstance(Clazz, "namedClass"));
	//}
//
	//public function testGetMappingResponseSucceedsForMappedUnnamedClass() : Void 
	//{
		//var clazz : Clazz = new Clazz();
		//injector.map(Clazz).toValue(clazz);
		//Assert.assertObjectEquals(injector.getInstance(Clazz), clazz);
	//}
//
	//public function testGetMappingResponseSucceedsForMappedNamedClass() : Void 
	//{
		//var clazz : Clazz = new Clazz();
		//injector.map(Clazz, "namedClass").toValue(clazz);
		//Assert.assertObjectEquals(injector.getInstance(Clazz, "namedClass"), clazz);
	//}
//
	//public function testInjectorRemovesSingletonInstanceOnMappingRemoval() : Void 
	//{
		//injector.map(Clazz).toSingleton(Clazz);
		//var injectee1 : ClassInjectee = injector.getInstance(ClassInjectee);
		//injector.unmap(Clazz);
		//injector.map(Clazz).toSingleton(Clazz);
		//var injectee2 : ClassInjectee = injector.getInstance(ClassInjectee);
		//Assert.assertFalse("injectee1.property is not the same instance as injectee2.property", injectee1.property == injectee2.property);
	//}
//
	//@:meta(Test(expects="org.swiftsuspenders.InjectorError"))
	//public function testInstantiateThrowsMeaningfulErrorOnInterfaceInstantiation() : Void 
	//{
		//injector.getInstance(Interface);
	//}
//
	//public function testInjectorDoesntThrowWhenAttemptingUnmappedOptionalPropertyInjection() : Void 
	//{
		//var injectee : OptionalClassInjectee = injector.getInstance(OptionalClassInjectee);
		//Assert.assertNull("injectee mustn\'t contain Clazz instance", injectee.property);
	//}
//
	//public function testInjectorDoesntThrowWhenAttemptingUnmappedOptionalMethodInjection() : Void 
	//{
		//var injectee : OptionalOneRequiredParameterMethodInjectee = injector.getInstance(OptionalOneRequiredParameterMethodInjectee);
		//Assert.assertNull("injectee mustn\'t contain Clazz instance", injectee.getDependency());
	//}
//
	//public function testSoftMappingIsUsedIfNoParentInjectorAvailable() : Void 
	//{
		//injector.map(Interface).toType(Clazz).soft();
		//Assert.assertNotNull(injector.getInstance(Interface));
	//}
//
	//public function testParentMappingIsUsedInsteadOfSoftChildMapping() : Void 
	//{
		//var childInjector : Injector = injector.createChildInjector();
		//injector.map(Interface).toType(Clazz);
		//childInjector.map(Interface).toType(Clazz2).soft();
		//Assert.assertEquals(Clazz, childInjector.getInstance(Interface)["constructor"]);
	//}
//
	//public function testCallingStrongTurnsSoftMappingsIntoStrongOnes() : Void 
	//{
		//var childInjector : Injector = injector.createChildInjector();
		//injector.map(Interface).toType(Clazz);
		//childInjector.map(Interface).toType(Clazz2).soft();
		//Assert.assertEquals(Clazz, childInjector.getInstance(Interface)["constructor"]);
		//childInjector.map(Interface).toType(Clazz2).strong();
		//Assert.assertEquals(Clazz2, childInjector.getInstance(Interface)["constructor"]);
	//}
//
	//public function testLocalMappingsAreUsedInOwnInjector() : Void
	//{
		//injector.map(Interface).toType(Clazz).local();
		//Assert.assertNotNull(injector.getInstance(Interface));
	//}
//
	//@:meta(Test(expects="org.swiftsuspenders.InjectorError"))
	//public function testLocalMappingsArentSharedWithChildInjectors() : Void 
	//{
		//var childInjector : Injector = injector.createChildInjector();
		//injector.map(Interface).toType(Clazz).local();
		//childInjector.getInstance(Interface);
	//}
//
	//public function testCallingSharedTurnsLocalMappingsIntoSharedOnes() : Void 
	//{
		//var childInjector : Injector = injector.createChildInjector();
		//injector.map(Interface).toType(Clazz).local();
		//injector.map(Interface).toType(Clazz).shared();
		//Assert.assertNotNull(childInjector.getInstance(Interface));
	//}
//
	//public function testInjectorDispatchesPostInstantiateEventDuringInstanceConstruction() : Void 
	//{
		//assertThat(constructMappedTypeAndListenForEvent(InjectionEvent.POST_INSTANTIATE), isTrue());
	//}
//
	//public function testInjectorDispatchesPreConstructEventDuringInstanceConstruction() : Void 
	//{
		//assertThat(constructMappedTypeAndListenForEvent(InjectionEvent.PRE_CONSTRUCT), isTrue());
	//}
//
	//public function testInjectorDispatchesPostConstructEventAfterInstanceConstruction() : Void
	//{
		//assertThat(constructMappedTypeAndListenForEvent(InjectionEvent.POST_CONSTRUCT), isTrue());
	//}
//
	//public function testInjectorEventsAfterInstantiateContainCreatedInstance() : Void 
	//{
		//function listener(event : InjectionEvent) : Void {
			//assertThat(event, hasPropertyWithValue("instance", isA(Clazz)));
		//}
//
		//injector.map(Clazz);
		//injector.addEventListener(InjectionEvent.POST_INSTANTIATE, listener);
		//injector.addEventListener(InjectionEvent.PRE_CONSTRUCT, listener);
		//injector.addEventListener(InjectionEvent.POST_CONSTRUCT, listener);
		//var instance : Clazz = injector.getInstance(Clazz);
	//}
//
	//public function testInjectIntoDispatchesPreConstructEventDuringObjectConstruction() : Void
	//{
		//assertThat(injectIntoInstanceAndListenForEvent(InjectionEvent.PRE_CONSTRUCT), isTrue());
	//}
//
	//public function testInjectIntoDispatchesPostConstructEventDuringObjectConstruction() : Void 
	//{
		//assertThat(injectIntoInstanceAndListenForEvent(InjectionEvent.POST_CONSTRUCT), isTrue());
	//}
//
	//public function testInjectorDispatchesEventBeforeCreatingNewMapping() : Void 
	//{
		//assertThat(createMappingAndListenForEvent(MappingEvent.PRE_MAPPING_CREATE));
	//}
//
	//public function testInjectorDispatchesEventAfterCreatingNewMapping() : Void 
	//{
		//assertThat(createMappingAndListenForEvent(MappingEvent.POST_MAPPING_CREATE));
	//}
//
	//public function testInjectorDispatchesEventBeforeChangingMappingProvider() : Void 
	//{
		//injector.map(Clazz);
		//listenToInjectorEvent(MappingEvent.PRE_MAPPING_CHANGE);
		//injector.map(Clazz).asSingleton();
		//assertThat(receivedInjectorEvents.pop(), equalTo(MappingEvent.PRE_MAPPING_CHANGE));
	//}
//
	//public function testInjectorDispatchesEventAfterChangingMappingProvider() : Void 
	//{
		//injector.map(Clazz);
		//listenToInjectorEvent(MappingEvent.POST_MAPPING_CHANGE);
		//injector.map(Clazz).asSingleton();
		//assertThat(receivedInjectorEvents.pop(), equalTo(MappingEvent.POST_MAPPING_CHANGE));
	//}
//
	//public function testInjectorDispatchesEventBeforeChangingMappingStrength() : Void 
	//{
		//injector.map(Clazz);
		//listenToInjectorEvent(MappingEvent.PRE_MAPPING_CHANGE);
		//injector.map(Clazz).soft();
		//assertThat(receivedInjectorEvents.pop(), equalTo(MappingEvent.PRE_MAPPING_CHANGE));
	//}
//
	//public function teatInjectorDispatchesEventAfterChangingMappingStrength() : Void
	//{
		//injector.map(Clazz);
		//listenToInjectorEvent(MappingEvent.POST_MAPPING_CHANGE);
		//injector.map(Clazz).soft();
		//assertThat(receivedInjectorEvents.pop(), equalTo(MappingEvent.POST_MAPPING_CHANGE));
	//}
//
	//public function teatInjectorDispatchesEventBeforeChangingMappingScope() : Void 
	//{
		//injector.map(Clazz);
		//listenToInjectorEvent(MappingEvent.PRE_MAPPING_CHANGE);
		//injector.map(Clazz).local();
		//assertThat(receivedInjectorEvents.pop(), equalTo(MappingEvent.PRE_MAPPING_CHANGE));
	//}
//
	//public function testInjectorDispatchesEventAfterChangingMappingScope() : Void
	//{
		//injector.map(Clazz);
		//listenToInjectorEvent(MappingEvent.POST_MAPPING_CHANGE);
		//injector.map(Clazz).local();
		//assertThat(receivedInjectorEvents.pop(), equalTo(MappingEvent.POST_MAPPING_CHANGE));
	//}
//
	//public function testInjectorDispatchesEventAfterRemovingMapping() : Void 
	//{
		//injector.map(Clazz);
		//listenToInjectorEvent(MappingEvent.POST_MAPPING_REMOVE);
		//injector.unmap(Clazz);
		//assertThat(receivedInjectorEvents.pop(), equalTo(MappingEvent.POST_MAPPING_REMOVE));
	//}
//
	//public function testInjectorThrowsWhenTryingToCreateMappingForSameTypeFromPreMappingCreateHandler() : Void
	//{
		//var errorThrown : Bool;
		//injector.addEventListener(MappingEvent.PRE_MAPPING_CREATE, function(event : MappingEvent) : Void {
			//try {
				//injector.map(Clazz);
			//}
			//catch(error : InjectorError) {
				//errorThrown = true;
			//}
//
		//});
		//
		//injector.map(Clazz);
		//assertThat(errorThrown, isTrue());
	//}
//
	//public function testInjectorThrowsWhenTryingToCreateMappingForSameTypeFromPostMappingCreateHandler() : Void {
		//var errorThrown : Bool;
		//injector.addEventListener(MappingEvent.POST_MAPPING_CREATE, function(event : MappingEvent) : Void {
			//try {
				//injector.map(Clazz).local();
			//}
			//catch(error : InjectorError) {
				//errorThrown = true;
			//}
//
		//}
//);
		//injector.map(Clazz);
		//assertThat(errorThrown, isTrue());
	//}
//
	//function testConstructMappedTypeAndListenForEvent(eventType : String) : Void 
	//{
		//injector.map(Clazz);
		//listenToInjectorEvent(eventType);
		//injector.getInstance(Clazz);
		//return receivedInjectorEvents.pop() == eventType;
	//}
//
	//function testInjectIntoInstanceAndListenForEvent(eventType : String) : Void 
	//{
		//var injectee : ClassInjectee = new ClassInjectee();
		//injector.map(Clazz).toValue(new Clazz());
		//listenToInjectorEvent(eventType);
		//injector.injectInto(injectee);
		//return receivedInjectorEvents.pop() == eventType;
	//}
//
	//function testCreateMappingAndListenForEvent(eventType : String) : Void 
	//{
		//listenToInjectorEvent(eventType);
		//injector.map(Clazz);
		//return receivedInjectorEvents.pop() == eventType;
	//}
//
	//function testListenToInjectorEvent(eventType : String) : Void 
	//{
		//injector.addEventListener(eventType, function(event : Event) : Void {
			//receivedInjectorEvents.push(event.type);
		//});
	//}
//
	//public function testInjectorMakesInjectParametersAvailableToProviders() : Void 
	//{
		//var provider : UnknownParametersUsingProvider = new UnknownParametersUsingProvider();
		//injector.map(Clazz).toProvider(provider);
		//injector.getInstance(UnknownInjectParametersListInjectee);
		//assertThat(provider.parameterValue, equalTo("true,str,123"));
	//}
//
	//public function testInjectorUsesManuallySuppliedTypeDescriptionForField() : Void 
	//{
		//var description : TypeDescription = new TypeDescription();
		//description.addFieldInjection("property", Clazz);
		//injector.addTypeDescription(NamedClassInjectee, description);
		//injector.map(Clazz);
		//var injectee : NamedClassInjectee = injector.getInstance(NamedClassInjectee);
		//assertThat(injectee.property, isA(Clazz));
	//}
//
	//public function testInjectorUsesManuallySuppliedTypeDescriptionForMethod() : Void 
	//{
		//var description : TypeDescription = new TypeDescription();
		//description.addMethodInjection("setDependency", [Clazz]);
		//injector.addTypeDescription(OneNamedParameterMethodInjectee, description);
		//injector.map(Clazz);
		//var injectee : OneNamedParameterMethodInjectee = injector.getInstance(OneNamedParameterMethodInjectee);
		//assertThat(injectee.getDependency(), isA(Clazz));
	//}
//
	//public function testInjectorUsesManuallySuppliedTypeDescriptionForCtor() : Void 
	//{
		//var description : TypeDescription = new TypeDescription(false);
		//description.setConstructor([Clazz]);
		//injector.addTypeDescription(OneNamedParameterConstructorInjectee, description);
		//injector.map(Clazz);
		//var injectee : OneNamedParameterConstructorInjectee = injector.getInstance(OneNamedParameterConstructorInjectee);
		//assertThat(injectee.getDependency(), isA(Clazz));
	//}
//
	//public function testInjectorUsesManuallySuppliedTypeDescriptionForPostConstructMethod() : Void
	//{
		//var description : TypeDescription = new TypeDescription();
		//description.addPostConstructMethod("doSomeStuff", [Clazz]);
		//injector.addTypeDescription(PostConstructWithArgInjectee, description);
		//injector.map(Clazz);
		//var injectee : PostConstructWithArgInjectee = injector.getInstance(PostConstructWithArgInjectee);
		//assertThat(injectee.property, isA(Clazz));
	//}
//
	//public function testInjectorExecutesInjectedPostConstructMethodVars() : Void 
	//{
		//var callbackInvoked : Bool;
		//injector.map(Function).toValue(function() : Void {
			//callbackInvoked = true;
		//}
//);
		//injector.getInstance(PostConstructInjectedVarInjectee);
		//assertThat(callbackInvoked, isTrue());
	//}
//
	//public function testInjectorExecutesInjectedPostConstructMethodVarsInInjecteeScope() : Void 
	//{
		//injector.map(Function).toValue(function() : Void {
			//this.property = new Clazz();
		//}
//);
		//var injectee : PostConstructInjectedVarInjectee = injector.getInstance(PostConstructInjectedVarInjectee);
		//assertThat(injectee.property, isA(Clazz));
	//}
//
}

