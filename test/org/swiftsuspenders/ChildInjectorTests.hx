/*
* Copyright (c) 2009 the original author or authors
* 
* Permission is hereby granted to use, modify, and distribute this file 
* in accordance with the terms of the license agreement accompanying it.
*/
package org.swiftsuspenders;

import flexunit.framework.Assert;
import org.swiftsuspenders.support.injectees.ClassInjectee;
import org.swiftsuspenders.support.injectees.childinjectors.ChildInjectorCreatingProvider;
import org.swiftsuspenders.support.injectees.childinjectors.InjectorInjectee;
import org.swiftsuspenders.support.injectees.childinjectors.LeftRobotFoot;
import org.swiftsuspenders.support.injectees.childinjectors.RightRobotFoot;
import org.swiftsuspenders.support.injectees.childinjectors.RobotAnkle;
import org.swiftsuspenders.support.injectees.childinjectors.RobotBody;
import org.swiftsuspenders.support.injectees.childinjectors.RobotFoot;
import org.swiftsuspenders.support.injectees.childinjectors.RobotLeg;
import org.swiftsuspenders.support.injectees.childinjectors.RobotToes;
import org.swiftsuspenders.support.types.Clazz;
import org.swiftsuspenders.utils.SsInternal;

class ChildInjectorTests {

	var injector : Injector;
	@:meta(Before())
	public function runBeforeEachTest() : Void {
		injector = new Injector();
	}

	@:meta(After())
	public function teardown() : Void {
		Injector.SsInternal::purgeInjectionPointsCache();
		injector = null;
	}

	@:meta(Test())
	public function injectorCreatesChildInjector() : Void {
		Assert.assertTrue(true);
		var childInjector : Injector = injector.createChildInjector();
		Assert.assertTrue("injector.createChildInjector should return an injector", Std.is(childInjector, Injector));
	}

	@:meta(Test())
	public function injectorUsesChildInjectorForSpecifiedMapping() : Void {
		injector.map(RobotFoot);
		var leftFootMapping : InjectionMapping = injector.map(RobotLeg, "leftLeg");
		var leftChildInjector : Injector = injector.createChildInjector();
		leftChildInjector.map(RobotAnkle);
		leftChildInjector.map(RobotFoot).toType(LeftRobotFoot);
		leftFootMapping.setInjector(leftChildInjector);
		var rightFootMapping : InjectionMapping = injector.map(RobotLeg, "rightLeg");
		var rightChildInjector : Injector = injector.createChildInjector();
		rightChildInjector.map(RobotAnkle);
		rightChildInjector.map(RobotFoot).toType(RightRobotFoot);
		rightFootMapping.setInjector(rightChildInjector);
		var robotBody : RobotBody = injector.getInstance(RobotBody);
		Assert.assertTrue("Right RobotLeg should have a RightRobotFoot", Std.is(robotBody.rightLeg.ankle.foot, RightRobotFoot));
		Assert.assertTrue("Left RobotLeg should have a LeftRobotFoot", Std.is(robotBody.leftLeg.ankle.foot, LeftRobotFoot));
	}

	@:meta(Test())
	public function childInjectorUsesParentForMissingMappings() : Void {
		injector.map(RobotFoot);
		injector.map(RobotToes);
		var leftFootMapping : InjectionMapping = injector.map(RobotLeg, "leftLeg");
		var leftChildInjector : Injector = injector.createChildInjector();
		leftChildInjector.map(RobotAnkle);
		leftChildInjector.map(RobotFoot).toType(LeftRobotFoot);
		leftFootMapping.setInjector(leftChildInjector);
		var rightFootMapping : InjectionMapping = injector.map(RobotLeg, "rightLeg");
		var rightChildInjector : Injector = injector.createChildInjector();
		rightChildInjector.map(RobotAnkle);
		rightChildInjector.map(RobotFoot).toType(RightRobotFoot);
		rightFootMapping.setInjector(rightChildInjector);
		var robotBody : RobotBody = injector.getInstance(RobotBody);
		Assert.assertTrue("Right RobotFoot should have toes", Std.is(robotBody.rightLeg.ankle.foot.toes, RobotToes));
		Assert.assertTrue("Left Robotfoot should have a toes", Std.is(robotBody.leftLeg.ankle.foot.toes, RobotToes));
	}

	@:meta(Test())
	public function parentMappedSingletonGetsInitializedByParentWhenInvokedThroughChildInjector() : Void {
		var parentClazz : Clazz = new Clazz();
		injector.map(Clazz).toValue(parentClazz);
		injector.map(ClassInjectee).asSingleton();
		var childInjector : Injector = injector.createChildInjector();
		var childClazz : Clazz = new Clazz();
		childInjector.map(Clazz).toValue(childClazz);
		var classInjectee : ClassInjectee = childInjector.getInstance(ClassInjectee);
		Assert.assertEquals("classInjectee.property is injected with value mapped in parent injector", classInjectee.property, parentClazz);
	}

	@:meta(Test())
	public function childInjectorDoesntReturnToParentAfterUsingParentInjectorForMissingMappings() : Void {
		injector.map(RobotAnkle);
		injector.map(RobotFoot);
		injector.map(RobotToes);
		var leftFootMapping : InjectionMapping = injector.map(RobotLeg, "leftLeg");
		var leftChildInjector : Injector = injector.createChildInjector();
		leftChildInjector.map(RobotFoot).toType(LeftRobotFoot);
		leftFootMapping.setInjector(leftChildInjector);
		var rightFootMapping : InjectionMapping = injector.map(RobotLeg, "rightLeg");
		var rightChildInjector : Injector = injector.createChildInjector();
		rightChildInjector.map(RobotFoot).toType(RightRobotFoot);
		rightFootMapping.setInjector(rightChildInjector);
		var robotBody : RobotBody = injector.getInstance(RobotBody);
		Assert.assertEquals("Right RobotFoot should have RightRobotFoot", RightRobotFoot, robotBody.rightLeg.ankle.foot["constructor"]);
		Assert.assertTrue("Left RobotFoot should have LeftRobotFoot", LeftRobotFoot, robotBody.leftLeg.ankle.foot["constructor"]);
	}

	@:meta(Test())
	public function childInjectorHasMappingWhenExistsOnParentInjector() : Void {
		var childInjector : Injector = injector.createChildInjector();
		var class1 : Clazz = new Clazz();
		injector.map(Clazz).toValue(class1);
		Assert.assertTrue("Child injector should return true for hasMapping that exists on parent injector", childInjector.satisfies(Clazz));
	}

	@:meta(Test())
	public function childInjectorDoesNotHaveMappingWhenDoesNotExistOnParentInjector() : Void {
		var childInjector : Injector = injector.createChildInjector();
		Assert.assertFalse("Child injector should not return true for hasMapping that does not exists on parent injector", childInjector.satisfies(Clazz));
	}

	@:meta(Test())
	public function grandChildInjectorSuppliesInjectionFromAncestor() : Void {
		var childInjector : Injector;
		var grandChildInjector : Injector;
		var injectee : ClassInjectee = new ClassInjectee();
		injector.map(Clazz).toSingleton(Clazz);
		childInjector = injector.createChildInjector();
		grandChildInjector = childInjector.createChildInjector();
		grandChildInjector.injectInto(injectee);
		Assert.assertTrue("injectee has been injected with Clazz instance from grandChildInjector", Std.is(injectee.property, Clazz));
	}

	@:meta(Test())
	public function injectorCanCreateChildInjectorDuringInjection() : Void {
		injector.map(Injector).toProvider(new ChildInjectorCreatingProvider());
		injector.map(InjectorInjectee).toType(InjectorInjectee);
		var injectee : InjectorInjectee = injector.getInstance(InjectorInjectee);
		Assert.assertNotNull("Injection has been applied to injectorInjectee", injectee.injector);
		Assert.assertTrue("injectorInjectee.injector is child of main injector", injectee.injector.parentInjector == injector);
		Assert.assertTrue("injectorInjectee.nestedInjectee is grandchild of main injector", injectee.nestedInjectee.nestedInjectee.injector.parentInjector.parentInjector.parentInjector == injector);
	}


	public function new() {
	}
}

