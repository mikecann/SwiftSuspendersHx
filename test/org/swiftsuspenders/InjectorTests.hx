/*
 * Copyright (c) 2012 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */
package org.swiftsuspenders;
import haxe.unit.TestCase;
import org.swiftsuspenders.dependencyproviders.OtherMappingProvider;
import org.swiftsuspenders.haxe.Error;
import org.swiftsuspenders.support.injectees.ClassInjectee;
import org.swiftsuspenders.support.injectees.ComplexClassInjectee;
import org.swiftsuspenders.support.injectees.InterfaceInjectee;
import org.swiftsuspenders.support.injectees.MixedParametersConstructorInjectee;
import org.swiftsuspenders.support.injectees.MixedParametersMethodInjectee;
import org.swiftsuspenders.support.injectees.MultipleNamedSingletonsOfSameClassInjectee;
import org.swiftsuspenders.support.injectees.MultipleSingletonsOfSameClassInjectee;
import org.swiftsuspenders.support.injectees.NamedClassInjectee;
import org.swiftsuspenders.support.injectees.NamedInterfaceInjectee;
import org.swiftsuspenders.support.injectees.OneNamedParameterConstructorInjectee;
import org.swiftsuspenders.support.injectees.OneNamedParameterMethodInjectee;
import org.swiftsuspenders.support.injectees.OneParameterConstructorInjectee;
import org.swiftsuspenders.support.injectees.OneParameterMethodInjectee;
import org.swiftsuspenders.support.injectees.RecursiveInterfaceInjectee;
import org.swiftsuspenders.support.injectees.SetterInjectee;
import org.swiftsuspenders.support.injectees.StringInjectee;
import org.swiftsuspenders.support.injectees.TwoNamedInterfaceFieldsInjectee;
import org.swiftsuspenders.support.injectees.TwoNamedParametersConstructorInjectee;
import org.swiftsuspenders.support.injectees.TwoNamedParametersMethodInjectee;
import org.swiftsuspenders.support.injectees.TwoParametersConstructorInjectee;
import org.swiftsuspenders.support.injectees.TwoParametersMethodInjectee;
import org.swiftsuspenders.support.types.Clazz;
import org.swiftsuspenders.support.types.Clazz2;
import org.swiftsuspenders.support.types.ComplexClazz;
import org.swiftsuspenders.support.types.Interface;
import org.swiftsuspenders.support.types.Interface2;

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
	
	public function testUnbindRemovesMapping()
	{
		var injectee = new InterfaceInjectee();
		var value = new Clazz();
		injector.map(Interface).toValue(value);
		assertTrue(injector.satisfies(Interface));
		injector.unmap(Interface);
		assertFalse(injector.satisfies(Interface));
	}
	
	public function testInjectorInjectsBoundValueIntoAllInjectees() : Void 
	{
		var injectee = new ClassInjectee();
		var injectee2 = new ClassInjectee();
		var value = new Clazz();
		injector.map(Clazz).toValue(value);
		injector.injectInto(injectee);
		
		assertEquals(value, injectee.property);
		injector.injectInto(injectee2);
		assertEquals(injectee.property, injectee2.property);
	}

	public function testBindValueByInterface() : Void 
	{
		var injectee = new InterfaceInjectee();
		var value = new Clazz();
		injector.map(Interface).toValue(value);
		injector.injectInto(injectee);
		assertTrue(value==injectee.property);
	}	

	public function testBindNamedValue() : Void 
	{
		var injectee = new NamedClassInjectee();
		var value = new Clazz();
		injector.map(Clazz, NamedClassInjectee.NAME).toValue(value);
		injector.injectInto(injectee);
		assertEquals(value, injectee.property);
	}

	public function testBindNamedValueByInterface() : Void
	{
		var injectee = new NamedInterfaceInjectee();
		var value = new Clazz();
		injector.map(Interface, NamedClassInjectee.NAME).toValue(value);
		injector.injectInto(injectee);
		assertTrue(value==injectee.property);
	}

	public function testBindFalsyValue() : Void 
	{
		var injectee = new StringInjectee();
		var value : String = null;
		injector.map(String).toValue(value);
		injector.injectInto(injectee);
		assertEquals(value, injectee.property);
	}

	public function testBoundValueIsNotInjectedInto() : Void 
	{
		var injectee = new RecursiveInterfaceInjectee();
		var value = new InterfaceInjectee();
		injector.map(InterfaceInjectee).toValue(value);
		injector.injectInto(injectee);
		assertTrue(value.property == null);
	}

	public function testBindMultipleInterfacesToOneSingletonClass() : Void 
	{
		var injectee = new MultipleSingletonsOfSameClassInjectee();
		injector.map(Interface).toSingleton(Clazz);
		injector.map(Interface2).toSingleton(Clazz);
		injector.injectInto(injectee);
		assertTrue(injectee.property1 != null); // Singleton Value for 'property1' should have been injected
		assertTrue(injectee.property2 != null); // Singleton Value for 'property2' should have been injected
		//assertTrue(injectee.property1 != injectee.property2); // Singleton Values 'property1' and 'property2' should not be identical
	}

	public function testBindClass() : Void 
	{
		var injectee = new ClassInjectee();
		var injectee2 = new ClassInjectee();
		injector.map(Clazz).toType(Clazz);
		injector.injectInto(injectee);
		assertTrue(injectee.property != null); // Instance of Class should have been injected
		injector.injectInto(injectee2);
		assertTrue(injectee.property != injectee2.property); // Injected values should be different
	}

	public function testBoundClassIsInjectedInto() : Void 
	{
		var injectee = new ComplexClassInjectee();
		var value : Clazz = new Clazz();
		injector.map(Clazz).toValue(value);
		injector.map(ComplexClazz).toType(ComplexClazz);
		injector.injectInto(injectee);
		assertTrue(injectee.property != null); // Complex Value should have been injected
		assertTrue(value == injectee.property.value); // Nested value should have been injected
	}

	public function testBindClassByInterface() : Void 
	{
		var injectee = new InterfaceInjectee();
		injector.map(Interface).toType(Clazz);
		injector.injectInto(injectee);
		assertTrue(injectee.property!=null); // Instance of Class should have been injected
	}

	public function testBindNamedClass() : Void 
	{
		var injectee = new NamedClassInjectee();
		injector.map(Clazz, NamedClassInjectee.NAME).toType(Clazz);
		injector.injectInto(injectee);
		assertTrue(injectee.property!=null); // Instance of named Class should have been injected
	}

	public function testBindNamedClassByInterface() : Void 
	{
		var injectee : NamedInterfaceInjectee = new NamedInterfaceInjectee();
		injector.map(Interface, NamedClassInjectee.NAME).toType(Clazz);
		injector.injectInto(injectee);
		assertTrue(injectee.property!=null); // Instance of named Class should have been injected
	}

	public function testBindSingleton() : Void 
	{
		var injectee = new ClassInjectee();
		var injectee2 = new ClassInjectee();
		injector.map(Clazz).toSingleton(Clazz);
		injector.injectInto(injectee);
		assertTrue(injectee.property != null); // Instance of Class should have been injected
		injector.injectInto(injectee2);
		assertEquals(injectee.property, injectee2.property); // Injected values should be equal
	}

	public function testBindSingletonOf() : Void 
	{
		var injectee = new InterfaceInjectee();
		var injectee2 = new InterfaceInjectee();
		injector.map(Interface).toSingleton(Clazz);
		injector.injectInto(injectee);
		assertTrue(injectee.property != null); // Instance of Class should have been injected
		injector.injectInto(injectee2);
		assertTrue(injectee.property == injectee2.property); // Injected values should be equal
	}

	public function testBindDifferentlyNamedSingletonsBySameInterface() : Void 
	{
		var injectee = new TwoNamedInterfaceFieldsInjectee();
		injector.map(Interface, "Name1").toSingleton(Clazz);
		injector.map(Interface, "Name2").toSingleton(Clazz2);
		injector.injectInto(injectee);
		assertTrue(Std.is(injectee.property1, Clazz)); // Property \"property1\" should be of type \"Clazz\"
		assertTrue(Std.is(injectee.property2, Clazz2)); // roperty \"property2\" should be of type \"Clazz2\"
		assertTrue(injectee.property1 != injectee.property2); // Properties \"property1\" and \"property2\" should have received different singletons
	}	

	public function testPerformSetterInjection() : Void 
	{
		var injectee = new SetterInjectee();
		var injectee2 = new SetterInjectee();
		injector.map(Clazz).toType(Clazz);
		injector.injectInto(injectee);
		assertTrue(injectee.property != null); // Instance of Class should have been injected
		injector.injectInto(injectee2);
		assertTrue(injectee.property != injectee2.property); // Injected values should be different
	}

	public function testPerformMethodInjectionWithOneParameter() : Void
	{
		var injectee = new OneParameterMethodInjectee();
		var injectee2 = new OneParameterMethodInjectee();
		injector.map(Clazz).toType(Clazz);
		injector.injectInto(injectee);
		assertTrue(injectee.getDependency() != null); // Instance of Class should have been injected
		injector.injectInto(injectee2);
		assertTrue(injectee.getDependency() != injectee2.getDependency()); // Injected values should be different
	}

	public function testPerformMethodInjectionWithOneNamedParameter() : Void 
	{
		var injectee = new OneNamedParameterMethodInjectee();
		var injectee2 = new OneNamedParameterMethodInjectee();
		injector.map(Clazz, "namedDep").toType(Clazz);
		injector.injectInto(injectee);
		assertTrue(injectee.getDependency() != null); // Instance of Class should have been injected for named Clazz parameter
		injector.injectInto(injectee2);
		assertTrue(injectee.getDependency() != injectee2.getDependency()); // Injected values should be different
	}

	public function testPerformMethodInjectionWithTwoParameters() : Void 
	{
		var injectee = new TwoParametersMethodInjectee();
		var injectee2 = new TwoParametersMethodInjectee();
		injector.map(Clazz).toType(Clazz);
		injector.map(Interface).toType(Clazz);
		injector.injectInto(injectee);
		assertTrue(injectee.getDependency() != null); // Instance of Class should have been injected for unnamed Clazz parameter
		assertTrue(injectee.getDependency2() != null); // Instance of Class should have been injected for unnamed Interface parameter
		injector.injectInto(injectee2);
		assertTrue(injectee.getDependency() != injectee2.getDependency()); // Injected values should be different
		assertTrue(injectee.getDependency2() != injectee2.getDependency2()); // Injected values for Interface should be different
	}

	public function testPerformMethodInjectionWithTwoNamedParameters() : Void 
	{
		var injectee = new TwoNamedParametersMethodInjectee();
		var injectee2 = new TwoNamedParametersMethodInjectee();
		injector.map(Clazz, "namedDep").toType(Clazz);
		injector.map(Interface, "namedDep2").toType(Clazz);
		injector.injectInto(injectee);
		assertTrue(injectee.getDependency() != null); // Instance of Class should have been injected for named Clazz parameter
		assertTrue(injectee.getDependency2() != null); // Instance of Class should have been injected for named Interface parameter
		injector.injectInto(injectee2);
		assertTrue(injectee.getDependency() != injectee2.getDependency()); // Injected values should be different
		assertTrue(injectee.getDependency2() != injectee2.getDependency2()); // Injected values for Interface should be different
	}

	public function testPerformMethodInjectionWithMixedParameters() : Void 
	{
		var injectee = new MixedParametersMethodInjectee();
		var injectee2 = new MixedParametersMethodInjectee();
		injector.map(Clazz, "namedDep").toType(Clazz);
		injector.map(Clazz).toType(Clazz);
		injector.map(Interface, "namedDep2").toType(Clazz);
		injector.injectInto(injectee);
		assertTrue(injectee.getDependency() != null); // Instance of Class should have been injected for named Clazz parameter
		assertTrue(injectee.getDependency2() != null); // Instance of Class should have been injected for unnamed Clazz parameter
		assertTrue(injectee.getDependency3() != null); // Instance of Class should have been injected for Interface
		injector.injectInto(injectee2);
		assertTrue(injectee.getDependency() != injectee2.getDependency()); // Injected values for named Clazz should be different
		assertTrue(injectee.getDependency2() != injectee2.getDependency2()); // Injected values for unnamed Clazz should be different
		assertTrue(injectee.getDependency3() != injectee2.getDependency3()); // Injected values for named Interface should be different
	}	

	public function testPerformConstructorInjectionWithOneParameter() : Void 
	{
		injector.map(Clazz);
		var injectee = injector.getInstance(OneParameterConstructorInjectee);
		assertTrue(injectee.getDependency() != null); // Instance of Class should have been injected for Clazz parameter
	}

	public function testPerformConstructorInjectionWithTwoParameters() : Void 
	{
		injector.map(Clazz);
		injector.map(String).toValue("stringDependency");
		var injectee = injector.getInstance(TwoParametersConstructorInjectee);
		assertTrue(injectee.getDependency() != null); // Instance of Class should have been injected for named Clazz parameter
		assertTrue(injectee.getDependency2()=="stringDependency"); // The String 'stringDependency' should have been injected for String parameter
	}

	public function testPerformConstructorInjectionWithOneNamedParameter() : Void 
	{
		injector.map(Clazz, "namedDependency").toType(Clazz);
		var injectee = injector.getInstance(OneNamedParameterConstructorInjectee);
		assertTrue(injectee.getDependency()!=null); // Instance of Class should have been injected for named Clazz parameter
	}

	public function testPerformXMLConfiguredConstructorInjectionWithOneNamedParameter() : Void 
	{
		injector = new Injector();
		injector.map(Clazz, "namedDependency").toType(Clazz);
		var injectee = injector.getInstance(OneNamedParameterConstructorInjectee);
		assertTrue(injectee.getDependency()!=null); // Instance of Class should have been injected for named Clazz parameter
	}

	public function testPerformConstructorInjectionWithTwoNamedParameter() : Void 
	{
		injector.map(Clazz, "namedDependency").toType(Clazz);
		injector.map(String, "namedDependency2").toValue("stringDependency");
		var injectee = injector.getInstance(TwoNamedParametersConstructorInjectee);
		assertTrue(injectee.getDependency() != null); // Instance of Class should have been injected for named Clazz parameter
		assertTrue(injectee.getDependency2()== "stringDependency"); // The String 'stringDependency' should have been injected for named String parameter
	}

	public function testPerformConstructorInjectionWithMixedParameters() : Void 
	{
		injector.map(Clazz, "namedDep").toType(Clazz);
		injector.map(Clazz).toType(Clazz);
		injector.map(Interface, "namedDep2").toType(Clazz);
		var injectee = injector.getInstance(MixedParametersConstructorInjectee);
		assertTrue(injectee.getDependency()!=null); // Instance of Class should have been injected for named Clazz parameter
		assertTrue(injectee.getDependency2()!=null); // Instance of Class should have been injected for unnamed Clazz parameter
		assertTrue(injectee.getDependency3()!=null); // Instance of Class should have been injected for Interface
	}

	//public function testPerformNamedArrayInjection() : Void 
	//{
		//var ac : ArrayCollection = new ArrayCollection();
		//injector.map(ArrayCollection, "namedCollection").toValue(ac);
		//var injectee : NamedArrayCollectionInjectee = injector.getInstance(NamedArrayCollectionInjectee);
		//Assert.assertNotNull("Instance 'ac' should have been injected for named ArrayCollection parameter", injectee.ac);
		//Assert.assertEquals("Instance field 'ac' should be identical to local variable 'ac'", ac, injectee.ac);
	//}

	public function testPerformMappedMappingInjection() : Void 
	{
		var mapping = injector.map(Interface);
		mapping.toSingleton(Clazz);
		injector.map(Interface2).toProvider(new OtherMappingProvider(mapping));
		var injectee = injector.getInstance(MultipleSingletonsOfSameClassInjectee);
		assertTrue(injectee.property1==injectee.property2); // Instance field 'property1' should be identical to Instance field 'property2'
	}

	public function testPerformMappedNamedMappingInjection() : Void 
	{
		var mapping = injector.map(Interface);
		mapping.toSingleton(Clazz);
		injector.map(Interface2).toProvider(new OtherMappingProvider(mapping));
		injector.map(Interface, "name1").toProvider(new OtherMappingProvider(mapping));
		injector.map(Interface2, "name2").toProvider(new OtherMappingProvider(mapping));
		var injectee = injector.getInstance(MultipleNamedSingletonsOfSameClassInjectee);
		assertTrue(injectee.property1==injectee.property2); // Instance field 'property1' should be identical to Instance field 'property2'
		assertTrue(injectee.property1, injectee.namedProperty1); // Instance field 'property1' should be identical to Instance field 'namedProperty1'
		assertTrue(injectee.property1, injectee.namedProperty2); // Instance field 'property1' should be identical to Instance field 'namedProperty2'
	}	

	//public function testInjectXMLValue() : Void 
	//{
		//var injectee : XMLInjectee = new XMLInjectee();
		//var value = FastXML.parse("<test/>");
		//injector.map(XML).toValue(value);
		//injector.injectInto(injectee);
		//assertTrue(injectee.property==value); // injected value should be indentical to mapped value
	//}

	public function testHaltOnMissingDependency() : Void 
	{
		var errorThrown = false;
		try
		{
			var injectee : InterfaceInjectee = new InterfaceInjectee();
			injector.injectInto(injectee);
		}
		catch (e:Dynamic) { errorThrown = true; }
		assertTrue(errorThrown);
	}

	public function testHaltOnMissingNamedDependency() : Void 
	{		
		var errorThrown = false;
		try
		{
			var injectee : NamedClassInjectee = new NamedClassInjectee();
			injector.injectInto(injectee);
		}
		catch (e:Dynamic) { errorThrown = true; }
		assertTrue(errorThrown);
	}

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

