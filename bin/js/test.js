var $_, $hxClasses = $hxClasses || {}, $estr = function() { return js.Boot.__string_rec(this,''); }
function $extend(from, fields) {
	function inherit() {}; inherit.prototype = from; var proto = new inherit();
	for (var name in fields) proto[name] = fields[name];
	return proto;
}
var Hash = $hxClasses["Hash"] = function() {
	this.h = { };
};
Hash.__name__ = ["Hash"];
Hash.prototype = {
	h: null
	,set: function(key,value) {
		this.h["$" + key] = value;
	}
	,get: function(key) {
		return this.h["$" + key];
	}
	,exists: function(key) {
		return this.h.hasOwnProperty("$" + key);
	}
	,remove: function(key) {
		key = "$" + key;
		if(!this.h.hasOwnProperty(key)) return false;
		delete(this.h[key]);
		return true;
	}
	,keys: function() {
		var a = [];
		for( var key in this.h ) {
		if(this.h.hasOwnProperty(key)) a.push(key.substr(1));
		}
		return a.iterator();
	}
	,iterator: function() {
		return { ref : this.h, it : this.keys(), hasNext : function() {
			return this.it.hasNext();
		}, next : function() {
			var i = this.it.next();
			return this.ref["$" + i];
		}};
	}
	,toString: function() {
		var s = new StringBuf();
		s.add("{");
		var it = this.keys();
		while( it.hasNext() ) {
			var i = it.next();
			s.add(i);
			s.add(" => ");
			s.add(Std.string(this.get(i)));
			if(it.hasNext()) s.add(", ");
		}
		s.add("}");
		return s.toString();
	}
	,__class__: Hash
}
var IntIter = $hxClasses["IntIter"] = function(min,max) {
	this.min = min;
	this.max = max;
};
IntIter.__name__ = ["IntIter"];
IntIter.prototype = {
	min: null
	,max: null
	,hasNext: function() {
		return this.min < this.max;
	}
	,next: function() {
		return this.min++;
	}
	,__class__: IntIter
}
var List = $hxClasses["List"] = function() {
	this.length = 0;
};
List.__name__ = ["List"];
List.prototype = {
	h: null
	,q: null
	,length: null
	,add: function(item) {
		var x = [item];
		if(this.h == null) this.h = x; else this.q[1] = x;
		this.q = x;
		this.length++;
	}
	,push: function(item) {
		var x = [item,this.h];
		this.h = x;
		if(this.q == null) this.q = x;
		this.length++;
	}
	,first: function() {
		return this.h == null?null:this.h[0];
	}
	,last: function() {
		return this.q == null?null:this.q[0];
	}
	,pop: function() {
		if(this.h == null) return null;
		var x = this.h[0];
		this.h = this.h[1];
		if(this.h == null) this.q = null;
		this.length--;
		return x;
	}
	,isEmpty: function() {
		return this.h == null;
	}
	,clear: function() {
		this.h = null;
		this.q = null;
		this.length = 0;
	}
	,remove: function(v) {
		var prev = null;
		var l = this.h;
		while(l != null) {
			if(l[0] == v) {
				if(prev == null) this.h = l[1]; else prev[1] = l[1];
				if(this.q == l) this.q = prev;
				this.length--;
				return true;
			}
			prev = l;
			l = l[1];
		}
		return false;
	}
	,iterator: function() {
		return { h : this.h, hasNext : function() {
			return this.h != null;
		}, next : function() {
			if(this.h == null) return null;
			var x = this.h[0];
			this.h = this.h[1];
			return x;
		}};
	}
	,toString: function() {
		var s = new StringBuf();
		var first = true;
		var l = this.h;
		s.add("{");
		while(l != null) {
			if(first) first = false; else s.add(", ");
			s.add(Std.string(l[0]));
			l = l[1];
		}
		s.add("}");
		return s.toString();
	}
	,join: function(sep) {
		var s = new StringBuf();
		var first = true;
		var l = this.h;
		while(l != null) {
			if(first) first = false; else s.add(sep);
			s.add(l[0]);
			l = l[1];
		}
		return s.toString();
	}
	,filter: function(f) {
		var l2 = new List();
		var l = this.h;
		while(l != null) {
			var v = l[0];
			l = l[1];
			if(f(v)) l2.add(v);
		}
		return l2;
	}
	,map: function(f) {
		var b = new List();
		var l = this.h;
		while(l != null) {
			var v = l[0];
			l = l[1];
			b.add(f(v));
		}
		return b;
	}
	,__class__: List
}
var Main = $hxClasses["Main"] = function() { }
Main.__name__ = ["Main"];
Main.main = function() {
	var r = new haxe.unit.TestRunner();
	r.add(new org.swiftsuspenders.InjectorTests());
	r.run();
}
Main.prototype = {
	__class__: Main
}
var Reflect = $hxClasses["Reflect"] = function() { }
Reflect.__name__ = ["Reflect"];
Reflect.hasField = function(o,field) {
	return Object.prototype.hasOwnProperty.call(o,field);
}
Reflect.field = function(o,field) {
	var v = null;
	try {
		v = o[field];
	} catch( e ) {
	}
	return v;
}
Reflect.setField = function(o,field,value) {
	o[field] = value;
}
Reflect.getProperty = function(o,field) {
	var tmp;
	return o == null?null:o.__properties__ && (tmp = o.__properties__["get_" + field])?o[tmp]():o[field];
}
Reflect.setProperty = function(o,field,value) {
	var tmp;
	if(o.__properties__ && (tmp = o.__properties__["set_" + field])) o[tmp](value); else o[field] = value;
}
Reflect.callMethod = function(o,func,args) {
	return func.apply(o,args);
}
Reflect.fields = function(o) {
	var a = [];
	if(o != null) {
		var hasOwnProperty = Object.prototype.hasOwnProperty;
		for( var f in o ) {
		if(hasOwnProperty.call(o,f)) a.push(f);
		}
	}
	return a;
}
Reflect.isFunction = function(f) {
	return typeof(f) == "function" && f.__name__ == null;
}
Reflect.compare = function(a,b) {
	return a == b?0:a > b?1:-1;
}
Reflect.compareMethods = function(f1,f2) {
	if(f1 == f2) return true;
	if(!Reflect.isFunction(f1) || !Reflect.isFunction(f2)) return false;
	return f1.scope == f2.scope && f1.method == f2.method && f1.method != null;
}
Reflect.isObject = function(v) {
	if(v == null) return false;
	var t = typeof(v);
	return t == "string" || t == "object" && !v.__enum__ || t == "function" && v.__name__ != null;
}
Reflect.deleteField = function(o,f) {
	if(!Reflect.hasField(o,f)) return false;
	delete(o[f]);
	return true;
}
Reflect.copy = function(o) {
	var o2 = { };
	var _g = 0, _g1 = Reflect.fields(o);
	while(_g < _g1.length) {
		var f = _g1[_g];
		++_g;
		Reflect.setField(o2,f,Reflect.field(o,f));
	}
	return o2;
}
Reflect.makeVarArgs = function(f) {
	return function() {
		var a = Array.prototype.slice.call(arguments);
		return f(a);
	};
}
Reflect.prototype = {
	__class__: Reflect
}
var Std = $hxClasses["Std"] = function() { }
Std.__name__ = ["Std"];
Std["is"] = function(v,t) {
	return js.Boot.__instanceof(v,t);
}
Std.string = function(s) {
	return js.Boot.__string_rec(s,"");
}
Std["int"] = function(x) {
	return x | 0;
}
Std.parseInt = function(x) {
	var v = parseInt(x,10);
	if(v == 0 && x.charCodeAt(1) == 120) v = parseInt(x);
	if(isNaN(v)) return null;
	return v;
}
Std.parseFloat = function(x) {
	return parseFloat(x);
}
Std.random = function(x) {
	return Math.floor(Math.random() * x);
}
Std.prototype = {
	__class__: Std
}
var StringBuf = $hxClasses["StringBuf"] = function() {
	this.b = new Array();
};
StringBuf.__name__ = ["StringBuf"];
StringBuf.prototype = {
	add: function(x) {
		this.b[this.b.length] = x == null?"null":x;
	}
	,addSub: function(s,pos,len) {
		this.b[this.b.length] = s.substr(pos,len);
	}
	,addChar: function(c) {
		this.b[this.b.length] = String.fromCharCode(c);
	}
	,toString: function() {
		return this.b.join("");
	}
	,b: null
	,__class__: StringBuf
}
var StringTools = $hxClasses["StringTools"] = function() { }
StringTools.__name__ = ["StringTools"];
StringTools.urlEncode = function(s) {
	return encodeURIComponent(s);
}
StringTools.urlDecode = function(s) {
	return decodeURIComponent(s.split("+").join(" "));
}
StringTools.htmlEscape = function(s) {
	return s.split("&").join("&amp;").split("<").join("&lt;").split(">").join("&gt;");
}
StringTools.htmlUnescape = function(s) {
	return s.split("&gt;").join(">").split("&lt;").join("<").split("&amp;").join("&");
}
StringTools.startsWith = function(s,start) {
	return s.length >= start.length && s.substr(0,start.length) == start;
}
StringTools.endsWith = function(s,end) {
	var elen = end.length;
	var slen = s.length;
	return slen >= elen && s.substr(slen - elen,elen) == end;
}
StringTools.isSpace = function(s,pos) {
	var c = s.charCodeAt(pos);
	return c >= 9 && c <= 13 || c == 32;
}
StringTools.ltrim = function(s) {
	var l = s.length;
	var r = 0;
	while(r < l && StringTools.isSpace(s,r)) r++;
	if(r > 0) return s.substr(r,l - r); else return s;
}
StringTools.rtrim = function(s) {
	var l = s.length;
	var r = 0;
	while(r < l && StringTools.isSpace(s,l - r - 1)) r++;
	if(r > 0) return s.substr(0,l - r); else return s;
}
StringTools.trim = function(s) {
	return StringTools.ltrim(StringTools.rtrim(s));
}
StringTools.rpad = function(s,c,l) {
	var sl = s.length;
	var cl = c.length;
	while(sl < l) if(l - sl < cl) {
		s += c.substr(0,l - sl);
		sl = l;
	} else {
		s += c;
		sl += cl;
	}
	return s;
}
StringTools.lpad = function(s,c,l) {
	var ns = "";
	var sl = s.length;
	if(sl >= l) return s;
	var cl = c.length;
	while(sl < l) if(l - sl < cl) {
		ns += c.substr(0,l - sl);
		sl = l;
	} else {
		ns += c;
		sl += cl;
	}
	return ns + s;
}
StringTools.replace = function(s,sub,by) {
	return s.split(sub).join(by);
}
StringTools.hex = function(n,digits) {
	var s = "";
	var hexChars = "0123456789ABCDEF";
	do {
		s = hexChars.charAt(n & 15) + s;
		n >>>= 4;
	} while(n > 0);
	if(digits != null) while(s.length < digits) s = "0" + s;
	return s;
}
StringTools.fastCodeAt = function(s,index) {
	return s.cca(index);
}
StringTools.isEOF = function(c) {
	return c != c;
}
StringTools.prototype = {
	__class__: StringTools
}
var ValueType = $hxClasses["ValueType"] = { __ename__ : ["ValueType"], __constructs__ : ["TNull","TInt","TFloat","TBool","TObject","TFunction","TClass","TEnum","TUnknown"] }
ValueType.TNull = ["TNull",0];
ValueType.TNull.toString = $estr;
ValueType.TNull.__enum__ = ValueType;
ValueType.TInt = ["TInt",1];
ValueType.TInt.toString = $estr;
ValueType.TInt.__enum__ = ValueType;
ValueType.TFloat = ["TFloat",2];
ValueType.TFloat.toString = $estr;
ValueType.TFloat.__enum__ = ValueType;
ValueType.TBool = ["TBool",3];
ValueType.TBool.toString = $estr;
ValueType.TBool.__enum__ = ValueType;
ValueType.TObject = ["TObject",4];
ValueType.TObject.toString = $estr;
ValueType.TObject.__enum__ = ValueType;
ValueType.TFunction = ["TFunction",5];
ValueType.TFunction.toString = $estr;
ValueType.TFunction.__enum__ = ValueType;
ValueType.TClass = function(c) { var $x = ["TClass",6,c]; $x.__enum__ = ValueType; $x.toString = $estr; return $x; }
ValueType.TEnum = function(e) { var $x = ["TEnum",7,e]; $x.__enum__ = ValueType; $x.toString = $estr; return $x; }
ValueType.TUnknown = ["TUnknown",8];
ValueType.TUnknown.toString = $estr;
ValueType.TUnknown.__enum__ = ValueType;
var Type = $hxClasses["Type"] = function() { }
Type.__name__ = ["Type"];
Type.getClass = function(o) {
	if(o == null) return null;
	if(o.__enum__ != null) return null;
	return o.__class__;
}
Type.getEnum = function(o) {
	if(o == null) return null;
	return o.__enum__;
}
Type.getSuperClass = function(c) {
	return c.__super__;
}
Type.getClassName = function(c) {
	var a = c.__name__;
	return a.join(".");
}
Type.getEnumName = function(e) {
	var a = e.__ename__;
	return a.join(".");
}
Type.resolveClass = function(name) {
	var cl = $hxClasses[name];
	if(cl == null || cl.__name__ == null) return null;
	return cl;
}
Type.resolveEnum = function(name) {
	var e = $hxClasses[name];
	if(e == null || e.__ename__ == null) return null;
	return e;
}
Type.createInstance = function(cl,args) {
	switch(args.length) {
	case 0:
		return new cl();
	case 1:
		return new cl(args[0]);
	case 2:
		return new cl(args[0],args[1]);
	case 3:
		return new cl(args[0],args[1],args[2]);
	case 4:
		return new cl(args[0],args[1],args[2],args[3]);
	case 5:
		return new cl(args[0],args[1],args[2],args[3],args[4]);
	case 6:
		return new cl(args[0],args[1],args[2],args[3],args[4],args[5]);
	case 7:
		return new cl(args[0],args[1],args[2],args[3],args[4],args[5],args[6]);
	case 8:
		return new cl(args[0],args[1],args[2],args[3],args[4],args[5],args[6],args[7]);
	default:
		throw "Too many arguments";
	}
	return null;
}
Type.createEmptyInstance = function(cl) {
	function empty() {}; empty.prototype = cl.prototype;
	return new empty();
}
Type.createEnum = function(e,constr,params) {
	var f = Reflect.field(e,constr);
	if(f == null) throw "No such constructor " + constr;
	if(Reflect.isFunction(f)) {
		if(params == null) throw "Constructor " + constr + " need parameters";
		return Reflect.callMethod(e,f,params);
	}
	if(params != null && params.length != 0) throw "Constructor " + constr + " does not need parameters";
	return f;
}
Type.createEnumIndex = function(e,index,params) {
	var c = e.__constructs__[index];
	if(c == null) throw index + " is not a valid enum constructor index";
	return Type.createEnum(e,c,params);
}
Type.getInstanceFields = function(c) {
	var a = [];
	for(var i in c.prototype) a.push(i);
	a.remove("__class__");
	a.remove("__properties__");
	return a;
}
Type.getClassFields = function(c) {
	var a = Reflect.fields(c);
	a.remove("__name__");
	a.remove("__interfaces__");
	a.remove("__properties__");
	a.remove("__super__");
	a.remove("prototype");
	return a;
}
Type.getEnumConstructs = function(e) {
	var a = e.__constructs__;
	return a.copy();
}
Type["typeof"] = function(v) {
	switch(typeof(v)) {
	case "boolean":
		return ValueType.TBool;
	case "string":
		return ValueType.TClass(String);
	case "number":
		if(Math.ceil(v) == v % 2147483648.0) return ValueType.TInt;
		return ValueType.TFloat;
	case "object":
		if(v == null) return ValueType.TNull;
		var e = v.__enum__;
		if(e != null) return ValueType.TEnum(e);
		var c = v.__class__;
		if(c != null) return ValueType.TClass(c);
		return ValueType.TObject;
	case "function":
		if(v.__name__ != null) return ValueType.TObject;
		return ValueType.TFunction;
	case "undefined":
		return ValueType.TNull;
	default:
		return ValueType.TUnknown;
	}
}
Type.enumEq = function(a,b) {
	if(a == b) return true;
	try {
		if(a[0] != b[0]) return false;
		var _g1 = 2, _g = a.length;
		while(_g1 < _g) {
			var i = _g1++;
			if(!Type.enumEq(a[i],b[i])) return false;
		}
		var e = a.__enum__;
		if(e != b.__enum__ || e == null) return false;
	} catch( e ) {
		return false;
	}
	return true;
}
Type.enumConstructor = function(e) {
	return e[0];
}
Type.enumParameters = function(e) {
	return e.slice(2);
}
Type.enumIndex = function(e) {
	return e[1];
}
Type.allEnums = function(e) {
	var all = [];
	var cst = e.__constructs__;
	var _g = 0;
	while(_g < cst.length) {
		var c = cst[_g];
		++_g;
		var v = Reflect.field(e,c);
		if(!Reflect.isFunction(v)) all.push(v);
	}
	return all;
}
Type.prototype = {
	__class__: Type
}
var haxe = haxe || {}
haxe.Int32 = $hxClasses["haxe.Int32"] = function() { }
haxe.Int32.__name__ = ["haxe","Int32"];
haxe.Int32.make = function(a,b) {
	return a << 16 | b;
}
haxe.Int32.ofInt = function(x) {
	return haxe.Int32.clamp(x);
}
haxe.Int32.clamp = function(x) {
	return x | 0;
}
haxe.Int32.toInt = function(x) {
	if((x >> 30 & 1) != x >>> 31) throw "Overflow " + x;
	return x;
}
haxe.Int32.toNativeInt = function(x) {
	return x;
}
haxe.Int32.add = function(a,b) {
	return haxe.Int32.clamp(a + b);
}
haxe.Int32.sub = function(a,b) {
	return haxe.Int32.clamp(a - b);
}
haxe.Int32.mul = function(a,b) {
	return haxe.Int32.clamp(a * b);
}
haxe.Int32.div = function(a,b) {
	return Std["int"](a / b);
}
haxe.Int32.mod = function(a,b) {
	return a % b;
}
haxe.Int32.shl = function(a,b) {
	return a << b;
}
haxe.Int32.shr = function(a,b) {
	return a >> b;
}
haxe.Int32.ushr = function(a,b) {
	return a >>> b;
}
haxe.Int32.and = function(a,b) {
	return a & b;
}
haxe.Int32.or = function(a,b) {
	return a | b;
}
haxe.Int32.xor = function(a,b) {
	return a ^ b;
}
haxe.Int32.neg = function(a) {
	return -a;
}
haxe.Int32.isNeg = function(a) {
	return a < 0;
}
haxe.Int32.isZero = function(a) {
	return a == 0;
}
haxe.Int32.complement = function(a) {
	return ~a;
}
haxe.Int32.compare = function(a,b) {
	return a - b;
}
haxe.Int32.ucompare = function(a,b) {
	if(haxe.Int32.isNeg(a)) return haxe.Int32.isNeg(b)?haxe.Int32.compare(haxe.Int32.complement(b),haxe.Int32.complement(a)):1;
	return haxe.Int32.isNeg(b)?-1:haxe.Int32.compare(a,b);
}
haxe.Int32.prototype = {
	__class__: haxe.Int32
}
haxe.Log = $hxClasses["haxe.Log"] = function() { }
haxe.Log.__name__ = ["haxe","Log"];
haxe.Log.trace = function(v,infos) {
	js.Boot.__trace(v,infos);
}
haxe.Log.clear = function() {
	js.Boot.__clear_trace();
}
haxe.Log.prototype = {
	__class__: haxe.Log
}
haxe.Public = $hxClasses["haxe.Public"] = function() { }
haxe.Public.__name__ = ["haxe","Public"];
haxe.Public.prototype = {
	__class__: haxe.Public
}
haxe.StackItem = $hxClasses["haxe.StackItem"] = { __ename__ : ["haxe","StackItem"], __constructs__ : ["CFunction","Module","FilePos","Method","Lambda"] }
haxe.StackItem.CFunction = ["CFunction",0];
haxe.StackItem.CFunction.toString = $estr;
haxe.StackItem.CFunction.__enum__ = haxe.StackItem;
haxe.StackItem.Module = function(m) { var $x = ["Module",1,m]; $x.__enum__ = haxe.StackItem; $x.toString = $estr; return $x; }
haxe.StackItem.FilePos = function(s,file,line) { var $x = ["FilePos",2,s,file,line]; $x.__enum__ = haxe.StackItem; $x.toString = $estr; return $x; }
haxe.StackItem.Method = function(classname,method) { var $x = ["Method",3,classname,method]; $x.__enum__ = haxe.StackItem; $x.toString = $estr; return $x; }
haxe.StackItem.Lambda = function(v) { var $x = ["Lambda",4,v]; $x.__enum__ = haxe.StackItem; $x.toString = $estr; return $x; }
haxe.Stack = $hxClasses["haxe.Stack"] = function() { }
haxe.Stack.__name__ = ["haxe","Stack"];
haxe.Stack.callStack = function() {
	return [];
}
haxe.Stack.exceptionStack = function() {
	return [];
}
haxe.Stack.toString = function(stack) {
	var b = new StringBuf();
	var _g = 0;
	while(_g < stack.length) {
		var s = stack[_g];
		++_g;
		b.add("\nCalled from ");
		haxe.Stack.itemToString(b,s);
	}
	return b.toString();
}
haxe.Stack.itemToString = function(b,s) {
	var $e = (s);
	switch( $e[1] ) {
	case 0:
		b.add("a C function");
		break;
	case 1:
		var m = $e[2];
		b.add("module ");
		b.add(m);
		break;
	case 2:
		var line = $e[4], file = $e[3], s1 = $e[2];
		if(s1 != null) {
			haxe.Stack.itemToString(b,s1);
			b.add(" (");
		}
		b.add(file);
		b.add(" line ");
		b.add(line);
		if(s1 != null) b.add(")");
		break;
	case 3:
		var meth = $e[3], cname = $e[2];
		b.add(cname);
		b.add(".");
		b.add(meth);
		break;
	case 4:
		var n = $e[2];
		b.add("local function #");
		b.add(n);
		break;
	}
}
haxe.Stack.makeStack = function(s) {
	return null;
}
haxe.Stack.prototype = {
	__class__: haxe.Stack
}
if(!haxe.rtti) haxe.rtti = {}
haxe.rtti.Meta = $hxClasses["haxe.rtti.Meta"] = function() { }
haxe.rtti.Meta.__name__ = ["haxe","rtti","Meta"];
haxe.rtti.Meta.getType = function(t) {
	var meta = t.__meta__;
	return meta == null || meta.obj == null?{ }:meta.obj;
}
haxe.rtti.Meta.getStatics = function(t) {
	var meta = t.__meta__;
	return meta == null || meta.statics == null?{ }:meta.statics;
}
haxe.rtti.Meta.getFields = function(t) {
	var meta = t.__meta__;
	return meta == null || meta.fields == null?{ }:meta.fields;
}
haxe.rtti.Meta.prototype = {
	__class__: haxe.rtti.Meta
}
if(!haxe.unit) haxe.unit = {}
haxe.unit.TestCase = $hxClasses["haxe.unit.TestCase"] = function() {
};
haxe.unit.TestCase.__name__ = ["haxe","unit","TestCase"];
haxe.unit.TestCase.__interfaces__ = [haxe.Public];
haxe.unit.TestCase.prototype = {
	currentTest: null
	,setup: function() {
	}
	,tearDown: function() {
	}
	,print: function(v) {
		haxe.unit.TestRunner.print(v);
	}
	,assertTrue: function(b,c) {
		this.currentTest.done = true;
		if(b == false) {
			this.currentTest.success = false;
			this.currentTest.error = "expected true but was false";
			this.currentTest.posInfos = c;
			throw this.currentTest;
		}
	}
	,assertFalse: function(b,c) {
		this.currentTest.done = true;
		if(b == true) {
			this.currentTest.success = false;
			this.currentTest.error = "expected false but was true";
			this.currentTest.posInfos = c;
			throw this.currentTest;
		}
	}
	,assertEquals: function(expected,actual,c) {
		this.currentTest.done = true;
		if(actual != expected) {
			this.currentTest.success = false;
			this.currentTest.error = "expected '" + expected + "' but was '" + actual + "'";
			this.currentTest.posInfos = c;
			throw this.currentTest;
		}
	}
	,__class__: haxe.unit.TestCase
}
haxe.unit.TestResult = $hxClasses["haxe.unit.TestResult"] = function() {
	this.m_tests = new List();
	this.success = true;
};
haxe.unit.TestResult.__name__ = ["haxe","unit","TestResult"];
haxe.unit.TestResult.prototype = {
	m_tests: null
	,success: null
	,add: function(t) {
		this.m_tests.add(t);
		if(!t.success) this.success = false;
	}
	,toString: function() {
		var buf = new StringBuf();
		var failures = 0;
		var $it0 = this.m_tests.iterator();
		while( $it0.hasNext() ) {
			var test = $it0.next();
			if(test.success == false) {
				buf.add("* ");
				buf.add(test.classname);
				buf.add("::");
				buf.add(test.method);
				buf.add("()");
				buf.add("\n");
				buf.add("ERR: ");
				if(test.posInfos != null) {
					buf.add(test.posInfos.fileName);
					buf.add(":");
					buf.add(test.posInfos.lineNumber);
					buf.add("(");
					buf.add(test.posInfos.className);
					buf.add(".");
					buf.add(test.posInfos.methodName);
					buf.add(") - ");
				}
				buf.add(test.error);
				buf.add("\n");
				if(test.backtrace != null) {
					buf.add(test.backtrace);
					buf.add("\n");
				}
				buf.add("\n");
				failures++;
			}
		}
		buf.add("\n");
		if(failures == 0) buf.add("OK "); else buf.add("FAILED ");
		buf.add(this.m_tests.length);
		buf.add(" tests, ");
		buf.add(failures);
		buf.add(" failed, ");
		buf.add(this.m_tests.length - failures);
		buf.add(" success");
		buf.add("\n");
		return buf.toString();
	}
	,__class__: haxe.unit.TestResult
}
haxe.unit.TestRunner = $hxClasses["haxe.unit.TestRunner"] = function() {
	this.result = new haxe.unit.TestResult();
	this.cases = new List();
};
haxe.unit.TestRunner.__name__ = ["haxe","unit","TestRunner"];
haxe.unit.TestRunner.print = function(v) {
	var msg = StringTools.htmlEscape(js.Boot.__string_rec(v,"")).split("\n").join("<br/>");
	var d = document.getElementById("haxe:trace");
	if(d == null) alert("haxe:trace element not found"); else d.innerHTML += msg;
}
haxe.unit.TestRunner.customTrace = function(v,p) {
	haxe.unit.TestRunner.print(p.fileName + ":" + p.lineNumber + ": " + Std.string(v) + "\n");
}
haxe.unit.TestRunner.prototype = {
	result: null
	,cases: null
	,add: function(c) {
		this.cases.add(c);
	}
	,run: function() {
		this.result = new haxe.unit.TestResult();
		var $it0 = this.cases.iterator();
		while( $it0.hasNext() ) {
			var c = $it0.next();
			this.runCase(c);
		}
		haxe.unit.TestRunner.print(this.result.toString());
		return this.result.success;
	}
	,runCase: function(t) {
		var old = haxe.Log.trace;
		haxe.Log.trace = haxe.unit.TestRunner.customTrace;
		var cl = Type.getClass(t);
		var fields = Type.getInstanceFields(cl);
		haxe.unit.TestRunner.print("Class: " + Type.getClassName(cl) + " ");
		var _g = 0;
		while(_g < fields.length) {
			var f = fields[_g];
			++_g;
			var fname = f;
			var field = Reflect.field(t,f);
			if(StringTools.startsWith(fname,"test") && Reflect.isFunction(field)) {
				t.currentTest = new haxe.unit.TestStatus();
				t.currentTest.classname = Type.getClassName(cl);
				t.currentTest.method = fname;
				t.setup();
				try {
					Reflect.callMethod(t,field,new Array());
					if(t.currentTest.done) {
						t.currentTest.success = true;
						haxe.unit.TestRunner.print(".");
					} else {
						t.currentTest.success = false;
						t.currentTest.error = "(warning) no assert";
						haxe.unit.TestRunner.print("W");
					}
				} catch( $e0 ) {
					if( js.Boot.__instanceof($e0,haxe.unit.TestStatus) ) {
						var e = $e0;
						haxe.unit.TestRunner.print("F");
						t.currentTest.backtrace = haxe.Stack.toString(haxe.Stack.exceptionStack());
					} else {
					var e = $e0;
					haxe.unit.TestRunner.print("E");
					if(e.message != null) t.currentTest.error = "exception thrown : " + e + " [" + e.message + "]"; else t.currentTest.error = "exception thrown : " + e;
					t.currentTest.backtrace = haxe.Stack.toString(haxe.Stack.exceptionStack());
					}
				}
				this.result.add(t.currentTest);
				t.tearDown();
			}
		}
		haxe.unit.TestRunner.print("\n");
		haxe.Log.trace = old;
	}
	,__class__: haxe.unit.TestRunner
}
haxe.unit.TestStatus = $hxClasses["haxe.unit.TestStatus"] = function() {
	this.done = false;
	this.success = false;
};
haxe.unit.TestStatus.__name__ = ["haxe","unit","TestStatus"];
haxe.unit.TestStatus.prototype = {
	done: null
	,success: null
	,error: null
	,method: null
	,classname: null
	,posInfos: null
	,backtrace: null
	,__class__: haxe.unit.TestStatus
}
var js = js || {}
js.Boot = $hxClasses["js.Boot"] = function() { }
js.Boot.__name__ = ["js","Boot"];
js.Boot.__unhtml = function(s) {
	return s.split("&").join("&amp;").split("<").join("&lt;").split(">").join("&gt;");
}
js.Boot.__trace = function(v,i) {
	var msg = i != null?i.fileName + ":" + i.lineNumber + ": ":"";
	msg += js.Boot.__string_rec(v,"");
	var d = document.getElementById("haxe:trace");
	if(d != null) d.innerHTML += js.Boot.__unhtml(msg) + "<br/>"; else if(typeof(console) != "undefined" && console.log != null) console.log(msg);
}
js.Boot.__clear_trace = function() {
	var d = document.getElementById("haxe:trace");
	if(d != null) d.innerHTML = "";
}
js.Boot.__string_rec = function(o,s) {
	if(o == null) return "null";
	if(s.length >= 5) return "<...>";
	var t = typeof(o);
	if(t == "function" && (o.__name__ != null || o.__ename__ != null)) t = "object";
	switch(t) {
	case "object":
		if(o instanceof Array) {
			if(o.__enum__ != null) {
				if(o.length == 2) return o[0];
				var str = o[0] + "(";
				s += "\t";
				var _g1 = 2, _g = o.length;
				while(_g1 < _g) {
					var i = _g1++;
					if(i != 2) str += "," + js.Boot.__string_rec(o[i],s); else str += js.Boot.__string_rec(o[i],s);
				}
				return str + ")";
			}
			var l = o.length;
			var i;
			var str = "[";
			s += "\t";
			var _g = 0;
			while(_g < l) {
				var i1 = _g++;
				str += (i1 > 0?",":"") + js.Boot.__string_rec(o[i1],s);
			}
			str += "]";
			return str;
		}
		var tostr;
		try {
			tostr = o.toString;
		} catch( e ) {
			return "???";
		}
		if(tostr != null && tostr != Object.toString) {
			var s2 = o.toString();
			if(s2 != "[object Object]") return s2;
		}
		var k = null;
		var str = "{\n";
		s += "\t";
		var hasp = o.hasOwnProperty != null;
		for( var k in o ) { ;
		if(hasp && !o.hasOwnProperty(k)) {
			continue;
		}
		if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__" || k == "__properties__") {
			continue;
		}
		if(str.length != 2) str += ", \n";
		str += s + k + " : " + js.Boot.__string_rec(o[k],s);
		}
		s = s.substring(1);
		str += "\n" + s + "}";
		return str;
	case "function":
		return "<function>";
	case "string":
		return o;
	default:
		return String(o);
	}
}
js.Boot.__interfLoop = function(cc,cl) {
	if(cc == null) return false;
	if(cc == cl) return true;
	var intf = cc.__interfaces__;
	if(intf != null) {
		var _g1 = 0, _g = intf.length;
		while(_g1 < _g) {
			var i = _g1++;
			var i1 = intf[i];
			if(i1 == cl || js.Boot.__interfLoop(i1,cl)) return true;
		}
	}
	return js.Boot.__interfLoop(cc.__super__,cl);
}
js.Boot.__instanceof = function(o,cl) {
	try {
		if(o instanceof cl) {
			if(cl == Array) return o.__enum__ == null;
			return true;
		}
		if(js.Boot.__interfLoop(o.__class__,cl)) return true;
	} catch( e ) {
		if(cl == null) return false;
	}
	switch(cl) {
	case Int:
		return Math.ceil(o%2147483648.0) === o;
	case Float:
		return typeof(o) == "number";
	case Bool:
		return o === true || o === false;
	case String:
		return typeof(o) == "string";
	case Dynamic:
		return true;
	default:
		if(o == null) return false;
		return o.__enum__ == cl || cl == Class && o.__name__ != null || cl == Enum && o.__ename__ != null;
	}
}
js.Boot.__init = function() {
	js.Lib.isIE = typeof document!='undefined' && document.all != null && typeof window!='undefined' && window.opera == null;
	js.Lib.isOpera = typeof window!='undefined' && window.opera != null;
	Array.prototype.copy = Array.prototype.slice;
	Array.prototype.insert = function(i,x) {
		this.splice(i,0,x);
	};
	Array.prototype.remove = Array.prototype.indexOf?function(obj) {
		var idx = this.indexOf(obj);
		if(idx == -1) return false;
		this.splice(idx,1);
		return true;
	}:function(obj) {
		var i = 0;
		var l = this.length;
		while(i < l) {
			if(this[i] == obj) {
				this.splice(i,1);
				return true;
			}
			i++;
		}
		return false;
	};
	Array.prototype.iterator = function() {
		return { cur : 0, arr : this, hasNext : function() {
			return this.cur < this.arr.length;
		}, next : function() {
			return this.arr[this.cur++];
		}};
	};
	if(String.prototype.cca == null) String.prototype.cca = String.prototype.charCodeAt;
	String.prototype.charCodeAt = function(i) {
		var x = this.cca(i);
		if(x != x) return undefined;
		return x;
	};
	var oldsub = String.prototype.substr;
	String.prototype.substr = function(pos,len) {
		if(pos != null && pos != 0 && len != null && len < 0) return "";
		if(len == null) len = this.length;
		if(pos < 0) {
			pos = this.length + pos;
			if(pos < 0) pos = 0;
		} else if(len < 0) len = this.length + len - pos;
		return oldsub.apply(this,[pos,len]);
	};
	Function.prototype["$bind"] = function(o) {
		var f = function() {
			return f.method.apply(f.scope,arguments);
		};
		f.scope = o;
		f.method = this;
		return f;
	};
}
js.Boot.prototype = {
	__class__: js.Boot
}
js.Lib = $hxClasses["js.Lib"] = function() { }
js.Lib.__name__ = ["js","Lib"];
js.Lib.isIE = null;
js.Lib.isOpera = null;
js.Lib.document = null;
js.Lib.window = null;
js.Lib.alert = function(v) {
	alert(js.Boot.__string_rec(v,""));
}
js.Lib.eval = function(code) {
	return eval(code);
}
js.Lib.setErrorHandler = function(f) {
	js.Lib.onerror = f;
}
js.Lib.prototype = {
	__class__: js.Lib
}
var org = org || {}
if(!org.swiftsuspenders) org.swiftsuspenders = {}
org.swiftsuspenders.ChildInjectorTests = $hxClasses["org.swiftsuspenders.ChildInjectorTests"] = function() {
	haxe.unit.TestCase.call(this);
};
org.swiftsuspenders.ChildInjectorTests.__name__ = ["org","swiftsuspenders","ChildInjectorTests"];
org.swiftsuspenders.ChildInjectorTests.__super__ = haxe.unit.TestCase;
org.swiftsuspenders.ChildInjectorTests.prototype = $extend(haxe.unit.TestCase.prototype,{
	injector: null
	,setup: function() {
		this.injector = new org.swiftsuspenders.Injector();
	}
	,tearDown: function() {
		org.swiftsuspenders.Injector.purgeInjectionPointsCache();
		this.injector = null;
	}
	,testInjectorCreatesChildInjector: function() {
		this.assertTrue(true,{ fileName : "ChildInjectorTests.hx", lineNumber : 40, className : "org.swiftsuspenders.ChildInjectorTests", methodName : "testInjectorCreatesChildInjector"});
		var childInjector = this.injector.createChildInjector();
		this.assertTrue(Std["is"](childInjector,org.swiftsuspenders.Injector),{ fileName : "ChildInjectorTests.hx", lineNumber : 42, className : "org.swiftsuspenders.ChildInjectorTests", methodName : "testInjectorCreatesChildInjector"});
	}
	,testIjectorUsesChildInjectorForSpecifiedMapping: function() {
		this.injector.map(org.swiftsuspenders.support.injectees.childinjectors.RobotFoot);
		var leftFootMapping = this.injector.map(org.swiftsuspenders.support.injectees.childinjectors.RobotLeg,"leftLeg");
		var leftChildInjector = this.injector.createChildInjector();
		leftChildInjector.map(org.swiftsuspenders.support.injectees.childinjectors.RobotAnkle);
		leftChildInjector.map(org.swiftsuspenders.support.injectees.childinjectors.RobotFoot).toType(org.swiftsuspenders.support.injectees.childinjectors.LeftRobotFoot);
		leftFootMapping.setInjector(leftChildInjector);
		var rightFootMapping = this.injector.map(org.swiftsuspenders.support.injectees.childinjectors.RobotLeg,"rightLeg");
		var rightChildInjector = this.injector.createChildInjector();
		rightChildInjector.map(org.swiftsuspenders.support.injectees.childinjectors.RobotAnkle);
		rightChildInjector.map(org.swiftsuspenders.support.injectees.childinjectors.RobotFoot).toType(org.swiftsuspenders.support.injectees.childinjectors.RightRobotFoot);
		rightFootMapping.setInjector(rightChildInjector);
		var robotBody = this.injector.getInstance(org.swiftsuspenders.support.injectees.childinjectors.RobotBody);
		this.assertTrue(Std["is"](robotBody.rightLeg.ankle.foot,org.swiftsuspenders.support.injectees.childinjectors.RightRobotFoot),{ fileName : "ChildInjectorTests.hx", lineNumber : 59, className : "org.swiftsuspenders.ChildInjectorTests", methodName : "testIjectorUsesChildInjectorForSpecifiedMapping"});
		this.assertTrue(Std["is"](robotBody.leftLeg.ankle.foot,org.swiftsuspenders.support.injectees.childinjectors.LeftRobotFoot),{ fileName : "ChildInjectorTests.hx", lineNumber : 60, className : "org.swiftsuspenders.ChildInjectorTests", methodName : "testIjectorUsesChildInjectorForSpecifiedMapping"});
	}
	,testChildInjectorUsesParentForMissingMappings: function() {
		this.injector.map(org.swiftsuspenders.support.injectees.childinjectors.RobotFoot);
		this.injector.map(org.swiftsuspenders.support.injectees.childinjectors.RobotToes);
		var leftFootMapping = this.injector.map(org.swiftsuspenders.support.injectees.childinjectors.RobotLeg,"leftLeg");
		var leftChildInjector = this.injector.createChildInjector();
		leftChildInjector.map(org.swiftsuspenders.support.injectees.childinjectors.RobotAnkle);
		leftChildInjector.map(org.swiftsuspenders.support.injectees.childinjectors.RobotFoot).toType(org.swiftsuspenders.support.injectees.childinjectors.LeftRobotFoot);
		leftFootMapping.setInjector(leftChildInjector);
		var rightFootMapping = this.injector.map(org.swiftsuspenders.support.injectees.childinjectors.RobotLeg,"rightLeg");
		var rightChildInjector = this.injector.createChildInjector();
		rightChildInjector.map(org.swiftsuspenders.support.injectees.childinjectors.RobotAnkle);
		rightChildInjector.map(org.swiftsuspenders.support.injectees.childinjectors.RobotFoot).toType(org.swiftsuspenders.support.injectees.childinjectors.RightRobotFoot);
		rightFootMapping.setInjector(rightChildInjector);
		var robotBody = this.injector.getInstance(org.swiftsuspenders.support.injectees.childinjectors.RobotBody);
		this.assertTrue(Std["is"](robotBody.rightLeg.ankle.foot.toes,org.swiftsuspenders.support.injectees.childinjectors.RobotToes),{ fileName : "ChildInjectorTests.hx", lineNumber : 77, className : "org.swiftsuspenders.ChildInjectorTests", methodName : "testChildInjectorUsesParentForMissingMappings"});
		this.assertTrue(Std["is"](robotBody.leftLeg.ankle.foot.toes,org.swiftsuspenders.support.injectees.childinjectors.RobotToes),{ fileName : "ChildInjectorTests.hx", lineNumber : 78, className : "org.swiftsuspenders.ChildInjectorTests", methodName : "testChildInjectorUsesParentForMissingMappings"});
	}
	,testParentMappedSingletonGetsInitializedByParentWhenInvokedThroughChildInjector: function() {
		var parentClazz = new org.swiftsuspenders.support.types.Clazz();
		this.injector.map(org.swiftsuspenders.support.types.Clazz).toValue(parentClazz);
		this.injector.map(org.swiftsuspenders.support.injectees.ClassInjectee).asSingleton();
		var childInjector = this.injector.createChildInjector();
		var childClazz = new org.swiftsuspenders.support.types.Clazz();
		childInjector.map(org.swiftsuspenders.support.types.Clazz).toValue(childClazz);
		var classInjectee = childInjector.getInstance(org.swiftsuspenders.support.injectees.ClassInjectee);
		this.assertTrue(classInjectee.property == parentClazz,{ fileName : "ChildInjectorTests.hx", lineNumber : 89, className : "org.swiftsuspenders.ChildInjectorTests", methodName : "testParentMappedSingletonGetsInitializedByParentWhenInvokedThroughChildInjector"});
	}
	,testChildInjectorDoesntReturnToParentAfterUsingParentInjectorForMissingMappings: function() {
		this.injector.map(org.swiftsuspenders.support.injectees.childinjectors.RobotAnkle);
		this.injector.map(org.swiftsuspenders.support.injectees.childinjectors.RobotFoot);
		this.injector.map(org.swiftsuspenders.support.injectees.childinjectors.RobotToes);
		var leftFootMapping = this.injector.map(org.swiftsuspenders.support.injectees.childinjectors.RobotLeg,"leftLeg");
		var leftChildInjector = this.injector.createChildInjector();
		leftChildInjector.map(org.swiftsuspenders.support.injectees.childinjectors.RobotFoot).toType(org.swiftsuspenders.support.injectees.childinjectors.LeftRobotFoot);
		leftFootMapping.setInjector(leftChildInjector);
		var rightFootMapping = this.injector.map(org.swiftsuspenders.support.injectees.childinjectors.RobotLeg,"rightLeg");
		var rightChildInjector = this.injector.createChildInjector();
		rightChildInjector.map(org.swiftsuspenders.support.injectees.childinjectors.RobotFoot).toType(org.swiftsuspenders.support.injectees.childinjectors.RightRobotFoot);
		rightFootMapping.setInjector(rightChildInjector);
		var robotBody = this.injector.getInstance(org.swiftsuspenders.support.injectees.childinjectors.RobotBody);
		this.assertTrue(Std["is"](robotBody.rightLeg.ankle.foot,org.swiftsuspenders.support.injectees.childinjectors.RightRobotFoot),{ fileName : "ChildInjectorTests.hx", lineNumber : 105, className : "org.swiftsuspenders.ChildInjectorTests", methodName : "testChildInjectorDoesntReturnToParentAfterUsingParentInjectorForMissingMappings"});
		this.assertTrue(Std["is"](robotBody.leftLeg.ankle.foot,org.swiftsuspenders.support.injectees.childinjectors.LeftRobotFoot),{ fileName : "ChildInjectorTests.hx", lineNumber : 106, className : "org.swiftsuspenders.ChildInjectorTests", methodName : "testChildInjectorDoesntReturnToParentAfterUsingParentInjectorForMissingMappings"});
	}
	,testChildInjectorHasMappingWhenExistsOnParentInjector: function() {
		var childInjector = this.injector.createChildInjector();
		var class1 = new org.swiftsuspenders.support.types.Clazz();
		this.injector.map(org.swiftsuspenders.support.types.Clazz).toValue(class1);
		this.assertTrue(childInjector.satisfies(org.swiftsuspenders.support.types.Clazz),{ fileName : "ChildInjectorTests.hx", lineNumber : 113, className : "org.swiftsuspenders.ChildInjectorTests", methodName : "testChildInjectorHasMappingWhenExistsOnParentInjector"});
	}
	,testChildInjectorDoesNotHaveMappingWhenDoesNotExistOnParentInjector: function() {
		var childInjector = this.injector.createChildInjector();
		this.assertFalse(childInjector.satisfies(org.swiftsuspenders.support.types.Interface),{ fileName : "ChildInjectorTests.hx", lineNumber : 117, className : "org.swiftsuspenders.ChildInjectorTests", methodName : "testChildInjectorDoesNotHaveMappingWhenDoesNotExistOnParentInjector"});
	}
	,testGrandChildInjectorSuppliesInjectionFromAncestor: function() {
		var childInjector;
		var grandChildInjector;
		var injectee = new org.swiftsuspenders.support.injectees.ClassInjectee();
		this.injector.map(org.swiftsuspenders.support.types.Clazz).toSingleton(org.swiftsuspenders.support.types.Clazz);
		childInjector = this.injector.createChildInjector();
		grandChildInjector = childInjector.createChildInjector();
		grandChildInjector.injectInto(injectee);
		this.assertTrue(Std["is"](injectee.property,org.swiftsuspenders.support.types.Clazz),{ fileName : "ChildInjectorTests.hx", lineNumber : 128, className : "org.swiftsuspenders.ChildInjectorTests", methodName : "testGrandChildInjectorSuppliesInjectionFromAncestor"});
	}
	,__class__: org.swiftsuspenders.ChildInjectorTests
});
org.swiftsuspenders.DependencyProviderTests = $hxClasses["org.swiftsuspenders.DependencyProviderTests"] = function() {
	haxe.unit.TestCase.call(this);
};
org.swiftsuspenders.DependencyProviderTests.__name__ = ["org","swiftsuspenders","DependencyProviderTests"];
org.swiftsuspenders.DependencyProviderTests.__super__ = haxe.unit.TestCase;
org.swiftsuspenders.DependencyProviderTests.prototype = $extend(haxe.unit.TestCase.prototype,{
	injector: null
	,setup: function() {
		this.injector = new org.swiftsuspenders.Injector();
	}
	,tearDown: function() {
		org.swiftsuspenders.Injector.purgeInjectionPointsCache();
		this.injector = null;
	}
	,testValueProviderReturnsSetValue: function() {
		var response = new org.swiftsuspenders.support.types.Clazz();
		var provider = new org.swiftsuspenders.dependencyproviders.ValueProvider(response);
		var returnedResponse = provider.apply(null,this.injector,null);
		this.assertTrue(response == returnedResponse,{ fileName : "DependencyProviderTests.hx", lineNumber : 39, className : "org.swiftsuspenders.DependencyProviderTests", methodName : "testValueProviderReturnsSetValue"});
	}
	,testClassProviderReturnsClassInstance: function() {
		var classProvider = new org.swiftsuspenders.dependencyproviders.ClassProvider(org.swiftsuspenders.support.types.Clazz);
		var returnedResponse = classProvider.apply(null,this.injector,null);
		this.assertTrue(Std["is"](returnedResponse,org.swiftsuspenders.support.types.Clazz),{ fileName : "DependencyProviderTests.hx", lineNumber : 45, className : "org.swiftsuspenders.DependencyProviderTests", methodName : "testClassProviderReturnsClassInstance"});
	}
	,testClassProviderReturnsDifferentInstancesOnEachApply: function() {
		var classProvider = new org.swiftsuspenders.dependencyproviders.ClassProvider(org.swiftsuspenders.support.types.Clazz);
		var firstResponse = classProvider.apply(null,this.injector,null);
		var secondResponse = classProvider.apply(null,this.injector,null);
		this.assertFalse(firstResponse == secondResponse,{ fileName : "DependencyProviderTests.hx", lineNumber : 52, className : "org.swiftsuspenders.DependencyProviderTests", methodName : "testClassProviderReturnsDifferentInstancesOnEachApply"});
	}
	,testSingletonProviderReturnsInstance: function() {
		var singletonProvider = new org.swiftsuspenders.dependencyproviders.SingletonProvider(org.swiftsuspenders.support.types.Clazz,this.injector);
		var returnedResponse = singletonProvider.apply(null,this.injector,null);
		this.assertTrue(Std["is"](returnedResponse,org.swiftsuspenders.support.types.Clazz),{ fileName : "DependencyProviderTests.hx", lineNumber : 58, className : "org.swiftsuspenders.DependencyProviderTests", methodName : "testSingletonProviderReturnsInstance"});
	}
	,testSameSingletonIsReturnedOnSecondResponse: function() {
		var singletonProvider = new org.swiftsuspenders.dependencyproviders.SingletonProvider(org.swiftsuspenders.support.types.Clazz,this.injector);
		var returnedResponse = singletonProvider.apply(null,this.injector,null);
		var secondResponse = singletonProvider.apply(null,this.injector,null);
		this.assertTrue(returnedResponse == secondResponse,{ fileName : "DependencyProviderTests.hx", lineNumber : 65, className : "org.swiftsuspenders.DependencyProviderTests", methodName : "testSameSingletonIsReturnedOnSecondResponse"});
	}
	,testInjectionTypeOtherMappingReturnsOtherMappingsResponse: function() {
		var otherConfig = new org.swiftsuspenders.InjectionMapping(this.injector,org.swiftsuspenders.support.types.ClazzExtension,"","");
		otherConfig.toProvider(new org.swiftsuspenders.dependencyproviders.ClassProvider(org.swiftsuspenders.support.types.ClazzExtension));
		var otherMappingProvider = new org.swiftsuspenders.dependencyproviders.OtherMappingProvider(otherConfig);
		var returnedResponse = otherMappingProvider.apply(null,this.injector,null);
		this.assertTrue(Std["is"](returnedResponse,org.swiftsuspenders.support.types.Clazz),{ fileName : "DependencyProviderTests.hx", lineNumber : 73, className : "org.swiftsuspenders.DependencyProviderTests", methodName : "testInjectionTypeOtherMappingReturnsOtherMappingsResponse"});
		this.assertTrue(Std["is"](returnedResponse,org.swiftsuspenders.support.types.ClazzExtension),{ fileName : "DependencyProviderTests.hx", lineNumber : 74, className : "org.swiftsuspenders.DependencyProviderTests", methodName : "testInjectionTypeOtherMappingReturnsOtherMappingsResponse"});
	}
	,testDependencyProviderHasAccessToTargetType: function() {
		var provider = new org.swiftsuspenders.support.providers.ClassNameStoringProvider();
		this.injector.map(org.swiftsuspenders.support.types.Clazz).toProvider(provider);
		this.injector.getInstance(org.swiftsuspenders.support.injectees.ClassInjectee);
		this.assertTrue(Type.getClassName(org.swiftsuspenders.support.injectees.ClassInjectee) == provider.lastTargetClassName,{ fileName : "DependencyProviderTests.hx", lineNumber : 81, className : "org.swiftsuspenders.DependencyProviderTests", methodName : "testDependencyProviderHasAccessToTargetType"});
	}
	,__class__: org.swiftsuspenders.DependencyProviderTests
});
org.swiftsuspenders.ReflectorBase = $hxClasses["org.swiftsuspenders.ReflectorBase"] = function() {
};
org.swiftsuspenders.ReflectorBase.__name__ = ["org","swiftsuspenders","ReflectorBase"];
org.swiftsuspenders.ReflectorBase.prototype = {
	getClass: function(value) {
		return value.constructor;
	}
	,getFQCN: function(value,replaceColons) {
		if(replaceColons == null) replaceColons = false;
		var fqcn;
		if(Std["is"](value,String)) {
			fqcn = value;
			if(!replaceColons && fqcn.indexOf("::") == -1) {
				var lastDotIndex = fqcn.lastIndexOf(".");
				if(lastDotIndex == -1) return fqcn;
				return fqcn.substr(0,lastDotIndex) + "::" + fqcn.substr(lastDotIndex + 1);
			}
		} else fqcn = Type.getClassName(value);
		return replaceColons?fqcn.split("::").join("."):fqcn;
	}
	,__class__: org.swiftsuspenders.ReflectorBase
}
org.swiftsuspenders.Reflector = $hxClasses["org.swiftsuspenders.Reflector"] = function() { }
org.swiftsuspenders.Reflector.__name__ = ["org","swiftsuspenders","Reflector"];
org.swiftsuspenders.Reflector.prototype = {
	getClass: null
	,getFQCN: null
	,typeImplements: null
	,describeInjections: null
	,__class__: org.swiftsuspenders.Reflector
}
org.swiftsuspenders.HaxeReflector = $hxClasses["org.swiftsuspenders.HaxeReflector"] = function() {
	org.swiftsuspenders.ReflectorBase.call(this);
};
org.swiftsuspenders.HaxeReflector.__name__ = ["org","swiftsuspenders","HaxeReflector"];
org.swiftsuspenders.HaxeReflector.__interfaces__ = [org.swiftsuspenders.Reflector];
org.swiftsuspenders.HaxeReflector.__super__ = org.swiftsuspenders.ReflectorBase;
org.swiftsuspenders.HaxeReflector.prototype = $extend(org.swiftsuspenders.ReflectorBase.prototype,{
	typeImplements: function(type,superType) {
		throw new org.swiftsuspenders.haxe.Error("typeImplements NOT IMPLEMENTED");
		return false;
	}
	,describeInjections: function(type) {
		var description = new org.swiftsuspenders.typedescriptions.TypeDescription(false);
		var typeMeta = haxe.rtti.Meta.getType(type);
		var fieldsMeta = this.getFields(type);
		var _g = 0, _g1 = Reflect.fields(fieldsMeta);
		while(_g < _g1.length) {
			var field = _g1[_g];
			++_g;
			var fieldMeta = Reflect.field(fieldsMeta,field);
			var hasInject = Reflect.hasField(fieldMeta,"Inject");
			var hasPostconstruct = Reflect.hasField(fieldMeta,"PostConstruct");
			var args = Reflect.field(fieldMeta,"args");
			if(field == "_") {
				if(args.length == 0) description.ctor = new org.swiftsuspenders.typedescriptions.NoParamsConstructorInjectionPoint(); else {
					var parameters = [];
					var requiredParameters = this.gatherMethodParameters(fieldMeta,parameters);
					description.ctor = new org.swiftsuspenders.typedescriptions.ConstructorInjectionPoint(parameters,requiredParameters,null);
				}
			} else if(Reflect.hasField(fieldMeta,"args")) {
				if(hasInject) {
					var parameters = [];
					var requiredParameters = this.gatherMethodParameters(fieldMeta,parameters);
					var injectionPoint = new org.swiftsuspenders.typedescriptions.MethodInjectionPoint(fieldMeta.name[0],parameters,requiredParameters,false,null);
					description.addInjectionPoint(injectionPoint);
				} else if(hasPostconstruct) {
					var parameters = [];
					var requiredParameters = this.gatherMethodParameters(fieldMeta,parameters);
					var injectionPoint = new org.swiftsuspenders.typedescriptions.PostConstructInjectionPoint(fieldMeta.name[0],parameters,requiredParameters,0);
					description.addInjectionPoint(injectionPoint);
				}
			} else if(type != null && hasInject) {
				var type1 = fieldMeta.type;
				var injectionPointName = fieldMeta.Inject != null?fieldMeta.Inject[0]:"";
				var injectionPoint = new org.swiftsuspenders.typedescriptions.PropertyInjectionPoint(fieldMeta.type + "|" + injectionPointName,field,false,null);
				description.addInjectionPoint(injectionPoint);
			}
		}
		if(description.ctor == null && !Reflect.hasField(typeMeta,"interface")) description.ctor = new org.swiftsuspenders.typedescriptions.NoParamsConstructorInjectionPoint();
		return description;
	}
	,getFields: function(type) {
		var meta = { };
		while(type != null) {
			var typeMeta = haxe.rtti.Meta.getFields(type);
			var _g = 0, _g1 = Reflect.fields(typeMeta);
			while(_g < _g1.length) {
				var field = _g1[_g];
				++_g;
				Reflect.setField(meta,field,Reflect.field(typeMeta,field));
			}
			type = Type.getSuperClass(type);
		}
		return meta;
	}
	,addCtorInjectionPoint: function(description,traits,typeName) {
		throw new org.swiftsuspenders.haxe.Error("addCtorInjectionPoint NOT IMPLEMENTED");
	}
	,addMethodInjectionPoints: function(description,methods,typeName) {
		throw new org.swiftsuspenders.haxe.Error("addMethodInjectionPoints NOT IMPLEMENTED");
	}
	,addPostConstructMethodPoints: function(description,methods,typeName) {
		throw new org.swiftsuspenders.haxe.Error("addPostConstructMethodPoints NOT IMPLEMENTED");
	}
	,addPreDestroyMethodPoints: function(description,methods,typeName) {
		throw new org.swiftsuspenders.haxe.Error("addPreDestroyMethodPoints NOT IMPLEMENTED");
	}
	,addFieldInjectionPoints: function(description,type) {
	}
	,gatherMethodParameters: function(meta,parameters) {
		var nameArgs = meta.Inject;
		var args = meta.args;
		var requiredParameters = 0;
		if(nameArgs == null) nameArgs = [];
		var i = 0;
		if(args != null) {
			var _g = 0;
			while(_g < args.length) {
				var arg = args[_g];
				++_g;
				var injectionName = "";
				if(i < nameArgs.length) injectionName = nameArgs[i];
				var parameterTypeName = arg.type;
				if(arg.opt) {
					if(parameterTypeName == "Dynamic") throw new org.swiftsuspenders.InjectorError("Error in method definition of injectee. Required parameters can't have non class type.");
				} else requiredParameters++;
				parameters.push(parameterTypeName + "|" + injectionName);
				i++;
			}
		}
		return requiredParameters;
	}
	,gatherOrderedInjectionPointsForTag: function(injectionPointClass,tag,methods,typeName) {
		throw new org.swiftsuspenders.haxe.Error("gatherOrderedInjectionPointsForTag NOT IMPLEMENTED");
		return null;
	}
	,extractTagParameters: function(tag,metadata) {
		throw new org.swiftsuspenders.haxe.Error("extractTagParameters NOT IMPLEMENTED");
		return null;
	}
	,__class__: org.swiftsuspenders.HaxeReflector
});
org.swiftsuspenders.InjectionMapping = $hxClasses["org.swiftsuspenders.InjectionMapping"] = function(creatingInjector,type,name,mappingId) {
	this._creatingInjector = creatingInjector;
	this._type = type;
	this._name = name;
	this._mappingId = mappingId;
	this._defaultProviderSet = true;
	this.mapProvider(new org.swiftsuspenders.dependencyproviders.ClassProvider(type));
};
org.swiftsuspenders.InjectionMapping.__name__ = ["org","swiftsuspenders","InjectionMapping"];
org.swiftsuspenders.InjectionMapping.prototype = {
	isSealed: null
	,_type: null
	,_name: null
	,_mappingId: null
	,_creatingInjector: null
	,_defaultProviderSet: null
	,_overridingInjector: null
	,_soft: null
	,_local: null
	,_sealed: null
	,_sealKey: null
	,asSingleton: function() {
		this.toSingleton(this._type);
		return this;
	}
	,toType: function(type) {
		this.toProvider(new org.swiftsuspenders.dependencyproviders.ClassProvider(type));
		return this;
	}
	,toSingleton: function(type) {
		this.toProvider(new org.swiftsuspenders.dependencyproviders.SingletonProvider(type,this._creatingInjector));
		return this;
	}
	,toValue: function(value) {
		this.toProvider(new org.swiftsuspenders.dependencyproviders.ValueProvider(value));
		return this;
	}
	,toProvider: function(provider) {
		if(this._sealed) this.throwSealedError();
		if(this.hasProvider() && provider != null && !this._defaultProviderSet) haxe.Log.trace("Warning: Injector already has a mapping for " + this._mappingId + ".\n " + "If you have overridden this mapping intentionally you can use " + "\"injector.unmap()\" prior to your replacement mapping in order to " + "avoid seeing this message.",{ fileName : "InjectionMapping.hx", lineNumber : 137, className : "org.swiftsuspenders.InjectionMapping", methodName : "toProvider"});
		this.dispatchPreChangeEvent();
		this._defaultProviderSet = false;
		this.mapProvider(provider);
		this.dispatchPostChangeEvent();
		return this;
	}
	,soft: function() {
		if(this._sealed) this.throwSealedError();
		if(!this._soft) {
			var provider = this.getProvider();
			this.dispatchPreChangeEvent();
			this._soft = true;
			this.mapProvider(provider);
			this.dispatchPostChangeEvent();
		}
		return this;
	}
	,local: function() {
		if(this._sealed) this.throwSealedError();
		if(this._local) return this;
		var provider = this.getProvider();
		this.dispatchPreChangeEvent();
		this._local = true;
		this.mapProvider(provider);
		this.dispatchPostChangeEvent();
		return this;
	}
	,shared: function() {
		if(this._sealed) this.throwSealedError();
		if(!this._local) return this;
		var provider = this.getProvider();
		this.dispatchPreChangeEvent();
		this._local = false;
		this.mapProvider(provider);
		this.dispatchPostChangeEvent();
		return this;
	}
	,seal: function() {
		if(this._sealed) throw new org.swiftsuspenders.InjectorError("Mapping is already sealed.");
		this._sealed = true;
		this._sealKey = { };
		return this._sealKey;
	}
	,unseal: function(key) {
		if(!this._sealed) throw new org.swiftsuspenders.InjectorError("Can't unseal a non-sealed mapping.");
		if(key != this._sealKey) throw new org.swiftsuspenders.InjectorError("Can't unseal mapping without the correct key.");
		this._sealed = false;
		this._sealKey = null;
		return this;
	}
	,getIsSealed: function() {
		return this._sealed;
	}
	,hasProvider: function() {
		return this._creatingInjector.providerMappings.exists(this._mappingId);
	}
	,getProvider: function() {
		var provider = this._creatingInjector.providerMappings.get(this._mappingId);
		while(Std["is"](provider,org.swiftsuspenders.dependencyproviders.ForwardingProvider)) provider = ((function($this) {
			var $r;
			var $t = provider;
			if(Std["is"]($t,org.swiftsuspenders.dependencyproviders.ForwardingProvider)) $t; else throw "Class cast error";
			$r = $t;
			return $r;
		}(this))).provider;
		return provider;
	}
	,setInjector: function(injector) {
		if(this._sealed) this.throwSealedError();
		if(injector == this._overridingInjector) return this;
		var provider = this.getProvider();
		this._overridingInjector = injector;
		this.mapProvider(provider);
		return this;
	}
	,mapProvider: function(provider) {
		if(this._soft) provider = new org.swiftsuspenders.dependencyproviders.SoftDependencyProvider(provider);
		if(this._local) provider = new org.swiftsuspenders.dependencyproviders.LocalOnlyProvider(provider);
		if(this._overridingInjector != null) provider = new org.swiftsuspenders.dependencyproviders.InjectorUsingProvider(this._overridingInjector,provider);
		this._creatingInjector.providerMappings.set(this._mappingId,provider);
	}
	,throwSealedError: function() {
		throw new org.swiftsuspenders.InjectorError("Can't change a sealed mapping");
	}
	,dispatchPreChangeEvent: function() {
	}
	,dispatchPostChangeEvent: function() {
	}
	,__class__: org.swiftsuspenders.InjectionMapping
	,__properties__: {get_isSealed:"getIsSealed"}
}
org.swiftsuspenders.InjectionResultTests = $hxClasses["org.swiftsuspenders.InjectionResultTests"] = function() {
	haxe.unit.TestCase.call(this);
};
org.swiftsuspenders.InjectionResultTests.__name__ = ["org","swiftsuspenders","InjectionResultTests"];
org.swiftsuspenders.InjectionResultTests.__super__ = haxe.unit.TestCase;
org.swiftsuspenders.InjectionResultTests.prototype = $extend(haxe.unit.TestCase.prototype,{
	injector: null
	,setup: function() {
		this.injector = new org.swiftsuspenders.Injector();
	}
	,tearDown: function() {
		org.swiftsuspenders.Injector.purgeInjectionPointsCache();
		this.injector = null;
	}
	,__class__: org.swiftsuspenders.InjectionResultTests
});
org.swiftsuspenders.Injector = $hxClasses["org.swiftsuspenders.Injector"] = function() {
	this.providerMappings = new Hash();
	this._defaultProviders = new Hash();
	this._mappings = new Hash();
	this._mappingsInProcess = new Hash();
	try {
		this._reflector = new org.swiftsuspenders.HaxeReflector();
	} catch( e ) {
		if( js.Boot.__instanceof(e,org.swiftsuspenders.haxe.Error) ) {
			this._reflector = new org.swiftsuspenders.HaxeReflector();
		} else throw(e);
	}
	this._classDescriptor = new org.swiftsuspenders.utils.TypeDescriptor(this._reflector,org.swiftsuspenders.Injector.INJECTION_POINTS_CACHE);
};
org.swiftsuspenders.Injector.__name__ = ["org","swiftsuspenders","Injector"];
org.swiftsuspenders.Injector.purgeInjectionPointsCache = function() {
	org.swiftsuspenders.Injector.INJECTION_POINTS_CACHE = new Hash();
}
org.swiftsuspenders.Injector.prototype = {
	parentInjector: null
	,_parentInjector: null
	,_classDescriptor: null
	,_mappings: null
	,_defaultProviders: null
	,_mappingsInProcess: null
	,_reflector: null
	,providerMappings: null
	,map: function(type,name) {
		if(name == null) name = "";
		var mappingId = Type.getClassName(type) + "|" + name;
		var map = this._mappings.get(mappingId);
		if(map == null) this._mappings.set(mappingId,map = this.createMapping(type,name,mappingId));
		return map;
	}
	,unmap: function(type,name) {
		if(name == null) name = "";
		var mappingId = Type.getClassName(type) + "|" + name;
		var mapping = this._mappings.get(mappingId);
		if(mapping != null && mapping.getIsSealed()) throw new org.swiftsuspenders.InjectorError("Can't unmap a sealed mapping");
		if(mapping == null) throw new org.swiftsuspenders.InjectorError("Error while removing an injector mapping: " + "No mapping defined for dependency " + mappingId);
		this._mappings.remove(mappingId);
		this.providerMappings.remove(mappingId);
	}
	,satisfies: function(type,name) {
		if(name == null) name = "";
		return this.getProvider(Type.getClassName(type) + "|" + name) != null;
	}
	,injectInto: function(target) {
		var type = this._reflector.getClass(target);
		var description = this._classDescriptor.getDescription(type);
		this.applyInjectionPoints(target,type,description.injectionPoints);
	}
	,getInstance: function(type,name,targetType) {
		if(name == null) name = "";
		var mappingId = Type.getClassName(type) + "|" + name;
		var provider = this.getProvider(mappingId);
		if(provider != null) {
			var ctor = this._classDescriptor.getDescription(type).ctor;
			return provider.apply(targetType,this,ctor != null?ctor.injectParameters:null);
		}
		if(name != null) throw new org.swiftsuspenders.InjectorError("No mapping found for request " + mappingId + ". getInstance only creates an unmapped instance if no name is given.");
		return this.instantiateUnmapped(type);
	}
	,createChildInjector: function() {
		var injector = new org.swiftsuspenders.Injector();
		injector.setParentInjector(this);
		return injector;
	}
	,setParentInjector: function(parentInjector) {
		this._parentInjector = parentInjector;
		return parentInjector;
	}
	,getParentInjector: function() {
		return this._parentInjector;
	}
	,addTypeDescription: function(type,description) {
		this._classDescriptor.addDescription(type,description);
	}
	,instantiateUnmapped: function(type) {
		var description = this._classDescriptor.getDescription(type);
		if(description.ctor == null) throw new org.swiftsuspenders.InjectorError("Can't instantiate interface " + Type.getClassName(type));
		var instance = description.ctor.createInstance(type,this);
		this.applyInjectionPoints(instance,type,description.injectionPoints);
		return instance;
		return null;
	}
	,getProvider: function(mappingId,fallbackToDefault) {
		if(fallbackToDefault == null) fallbackToDefault = true;
		var softProvider = null;
		var injector = this;
		while(injector != null) {
			var provider = injector.providerMappings.get(mappingId);
			if(provider != null) {
				if(Std["is"](provider,org.swiftsuspenders.dependencyproviders.SoftDependencyProvider)) {
					softProvider = provider;
					injector = injector.getParentInjector();
					continue;
				}
				if(Std["is"](provider,org.swiftsuspenders.dependencyproviders.LocalOnlyProvider) && injector != this) {
					injector = injector.getParentInjector();
					continue;
				}
				return provider;
			}
			injector = injector.getParentInjector();
		}
		if(softProvider != null) return softProvider;
		return fallbackToDefault?this.getDefaultProvider(mappingId):null;
	}
	,getDefaultProvider: function(mappingId) {
		if(mappingId == "String|") return null;
		var parts = mappingId.split("|");
		var name = parts.pop();
		if(name.length != 0) return null;
		var typeName = parts.pop();
		var definition = null;
		try {
			definition = Type.resolveClass(typeName);
		} catch( e ) {
			if( js.Boot.__instanceof(e,org.swiftsuspenders.haxe.Error) ) {
				return null;
			} else throw(e);
		}
		if(definition == null || !Std["is"](definition,Class)) return null;
		var type = definition;
		var description = this._classDescriptor.getDescription(type);
		if(description.ctor == null) return null;
		if(this._defaultProviders.get(Type.getClassName(type)) != null) return this._defaultProviders.get(Type.getClassName(type));
		var c = new org.swiftsuspenders.dependencyproviders.ClassProvider(type);
		this._defaultProviders.set(Type.getClassName(type),c);
		return c;
	}
	,createMapping: function(type,name,mappingId) {
		if(Reflect.field(this._mappingsInProcess,mappingId)) throw new org.swiftsuspenders.InjectorError("Can't change a mapping from inside a listener to it's creation event");
		this._mappingsInProcess.set(mappingId,true);
		var mapping = new org.swiftsuspenders.InjectionMapping(this,type,name,mappingId);
		this._mappings.set(mappingId,mapping);
		var sealKey = mapping.seal();
		this._mappingsInProcess.remove(mappingId);
		mapping.unseal(sealKey);
		return mapping;
	}
	,applyInjectionPoints: function(target,targetType,injectionPoint) {
		while(injectionPoint != null) {
			injectionPoint.applyInjection(target,targetType,this);
			injectionPoint = injectionPoint.next;
		}
	}
	,__class__: org.swiftsuspenders.Injector
	,__properties__: {set_parentInjector:"setParentInjector",get_parentInjector:"getParentInjector"}
}
if(!org.swiftsuspenders.haxe) org.swiftsuspenders.haxe = {}
org.swiftsuspenders.haxe.Error = $hxClasses["org.swiftsuspenders.haxe.Error"] = function(message,id) {
	if(id == null) id = "";
	if(message == null) message = "";
	this.message = message;
	this.id = id;
};
org.swiftsuspenders.haxe.Error.__name__ = ["org","swiftsuspenders","haxe","Error"];
org.swiftsuspenders.haxe.Error.prototype = {
	message: null
	,id: null
	,toString: function() {
		return this.message + ", " + this.id;
	}
	,__class__: org.swiftsuspenders.haxe.Error
}
org.swiftsuspenders.InjectorError = $hxClasses["org.swiftsuspenders.InjectorError"] = function(message,id) {
	if(id == null) id = "";
	if(message == null) message = "";
	org.swiftsuspenders.haxe.Error.call(this,message,id);
};
org.swiftsuspenders.InjectorError.__name__ = ["org","swiftsuspenders","InjectorError"];
org.swiftsuspenders.InjectorError.__super__ = org.swiftsuspenders.haxe.Error;
org.swiftsuspenders.InjectorError.prototype = $extend(org.swiftsuspenders.haxe.Error.prototype,{
	__class__: org.swiftsuspenders.InjectorError
});
org.swiftsuspenders.InjectorTests = $hxClasses["org.swiftsuspenders.InjectorTests"] = function() {
	haxe.unit.TestCase.call(this);
};
org.swiftsuspenders.InjectorTests.__name__ = ["org","swiftsuspenders","InjectorTests"];
org.swiftsuspenders.InjectorTests.__super__ = haxe.unit.TestCase;
org.swiftsuspenders.InjectorTests.prototype = $extend(haxe.unit.TestCase.prototype,{
	injector: null
	,receivedInjectorEvents: null
	,setup: function() {
		this.injector = new org.swiftsuspenders.Injector();
		this.receivedInjectorEvents = [];
	}
	,tearDown: function() {
		org.swiftsuspenders.Injector.purgeInjectionPointsCache();
		this.injector = null;
		this.receivedInjectorEvents = null;
	}
	,testUnbindRemovesMapping: function() {
		var injectee = new org.swiftsuspenders.support.injectees.InterfaceInjectee();
		var value = new org.swiftsuspenders.support.types.Clazz();
		this.injector.map(org.swiftsuspenders.support.types.Interface).toValue(value);
		this.assertTrue(this.injector.satisfies(org.swiftsuspenders.support.types.Interface),{ fileName : "InjectorTests.hx", lineNumber : 67, className : "org.swiftsuspenders.InjectorTests", methodName : "testUnbindRemovesMapping"});
		this.injector.unmap(org.swiftsuspenders.support.types.Interface);
		this.assertFalse(this.injector.satisfies(org.swiftsuspenders.support.types.Interface),{ fileName : "InjectorTests.hx", lineNumber : 69, className : "org.swiftsuspenders.InjectorTests", methodName : "testUnbindRemovesMapping"});
	}
	,testInjectorInjectsBoundValueIntoAllInjectees: function() {
		var injectee = new org.swiftsuspenders.support.injectees.ClassInjectee();
		var injectee2 = new org.swiftsuspenders.support.injectees.ClassInjectee();
		var value = new org.swiftsuspenders.support.types.Clazz();
		this.injector.map(org.swiftsuspenders.support.types.Clazz).toValue(value);
		this.injector.injectInto(injectee);
		this.assertTrue(value == injectee.property,{ fileName : "InjectorTests.hx", lineNumber : 80, className : "org.swiftsuspenders.InjectorTests", methodName : "testInjectorInjectsBoundValueIntoAllInjectees"});
		this.injector.injectInto(injectee2);
	}
	,testBindValueByInterface: function() {
		var injectee = new org.swiftsuspenders.support.injectees.InterfaceInjectee();
		var value = new org.swiftsuspenders.support.types.Clazz();
		this.injector.map(org.swiftsuspenders.support.types.Interface).toValue(value);
		this.injector.injectInto(injectee);
		this.assertTrue(value == injectee.property,{ fileName : "InjectorTests.hx", lineNumber : 91, className : "org.swiftsuspenders.InjectorTests", methodName : "testBindValueByInterface"});
	}
	,testBindNamedValue: function() {
		var injectee = new org.swiftsuspenders.support.injectees.NamedClassInjectee();
		var value = new org.swiftsuspenders.support.types.Clazz();
		this.injector.map(org.swiftsuspenders.support.types.Clazz,"Name").toValue(value);
		this.injector.injectInto(injectee);
		this.assertEquals(value,injectee.property,{ fileName : "InjectorTests.hx", lineNumber : 100, className : "org.swiftsuspenders.InjectorTests", methodName : "testBindNamedValue"});
	}
	,testBindNamedValueByInterface: function() {
		var injectee = new org.swiftsuspenders.support.injectees.NamedInterfaceInjectee();
		var value = new org.swiftsuspenders.support.types.Clazz();
		this.injector.map(org.swiftsuspenders.support.types.Interface,"Name").toValue(value);
		this.injector.injectInto(injectee);
		this.assertTrue(value == injectee.property,{ fileName : "InjectorTests.hx", lineNumber : 109, className : "org.swiftsuspenders.InjectorTests", methodName : "testBindNamedValueByInterface"});
	}
	,testBindFalsyValue: function() {
		var injectee = new org.swiftsuspenders.support.injectees.StringInjectee();
		var value = null;
		this.injector.map(String).toValue(value);
		this.injector.injectInto(injectee);
		this.assertEquals(value,injectee.property,{ fileName : "InjectorTests.hx", lineNumber : 118, className : "org.swiftsuspenders.InjectorTests", methodName : "testBindFalsyValue"});
	}
	,testBoundValueIsNotInjectedInto: function() {
		var injectee = new org.swiftsuspenders.support.injectees.RecursiveInterfaceInjectee();
		var value = new org.swiftsuspenders.support.injectees.InterfaceInjectee();
		this.injector.map(org.swiftsuspenders.support.injectees.InterfaceInjectee).toValue(value);
		this.injector.injectInto(injectee);
		this.assertTrue(value.property == null,{ fileName : "InjectorTests.hx", lineNumber : 127, className : "org.swiftsuspenders.InjectorTests", methodName : "testBoundValueIsNotInjectedInto"});
	}
	,testBindMultipleInterfacesToOneSingletonClass: function() {
		var injectee = new org.swiftsuspenders.support.injectees.MultipleSingletonsOfSameClassInjectee();
		this.injector.map(org.swiftsuspenders.support.types.Interface).toSingleton(org.swiftsuspenders.support.types.Clazz);
		this.injector.map(org.swiftsuspenders.support.types.Interface2).toSingleton(org.swiftsuspenders.support.types.Clazz);
		this.injector.injectInto(injectee);
		this.assertTrue(injectee.property1 != null,{ fileName : "InjectorTests.hx", lineNumber : 136, className : "org.swiftsuspenders.InjectorTests", methodName : "testBindMultipleInterfacesToOneSingletonClass"});
		this.assertTrue(injectee.property2 != null,{ fileName : "InjectorTests.hx", lineNumber : 137, className : "org.swiftsuspenders.InjectorTests", methodName : "testBindMultipleInterfacesToOneSingletonClass"});
	}
	,testBindClass: function() {
		var injectee = new org.swiftsuspenders.support.injectees.ClassInjectee();
		var injectee2 = new org.swiftsuspenders.support.injectees.ClassInjectee();
		this.injector.map(org.swiftsuspenders.support.types.Clazz).toType(org.swiftsuspenders.support.types.Clazz);
		this.injector.injectInto(injectee);
		this.assertTrue(injectee.property != null,{ fileName : "InjectorTests.hx", lineNumber : 147, className : "org.swiftsuspenders.InjectorTests", methodName : "testBindClass"});
		this.injector.injectInto(injectee2);
		this.assertTrue(injectee.property != injectee2.property,{ fileName : "InjectorTests.hx", lineNumber : 149, className : "org.swiftsuspenders.InjectorTests", methodName : "testBindClass"});
	}
	,testBoundClassIsInjectedInto: function() {
		var injectee = new org.swiftsuspenders.support.injectees.ComplexClassInjectee();
		var value = new org.swiftsuspenders.support.types.Clazz();
		this.injector.map(org.swiftsuspenders.support.types.Clazz).toValue(value);
		this.injector.map(org.swiftsuspenders.support.types.ComplexClazz).toType(org.swiftsuspenders.support.types.ComplexClazz);
		this.injector.injectInto(injectee);
		this.assertTrue(injectee.property != null,{ fileName : "InjectorTests.hx", lineNumber : 159, className : "org.swiftsuspenders.InjectorTests", methodName : "testBoundClassIsInjectedInto"});
		this.assertTrue(value == injectee.property.value,{ fileName : "InjectorTests.hx", lineNumber : 160, className : "org.swiftsuspenders.InjectorTests", methodName : "testBoundClassIsInjectedInto"});
	}
	,testBindClassByInterface: function() {
		var injectee = new org.swiftsuspenders.support.injectees.InterfaceInjectee();
		this.injector.map(org.swiftsuspenders.support.types.Interface).toType(org.swiftsuspenders.support.types.Clazz);
		this.injector.injectInto(injectee);
		this.assertTrue(injectee.property != null,{ fileName : "InjectorTests.hx", lineNumber : 168, className : "org.swiftsuspenders.InjectorTests", methodName : "testBindClassByInterface"});
	}
	,testBindNamedClass: function() {
		var injectee = new org.swiftsuspenders.support.injectees.NamedClassInjectee();
		this.injector.map(org.swiftsuspenders.support.types.Clazz,"Name").toType(org.swiftsuspenders.support.types.Clazz);
		this.injector.injectInto(injectee);
		this.assertTrue(injectee.property != null,{ fileName : "InjectorTests.hx", lineNumber : 176, className : "org.swiftsuspenders.InjectorTests", methodName : "testBindNamedClass"});
	}
	,testBindNamedClassByInterface: function() {
		var injectee = new org.swiftsuspenders.support.injectees.NamedInterfaceInjectee();
		this.injector.map(org.swiftsuspenders.support.types.Interface,"Name").toType(org.swiftsuspenders.support.types.Clazz);
		this.injector.injectInto(injectee);
		this.assertTrue(injectee.property != null,{ fileName : "InjectorTests.hx", lineNumber : 184, className : "org.swiftsuspenders.InjectorTests", methodName : "testBindNamedClassByInterface"});
	}
	,testBindSingleton: function() {
		var injectee = new org.swiftsuspenders.support.injectees.ClassInjectee();
		var injectee2 = new org.swiftsuspenders.support.injectees.ClassInjectee();
		this.injector.map(org.swiftsuspenders.support.types.Clazz).toSingleton(org.swiftsuspenders.support.types.Clazz);
		this.injector.injectInto(injectee);
		this.assertTrue(injectee.property != null,{ fileName : "InjectorTests.hx", lineNumber : 193, className : "org.swiftsuspenders.InjectorTests", methodName : "testBindSingleton"});
		this.injector.injectInto(injectee2);
		this.assertEquals(injectee.property,injectee2.property,{ fileName : "InjectorTests.hx", lineNumber : 195, className : "org.swiftsuspenders.InjectorTests", methodName : "testBindSingleton"});
	}
	,testBindSingletonOf: function() {
		var injectee = new org.swiftsuspenders.support.injectees.InterfaceInjectee();
		var injectee2 = new org.swiftsuspenders.support.injectees.InterfaceInjectee();
		this.injector.map(org.swiftsuspenders.support.types.Interface).toSingleton(org.swiftsuspenders.support.types.Clazz);
		this.injector.injectInto(injectee);
		this.assertTrue(injectee.property != null,{ fileName : "InjectorTests.hx", lineNumber : 204, className : "org.swiftsuspenders.InjectorTests", methodName : "testBindSingletonOf"});
		this.injector.injectInto(injectee2);
		this.assertTrue(injectee.property == injectee2.property,{ fileName : "InjectorTests.hx", lineNumber : 206, className : "org.swiftsuspenders.InjectorTests", methodName : "testBindSingletonOf"});
	}
	,testBindDifferentlyNamedSingletonsBySameInterface: function() {
		var injectee = new org.swiftsuspenders.support.injectees.TwoNamedInterfaceFieldsInjectee();
		this.injector.map(org.swiftsuspenders.support.types.Interface,"Name1").toSingleton(org.swiftsuspenders.support.types.Clazz);
		this.injector.map(org.swiftsuspenders.support.types.Interface,"Name2").toSingleton(org.swiftsuspenders.support.types.Clazz2);
		this.injector.injectInto(injectee);
		this.assertTrue(Std["is"](injectee.property1,org.swiftsuspenders.support.types.Clazz),{ fileName : "InjectorTests.hx", lineNumber : 215, className : "org.swiftsuspenders.InjectorTests", methodName : "testBindDifferentlyNamedSingletonsBySameInterface"});
		this.assertTrue(Std["is"](injectee.property2,org.swiftsuspenders.support.types.Clazz2),{ fileName : "InjectorTests.hx", lineNumber : 216, className : "org.swiftsuspenders.InjectorTests", methodName : "testBindDifferentlyNamedSingletonsBySameInterface"});
		this.assertTrue(injectee.property1 != injectee.property2,{ fileName : "InjectorTests.hx", lineNumber : 217, className : "org.swiftsuspenders.InjectorTests", methodName : "testBindDifferentlyNamedSingletonsBySameInterface"});
	}
	,testPerformSetterInjection: function() {
		var injectee = new org.swiftsuspenders.support.injectees.SetterInjectee();
		var injectee2 = new org.swiftsuspenders.support.injectees.SetterInjectee();
		this.injector.map(org.swiftsuspenders.support.types.Clazz).toType(org.swiftsuspenders.support.types.Clazz);
		this.injector.injectInto(injectee);
		this.assertTrue(injectee.getProperty() != null,{ fileName : "InjectorTests.hx", lineNumber : 226, className : "org.swiftsuspenders.InjectorTests", methodName : "testPerformSetterInjection"});
		this.injector.injectInto(injectee2);
		this.assertTrue(injectee.getProperty() != injectee2.getProperty(),{ fileName : "InjectorTests.hx", lineNumber : 228, className : "org.swiftsuspenders.InjectorTests", methodName : "testPerformSetterInjection"});
	}
	,testPerformMethodInjectionWithOneParameter: function() {
		var injectee = new org.swiftsuspenders.support.injectees.OneParameterMethodInjectee();
		var injectee2 = new org.swiftsuspenders.support.injectees.OneParameterMethodInjectee();
		this.injector.map(org.swiftsuspenders.support.types.Clazz).toType(org.swiftsuspenders.support.types.Clazz);
		this.injector.injectInto(injectee);
		this.assertTrue(injectee.getDependency() != null,{ fileName : "InjectorTests.hx", lineNumber : 237, className : "org.swiftsuspenders.InjectorTests", methodName : "testPerformMethodInjectionWithOneParameter"});
		this.injector.injectInto(injectee2);
		this.assertTrue(injectee.getDependency() != injectee2.getDependency(),{ fileName : "InjectorTests.hx", lineNumber : 239, className : "org.swiftsuspenders.InjectorTests", methodName : "testPerformMethodInjectionWithOneParameter"});
	}
	,testPerformMethodInjectionWithOneNamedParameter: function() {
		var injectee = new org.swiftsuspenders.support.injectees.OneNamedParameterMethodInjectee();
		var injectee2 = new org.swiftsuspenders.support.injectees.OneNamedParameterMethodInjectee();
		this.injector.map(org.swiftsuspenders.support.types.Clazz,"namedDep").toType(org.swiftsuspenders.support.types.Clazz);
		this.injector.injectInto(injectee);
		this.assertTrue(injectee.getDependency() != null,{ fileName : "InjectorTests.hx", lineNumber : 248, className : "org.swiftsuspenders.InjectorTests", methodName : "testPerformMethodInjectionWithOneNamedParameter"});
		this.injector.injectInto(injectee2);
		this.assertTrue(injectee.getDependency() != injectee2.getDependency(),{ fileName : "InjectorTests.hx", lineNumber : 250, className : "org.swiftsuspenders.InjectorTests", methodName : "testPerformMethodInjectionWithOneNamedParameter"});
	}
	,testPerformMethodInjectionWithTwoParameters: function() {
		var injectee = new org.swiftsuspenders.support.injectees.TwoParametersMethodInjectee();
		var injectee2 = new org.swiftsuspenders.support.injectees.TwoParametersMethodInjectee();
		this.injector.map(org.swiftsuspenders.support.types.Clazz).toType(org.swiftsuspenders.support.types.Clazz);
		this.injector.map(org.swiftsuspenders.support.types.Interface).toType(org.swiftsuspenders.support.types.Clazz);
		this.injector.injectInto(injectee);
		this.assertTrue(injectee.getDependency() != null,{ fileName : "InjectorTests.hx", lineNumber : 260, className : "org.swiftsuspenders.InjectorTests", methodName : "testPerformMethodInjectionWithTwoParameters"});
		this.assertTrue(injectee.getDependency2() != null,{ fileName : "InjectorTests.hx", lineNumber : 261, className : "org.swiftsuspenders.InjectorTests", methodName : "testPerformMethodInjectionWithTwoParameters"});
		this.injector.injectInto(injectee2);
		this.assertTrue(injectee.getDependency() != injectee2.getDependency(),{ fileName : "InjectorTests.hx", lineNumber : 263, className : "org.swiftsuspenders.InjectorTests", methodName : "testPerformMethodInjectionWithTwoParameters"});
		this.assertTrue(injectee.getDependency2() != injectee2.getDependency2(),{ fileName : "InjectorTests.hx", lineNumber : 264, className : "org.swiftsuspenders.InjectorTests", methodName : "testPerformMethodInjectionWithTwoParameters"});
	}
	,testPerformMethodInjectionWithTwoNamedParameters: function() {
		var injectee = new org.swiftsuspenders.support.injectees.TwoNamedParametersMethodInjectee();
		var injectee2 = new org.swiftsuspenders.support.injectees.TwoNamedParametersMethodInjectee();
		this.injector.map(org.swiftsuspenders.support.types.Clazz,"namedDep").toType(org.swiftsuspenders.support.types.Clazz);
		this.injector.map(org.swiftsuspenders.support.types.Interface,"namedDep2").toType(org.swiftsuspenders.support.types.Clazz);
		this.injector.injectInto(injectee);
		this.assertTrue(injectee.getDependency() != null,{ fileName : "InjectorTests.hx", lineNumber : 274, className : "org.swiftsuspenders.InjectorTests", methodName : "testPerformMethodInjectionWithTwoNamedParameters"});
		this.assertTrue(injectee.getDependency2() != null,{ fileName : "InjectorTests.hx", lineNumber : 275, className : "org.swiftsuspenders.InjectorTests", methodName : "testPerformMethodInjectionWithTwoNamedParameters"});
		this.injector.injectInto(injectee2);
		this.assertTrue(injectee.getDependency() != injectee2.getDependency(),{ fileName : "InjectorTests.hx", lineNumber : 277, className : "org.swiftsuspenders.InjectorTests", methodName : "testPerformMethodInjectionWithTwoNamedParameters"});
		this.assertTrue(injectee.getDependency2() != injectee2.getDependency2(),{ fileName : "InjectorTests.hx", lineNumber : 278, className : "org.swiftsuspenders.InjectorTests", methodName : "testPerformMethodInjectionWithTwoNamedParameters"});
	}
	,testPerformMethodInjectionWithMixedParameters: function() {
		var injectee = new org.swiftsuspenders.support.injectees.MixedParametersMethodInjectee();
		var injectee2 = new org.swiftsuspenders.support.injectees.MixedParametersMethodInjectee();
		this.injector.map(org.swiftsuspenders.support.types.Clazz,"namedDep").toType(org.swiftsuspenders.support.types.Clazz);
		this.injector.map(org.swiftsuspenders.support.types.Clazz).toType(org.swiftsuspenders.support.types.Clazz);
		this.injector.map(org.swiftsuspenders.support.types.Interface,"namedDep2").toType(org.swiftsuspenders.support.types.Clazz);
		this.injector.injectInto(injectee);
		this.assertTrue(injectee.getDependency() != null,{ fileName : "InjectorTests.hx", lineNumber : 289, className : "org.swiftsuspenders.InjectorTests", methodName : "testPerformMethodInjectionWithMixedParameters"});
		this.assertTrue(injectee.getDependency2() != null,{ fileName : "InjectorTests.hx", lineNumber : 290, className : "org.swiftsuspenders.InjectorTests", methodName : "testPerformMethodInjectionWithMixedParameters"});
		this.assertTrue(injectee.getDependency3() != null,{ fileName : "InjectorTests.hx", lineNumber : 291, className : "org.swiftsuspenders.InjectorTests", methodName : "testPerformMethodInjectionWithMixedParameters"});
		this.injector.injectInto(injectee2);
		this.assertTrue(injectee.getDependency() != injectee2.getDependency(),{ fileName : "InjectorTests.hx", lineNumber : 293, className : "org.swiftsuspenders.InjectorTests", methodName : "testPerformMethodInjectionWithMixedParameters"});
		this.assertTrue(injectee.getDependency2() != injectee2.getDependency2(),{ fileName : "InjectorTests.hx", lineNumber : 294, className : "org.swiftsuspenders.InjectorTests", methodName : "testPerformMethodInjectionWithMixedParameters"});
		this.assertTrue(injectee.getDependency3() != injectee2.getDependency3(),{ fileName : "InjectorTests.hx", lineNumber : 295, className : "org.swiftsuspenders.InjectorTests", methodName : "testPerformMethodInjectionWithMixedParameters"});
	}
	,testPerformConstructorInjectionWithOneParameter: function() {
		this.injector.map(org.swiftsuspenders.support.types.Clazz);
		var injectee = this.injector.getInstance(org.swiftsuspenders.support.injectees.OneParameterConstructorInjectee);
		this.assertTrue(injectee.getDependency() != null,{ fileName : "InjectorTests.hx", lineNumber : 302, className : "org.swiftsuspenders.InjectorTests", methodName : "testPerformConstructorInjectionWithOneParameter"});
	}
	,testPerformConstructorInjectionWithTwoParameters: function() {
		this.injector.map(org.swiftsuspenders.support.types.Clazz);
		this.injector.map(String).toValue("stringDependency");
		var injectee = this.injector.getInstance(org.swiftsuspenders.support.injectees.TwoParametersConstructorInjectee);
		this.assertTrue(injectee.getDependency() != null,{ fileName : "InjectorTests.hx", lineNumber : 310, className : "org.swiftsuspenders.InjectorTests", methodName : "testPerformConstructorInjectionWithTwoParameters"});
		this.assertTrue(injectee.getDependency2() == "stringDependency",{ fileName : "InjectorTests.hx", lineNumber : 311, className : "org.swiftsuspenders.InjectorTests", methodName : "testPerformConstructorInjectionWithTwoParameters"});
	}
	,testPerformConstructorInjectionWithOneNamedParameter: function() {
		this.injector.map(org.swiftsuspenders.support.types.Clazz,"namedDependency").toType(org.swiftsuspenders.support.types.Clazz);
		var injectee = this.injector.getInstance(org.swiftsuspenders.support.injectees.OneNamedParameterConstructorInjectee);
		this.assertTrue(injectee.getDependency() != null,{ fileName : "InjectorTests.hx", lineNumber : 318, className : "org.swiftsuspenders.InjectorTests", methodName : "testPerformConstructorInjectionWithOneNamedParameter"});
	}
	,testPerformXMLConfiguredConstructorInjectionWithOneNamedParameter: function() {
		this.injector = new org.swiftsuspenders.Injector();
		this.injector.map(org.swiftsuspenders.support.types.Clazz,"namedDependency").toType(org.swiftsuspenders.support.types.Clazz);
		var injectee = this.injector.getInstance(org.swiftsuspenders.support.injectees.OneNamedParameterConstructorInjectee);
		this.assertTrue(injectee.getDependency() != null,{ fileName : "InjectorTests.hx", lineNumber : 326, className : "org.swiftsuspenders.InjectorTests", methodName : "testPerformXMLConfiguredConstructorInjectionWithOneNamedParameter"});
	}
	,testPerformConstructorInjectionWithTwoNamedParameter: function() {
		this.injector.map(org.swiftsuspenders.support.types.Clazz,"namedDependency").toType(org.swiftsuspenders.support.types.Clazz);
		this.injector.map(String,"namedDependency2").toValue("stringDependency");
		var injectee = this.injector.getInstance(org.swiftsuspenders.support.injectees.TwoNamedParametersConstructorInjectee);
		this.assertTrue(injectee.getDependency() != null,{ fileName : "InjectorTests.hx", lineNumber : 334, className : "org.swiftsuspenders.InjectorTests", methodName : "testPerformConstructorInjectionWithTwoNamedParameter"});
		this.assertTrue(injectee.getDependency2() == "stringDependency",{ fileName : "InjectorTests.hx", lineNumber : 335, className : "org.swiftsuspenders.InjectorTests", methodName : "testPerformConstructorInjectionWithTwoNamedParameter"});
	}
	,testPerformConstructorInjectionWithMixedParameters: function() {
		this.injector.map(org.swiftsuspenders.support.types.Clazz,"namedDep").toType(org.swiftsuspenders.support.types.Clazz);
		this.injector.map(org.swiftsuspenders.support.types.Clazz).toType(org.swiftsuspenders.support.types.Clazz);
		this.injector.map(org.swiftsuspenders.support.types.Interface,"namedDep2").toType(org.swiftsuspenders.support.types.Clazz);
		var injectee = this.injector.getInstance(org.swiftsuspenders.support.injectees.MixedParametersConstructorInjectee);
		this.assertTrue(injectee.getDependency() != null,{ fileName : "InjectorTests.hx", lineNumber : 344, className : "org.swiftsuspenders.InjectorTests", methodName : "testPerformConstructorInjectionWithMixedParameters"});
		this.assertTrue(injectee.getDependency2() != null,{ fileName : "InjectorTests.hx", lineNumber : 345, className : "org.swiftsuspenders.InjectorTests", methodName : "testPerformConstructorInjectionWithMixedParameters"});
		this.assertTrue(injectee.getDependency3() != null,{ fileName : "InjectorTests.hx", lineNumber : 346, className : "org.swiftsuspenders.InjectorTests", methodName : "testPerformConstructorInjectionWithMixedParameters"});
	}
	,testPerformMappedMappingInjection: function() {
		var mapping = this.injector.map(org.swiftsuspenders.support.types.Interface);
		mapping.toSingleton(org.swiftsuspenders.support.types.Clazz);
		this.injector.map(org.swiftsuspenders.support.types.Interface2).toProvider(new org.swiftsuspenders.dependencyproviders.OtherMappingProvider(mapping));
		var injectee = this.injector.getInstance(org.swiftsuspenders.support.injectees.MultipleSingletonsOfSameClassInjectee);
		this.assertTrue(injectee.property1 == injectee.property2,{ fileName : "InjectorTests.hx", lineNumber : 364, className : "org.swiftsuspenders.InjectorTests", methodName : "testPerformMappedMappingInjection"});
	}
	,testPerformMappedNamedMappingInjection: function() {
		var mapping = this.injector.map(org.swiftsuspenders.support.types.Interface);
		mapping.toSingleton(org.swiftsuspenders.support.types.Clazz);
		this.injector.map(org.swiftsuspenders.support.types.Interface2).toProvider(new org.swiftsuspenders.dependencyproviders.OtherMappingProvider(mapping));
		this.injector.map(org.swiftsuspenders.support.types.Interface,"name1").toProvider(new org.swiftsuspenders.dependencyproviders.OtherMappingProvider(mapping));
		this.injector.map(org.swiftsuspenders.support.types.Interface2,"name2").toProvider(new org.swiftsuspenders.dependencyproviders.OtherMappingProvider(mapping));
		var injectee = this.injector.getInstance(org.swiftsuspenders.support.injectees.MultipleNamedSingletonsOfSameClassInjectee);
		this.assertTrue(injectee.property1 == injectee.property2,{ fileName : "InjectorTests.hx", lineNumber : 375, className : "org.swiftsuspenders.InjectorTests", methodName : "testPerformMappedNamedMappingInjection"});
		this.assertTrue(injectee.property1,injectee.namedProperty1);
		this.assertTrue(injectee.property1,injectee.namedProperty2);
	}
	,testHaltOnMissingDependency: function() {
		var errThrown = false;
		try {
			var injectee = new org.swiftsuspenders.support.injectees.InterfaceInjectee();
			this.injector.injectInto(injectee);
		} catch( e ) {
			errThrown = true;
		}
		this.assertTrue(errThrown,{ fileName : "InjectorTests.hx", lineNumber : 397, className : "org.swiftsuspenders.InjectorTests", methodName : "testHaltOnMissingDependency"});
	}
	,testHaltOnMissingNamedDependency: function() {
		var errThrown = false;
		try {
			var injectee = new org.swiftsuspenders.support.injectees.NamedClassInjectee();
			this.injector.injectInto(injectee);
		} catch( e ) {
			errThrown = true;
		}
		this.assertTrue(errThrown,{ fileName : "InjectorTests.hx", lineNumber : 408, className : "org.swiftsuspenders.InjectorTests", methodName : "testHaltOnMissingNamedDependency"});
	}
	,testPostConstructIsCalled: function() {
		var injectee = new org.swiftsuspenders.support.injectees.ClassInjectee();
		var value = new org.swiftsuspenders.support.types.Clazz();
		this.injector.map(org.swiftsuspenders.support.types.Clazz).toValue(value);
		this.injector.injectInto(injectee);
		this.assertTrue(injectee.someProperty,{ fileName : "InjectorTests.hx", lineNumber : 417, className : "org.swiftsuspenders.InjectorTests", methodName : "testPostConstructIsCalled"});
	}
	,testPostConstructWithArgIsCalledCorrectly: function() {
		this.injector.map(org.swiftsuspenders.support.types.Clazz);
		var injectee = this.injector.getInstance(org.swiftsuspenders.support.injectees.PostConstructWithArgInjectee);
		this.assertTrue(Std["is"](injectee.property,org.swiftsuspenders.support.types.Clazz),{ fileName : "InjectorTests.hx", lineNumber : 424, className : "org.swiftsuspenders.InjectorTests", methodName : "testPostConstructWithArgIsCalledCorrectly"});
	}
	,satisfiesSucceedsForUnmappedUnnamedClass: function() {
		this.assertTrue(this.injector.satisfies(org.swiftsuspenders.support.types.Clazz),{ fileName : "InjectorTests.hx", lineNumber : 436, className : "org.swiftsuspenders.InjectorTests", methodName : "satisfiesSucceedsForUnmappedUnnamedClass"});
	}
	,testHasMappingFailsForUnmappedNamedClass: function() {
		this.assertFalse(this.injector.satisfies(org.swiftsuspenders.support.types.Clazz,"namedClass"),{ fileName : "InjectorTests.hx", lineNumber : 441, className : "org.swiftsuspenders.InjectorTests", methodName : "testHasMappingFailsForUnmappedNamedClass"});
	}
	,testHasMappingSucceedsForMappedUnnamedClass: function() {
		this.injector.map(org.swiftsuspenders.support.types.Clazz).toType(org.swiftsuspenders.support.types.Clazz);
		this.assertTrue(this.injector.satisfies(org.swiftsuspenders.support.types.Clazz),{ fileName : "InjectorTests.hx", lineNumber : 447, className : "org.swiftsuspenders.InjectorTests", methodName : "testHasMappingSucceedsForMappedUnnamedClass"});
	}
	,testHasMappingSucceedsForMappedNamedClass: function() {
		this.injector.map(org.swiftsuspenders.support.types.Clazz,"namedClass").toType(org.swiftsuspenders.support.types.Clazz);
		this.assertTrue(this.injector.satisfies(org.swiftsuspenders.support.types.Clazz,"namedClass"),{ fileName : "InjectorTests.hx", lineNumber : 453, className : "org.swiftsuspenders.InjectorTests", methodName : "testHasMappingSucceedsForMappedNamedClass"});
	}
	,testGetMappingResponseFailsForUnmappedNamedClass: function() {
		var errThrown = false;
		try {
			this.injector.getInstance(org.swiftsuspenders.support.types.Clazz,"namedClass");
		} catch( e ) {
			errThrown = true;
		}
		this.assertTrue(errThrown,{ fileName : "InjectorTests.hx", lineNumber : 463, className : "org.swiftsuspenders.InjectorTests", methodName : "testGetMappingResponseFailsForUnmappedNamedClass"});
	}
	,testGetMappingResponseSucceedsForMappedUnnamedClass: function() {
		var clazz = new org.swiftsuspenders.support.types.Clazz();
		this.injector.map(org.swiftsuspenders.support.types.Clazz).toValue(clazz);
		this.assertTrue(this.injector.getInstance(org.swiftsuspenders.support.types.Clazz) == clazz,{ fileName : "InjectorTests.hx", lineNumber : 470, className : "org.swiftsuspenders.InjectorTests", methodName : "testGetMappingResponseSucceedsForMappedUnnamedClass"});
	}
	,testGetMappingResponseSucceedsForMappedNamedClass: function() {
		var clazz = new org.swiftsuspenders.support.types.Clazz();
		this.injector.map(org.swiftsuspenders.support.types.Clazz,"namedClass").toValue(clazz);
		this.assertTrue(this.injector.getInstance(org.swiftsuspenders.support.types.Clazz,"namedClass") == clazz,{ fileName : "InjectorTests.hx", lineNumber : 477, className : "org.swiftsuspenders.InjectorTests", methodName : "testGetMappingResponseSucceedsForMappedNamedClass"});
	}
	,testInjectorRemovesSingletonInstanceOnMappingRemoval: function() {
		this.injector.map(org.swiftsuspenders.support.types.Clazz).toSingleton(org.swiftsuspenders.support.types.Clazz);
		var injectee1 = this.injector.getInstance(org.swiftsuspenders.support.injectees.ClassInjectee);
		this.injector.unmap(org.swiftsuspenders.support.types.Clazz);
		this.injector.map(org.swiftsuspenders.support.types.Clazz).toSingleton(org.swiftsuspenders.support.types.Clazz);
		var injectee2 = this.injector.getInstance(org.swiftsuspenders.support.injectees.ClassInjectee);
		this.assertTrue(injectee1.property != injectee2.property,{ fileName : "InjectorTests.hx", lineNumber : 487, className : "org.swiftsuspenders.InjectorTests", methodName : "testInjectorRemovesSingletonInstanceOnMappingRemoval"});
	}
	,testInstantiateThrowsMeaningfulErrorOnInterfaceInstantiation: function() {
		var errThrown = false;
		try {
			this.injector.getInstance(org.swiftsuspenders.support.types.Interface);
		} catch( e ) {
			errThrown = true;
		}
		this.assertTrue(errThrown,{ fileName : "InjectorTests.hx", lineNumber : 497, className : "org.swiftsuspenders.InjectorTests", methodName : "testInstantiateThrowsMeaningfulErrorOnInterfaceInstantiation"});
	}
	,testInjectorDoesntThrowWhenAttemptingUnmappedOptionalPropertyInjection: function() {
		var injectee = this.injector.getInstance(org.swiftsuspenders.support.injectees.OptionalClassInjectee);
		this.assertTrue(injectee.property == null,{ fileName : "InjectorTests.hx", lineNumber : 503, className : "org.swiftsuspenders.InjectorTests", methodName : "testInjectorDoesntThrowWhenAttemptingUnmappedOptionalPropertyInjection"});
	}
	,testInjectorDoesntThrowWhenAttemptingUnmappedOptionalMethodInjection: function() {
		var injectee = this.injector.getInstance(org.swiftsuspenders.support.injectees.OptionalOneRequiredParameterMethodInjectee);
		this.assertTrue(injectee.getDependency() == null,{ fileName : "InjectorTests.hx", lineNumber : 509, className : "org.swiftsuspenders.InjectorTests", methodName : "testInjectorDoesntThrowWhenAttemptingUnmappedOptionalMethodInjection"});
	}
	,testSoftMappingIsUsedIfNoParentInjectorAvailable: function() {
		this.injector.map(org.swiftsuspenders.support.types.Interface).toType(org.swiftsuspenders.support.types.Clazz).soft();
		this.assertTrue(this.injector.getInstance(org.swiftsuspenders.support.types.Interface) != null,{ fileName : "InjectorTests.hx", lineNumber : 515, className : "org.swiftsuspenders.InjectorTests", methodName : "testSoftMappingIsUsedIfNoParentInjectorAvailable"});
	}
	,testParentMappingIsUsedInsteadOfSoftChildMapping: function() {
		var childInjector = this.injector.createChildInjector();
		this.injector.map(org.swiftsuspenders.support.types.Interface).toType(org.swiftsuspenders.support.types.Clazz);
		childInjector.map(org.swiftsuspenders.support.types.Interface).toType(org.swiftsuspenders.support.types.Clazz2).soft();
		this.assertTrue(Std["is"](childInjector.getInstance(org.swiftsuspenders.support.types.Interface),org.swiftsuspenders.support.types.Clazz),{ fileName : "InjectorTests.hx", lineNumber : 523, className : "org.swiftsuspenders.InjectorTests", methodName : "testParentMappingIsUsedInsteadOfSoftChildMapping"});
	}
	,testLocalMappingsAreUsedInOwnInjector: function() {
		this.injector.map(org.swiftsuspenders.support.types.Interface).toType(org.swiftsuspenders.support.types.Clazz).local();
		this.assertTrue(this.injector.getInstance(org.swiftsuspenders.support.types.Interface) != null,{ fileName : "InjectorTests.hx", lineNumber : 539, className : "org.swiftsuspenders.InjectorTests", methodName : "testLocalMappingsAreUsedInOwnInjector"});
	}
	,testLocalMappingsArentSharedWithChildInjectors: function() {
		var errThrown = false;
		try {
			var childInjector = this.injector.createChildInjector();
			this.injector.map(org.swiftsuspenders.support.types.Interface).toType(org.swiftsuspenders.support.types.Clazz).local();
			childInjector.getInstance(org.swiftsuspenders.support.types.Interface);
		} catch( e ) {
			errThrown = true;
		}
		this.assertTrue(errThrown,{ fileName : "InjectorTests.hx", lineNumber : 551, className : "org.swiftsuspenders.InjectorTests", methodName : "testLocalMappingsArentSharedWithChildInjectors"});
	}
	,testCallingSharedTurnsLocalMappingsIntoSharedOnes: function() {
		var childInjector = this.injector.createChildInjector();
		this.injector.map(org.swiftsuspenders.support.types.Interface).toType(org.swiftsuspenders.support.types.Clazz).local();
		this.injector.map(org.swiftsuspenders.support.types.Interface).toType(org.swiftsuspenders.support.types.Clazz).shared();
		this.assertTrue(childInjector.getInstance(org.swiftsuspenders.support.types.Interface) != null,{ fileName : "InjectorTests.hx", lineNumber : 559, className : "org.swiftsuspenders.InjectorTests", methodName : "testCallingSharedTurnsLocalMappingsIntoSharedOnes"});
	}
	,testInjectorUsesManuallySuppliedTypeDescriptionForField: function() {
		var description = new org.swiftsuspenders.typedescriptions.TypeDescription();
		description.addFieldInjection("property",org.swiftsuspenders.support.types.Clazz);
		this.injector.addTypeDescription(org.swiftsuspenders.support.injectees.NamedClassInjectee,description);
		this.injector.map(org.swiftsuspenders.support.types.Clazz);
		var injectee = this.injector.getInstance(org.swiftsuspenders.support.injectees.NamedClassInjectee);
		this.assertTrue(injectee.property != null,{ fileName : "InjectorTests.hx", lineNumber : 745, className : "org.swiftsuspenders.InjectorTests", methodName : "testInjectorUsesManuallySuppliedTypeDescriptionForField"});
	}
	,__class__: org.swiftsuspenders.InjectorTests
});
org.swiftsuspenders.ReflectorBaseTests = $hxClasses["org.swiftsuspenders.ReflectorBaseTests"] = function() {
	haxe.unit.TestCase.call(this);
};
org.swiftsuspenders.ReflectorBaseTests.__name__ = ["org","swiftsuspenders","ReflectorBaseTests"];
org.swiftsuspenders.ReflectorBaseTests.__super__ = haxe.unit.TestCase;
org.swiftsuspenders.ReflectorBaseTests.prototype = $extend(haxe.unit.TestCase.prototype,{
	_reflector: null
	,setup: function() {
		this._reflector = new org.swiftsuspenders.ReflectorBase();
	}
	,tearDown: function() {
		this._reflector = null;
	}
	,testGetClassReturnsConstructorForObject: function() {
		var object = { };
		var objectClass = this._reflector.getClass(object);
		this.assertTrue(Std["is"](objectClass,Dynamic),{ fileName : "ReflectorBaseTests.hx", lineNumber : 29, className : "org.swiftsuspenders.ReflectorBaseTests", methodName : "testGetClassReturnsConstructorForObject"});
	}
	,__class__: org.swiftsuspenders.ReflectorBaseTests
});
if(!org.swiftsuspenders.dependencyproviders) org.swiftsuspenders.dependencyproviders = {}
org.swiftsuspenders.dependencyproviders.DependencyProvider = $hxClasses["org.swiftsuspenders.dependencyproviders.DependencyProvider"] = function() { }
org.swiftsuspenders.dependencyproviders.DependencyProvider.__name__ = ["org","swiftsuspenders","dependencyproviders","DependencyProvider"];
org.swiftsuspenders.dependencyproviders.DependencyProvider.prototype = {
	apply: null
	,__class__: org.swiftsuspenders.dependencyproviders.DependencyProvider
}
org.swiftsuspenders.dependencyproviders.ClassProvider = $hxClasses["org.swiftsuspenders.dependencyproviders.ClassProvider"] = function(responseType) {
	this._responseType = responseType;
};
org.swiftsuspenders.dependencyproviders.ClassProvider.__name__ = ["org","swiftsuspenders","dependencyproviders","ClassProvider"];
org.swiftsuspenders.dependencyproviders.ClassProvider.__interfaces__ = [org.swiftsuspenders.dependencyproviders.DependencyProvider];
org.swiftsuspenders.dependencyproviders.ClassProvider.prototype = {
	_responseType: null
	,apply: function(targetType,activeInjector,injectParameters) {
		return activeInjector.instantiateUnmapped(this._responseType);
	}
	,__class__: org.swiftsuspenders.dependencyproviders.ClassProvider
}
org.swiftsuspenders.dependencyproviders.ForwardingProvider = $hxClasses["org.swiftsuspenders.dependencyproviders.ForwardingProvider"] = function(provider) {
	this.provider = provider;
};
org.swiftsuspenders.dependencyproviders.ForwardingProvider.__name__ = ["org","swiftsuspenders","dependencyproviders","ForwardingProvider"];
org.swiftsuspenders.dependencyproviders.ForwardingProvider.__interfaces__ = [org.swiftsuspenders.dependencyproviders.DependencyProvider];
org.swiftsuspenders.dependencyproviders.ForwardingProvider.prototype = {
	provider: null
	,apply: function(targetType,activeInjector,injectParameters) {
		return this.provider.apply(targetType,activeInjector,injectParameters);
	}
	,__class__: org.swiftsuspenders.dependencyproviders.ForwardingProvider
}
org.swiftsuspenders.dependencyproviders.InjectorUsingProvider = $hxClasses["org.swiftsuspenders.dependencyproviders.InjectorUsingProvider"] = function(injector,provider) {
	org.swiftsuspenders.dependencyproviders.ForwardingProvider.call(this,provider);
	this.injector = injector;
};
org.swiftsuspenders.dependencyproviders.InjectorUsingProvider.__name__ = ["org","swiftsuspenders","dependencyproviders","InjectorUsingProvider"];
org.swiftsuspenders.dependencyproviders.InjectorUsingProvider.__super__ = org.swiftsuspenders.dependencyproviders.ForwardingProvider;
org.swiftsuspenders.dependencyproviders.InjectorUsingProvider.prototype = $extend(org.swiftsuspenders.dependencyproviders.ForwardingProvider.prototype,{
	injector: null
	,apply: function(targetType,activeInjector,injectParameters) {
		return this.provider.apply(targetType,this.injector,injectParameters);
	}
	,__class__: org.swiftsuspenders.dependencyproviders.InjectorUsingProvider
});
org.swiftsuspenders.dependencyproviders.LocalOnlyProvider = $hxClasses["org.swiftsuspenders.dependencyproviders.LocalOnlyProvider"] = function(provider) {
	org.swiftsuspenders.dependencyproviders.ForwardingProvider.call(this,provider);
};
org.swiftsuspenders.dependencyproviders.LocalOnlyProvider.__name__ = ["org","swiftsuspenders","dependencyproviders","LocalOnlyProvider"];
org.swiftsuspenders.dependencyproviders.LocalOnlyProvider.__super__ = org.swiftsuspenders.dependencyproviders.ForwardingProvider;
org.swiftsuspenders.dependencyproviders.LocalOnlyProvider.prototype = $extend(org.swiftsuspenders.dependencyproviders.ForwardingProvider.prototype,{
	__class__: org.swiftsuspenders.dependencyproviders.LocalOnlyProvider
});
org.swiftsuspenders.dependencyproviders.OtherMappingProvider = $hxClasses["org.swiftsuspenders.dependencyproviders.OtherMappingProvider"] = function(mapping) {
	this._mapping = mapping;
};
org.swiftsuspenders.dependencyproviders.OtherMappingProvider.__name__ = ["org","swiftsuspenders","dependencyproviders","OtherMappingProvider"];
org.swiftsuspenders.dependencyproviders.OtherMappingProvider.__interfaces__ = [org.swiftsuspenders.dependencyproviders.DependencyProvider];
org.swiftsuspenders.dependencyproviders.OtherMappingProvider.prototype = {
	_mapping: null
	,apply: function(targetType,activeInjector,injectParameters) {
		return this._mapping.getProvider().apply(targetType,activeInjector,injectParameters);
	}
	,__class__: org.swiftsuspenders.dependencyproviders.OtherMappingProvider
}
org.swiftsuspenders.dependencyproviders.SingletonProvider = $hxClasses["org.swiftsuspenders.dependencyproviders.SingletonProvider"] = function(responseType,creatingInjector) {
	this._responseType = responseType;
	this._creatingInjector = creatingInjector;
};
org.swiftsuspenders.dependencyproviders.SingletonProvider.__name__ = ["org","swiftsuspenders","dependencyproviders","SingletonProvider"];
org.swiftsuspenders.dependencyproviders.SingletonProvider.__interfaces__ = [org.swiftsuspenders.dependencyproviders.DependencyProvider];
org.swiftsuspenders.dependencyproviders.SingletonProvider.prototype = {
	_responseType: null
	,_creatingInjector: null
	,_response: null
	,apply: function(targetType,activeInjector,injectParameters) {
		if(!this._response) this._response = this.createResponse(this._creatingInjector);
		return this._response;
	}
	,createResponse: function(injector) {
		return injector.instantiateUnmapped(this._responseType);
	}
	,__class__: org.swiftsuspenders.dependencyproviders.SingletonProvider
}
org.swiftsuspenders.dependencyproviders.SoftDependencyProvider = $hxClasses["org.swiftsuspenders.dependencyproviders.SoftDependencyProvider"] = function(provider) {
	org.swiftsuspenders.dependencyproviders.ForwardingProvider.call(this,provider);
};
org.swiftsuspenders.dependencyproviders.SoftDependencyProvider.__name__ = ["org","swiftsuspenders","dependencyproviders","SoftDependencyProvider"];
org.swiftsuspenders.dependencyproviders.SoftDependencyProvider.__super__ = org.swiftsuspenders.dependencyproviders.ForwardingProvider;
org.swiftsuspenders.dependencyproviders.SoftDependencyProvider.prototype = $extend(org.swiftsuspenders.dependencyproviders.ForwardingProvider.prototype,{
	__class__: org.swiftsuspenders.dependencyproviders.SoftDependencyProvider
});
org.swiftsuspenders.dependencyproviders.ValueProvider = $hxClasses["org.swiftsuspenders.dependencyproviders.ValueProvider"] = function(value) {
	this._value = value;
};
org.swiftsuspenders.dependencyproviders.ValueProvider.__name__ = ["org","swiftsuspenders","dependencyproviders","ValueProvider"];
org.swiftsuspenders.dependencyproviders.ValueProvider.__interfaces__ = [org.swiftsuspenders.dependencyproviders.DependencyProvider];
org.swiftsuspenders.dependencyproviders.ValueProvider.prototype = {
	_value: null
	,apply: function(targetType,activeInjector,injectParameters) {
		return this._value;
	}
	,__class__: org.swiftsuspenders.dependencyproviders.ValueProvider
}
if(!org.swiftsuspenders.support) org.swiftsuspenders.support = {}
if(!org.swiftsuspenders.support.injectees) org.swiftsuspenders.support.injectees = {}
org.swiftsuspenders.support.injectees.ClassInjectee = $hxClasses["org.swiftsuspenders.support.injectees.ClassInjectee"] = function() {
	this.someProperty = false;
};
org.swiftsuspenders.support.injectees.ClassInjectee.__name__ = ["org","swiftsuspenders","support","injectees","ClassInjectee"];
org.swiftsuspenders.support.injectees.ClassInjectee.prototype = {
	property: null
	,someProperty: null
	,doSomeStuff: function() {
		this.someProperty = true;
	}
	,__class__: org.swiftsuspenders.support.injectees.ClassInjectee
}
org.swiftsuspenders.support.injectees.ComplexClassInjectee = $hxClasses["org.swiftsuspenders.support.injectees.ComplexClassInjectee"] = function() {
};
org.swiftsuspenders.support.injectees.ComplexClassInjectee.__name__ = ["org","swiftsuspenders","support","injectees","ComplexClassInjectee"];
org.swiftsuspenders.support.injectees.ComplexClassInjectee.prototype = {
	property: null
	,__class__: org.swiftsuspenders.support.injectees.ComplexClassInjectee
}
org.swiftsuspenders.support.injectees.InterfaceInjectee = $hxClasses["org.swiftsuspenders.support.injectees.InterfaceInjectee"] = function() {
};
org.swiftsuspenders.support.injectees.InterfaceInjectee.__name__ = ["org","swiftsuspenders","support","injectees","InterfaceInjectee"];
org.swiftsuspenders.support.injectees.InterfaceInjectee.prototype = {
	property: null
	,__class__: org.swiftsuspenders.support.injectees.InterfaceInjectee
}
org.swiftsuspenders.support.injectees.MixedParametersConstructorInjectee = $hxClasses["org.swiftsuspenders.support.injectees.MixedParametersConstructorInjectee"] = function(dependency,dependency2,dependency3) {
	this.m_dependency = dependency;
	this.m_dependency2 = dependency2;
	this.m_dependency3 = dependency3;
};
org.swiftsuspenders.support.injectees.MixedParametersConstructorInjectee.__name__ = ["org","swiftsuspenders","support","injectees","MixedParametersConstructorInjectee"];
org.swiftsuspenders.support.injectees.MixedParametersConstructorInjectee.prototype = {
	m_dependency: null
	,m_dependency2: null
	,m_dependency3: null
	,getDependency: function() {
		return this.m_dependency;
	}
	,getDependency2: function() {
		return this.m_dependency2;
	}
	,getDependency3: function() {
		return this.m_dependency3;
	}
	,__class__: org.swiftsuspenders.support.injectees.MixedParametersConstructorInjectee
}
org.swiftsuspenders.support.injectees.MixedParametersMethodInjectee = $hxClasses["org.swiftsuspenders.support.injectees.MixedParametersMethodInjectee"] = function() {
};
org.swiftsuspenders.support.injectees.MixedParametersMethodInjectee.__name__ = ["org","swiftsuspenders","support","injectees","MixedParametersMethodInjectee"];
org.swiftsuspenders.support.injectees.MixedParametersMethodInjectee.prototype = {
	m_dependency: null
	,m_dependency2: null
	,m_dependency3: null
	,setDependencies: function(dependency,dependency2,dependency3) {
		this.m_dependency = dependency;
		this.m_dependency2 = dependency2;
		this.m_dependency3 = dependency3;
	}
	,getDependency: function() {
		return this.m_dependency;
	}
	,getDependency2: function() {
		return this.m_dependency2;
	}
	,getDependency3: function() {
		return this.m_dependency3;
	}
	,__class__: org.swiftsuspenders.support.injectees.MixedParametersMethodInjectee
}
org.swiftsuspenders.support.injectees.MultipleNamedSingletonsOfSameClassInjectee = $hxClasses["org.swiftsuspenders.support.injectees.MultipleNamedSingletonsOfSameClassInjectee"] = function() {
};
org.swiftsuspenders.support.injectees.MultipleNamedSingletonsOfSameClassInjectee.__name__ = ["org","swiftsuspenders","support","injectees","MultipleNamedSingletonsOfSameClassInjectee"];
org.swiftsuspenders.support.injectees.MultipleNamedSingletonsOfSameClassInjectee.prototype = {
	property1: null
	,property2: null
	,namedProperty1: null
	,namedProperty2: null
	,__class__: org.swiftsuspenders.support.injectees.MultipleNamedSingletonsOfSameClassInjectee
}
org.swiftsuspenders.support.injectees.MultipleSingletonsOfSameClassInjectee = $hxClasses["org.swiftsuspenders.support.injectees.MultipleSingletonsOfSameClassInjectee"] = function() {
};
org.swiftsuspenders.support.injectees.MultipleSingletonsOfSameClassInjectee.__name__ = ["org","swiftsuspenders","support","injectees","MultipleSingletonsOfSameClassInjectee"];
org.swiftsuspenders.support.injectees.MultipleSingletonsOfSameClassInjectee.prototype = {
	property1: null
	,property2: null
	,__class__: org.swiftsuspenders.support.injectees.MultipleSingletonsOfSameClassInjectee
}
org.swiftsuspenders.support.injectees.NamedClassInjectee = $hxClasses["org.swiftsuspenders.support.injectees.NamedClassInjectee"] = function() {
};
org.swiftsuspenders.support.injectees.NamedClassInjectee.__name__ = ["org","swiftsuspenders","support","injectees","NamedClassInjectee"];
org.swiftsuspenders.support.injectees.NamedClassInjectee.prototype = {
	property: null
	,__class__: org.swiftsuspenders.support.injectees.NamedClassInjectee
}
org.swiftsuspenders.support.injectees.NamedInterfaceInjectee = $hxClasses["org.swiftsuspenders.support.injectees.NamedInterfaceInjectee"] = function() {
};
org.swiftsuspenders.support.injectees.NamedInterfaceInjectee.__name__ = ["org","swiftsuspenders","support","injectees","NamedInterfaceInjectee"];
org.swiftsuspenders.support.injectees.NamedInterfaceInjectee.prototype = {
	property: null
	,__class__: org.swiftsuspenders.support.injectees.NamedInterfaceInjectee
}
org.swiftsuspenders.support.injectees.OneNamedParameterConstructorInjectee = $hxClasses["org.swiftsuspenders.support.injectees.OneNamedParameterConstructorInjectee"] = function(dependency) {
	this.m_dependency = dependency;
};
org.swiftsuspenders.support.injectees.OneNamedParameterConstructorInjectee.__name__ = ["org","swiftsuspenders","support","injectees","OneNamedParameterConstructorInjectee"];
org.swiftsuspenders.support.injectees.OneNamedParameterConstructorInjectee.prototype = {
	m_dependency: null
	,getDependency: function() {
		return this.m_dependency;
	}
	,__class__: org.swiftsuspenders.support.injectees.OneNamedParameterConstructorInjectee
}
org.swiftsuspenders.support.injectees.OneNamedParameterMethodInjectee = $hxClasses["org.swiftsuspenders.support.injectees.OneNamedParameterMethodInjectee"] = function() {
};
org.swiftsuspenders.support.injectees.OneNamedParameterMethodInjectee.__name__ = ["org","swiftsuspenders","support","injectees","OneNamedParameterMethodInjectee"];
org.swiftsuspenders.support.injectees.OneNamedParameterMethodInjectee.prototype = {
	m_dependency: null
	,setDependency: function(dependency) {
		this.m_dependency = dependency;
	}
	,getDependency: function() {
		return this.m_dependency;
	}
	,__class__: org.swiftsuspenders.support.injectees.OneNamedParameterMethodInjectee
}
org.swiftsuspenders.support.injectees.OneParameterConstructorInjectee = $hxClasses["org.swiftsuspenders.support.injectees.OneParameterConstructorInjectee"] = function(dependency) {
	this.m_dependency = dependency;
};
org.swiftsuspenders.support.injectees.OneParameterConstructorInjectee.__name__ = ["org","swiftsuspenders","support","injectees","OneParameterConstructorInjectee"];
org.swiftsuspenders.support.injectees.OneParameterConstructorInjectee.prototype = {
	m_dependency: null
	,getDependency: function() {
		return this.m_dependency;
	}
	,__class__: org.swiftsuspenders.support.injectees.OneParameterConstructorInjectee
}
org.swiftsuspenders.support.injectees.OneParameterMethodInjectee = $hxClasses["org.swiftsuspenders.support.injectees.OneParameterMethodInjectee"] = function() {
};
org.swiftsuspenders.support.injectees.OneParameterMethodInjectee.__name__ = ["org","swiftsuspenders","support","injectees","OneParameterMethodInjectee"];
org.swiftsuspenders.support.injectees.OneParameterMethodInjectee.prototype = {
	m_dependency: null
	,setDependency: function(dependency) {
		this.m_dependency = dependency;
	}
	,getDependency: function() {
		return this.m_dependency;
	}
	,__class__: org.swiftsuspenders.support.injectees.OneParameterMethodInjectee
}
org.swiftsuspenders.support.injectees.OptionalClassInjectee = $hxClasses["org.swiftsuspenders.support.injectees.OptionalClassInjectee"] = function() {
};
org.swiftsuspenders.support.injectees.OptionalClassInjectee.__name__ = ["org","swiftsuspenders","support","injectees","OptionalClassInjectee"];
org.swiftsuspenders.support.injectees.OptionalClassInjectee.prototype = {
	property: null
	,__class__: org.swiftsuspenders.support.injectees.OptionalClassInjectee
}
org.swiftsuspenders.support.injectees.OptionalOneRequiredParameterMethodInjectee = $hxClasses["org.swiftsuspenders.support.injectees.OptionalOneRequiredParameterMethodInjectee"] = function() {
};
org.swiftsuspenders.support.injectees.OptionalOneRequiredParameterMethodInjectee.__name__ = ["org","swiftsuspenders","support","injectees","OptionalOneRequiredParameterMethodInjectee"];
org.swiftsuspenders.support.injectees.OptionalOneRequiredParameterMethodInjectee.prototype = {
	m_dependency: null
	,setDependency: function(dependency) {
		this.m_dependency = dependency;
	}
	,getDependency: function() {
		return this.m_dependency;
	}
	,__class__: org.swiftsuspenders.support.injectees.OptionalOneRequiredParameterMethodInjectee
}
org.swiftsuspenders.support.injectees.OrderedPostConstructInjectee = $hxClasses["org.swiftsuspenders.support.injectees.OrderedPostConstructInjectee"] = function() {
	this.loadOrder = [];
};
org.swiftsuspenders.support.injectees.OrderedPostConstructInjectee.__name__ = ["org","swiftsuspenders","support","injectees","OrderedPostConstructInjectee"];
org.swiftsuspenders.support.injectees.OrderedPostConstructInjectee.prototype = {
	loadOrder: null
	,methodTwo: function() {
		this.loadOrder.push(2);
	}
	,methodFour: function() {
		this.loadOrder.push(4);
	}
	,methodThree: function() {
		this.loadOrder.push(3);
	}
	,methodOne: function() {
		this.loadOrder.push(1);
	}
	,__class__: org.swiftsuspenders.support.injectees.OrderedPostConstructInjectee
}
org.swiftsuspenders.support.injectees.PostConstructWithArgInjectee = $hxClasses["org.swiftsuspenders.support.injectees.PostConstructWithArgInjectee"] = function() {
};
org.swiftsuspenders.support.injectees.PostConstructWithArgInjectee.__name__ = ["org","swiftsuspenders","support","injectees","PostConstructWithArgInjectee"];
org.swiftsuspenders.support.injectees.PostConstructWithArgInjectee.prototype = {
	property: null
	,doSomeStuff: function(arg) {
		this.property = arg;
	}
	,__class__: org.swiftsuspenders.support.injectees.PostConstructWithArgInjectee
}
if(!org.swiftsuspenders.support.types) org.swiftsuspenders.support.types = {}
org.swiftsuspenders.support.types.Interface = $hxClasses["org.swiftsuspenders.support.types.Interface"] = function() { }
org.swiftsuspenders.support.types.Interface.__name__ = ["org","swiftsuspenders","support","types","Interface"];
org.swiftsuspenders.support.types.Interface.prototype = {
	__class__: org.swiftsuspenders.support.types.Interface
}
org.swiftsuspenders.support.injectees.RecursiveInterfaceInjectee = $hxClasses["org.swiftsuspenders.support.injectees.RecursiveInterfaceInjectee"] = function() {
};
org.swiftsuspenders.support.injectees.RecursiveInterfaceInjectee.__name__ = ["org","swiftsuspenders","support","injectees","RecursiveInterfaceInjectee"];
org.swiftsuspenders.support.injectees.RecursiveInterfaceInjectee.__interfaces__ = [org.swiftsuspenders.support.types.Interface];
org.swiftsuspenders.support.injectees.RecursiveInterfaceInjectee.prototype = {
	interfaceInjectee: null
	,__class__: org.swiftsuspenders.support.injectees.RecursiveInterfaceInjectee
}
org.swiftsuspenders.support.injectees.SetterInjectee = $hxClasses["org.swiftsuspenders.support.injectees.SetterInjectee"] = function() {
};
org.swiftsuspenders.support.injectees.SetterInjectee.__name__ = ["org","swiftsuspenders","support","injectees","SetterInjectee"];
org.swiftsuspenders.support.injectees.SetterInjectee.prototype = {
	property: null
	,m_property: null
	,setProperty: function(value) {
		this.m_property = value;
		return value;
	}
	,getProperty: function() {
		return this.m_property;
	}
	,__class__: org.swiftsuspenders.support.injectees.SetterInjectee
	,__properties__: {set_property:"setProperty",get_property:"getProperty"}
}
org.swiftsuspenders.support.injectees.StringInjectee = $hxClasses["org.swiftsuspenders.support.injectees.StringInjectee"] = function() {
};
org.swiftsuspenders.support.injectees.StringInjectee.__name__ = ["org","swiftsuspenders","support","injectees","StringInjectee"];
org.swiftsuspenders.support.injectees.StringInjectee.prototype = {
	property: null
	,__class__: org.swiftsuspenders.support.injectees.StringInjectee
}
org.swiftsuspenders.support.injectees.TwoNamedInterfaceFieldsInjectee = $hxClasses["org.swiftsuspenders.support.injectees.TwoNamedInterfaceFieldsInjectee"] = function() {
};
org.swiftsuspenders.support.injectees.TwoNamedInterfaceFieldsInjectee.__name__ = ["org","swiftsuspenders","support","injectees","TwoNamedInterfaceFieldsInjectee"];
org.swiftsuspenders.support.injectees.TwoNamedInterfaceFieldsInjectee.prototype = {
	property1: null
	,property2: null
	,__class__: org.swiftsuspenders.support.injectees.TwoNamedInterfaceFieldsInjectee
}
org.swiftsuspenders.support.injectees.TwoNamedParametersConstructorInjectee = $hxClasses["org.swiftsuspenders.support.injectees.TwoNamedParametersConstructorInjectee"] = function(dependency,dependency2) {
	this.m_dependency = dependency;
	this.m_dependency2 = dependency2;
};
org.swiftsuspenders.support.injectees.TwoNamedParametersConstructorInjectee.__name__ = ["org","swiftsuspenders","support","injectees","TwoNamedParametersConstructorInjectee"];
org.swiftsuspenders.support.injectees.TwoNamedParametersConstructorInjectee.prototype = {
	m_dependency: null
	,m_dependency2: null
	,getDependency: function() {
		return this.m_dependency;
	}
	,getDependency2: function() {
		return this.m_dependency2;
	}
	,__class__: org.swiftsuspenders.support.injectees.TwoNamedParametersConstructorInjectee
}
org.swiftsuspenders.support.injectees.TwoNamedParametersMethodInjectee = $hxClasses["org.swiftsuspenders.support.injectees.TwoNamedParametersMethodInjectee"] = function() {
};
org.swiftsuspenders.support.injectees.TwoNamedParametersMethodInjectee.__name__ = ["org","swiftsuspenders","support","injectees","TwoNamedParametersMethodInjectee"];
org.swiftsuspenders.support.injectees.TwoNamedParametersMethodInjectee.prototype = {
	m_dependency: null
	,m_dependency2: null
	,setDependencies: function(dependency,dependency2) {
		this.m_dependency = dependency;
		this.m_dependency2 = dependency2;
	}
	,getDependency: function() {
		return this.m_dependency;
	}
	,getDependency2: function() {
		return this.m_dependency2;
	}
	,__class__: org.swiftsuspenders.support.injectees.TwoNamedParametersMethodInjectee
}
org.swiftsuspenders.support.injectees.TwoParametersConstructorInjectee = $hxClasses["org.swiftsuspenders.support.injectees.TwoParametersConstructorInjectee"] = function(dependency,dependency2) {
	this.m_dependency = dependency;
	this.m_dependency2 = dependency2;
};
org.swiftsuspenders.support.injectees.TwoParametersConstructorInjectee.__name__ = ["org","swiftsuspenders","support","injectees","TwoParametersConstructorInjectee"];
org.swiftsuspenders.support.injectees.TwoParametersConstructorInjectee.prototype = {
	m_dependency: null
	,m_dependency2: null
	,getDependency: function() {
		return this.m_dependency;
	}
	,getDependency2: function() {
		return this.m_dependency2;
	}
	,__class__: org.swiftsuspenders.support.injectees.TwoParametersConstructorInjectee
}
org.swiftsuspenders.support.injectees.TwoParametersMethodInjectee = $hxClasses["org.swiftsuspenders.support.injectees.TwoParametersMethodInjectee"] = function() {
};
org.swiftsuspenders.support.injectees.TwoParametersMethodInjectee.__name__ = ["org","swiftsuspenders","support","injectees","TwoParametersMethodInjectee"];
org.swiftsuspenders.support.injectees.TwoParametersMethodInjectee.prototype = {
	m_dependency: null
	,m_dependency2: null
	,setDependencies: function(dependency,dependency2) {
		this.m_dependency = dependency;
		this.m_dependency2 = dependency2;
	}
	,getDependency: function() {
		return this.m_dependency;
	}
	,getDependency2: function() {
		return this.m_dependency2;
	}
	,__class__: org.swiftsuspenders.support.injectees.TwoParametersMethodInjectee
}
org.swiftsuspenders.support.injectees.UnknownInjectParametersListInjectee = $hxClasses["org.swiftsuspenders.support.injectees.UnknownInjectParametersListInjectee"] = function() {
};
org.swiftsuspenders.support.injectees.UnknownInjectParametersListInjectee.__name__ = ["org","swiftsuspenders","support","injectees","UnknownInjectParametersListInjectee"];
org.swiftsuspenders.support.injectees.UnknownInjectParametersListInjectee.prototype = {
	property: null
	,__class__: org.swiftsuspenders.support.injectees.UnknownInjectParametersListInjectee
}
if(!org.swiftsuspenders.support.injectees.childinjectors) org.swiftsuspenders.support.injectees.childinjectors = {}
org.swiftsuspenders.support.injectees.childinjectors.ChildInjectorCreatingProvider = $hxClasses["org.swiftsuspenders.support.injectees.childinjectors.ChildInjectorCreatingProvider"] = function() {
};
org.swiftsuspenders.support.injectees.childinjectors.ChildInjectorCreatingProvider.__name__ = ["org","swiftsuspenders","support","injectees","childinjectors","ChildInjectorCreatingProvider"];
org.swiftsuspenders.support.injectees.childinjectors.ChildInjectorCreatingProvider.__interfaces__ = [org.swiftsuspenders.dependencyproviders.DependencyProvider];
org.swiftsuspenders.support.injectees.childinjectors.ChildInjectorCreatingProvider.prototype = {
	apply: function(targetType,activeInjector,injectParameters) {
		return activeInjector.createChildInjector();
	}
	,__class__: org.swiftsuspenders.support.injectees.childinjectors.ChildInjectorCreatingProvider
}
org.swiftsuspenders.support.injectees.childinjectors.InjectorInjectee = $hxClasses["org.swiftsuspenders.support.injectees.childinjectors.InjectorInjectee"] = function() {
};
org.swiftsuspenders.support.injectees.childinjectors.InjectorInjectee.__name__ = ["org","swiftsuspenders","support","injectees","childinjectors","InjectorInjectee"];
org.swiftsuspenders.support.injectees.childinjectors.InjectorInjectee.prototype = {
	injector: null
	,nestedInjectee: null
	,createAnotherChildInjector: function() {
		this.nestedInjectee = this.injector.getInstance(org.swiftsuspenders.support.injectees.childinjectors.NestedInjectorInjectee);
	}
	,__class__: org.swiftsuspenders.support.injectees.childinjectors.InjectorInjectee
}
org.swiftsuspenders.support.injectees.childinjectors.RobotFoot = $hxClasses["org.swiftsuspenders.support.injectees.childinjectors.RobotFoot"] = function(toes) {
	this.toes = toes;
};
org.swiftsuspenders.support.injectees.childinjectors.RobotFoot.__name__ = ["org","swiftsuspenders","support","injectees","childinjectors","RobotFoot"];
org.swiftsuspenders.support.injectees.childinjectors.RobotFoot.prototype = {
	toes: null
	,__class__: org.swiftsuspenders.support.injectees.childinjectors.RobotFoot
}
org.swiftsuspenders.support.injectees.childinjectors.LeftRobotFoot = $hxClasses["org.swiftsuspenders.support.injectees.childinjectors.LeftRobotFoot"] = function(toes) {
	org.swiftsuspenders.support.injectees.childinjectors.RobotFoot.call(this,toes);
};
org.swiftsuspenders.support.injectees.childinjectors.LeftRobotFoot.__name__ = ["org","swiftsuspenders","support","injectees","childinjectors","LeftRobotFoot"];
org.swiftsuspenders.support.injectees.childinjectors.LeftRobotFoot.__super__ = org.swiftsuspenders.support.injectees.childinjectors.RobotFoot;
org.swiftsuspenders.support.injectees.childinjectors.LeftRobotFoot.prototype = $extend(org.swiftsuspenders.support.injectees.childinjectors.RobotFoot.prototype,{
	__class__: org.swiftsuspenders.support.injectees.childinjectors.LeftRobotFoot
});
org.swiftsuspenders.support.injectees.childinjectors.NestedInjectorInjectee = $hxClasses["org.swiftsuspenders.support.injectees.childinjectors.NestedInjectorInjectee"] = function() {
};
org.swiftsuspenders.support.injectees.childinjectors.NestedInjectorInjectee.__name__ = ["org","swiftsuspenders","support","injectees","childinjectors","NestedInjectorInjectee"];
org.swiftsuspenders.support.injectees.childinjectors.NestedInjectorInjectee.prototype = {
	injector: null
	,nestedInjectee: null
	,createAnotherChildInjector: function() {
		this.nestedInjectee = this.injector.getInstance(org.swiftsuspenders.support.injectees.childinjectors.NestedNestedInjectorInjectee);
	}
	,__class__: org.swiftsuspenders.support.injectees.childinjectors.NestedInjectorInjectee
}
org.swiftsuspenders.support.injectees.childinjectors.NestedNestedInjectorInjectee = $hxClasses["org.swiftsuspenders.support.injectees.childinjectors.NestedNestedInjectorInjectee"] = function() {
};
org.swiftsuspenders.support.injectees.childinjectors.NestedNestedInjectorInjectee.__name__ = ["org","swiftsuspenders","support","injectees","childinjectors","NestedNestedInjectorInjectee"];
org.swiftsuspenders.support.injectees.childinjectors.NestedNestedInjectorInjectee.prototype = {
	injector: null
	,__class__: org.swiftsuspenders.support.injectees.childinjectors.NestedNestedInjectorInjectee
}
org.swiftsuspenders.support.injectees.childinjectors.RightRobotFoot = $hxClasses["org.swiftsuspenders.support.injectees.childinjectors.RightRobotFoot"] = function(toes) {
	org.swiftsuspenders.support.injectees.childinjectors.RobotFoot.call(this,toes);
};
org.swiftsuspenders.support.injectees.childinjectors.RightRobotFoot.__name__ = ["org","swiftsuspenders","support","injectees","childinjectors","RightRobotFoot"];
org.swiftsuspenders.support.injectees.childinjectors.RightRobotFoot.__super__ = org.swiftsuspenders.support.injectees.childinjectors.RobotFoot;
org.swiftsuspenders.support.injectees.childinjectors.RightRobotFoot.prototype = $extend(org.swiftsuspenders.support.injectees.childinjectors.RobotFoot.prototype,{
	__class__: org.swiftsuspenders.support.injectees.childinjectors.RightRobotFoot
});
org.swiftsuspenders.support.injectees.childinjectors.RobotAnkle = $hxClasses["org.swiftsuspenders.support.injectees.childinjectors.RobotAnkle"] = function() {
};
org.swiftsuspenders.support.injectees.childinjectors.RobotAnkle.__name__ = ["org","swiftsuspenders","support","injectees","childinjectors","RobotAnkle"];
org.swiftsuspenders.support.injectees.childinjectors.RobotAnkle.prototype = {
	foot: null
	,__class__: org.swiftsuspenders.support.injectees.childinjectors.RobotAnkle
}
org.swiftsuspenders.support.injectees.childinjectors.RobotBody = $hxClasses["org.swiftsuspenders.support.injectees.childinjectors.RobotBody"] = function() {
};
org.swiftsuspenders.support.injectees.childinjectors.RobotBody.__name__ = ["org","swiftsuspenders","support","injectees","childinjectors","RobotBody"];
org.swiftsuspenders.support.injectees.childinjectors.RobotBody.prototype = {
	leftLeg: null
	,rightLeg: null
	,__class__: org.swiftsuspenders.support.injectees.childinjectors.RobotBody
}
org.swiftsuspenders.support.injectees.childinjectors.RobotLeg = $hxClasses["org.swiftsuspenders.support.injectees.childinjectors.RobotLeg"] = function() {
};
org.swiftsuspenders.support.injectees.childinjectors.RobotLeg.__name__ = ["org","swiftsuspenders","support","injectees","childinjectors","RobotLeg"];
org.swiftsuspenders.support.injectees.childinjectors.RobotLeg.prototype = {
	ankle: null
	,__class__: org.swiftsuspenders.support.injectees.childinjectors.RobotLeg
}
org.swiftsuspenders.support.injectees.childinjectors.RobotToes = $hxClasses["org.swiftsuspenders.support.injectees.childinjectors.RobotToes"] = function() {
};
org.swiftsuspenders.support.injectees.childinjectors.RobotToes.__name__ = ["org","swiftsuspenders","support","injectees","childinjectors","RobotToes"];
org.swiftsuspenders.support.injectees.childinjectors.RobotToes.prototype = {
	__class__: org.swiftsuspenders.support.injectees.childinjectors.RobotToes
}
if(!org.swiftsuspenders.support.providers) org.swiftsuspenders.support.providers = {}
org.swiftsuspenders.support.providers.ClassNameStoringProvider = $hxClasses["org.swiftsuspenders.support.providers.ClassNameStoringProvider"] = function() {
};
org.swiftsuspenders.support.providers.ClassNameStoringProvider.__name__ = ["org","swiftsuspenders","support","providers","ClassNameStoringProvider"];
org.swiftsuspenders.support.providers.ClassNameStoringProvider.__interfaces__ = [org.swiftsuspenders.dependencyproviders.DependencyProvider];
org.swiftsuspenders.support.providers.ClassNameStoringProvider.prototype = {
	lastTargetClassName: null
	,apply: function(targetType,activeInjector,injectParameters) {
		this.lastTargetClassName = Type.getClassName(targetType);
		return new org.swiftsuspenders.support.types.Clazz();
	}
	,__class__: org.swiftsuspenders.support.providers.ClassNameStoringProvider
}
org.swiftsuspenders.support.types.Interface2 = $hxClasses["org.swiftsuspenders.support.types.Interface2"] = function() { }
org.swiftsuspenders.support.types.Interface2.__name__ = ["org","swiftsuspenders","support","types","Interface2"];
org.swiftsuspenders.support.types.Interface2.prototype = {
	__class__: org.swiftsuspenders.support.types.Interface2
}
org.swiftsuspenders.support.types.Clazz = $hxClasses["org.swiftsuspenders.support.types.Clazz"] = function() {
};
org.swiftsuspenders.support.types.Clazz.__name__ = ["org","swiftsuspenders","support","types","Clazz"];
org.swiftsuspenders.support.types.Clazz.__interfaces__ = [org.swiftsuspenders.support.types.Interface2,org.swiftsuspenders.support.types.Interface];
org.swiftsuspenders.support.types.Clazz.prototype = {
	__class__: org.swiftsuspenders.support.types.Clazz
}
org.swiftsuspenders.support.types.Clazz2 = $hxClasses["org.swiftsuspenders.support.types.Clazz2"] = function() {
};
org.swiftsuspenders.support.types.Clazz2.__name__ = ["org","swiftsuspenders","support","types","Clazz2"];
org.swiftsuspenders.support.types.Clazz2.__interfaces__ = [org.swiftsuspenders.support.types.Interface2,org.swiftsuspenders.support.types.Interface];
org.swiftsuspenders.support.types.Clazz2.prototype = {
	__class__: org.swiftsuspenders.support.types.Clazz2
}
org.swiftsuspenders.support.types.ClazzExtension = $hxClasses["org.swiftsuspenders.support.types.ClazzExtension"] = function() {
	org.swiftsuspenders.support.types.Clazz.call(this);
};
org.swiftsuspenders.support.types.ClazzExtension.__name__ = ["org","swiftsuspenders","support","types","ClazzExtension"];
org.swiftsuspenders.support.types.ClazzExtension.__super__ = org.swiftsuspenders.support.types.Clazz;
org.swiftsuspenders.support.types.ClazzExtension.prototype = $extend(org.swiftsuspenders.support.types.Clazz.prototype,{
	__class__: org.swiftsuspenders.support.types.ClazzExtension
});
org.swiftsuspenders.support.types.ComplexInterface = $hxClasses["org.swiftsuspenders.support.types.ComplexInterface"] = function() { }
org.swiftsuspenders.support.types.ComplexInterface.__name__ = ["org","swiftsuspenders","support","types","ComplexInterface"];
org.swiftsuspenders.support.types.ComplexInterface.prototype = {
	__class__: org.swiftsuspenders.support.types.ComplexInterface
}
org.swiftsuspenders.support.types.ComplexClazz = $hxClasses["org.swiftsuspenders.support.types.ComplexClazz"] = function() {
};
org.swiftsuspenders.support.types.ComplexClazz.__name__ = ["org","swiftsuspenders","support","types","ComplexClazz"];
org.swiftsuspenders.support.types.ComplexClazz.__interfaces__ = [org.swiftsuspenders.support.types.ComplexInterface];
org.swiftsuspenders.support.types.ComplexClazz.prototype = {
	value: null
	,__class__: org.swiftsuspenders.support.types.ComplexClazz
}
if(!org.swiftsuspenders.typedescriptions) org.swiftsuspenders.typedescriptions = {}
org.swiftsuspenders.typedescriptions.InjectionPoint = $hxClasses["org.swiftsuspenders.typedescriptions.InjectionPoint"] = function() {
};
org.swiftsuspenders.typedescriptions.InjectionPoint.__name__ = ["org","swiftsuspenders","typedescriptions","InjectionPoint"];
org.swiftsuspenders.typedescriptions.InjectionPoint.prototype = {
	next: null
	,last: null
	,injectParameters: null
	,applyInjection: function(target,targetType,injector) {
	}
	,__class__: org.swiftsuspenders.typedescriptions.InjectionPoint
}
org.swiftsuspenders.typedescriptions.MethodInjectionPoint = $hxClasses["org.swiftsuspenders.typedescriptions.MethodInjectionPoint"] = function(methodName,parameters,requiredParameters,isOptional,injectParameters) {
	this._methodName = methodName;
	this._parameterMappingIDs = parameters;
	this._requiredParameters = requiredParameters;
	this._isOptional = isOptional;
	this.injectParameters = injectParameters;
	org.swiftsuspenders.typedescriptions.InjectionPoint.call(this);
};
org.swiftsuspenders.typedescriptions.MethodInjectionPoint.__name__ = ["org","swiftsuspenders","typedescriptions","MethodInjectionPoint"];
org.swiftsuspenders.typedescriptions.MethodInjectionPoint.__super__ = org.swiftsuspenders.typedescriptions.InjectionPoint;
org.swiftsuspenders.typedescriptions.MethodInjectionPoint.prototype = $extend(org.swiftsuspenders.typedescriptions.InjectionPoint.prototype,{
	_parameterMappingIDs: null
	,_requiredParameters: null
	,_isOptional: null
	,_methodName: null
	,applyInjection: function(target,targetType,injector) {
		var parameters = this.gatherParameterValues(target,targetType,injector);
		var method = Reflect.field(target,this._methodName);
		Reflect.callMethod(target,method,parameters);
	}
	,gatherParameterValues: function(target,targetType,injector) {
		var parameters = [];
		var length = this._parameterMappingIDs.length;
		var _g = 0;
		while(_g < length) {
			var i = _g++;
			var parameterMappingId = this._parameterMappingIDs[i];
			var provider = injector.getProvider(parameterMappingId);
			if(provider == null) {
				if(i >= this._requiredParameters || this._isOptional) break;
				throw new org.swiftsuspenders.InjectorError("Injector is missing a rule to handle injection into target " + Type.getClassName(target) + ". Target dependency: " + Type.getClassName(targetType) + "\" Target dependency: " + parameterMappingId + ", method: " + this._methodName + ", parameter: " + (i + 1));
			}
			parameters[i] = provider.apply(targetType,injector,this.injectParameters);
		}
		return parameters;
	}
	,__class__: org.swiftsuspenders.typedescriptions.MethodInjectionPoint
});
org.swiftsuspenders.typedescriptions.ConstructorInjectionPoint = $hxClasses["org.swiftsuspenders.typedescriptions.ConstructorInjectionPoint"] = function(parameters,requiredParameters,injectParameters) {
	org.swiftsuspenders.typedescriptions.MethodInjectionPoint.call(this,"ctor",parameters,requiredParameters,false,injectParameters);
};
org.swiftsuspenders.typedescriptions.ConstructorInjectionPoint.__name__ = ["org","swiftsuspenders","typedescriptions","ConstructorInjectionPoint"];
org.swiftsuspenders.typedescriptions.ConstructorInjectionPoint.__super__ = org.swiftsuspenders.typedescriptions.MethodInjectionPoint;
org.swiftsuspenders.typedescriptions.ConstructorInjectionPoint.prototype = $extend(org.swiftsuspenders.typedescriptions.MethodInjectionPoint.prototype,{
	createInstance: function(type,injector) {
		var p = this.gatherParameterValues(type,type,injector);
		var result = null;
		var _sw0_ = p.length;
		switch(_sw0_) {
		case 1:
			result = Type.createInstance(type,[p[0]]);
			break;
		case 2:
			result = Type.createInstance(type,[p[0],p[1]]);
			break;
		case 3:
			result = Type.createInstance(type,[p[0],p[1],p[2]]);
			break;
		case 4:
			result = Type.createInstance(type,[p[0],p[1],p[2],p[3]]);
			break;
		case 5:
			result = Type.createInstance(type,[p[0],p[1],p[2],p[3],p[4]]);
			break;
		case 6:
			result = Type.createInstance(type,[p[0],p[1],p[2],p[3],p[4],p[5]]);
			break;
		case 7:
			result = Type.createInstance(type,[p[0],p[1],p[2],p[3],p[4],p[5],p[6]]);
			break;
		case 8:
			result = Type.createInstance(type,[p[0],p[1],p[2],p[3],p[4],p[5],p[6],p[7]]);
			break;
		case 9:
			result = Type.createInstance(type,[p[0],p[1],p[2],p[3],p[4],p[5],p[6],p[7],p[8]]);
			break;
		case 10:
			result = Type.createInstance(type,[p[0],p[1],p[2],p[3],p[4],p[5],p[6],p[7],p[8],p[9]]);
			break;
		}
		return result;
	}
	,__class__: org.swiftsuspenders.typedescriptions.ConstructorInjectionPoint
});
org.swiftsuspenders.typedescriptions.NoParamsConstructorInjectionPoint = $hxClasses["org.swiftsuspenders.typedescriptions.NoParamsConstructorInjectionPoint"] = function() {
	org.swiftsuspenders.typedescriptions.ConstructorInjectionPoint.call(this,[],0,this.injectParameters);
};
org.swiftsuspenders.typedescriptions.NoParamsConstructorInjectionPoint.__name__ = ["org","swiftsuspenders","typedescriptions","NoParamsConstructorInjectionPoint"];
org.swiftsuspenders.typedescriptions.NoParamsConstructorInjectionPoint.__super__ = org.swiftsuspenders.typedescriptions.ConstructorInjectionPoint;
org.swiftsuspenders.typedescriptions.NoParamsConstructorInjectionPoint.prototype = $extend(org.swiftsuspenders.typedescriptions.ConstructorInjectionPoint.prototype,{
	createInstance: function(type,injector) {
		return Type.createInstance(type,[]);
	}
	,__class__: org.swiftsuspenders.typedescriptions.NoParamsConstructorInjectionPoint
});
org.swiftsuspenders.typedescriptions.OrderedInjectionPoint = $hxClasses["org.swiftsuspenders.typedescriptions.OrderedInjectionPoint"] = function(methodName,parameters,requiredParameters,order) {
	org.swiftsuspenders.typedescriptions.MethodInjectionPoint.call(this,methodName,parameters,requiredParameters,false,null);
	this.order = order;
};
org.swiftsuspenders.typedescriptions.OrderedInjectionPoint.__name__ = ["org","swiftsuspenders","typedescriptions","OrderedInjectionPoint"];
org.swiftsuspenders.typedescriptions.OrderedInjectionPoint.__super__ = org.swiftsuspenders.typedescriptions.MethodInjectionPoint;
org.swiftsuspenders.typedescriptions.OrderedInjectionPoint.prototype = $extend(org.swiftsuspenders.typedescriptions.MethodInjectionPoint.prototype,{
	order: null
	,__class__: org.swiftsuspenders.typedescriptions.OrderedInjectionPoint
});
org.swiftsuspenders.typedescriptions.PostConstructInjectionPoint = $hxClasses["org.swiftsuspenders.typedescriptions.PostConstructInjectionPoint"] = function(methodName,parameters,requiredParameters,order) {
	org.swiftsuspenders.typedescriptions.OrderedInjectionPoint.call(this,methodName,parameters,requiredParameters,order);
};
org.swiftsuspenders.typedescriptions.PostConstructInjectionPoint.__name__ = ["org","swiftsuspenders","typedescriptions","PostConstructInjectionPoint"];
org.swiftsuspenders.typedescriptions.PostConstructInjectionPoint.__super__ = org.swiftsuspenders.typedescriptions.OrderedInjectionPoint;
org.swiftsuspenders.typedescriptions.PostConstructInjectionPoint.prototype = $extend(org.swiftsuspenders.typedescriptions.OrderedInjectionPoint.prototype,{
	__class__: org.swiftsuspenders.typedescriptions.PostConstructInjectionPoint
});
org.swiftsuspenders.typedescriptions.PreDestroyInjectionPoint = $hxClasses["org.swiftsuspenders.typedescriptions.PreDestroyInjectionPoint"] = function(methodName,parameters,requiredParameters,order) {
	org.swiftsuspenders.typedescriptions.OrderedInjectionPoint.call(this,methodName,parameters,requiredParameters,order);
};
org.swiftsuspenders.typedescriptions.PreDestroyInjectionPoint.__name__ = ["org","swiftsuspenders","typedescriptions","PreDestroyInjectionPoint"];
org.swiftsuspenders.typedescriptions.PreDestroyInjectionPoint.__super__ = org.swiftsuspenders.typedescriptions.OrderedInjectionPoint;
org.swiftsuspenders.typedescriptions.PreDestroyInjectionPoint.prototype = $extend(org.swiftsuspenders.typedescriptions.OrderedInjectionPoint.prototype,{
	__class__: org.swiftsuspenders.typedescriptions.PreDestroyInjectionPoint
});
org.swiftsuspenders.typedescriptions.PropertyInjectionPoint = $hxClasses["org.swiftsuspenders.typedescriptions.PropertyInjectionPoint"] = function(mappingId,propertyName,optional,injectParameters) {
	this._propertyName = propertyName;
	this._mappingId = mappingId;
	this._optional = optional;
	this.injectParameters = injectParameters;
	org.swiftsuspenders.typedescriptions.InjectionPoint.call(this);
};
org.swiftsuspenders.typedescriptions.PropertyInjectionPoint.__name__ = ["org","swiftsuspenders","typedescriptions","PropertyInjectionPoint"];
org.swiftsuspenders.typedescriptions.PropertyInjectionPoint.__super__ = org.swiftsuspenders.typedescriptions.InjectionPoint;
org.swiftsuspenders.typedescriptions.PropertyInjectionPoint.prototype = $extend(org.swiftsuspenders.typedescriptions.InjectionPoint.prototype,{
	_propertyName: null
	,_mappingId: null
	,_optional: null
	,applyInjection: function(target,targetType,injector) {
		var provider = injector.getProvider(this._mappingId);
		if(provider == null) {
			if(this._optional) return;
			throw new org.swiftsuspenders.InjectorError("Injector is missing a mapping to handle injection into property \"" + this._propertyName + "\" of object \"" + target + "\" with type \"" + targetType + "\". Target dependency: \"" + this._mappingId + "\"");
		}
		Reflect.setField(target,this._propertyName,provider.apply(targetType,injector,this.injectParameters));
	}
	,__class__: org.swiftsuspenders.typedescriptions.PropertyInjectionPoint
});
org.swiftsuspenders.typedescriptions.TypeDescription = $hxClasses["org.swiftsuspenders.typedescriptions.TypeDescription"] = function(useDefaultConstructor) {
	if(useDefaultConstructor == null) useDefaultConstructor = true;
	if(useDefaultConstructor) this.ctor = new org.swiftsuspenders.typedescriptions.NoParamsConstructorInjectionPoint();
};
org.swiftsuspenders.typedescriptions.TypeDescription.__name__ = ["org","swiftsuspenders","typedescriptions","TypeDescription"];
org.swiftsuspenders.typedescriptions.TypeDescription.prototype = {
	ctor: null
	,injectionPoints: null
	,preDestroyMethods: null
	,_postConstructAdded: null
	,setConstructor: function(parameterTypes,parameterNames,requiredParameters,metadata) {
		if(requiredParameters == null) requiredParameters = 999999999;
		if(parameterNames == null) parameterNames = [];
		this.ctor = new org.swiftsuspenders.typedescriptions.ConstructorInjectionPoint(this.createParameterMappings(parameterTypes,parameterNames),requiredParameters,metadata);
		return this;
	}
	,addFieldInjection: function(fieldName,type,injectionName,optional,metadata) {
		if(optional == null) optional = false;
		if(injectionName == null) injectionName = "";
		if(this._postConstructAdded) throw new org.swiftsuspenders.InjectorError("Can't add injection point after post construct method");
		this.addInjectionPoint(new org.swiftsuspenders.typedescriptions.PropertyInjectionPoint(Type.getClassName(type) + "|" + injectionName,fieldName,optional,metadata));
		return this;
	}
	,addMethodInjection: function(methodName,parameterTypes,parameterNames,requiredParameters,optional,metadata) {
		if(optional == null) optional = false;
		if(requiredParameters == null) requiredParameters = 999999999;
		if(this._postConstructAdded) throw new org.swiftsuspenders.InjectorError("Can't add injection point after post construct method");
		if(parameterNames == null) parameterNames = [];
		this.addInjectionPoint(new org.swiftsuspenders.typedescriptions.MethodInjectionPoint(methodName,this.createParameterMappings(parameterTypes,parameterNames),Std["int"](Math.min(requiredParameters,parameterTypes.length)),optional,metadata));
		return this;
	}
	,addPostConstructMethod: function(methodName,parameterTypes,parameterNames,requiredParameters) {
		if(requiredParameters == null) requiredParameters = 999999999;
		this._postConstructAdded = true;
		if(parameterNames == null) parameterNames = [];
		this.addInjectionPoint(new org.swiftsuspenders.typedescriptions.PostConstructInjectionPoint(methodName,this.createParameterMappings(parameterTypes,parameterNames),Std["int"](Math.min(requiredParameters,parameterTypes.length)),0));
		return this;
	}
	,addPreDestroyMethod: function(methodName,parameterTypes,parameterNames,requiredParameters) {
		if(requiredParameters == null) requiredParameters = 999999999;
		if(parameterNames == null) parameterNames = [];
		var method = new org.swiftsuspenders.typedescriptions.PreDestroyInjectionPoint(methodName,this.createParameterMappings(parameterTypes,parameterNames),Std["int"](Math.min(requiredParameters,parameterTypes.length)),0);
		if(this.preDestroyMethods != null) {
			this.preDestroyMethods.last.next = method;
			this.preDestroyMethods.last = method;
		} else {
			this.preDestroyMethods = method;
			this.preDestroyMethods.last = method;
		}
		return this;
	}
	,addInjectionPoint: function(injectionPoint) {
		if(this.injectionPoints != null) {
			this.injectionPoints.last.next = injectionPoint;
			this.injectionPoints.last = injectionPoint;
		} else {
			this.injectionPoints = injectionPoint;
			this.injectionPoints.last = injectionPoint;
		}
	}
	,createParameterMappings: function(parameterTypes,parameterNames) {
		var parameters = new Array();
		var i = parameters.length;
		while(i-- != 0) {
			var n = "";
			if(parameterNames[i] != null) n = parameterNames[i];
			parameters[i] = Type.getClassName(parameterTypes[i]) + "|" + n;
		}
		return parameters;
	}
	,__class__: org.swiftsuspenders.typedescriptions.TypeDescription
}
if(!org.swiftsuspenders.utils) org.swiftsuspenders.utils = {}
org.swiftsuspenders.utils.TypeDescriptor = $hxClasses["org.swiftsuspenders.utils.TypeDescriptor"] = function(reflector,descriptionsCache) {
	this._descriptionsCache = descriptionsCache;
	this._reflector = reflector;
};
org.swiftsuspenders.utils.TypeDescriptor.__name__ = ["org","swiftsuspenders","utils","TypeDescriptor"];
org.swiftsuspenders.utils.TypeDescriptor.prototype = {
	_descriptionsCache: null
	,_reflector: null
	,getDescription: function(type) {
		var f = this._descriptionsCache.get(Std.string(type));
		if(f == null) {
			f = this._reflector.describeInjections(type);
			this._descriptionsCache.set(Std.string(type),f);
		}
		return f;
	}
	,addDescription: function(type,description) {
		this._descriptionsCache.set(Std.string(type),description);
	}
	,__class__: org.swiftsuspenders.utils.TypeDescriptor
}
js.Boot.__res = {}
js.Boot.__init();
{
	Math.__name__ = ["Math"];
	Math.NaN = Number["NaN"];
	Math.NEGATIVE_INFINITY = Number["NEGATIVE_INFINITY"];
	Math.POSITIVE_INFINITY = Number["POSITIVE_INFINITY"];
	$hxClasses["Math"] = Math;
	Math.isFinite = function(i) {
		return isFinite(i);
	};
	Math.isNaN = function(i) {
		return isNaN(i);
	};
}
{
	String.prototype.__class__ = $hxClasses["String"] = String;
	String.__name__ = ["String"];
	Array.prototype.__class__ = $hxClasses["Array"] = Array;
	Array.__name__ = ["Array"];
	var Int = $hxClasses["Int"] = { __name__ : ["Int"]};
	var Dynamic = $hxClasses["Dynamic"] = { __name__ : ["Dynamic"]};
	var Float = $hxClasses["Float"] = Number;
	Float.__name__ = ["Float"];
	var Bool = $hxClasses["Bool"] = Boolean;
	Bool.__ename__ = ["Bool"];
	var Class = $hxClasses["Class"] = { __name__ : ["Class"]};
	var Enum = { };
	var Void = $hxClasses["Void"] = { __ename__ : ["Void"]};
}
{
	if(typeof document != "undefined") js.Lib.document = document;
	if(typeof window != "undefined") {
		js.Lib.window = window;
		js.Lib.window.onerror = function(msg,url,line) {
			var f = js.Lib.onerror;
			if(f == null) return false;
			return f(msg,[url + ":" + line]);
		};
	}
}
haxe.Public.__meta__ = { obj : { 'interface' : null}};
js.Lib.onerror = null;
org.swiftsuspenders.Reflector.__meta__ = { obj : { 'interface' : null}};
org.swiftsuspenders.Injector.INJECTION_POINTS_CACHE = new Hash();
org.swiftsuspenders.dependencyproviders.DependencyProvider.__meta__ = { obj : { 'interface' : null}};
org.swiftsuspenders.support.injectees.ClassInjectee.__meta__ = { fields : { property : { name : ["property"], type : ["org.swiftsuspenders.support.types.Clazz"], Inject : null}, doSomeStuff : { name : ["doSomeStuff"], args : null, PostConstruct : null}}};
org.swiftsuspenders.support.injectees.ComplexClassInjectee.__meta__ = { fields : { property : { name : ["property"], type : ["org.swiftsuspenders.support.types.ComplexClazz"], Inject : null}}};
org.swiftsuspenders.support.injectees.InterfaceInjectee.__meta__ = { fields : { property : { name : ["property"], type : ["org.swiftsuspenders.support.types.Interface"], Inject : null}}};
org.swiftsuspenders.support.injectees.MixedParametersConstructorInjectee.__meta__ = { fields : { _ : { name : ["new"], args : [{ type : "org.swiftsuspenders.support.types.Clazz", opt : false},{ type : "org.swiftsuspenders.support.types.Clazz", opt : false},{ type : "org.swiftsuspenders.support.types.Interface", opt : false}], Inject : ["namedDep","","namedDep2"]}}};
org.swiftsuspenders.support.injectees.MixedParametersMethodInjectee.__meta__ = { fields : { setDependencies : { name : ["setDependencies"], args : [{ type : "org.swiftsuspenders.support.types.Clazz", opt : false},{ type : "org.swiftsuspenders.support.types.Clazz", opt : false},{ type : "org.swiftsuspenders.support.types.Interface", opt : false}], Inject : ["namedDep","","namedDep2"]}}};
org.swiftsuspenders.support.injectees.MultipleNamedSingletonsOfSameClassInjectee.__meta__ = { fields : { property1 : { name : ["property1"], type : ["org.swiftsuspenders.support.types.Interface"], Inject : null}, property2 : { name : ["property2"], type : ["org.swiftsuspenders.support.types.Interface2"], Inject : null}, namedProperty2 : { name : ["namedProperty2"], type : ["org.swiftsuspenders.support.types.Interface2"], Inject : ["name2"]}}};
org.swiftsuspenders.support.injectees.MultipleSingletonsOfSameClassInjectee.__meta__ = { fields : { property1 : { name : ["property1"], type : ["org.swiftsuspenders.support.types.Interface"], Inject : null}, property2 : { name : ["property2"], type : ["org.swiftsuspenders.support.types.Interface2"], Inject : null}}};
org.swiftsuspenders.support.injectees.NamedClassInjectee.__meta__ = { fields : { property : { name : ["property"], type : ["org.swiftsuspenders.support.types.Clazz"], Inject : ["Name"]}}};
org.swiftsuspenders.support.injectees.NamedClassInjectee.NAME = "Name";
org.swiftsuspenders.support.injectees.NamedInterfaceInjectee.__meta__ = { fields : { property : { name : ["property"], type : ["org.swiftsuspenders.support.types.Interface"], Inject : ["Name"]}}};
org.swiftsuspenders.support.injectees.NamedInterfaceInjectee.NAME = "Name";
org.swiftsuspenders.support.injectees.OneNamedParameterConstructorInjectee.__meta__ = { fields : { _ : { name : ["new"], args : [{ type : "org.swiftsuspenders.support.types.Clazz", opt : false}], Inject : ["namedDependency"]}}};
org.swiftsuspenders.support.injectees.OneNamedParameterMethodInjectee.__meta__ = { fields : { setDependency : { name : ["setDependency"], args : [{ type : "org.swiftsuspenders.support.types.Clazz", opt : false}], Inject : ["namedDep"]}}};
org.swiftsuspenders.support.injectees.OneParameterConstructorInjectee.__meta__ = { fields : { _ : { name : ["new"], args : [{ type : "org.swiftsuspenders.support.types.Clazz", opt : false}], Inject : null}}};
org.swiftsuspenders.support.injectees.OneParameterMethodInjectee.__meta__ = { fields : { setDependency : { name : ["setDependency"], args : [{ type : "org.swiftsuspenders.support.types.Clazz", opt : false}], Inject : null}}};
org.swiftsuspenders.support.injectees.OptionalClassInjectee.__meta__ = { fields : { property : { OptionalInject : null}}};
org.swiftsuspenders.support.injectees.OptionalOneRequiredParameterMethodInjectee.__meta__ = { fields : { setDependency : { OptionalInject : null}}};
org.swiftsuspenders.support.injectees.OrderedPostConstructInjectee.__meta__ = { fields : { methodFour : { name : ["methodFour"], args : null, PostConstruct : null}}};
org.swiftsuspenders.support.injectees.PostConstructWithArgInjectee.__meta__ = { fields : { doSomeStuff : { name : ["doSomeStuff"], args : [{ type : "org.swiftsuspenders.support.types.Clazz", opt : false}], PostConstruct : null}}};
org.swiftsuspenders.support.types.Interface.__meta__ = { obj : { 'interface' : null}};
org.swiftsuspenders.support.injectees.SetterInjectee.__meta__ = { fields : { setProperty : { name : ["setProperty"], args : [{ type : "org.swiftsuspenders.support.types.Clazz", opt : false}], Inject : null}}};
org.swiftsuspenders.support.injectees.TwoNamedInterfaceFieldsInjectee.__meta__ = { fields : { property1 : { name : ["property1"], type : ["org.swiftsuspenders.support.types.Interface"], Inject : ["Name1"]}, property2 : { name : ["property2"], type : ["org.swiftsuspenders.support.types.Interface"], Inject : ["Name2"]}}};
org.swiftsuspenders.support.injectees.TwoNamedParametersConstructorInjectee.__meta__ = { fields : { _ : { name : ["new"], args : [{ type : "org.swiftsuspenders.support.types.Clazz", opt : false},{ type : "String", opt : false}], Inject : ["namedDependency","namedDependency2"]}}};
org.swiftsuspenders.support.injectees.TwoNamedParametersMethodInjectee.__meta__ = { fields : { setDependencies : { name : ["setDependencies"], args : [{ type : "org.swiftsuspenders.support.types.Clazz", opt : false},{ type : "org.swiftsuspenders.support.types.Interface", opt : false}], Inject : ["namedDep","namedDep2"]}}};
org.swiftsuspenders.support.injectees.TwoParametersConstructorInjectee.__meta__ = { fields : { _ : { name : ["new"], args : [{ type : "org.swiftsuspenders.support.types.Clazz", opt : false},{ type : "String", opt : false}], Inject : null}}};
org.swiftsuspenders.support.injectees.TwoParametersMethodInjectee.__meta__ = { fields : { setDependencies : { name : ["setDependencies"], args : [{ type : "org.swiftsuspenders.support.types.Clazz", opt : false},{ type : "org.swiftsuspenders.support.types.Interface", opt : false}], Inject : null}}};
org.swiftsuspenders.support.injectees.UnknownInjectParametersListInjectee.__meta__ = { fields : { property : { name : ["property"], type : ["org.swiftsuspenders.support.types.Clazz"], Inject : [{ param : true, param : "str", param : 123}]}}};
org.swiftsuspenders.support.injectees.childinjectors.InjectorInjectee.__meta__ = { fields : { injector : { name : ["injector"], type : ["org.swiftsuspenders.Injector"], Inject : null}, createAnotherChildInjector : { name : ["createAnotherChildInjector"], args : null, PostConstruct : null}}};
org.swiftsuspenders.support.injectees.childinjectors.RobotFoot.__meta__ = { fields : { _ : { name : ["new"], args : [{ type : "org.swiftsuspenders.support.injectees.childinjectors.RobotToes", opt : true}], Inject : null}}};
org.swiftsuspenders.support.injectees.childinjectors.LeftRobotFoot.__meta__ = { fields : { _ : { name : ["new"], args : [{ type : "org.swiftsuspenders.support.injectees.childinjectors.RobotToes", opt : true}], Inject : null}}};
org.swiftsuspenders.support.injectees.childinjectors.NestedInjectorInjectee.__meta__ = { fields : { injector : { name : ["injector"], type : ["org.swiftsuspenders.Injector"], Inject : null}, createAnotherChildInjector : { name : ["createAnotherChildInjector"], args : null, PostConstruct : null}}};
org.swiftsuspenders.support.injectees.childinjectors.NestedNestedInjectorInjectee.__meta__ = { fields : { injector : { name : ["injector"], type : ["org.swiftsuspenders.Injector"], Inject : null}}};
org.swiftsuspenders.support.injectees.childinjectors.RightRobotFoot.__meta__ = { fields : { _ : { name : ["new"], args : [{ type : "org.swiftsuspenders.support.injectees.childinjectors.RobotToes", opt : true}], Inject : null}}};
org.swiftsuspenders.support.injectees.childinjectors.RobotAnkle.__meta__ = { fields : { foot : { name : ["foot"], type : ["org.swiftsuspenders.support.injectees.childinjectors.RobotFoot"], Inject : null}}};
org.swiftsuspenders.support.injectees.childinjectors.RobotBody.__meta__ = { fields : { leftLeg : { name : ["leftLeg"], type : ["org.swiftsuspenders.support.injectees.childinjectors.RobotLeg"], Inject : ["leftLeg"]}, rightLeg : { name : ["rightLeg"], type : ["org.swiftsuspenders.support.injectees.childinjectors.RobotLeg"], Inject : ["rightLeg"]}}};
org.swiftsuspenders.support.injectees.childinjectors.RobotLeg.__meta__ = { fields : { ankle : { name : ["ankle"], type : ["org.swiftsuspenders.support.injectees.childinjectors.RobotAnkle"], Inject : null}}};
org.swiftsuspenders.support.types.Interface2.__meta__ = { obj : { 'interface' : null}};
org.swiftsuspenders.support.types.ComplexInterface.__meta__ = { obj : { 'interface' : null}};
org.swiftsuspenders.support.types.ComplexClazz.__meta__ = { fields : { value : { name : ["value"], type : ["org.swiftsuspenders.support.types.Clazz"], Inject : null}}};
org.swiftsuspenders.typedescriptions.MethodInjectionPoint._parameterValues = [];
org.swiftsuspenders.typedescriptions.TypeDescription.MAX_INT = 999999999;
Main.main()
//@ sourceMappingURL=test.js.map