require("/implementations/foo");

var FooFailingSpec = new Object();
FooFailingSpec.name = "Foo Failing Spec";
Spec.register(FooFailingSpec);

FooFailingSpec.describe("A failing spec in foo", {
	'fails': function() {
		value_of(Foo.value).should_be(false);
	}
})
