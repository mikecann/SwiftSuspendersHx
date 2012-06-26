/*
* Copyright (c) 2009 the original author or authors
* 
* Permission is hereby granted to use, modify, and distribute this file 
* in accordance with the terms of the license agreement accompanying it.
*/
package org.swiftsuspenders;

import haxe.unit.TestCase;
import org.swiftsuspenders.support.injectees.childinjectors.ChildInjectorCreatingProvider;
import org.swiftsuspenders.support.injectees.ClassInjectee;
import org.swiftsuspenders.support.injectees.childinjectors.InjectorInjectee;
import org.swiftsuspenders.support.injectees.childinjectors.LeftRobotFoot;
import org.swiftsuspenders.support.injectees.childinjectors.RightRobotFoot;
import org.swiftsuspenders.support.injectees.childinjectors.RobotAnkle;
import org.swiftsuspenders.support.injectees.childinjectors.RobotBody;
import org.swiftsuspenders.support.injectees.childinjectors.RobotFoot;
import org.swiftsuspenders.support.injectees.childinjectors.RobotLeg;
import org.swiftsuspenders.support.injectees.childinjectors.RobotToes;
import org.swiftsuspenders.support.types.Clazz;
import org.swiftsuspenders.support.types.Interface;

class ChildInjectorTests extends TestCase
{
	var injector : Injector;
	
	override public function setup() 
	{ 
		injector = new Injector();
	}

	override public function tearDown() 
	{     
		Injector.purgeInjectionPointsCache();
		injector = null;
	}

	public function testInjectorCreatesChildInjector() : Void 
	{
		assertTrue(true);
		var childInjector = injector.createChildInjector();
		assertTrue(Std.is(childInjector, Injector)); // "injector.createChildInjector should return an injector"
	}

	public function testIjectorUsesChildInjectorForSpecifiedMapping() : Void 
	{
		injector.map(RobotFoot);
		var leftFootMapping = injector.map(RobotLeg, "leftLeg");
		var leftChildInjector = injector.createChildInjector();
		leftChildInjector.map(RobotAnkle);
		leftChildInjector.map(RobotFoot).toType(LeftRobotFoot);
		leftFootMapping.setInjector(leftChildInjector);
		var rightFootMapping = injector.map(RobotLeg, "rightLeg");
		var rightChildInjector = injector.createChildInjector();
		rightChildInjector.map(RobotAnkle);
		rightChildInjector.map(RobotFoot).toType(RightRobotFoot);
		rightFootMapping.setInjector(rightChildInjector);
		var robotBody = injector.getInstance(RobotBody);
		assertTrue(Std.is(robotBody.rightLeg.ankle.foot, RightRobotFoot)); // Right RobotLeg should have a RightRobotFoot
		assertTrue(Std.is(robotBody.leftLeg.ankle.foot, LeftRobotFoot)); // Left RobotLeg should have a LeftRobotFoot
	}

	public function testChildInjectorUsesParentForMissingMappings() : Void {
		injector.map(RobotFoot);
		injector.map(RobotToes);
		var leftFootMapping = injector.map(RobotLeg, "leftLeg");
		var leftChildInjector = injector.createChildInjector();
		leftChildInjector.map(RobotAnkle);
		leftChildInjector.map(RobotFoot).toType(LeftRobotFoot);
		leftFootMapping.setInjector(leftChildInjector);
		var rightFootMapping = injector.map(RobotLeg, "rightLeg");
		var rightChildInjector = injector.createChildInjector();
		rightChildInjector.map(RobotAnkle);
		rightChildInjector.map(RobotFoot).toType(RightRobotFoot);
		rightFootMapping.setInjector(rightChildInjector);
		var robotBody = injector.getInstance(RobotBody);
		assertTrue(Std.is(robotBody.rightLeg.ankle.foot.toes, RobotToes)); // Right RobotFoot should have toes
		assertTrue(Std.is(robotBody.leftLeg.ankle.foot.toes, RobotToes)); // Left Robotfoot should have a toes
	}

	public function testParentMappedSingletonGetsInitializedByParentWhenInvokedThroughChildInjector() : Void {
		var parentClazz : Clazz = new Clazz();
		injector.map(Clazz).toValue(parentClazz);
		injector.map(ClassInjectee).asSingleton();
		var childInjector : Injector = injector.createChildInjector();
		var childClazz : Clazz = new Clazz();
		childInjector.map(Clazz).toValue(childClazz);
		var classInjectee : ClassInjectee = childInjector.getInstance(ClassInjectee);
		assertTrue(classInjectee.property==parentClazz); // classInjectee.property is injected with value mapped in parent injector
	}

	public function testChildInjectorDoesntReturnToParentAfterUsingParentInjectorForMissingMappings() : Void {
		injector.map(RobotAnkle);
		injector.map(RobotFoot);
		injector.map(RobotToes);
		var leftFootMapping  = injector.map(RobotLeg, "leftLeg");
		var leftChildInjector = injector.createChildInjector();
		leftChildInjector.map(RobotFoot).toType(LeftRobotFoot);
		leftFootMapping.setInjector(leftChildInjector);
		var rightFootMapping = injector.map(RobotLeg, "rightLeg");
		var rightChildInjector = injector.createChildInjector();
		rightChildInjector.map(RobotFoot).toType(RightRobotFoot);
		rightFootMapping.setInjector(rightChildInjector);
		var robotBody = injector.getInstance(RobotBody);
		assertTrue(Std.is(robotBody.rightLeg.ankle.foot,RightRobotFoot)); // Right RobotFoot should have RightRobotFoot
		assertTrue(Std.is(robotBody.leftLeg.ankle.foot,LeftRobotFoot)); // Left RobotFoot should have LeftRobotFoot
	}

	public function testChildInjectorHasMappingWhenExistsOnParentInjector() : Void {
		var childInjector = injector.createChildInjector();
		var class1 = new Clazz();
		injector.map(Clazz).toValue(class1);
		assertTrue(childInjector.satisfies(Clazz)); // Child injector should return true for hasMapping that exists on parent injector
	}
	public function testChildInjectorDoesNotHaveMappingWhenDoesNotExistOnParentInjector() : Void {
		var childInjector = injector.createChildInjector();
		assertFalse(childInjector.satisfies(Interface)); // Child injector should not return true for hasMapping that does not exists on parent injector
	}

	public function testGrandChildInjectorSuppliesInjectionFromAncestor() : Void {
		var childInjector : Injector;
		var grandChildInjector : Injector;
		var injectee = new ClassInjectee();
		injector.map(Clazz).toSingleton(Clazz);
		childInjector = injector.createChildInjector();
		grandChildInjector = childInjector.createChildInjector();
		grandChildInjector.injectInto(injectee);
		assertTrue(Std.is(injectee.property, Clazz)); // injectee has been injected with Clazz instance from grandChildInjector
	}

	//public function testInjectorCanCreateChildInjectorDuringInjection() : Void 
	//{
		//injector.map(Injector).toProvider(new ChildInjectorCreatingProvider());
		//injector.map(InjectorInjectee).toType(InjectorInjectee);
		//var injectee : InjectorInjectee = injector.getInstance(InjectorInjectee);
		//assertTrue(injectee.injector!=null); // Injection has been applied to injectorInjectee
		//assertTrue(injectee.injector.parentInjector == injector); // injectorInjectee.injector is child of main injector
		//assertTrue(injectee.nestedInjectee.nestedInjectee.injector.parentInjector.parentInjector.parentInjector == injector); // injectorInjectee.nestedInjectee is grandchild of main injector
	//}

}

