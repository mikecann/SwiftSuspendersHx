/*
 * Copyright (c) 2012 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */
package org.swiftsuspenders;

import org.flexunit.Assert;
import org.hamcrest.AssertThat;
import org.hamcrest.core.IsA;
import org.hamcrest.object.HasProperties;
import org.hamcrest.object.IsTrue;
import org.hamcrest.object.NotNullValue;
import org.swiftsuspenders.support.injectees.PostConstructGetterInjectee;
import org.swiftsuspenders.support.injectees.PostConstructInjectedVarInjectee;
import org.swiftsuspenders.support.injectees.PostConstructVarInjectee;
import org.swiftsuspenders.support.injectees.UnknownInjectParametersInjectee;
import org.swiftsuspenders.support.injectees.UnknownInjectParametersListInjectee;
import org.swiftsuspenders.typedescriptions.ConstructorInjectionPoint;
import org.swiftsuspenders.typedescriptions.InjectionPoint;
import org.swiftsuspenders.typedescriptions.NoParamsConstructorInjectionPoint;
import org.swiftsuspenders.typedescriptions.PostConstructInjectionPoint;
import org.swiftsuspenders.typedescriptions.PreDestroyInjectionPoint;
import org.swiftsuspenders.support.injectees.InterfaceInjectee;
import org.swiftsuspenders.support.injectees.NamedInterfaceInjectee;
import org.swiftsuspenders.support.injectees.OneNamedParameterConstructorInjectee;
import org.swiftsuspenders.support.injectees.OneNamedParameterMethodInjectee;
import org.swiftsuspenders.support.injectees.OneParameterConstructorInjectee;
import org.swiftsuspenders.support.injectees.OneParameterMethodInjectee;
import org.swiftsuspenders.support.injectees.OneRequiredOneOptionalPropertyMethodInjectee;
import org.swiftsuspenders.support.injectees.OptionalClassInjectee;
import org.swiftsuspenders.support.injectees.OptionalOneRequiredParameterMethodInjectee;
import org.swiftsuspenders.support.injectees.OrderedPostConstructInjectee;
import org.swiftsuspenders.support.injectees.OrderedPreDestroyInjectee;
import org.swiftsuspenders.support.injectees.TwoNamedParametersMethodInjectee;
import org.swiftsuspenders.support.types.Clazz;
import org.swiftsuspenders.support.types.ClazzExtension;
import org.swiftsuspenders.support.types.Interface;
import org.swiftsuspenders.typedescriptions.PropertyInjectionPoint;
import org.swiftsuspenders.typedescriptions.TypeDescription;
import org.swiftsuspenders.utils.SsInternal;

class ReflectorTests {

	static inline var CLAZZ_FQCN_COLON_NOTATION : String = "org.swiftsuspenders.support.types::Clazz";
	static inline var CLAZZ_FQCN_DOT_NOTATION : String = "org.swiftsuspenders.support.types.Clazz";
	static inline var CLASS_IN_ROOT_PACKAGE : Class<Dynamic> = Date;
	static inline var CLASS_NAME_IN_ROOT_PACKAGE : String = "Date";
	var reflector : Reflector;
	var injector : Injector;
	@:meta(After())
	public function teardown() : Void {
		reflector = null;
		Injector.SsInternal::purgeInjectionPointsCache();
		injector = null;
	}

	@:meta(Test())
	public function classExtendsClass() : Void {
		var isClazz : Bool = reflector.typeImplements(ClazzExtension, Clazz);
		Assert.assertTrue("ClazzExtension should be an extension of Clazz", isClazz);
	}

	@:meta(Test())
	public function classImplementsInterface() : Void {
		var implemented : Bool = reflector.typeImplements(ClazzExtension, Interface);
		Assert.assertTrue("ClazzExtension should implement Interface", implemented);
	}

	@:meta(Test())
	public function getFullyQualifiedClassNameFromClass() : Void {
		var fqcn : String = reflector.getFQCN(Clazz);
		Assert.assertEquals(CLAZZ_FQCN_COLON_NOTATION, fqcn);
	}

	@:meta(Test())
	public function getFullyQualifiedClassNameFromClassReplacingColons() : Void {
		var fqcn : String = reflector.getFQCN(Clazz, true);
		Assert.assertEquals(CLAZZ_FQCN_DOT_NOTATION, fqcn);
	}

	@:meta(Test())
	public function getFullyQualifiedClassNameFromClassString() : Void {
		var fqcn : String = reflector.getFQCN(CLAZZ_FQCN_DOT_NOTATION);
		Assert.assertEquals(CLAZZ_FQCN_COLON_NOTATION, fqcn);
	}

	@:meta(Test())
	public function getFullyQualifiedClassNameFromClassStringReplacingColons() : Void {
		var fqcn : String = reflector.getFQCN(CLAZZ_FQCN_DOT_NOTATION, true);
		Assert.assertEquals(CLAZZ_FQCN_DOT_NOTATION, fqcn);
	}

	@:meta(Test())
	public function getFullyQualifiedClassNameFromClassInRootPackage() : Void {
		var fqcn : String = reflector.getFQCN(CLASS_IN_ROOT_PACKAGE);
		Assert.assertEquals(CLASS_NAME_IN_ROOT_PACKAGE, fqcn);
	}

	@:meta(Test())
	public function getFullyQualifiedClassNameFromClassStringInRootPackage() : Void {
		var fqcn : String = reflector.getFQCN(CLASS_NAME_IN_ROOT_PACKAGE);
		Assert.assertEquals(CLASS_NAME_IN_ROOT_PACKAGE, fqcn);
	}

	@:meta(Test())
	public function getFullyQualifiedClassNameFromClassInRootPackageReplacingColons() : Void {
		var fqcn : String = reflector.getFQCN(CLASS_IN_ROOT_PACKAGE, true);
		Assert.assertEquals(CLASS_NAME_IN_ROOT_PACKAGE, fqcn);
	}

	@:meta(Test())
	public function getFullyQualifiedClassNameFromClassStringInRootPackageReplacingColons() : Void {
		var fqcn : String = reflector.getFQCN(CLASS_NAME_IN_ROOT_PACKAGE, true);
		Assert.assertEquals(CLASS_NAME_IN_ROOT_PACKAGE, fqcn);
	}

	@:meta(Test())
	public function reflectorReturnsNoParamsCtorInjectionPointForNoParamsCtor() : Void {
		var injectionPoint : InjectionPoint = reflector.describeInjections(Clazz).ctor;
		Assert.assertTrue("reflector-returned injectionPoint is no-params ctor injectionPoint", Std.is(injectionPoint, NoParamsConstructorInjectionPoint));
	}

	@:meta(Test())
	public function reflectorReturnsCorrectCtorInjectionPointForParamsCtor() : Void {
		var injectionPoint : InjectionPoint = reflector.describeInjections(OneParameterConstructorInjectee).ctor;
		Assert.assertTrue("reflector-returned injectionPoint is ctor injectionPoint", Std.is(injectionPoint, ConstructorInjectionPoint));
	}

	@:meta(Test())
	public function reflectorReturnsCorrectCtorInjectionPointForNamedParamsCtor() : Void {
		var injectionPoint : ConstructorInjectionPoint = reflector.describeInjections(OneNamedParameterConstructorInjectee).ctor;
		Assert.assertTrue("reflector-returned injectionPoint is ctor injectionPoint", Std.is(injectionPoint, ConstructorInjectionPoint));
		injector.map(Clazz, "namedDependency").toType(Clazz);
		var injectee : OneNamedParameterConstructorInjectee = cast((injectionPoint.createInstance(OneNamedParameterConstructorInjectee, injector)), OneNamedParameterConstructorInjectee);
		Assert.assertNotNull("Instance of Clazz should have been injected for named Clazz parameter", injectee.getDependency());
	}

	@:meta(Test())
	public function reflectorCorrectlyCreatesInjectionPointForUnnamedPropertyInjection() : Void {
		var description : TypeDescription = reflector.describeInjections(InterfaceInjectee);
		assertThat(description.injectionPoints, isA(PropertyInjectionPoint));
	}

	@:meta(Test())
	public function reflectorCorrectlyCreatesInjectionPointForNamedPropertyInjection() : Void {
		var description : TypeDescription = reflector.describeInjections(NamedInterfaceInjectee);
		assertThat(description.injectionPoints, isA(PropertyInjectionPoint));
	}

	@:meta(Test())
	public function reflectorCorrectlyCreatesInjectionPointForOptionalPropertyInjection() : Void {
		var description : TypeDescription = reflector.describeInjections(OptionalClassInjectee);
		var injectee : OptionalClassInjectee = new OptionalClassInjectee();
		description.injectionPoints.applyInjection(injectee, OptionalClassInjectee, injector);
		Assert.assertNull("Instance of Clazz should not have been injected for Clazz property", injectee.property);
	}

	@:meta(Test())
	public function reflectorCorrectlyCreatesInjectionPointForOneParamMethodInjection() : Void {
		var description : TypeDescription = reflector.describeInjections(OneParameterMethodInjectee);
		var injectee : OneParameterMethodInjectee = new OneParameterMethodInjectee();
		injector.map(Clazz);
		description.injectionPoints.applyInjection(injectee, OneParameterMethodInjectee, injector);
		Assert.assertNotNull("Instance of Clazz should have been injected for Clazz dependency", injectee.getDependency());
	}

	@:meta(Test())
	public function reflectorCorrectlyCreatesInjectionPointForOneNamedParamMethodInjection() : Void {
		var description : TypeDescription = reflector.describeInjections(OneNamedParameterMethodInjectee);
		var injectee : OneNamedParameterMethodInjectee = new OneNamedParameterMethodInjectee();
		injector.map(Clazz, "namedDep");
		description.injectionPoints.applyInjection(injectee, OneNamedParameterMethodInjectee, injector);
		Assert.assertNotNull("Instance of Clazz should have been injected for Clazz dependency", injectee.getDependency());
	}

	@:meta(Test())
	public function reflectorCorrectlyCreatesInjectionPointForTwoNamedParamsMethodInjection() : Void {
		var description : TypeDescription = reflector.describeInjections(TwoNamedParametersMethodInjectee);
		var injectee : TwoNamedParametersMethodInjectee = new TwoNamedParametersMethodInjectee();
		injector.map(Clazz, "namedDep");
		injector.map(Interface, "namedDep2").toType(Clazz);
		description.injectionPoints.applyInjection(injectee, TwoNamedParametersMethodInjectee, injector);
		Assert.assertNotNull("Instance of Clazz should have been injected for Clazz dependency", injectee.getDependency());
		Assert.assertNotNull("Instance of Clazz should have been injected for Interface dependency", injectee.getDependency2());
	}

	@:meta(Test())
	public function reflectorCorrectlyCreatesInjectionPointForOneRequiredOneOptionalParamsMethodInjection() : Void {
		var description : TypeDescription = reflector.describeInjections(OneRequiredOneOptionalPropertyMethodInjectee);
		var injectee : OneRequiredOneOptionalPropertyMethodInjectee = new OneRequiredOneOptionalPropertyMethodInjectee();
		injector.map(Clazz);
		description.injectionPoints.applyInjection(injectee, OneRequiredOneOptionalPropertyMethodInjectee, injector);
		Assert.assertNotNull("Instance of Clazz should have been injected for Clazz dependency", injectee.getDependency());
		Assert.assertNull("Instance of Clazz should not have been injected for Interface dependency", injectee.getDependency2());
	}

	@:meta(Test())
	public function reflectorCorrectlyCreatesInjectionPointForOptionalOneRequiredParamMethodInjection() : Void {
		var description : TypeDescription = reflector.describeInjections(OptionalOneRequiredParameterMethodInjectee);
		var injectee : OptionalOneRequiredParameterMethodInjectee = new OptionalOneRequiredParameterMethodInjectee();
		description.injectionPoints.applyInjection(injectee, OptionalOneRequiredParameterMethodInjectee, injector);
		Assert.assertNull("Instance of Clazz should not have been injected for Clazz dependency", injectee.getDependency());
	}

	@:meta(Test())
	public function reflectorCreatesInjectionPointsForPostConstructMethods() : Void {
		var first : InjectionPoint = reflector.describeInjections(OrderedPostConstructInjectee).injectionPoints;
		Assert.assertTrue("Four injection points have been added", first && first.next && first.next.next && first.next.next.next);
	}

	@:meta(Test())
	public function reflectorCorrectlySortsInjectionPointsForPostConstructMethods() : Void {
		var first : InjectionPoint = reflector.describeInjections(OrderedPostConstructInjectee).injectionPoints;
		Assert.assertEquals("First injection point has order \"1\"", 1, cast((first), PostConstructInjectionPoint).order);
		Assert.assertEquals("Second injection point has order \"2\"", 2, cast((first.next), PostConstructInjectionPoint).order);
		Assert.assertEquals("Third injection point has order \"3\"", 3, cast((first.next.next), PostConstructInjectionPoint).order);
		Assert.assertEquals("Fourth injection point has no order \"int.MAX_VALUE\"", int.MAX_VALUE, cast((first.next.next.next), PostConstructInjectionPoint).order);
	}

	@:meta(Test())
	public function reflectorCreatesInjectionPointsForPreDestroyMethods() : Void {
		var first : InjectionPoint = reflector.describeInjections(OrderedPreDestroyInjectee).preDestroyMethods;
		Assert.assertTrue("Four injection points have been added", first && first.next && first.next.next && first.next.next.next);
	}

	@:meta(Test())
	public function reflectorCorrectlySortsInjectionPointsForPreDestroyMethods() : Void {
		var first : InjectionPoint = reflector.describeInjections(OrderedPreDestroyInjectee).preDestroyMethods;
		Assert.assertEquals("First injection point has order \"1\"", 1, cast((first), PreDestroyInjectionPoint).order);
		Assert.assertEquals("Second injection point has order \"2\"", 2, cast((first.next), PreDestroyInjectionPoint).order);
		Assert.assertEquals("Third injection point has order \"3\"", 3, cast((first.next.next), PreDestroyInjectionPoint).order);
		Assert.assertEquals("Fourth injection point has no order \"int.MAX_VALUE\"", int.MAX_VALUE, cast((first.next.next.next), PreDestroyInjectionPoint).order);
	}

	@:meta(Test())
	public function reflectorStoresUnknownInjectParameters() : Void {
		var first : InjectionPoint = reflector.describeInjections(UnknownInjectParametersInjectee).injectionPoints;
		assertThat(first.injectParameters, hasProperties({
			optional : "true",
			name : "test",
			param1 : "true",
			param2 : "str",
			param3 : "123",

		}));
	}

	@:meta(Test())
	public function reflectorStoresUnknownInjectParametersListAsCSV() : Void {
		var first : InjectionPoint = reflector.describeInjections(UnknownInjectParametersListInjectee).injectionPoints;
		assertThat(first.injectParameters, hasProperties({
			param : "true,str,123"

		}));
	}

	@:meta(Test())
	public function reflectorFindsPostConstructMethodVars() : Void {
		var first : PostConstructInjectionPoint = cast((reflector.describeInjections(PostConstructVarInjectee).injectionPoints), PostConstructInjectionPoint);
		assertThat(first, notNullValue());
	}

	@:meta(Test())
	public function reflectorFindsPostConstructMethodGetters() : Void {
		var first : PostConstructInjectionPoint = cast((reflector.describeInjections(PostConstructGetterInjectee).injectionPoints), PostConstructInjectionPoint);
		assertThat(first, notNullValue());
	}


	public function new() {
	}
}

