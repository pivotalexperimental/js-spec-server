require("/implementations/foo");

var FooPassingSpec = new Object();
FooPassingSpec.name = "Foo Passing Spec";
Spec.register(FooPassingSpec);

FooPassingSpec.describe("A passing spec", {
	'passes': function() {
		value_of(Foo.value).should_be(true);
	}
})
